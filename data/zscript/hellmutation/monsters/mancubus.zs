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

        let startingAngle = Angle;
        if(directions & HM_FATSHOT_LEFT)
        {
            startingAngle = Angle - FATSPREAD;
        }

        let endingAngle = Angle;
        if(directions & HM_FATSHOT_RIGHT)
        {
            endingAngle = Angle + FATSPREAD;
        }

        let angleIncrement = FATSPREAD;
        if(global.IsMutationActive("abundance"))
        {
            angleIncrement = FATSPREAD / 2;
        }
        
        for(let currentAngle = startingAngle; currentAngle <= endingAngle + epsilon; currentAngle += angleIncrement)
        {
            Actor missile = SpawnMissile (target, "FatShot");
            if (missile)
            {
                missile.Angle = currentAngle;
                missile.VelFromAngle();
            }
        }
    }

}

enum HM_FatShotDirection
{
    HM_FATSHOT_LEFT = 1,
    HM_FATSHOT_RIGHT = 2
}