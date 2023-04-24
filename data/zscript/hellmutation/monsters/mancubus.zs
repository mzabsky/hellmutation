class HM_Mancubus: Fatso replaces Fatso
{
    mixin HM_GlobalRef;

    bool appliedAdipocytesState;

    States
    {
        See:
            FATT A 0 {
                let totalHealth = 600;
                if(global.IsMutationActive("adipocytes"))
                {
                    totalHealth += 300;
                }

                HM_SetMaxHealth(totalHealth);
            }
            FATT AABBCCDDEEFF 4 A_Chase;
            Loop;
        Missile:
            FATT G 20 A_FatRaise;
            FATT H 10 Bright HM_A_FatAttack(HM_FATSHOT_RIGHT);
            FATT IG 5 A_FaceTarget;
            FATT H 10 Bright HM_A_FatAttack(HM_FATSHOT_LEFT);
            FATT IG 5 A_FaceTarget;
            FATT H 10 Bright HM_A_FatAttack(HM_FATSHOT_RIGHT | HM_FATSHOT_LEFT);
            FATT IG 5 A_FaceTarget;
            Goto See;
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