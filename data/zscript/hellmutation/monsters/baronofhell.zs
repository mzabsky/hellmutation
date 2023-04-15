class HM_BaronOfHell : BaronOfHell replaces BaronOfHell
{
    mixin HM_GlobalRef;
    mixin HM_HellsCaress;
    mixin HM_LordsOfDarkness;

    States
    {
        Melee:
        Missile:
            BOS2 EF 8 A_FaceTarget;
            BOS2 G 8 HM_A_BruisAttack();
            Goto See;
    }
}