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

        SpawnPrepainedLostSouls();

        SpawnDejaVuTraces();

        /*

        		for (looker = cursector.thinglist; looker != NULL; looker = looker.snext)
		{
			if (looker == self || looker == target)
				continue;

			if (looker.health <= 0)
				continue;

			if (!looker.bSeesDaggers)
				continue;

			if (!looker.bInCombat)
			{
				if (!looker.CheckSight(target) && !looker.CheckSight(self))
					continue;

				looker.target = target;
				if (looker.SeeSound)
				{
					looker.A_StartSound(looker.SeeSound, CHAN_VOICE);
				}
				looker.SetState(looker.SeeState);
				looker.bInCombat = true;
			}
		}

        */
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
        if(!IsMutationActive("prepained"))
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
}