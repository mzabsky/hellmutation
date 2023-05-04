mixin class HM_Macropods
{
    void A_PounceChase()
    {
        if(global.IsMutationActive("Macropods") && target && Distance2D(target) > 100 && Distance2D(target) < 1000)
        {
            A_Chase("Melee", "Pounce");
        }
        else
        {
            A_Chase("Melee");
        }
    }
}