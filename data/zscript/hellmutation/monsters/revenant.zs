class HM_RevenantTracer : RevenantTracer replaces RevenantTracer
{
    mixin RefToHandler;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("HyperFuel") && !(target is "PlayerPawn"))
        {
            Speed = 16;
        }
    }
}