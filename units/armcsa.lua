unitDef = {
  unitname            = [[armcsa]],
  name                = [[Athena]],
  description         = [[Airborne SpecOps Engineer, Builds at 7.5 m/s]],
  acceleration        = 0.084,
  airStrafe           = 0,
  amphibious          = true,
  autoHeal            = 2,
  bankscale           = [[1.5]],
  brakeRate           = 1.875,
  buildCostEnergy     = 500,
  buildCostMetal      = 500,
  buildDistance       = 60,
  builder             = true,

  buildoptions        = {
    [[cormex]],
    [[armsolar]],
    [[armwin]],
    [[armnanotc]],
    [[corrad]],
    [[armjamt]],
    [[corrl]],
    [[corllt]],
    [[armartic]],
    [[corgrav]],
    [[armdeva]],
    [[corhlt]],
    [[armsonar]],
    [[cortl]],
    [[armcomdgun]],
    [[armrectr]],
    [[armflea]],
    [[corak]],
    [[spherepole]],
    [[armsptk]],
    [[slowmort]],
    [[armsnipe]],
    [[armspy]],
    [[armjeth]],
  },

  buildPic            = [[ARMCSA.png]],
  buildRange3D        = false,
  buildTime           = 500,
  canFly              = true,
  canGuard            = true,
  canMove             = true,
  canPatrol           = true,
  canreclamate        = [[1]],
  canSubmerge         = false,
  category            = [[GUNSHIP UNARMED]],
  cloakCost           = 3,
  cloakCostMoving     = 10,
  collide             = true,
  corpse              = [[DEAD]],
  cruiseAlt           = 80,

  customParams        = {
    airstrafecontrol = [[1]],
    description_fr = [[ADAV de Construcion Furtif Camouflable, Construit r 6 m/s]],
    description_de = [[Fliegender SpecOps Bauleiter, Baut mit 9 m/s]],
    helptext_de    = [[Athene ist die Spitze der Tarnungsschlagkraft. Ausgerüstet mit einem Verhüllungsgeräte und einem Radarstörer kann es durch gegnerische Verteidigungslinien fliegen und Truppen aus Angreifern zusammenstellen, die dann Verwüstung nachsichziehen werden und die gegnerische Logistik vernichten können.]],
    helptext       = [[The Athena is the pinnacle of stealth strike capability. Equipped with a cloaking device and a radar jammer, it can slip through enemy lines to assemble squads of raiders, inflicting havoc on the opposition's logistics.]],
    helptext_fr    = [[Le Athena est un ingénieur de combat non armé. Équipé d'un brouilleur radar et d'un camouflage optique il peut construire certaines infrastructures et des unités nimporte ou, et ainsi surprendre l'enneme.]],
  },

  energyMake          = 0.15,
  energyUse           = 0,
  explodeAs           = [[GUNSHIPEX]],
  floater             = true,
  footprintX          = 2,
  footprintZ          = 2,
  hoverAttack         = true,
  iconType            = [[t3builder]],
  initCloaked         = false,
  maneuverleashlength = [[1280]],
  mass                = 196,
  maxDamage           = 200,
  maxSlope            = 36,
  maxVelocity         = 9.17,
  metalMake           = 0.15,
  minCloakDistance    = 50,
  noAutoFire          = false,
  noChaseCategory     = [[TERRAFORM SATELLITE FIXEDWING GUNSHIP HOVER SHIP SWIM SUB LAND FLOAT SINK TURRET]],
  objectName          = [[selene.s3o]],
  radarDistanceJam    = 300,
  seismicSignature    = 0,
  selfDestructAs      = [[GUNSHIPEX]],
  showNanoSpray       = false,
  side                = [[ARM]],
  sightDistance       = 380,
  smoothAnim          = true,
  stealth             = true,
  terraformSpeed      = 300,
  turnRate            = 148,
  workerTime          = 7.5,

  featureDefs         = {

    DEAD  = {
      description      = [[Wreckage - Athena]],
      blocking         = true,
      category         = [[corpses]],
      damage           = 400,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[40]],
      hitdensity       = [[100]],
      metal            = 200,
      object           = [[selene_dead.s3o]],
      reclaimable      = true,
      reclaimTime      = 200,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

    HEAP  = {
      description      = [[Debris - Athena]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 400,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 2,
      footprintZ       = 2,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 100,
      object           = [[debris2x2c.s3o]],
      reclaimable      = true,
      reclaimTime      = 100,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ armcsa = unitDef })
