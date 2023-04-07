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
        let commandName = e.name.MakeLower();
        if (commandName.IndexOf("hm_remove:") >= 0) // sent by DNA menu
        {
            Array <String> parts;
			      commandName.split(parts, ":");

            let playerNumber = e.args[0];
            let mutationName = parts[1];

            if(IsMutationActive(mutationName))
            {
                console.printf("%s removed mutation %s", players[playerNumber].GetUserName(), mutationName);
                ActiveMutations.Insert(mutationName, "0");

                let playerPawn = players[playerNumber].mo;
                playerPawn.TakeInventory("HM_Dna", 1);

                for (let i = 0; i < players.Size(); i++)
                {
                    if (players[i].mo != null)
                    {
                        players[i].mo.ACS_NamedExecute("hm_mutationremoved");
                    }
                }
            }
            else
            {
                console.printf("%s is not an active mutation.", mutationName);
            }
        }
        else if (commandName.IndexOf("hm_add:") >= 0)
        {
            Array <String> parts;
            commandName.split(parts, ":");

            let mutationName = parts[1];

            bool found = false;
            for(let i = 0; i < mutationDefinitions.Size(); i++)
            {
                if (mutationDefinitions[i].Key != mutationName)
                {
                    continue;
                }

                found = true;
                break;
            }

            if(found)
            {

                let playerNumber = e.args[0];
                console.printf("%s added mutation %s", players[playerNumber].GetUserName(), mutationName);
                ActiveMutations.Insert(mutationName, "1");
            }
            else
            {
                console.printf("Unknown mutation %s", mutationName);
            }
        }
        else
        {
            console.printf("Unknown net command: %s", commandName);
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
        if (e.damageSource == null)
        {
            return;    
        }

        //console.printf("Thing damaged: %s, Health: %d, Source: %s, Source health %d", e.thing.GetClassName(), e.thing.health, e.damageSource.GetClassName(), e.damageSource.health);

        // Hematophagy
        if (e.inflictor is "Demon" && IsMutationActive("Hematophagy") && e.inflictor.health >= 0)
        {
            // This uses inflictor - we want the demon to be dealing the damage directly
            // (instead of eg. via a barrel)
            e.inflictor.A_ResetHealth();
        }

        if (e.thing is "PlayerPawn")
        {
            // Desecration - player was damaged by an imp
            if(e.damageSource is 'DoomImp' && IsMutationActive("Desecration") && e.inflictor.target.health >= 0)
            {
                ReplaceActor(e.damageSource, "HM_ArchImp", e.thing);
            }

            // Promotiom - player was damaged by a zombieman
            if(e.damageSource is 'ZombieMan' && IsMutationActive("Promotion"))
            {
                ReplaceActor(e.damageSource, "ShotgunGuy", e.thing);
            }
        }
    }
    
    clearscope bool IsMutationRemoved(string mutationName)
    {
        let foundValue = ActiveMutations.At(mutationName.MakeLower());
        let isRemoved = foundValue != "1";

        //console.printf("IS MUTATION REMOVED %s %i", mutationName, isRemoved);
        return isRemoved;
    }
    
    clearscope bool IsMutationActive(string mutationName)
    {
        let foundValue = ActiveMutations.At(mutationName.MakeLower());
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
