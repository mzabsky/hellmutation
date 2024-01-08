extend class HM_GlobalEventHandler
{
    override void WorldThingDied(WorldEvent e)
    {
        if(!e.thing)
        {
            return;
        }

        // This is required to support various healing and health manipulating functions
        if(e.thing.starthealth == 0)
        {
            e.thing.starthealth = e.thing.SpawnHealth();
        }

        let killTracker = HM_KillTracker(e.thing.FindInventory('HM_KillTracker'));
        Class<Weapon> weapon = null;
        if(killTracker != null)
        {
            weapon = killTracker.KillWeapon;
        }

        if(weapon != null)
        {
            let killer = killTracker.killer;

            //console.printf("Kill %s %s", weapon.GetClassName(), e.damageSource.GetClassName());

            if(weapon is 'Fist' && IsPerkActive("bloodlust"))
            {
                killer.GiveInventoryType('PowerGiverBloodlust');
            }
        }

        // Anger - Lost soul died -> set FAST on all Lost Souls in vision range
        if(IsMutationActive("anger") && e.thing is 'LostSoul')
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

        // Triumvirate - Kill the other cyberdemons (shouldn't be needed, just to be sure)
        if (e.thing is "HM_Cyberdemon" && (e.damageFlags & HM_DMG_REDIRECTED == 0)) // Do not share already shared damage
        {
            let cyberdemon = HM_Cyberdemon(e.thing);
            if(cyberdemon != null)
            {
                if(cyberdemon.triumvirateMateA != null)
                {
                    cyberdemon.triumvirateMateA.DamageMobj(cyberdemon, e.damageSource, 9999, 'Triumvirate', HM_DMG_REDIRECTED);
                }
                
                if(cyberdemon.triumvirateMateB != null)
                {
                    cyberdemon.triumvirateMateB.DamageMobj(cyberdemon, e.damageSource, 9999, 'Triumvirate', HM_DMG_REDIRECTED);
                }
            }
        }
    }
}