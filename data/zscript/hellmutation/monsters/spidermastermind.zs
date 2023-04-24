class HM_SpiderMastermind: SpiderMastermind replaces SpiderMastermind
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;

    States
    {
        Raise:
            SPID RQPONML 10;
            SPID K 10;
            SPID J 20;
            Goto See;
    }
}