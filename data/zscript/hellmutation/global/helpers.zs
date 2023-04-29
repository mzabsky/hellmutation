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
}