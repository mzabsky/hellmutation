class HM_Mancubus: Fatso replaces Fatso
{
    mixin HM_GlobalRef;
    mixin HM_SetMaxHealth;

    Default
    {
        Species "Fatso";
    }

    States
    {
        See:
            FATT A 0 {
                bAlwaysFast = global.IsMutationActive("hyperphagy");

                let totalHealth = 600;
                if(global.IsMutationActive("obesity"))
                {
                    totalHealth += 300;
                }

                HM_SetMaxHealth(totalHealth);
            }
            FATT AABBCCDDEEFF 4 FAST A_Chase;
            Loop;
        Missile:
            FATT G 20 FAST A_FatRaise;
            FATT H 10 Bright HM_A_FatAttack(HM_FATSHOT_RIGHT);
            FATT IG 5 A_FaceTarget;
            FATT H 10 Bright HM_A_FatAttack(HM_FATSHOT_LEFT);
            FATT IG 5 A_FaceTarget;
            FATT H 10 Bright HM_A_FatAttack(HM_FATSHOT_RIGHT | HM_FATSHOT_LEFT);
            FATT IG 5 A_FaceTarget;
            Goto See;
        Death:
            FATT K 0 {
                if(global.IsMutationActive("catastrophicreflux"))
                {
                    return ResolveState("RefluxDeath");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            FATT K 6;
            FATT L 6 A_Scream;
            FATT M 6 A_NoBlocking;
            FATT NOPQRS 6;
            FATT T -1 A_BossDeath;
            Stop;
        RefluxDeath:
            FATT K 0 Spawn("HM_RefluxExplosionGenerator", pos);
            FATT K 6;
            FATT L 6 A_Scream;
            FATT L 0 A_Explode(260, 164);
            FATT M 6 A_NoBlocking;
            FATT NOPQRS 6;
            FATT T -1 A_BossDeath;
            Stop;
    }

    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        if(inflictor is 'HM_Fire')
        {
            return 0;
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }

    void HM_A_FatAttack(HM_FatShotDirection directions)
    {
        if(!target)
        {
            return;
        }

        let epsilon = 0.0000001;

        A_FaceTarget();

        let startingAngle = 0;
        if(directions & HM_FATSHOT_LEFT)
        {
            startingAngle = 0 - FATSPREAD;
        }

        let endingHorizontalAngle = 0;
        if(directions & HM_FATSHOT_RIGHT)
        {
            endingHorizontalAngle = 0 + FATSPREAD;
        }

        let horizontalAngleIncrement = FATSPREAD;
        if(global.IsMutationActive("abundance"))
        {
            horizontalAngleIncrement = FATSPREAD / 2;
        }
        
        let startingVerticalAngle = 0;
        let endingVerticalAngle = 0;
        let verticalAngleIncrement = 6;
        if(global.IsMutationActive("walloffire"))
        {
            startingVerticalAngle = -6;
            endingVerticalAngle = 6;

            if(global.IsMutationActive("abundance"))
            {
                startingVerticalAngle = -9;
                endingVerticalAngle = 9;
                verticalAngleIncrement = 4.5;
            }
        }

        for(let currentHorizontalAngle = startingAngle; currentHorizontalAngle <= endingHorizontalAngle + epsilon; currentHorizontalAngle += horizontalAngleIncrement)
        {
            for(let currentVerticalAngle = startingVerticalAngle; currentVerticalAngle <= endingVerticalAngle + epsilon; currentVerticalAngle += verticalAngleIncrement)
            {
                A_CustomMissile("HM_FatShot",32,0, currentHorizontalAngle,CMF_AIMOFFSET | CMF_OFFSETPITCH, currentVerticalAngle);
            }
        }
    }

}

enum HM_FatShotDirection
{
    HM_FATSHOT_LEFT = 1,
    HM_FATSHOT_RIGHT = 2
}

class HM_FatShot : FatShot
{
    mixin HM_GlobalRef;

    States
    {
        Spawn:
            MANF AB 4 BRIGHT;
            Loop;
        Death:
            MISL B 8 BRIGHT;
            MISL B 0 BRIGHT {
                SpawnFire();
            }
            MISL C 6 BRIGHT;
            MISL D 4 BRIGHT;
            Stop;
    }

    Vector3 storedVel;
    
    override void PostBeginPlay()
    {
        storedVel = vel;

        super.PostBeginPlay();
    }

    void SpawnFire()
    {
        if(!global.IsMutationActive("napalmpayload"))
        {
            return;
        }

        let numberOfFires = random[HM_Fire](5, 8);
        for(let i = 0; i < numberOfFires; i++)
        {
            // Reverse a bit of the flight trajectory to spawn the fire, so that it spreads
            // a little bit away from whatever it hit
            let fire = Spawn("HM_Fire", Vec3Offset(-storedVel.x, -storedVel.y, 10));
            fire.target = target;
            if(fire)
            {
                // Spread the fire around a bit
                fire.vel.x = random[HM_Fire](-6, 6);
                fire.vel.y = random[HM_Fire](-6, 6);
                fire.vel.z = random[HM_Fire](0, 3);                
            }
        }
    }
}

class HM_RefluxExplosionGenerator: Actor
{    
    mixin HM_GlobalRef;

    int RemainingTics;
    bool EnableNapalm;

    States
    {
        Spawn:
            TNT1 A -1;
            Stop;
    }

    override void PostBeginPlay ()
    {
        RemainingTics = 35;
        EnableNapalm = global.IsMutationActive("napalmpayload");
        super.PostBeginPlay();
    }

    override void Tick()
    {
        if(RemainingTics <= 0)
        {
            Destroy();
            return;
        }

        if(EnableNapalm)
        {
            let numberOfFires = random[HM_Fire](0, 3);
            for(let i = 0; i < numberOfFires; i++)
            {
                // Reverse a bit of the flight trajectory to spawn the fire, so that it spreads
                // a little bit away from whatever it hit
                let fire = Spawn("HM_Fire", Vec3Offset(random[HM_Fire](-30, 30), random[HM_Fire](-30, 30), random[HM_Fire](0, 60)));
                fire.target = target;
                if(fire)
                {
                    // Spread the fire around a bit
                    fire.vel.x = random[HM_Fire](-8, 8);
                    fire.vel.y = random[HM_Fire](-8, 8);
                    fire.vel.z = random[HM_Fire](0, 12);                
                }
            }
        }

        RemainingTics--;

        let spread = 104 - RemainingTics * 3;
        Spawn(
            "HM_RefluxExplosion",
            Vec3Offset(
                random[HM_RefluxExplosion](-spread, spread), random[HM_RefluxExplosion](-spread, spread), random[TeleGlitter](0,64)
            )
        );
        
        super.Tick();
    }
}

class HM_RefluxExplosion: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +NOGRAVITY
        RenderStyle "Add";
        Damage 0;
    }
  
    States
    {
        Spawn:
            MISL B 8 Bright;
            MISL C 6 Bright;
            MISL D 4 Bright;
            Stop;
  }
}
