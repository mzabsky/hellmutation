class HM_SoulSphere: SoulSphere replaces SoulSphere
{
    mixin HM_GlobalRef;

    override bool TryPickup (in out Actor toucher)
    {
        let tryPickupResult = super.TryPickup(toucher);
        if(tryPickupResult && global.IsPerkActive("megalomania"))
        {
            toucher.GiveInventoryType("megasphere");
        }
        
        return tryPickupResult;
    }
}