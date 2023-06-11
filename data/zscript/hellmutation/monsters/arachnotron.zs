class HM_Arachnotron: Arachnotron replaces Arachnotron
{
    mixin HM_GlobalRef;

    int lastFireTime;
    int rampNumber;

    Default
    {
        Species "Arachnotron";
    }

    States
    {
        See:
            BSPI A 20;
            BSPI A 0 {
                if(global.IsMutationActive("argenthydraulics"))
                {
                    Speed = 24;
                    return ResolveState("FastSee");
                }
                else {
                    Speed = 12;
                    return ResolveState(null);
                }
            }
            BSPI A 3 A_BabyMetal;
            BSPI ABBCC 3 A_Chase;
            BSPI D 3 A_BabyMetal;
            BSPI DEEFF 3 A_Chase;
            Goto See+1;
        FastSee:
            BSPI A 2 A_BabyMetal;
            BSPI ABBCC 2 A_Chase;
            BSPI D 2 A_BabyMetal;
            BSPI DEEFF 2 A_Chase;
            Goto See+1;
        Missile:
            BSPI A 0 {
                rampNumber = 0;
            }
            BSPI A 20 A_FaceTarget;
        InstantMissile:
            BSPI G 0 {
                if(!global.IsMutationActive("overwhelmingfire"))
                {
                    return ResolveState(null);
                }

                if(rampNumber >= 38)
                {
                    return ResolveState("InstantMissile4");
                }
                else if(rampNumber >= 12)
                {
                    return ResolveState("InstantMissile3");
                }
                else if(rampNumber >= 4)
                {
                    return ResolveState("InstantMissile2");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            BSPI G 4 BRIGHT HM_A_BspiAttack();
            BSPI H 4 ;
            BSPI H 1 A_SpidRefire;
            Goto InstantMissile;
        InstantMissile2:
            BSPI G 3 BRIGHT HM_A_BspiAttack();
            BSPI H 3 ;
            BSPI H 1 A_SpidRefire;
            Goto InstantMissile;
        InstantMissile3:
            BSPI G 2 BRIGHT HM_A_BspiAttack();
            BSPI H 2 ;
            BSPI H 1 A_SpidRefire;
            Goto InstantMissile;
        InstantMissile4:
            BSPI G 1 BRIGHT HM_A_BspiAttack();
            BSPI H 1 ;
            BSPI H 1 A_SpidRefire;
            Goto InstantMissile;
    }

    void HM_A_BspiAttack()
    {
        // Do not fire more than once in each frame (for case with cyberneuralreflexes)
        if(lastFireTime == Level.time)
        {
            return;
        }

        if (target)
        {
            A_FaceTarget();
            let missile = SpawnMissile(target, "ArachnotronPlasma");
            if(missile)
            {
                if(global.IsMutationActive("extendedaccelerators"))
                {
                    missile.A_ScaleVelocity(2);
                }

                if(global.IsMutationActive("hypercognition"))
                {
                    missile.VelIntercept(target);
                }
            }

            lastFireTime = Level.time;
            rampNumber++;
        }
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        // arachnotrons can't enter pain states if they are to fire back
        // the actual trigger to do the counterattack is in WorldThingDamaged
        if(global.IsMutationActive("cyberneuralreflexes"))
        {
            flags = flags | DMG_NO_PAIN;
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}