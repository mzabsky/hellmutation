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
    }
}