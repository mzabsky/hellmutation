mixin class HM_HighGround
{
    bool HasHighGroundOver(Actor target)
    {
        if(!target)
        {
            return false;  
        }

        if(!global.IsMutationActive("highground"))
        {
            return false;
        }

        // At least 48 units of extra height is required
        if(pos.z < target.pos.z + 48)
        {
            return false;
        }

        return true;
    }
}