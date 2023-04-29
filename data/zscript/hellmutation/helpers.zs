extend class HM_GlobalEventHandler
{
    // Replaces an actor with a newly spawned actor of a different class, destroying the old one.
    // Returns the replacee
    Actor ReplaceActor(Actor original, string newClass, Actor playerPawn)
    {
        original.A_NoBlocking();
        let spawnee = original.Spawn(newClass, original.pos, ALLOW_REPLACE);
        original.Destroy();

        if(spawnee)
        {
            spawnee.A_Face(playerPawn);
            spawnee.A_Look();
        }

        // Show a visual effect to notify the player the monster has been upgraded
        spawnee.A_GiveInventory("HM_UpgradeGlitterGenerator");

        return spawnee;
    }

}