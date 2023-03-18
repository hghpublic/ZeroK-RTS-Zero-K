return {
  ["riotball"] = {
    usedefaultexplosions = false,
    groundflash = {
      alwaysvisible      = false,
      circlealpha        = 0.2,
      circlegrowth       = 13.2,
      flashalpha         = 0.2,
      flashsize          = 500,
      ttl                = 24,
      color = {
        [1]  = 0.3,
        [2]  = 0,
        [3]  = 0.4,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alpha              = 0.6,
        color              = [[0.3,0,0.4]],
        expansionspeed     = 13.2,
        ttl                = 20,
      },
    },
    muzzleflash = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        colormap           = [[1 0.7 0.2 0.01    1 0.7 0.2 0.01    0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[dir]],
        gravity            = [[0, 0, 0]],
        numparticles       = 1,
        particlelife       = 90,
        particlelifespread = 0,
        particlesize       = 0,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 0,
        texture            = [[plasma]],
      },
    },
  },
  ["riotball_small"] = {
    usedefaultexplosions = false,
    groundflash = {
      alwaysvisible      = true,
      circlealpha        = 0.4,
      circlegrowth       = 7,
      flashalpha         = 0.5,
      flashsize          = 60,
      ttl                = 12,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 1,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alpha              = 0.5,
        color              = [[1,0,1]],
        expansionspeed     = 6,
        ttl                = 8,
      },
    },
  },
  ["riotball_dark"] = {
    usedefaultexplosions = false,
    groundflash = {
      alwaysvisible      = true,
      circlealpha        = 0.4,
      circlegrowth       = 7,
      flashalpha         = 0.2,
      flashsize          = 300,
      ttl                = 45,
      color = {
        [1]  = 0.15,
        [2]  = 0,
        [3]  = 0.2,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alpha              = 0.6,
        color              = [[0.15,0,0.2]],
        expansionspeed     = 3,
        ttl                = 150,
      },
    },
    ring1 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        colormap           = [[0.3 0 0.4 .1   .15 0 0.2 .1   0 0 0 0]],
        dir                = [[-1 r1, 1, -1 r1]],
        frontoffset        = 0,
        fronttexture       = [[shockwave]],
        length             = 1,
        pos                = [[0, 0, 0]],
        sidetexture        = [[null]],
        size               = 1,
        sizegrowth         = 175,
        ttl                = 18,
      },
    },
  },
  ["riotballplus"] = {
    usedefaultexplosions = false,
    groundflash = {
      alwaysvisible      = true,
      circlealpha        = 0.4,
      circlegrowth       = 7,
      flashalpha         = 0.5,
      flashsize          = 256,
      ttl                = 45,
      color = {
        [1]  = 0,
        [2]  = 1,
        [3]  = 1,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alpha              = 0.5,
        color              = [[0,1,1]],
        expansionspeed     = 6,
        ttl                = 32,
      },
    },
  },
  ["riotballplus2_purple"] = {
    usedefaultexplosions = false,
    groundflash = {
      alwaysvisible      = true,
      circlealpha        = 0.4,
      circlegrowth       = 7,
      flashalpha         = 0.5,
      flashsize          = 320,
      ttl                = 64,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 1,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alpha              = 0.5,
        color              = [[1,0,1]],
        expansionspeed     = 6,
        ttl                = 45,
      },
    },
  },
  ["purple_missile"] = {
    usedefaultexplosions = false,
    meltage = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 10,
      ground             = true,
      water              = true,
      properties = {
        delay              = 0,
        explosiongenerator = [[custom:SLOW_MELT]],
        pos                = [[0, 0, 0]],
      },
    },
    pikes = {
      air                = true,
      class              = [[explspike]],
      count              = 5,
      ground             = true,
      water              = true,
      properties = {
        alpha              = 1,
        alphadecay         = 0.04,
        color              = [[0.4,0,0.5]],
        dir                = [[-1 r2,-1 r2,-1 r2]],
        length             = 20,
        width              = 45,
      },
    },
    sparks_purple_fallout = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 300,
      ground             = true,
      water              = true,
      properties = {
        delay              = 0,
        explosiongenerator = [[custom:purple_fallout]],
        pos                = [[r3.7606 y10 -1 x10x10x10x10 y10 400 a10 y10     r6.2831 y11 -3.1415 a11 y11    r1 y12    -1 x12 y0 1 a0 p0.5 y0 0 a12 p0.5 y1 2 x0 x1 y13       -0.5x11x11 y0 0.0417x11x11x11x11 y1 -0.00139x11x11x11x11x11x11 y2 0.0000248015x11x11x11x11x11x11x11x11 y3 -0.000000275573x11x11x11x11x11x11x11x11x11x11 y4 0.00000000208768x11x11x11x11x11x11x11x11x11x11x11x11 y5 1 a0 a1 a2 a3 a4 a5 x10 x13,              2 x12 y12 -1 a12 x10,              -0.1667x11x11x11 y0 0.00833x11x11x11x11x11 y1 -0.000198412x11x11x11x11x11x11x11 y2 0.00000275573192x11x11x11x11x11x11x11x11x11 y3 -0.00000002505210838x11x11x11x11x11x11x11x11x11x11x11 y4 0 a11 a0 a1 a2 a3 a4 x10 x13]],
      },
    },
    sparks_purple_fallout_burst = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 45,
      ground             = true,
      water              = true,
      properties = {
        airdrag             = 0.95,
        colormap            = [[1.0 0.2 1.0 0.01   0.9 0.3 0.9 0.01   0 0 0 0.01]],
        directional         = false,
        emitrot             = 0,
        emitrotspread       = 180,
        emitvector          = [[0, 1, 0]],
        gravity             = [[0, -0.002, 0]],
        numparticles        = 6,
        particlelife        = 90,
        particlelifespread  = 50,
        particlesize        = 3,
        particlesizespread  = 7,
        particlespeed       = 15,
        particlespeedspread = 5,
        pos                 = [[0, 0, 0]],
        sizegrowth          = 0.01,
        sizemod             = 1.0,
        texture             = [[dirt]],
      },
    },
    --sparks_purple = {
    --  air                = true,
    --  class              = [[CSimpleParticleSystem]],
    --  count              = 15,
    --  ground             = true,
    --  water              = true,
    --  properties = {
    --    airdrag            = 0.97,
    --    colormap           = [[1.0 0.2 1.0 0.01   0.9 0.3 0.9 0.01   0 0 0 0.01]],
    --    directional        = true,
    --    emitrot            = 0,
    --    emitrotspread      = 80,
    --    emitvector         = [[0, 1, 0]],
    --    gravity            = [[0, -0.15, 0]],
    --    numparticles       = 6,
    --    particlelife       = 6,
    --    particlelifespread = 5,
    --    particlesize       = 10,
    --    particlesizespread = 6,
    --    particlespeed      = 4,
    --    particlespeedspread = 8,
    --    pos                = [[0, 0, 0]],
    --    sizegrowth         = 0,
    --    sizemod            = 1.0,
    --    texture            = [[plasma]],
    --  },
    --},
    sparks_purple_up = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 16,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.99,
        colormap           = [[1.0 0.2 1.0 0.01   0.9 0.3 0.9 0.01   0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 30,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.12, 0]],
        numparticles       = 6,
        particlelife       = 8,
        particlelifespread = 15,
        particlesize       = 10,
        particlesizespread = 5,
        particlespeed      = 8,
        particlespeedspread = 12,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[plasma]],
      },
    },
    sparks_yellow_up = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 16,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.99,
        colormap           = [[1.0 0.8 0.5 0.01   0.9 0.7 0.4 0.01   0 0 0 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 30,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.12, 0]],
        numparticles       = 6,
        particlelife       = 8,
        particlelifespread = 15,
        particlesize       = 10,
        particlesizespread = 5,
        particlespeed      = 8,
        particlespeedspread = 12,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1.0,
        texture            = [[plasma]],
      },
    },
  },
  ["purple_fallout"] = {
   sparks_purple_fallout = {
     air                = true,
     class              = [[CSimpleParticleSystem]],
     count              = 1,
     ground             = true,
     water              = true,
     properties = {
       airdrag             = 0.995,
       colormap            = [[0.0 0.0 0.0 0.01  0.0 0.0 0.0 0.01   1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1  1.0 0.2 1.0 0.1  1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1    1.0 0.2 1.0 0.1   0.9 0.3 0.9 0.1   0 0 0 0.01]],
       directional         = false,
       emitrot             = 0,
       emitrotspread       = 180,
       emitvector          = [[0, 1, 0]],
       gravity             = [[0, -0.0012, 0]],
       numparticles        = 1,
       particlelife        = 780,
       particlelifespread  = 240,
       particlesize        = 3,
       particlesizespread  = 7,
       particlespeed       = 0.08,
       particlespeedspread = 0.1,
       pos                 = [[0, 0, 0]],
       sizegrowth          = 0.01,
       sizemod             = 1.0,
       texture             = [[dirt]],
     },
   },
  },
  ["purple_missile_riotball"] = {
    usedefaultexplosions = false,
    groundflash = {
      alwaysvisible      = true,
      circlealpha        = 0.4,
      circlegrowth       = 7,
      flashalpha         = 0.2,
      flashsize          = 320,
      ttl                = 64,
      color = {
        [1]  = 1,
        [2]  = 0,
        [3]  = 1,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alpha              = 0.5,
        color              = [[1,0,1]],
        expansionspeed     = 6,
        ttl                = 45,
      },
    },
  },
  ["riotballplus2_purple_limpet"] = {
    usedefaultexplosions = false,
    groundflash = {
      circlealpha        = 1,
      circlegrowth       = 12,
      flashalpha         = 2.15,
      flashsize          = 68,
      ttl                = 6,
      color = {
        [1]  = 1,
        [2]  = 0.89999997615814,
        [3]  = 0.60000002384186,
      },
    },
    sphere = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater 		 = true,
      properties = {
        alpha              = 0.5,
        color              = [[1,0,1]],
        expansionspeed     = 12,
        ttl                = 22,
      },
    },
  },
  ["riotballgrav"] = {
    usedefaultexplosions = false,
    groundflash = {
      air = true,
      ground = true,
      water = true,
      underwater = true,
      unit = true,
      alwaysvisible      = true,
      circlealpha        = 0.4,
      circlegrowth       = 7,
      flashalpha         = 0.5,
      flashsize          = 320,
      ttl                = 64,
      color = {
        [1]  = 0.2,
        [2]  = 0.3,
        [3]  = 0.8,
      },
    },
    ring1 = {
      air                = true,
      class              = [[CBitmapMuzzleFlame]],
      ground             = true,
      water              = true,
      underwater         = true,
      count              = 5,
      properties = {
        colormap           = [[0.1 0.15 0.4 .1   .05 0.075 0.2 .1   0 0 0 0]],
        dir                = [[-1 r2, 1, -1 r2]],
        frontoffset        = 0,
        fronttexture       = [[shockwave]],
        length             = 1,
        pos                = [[0, 0, 0]],
        sidetexture        = [[null]],
        size               = 1,
        sizegrowth         = 260,
        ttl                = 60,
      },
    },
  },
}

