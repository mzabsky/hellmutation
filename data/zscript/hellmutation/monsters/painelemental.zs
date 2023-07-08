class HM_PainElemental: PainElemental replaces PainElemental
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;
    mixin HM_SetMaxHealth;

    Array<Actor> spawnedActors;

    States
    {
        See:
            PAIN A 0 {
                bAlwaysFast = global.IsMutationActive("dependence");

                let totalHealth = 400;
                if(global.IsMutationActive("affinity"))
                {
                    totalHealth += 1000;
                }

                HM_SetMaxHealth(totalHealth);
            }
		    PAIN AABBCC 3 FAST A_Chase;
		    Loop;
        Missile:
            PAIN D 5 FAST A_FaceTarget;
            PAIN E 5 FAST A_FaceTarget;
            PAIN F 5 FAST BRIGHT A_FaceTarget;
            PAIN F 0 FAST BRIGHT HM_A_PainAttack();
            Goto See;
        Pain:
            PAIN G 6;
            PAIN G 0 {
                if(global.IsMutationActive('obsession'))
                {
                    A_FaceTarget();
                    HM_A_PainAttack();
                }
            }
            PAIN G 6 A_Pain;
		Goto See;
        Death:
            PAIN H 8 BRIGHT;
            PAIN I 8 BRIGHT A_Scream;
            PAIN JK 8 BRIGHT;
            PAIN L 8 BRIGHT {
                if(!global.IsMutationActive("dependence"))
                {
                    HM_A_PainDie();
                }
            }
            PAIN M 8 BRIGHT;
            TNT1 A -1; // Needed to be resurrectable (for Greater Ritual)
            Stop;
        Raise:
            PAIN M 8 BRIGHT;
            PAIN L 8 BRIGHT;
            PAIN KJ 8 BRIGHT;
            PAIN I 8 BRIGHT;
            PAIN H 8 BRIGHT;
            Goto See;
        FastRaise:
            PAIN M 4 BRIGHT;
            PAIN L 4 BRIGHT;
            PAIN KJ 4 BRIGHT;
            PAIN I 4 BRIGHT;
            PAIN H 4 BRIGHT;
            Goto See;
    }

    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        // Take no damage from Regret explosions
        if(mod == 'Regret')
        {
            return 0;
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }

    // Called from global handler on death of this
    // Kills all dependent lost souls
    void DependenceDeath(Actor source)
    {
        for(let i = 0; i < spawnedActors.Size(); i++)
        {
            int newDamage;

            let spawnee = spawnedActors[i];
            if(spawnee != null)
            {
                spawnee.DamageMobj(self, source, 9999, 'Dependence', DMG_FOILINVUL);
            }
        }
    }

    // Copied over from A_PainShootSkull
    void HM_A_PainShootSkull(Class<Actor> spawntype, double angle)
    {
        // Don't spawn if we get massacred.
        if (DamageType == 'Massacre') return;

        if (spawntype == null) spawntype = "LostSoul";

        // [RH] check to make sure it's not too close to the ceiling
        if (pos.z + height + 8 > ceilingz)
        {
            if (bFloat)
            {
                Vel.Z -= 2;
                bInFloat = true;
                bVFriction = true;
            }
            return;
        }

        // Don't need the compat stuff

        // okay, there's room for another one
        double otherradius = GetDefaultByType(spawntype).radius;
        double prestep = 4 + (radius + otherradius) * 1.5;

        Vector2 move = AngleToVector(angle, prestep);
        Vector3 spawnpos = pos + (0,0,8);
        Vector3 destpos = spawnpos + move;

        Actor other = Spawn(spawntype, spawnpos, ALLOW_REPLACE);

        // Now check if the spawn is legal. Unlike Boom's hopeless attempt at fixing it, let's do it the same way
        // P_XYMovement solves the line skipping: Spawn the Lost Soul near the PE's center and then use multiple
        // smaller steps to get it to its intended position. This will also result in proper clipping, but
        // it will avoid all the problems of the Boom method, which checked too many lines that weren't even touched
        // and despite some adjustments never worked with portals.

        if (other != null)
        {
            double maxmove = other.radius - 1;

            if (maxmove <= 0) maxmove = 16;

            double xspeed = abs(move.X);
            double yspeed = abs(move.Y);

            int steps = 1;

            if (xspeed > yspeed)
            {
                if (xspeed > maxmove)
                {
                    steps = int(1 + xspeed / maxmove);
                }
            }
            else
            {
                if (yspeed > maxmove)
                {
                    steps = int(1 + yspeed / maxmove);
                }
            }

            Vector2 stepmove = move / steps;
            bool savedsolid = bSolid;
            bool savednoteleport = other.bNoTeleport;
            
            // make the PE nonsolid for the check and the LS non-teleporting so that P_TryMove doesn't do unwanted things.
            bSolid = false;
            other.bNoTeleport = true;
            for (int i = 0; i < steps; i++)
            {
                Vector2 ptry = other.pos.xy + stepmove;
                double oldangle = other.angle;
                if (!other.TryMove(ptry, 0))
                {
                    // kill it immediately
                    other.ClearCounters();
                    other.DamageMobj(self, self, TELEFRAG_DAMAGE, 'None');
                    bSolid = savedsolid;
                    other.bNoTeleport = savednoteleport;

                    if(global.IsMutationActive('regret'))
                    {                     
                        other.Spawn('HM_RefluxExplosionGenerator', other.pos);
                        other.A_Explode(40, 164, damageType: 'Regret');   
                    }

                    return;
                }

                if (other.pos.xy != ptry)
                {
                    // If the new position does not match the desired position, the player
                    // must have gone through a portal.
                    // For that we need to adjust the movement vector for the following steps.
                    double anglediff = deltaangle(oldangle, other.angle);

                    if (anglediff != 0)
                    {
                        stepmove = RotateVector(stepmove, anglediff);
                    }
                }

            }
            bSolid = savedsolid;
            other.bNoTeleport = savednoteleport;

            // [RH] Lost souls hate the same things as their pain elementals
            other.CopyFriendliness (self, true);

            spawnedActors.Push(other);

            if(global.IsMutationActive("zeal"))
            {
                let i = 0;
                // Compassion -> all the alive spawned lost souls charge    
                foreach(previouslySpawnedActor:spawnedActors)
                {
                    if(previouslySpawnedActor && previouslySpawnedActor.health > 0)
                    {
                        previouslySpawnedActor.A_SkullAttack();
                    }

                    i++;
                }
            }
            else
            {
                // No Compassion -> just the spawned lost soul charges
                other.A_SkullAttack();
            }

            // The actor might have got replaced, theoretically
            let lostSoul = HM_LostSoul(other);
            if(lostSoul != null)
            {
                lostSoul.parent = self;
            }

        }
    }

    
    void HM_A_PainAttack(class<Actor> spawntype = "LostSoul", double addangle = 0)
    {
        if (target)
        {
            A_FaceTarget();
            HM_A_PainShootSkull(spawntype, angle + addangle);
        }
    }

    void HM_A_PainDie(class<Actor> spawntype = "LostSoul")
    {
        if (target && IsFriend(target))
        { // And I thought you were my friend!
            bFriendly = false;
        }
        A_NoBlocking();
        HM_A_PainShootSkull(spawntype, angle + 90);
        HM_A_PainShootSkull(spawntype, angle + 180);
        HM_A_PainShootSkull(spawntype, angle + 270);
    }
}