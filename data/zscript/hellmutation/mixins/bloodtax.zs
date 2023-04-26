// Implements Blood Tax mutation, applicable on inventory items
mixin class HM_BloodTax
{
    override void DoPickupSpecial(Actor toucher)
    {
        if(toucher && toucher.health > 0 && toucher is 'PlayerPawn' && global.IsMutationActive("bloodtax"))
        {
            let oldHealth = toucher.health;
            toucher.A_SetHealth(max(toucher.health - 25, 1));

            if(toucher.health != oldHealth)
            {
                toucher.SetState(toucher.ResolveState("Pain"));
                toucher.player.damagecount += 25;
            }
        }

        super.DoPickupSpecial(toucher);
    }
}