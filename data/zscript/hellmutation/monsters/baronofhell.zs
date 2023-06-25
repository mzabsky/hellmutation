class HM_BaronOfHell : BaronOfHell replaces BaronOfHell
{
    mixin HM_GlobalRef;
    mixin HM_BruisAttack;
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
        FastRaise:
            BOSS O 4;
            BOSS NMLKJI 4;
            Goto See;
    }
}

class HM_BaronBall : BaronBall replaces BaronBall
{
    mixin HM_GlobalRef;

    override bool CanCollideWith(Actor other, bool passive)
    {
        // Lords of Reality - baron balls can pass through barons and hell knights.
        if((other is 'BaronOfHell' || other is 'HellKnight') && global.IsMutationActive("lordsofreality"))
        {
            return false;
        }

        return super.CanCollideWith(other, passive);
    }
}