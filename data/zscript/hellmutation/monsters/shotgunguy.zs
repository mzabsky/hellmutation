class HM_ShotgunGuy: ShotgunGuy replaces ShotgunGuy
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;
    mixin HM_HighGround;

    States
    {
        See:
            SPOS A 0 {
                bAlwaysFast = global.IsMutationActive("Adrenaline");
            }
            SPOS AABBCCDD 3 A_Chase;
            Loop;
        Missile:
            SPOS E 10 A_FaceTarget;
            SPOS F 10 BRIGHT HM_A_SposAttackUseAtkSound();
            SPOS E 10;
            Goto See;
        Death:
            POSS H 0 JumpIfDecapitation("Decapitation");
            SPOS H 5;
            SPOS I 5 A_Scream;
            SPOS J 5 A_NoBlocking;
            SPOS K 5;
            SPOS L -1;
            Stop;
        Decapitation:
            SPOS H 5;
            SPOS I 5;
            SPOS J 5;
            SPOS N 5 A_XScream;
            SPOS O 5 Decapitate;
            SPOS PQRST 5;
            SPOS U -1;
            Stop;
        FastRaise:
            SPOS L 3;
            SPOS KJIH 3;
            Goto See;
    }

    void HM_A_SPosAttackUseAtkSound()
    {
        if (target)
        {
            A_StartSound(AttackSound, CHAN_WEAPON);
            HM_A_SPosAttackInternal();
        }
    }

    private void HM_A_SPosAttackInternal()
    {
        if (target)
        {
            A_FaceTarget();
            double bangle = angle;
            double slope = AimLineAttack(bangle, MISSILERANGE);
        
            let hasHighGround = HasHighGroundOver(target);
            for (int i=0 ; i<3 ; i++)
            {
                double ang = bangle + Random2[SPosAttack]() * (22.5/256);
                int damage = Random[SPosAttack](1, 5) * 3;
                if(hasHighGround)
                {
                    damage += 3;
                }

                LineAttack(ang, MISSILERANGE, slope, damage, "Hitscan", "Bulletpuff");
            }
        }
    }
}