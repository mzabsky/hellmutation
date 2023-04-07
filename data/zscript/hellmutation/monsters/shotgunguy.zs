class HM_ShotgunGuy: ShotgunGuy replaces ShotgunGuy
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;

    States
    {
        Death:
            POSS H 0 JumpIfDecapitation("Decapitation", null);
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
    }
}