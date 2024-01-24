extend class HM_GlobalEventHandler
{
    override void WorldLoaded(WorldEvent e) 
    {
        let detectGame = new ("HM_DetectGame");
        hasDoom2 = detectGame.HasDoom2();

        CreateMutationDefinitions();
        CreatePerkDefinitions();

        globalThinker = HM_GlobalThinker.Get();
        MapNumber = globalThinker.MapNumber;

        MutationStates = globalThinker.MutationStates;
        if(MutationStates == null)
        {
            MutationStates = Dictionary.Create();
        }

        PerkStates = globalThinker.PerkStates;
        if(PerkStates == null)
        {
            PerkStates = Dictionary.Create();
        }

        int newMutationsInEffect = ChooseMutations();

        if(MapNumber == 0)
        {
            ChoosePerks();
        }
        else
        {
            for(let i = 0; i < PerkDefinitions.Size(); i++)
            {
                let currentPerkDefinition = PerkDefinitions[i];
                let foundValue = PerkStates.At(currentPerkDefinition.Key);
                
                if(foundValue == "Offered")
                {
                    PerksOnOffer.Push(currentPerkDefinition.Key);
                }
            }
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

        ReplaceMonsters();

        SpawnPrepainedLostSouls();

        SpawnTriumvirate();

        SpawnDejaVuTraces();

        WorkplaceSafety();

        SpawnDoppelgangersCorpses();

        SpawnVileIncursion();

        BriefRestHeal();

        FleshInversion();
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

    // Spawn Pre-pained lost souls
    void SpawnPrepainedLostSouls()
    {
        if(!IsMutationActive("trauma"))
        {
            return;
        }

        Array<int> lostSoulOffsetXs;
        lostSoulOffsetXs.Push(60);
        lostSoulOffsetXs.Push(60);
        lostSoulOffsetXs.Push(0);
        lostSoulOffsetXs.Push(-60);
        lostSoulOffsetXs.Push(-60);
        lostSoulOffsetXs.Push(-60);
        lostSoulOffsetXs.Push(0);
        lostSoulOffsetXs.Push(60);
        
        Array<int> lostSoulOffsetYs;
        lostSoulOffsetYs.Push(0);
        lostSoulOffsetYs.Push(-60);
        lostSoulOffsetYs.Push(-60);
        lostSoulOffsetYs.Push(-60);
        lostSoulOffsetYs.Push(0);
        lostSoulOffsetYs.Push(60);
        lostSoulOffsetYs.Push(60);
        lostSoulOffsetYs.Push(60);

        let painElementalFinder = ThinkerIterator.Create("HM_PainElemental");
        HM_PainElemental painElemental;
        while((painElemental = HM_PainElemental(painElementalFinder.next())) != null)
        {
            int numberAccepted = 0;
            for(let i = 0; i < lostSoulOffsetXs.Size(); i++)
            {
                //console.printf("spawning LS at %i %d %d", i, lostSoulOffsetXs[i], lostSoulOffsetYs[i]);

                let spawnee = painElemental.Spawn(
                    "HM_LostSoul",
                    painElemental.Vec3Offset(
                        lostSoulOffsetXs[i],
                        lostSoulOffsetYs[i],
                        0
                    )
                );

                if(spawnee && !spawnee.TestMobjLocation())
                {
                    // Reject lost souls which would collide with something
                    spawnee.Destroy();
                }
                else
                {
                    spawnee.Angle = painElemental.Angle;
                    spawnee.SpawnFlags = painElemental.SpawnFlags;
                    spawnee.HandleSpawnFlags();

                    // Make sure the pain elemental tracks this as one of his own
                    // eg. for Zeal
                    painElemental.spawnedActors.Push(spawnee);

                    numberAccepted++;

                    // 4 is enough
                    if(numberAccepted >= 4)
                    {
                        break;
                    }
                }
            }
        }
    }

    void SpawnTriumvirate()
    {
        if(!IsMutationActive("triumvirate"))
        {
            return;
        }

        // Spawn an additional cyberdemon for each one in the map
        // Then connect them in a love triangle so they treat each other
        // as mates
        let cyberdemonFinder = ThinkerIterator.Create("HM_Cyberdemon");
        HM_Cyberdemon cyberdemon;
        while((cyberdemon = HM_Cyberdemon(cyberdemonFinder.next())) != null)
        {
            // A newly spawned cyberdemon from previous iteration of the loop
            if (cyberdemon.triumvirateMateA != null)
            {
                continue;
            }

            let triumvirateMate1 = HM_Cyberdemon(cyberdemon.Spawn('HM_Cyberdemon', cyberdemon.pos));
            if(triumvirateMate1 == null)
            {
                break;
            }

            triumvirateMate1.Angle = cyberdemon.Angle;
            triumvirateMate1.SpawnFlags = cyberdemon.SpawnFlags;
            triumvirateMate1.HandleSpawnFlags();

            let triumvirateMate2 = HM_Cyberdemon(cyberdemon.Spawn('HM_Cyberdemon', cyberdemon.pos));
            if(triumvirateMate2 == null)
            {
                break;
            }

            triumvirateMate2.Angle = cyberdemon.Angle;
            triumvirateMate2.SpawnFlags = cyberdemon.SpawnFlags;
            triumvirateMate2.HandleSpawnFlags();

            // Make the love triangle
            cyberdemon.triumvirateMateA = triumvirateMate1;
            cyberdemon.triumvirateMateB = triumvirateMate2;

            triumvirateMate1.triumvirateMateA = cyberdemon;
            triumvirateMate1.triumvirateMateB = triumvirateMate2;

            triumvirateMate2.triumvirateMateA = cyberdemon;
            triumvirateMate2.triumvirateMateB = triumvirateMate1;
        }
    }

    // Spawns traces that can be periodially checked - and if conditions permit, used to respawn the monsters
    // These traces are invisible and only exist for this purpose.
    void SpawnDejaVuTraces()
    {
        Map<int, Sector> ambushSectorMap;

        let ambushMonsterFinder = ThinkerIterator.Create("Actor");
        Actor monster;
        while((monster = Actor(ambushMonsterFinder.next())) != null)
        {
            if(!monster.bIsMonster)
            {
                continue;
            }

            if(monster.SpawnFlags & MTF_AMBUSH == 0)
            {
                continue;
            }

            //console.printf("ambush %s", monster.GetClassName());

            let ambushTrace = monster.Spawn("HM_AmbushTrace", monster.pos);
            ambushTrace.SpawnFlags = monster.SpawnFlags;
            ambushTrace.target = monster;
            ambushTrace.angle = monster.angle;

            ambushSectorMap.Insert(monster.cursector.sectornum, monster.cursector);
        }

        MapIterator<int, Sector> ambushSectorMapIterator;
        ambushSectorMapIterator.Init(ambushSectorMap);
        while(ambushSectorMapIterator.Next())
        {
            let currentSector = ambushSectorMapIterator.GetValue();
            ambushSectors.Push(currentSector);

            //console.printf("ambushsector %d", currentSector.sectornum);
        }
    }

    void WorkplaceSafety()
    {
        if(IsMutationActive("workplacesafety"))
        {
            let barrelFinder = ThinkerIterator.Create("HM_ExplosiveBarrel");
            HM_ExplosiveBarrel barrel;
            while((barrel = HM_ExplosiveBarrel(barrelFinder.next())) != null)
            {
                barrel.SpawnSurprise(true);
                barrel.Destroy();
            }
        }
    }

    void SpawnDoppelgangersCorpses()
    {
        if(!IsMutationActive("doppelgangers"))
        {
            return;
        }

        // Corpses will only be spawned in sectors where monsters already exists
        // (we know it makes sense for monsters to be there, since there are some already)
        Array<Sector> candidateSectors;
        for(let i = 0; i < Level.Sectors.Size(); i++)
        {
            let sector = Level.Sectors[i];

            let foundMonster = false;
            let foundPriorityMonster = false; // Give a bit higher weight to monster that can actually take advantage of the corpses
            let currentThing = sector.thingList;
            while(currentThing != null)
            {
                if(currentThing is 'HM_ArchImp' || currentThing is 'ArchVile')
                {
                    foundPriorityMonster = true;
                }
                else if(currentThing.bIsMonster)
                {
                    foundMonster = true;
                }

                currentThing = currentThing.snext;
            }

            if(foundPriorityMonster)
            {
                // 4x weight :)
                candidateSectors.Push(sector);
                candidateSectors.Push(sector);
                candidateSectors.Push(sector);
                candidateSectors.Push(sector);

                sector.lightlevel = 255;
            }
            else if(foundMonster)
            {
                candidateSectors.Push(sector);

                //sector.lightlevel = 255;
            }
        }

        //console.printf("%d candidate sectors", candidateSectors.Size());

        // Determine which monsters need corpses spawned
        // Do this before the actual spawning (spawning actors in a finder loop
        // causes infinite loops...)
        Array<Actor> monsters;
        let actorFinder = ThinkerIterator.Create("Actor");
        Actor actor;
        while((actor = Actor(actorFinder.next())) != null)
        {
            if(!actor.bIsMonster || actor.bCorpse)
            {
                continue;
            }

            // Those leave no corpses
            if(actor is 'PainElemental' || actor is 'LostSoul')
            {
                continue;
            }

            monsters.Push(actor);
        }

        for(let i = 0; i < monsters.Size(); i++)
        {
            let actor = monsters[i];

            // Give each doppelganger 25 shots and finding a place where they fit
            let successfulAttempt = -1;
            for(let attempt = 0; attempt < 25; attempt++)
            {
                let chosenSector = candidateSectors[random[HM_GlobalEventHandler](0, candidateSectors.Size() - 1)];

                bool foundPoint;
                int chosenX, chosenY, chosenZ;
                [foundPoint, chosenX, chosenY, chosenZ] = ChooseRandomPointInSector(chosenSector);

                let spawner = MonsterCorpseSpawner.SpawnCorpse(actor.GetClass(), (chosenX, chosenY, chosenZ), true);
                if(!spawner)
                {
                    continue;
                }

                // Atempt was sucessful
                successfulAttempt = attempt;
                break;
            }
        }
    }

    void SpawnVileIncursion()
    {
        if(!IsMutationActive("vileincursion"))
        {
            return;
        }

        // Spawn the Vile in a sector where monsters already are
        Array<Sector> candidateSectors;
        for(let i = 0; i < Level.Sectors.Size(); i++)
        {
            let sector = Level.Sectors[i];

            let currentThing = sector.thingList;
            while(currentThing != null)
            {
                

                // We actually don't mind the monsters are dead (eg. from Doppelgangers)
                // We don't want flying monsters though (don't want to spawn the vile where )
                if(currentThing.bIsMonster && currentThing.pos.z - currentThing.floorz == 0)
                {
                    // Push it once for each monster -> this serves to weigh the spawning specifically towards more crowded sectors
                    candidateSectors.Push(sector);
                }

                currentThing = currentThing.snext;
            }
        }

        for(let attempt = 0; attempt < 50; attempt++)
        {
            let chosenSector = candidateSectors[random[HM_GlobalEventHandler](0, candidateSectors.Size() - 1)];

            bool pointFound;
            int chosenX, chosenY, chosenZ;
            [pointFound, chosenX, chosenY, chosenZ] = ChooseRandomPointInSector(chosenSector);

            if(!pointFound)
            {
                // Outside of the sector
                continue;
            }

            let vile = Actor.Spawn('HM_ArchVile', (chosenX, chosenY, 0));
            if(vile)
            {
                if(!vile.TestMobjLocation())
                {
                    vile.Destroy();
                    continue;
                }
                
                // Do not spawn the AC where it would be seen by the player
                let seenByPlayer = false;
                for(let i = 0; i < Players.Size(); i++)
                {
                    if(Players[i].mo && Players[i].mo.CheckSight(vile))
                    {
                        seenByPlayer = true;
                        break;
                    }
                }

                if(seenByPlayer)
                {
                    vile.Destroy();
                    continue;
                }

                // Atempt was sucessful
                break;
            }

            continue;
        }

    }

    void BriefRestHeal()
    {
        for(let i = 0; i < Players.Size(); i++)
        {
            let pawn = Players[i].mo;
            if(IsPerkActive("briefrest") && pawn && pawn.health < 150)
            {
                pawn.A_SetHealth(150);
            }
        }
    }

    // Flesh Inversion - AT the beginning of each level, swap 
    void FleshInversion()
    {
        for(let i = 0; i < Players.Size(); i++)
        {
            let pawn = Players[i].mo;
            if(IsMutationActive("fleshinversion") && pawn && mapNumber > 0)
            {
                let previousHealth = pawn.Health;
                let previousArmor = pawn.CountInv("BasicArmor");

                pawn.TakeInventory("BasicArmor", previousArmor);

                pawn.A_SetHealth(max(1, previousArmor));

                pawn.GiveInventory("ArmorBonus", previousHealth);
            }
        }
    }
}