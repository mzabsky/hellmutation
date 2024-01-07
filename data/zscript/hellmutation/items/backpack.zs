class HM_Backpack: Backpack replaces Backpack
{
    mixin HM_GlobalRef;

    override bool TryPickup (in out Actor toucher)
    {
        let tryPickupResult = super.TryPickup(toucher);
        if(tryPickupResult && global.IsPerkActive("carepackage"))
        {
            toucher.GiveInventory("ClipBox", 1000);
            toucher.GiveInventory("ShellBox", 1000);
            toucher.GiveInventory("RocketBox", 1000);
            toucher.GiveInventory("CellPack", 1000);
        }
        
        return tryPickupResult;
    }
}