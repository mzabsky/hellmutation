class HM_ArchVile : ArchVile replaces ArchVile
{
    mixin HM_GlobalRef;
    mixin HM_Sacrifice;
    mixin HM_GreaterRitual;
    
    States
    {
        See:
		    VILE AABBCCDDEEFF 2 DoReachingRitual;
		    Loop;
        Raise:
            VILE YXWVUT 7;
            VILE S 7;
            VILE R 7;
            VILE Q 7;
            Goto See;
        Missile:
            VILE G 0 BRIGHT A_VileStart;
            VILE G 10 BRIGHT A_FaceTarget;
            VILE H 8 BRIGHT A_VileTarget;
            VILE IJKLMN 8 BRIGHT A_FaceTarget;
            VILE O 8 BRIGHT HM_A_VileAttack;
            VILE P 20 BRIGHT;
            Goto See;
    }

    void DoReachingRitual()
    {
        if(global.IsMutationActive("reachingritual"))
        {
            let range = 386;
            BlockThingsIterator it = BlockThingsIterator.Create(self, range);
            Actor mo;

            while (it.Next())
            {
                mo = it.thing;
                if (!mo || !mo.bIsMonster || mo.health > 0 || Distance3D(mo) > range || !CheckSight(mo) || !mo.CanRaise())
                {
                    continue;
                }

                if(RaiseActor(mo))
                {
                    A_Face(mo);
                    SetState(ResolveState("Heal"));
                }
            }
        }

        A_VileChase();
    }

    void HM_A_VileAttack(sound snd = "vile/stop", int initialdmg = 20, int blastdmg = 70, int blastradius = 70, double thrust = 1.0, name damagetype = "Fire", int flags = 0)
    {
        Actor targ = target;
        if (targ)
        {
            A_FaceTarget();
            if (!CheckSight(targ, 0)) return;
            A_StartSound(snd, CHAN_WEAPON);
            int newdam = targ.DamageMobj (self, self, initialdmg, (flags & VAF_DMGTYPEAPPLYTODIRECT)? damagetype : 'none');

            targ.TraceBleed (newdam > 0 ? newdam : initialdmg, self);
            
            Actor fire = tracer;
            if (fire)
            {
                // move the fire between the vile and the player
                fire.SetOrigin(targ.Vec3Angle(-24., angle, 0), true);
                fire.A_Explode(blastdmg, blastradius, XF_NOSPLASH, false, 0, 0, 0, "BulletPuff", damagetype);
            }
            if (!targ.bDontThrust)
            {
                if(global.IsMutationActive("tractorspell"))
                {
                    // Pull towards the caster
                    let to = Vec3To(targ);
                    targ.Vel.x = -to.x / 50;
                    targ.Vel.y = -to.y / 50;
                    targ.Vel.z = thrust * 1700 / max(1, targ.Mass);    
                }
                else {
                    targ.Vel.z = thrust * 1000 / max(1, targ.Mass);
                }
            }
        }
    }
}

class HM_ArchvileFire : ArchvileFire replaces ArchvileFire
{
    mixin HM_GlobalRef;

    States
    {
        Spawn:
            FIRE A 2 BRIGHT  A_StartFire;
            FIRE BAB 2 BRIGHT  HM_A_Fire;
            FIRE C 2 BRIGHT  A_FireCrackle;
            FIRE BCBCDCDCDEDED 2 BRIGHT  HM_A_Fire;
            FIRE E 2 BRIGHT  A_FireCrackle;
            FIRE FEFEFGHGHGH 2 BRIGHT  HM_A_Fire;
            Stop;
    }

    void HM_A_Fire(double spawnheight = 0)
    {
        Actor dest = tracer;
        if (!dest || !target) return;
                
        // don't move it if the vile lost sight
        if (!target.CheckSight (dest, 0) ) return;

        SetOrigin(dest.Vec3Angle(24, dest.angle, spawnheight), true);

        if(global.IsMutationActive('searinggaze'))
        {
            dest.DamageMobj(self, target, 1, 'fire', DMG_THRUSTLESS);
        }
    }
}