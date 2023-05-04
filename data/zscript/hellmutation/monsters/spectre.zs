class HM_Spectre : Spectre replaces Spectre
{
    // Copied in its entirety from HM_Demon
    mixin HM_GlobalRef;
    mixin HM_Macropods;
    mixin HM_Unstoppable;

    Default
    {
        Species "Demon";
    }

    States
    {
        See:
            SARG A 0 {
                bAlwaysFast = global.IsMutationActive("rage");
            }
            SARG A 0 UpdatePainThreshold();
            SARG AABBCCDD 2 Fast A_PounceChase;
            Loop;
        Melee: 
            SARG EF 8 A_FaceTarget;
            SARG G 8 A_SargAttack;
            Goto See;
        Pounce:
            SARG E 4 A_FaceTarget;
            //SARG F 0 Thrust(5000, 0);
            SARG F 10 A_SkullAttack;
            SARG G 5 A_Gravity;
            Goto See;
    }
}