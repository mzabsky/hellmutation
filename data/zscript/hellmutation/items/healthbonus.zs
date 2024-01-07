class HM_HealthBonus: HealthBonus replaces HealthBonus
{
    mixin HM_GlobalRef;

    override bool TryPickup (in out Actor toucher)
    {
        let tryPickupResult = super.TryPickup(toucher);
        if(tryPickupResult && global.IsPerkActive("bonusbonus"))
        {
            toucher.GiveInventoryType("armorbonus");
            toucher.GiveInventoryType("armorbonus");
            toucher.GiveInventoryType("healthbonus");
        }
        
        return tryPickupResult;
    }
}