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
		  //if (e.thing) // Check that the Actor is valid
			//  console.printf("SPAWNED %s", e.thing.GetClassName());
       if(e.thing is "PlayerPawn") {
          console.printf("PLAYER PAWN SPAWNED %s", e.thing.GetClassName());

          e.thing.ACS_NamedExecute("hm_hud", 0);
       }
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
    
    override void PlayerEntered(PlayerEvent e)
    {
        console.printf("PLAYER RESPAWNED");
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

        let firstDnaPlace = FindPlaceForFirstDna();
        if(firstDnaPlace != null)
        {
            firstDnaPlace.Spawn("HM_Dna", firstDnaPlace.Vec3Offset(0, 0, 32), ALLOW_REPLACE);
            console.printf("Spawned first DNA.");
        }
        else
        {
            console.printf("Could not find place to spawn first DNA.");
        }

        let secondDnaPlace = FindPlaceForSecondDna();
        if(secondDnaPlace != null)
        {
            secondDnaPlace.Spawn("HM_Dna", secondDnaPlace.Vec3Offset(0, 0, 32), ALLOW_REPLACE);
            console.printf("Spawned second DNA.");
        }
        else
        {
            console.printf("Could not find place to spawn second DNA.");
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

    private Actor FindPlaceForFirstDna()
    {
        let finder = ThinkerIterator.Create("MegasphereHealth");
        let actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Soulsphere");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("BFG9000");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("PlasmaRifle");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("RocketLauncher");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        return null;
    }

    private Actor FindPlaceForSecondDna()
    {
        let finder = ThinkerIterator.Create("Shotgun");
        let actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Chaingun");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("SuperShotgun");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Medikit");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Stimpack");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        return null;
    }
}
