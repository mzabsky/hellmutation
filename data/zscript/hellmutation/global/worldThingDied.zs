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

            console.printf("Kill Killer: %s, Weapon: %s, Inflictor: %s, Victim: %s", killer.GetClassName(), weapon.GetClassName(), e.inflictor.GetClassName(), e.thing.GetClassName());

            if(weapon is 'Fist' && IsPerkActive("bloodlust"))
            {
                killer.GiveInventoryType('HM_PowerGiverBloodlust');
            }

            if(e.thing is 'DoomImp' && IsPerkActive("shakedown"))
            {
                e.thing.Spawn("HM_RandomAmmo", e.thing.pos);
            }

            if(weapon is 'Chainsaw' && IsPerkActive("profitablecut"))
            {
                e.thing.Spawn("HM_RandomAmmo", e.thing.pos);
            }

            if(weapon is 'Shotgun' && e.thing.bIsMonster)
            {
                HM_Player(killTracker.killer).lastShotgunKillTime = Level.Time;
            }
            
            // Performance Bonus - Rocket kills 5 monsters -> gets refunded
            if(e.inflictor is "HM_PlayerRocket" && IsPerkActive("performancebonus"))
            {
                let rocket = HM_PlayerRocket(e.inflictor);
                rocket.KillCount++;
                if(rocket.KillCount == 5)
                {
                    Killer.GiveInventoryType("RocketAmmo");
                }
            }
        }
        else if(e.inflictor)
        {
            console.printf("Kill Inflictor: %s, Victim: %s", e.inflictor.GetClassName(), e.thing.GetClassName());
        }
        else {
            console.printf("Kill no Inflictor. Victim: %s", e.thing.GetClassName());
        }

        // Discord - Imp killed another monster
        if(
            IsMutationActive("discord")
            && e.inflictor is 'DoomImpBall'
            && e.thing.bIsMonster
            && e.inflictor.target
            && !e.inflictor.target.bCorpse // is still alive
            && e.inflictor.target.GetClassName() == "HM_DoomImp" // Is not upgraded yet by previous projectile
        )
        {
            ReplaceActor(e.inflictor.target, "HM_ArchImp");
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

        // Dependence - Kill all dependent Lost Souls
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

        // Betrayal - A monster killed another monster -> create an explosion of bonuses
        if(e.thing && e.thing.target && e.thing.target.bIsMonster && e.thing.bIsMonster && IsPerkActive("betrayal"))
        {
            let victim = e.thing;
            let maxHealth = GetDefaultByType(e.thing.GetClass()).health;

            //console.printf("Viction max health: %d, Log: %f, LogN: %f, Sqrt: %f", maxHealth, log(double(maxhealth)), logN(double(maxHealth), 1.2) - 14, int(sqrt(double(maxHealth)) / 2));
            let bonusCount = int(sqrt(double(maxHealth) / 2));
            for(let i = 0; i < bonusCount; i++)
            {
                Class<Inventory> bonusClass = random[HM_GlobalEventHandler](0, 1) == 0 ? "HealthBonus" : "ArmorBonus";
                let position = e.thing.Vec3Offset(
                    random[HM_GlobalEventHandler](-victim.radius, victim.radius),
                    random[HM_GlobalEventHandler](-victim.radius, victim.radius),
                    random[HM_GlobalEventHandler](0, victim.height)
                );
                let bonus = e.thing.Spawn(bonusClass, position);
                bonus.vel.x = (position.x - victim.pos.x) / 10;
                bonus.vel.y = (position.y - victim.pos.y) / 10;
                bonus.vel.z = (position.z - victim.pos.z) / 10;
            }
        }
    }
}