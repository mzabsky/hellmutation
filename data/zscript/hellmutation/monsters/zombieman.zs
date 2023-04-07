class HM_ZombieMan : ZombieMan replaces ZombieMan
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;

    Default
    {
    }

    States
	{
         Missile:
            POSS E 0 {
                if(global.IsMutationActive("Stormtroopers")) {
                    SetState(FindState("StormTrooperMissile"));
                }
            }
            POSS E 10 A_FaceTarget;
            POSS F 8 A_PosAttack;
            POSS E 8;
            goto See;
        StormTrooperMissile:
            POSS E 10 A_FaceTarget;
            POSS F 8 A_CustomBulletAttack(5, 0, 1, random(1,5)*3, "BulletPuff", 0, CBAF_NORANDOM);
            POSS E 8;
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
}
