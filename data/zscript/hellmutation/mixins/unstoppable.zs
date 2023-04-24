mixin class HM_Unstoppable
{
    void UpdatePainThreshold()
    {
        if(global.IsMutationActive("unstoppable"))
        {
            PainChance = 16;
        }
        else
        {
            PainChance = 180;
        }
    }
}