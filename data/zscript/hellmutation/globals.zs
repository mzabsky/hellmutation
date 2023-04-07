class HM_GlobalThinker : Thinker
{
    int MapNumber;
    Dictionary ActiveMutations;

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
    // This could be better done with associative arrays, once their const methods are in stable version
    Array<HM_MutationDefinition> mutationDefinitions;

    int MapNumber;
    Dictionary ActiveMutations;
    Array<string> MutationRemovalsOnOffer;

    HM_GlobalThinker globalThinker;

    override void NewGame()
    {
        MapNumber = 0;
        ActiveMutations = Dictionary.Create();
        //MutationRemovalsOnOffer = new Array<string>();
    }

    override void PlayerSpawned (PlayerEvent e)
    {
        //console.printf("PLAYER SPAWNED %d", e.playerNumber);
		    //if (e.thing) // Check that the Actor is valid
			  //  console.printf("SPAWNED %s", e.thing.GetClassName());

        players[e.playerNumber].mo.ACS_NamedExecute("hm_hud", 0);
    }

    override void NetworkProcess(consoleevent e)
    {
        if (e.name.IndexOf("HM_RemoveMutation:") >= 0) // sent by DNA menu
        {
            Array <String> parts;
			      e.name.split(parts, ":");

            let playerNumber = e.args[0];
            let mutationName = parts[1];
            console.printf("%s REMOVED MUTATION %s", players[playerNumber].GetUserName(), mutationName);
            ActiveMutations.Insert(mutationName, "0");

            let playerPawn = players[playerNumber].mo;
            playerPawn.TakeInventory("HM_Dna", 1);
        }
    }

    override void WorldLoaded(WorldEvent e) 
    {
        CreateMutationDefinitions();

        globalThinker = HM_GlobalThinker.Get();
        MapNumber = globalThinker.MapNumber;
        ActiveMutations = globalThinker.ActiveMutations;

        //console.printf("WORLD LOADED MAP %d", MapNumber);

        if(ActiveMutations == null)
        {
            ActiveMutations = Dictionary.Create();
        }

        int newMutationsInEffect = 0;
        for (let i = 0; i < MutationDefinitions.Size(); i++)
        {
            let mutationDefinition = MutationDefinitions[i];
            if(mutationDefinition.MapNumber != MapNumber)
            {
                continue;
            }

            MutationRemovalsOnOffer.Push(mutationDefinition.Key);
            ActiveMutations.Insert(mutationDefinition.Key, "1");

            newMutationsInEffect++;
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
    }

    override void WorldUnloaded(WorldEvent e) 
    {
        //console.printf("WORLD UNLOADED MAP %d", MapNumber);

        MapNumber++;

        globalThinker.MapNumber = MapNumber;
        globalThinker.ActiveMutations = ActiveMutations;
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        // Insomnia
        if(e.thing.bIsMonster && players.Size() > 0 && players[0].mo != null && IsMutationActive("Insomnia"))
        {
            e.thing.target = players[0].mo;
            e.thing.A_AlertMonsters();
        }
    }

    override void WorldThingDamaged(WorldEvent e)
    {
        //console.printf("Thing damaged: %s, Health: %d", e.thing.GetClassName(), e.thing.health);

        // Hematophagy
        if(e.inflictor is "Demon" && IsMutationActive("Hematophagy"))
        {
            e.inflictor.A_ResetHealth();
        }

        if(e.thing is "PlayerPawn")
        {
            console.printf("Player was damaged by %s", e.inflictor.GetClassName());

            // Desecration - player was damaged by an imp fireball
            if(e.inflictor is "DoomImpBall" && e.inflictor.target != null && IsMutationActive("Desecration"))
            {
                ReplaceActor(e.inflictor.target, "HM_ArchImp", e.thing);
            }
            
            // Desecration - player was damaged by imp melee attack
            if(e.inflictor is "DoomImp" && IsMutationActive("Desecration"))
            {
                ReplaceActor(e.inflictor, "HM_ArchImp", e.thing);
            }
        }
    }
    
    clearscope bool IsMutationRemoved(string mutationName)
    {
        let foundValue = ActiveMutations.At(mutationName);
        let isRemoved = foundValue != "1";

        //console.printf("IS MUTATION REMOVED %s %i", mutationName, isRemoved);
        return isRemoved;
    }
    
    clearscope bool IsMutationActive(string mutationName)
    {
        let foundValue = ActiveMutations.At(mutationName);
        let isActive = foundValue == "1";

        //console.printf("IS MUTATION ACTIVE %s %i", mutationName, isActive);
        return isActive;
    }

    clearscope void GetMutationRemovalOnOffer(int index, out HM_MutationDefinition mutationDefinition) const
    {
        let mutationKey = MutationRemovalsOnOffer[index];
        for(let i = 0; i < MutationDefinitions.Size(); i++)
        {
            let currentMutationDefinition = MutationDefinitions[i];
            if(currentMutationDefinition.Key == mutationKey)
            {
                mutationDefinition = currentMutationDefinition;
                return;
            }
        }
    }

    clearscope int GetMutationRemovalOnOfferCount() const
    {
        return MutationRemovalsOnOffer.Size();
    }
}
