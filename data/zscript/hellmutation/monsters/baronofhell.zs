class HM_BaronOfHell : BaronOfHell replaces BaronOfHell
{
    mixin HM_GlobalRef;
    mixin HM_HellsCaress;
    mixin HM_LordsOfDarkness;
    mixin MG_LordsOfVengeance;

    States
    {
        Melee:
        Missile:
            BOSS E 0 JumpByHealthPercentage("Attack100", "Attack75", "Attack50", "Attack25");
        Attack25:
            BOSS EF 3 A_FaceTarget;
            BOSS G 3 HM_A_BruisAttack();
            Goto See;
        Attack50:
            BOSS EF 4 A_FaceTarget;
            BOSS G 4 HM_A_BruisAttack();
            Goto See;
        Attack75:
            BOSS EF 6 A_FaceTarget;
            BOSS G 6 HM_A_BruisAttack();
            Goto See;
        Attack100:
            BOSS EF 8 A_FaceTarget;
            BOSS G 8 HM_A_BruisAttack();
            Goto See;
    }
}