class HM_RevenantTracer : RevenantTracer replaces RevenantTracer
{
    mixin HM_GlobalRef;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("HyperFuel") && !(target is "PlayerPawn"))
        {
            Speed = 16;
        }
    }
}