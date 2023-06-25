class HM_ChaingunGuy: ChaingunGuy replaces ChaingunGuy
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;
    mixin HM_HighGround;

    bool hadShield;
    bool hasShield;
    int shieldStartTime;


    States
    {
        See:
            CPOS A 0 {
                let hasRapidSpin = global.IsMutationActive("rapidspin");
                bAlwaysFast = hasRapidSpin;
                A_SetSpeed(hasRapidSpin ? 10 : 8);
            }
            CPOS AABBCCDD 3 FAST A_Chase;
            Loop;
        Missile:
            CPOS E 0 {
                if(target && target is "PlayerPawn" && !hadShield && !hasShield && global.IsMutationActive("ambushshield"))
                {
                    shieldStartTime = Level.time;
                    hasShield = true;
                    hadShield = true;
                    A_SetTranslation("Ice");
                    bInvulnerable = true;
                }
            }
            CPOS E 10 FAST A_FaceTarget;
        ReMissile:
            CPOS FE 4 BRIGHT HM_A_CPosAttack();
            CPOS F 1 A_CPosRefire;
            Goto ReMissile;
        Death:
            CPOS H 0 JumpIfDecapitation("Decapitation");
            CPOS H 5;
            CPOS I 5 A_Scream;
            CPOS J 5 A_NoBlocking;
            CPOS KLM 5;
            CPOS N -1;
            Stop;
        Decapitation:
            CPOS H 5;
            CPOS I 5;
            CPOS J 5;
            CPOS P 5 A_XScream;
            CPOS Q 5 Decapitate;
            CPOS RS 5;
            CPOS T -1;
            Stop;
        FastRaise:
            CPOS N 3;
            CPOS MLKJIH 3;
            Goto See;
    }

    override void Tick()
    {
        if(hasShield && Level.time - shieldStartTime > 35 * 3)
        {
            shieldStartTime = Level.time;
            hasShield = false;
            hadShield = true;
            A_SetTranslation("");
            bInvulnerable = false;
        }

        super.Tick();
    }

    void HM_A_CPosAttack()
    {
        if (target)
        {
            if (bStealth) visdir = 1;
            A_StartSound(AttackSound, CHAN_WEAPON);
            A_FaceTarget();
            double slope = AimLineAttack(angle, MISSILERANGE);
            double ang = angle + Random2[CPosAttack]() * (22.5/256);
            int damage = Random[CPosAttack](1, 5) * 3;
            let hasHighGround = HasHighGroundOver(target);
            if(hasHighGround)
            {
                damage += 1;
            }


            if(global.IsMutationActive("torrentcannons"))
            {
                if(hasHighGround)
                {
                    LineAttack(ang, MISSILERANGE, slope, 0, "Hitscan", "HM_HighGroundTorrentExplosion");
                }
                else
                {
                    LineAttack(ang, MISSILERANGE, slope, 0, "Hitscan", "HM_TorrentExplosion");
                }
            }
            else
            {
                LineAttack(ang, MISSILERANGE, slope, DAMAGE, "Hitscan", "BulletPuff");
            }
        }
    }
}