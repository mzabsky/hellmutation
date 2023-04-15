class HM_HellKnight : HellKnight replaces HellKnight
{
    mixin HM_GlobalRef;
    mixin HM_HellsCaress;
    mixin HM_LordsOfDarkness;

    States
    {
        Melee:
        Missile:
            BOSS EF 8 A_FaceTarget;
            BOSS G 8 HM_A_BruisAttack();
            Goto See;
    }
}