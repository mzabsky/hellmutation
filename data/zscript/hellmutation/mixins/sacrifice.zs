enum HM_EDmgFlags
{
	HM_DMG_REDIRECTED = 1 << 30
}

// Implements damage redirection for Sacrifice mutation
mixin class HM_Sacrifice
{
    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        let newDamage = damage / 2;
        let damageToRedirect = damage - newDamage;
        let radius = 256;

        // TODO: Check flags for some special damage flags
        // Can't redirect redirected damage
        if(global.IsMutationActive("sacrifice") && flags & HM_DMG_REDIRECTED == 0 && damageToRedirect > 0) {
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
                    console.printf("%s redirected %d damage to %s", GetClassName(), damagePerTarget, redirectTargets[i].GetClassName());
                }

                // Take the rest that wasn't redirected
                super.DamageMobj(inflictor, source, newDamage, mod, flags, angle);
                console.printf("%s took leftover damage 5d", GetClassName(), newDamage);
                return newDamage;
            }
        }

        // Can't redirect, take everything
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}