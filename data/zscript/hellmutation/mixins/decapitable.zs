// Implements a Decapitate action for the Decapitation mutation (the mutation check is done separately)
mixin class HM_Decapitable
{
    state JumpIfDecapitation(StateLabel decapitationStateLabel)
    {
        if (global.IsMutationActive("Decapitation"))
        {
            return A_Jump(48, decapitationStateLabel);
        }
        else
        {
            return ResolveState(null);
        }
    }

    void Decapitate()
    {
        A_NoBlocking();
        let spawnee = Spawn("LostSoul", Vec3Offset(0, 0, 0), ALLOW_REPLACE);
        if(spawnee)
        {
            spawnee.A_SetHealth(40); // Make the spawned lost soul a bit easier to kill
            spawnee.target = target;
            spawnee.A_FaceTarget();
        }
    }
}