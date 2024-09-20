
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Attributes Generic",
		desc      = "Handles UnitRulesParam attributes in a generic way.",
		author    = "GoogleFrog", -- v1 CarReparier & GoogleFrog
		date      = "2018-11-30", -- v1 2009-11-27
		license   = "GNU GPL, v2 or later",
		layer     = -1,
		enabled   = true,
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local UPDATE_PERIOD = 3

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local floor = math.floor

local spValidUnitID            = Spring.ValidUnitID
local spGetUnitDefID           = Spring.GetUnitDefID
local spGetGameFrame           = Spring.GetGameFrame
local spSetUnitRulesParam      = Spring.SetUnitRulesParam

local spSetUnitBuildSpeed      = Spring.SetUnitBuildSpeed
local spSetUnitWeaponState     = Spring.SetUnitWeaponState
local spGetUnitWeaponState     = Spring.GetUnitWeaponState
local spSetUnitWeaponDamages   = Spring.SetUnitWeaponDamages

local spGetUnitMoveTypeData    = Spring.GetUnitMoveTypeData
local spMoveCtrlGetTag         = Spring.MoveCtrl.GetTag
local spSetAirMoveTypeData     = Spring.MoveCtrl.SetAirMoveTypeData
local spSetGunshipMoveTypeData = Spring.MoveCtrl.SetGunshipMoveTypeData
local spSetGroundMoveTypeData  = Spring.MoveCtrl.SetGroundMoveTypeData

local ALLY_ACCESS = {allied = true}
local INLOS_ACCESS = {inlos = true}

local getMovetype = Spring.Utilities.getMovetype

local IterableMap = VFS.Include("LuaRules/Gadgets/Include/IterableMap.lua")

local DO_CHANGES_EXTERNALLY = true
local HALF_FRAME = 1 / (2 * Game.gameSpeed)

local function GetMass(health, cost)
	return (((cost/2) + (health/8))^0.6)*6.5
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Sensor Handling

local origUnitSight = {}

local function UpdateSensorAndJamm(unitID, unitDefID, multiplier)
	if not UnitDefs[unitDefID] then
		return
	end
	if not origUnitSight[unitDefID] then
		local ud = UnitDefs[unitDefID]
		origUnitSight[unitDefID] = {
			radar = (ud.radarDistance > 0) and ud.radarDistance,
			sonar = (ud.sonarDistance > 0) and ud.sonarDistance,
			jammer = (ud.radarDistanceJam > 0) and ud.radarDistanceJam,
			los = (ud.sightDistance > 0) and ud.sightDistance,
			airLos = (ud.airSightDistance > 0) and ud.airSightDistance,
		}
	end
	local orig = origUnitSight[unitDefID]
	
	if DO_CHANGES_EXTERNALLY then
		if orig.radar then
			Spring.SetUnitRulesParam(unitID, "radarRangeOverride", orig.radar*multiplier)
		end
		if orig.sonar then
			Spring.SetUnitRulesParam(unitID, "sonarRangeOverride", orig.sonar*multiplier)
		end
		if orig.jammer then
			Spring.SetUnitRulesParam(unitID, "jammingRangeOverride", orig.jammer*multiplier)
		end
		if orig.los then
			Spring.SetUnitRulesParam(unitID, "sightRangeOverride", orig.los*multiplier)
		end
		return
	end
	
	if orig.radar then
		Spring.SetUnitSensorRadius(unitID, "radar", orig.radar*multiplier)
	end
	if orig.sonar then
		Spring.SetUnitSensorRadius(unitID, "sonar", orig.sonar*multiplier)
	end
	if orig.jammer then
		Spring.SetUnitSensorRadius(unitID, "radarJammer", orig.jammer*multiplier)
	end
	if orig.los then
		Spring.SetUnitSensorRadius(unitID, "los", orig.los*multiplier)
	end
	if orig.airLos then
		Spring.SetUnitSensorRadius(unitID, "airLos", orig.airLos*multiplier)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Build Speed Handling

local origUnitBuildSpeed = {}

local function UpdateEconRate(unitID, unitDefID, speedFactor)
	if not origUnitBuildSpeed[unitDefID] then
		local ud = UnitDefs[unitDefID]
		origUnitBuildSpeed[unitDefID] = {
			buildSpeed = ud.buildSpeed,
			maxRepairSpeed = ud.maxRepairSpeed,
			reclaimSpeed = ud.reclaimSpeed,
			resurrectSpeed = ud.resurrectSpeed
		}
	end
	local state = origUnitBuildSpeed[unitDefID]
	
	spSetUnitBuildSpeed(unitID,
		state.buildSpeed * speedFactor, -- build
		state.maxRepairSpeed * speedFactor, -- repair
		state.reclaimSpeed * speedFactor, -- reclaim
		state.resurrectSpeed * speedFactor -- rezz
	)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Cost Handling

local function UpdateCost(unitID, unitDefID, costMult)
	local cost = Spring.Utilities.GetUnitCost(unitID, unitDefID)*costMult
	Spring.SetUnitCosts(unitID, {
		metal = cost,
		energy = cost,
		buildTime = cost,
	})
	GG.att_CostMult[unitID] = costMult
	spSetUnitRulesParam(unitID, "costMult", costMult, INLOS_ACCESS)
	
	local _, maxHealth = Spring.GetUnitHealth(unitID)
	Spring.SetUnitMass(unitID, GetMass(maxHealth, cost))
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Health Handling

local origUnitHealth = {}

local function UpdateHealth(unitID, unitDefID, healthAdd, healthMult)
	if not origUnitHealth[unitDefID] then
		local ud = UnitDefs[unitDefID]
		origUnitHealth[unitDefID] = ud.health
	end
	local newMaxHealth = (origUnitHealth[unitDefID] + healthAdd) * healthMult
	local oldHealth, oldMaxHealth = Spring.GetUnitHealth(unitID)
	Spring.SetUnitMaxHealth(unitID, newMaxHealth)
	Spring.SetUnitHealth(unitID, oldHealth * newMaxHealth / oldMaxHealth)
	
	local cost = Spring.Utilities.GetUnitCost(unitID, unitDefID)*(GG.att_CostMult[unitID] or 1)
	Spring.SetUnitMass(unitID, GetMass(newMaxHealth, cost))
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Reload Time Handling

local origUnitWeapons = {}
local unitReloadPaused = {}

local function UpdatePausedReload(unitID, unitDefID, gameFrame)
	local state = origUnitWeapons[unitDefID]
	
	for i = 1, state.weaponCount do
		local w = state.weapon[i]
		local reloadState = spGetUnitWeaponState(unitID, i , 'reloadState')
		if reloadState then
			local reloadTime  = spGetUnitWeaponState(unitID, i , 'reloadTime')
			local newReload = 100000 -- set a high reload time so healthbars don't judder. NOTE: math.huge is TOO LARGE
			if reloadState < 0 then -- unit is already reloaded, so set unit to almost reloaded
				spSetUnitWeaponState(unitID, i, {reloadTime = newReload, reloadState = gameFrame+UPDATE_PERIOD+1})
			else
				local nextReload = gameFrame+(reloadState-gameFrame)*newReload/reloadTime
				spSetUnitWeaponState(unitID, i, {reloadTime = newReload, reloadState = nextReload+UPDATE_PERIOD})
			end
		end
	end
end

local function UpdateWeapons(unitID, unitDefID, weaponMods, speedFactor, rangeFactor, projSpeedFactor, projectilesFactor, minSpray, gameFrame)
	if not origUnitWeapons[unitDefID] then
		local ud = UnitDefs[unitDefID]
	
		origUnitWeapons[unitDefID] = {
			weapon = {},
			weaponCount = #ud.weapons,
			maxWeaponRange = ud.maxWeaponRange,
		}
		local state = origUnitWeapons[unitDefID]
		
		for i = 1, state.weaponCount do
			local wd = WeaponDefs[ud.weapons[i].weaponDef]
			local reload = wd.reload
			state.weapon[i] = {
				reload = reload,
				burstRate = wd.salvoDelay,
				projectiles = wd.projectiles,
				oldReloadFrames = floor(reload*Game.gameSpeed),
				range = wd.range,
				sprayAngle = wd.sprayAngle,
				projectileSpeed = wd.projectilespeed,
			}
			if wd.type == "BeamLaser" then
				state.weapon[i].burstRate = false -- beamlasers go screwy if you mess with their burst length
			end
		end
		
	end
	
	local state = origUnitWeapons[unitDefID]
	local maxRangeModified = state.maxWeaponRange*rangeFactor

	for i = 1, state.weaponCount do
		local w = state.weapon[i]
		
		if not DO_CHANGES_EXTERNALLY then
			local reloadState = spGetUnitWeaponState(unitID, i , 'reloadState')
			local reloadTime  = spGetUnitWeaponState(unitID, i , 'reloadTime')
			if speedFactor <= 0 then
				if not unitReloadPaused[unitID] then
					local newReload = 100000 -- set a high reload time so healthbars don't judder. NOTE: math.huge is TOO LARGE
					unitReloadPaused[unitID] = unitDefID
					if reloadState < gameFrame then -- unit is already reloaded, so set unit to almost reloaded
						spSetUnitWeaponState(unitID, i, {reloadTime = newReload, reloadState = gameFrame+UPDATE_PERIOD+1})
					else
						local nextReload = gameFrame+(reloadState-gameFrame)*newReload/reloadTime
						spSetUnitWeaponState(unitID, i, {reloadTime = newReload, reloadState = nextReload+UPDATE_PERIOD})
					end
					-- add UPDATE_PERIOD so that the reload time never advances past what it is now
				end
			else
				if unitReloadPaused[unitID] then
					unitReloadPaused[unitID] = nil
					spSetUnitRulesParam(unitID, "reloadPaused", -1, INLOS_ACCESS)
				end
				local moddedSpeed = ((weaponMods and weaponMods[i] and weaponMods[i].reloadMult) or 1)*speedFactor
				local newReload = w.reload/moddedSpeed
				local nextReload = gameFrame+(reloadState-gameFrame)*newReload/reloadTime
				if w.burstRate then
					spSetUnitWeaponState(unitID, i, {reloadTime = newReload + HALF_FRAME, reloadState = nextReload + 0.5, burstRate = w.burstRate/moddedSpeed + HALF_FRAME})
				else
					spSetUnitWeaponState(unitID, i, {reloadTime = newReload + HALF_FRAME, reloadState = nextReload + 0.5})
				end
			end
		end
		local moddedRange = w.range*((weaponMods and weaponMods[i] and weaponMods[i].rangeMult) or 1)*rangeFactor
		local moddedSpeed = w.projectileSpeed*((weaponMods and weaponMods[i] and weaponMods[i].projSpeedMult) or 1)*projSpeedFactor
		local moddedProjectiles = w.projectiles*((weaponMods and weaponMods[i] and weaponMods[i].projectilesMult) or 1)*projectilesFactor
		
		local sprayAngle = math.max(w.sprayAngle, minSpray)
		spSetUnitWeaponState(unitID, i, "sprayAngle", sprayAngle)
		
		spSetUnitWeaponState(unitID, i, "projectiles", moddedProjectiles)
		spSetUnitWeaponState(unitID, i, "projectileSpeed", moddedSpeed)
		spSetUnitWeaponState(unitID, i, "range", moddedRange)
		spSetUnitWeaponDamages(unitID, i, "dynDamageRange", moddedRange)
		if maxRangeModified < moddedRange then
			maxRangeModified = moddedRange
		end
	end
	
	Spring.SetUnitMaxRange(unitID, maxRangeModified)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Movement Speed Handling

local origUnitSpeed = {}

local function UpdateMovementSpeed(unitID, unitDefID, speedFactor, turnAccelFactor, maxAccelerationFactor)
	if not origUnitSpeed[unitDefID] then
		local ud = UnitDefs[unitDefID]
		local moveData = spGetUnitMoveTypeData(unitID)
	
		origUnitSpeed[unitDefID] = {
			origSpeed = ud.speed,
			origReverseSpeed = (moveData.name == "ground") and moveData.maxReverseSpeed or ud.speed,
			origTurnRate = ud.turnRate,
			origTurnAccel = (ud.turnRate or 1) * (ud.customParams.turn_accel_factor or 1),
			origMaxAcc = ud.maxAcc,
			origMaxDec = ud.maxDec,
			movetype = -1,
		}
		
		local state = origUnitSpeed[unitDefID]
		state.movetype = getMovetype(ud)
	end
	
	local state = origUnitSpeed[unitDefID]
	local decFactor = maxAccelerationFactor
	local isSlowed = speedFactor < 1
	if isSlowed then
		-- increase brake rate to cause units to slow down to their new max speed correctly.
		decFactor = 1000
	end
	if speedFactor <= 0 then
		speedFactor = 0
		
		-- Set the units velocity to zero if it is attached to the ground.
		local x, y, z = Spring.GetUnitPosition(unitID)
		if x then
			local h = Spring.GetGroundHeight(x, z)
			if h and h >= y then
				Spring.SetUnitVelocity(unitID, 0,0,0)
				
				-- Perhaps attributes should do this:
				--local env = Spring.UnitScript.GetScriptEnv(unitID)
				--if env and env.script.StopMoving then
				--	Spring.UnitScript.CallAsUnit(unitID,env.script.StopMoving, hx, hy, hz)
				--end
			end
		end
	end
	if turnAccelFactor <= 0 then
		turnAccelFactor = 0
	end
	local turnFactor = turnAccelFactor
	if turnFactor <= 0.001 then
		turnFactor = 0.001
	end
	if maxAccelerationFactor <= 0 then
		maxAccelerationFactor = 0.001
	end
	
	if spMoveCtrlGetTag(unitID) == nil then
		if state.movetype == 0 then
			local attribute = {
				maxSpeed        = state.origSpeed       *speedFactor,
				maxAcc          = state.origMaxAcc      *maxAccelerationFactor, --(speedFactor > 0.001 and speedFactor or 0.001)
			}
			spSetAirMoveTypeData (unitID, attribute)
			spSetAirMoveTypeData (unitID, attribute)
		elseif state.movetype == 1 then
			local attribute =  {
				maxSpeed        = state.origSpeed       *speedFactor,
				turnRate        = state.origTurnRate    *turnFactor,
				accRate         = state.origMaxAcc      *maxAccelerationFactor,
				decRate         = state.origMaxDec      *maxAccelerationFactor
			}
			spSetGunshipMoveTypeData (unitID, attribute)
		elseif state.movetype == 2 then
			local accRate = state.origMaxAcc*maxAccelerationFactor
			if isSlowed and accRate > speedFactor then
				-- Clamp acceleration to mitigate prevent brief speedup when executing new order
				-- 1 is here as an arbitary factor, there is no nice conversion which means that 1 is a good value.
				accRate = speedFactor
			end
			local attribute =  {
				maxSpeed        = state.origSpeed       *speedFactor,
				maxReverseSpeed = (isSlowed and 0) or state.origReverseSpeed, --disallow reverse while slowed
				turnRate        = state.origTurnRate    *turnFactor,
				accRate         = accRate,
				decRate         = state.origMaxDec      *decFactor,
				turnAccel       = state.origTurnAccel    *turnAccelFactor,
			}
			spSetGroundMoveTypeData (unitID, attribute)
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Handle by a different gadget

local function ApplyExternalChanges(unitID, weaponMods, moveMult, turnMult, accelMult, reloadMult, econMult, energyMult, buildMult)
	GG.att_genericUsed = true

	GG.att_moveMult[unitID]   = moveMult
	GG.att_turnMult[unitID]   = turnMult
	GG.att_accelMult[unitID]  = accelMult
	GG.att_reloadMult[unitID] = reloadMult
	GG.att_econMult[unitID]   = econMult
	GG.att_energyMult[unitID] = energyMult
	GG.att_buildMult[unitID]  = buildMult

	GG.att_weaponMods[unitID] = weaponMods

	GG.UpdateUnitAttributes(unitID)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Attribute Updating

-- For other gadgets to read
GG.att_CostMult = {}

-- Internal tracking to avoid unnecessary updates
local currentHealthAdd = {}
local currentHealthMult = {}
local currentMove = {}
local currentTurn = {}
local currentAccel = {}
local currentReload = {}
local currentRange = {}
local currentProjSpeed = {}
local currentEcon = {}
local currentEnergy = {}
local currentCost = {}
local currentSense = {}
local currentProjectiles = {}
local currentMinSpray = {}

local function RemoveUnit(unitID)
	unitReloadPaused[unitID] = nil -- defined earlier
	
	currentHealthAdd[unitID] = nil
	currentHealthMult[unitID] = nil
	currentMove[unitID] = nil
	currentTurn[unitID] = nil
	currentAccel[unitID] = nil
	currentReload[unitID] = nil
	currentRange[unitID] = nil
	currentProjSpeed[unitID] = nil
	currentEcon[unitID] = nil
	currentEnergy[unitID] = nil
	currentCost[unitID] = nil
	currentSense[unitID] = nil
	currentProjectiles[unitID] = nil
	currentMinSpray[unitID] = nil
end

local function UpdateUnitAttributes(unitID, attList)
	if not spValidUnitID(unitID) then
		return true
	end
	
	local unitDefID = spGetUnitDefID(unitID)
	if not unitDefID then
		return true
	end
	
	local frame = spGetGameFrame()
	
	local healthAdd = 0
	local healthMult = 1
	local moveMult = 1
	local turnMult = 1
	local accelMult = 1
	local reloadMult = 1
	local rangeMult = 1
	local projSpeedMult = 1
	local econMult = 1
	local energyMult = 1
	local costMult = 1
	local buildMult = 1
	local senseMult = 1
	local projectilesMult = 1
	local minSpray = 0
	local weaponSpecificMods = false
	
	for _, data in IterableMap.Iterator(attList) do
		healthAdd = healthAdd + (data.healthAdd or 0)
		healthMult = healthMult*(data.healthMult or 1)
		moveMult = moveMult*(data.move or 1)
		turnMult = turnMult*(data.turn or 1)
		accelMult = accelMult*(data.accel or 1)
		econMult = econMult*(data.econ or 1)
		energyMult = energyMult*(data.energy or 1)
		costMult = costMult*(data.cost or 1)
		buildMult = buildMult*(data.build or 1)
		senseMult = senseMult*(data.sense or 1)
		minSpray = math.max(minSpray, data.minSpray or 0)
		
		if data.weaponNum then
			weaponSpecificMods = weaponSpecificMods or {}
			weaponSpecificMods[data.weaponNum] = weaponSpecificMods[data.weaponNum] or {
				reloadMult = 1,
				rangeMult = 1,
				projSpeedMult = 1,
				projectilesMult = 1,
			}
			local wepData = weaponSpecificMods[data.weaponNum]
			wepData.reloadMult = wepData.reloadMult*(data.reload or 1)
			wepData.rangeMult = wepData.rangeMult*(data.range or 1)
			wepData.projSpeedMult = wepData.projSpeedMult*(data.projSpeed or 1)
			wepData.projectilesMult = wepData.projectilesMult*(data.projectiles or 1)
		else
			reloadMult = reloadMult*(data.reload or 1)
			rangeMult = rangeMult*(data.range or 1)
			projSpeedMult = projSpeedMult*(data.projSpeed or 1)
			projectilesMult = projectilesMult*(data.projectiles or 1)
		end
	end
	
	local healthChanges = (currentHealthAdd[unitID] or 0) ~= healthAdd
		or (currentHealthMult[unitID] or 1) ~= healthMult
	
	local weaponChanges = (currentReload[unitID] or 1) ~= reloadMult
		or (currentRange[unitID] or 1) ~= rangeMult
		or (currentProjectiles[unitID] or 1) ~= projectilesMult
		or (currentMinSpray[unitID] or 0) ~= minSpray
	
	local moveChanges = (currentMove[unitID] or 1) ~= moveMult
		or (currentTurn[unitID] or 1) ~= turnMult
		or (currentAccel[unitID] or 1) ~= accelMult
	
	if healthChanges then
		UpdateHealth(unitID, unitDefID, healthAdd, healthMult)
		currentHealthAdd[unitID] = healthAdd
		currentHealthMult[unitID] = healthMult
	end
	
	if (currentCost[unitID] or 1) ~= costMult then
		UpdateCost(unitID, unitDefID, costMult)
		currentCost[unitID] = costMult
	end
	
	if DO_CHANGES_EXTERNALLY then
		if (currentSense[unitID] or 1) ~= senseMult then
			UpdateSensorAndJamm(unitID, unitDefID, senseMult)
			currentSense[unitID] = senseMult
		end
		if weaponSpecificMods or weaponChanges then
			UpdateWeapons(unitID, unitDefID, weaponSpecificMods, reloadMult, rangeMult, projSpeedMult, projectilesMult, minSpray, frame)
			currentReload[unitID] = reloadMult
			currentRange[unitID] = rangeMult
			currentProjSpeed[unitID] = projSpeedMult
			currentProjectiles[unitID] = projectilesMult
			currentMinSpray[unitID] = minSpray
		end
		
		ApplyExternalChanges(unitID, weaponSpecificMods, moveMult, turnMult, accelMult, reloadMult, econMult, energyMult, buildMult)
		return
	end
	
	if moveChanges then
		UpdateMovementSpeed(unitID, unitDefID, moveMult, turnMult, accelMult)
		currentMove[unitID] = moveMult
		currentTurn[unitID] = turnMult
		currentAccel[unitID] = accelMult
	end
	
	if weaponSpecificMods or weaponChanges then
		UpdateWeapons(unitID, unitDefID, weaponSpecificMods, reloadMult, rangeMult, projSpeedMult, projectilesMult, minSpray, frame)
		currentReload[unitID] = reloadMult
		currentRange[unitID] = rangeMult
		currentProjSpeed[unitID] = projSpeedMult
		currentProjectiles[unitID] = projectilesMult
		currentMinSpray[unitID] = minSpray
	end
	
	if (currentSense[unitID] or 1) ~= senseMult then
		UpdateSensorAndJamm(unitID, unitDefID, senseMult)
		currentSense[unitID] = senseMult
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- External Interface

local Attributes = {}
local attributeUnits = {}

function Attributes.RemoveUnit(unitID)
	attributeUnits[unitID] = nil
	RemoveUnit(unitID)
end

function Attributes.AddEffect(unitID, key, effect)
	if not attributeUnits[unitID] then
		attributeUnits[unitID] = IterableMap.New()
	end
	local data = IterableMap.Get(attributeUnits[unitID], key) or {}
	
	data.healthAdd = effect.healthAdd
	data.healthMult = effect.healthMult
	data.move = effect.move
	data.turn = effect.turn or effect.move
	data.accel = effect.accel or effect.move
	data.reload = effect.reload
	data.range = effect.range
	data.projSpeed = effect.projSpeed
	data.econ = effect.econ
	data.energy = effect.energy
	data.cost = effect.cost
	data.build = effect.build
	data.sense = effect.sense
	data.projectiles = effect.projectiles
	data.weaponNum = effect.weaponNum
	data.minSpray = effect.minSprayAngle
	
	IterableMap.Add(attributeUnits[unitID], key, data) -- Overwrites existing key if it exists
	if UpdateUnitAttributes(unitID, attributeUnits[unitID]) then
		Attributes.RemoveUnit(unitID)
	end
end

function Attributes.RemoveEffect(unitID, key)
	if not attributeUnits[unitID] then
		return
	end
	IterableMap.Remove(attributeUnits[unitID], key)
	if UpdateUnitAttributes(unitID, attributeUnits[unitID]) then
		Attributes.RemoveUnit(unitID)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Updates and tweaks

function gadget:Initialize()
	GG.Attributes = Attributes
end

function gadget:GameFrame(f)
	if f % UPDATE_PERIOD == 1 then
		for unitID, unitDefID in pairs(unitReloadPaused) do
			UpdatePausedReload(unitID, unitDefID, f)
		end
	end
end

function gadget:UnitDestroyed(unitID)
	Attributes.RemoveUnit(unitID)
end
