class HM_PainElemental: PainElemental replaces PainElemental
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;

    States
    {
        Death:
            PAIN H 8 BRIGHT;
            PAIN I 8 BRIGHT A_Scream;
            PAIN JK 8 BRIGHT;
            PAIN L 8 BRIGHT A_PainDie;
            PAIN M 8 BRIGHT;
            TNT1 A -1; // Needed to be resurrectable (for Greater Ritual)
            Stop;
            Stop;
        Raise:
            PAIN M 8 BRIGHT;
            PAIN L 8 BRIGHT;
            PAIN KJ 8 BRIGHT;
            PAIN I 8 BRIGHT;
            PAIN H 8 BRIGHT;
            Goto See;
    }
}