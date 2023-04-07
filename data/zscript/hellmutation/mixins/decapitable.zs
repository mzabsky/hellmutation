// Implements a Decapitate action for the Decapitation mutation (the mutation check is done separately)
mixin class HM_Decapitable
{
    void Decapitate()
    {
        A_NoBlocking();
        let spawnee = Spawn("LostSoul", Vec3Offset(0, 0, 0), ALLOW_REPLACE);
        spawnee.A_Look();
        spawnee.A_FaceTarget();
    }
}