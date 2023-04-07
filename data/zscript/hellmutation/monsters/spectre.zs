class RH_Spectre : Spectre replaces Spectre
{
    // Copied in its entirety from HM_Demon
    mixin HM_GlobalRef;

    Default {
        Species "Demon";
    }

    States {
        Melee: 
            SARG EF 8 A_FaceTarget;
            SARG G 8 A_SargAttack;
            Goto See;
        Missile: 
            SARG E 0 {
                if(!global.IsMutationActive("Macropods")) {
                    return ResolveState("See");
                }

                return ResolveState(null);
            }
            SARG E 0 A_Jumpifcloser(100, "Melee");
            SARG E 0 A_Jumpifcloser(1000, "Pounce");
            Goto See;
        Pounce:
            SARG E 4 A_FaceTarget;
            //SARG F 0 Thrust(5000, 0);
            SARG F 10 A_SkullAttack;
            SARG G 5 A_Gravity;
            Goto See;
    }
}