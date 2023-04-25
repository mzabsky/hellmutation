class HM_HellKnight : HellKnight replaces HellKnight
{
    mixin HM_GlobalRef;
    mixin HM_HellsCaress;
    mixin HM_LordsOfDarkness;
    mixin MG_LordsOfVengeance;

    States
    {
        Melee:
        Missile:
            BOS2 E 0 JumpByHealthPercentage("Attack100", "Attack75", "Attack50", "Attack25");
        Attack25:
            BOS2 EF 3 A_FaceTarget;
            BOS2 G 3 HM_A_BruisAttack();
            Goto See;
        Attack50:
            BOS2 EF 4 A_FaceTarget;
            BOS2 G 4 HM_A_BruisAttack();
            Goto See;
        Attack75:
            BOS2 EF 6 A_FaceTarget;
            BOS2 G 6 HM_A_BruisAttack();
            Goto See;
        Attack100:
            BOS2 EF 8 A_FaceTarget;
            BOS2 G 8 HM_A_BruisAttack();
            Goto See;
    }
}