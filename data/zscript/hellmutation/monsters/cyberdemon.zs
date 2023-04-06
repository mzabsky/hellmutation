class HM_Rocket : Rocket replaces Rocket
{
    mixin RefToHandler;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("HyperFuel") && !(target is "PlayerPawn"))
        {
            Speed = 40;
        }
    }
}