class HM_GlobalThinker : Thinker
{
    int MapNumber;
    Dictionary MutationStates;
    Dictionary PerkStates;

    static HM_GlobalThinker Get()
    {
        ThinkerIterator it = ThinkerIterator.Create("HM_GlobalThinker", STAT_STATIC);
        let p = HM_GlobalThinker(it.Next());
        if (!p)
        {
            p = new("HM_GlobalThinker");
            p.ChangeStatNum(STAT_STATIC);
        }

        return p;
    }
}