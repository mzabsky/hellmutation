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

        ChooseMutations();


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
        // This is required to support various healing and health manipulating functions
        if(e.thing.starthealth == 0)
        {
            e.thing.starthealth = e.thing.SpawnHealth();
        }

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
            // No source

            if (e.thing is "PlayerPawn")
            {
                if(IsMutationActive("slimeborne"))
                {
                    let roll = Random(0, 100);
                    //console.printf("slimeborne roll %d", roll);
                    if(roll <= e.damage * 2)
                    {
                        let spawnee = e.thing.Spawn("HM_DemonEgg", e.thing.pos, ALLOW_REPLACE);
                        spawnee.target = e.thing;
                    }
                }
            }
        }
        else
        {
            // Has damage source

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

            // Cyber-Neural Reflexes
            if (e.thing is "HM_Arachnotron" && IsMutationActive("cyberneuralreflexes"))
            {
                let arachnotron = HM_ARachnotron(e.thing);
                arachnotron.target = e.damageSource;
                arachnotron.A_FaceTarget();
                arachnotron.HM_A_BspiAttack();
                arachnotron.SetState(arachnotron.ResolveState("InstantMissile"), 1);
            }

            // Decoys
            if (e.thing is "HM_Revenant" && IsMutationActive("decoys"))
            {
                let revenant = HM_Revenant(e.thing);
                if(Level.time > revenant.lastDecoyTime + 35) // Max. once every second
                {
                    revenant.decoyRequested = true;
                }
            }
        }
    }

    override void WorldTick()
    {
        // Run each second
        if(Level.time % 35 != 0)
        {
            return;
        }

        if(IsMutationActive("extremophilia"))
        {
            let finder = ThinkerIterator.Create("Actor");
            Actor actor;
            while((actor = Actor(finder.next())) != null)
            {
                // Only alive non-flying monsters that are standing on the floor qualify
                if(!actor.bIsMonster || actor.health <= 0 || actor.bNoGravity || actor.pos.z - actor.floorz > 0) 
                {
                    continue;
                }

                if(actor.cursector.damageamount == 0)
                {
                    continue;
                }

                // Only injured monsters
                if(actor.health >= actor.spawnhealth())
                {
                    continue;
                }

                let oldHealth = actor.health;
                let healAmount = max(min(actor.spawnhealth() / 7, 200), 10);
                actor.A_SetHealth(min(oldHealth + healAmount, actor.spawnhealth()));
                
                //console.printf("Extremophilia heal %s from %d to %d (+%d)", actor.GetClassName(), oldHealth, actor.health, healAmount);
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
