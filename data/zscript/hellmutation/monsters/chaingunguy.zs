class HM_ChaingunGuy: ChaingunGuy replaces ChaingunGuy
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;

    bool hadShield;
    bool hasShield;
    int shieldStartTime;

    States
    {
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
            CPOS E 10 A_FaceTarget;
        ReMissile:
            CPOS FE 4 BRIGHT A_CPosAttack;
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
}