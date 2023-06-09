mixin class HM_SetMaxHealth
{
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