mixin class HM_BigFuckingWomp
{
    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        if(mod == "BFGSplash" && global.IsMutationActive("bigfuckingwomp"))
        {
            damage = damage / 3;
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}