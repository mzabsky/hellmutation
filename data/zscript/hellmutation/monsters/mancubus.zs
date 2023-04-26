class HM_Mancubus: Fatso replaces Fatso
{
    mixin HM_GlobalRef;

    Default
    {
        Species "Fatso";
    }

    bool appliedAdipocytesState;

    States
    {
        See:
            FATT A 0 {
                bAlwaysFast = global.IsMutationActive("hyperphagy");

                let totalHealth = 600;
                if(global.IsMutationActive("adipocytes"))
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

    void HM_SetMaxHealth(int newMaxHealth)
    {
        let previousMaxHealth = starthealth;
        if(newMaxHealth != previousMaxHealth)
        {
            starthealth = newMaxHealth;

            if(newMaxHealth > previousMaxHealth)
            {
                A_SetHealth(newMaxHealth);
            }
            else if(health > newMaxHealth)
            {
                A_SetHealth(newMaxHealth);
            }
        }
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
                A_CustomMissile("FatShot",32,0, currentHorizontalAngle,CMF_AIMOFFSET | CMF_OFFSETPITCH, currentVerticalAngle);
            }
        }
    }

}

enum HM_FatShotDirection
{
    HM_FATSHOT_LEFT = 1,
    HM_FATSHOT_RIGHT = 2
}

class HM_RefluxExplosionGenerator: Actor
{
    int RemainingTics;

    States
    {
        Spawn:
            TNT1 A -1;
            Stop;
    }

    override void BeginPlay ()
    {
        RemainingTics = 35;
        super.BeginPlay();
    }

    override void Tick()
    {
        if(RemainingTics <= 0)
        {
            Destroy();
            return;
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
