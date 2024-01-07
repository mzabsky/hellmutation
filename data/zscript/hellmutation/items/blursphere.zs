class HM_BlurSphere: BlurSphere replaces BlurSphere
{
    mixin HM_GlobalRef;

    override bool Use(bool pickup)
    {
        if(global.IsPerkActive("focused"))
        {
            Owner.GiveInventoryType("soulsphere");
            return true;
        }
        
        return super.Use(pickup);
    }
}