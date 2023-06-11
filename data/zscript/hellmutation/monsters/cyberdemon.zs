class HM_Cyberdemon : Cyberdemon replaces Cyberdemon
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;
    mixin HM_BigFuckingWomp;

    Actor triumvirateMateA;
    Actor triumvirateMateB;

    int lastScoredHitTime;

    States
    {
        Raise:
            CYBR ON 10;
            CYBR M 10;
            CYBR LKJ 10;
            CYBR I 10;
            CYBR H 10;
            Goto See;
        Missile:
            CYBR E 0 {
                if(!global.IsMutationActive("tyranny"))
                {
                    bAlwaysFast = false;
                    Speed = 16;
                    return ResolveState("Missile12");
                }

                // Only start counting after firing the first missile at the target
                // This then gets re-cleared in the global handler
                if(lastScoredHitTime == 0)
                {
                    lastScoredHitTime = Level.time;
                }

                let sinceLastHit = Level.time - lastScoredHitTime;
                let secondsPerTyrannyLevel = 10;
                if(sinceLastHit <= 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 0");
		            Speed = 16;
                    bAlwaysFast = false;
                    return ResolveState("Missile12");
                }
                else if (sinceLastHit <= 2 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 1");
		            Speed = 17;
                    bAlwaysFast = false;
                    return ResolveState("Missile11");
                }
                else if (sinceLastHit <= 3 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 2");
		            Speed = 18;
                    bAlwaysFast = false;
                    return ResolveState("Missile10");
                }
                else if (sinceLastHit <= 4 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 3");
		            Speed = 19;
                    bAlwaysFast = false;
                    return ResolveState("Missile9");
                }
                else if (sinceLastHit <= 5 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 4");
		            Speed = 20;
                    bAlwaysFast = true;
                    return ResolveState("Missile8");
                }
                else if (sinceLastHit <= 6 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 5");
		            Speed = 21;
                    bAlwaysFast = true;
                    return ResolveState("Missile7");
                }
                else if (sinceLastHit <= 7 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 6");
		            Speed = 22;
                    bAlwaysFast = true;
                    return ResolveState("Missile6");
                }
                else if (sinceLastHit <= 8 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 7");
		            Speed = 23;
                    bAlwaysFast = true;
                    return ResolveState("Missile5");
                }
                else
                {
                    //console.printf("tyranny level 8");
		            Speed = 24;
                    bAlwaysFast = true;
                    return ResolveState("Missile4");
                }
            }
        Missile12:
            CYBR E 6 A_FaceTarget;
            CYBR F 12 A_CyberAttack;
            CYBR E 12 A_FaceTarget;
            CYBR F 12 A_CyberAttack;
            CYBR E 12 A_FaceTarget;
            CYBR F 12 A_CyberAttack;
            Goto See;
        Missile11:
            CYBR E 6 A_FaceTarget;
            CYBR F 11 A_CyberAttack;
            CYBR E 11 A_FaceTarget;
            CYBR F 11 A_CyberAttack;
            CYBR E 11 A_FaceTarget;
            CYBR F 11 A_CyberAttack;
            Goto See;
        Missile10:
            CYBR E 5 A_FaceTarget;
            CYBR F 10 A_CyberAttack;
            CYBR E 10 A_FaceTarget;
            CYBR F 10 A_CyberAttack;
            CYBR E 10 A_FaceTarget;
            CYBR F 10 A_CyberAttack;
            Goto See;
        Missile9:
            CYBR E 5 A_FaceTarget;
            CYBR F 9 A_CyberAttack;
            CYBR E 9 A_FaceTarget;
            CYBR F 9 A_CyberAttack;
            CYBR E 9 A_FaceTarget;
            CYBR F 9 A_CyberAttack;
            Goto See;
        Missile8:
            CYBR E 4 A_FaceTarget;
            CYBR F 8 A_CyberAttack;
            CYBR E 8 A_FaceTarget;
            CYBR F 8 A_CyberAttack;
            CYBR E 8 A_FaceTarget;
            CYBR F 8 A_CyberAttack;
            Goto See;
        Missile7:
            CYBR E 4 A_FaceTarget;
            CYBR F 7 A_CyberAttack;
            CYBR E 7 A_FaceTarget;
            CYBR F 7 A_CyberAttack;
            CYBR E 7 A_FaceTarget;
            CYBR F 7 A_CyberAttack;
            Goto See;
        Missile6:
            CYBR E 3 A_FaceTarget;
            CYBR F 6 A_CyberAttack;
            CYBR E 6 A_FaceTarget;
            CYBR F 6 A_CyberAttack;
            CYBR E 6 A_FaceTarget;
            CYBR F 6 A_CyberAttack;
            Goto See;
        Missile5:
            CYBR E 3 A_FaceTarget;
            CYBR F 5 A_CyberAttack;
            CYBR E 5 A_FaceTarget;
            CYBR F 5 A_CyberAttack;
            CYBR E 5 A_FaceTarget;
            CYBR F 5 A_CyberAttack;
            Goto See;
        Missile4:
            CYBR E 2 A_FaceTarget;
            CYBR F 4 A_CyberAttack;
            CYBR E 4 A_FaceTarget;
            CYBR F 4 A_CyberAttack;
            CYBR E 4 A_FaceTarget;
            CYBR F 4 A_CyberAttack;
            Goto See;
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if(other == triumvirateMateA || other == triumvirateMateB)
        {
            return false;
        }

        return super.CanCollideWith(other, passive);
    }
}

class HM_Rocket : Rocket replaces Rocket
{
    mixin HM_GlobalRef;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("HyperFuel") && !(target is "PlayerPawn"))
        {
            A_ScaleVelocity(2);
        }
    }
}