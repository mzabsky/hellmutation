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

}