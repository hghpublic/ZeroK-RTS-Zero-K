unitDef = {
  unitname                      = [[factoryplane]],
  name                          = [[Airplane Plant]],
  description                   = [[Produces Airplanes, Builds at 10 m/s]],
  acceleration                  = 0,
  activateWhenBuilt             = false,
  brakeRate                     = 0,
  buildCostEnergy               = 600,
  buildCostMetal                = 600,
  builder                       = true,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 9,
  buildingGroundDecalSizeY      = 7,
  buildingGroundDecalType       = [[factoryplane_aoplane.dds]],

  buildoptions                  = {
    [[armca]],
    [[fighter]],
    [[corvamp]],
	[[bomberdive]],
	[[corhurc2]],
    [[armstiletto_laser]],
    [[armcybr]],
    [[corawac]],
  },

  buildPic                      = [[factoryplane.png]],
  buildTime                     = 600,
  canMove                       = true,
  canPatrol                     = true,
  canstop                       = [[1]],
  category                      = [[FLOAT UNARMED]],
  collisionVolumeTest           = 1,
  corpse                        = [[DEAD]],

  customParams                  = {
    pad_count = 1,
    landflystate   = [[0]],
    description_de = [[Produziert Flugzeuge, Baut mit 10 M/s]],
    description_pl = [[Buduje samoloty, moc 10 m/s]],
    helptext       = [[The Airplane Plant offers a variety of fixed-wing aircraft to suit your needs. Choose between multirole fighters that can double as light attackers or specialized interceptors, and between precision bombers for taking down specific targets or their saturation counterparts for destroying swarms. The plant also comes bundled with one rearm pad.]],
	helptext_de    = [[Das Airplane Plant ermöglicht den Bau vielfältiger Starrflügelflugzeuge, um deine Bedürfnisse zu stillen. Wähle zwischen Allzweckjägern, die sowohl leichte Attacken fliegen können, als auch als Abfangjäger fungieren, und präzisen Bombern, um spezielle Ziele zu vernichten. Es befüllt außerdem die Bomber.]],
	helptext_pl    = [[Lotnisko pozwala na budowe samolotow i oprocz samolotu konstrukcyjnego i zwiadowczego oferuje takze dwa rodzaje mysliwcow i cztery bombowcow, kazdy wyspecjalizowany do unikalnej roli. Posiada takze jedno stanowisko uzupelniania dla bombowcow.]],
    sortName = [[4]],
	modelradius    = [[25]],
	midposoffset   = [[0 20 0]],
  },

  energyMake                    = 0.3,
  energyUse                     = 0,
  explodeAs                     = [[LARGE_BUILDINGEX]],
  fireState                     = 0,
  footprintX                    = 8,
  footprintZ                    = 6,
  iconType                      = [[facair]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  mass                          = 324,
  maxDamage                     = 4000,
  maxSlope                      = 15,
  maxVelocity                   = 0,
  metalMake                     = 0.3,
  minCloakDistance              = 150,
  noAutoFire                    = false,
  objectName                    = [[CORAP.s3o]],
  script                        = [[factoryplane.lua]],
  seismicSignature              = 4,
  selfDestructAs                = [[LARGE_BUILDINGEX]],
  showNanoSpray                 = false,
  side                          = [[CORE]],
  sightDistance                 = 273,
  TEDClass                      = [[PLANT]],
  turnRate                      = 0,
  useBuildingGroundDecal        = true,
  waterline						= 0,
  workerTime                    = 10,
  yardMap                       = [[oooooooo oooooooo oooooooo occooooo occooooo oooooooo]],

  featureDefs                   = {

    DEAD = {
      description      = [[Wreckage - Airplane Plant]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 4000,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 7,
      footprintZ       = 6,
      height           = [[20]],
      hitdensity       = [[100]],
      metal            = 240,
      object           = [[corap_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 240,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP = {
      description      = [[Debris - Airplane Plant]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 4000,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 6,
      footprintZ       = 6,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 120,
      object           = [[debris4x4c.s3o]],
      reclaimable      = true,
      reclaimTime      = 120,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ factoryplane = unitDef })
