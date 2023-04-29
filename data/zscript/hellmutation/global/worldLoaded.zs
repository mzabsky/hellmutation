extend class HM_GlobalEventHandler
{
    override void WorldLoaded(WorldEvent e) 
    {
        let detectGame = new ("HM_DetectGame");
        hasDoom2 = detectGame.HasDoom2();

        CreateMutationDefinitions();

        globalThinker = HM_GlobalThinker.Get();
        MapNumber = globalThinker.MapNumber;
        MutationStates = globalThinker.MutationStates;

        if(MutationStates == null)
        {
            MutationStates = Dictionary.Create();
        }

        int newMutationsInEffect = ChooseMutations();

        // Kleptomania
        if(IsMutationActive("kleptomania"))
        {
            for (let i = 0; i < players.Size(); i++)
            {
                if (players[i].mo != null)
                {
                    players[i].mo.TakeInventory("Cell", 9999);
                    players[i].mo.TakeInventory("RocketAmmo", 9999);
                }
            }
        }

        // Diplay the title card
        for (let i = 0; i < players.Size(); i++)
        {
            if (players[i].mo != null)
            {
                players[i].mo.ACS_NamedExecute("hm_announce", 0, globalThinker.MapNumber == 0, newMutationsInEffect);
            }
        }

        SpawnDna();

        ReplaceMonsters();
    }

    void ReplaceMonsters()
    {
        let finder = ThinkerIterator.Create("Actor");
        Actor actor;
        
        while((actor = Actor(finder.next())) != null)
        {
            if(!actor.bIsMonster)
            {
                continue;
            }

            if(actor.GetClass() == 'HM_DoomImp')
            {
                ChanceReplaceActor(actor, 'HM_ArchImp', IsMutationActive("unholylegion") ? 17 * 3 : 17); // 1 in 5 with Unholy Legion, one in 15 otherwise
            }
        }
    }
}