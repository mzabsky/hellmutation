mixin class HM_GreaterRitual
{
    override bool CanResurrect (Actor other, bool passive)
    {
        return global.IsMutationActive("greaterritual");
    }
}