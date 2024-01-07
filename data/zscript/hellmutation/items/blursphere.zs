class HM_BlurSphere: BlurSphere replaces BlurSphere
{
    mixin HM_GlobalRef;

    override bool Use(bool pickup)
    {
        if(global.IsPerkActive("focused"))
        {
            // Make sure Focused stacks with Megalomania correctly
            if(global.IsPerkActive("megalomania"))
            {
                Owner.GiveInventoryType("megasphere");
            }
            else
            {
                Owner.GiveInventoryType("soulsphere");
            }
            
            return true;
        }
        
        return super.Use(pickup);
    }
}