class HM_ArchVile : ArchVile replaces ArchVile
{
    mixin HM_GlobalRef;
    mixin HM_Sacrifice;
    mixin HM_GreaterRitual;
    
    States
    {
        Raise:
            VILE YXWVUT 7;
            VILE S 7;
            VILE R 7;
            VILE Q 7;
            Goto See;
    }
}