class HM_BaronOfHell : HellKnight replaces HellKnight
{
    mixin HM_GlobalRef;
    mixin HM_BruisAttack;

    States
    {
        Melee:
        Missile:
            BOS2 EF 8 A_FaceTarget;
            BOS2 G 8 HM_A_BruisAttack();
            Goto See;
    }
}