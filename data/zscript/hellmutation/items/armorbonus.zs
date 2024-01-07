class HM_ArmorBonus: ArmorBonus replaces ArmorBonus
{
    mixin HM_GlobalRef;

    override bool TryPickup (in out Actor toucher)
    {
        let tryPickupResult = super.TryPickup(toucher);
        if(tryPickupResult && global.IsPerkActive("bonusbonus"))
        {
            toucher.GiveInventoryType("armorbonus");
            toucher.GiveInventoryType("healthbonus");
            toucher.GiveInventoryType("healthbonus");
        }
        
        return tryPickupResult;
    }
}