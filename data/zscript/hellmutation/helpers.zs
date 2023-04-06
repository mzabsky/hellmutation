extend class HM_GlobalEventHandler
{
    // Replaces an actor with a newly spawned actor of a different class, destroying the old one.
    // Returns the replacee
    Actor ReplaceActor(Actor original, string newClass, Actor playerPawn)
    {
        original.A_NoBlocking();
        let spawnee = original.Spawn(newClass, original.Vec3Offset(0, 0, 0), ALLOW_REPLACE);
        original.Destroy();

        spawnee.A_Face(playerPawn);
        spawnee.A_Look();

        return spawnee;
    }

}