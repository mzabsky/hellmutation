class HM_Arachnotron: Arachnotron replaces Arachnotron
{
    mixin HM_GlobalRef;

    int lastFireTime;

    States
    {
        Missile:
            BSPI A 20 A_FaceTarget;
        InstantMissile:
            BSPI G 4 BRIGHT HM_A_BspiAttack();
            BSPI H 4 ;
            BSPI H 1 A_SpidRefire;
            Goto Missile+1;
    }

    void HM_A_BspiAttack()
    {
        // Do not fire more than once in each frame (for case with cyberneuralreflexes)
        if(lastFireTime == Level.time)
        {
            return;
        }

        if (target)
        {
            A_FaceTarget();
            let missile = SpawnMissile(target, "ArachnotronPlasma");
            if(missile && global.IsMutationActive("hypercognition"))
            {
                missile.VelIntercept(target);
            }

            lastFireTime = Level.time;
        }
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        // arachnotrons can't enter pain states if they are to fire back
        // the actual trigger to do the counterattack is in WorldThingDamaged
        if(global.IsMutationActive("cyberneuralreflexes"))
        {
            flags = flags & DMG_NO_PAIN;
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}