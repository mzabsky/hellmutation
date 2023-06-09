extend class HM_GlobalEventHandler
{
    override void WorldThingDied(WorldEvent e)
    {
        if(!e.thing)
        {
            return;
        }

        // ANger - Lost soul died -> set FAST on all Lost Souls in vision range
        if(IsMutationActive("anger"))
        {
            let iterator = ThinkerIterator.Create("HM_LostSoul");
            HM_LostSoul lostSoul;
            while (lostSoul = HM_LostSoul(iterator.Next()))
            {
                if(lostSoul.bAlwaysFast || lostSoul.health <= 0)
                {
                    continue;
                }

                if(lostSoul.CheckSight(e.thing))
                {
                    lostSoul.bAlwaysFast = true;
                }
            }
        }

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

        if(e.thing is 'HM_PainElemental' && IsMutationActive('dependence'))
        {
            HM_PainElemental(e.thing).DependenceDeath(e.damageSource);
        }
    }
}