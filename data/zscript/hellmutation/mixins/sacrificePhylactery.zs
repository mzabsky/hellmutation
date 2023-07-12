enum HM_EDmgFlags
{
	HM_DMG_REDIRECTED = 1 << 30
}

// Implements damage redirection for Sacrifice mutation
mixin class HM_SacrificeAndPhylactery
{
    Actor phylacteryTarget;

    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        let halvedDamage = damage / 2;
        let damageToRedirect = damage - halvedDamage;
        let radius = 256;

        let actualDamage = damage;

        // TODO: Check flags for some special damage flags
        // Can't redirect redirected damage
        if(global.IsMutationActive("sacrifice") && flags & HM_DMG_REDIRECTED == 0 && damageToRedirect > 0)
        {
            BlockThingsIterator it = BlockThingsIterator.Create(self, 256);
            
            
            Array<Actor> redirectTargets;
            while (it.Next())
			{
                let currentThing = it.thing;

                // Can redirect only to alive monsters (and not self)
                if(currentThing.bISMONSTER && currentThing.health > 0 && Distance3D(currentThing) < radius && currentThing != self)
                {
                    // Can redirect :)
                    redirectTargets.Push(Actor(currentThing));
                }
			}

            if(redirectTargets.Size() > 0)
            {
                let damagePerTarget = damageToRedirect / redirectTargets.Size();
                let redirectFlags = flags | HM_DMG_REDIRECTED;

                for(let i = 0; i < redirectTargets.Size(); i++)
                {
                    redirectTargets[i].DamageMobj(self, source, damagePerTarget, mod, redirectFlags, angle); // TODO: Recalculate angle probably?
                    //console.printf("%s redirected %d damage to %s", GetClassName(), damagePerTarget, redirectTargets[i].GetClassName());
                }

                // Take the rest that wasn't redirected
                actualDamage = halvedDamage;
            }
        }

        if(global.IsMutationActive("phylactery"))
        {
            if(phylacteryTarget && phylacteryTarget.health > 0 && actualDamage > health)
            {
                actualDamage = health - 1;
            }
        }
        
        // Can't redirect, take everything
        return super.DamageMobj(inflictor, source, actualDamage, mod, flags, angle);
    }

    override void Tick()
    {
        if(health > 0 && phylacteryTarget && phylacteryTarget.health > 0 && global.IsMutationActive("phylactery"))
        {
            phylacteryTarget.Spawn(
                "HM_PhylacteryGlitter",
                phylacteryTarget.Vec3Offset(
                    random[TeleGlitter](-phylacteryTarget.radius, phylacteryTarget.radius), random[TeleGlitter](-phylacteryTarget.radius, phylacteryTarget.radius), random[TeleGlitter](0, phylacteryTarget.height)
                )
            );
        }

        super.Tick();
    }

    override bool OkayToSwitchTarget(Actor other)
    {
        if(other == phylacteryTarget && global.IsMutationActive("phylactery"))
        {
            // Do not attack phylactery target
            return false;
        }
        
        return super.OkayToSwitchTarget(other);
    }
}

class HM_PhylacteryGlitter: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +MISSILE
        Gravity -0.4;
        RenderStyle "Add";
        Damage 0;
    }
  
    States
    {
        Spawn:
            PGLT A 2 Bright A_FadeOut(0.1);
            PGLT B 2 Bright A_FadeOut(0.1);
            PGLT C 2 Bright A_FadeOut(0.1);
            PGLT D 2 Bright A_FadeOut(0.1);
            PGLT E 2 Bright A_FadeOut(0.1);
            Loop;
        Crash:
        Death:
        XDeath:
            TNT1 A 1;
            stop;
  }
}