extend class HM_GlobalEventHandler
{
    // Replaces an actor with a newly spawned actor of a different class, destroying the old one.
    // Returns the replacee
    Actor ReplaceActor(Actor original, string newClass)
    {
        let originalTarget = original.target;
        let orignalSpawnFlags = original.SpawnFlags;

        original.A_NoBlocking();
        let spawnee = original.Spawn(newClass, original.pos, ALLOW_REPLACE);
        original.Destroy();

        if(spawnee)
        {
            spawnee.target = originalTarget;
            spawnee.SpawnFlags = original.SpawnFlags;
            spawnee.HandleSpawnFlags();

            if(originalTarget)
            {
                spawnee.A_FaceTarget();
            }
            
            // Show a visual effect to notify the player the monster has been upgraded
            spawnee.A_GiveInventory("HM_UpgradeGlitterGenerator");
        }


        return spawnee;
    }

    // Replaces an actor with a newly spawned actor of a different class, destroying the old one.
    // Chance is [chance] out of 255
    // Returns the replacee
    Actor ChanceReplaceActor(Actor original, string newClass, int chance)
    {
        let roll = random[randomspawn](0, 255);
        if(roll >= chance)
        {
            return original;
        }

        return ReplaceActor(original, newClass);
    }

    bool, int, int, int ChooseRandomPointInSector(Sector sec)
    {
        for(let attempt = 0; attempt < 50; attempt++)
        {
            let minX = int.max;
            let minY = int.max;
            let maxX = int.min;
            let maxY = int.min;

            for(let j = 0; j < sec.lines.Size(); j++)
            {
                let line = sec.lines[j];

                minX = min(minX, line.v1.p.x);
                minX = min(minX, line.v2.p.x);

                maxX = max(maxX, line.v1.p.x);
                maxX = max(maxX, line.v2.p.x);

                minY = min(minY, line.v1.p.y);
                minY = min(minY, line.v2.p.y);

                maxY = max(maxY, line.v1.p.y);
                maxY = max(maxY, line.v2.p.y);
            }

            let chosenX = random[HM_GlobalEventHandler](minX, maxX);
            let chosenY = random[HM_GlobalEventHandler](minY, maxY);

            let v2 = (chosenX, chosenY);

            let matchedSector = Level.PointInSector(v2);
            double floorHeight = matchedSector.floorPlane.ZAtPoint(v2);

            let v3 = (chosenX, chosenY, floorHeight);

            if(!Level.IsPointInLevel(v3))
            {
                continue;
            }

            return true, chosenX, chosenY, floorHeight;
        }

        return false, 0, 0, 0;
    }

    Class<Weapon> GetSourceWeapon(WorldEvent e)
    {
        let player = e.damageSource;
        if(!(player is 'PlayerPawn'))
        {
            return null;
        }

        Class<Weapon> weaponClass;
        if(e.damageType == "BFGSplash")
        {
            return "BFG9000";
        }
        else if(e.inflictor is "BulletPuff")
        {
            // Hitscan weapon
            return player.player.readyWeapon.GetClass();
        }
        else if(e.inflictor is "BFGBall")
        {
            return "BFG9000";
        }
        else if(e.inflictor is "PlasmaBall")
        {
            return "PlasmaRifle";
        }
        else if(e.inflictor is "Rocket")
        {
            return "RocketLauncher";
        }

        return null;
    }
}