class HM_Revenant : Revenant replaces Revenant
{
    mixin HM_GlobalRef;

    States
    {
        Melee:
            SKEL G 0 A_FaceTarget;
            SKEL G 6 A_SkelWhoosh;
            SKEL H 6 A_FaceTarget;
            SKEL I 6 HM_A_SkelFist;
           
            Goto See;
    }

    void HM_A_SkelFist()
    {
        let targ = target;
        if (targ == null) return;
        A_FaceTarget();
        
        if (CheckMeleeRange ())
        {
            int damage = random[SkelFist](1, 10) * 6;
            if(global.IsMutationActive("HellsCaress"))
            {
                damage *= 2;
            }

            A_StartSound("skeleton/melee", CHAN_WEAPON);
            int newdam = targ.DamageMobj (self, self, damage, 'Melee');
            targ.TraceBleed (newdam > 0 ? newdam : damage, self);
        }
    }
}

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