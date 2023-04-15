// Implementation of LordsOfDarkness
mixin class HM_LordsOfDarkness
{
    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        let lightlevelMultiplier = 1.0;
        if(global.IsMutationActive("lordsofdarkness") && cursector.lightlevel < 128)
        {
            // We want them to take:
            // - light level 128+ -> 100% multiplier
            // - light level 0 -> 33% multiplier
            // Interpolate in between.
            lightlevelMultiplier = 0.33 + (0.6 * double(cursector.lightlevel) / 128.0);
        }

        //console.printf("Lords of Darkness multiplier: %f %d", lightlevelMultiplier, int(damage * lightlevelMultiplier));

        // Can't redirect, take everything
        return super.DamageMobj(inflictor, source, int(damage * lightlevelMultiplier), mod, flags, angle);
    }
}