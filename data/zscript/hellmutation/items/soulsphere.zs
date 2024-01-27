class HM_SoulSphere: SoulSphere replaces SoulSphere
{
    mixin HM_GlobalRef;

    override bool TryPickup (in out Actor toucher)
    {
        if(global.IsPerkActive("glory"))
        {
            MaxAmount = 300;
        }
        else
        {
            MaxAmount = 200;
        }

        let originalHealth = toucher.Health;
        let originalArmor = toucher.CountInv("BasicArmor");

        if(global.IsPerkActive("megalomania"))
        {
            toucher.GiveInventoryType("hm_megasphere");

            return originalHealth <= MaxAmount || originalArmor <= MaxAmount;
        }
        else
        {
            return super.TryPickup(toucher);
        }
    }
}