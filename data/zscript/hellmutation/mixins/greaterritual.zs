mixin class HM_GreaterRitual
{
    override bool CanResurrect (Actor other, bool passive)
    {
        if(!passive)
        {
            return super.CanResurrect(other, passive);
        }

        return  global.IsMutationActive("greaterritual");
    }
}