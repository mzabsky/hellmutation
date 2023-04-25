mixin class MG_LordsOfVengeance
{
    state JumpByHealthPercentage(StateLabel pct100, StateLabel pct75, StateLabel pct50, StateLabel pct25)
    {
        if(!global.IsMutationActive("lordsofvengeance"))
        {
            return ResolveState(pct100);
        }

        let healthPercentage = health * 100 / spawnhealth();
        if(healthPercentage < 100)
        {
            bAlwaysFast = true;
        }

        if(healthPercentage < 25)
        {
            return ResolveState(pct25);
        }
        else if(healthPercentage < 50)
        {
            return ResolveState(pct50);
        }
        else if(healthPercentage < 75)
        {
            return ResolveState(pct75);
        }
        else
        {
            return ResolveState(pct100);
        }
    }
}