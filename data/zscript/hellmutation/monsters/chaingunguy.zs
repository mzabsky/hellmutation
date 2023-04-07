class HM_ChaingunGuy: ChaingunGuy replaces ChaingunGuy
{
    mixin HM_GlobalRef;
    mixin HM_Decapitable;
    States
    {
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
}