extend class HM_GlobalEventHandler
{
    override void WorldTick()
    {
        // Run each second
        if(Level.time % 35 == 0 && IsMutationActive("extremophilia"))
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
                actor.A_GiveInventory("HM_HealGlitterGenerator");
                
                //console.printf("Extremophilia heal %s from %d to %d (+%d)", actor.GetClassName(), oldHealth, actor.health, healAmount);
            }
        }

        if(Level.time % 22 == 0 && IsMutationActive("vitalitylimit"))
        {
            for(let i = 0; i < players.Size(); i++)
            {
                let playerPawn = players[i].mo;
                if(!playerPawn)
                {
                    continue;
                }

                if(playerPawn.health <= 100)
                {
                    continue;
                }

                playerPawn.A_SetHealth(max(100, playerPawn.health - 1));
            }
        }

        // Deja Vu - once every 10 seconds
        if(Level.time % 350 == 0 && IsMutationActive("dejavu"))
        {
            PerformDejaVuAmbushRespawns();
        }
    }

    // For each sector that had any ambush enemies, this checks that they are already dead and out of sight.
    // If they are, they might get to respawn.
    void PerformDejaVuAmbushRespawns()
    {
        foreach(ambushSector: ambushSectors)
        {
            let livingTraces = 0;

            // Check that all the monsters belonging to ambush traces in this sector
            // are dead.
            ACtor looker;
            for (looker = ambushSector.thinglist; looker != NULL; looker = looker.snext)
            {
                if(looker is 'HM_AmbushTrace' && looker.target && looker.target.health > 0)
                {
                    livingTraces++;
                    //console.printf("living %s", looker.target.GetClassName());
                }
            }

            //console.printf("sector %d living traces %d", ambushSector.sectornum, livingTraces);
            if(livingTraces > 0)
            {
                continue;
            }

            // Check that no player can see any of the traces in this sector
            let visibleTraces = 0;
            for (looker = ambushSector.thinglist; looker != NULL; looker = looker.snext)
            {
                if(looker is 'HM_AmbushTrace' && looker.target)
                {
                    for(let i = 0; i < players.Size(); i++)
                    {
                        let playerPawn = players[i].mo;
                        if(!playerPawn)
                        {
                            continue;
                        }

                        if(playerPawn.CheckSight(looker))
                        {
                            //console.printf("visible %s", looker.target.GetClassName());
                            visibleTraces++;
                            break;
                        }
                    }
                }
            }

            if(visibleTraces > 0)
            {
                continue;
            }

            // All the traces in this sector are ready to respawn

            // Now we have 4% chance to actually respawn them (each 10s)
            let roll = random[HM_AmbushTrace](0, 255);
            if(roll >= 10)
            {
                continue;
            }

            // Everything passed: Respawn all ambush enemies in the sector
            for (looker = ambushSector.thinglist; looker != NULL; looker = looker.snext)
            {
                if(looker is 'HM_AmbushTrace' && looker.target)
                {
                    let spawnee = looker.Spawn(looker.target.GetClass(), looker.pos);
                    if(spawnee)
                    {
                        spawnee.angle = looker.angle;
                        spawnee.SpawnFlags = looker.SpawnFlags;
                        spawnee.HandleSpawnFlags();

                        // The trace now cares about trakcing this new monster
                        looker.target = spawnee;
                    }
                }
            }
        }
    }
}