class HM_GlobalThinker : Thinker
{
    Dictionary RemovedMutations;

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


class HM_GlobalEventHandler : EventHandler
{
    Dictionary RemovedMutations;
    HM_GlobalThinker globalThinker;

    override void NewGame()
    {
        globalThinker = HM_GlobalThinker.Get();
        RemovedMutations = Dictionary.Create();
    }

    override void WorldThingDied(WorldEvent e)
    {
		//if (e.thing) // Check that the Actor is valid
		//	console.printf("%s DIED", e.thing.GetClassName());
    }

	  override void WorldThingSpawned(WorldEvent e)
	  {
		  if (e.thing) // Check that the Actor is valid
			  console.printf("SPAWNED %s", e.thing.GetClassName());
	  }

    override void NetworkProcess(consoleevent e)
    {
        if (e.name.IndexOf("HM_RemoveMutation:") >= 0) // sent by DNA menu
        {
            Array <String> parts;
			e.name.split(parts, ":");

            let mutationName = parts[1];
            console.printf("REMOVED MUTATION %s", mutationName);

            RemovedMutations.Insert(mutationName, "1");
        }
    }

    override void WorldUnloaded(WorldEvent e) 
    {
        console.printf("World unloaded");
        globalThinker.RemovedMutations = RemovedMutations;
        console.printf("World unloaded");
    }

    override void WorldLoaded(WorldEvent e) 
    {
        console.printf("World Loaded");
        globalThinker = HM_GlobalThinker.Get();
        RemovedMutations = globalThinker.RemovedMutations;
        if(RemovedMutations == null)
        {
            RemovedMutations = Dictionary.Create();
        }

        console.printf("World Loaded");
    }
    
    clearscope bool IsMutationRemoved(string mutationName)
    {
        let foundValue = RemovedMutations.At(mutationName);
        let isRemoved = foundValue == "1";

        console.printf("IS MUTATION REMOVED %s %i", mutationName, isRemoved);
        return isRemoved;
    }
}
