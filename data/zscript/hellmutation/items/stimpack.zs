class HM_Stimpack: Stimpack replaces Stimpack
{
    mixin HM_GlobalRef;

    override bool TryPickup (in out Actor toucher)
    {
        let tryPickupResult = super.TryPickup(toucher);
        if(tryPickupResult && global.IsPerkActive("firstaid"))
        {
            toucher.GiveInventoryType("stimpack");
        }
        
        return tryPickupResult;
    }
}