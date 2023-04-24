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

        return spawnee;
    }

}