mixin class HM_Macropods
{
    int lastPounceTime;

    void A_PounceChase()
    {
        if(
            global.IsMutationActive("Macropods")
            && target 
            && Distance2D(target) > 100
            && Distance2D(target) < 1000
            && Level.Time > lastPounceTime + 35 * 2 // Only pounce every 2 seconds at most. This is set in the actual Pounce state.
        )
        {
            A_Chase("Melee", "Pounce");
        }
        else
        {
            A_Chase("Melee");
        }
    }
}