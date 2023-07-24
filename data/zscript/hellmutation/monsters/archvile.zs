class HM_ArchVile : ArchVile replaces ArchVile
{
    mixin HM_GlobalRef;
    mixin HM_SacrificeAndPhylactery;
    mixin HM_GreaterRitual;

    States
    {
        See:
		    VILE AABBCCDDEEFF 2 ResurrectChase(false);
		    Loop;
        Raise:
            VILE YXWVUT 7;
            VILE S 7;
            VILE R 7;
            VILE Q 7;
            Goto See;
        FastRaise:
            VILE YXWVUT 4;
            VILE S 4;
            VILE R 4;
            VILE Q 4;
            Goto See;
        Missile:
            VILE G 0 BRIGHT A_VileStart;
            VILE G 10 BRIGHT A_FaceTarget;
            VILE H 8 BRIGHT A_VileTarget;
            VILE IJKLMN 8 BRIGHT A_FaceTarget;
            VILE O 8 BRIGHT HM_A_VileAttack;
            VILE P 20 BRIGHT;
            Goto See;
        Heal:
            VILE [ 0 {
                if(global.IsMutationActive("rushedritual"))
                {
                    return ResolveState("FastHeal");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            VILE [\ 10 BRIGHT;
            VILE ] 0 {
                if(global.IsMutationActive("odiousritual"))
                {
                    return ResolveState("ReHeal");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            VILE ] 10 BRIGHT;
            Goto See;
        FastHeal:
            VILE [\ 5 BRIGHT;
            VILE ] 0 {
                if(global.IsMutationActive("odiousritual"))
                {
                    return ResolveState("ReHeal");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            VILE ] 5 BRIGHT;
            Goto See;
        ReHeal:
            VILE \ 30 BRIGHT;
            VILE \ 10 BRIGHT ResurrectChase(true);
            VILE ] 10 BRIGHT;
            Goto See;
        FastReHeal:
            VILE \ 15 BRIGHT;
            VILE \ 5 BRIGHT ResurrectChase(true);
            VILE ] 10 BRIGHT;
            Goto See;
    }

    void ResurrectChase(bool isReHeal)
    {
        //if(global.IsMutationActive("reachingritual"))
        {
            let range = 386;
            BlockThingsIterator it = BlockThingsIterator.Create(self, range);
            Actor mo;
            while (it.Next())
            {
                mo = it.thing;
                if (!mo || mo == self || !mo.bIsMonster || mo.health > 0 || (!CheckSight(mo) && !global.IsMutationActive("aethericritual")) || !mo.CanRaise())
                {
                    continue;
                }

                let actualRange = radius + mo/*.GetDefault()*/.radius + 30; // I'm not sure why the 30 is necessary...
                if(global.IsMutationActive("reachingritual"))
                {
                    actualRange = range;
                }
                else if(isReHeal)
                {
                    actualRange += 50; // Give Odious Ritual some more space to work with on reheals, so that the raising can continue
                }

                // This is the way P_CheckForResurrection does things
                let manhattanDist = min(
                    abs(pos.x - mo.pos.x),
                    abs(pos.y - mo.pos.y)
                );

                if(Distance3D(mo) > actualRange)
                {
                    //console.printf("out of range %d %d (%d/%d vs. %d/%d)", Distance3D(mo), actualRange, pos.x, pos.y, mo.pos.x, mo.pos.y);
                    continue;
                }

                let oldSolid = mo.bSolid;
                if(RaiseActor(mo))
                {
                    A_Face(mo);
                    SetState(ResolveState("Heal"));

                    mo.target = target;

                    if(global.IsMutationActive("rushedritual"))
                    {
                        let fastRaiseState = mo.ResolveState("FastRaise");
                        if(fastRaiseState)
                        {
                            mo.SetState(fastRaiseState);
                        }
                        mo.health /= 2;
                    }

                    phylacteryTarget = mo;
                    lastPhylacteryTime = Level.Time;

                    if(isReHeal)
                    {
                        if(global.IsMutationActive("rushedritual"))
                        {
                            SetState(ResolveState("FastReHeal"));
                        }
                        else
                        {
                            SetState(ResolveState("ReHeal"));
                        }
                    }
                    return;
                }
                else
                {
                    // P_Thing_Raise in C++ makes the corpse solid before calling CanResurrect, for some reason
                    mo.bSolid = oldSolid;
                }
            }
        }

        A_Chase();
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
                if(global.IsMutationActive("sirenicgaze"))
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

        if(global.IsMutationActive('scorchinggaze'))
        {
            dest.DamageMobj(self, target, 1, 'fire', DMG_THRUSTLESS);
        }

        if(global.IsMutationActive('borealgaze') && dest is 'HM_Player')
        {
            let hmPlayer = HM_Player(dest);
            //console.printf("%d vile apply boreal %d", Level.Time, hmPlayer.lastBorealGazeTime);
            if(hmPlayer.lastBorealGazeTime >= Level.Time - 4)
            {
                hmPlayer.borealGazeTicks+=2;
            }
            else
            {
                //console.printf("%d vile new boreal", Level.Time);
                hmPlayer.borealGazeTicks = 2;
            }

            hmPlayer.lastBorealGazeTime = Level.Time;
            //console.printf("%d vile final %d %d", Level.Time, hmPlayer.lastBorealGazeTime, hmPlayer.borealGazeTicks );
        }
    }
}