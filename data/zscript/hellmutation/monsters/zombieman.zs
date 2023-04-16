class HM_ZombieMan : ZombieMan replaces ZombieMan
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;
    mixin HM_HighGround;

    Default
    {
    }

    States
    {
        
        See:
            POSS A 0 FAST {
                bAlwaysFast = global.IsMutationActive("Adrenaline");
            }
            POSS AABBCCDD 4 FAST A_Chase;
            Loop;
        Missile:
            POSS E 10 FAST A_FaceTarget;
            POSS F 8 FAST HM_A_PosAttack();
            POSS E 8FAST ;
            goto See;
        Death:
            POSS H 0 JumpIfDecapitation("Decapitation");
            POSS H 5;
            POSS I 5 A_Scream;
            POSS J 0 A_NoBlocking;
            POSS J 5;
            POSS K 5;
            POSS L -1;
            Stop;
        XDeath:
            POSS M 5;
            POSS N 5 A_XScream;
            POSS O 5 A_NoBlocking;
            POSS PQRST 5;
            POSS U -1;
            Stop;
        Decapitation:
            POSS H 5;
            POSS I 5;
            POSS J 0;
            POSS N 5 A_XScream;
            POSS O 5 Decapitate;
            POSS PQRST 5;
            POSS U -1;
            Stop;
    }

    void HM_A_PosAttack()
    {
        if (target)
        {
            A_FaceTarget();
            double ang = angle;
            double slope = AimLineAttack(ang, MISSILERANGE);
            A_StartSound("grunt/attack", CHAN_WEAPON);

            let spread = 22.5;
            if(global.IsMutationActive("stormtroopers"))
            {
                spread = 5;
            }

            ang  += Random2[PosAttack]() * (spread/256);
            int damage = Random[PosAttack](1, 5) * 3;
            let hasHighGround = HasHighGroundOver(target);
            if(hasHighGround)
            {
                damage += 3;
            }

            LineAttack(ang, MISSILERANGE, slope, damage, "Hitscan", "Bulletpuff");
        }
    }
}