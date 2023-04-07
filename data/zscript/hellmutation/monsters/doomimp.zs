class HM_DoomImp : DoomImp replaces DoomImp
{
    mixin HM_GlobalRef;
    
    States
    {
        Melee:
        Missile:
            TROO EF 8 A_FaceTarget;
            TROO G 6 HM_A_TroopAttack;
            Goto See;

    }

    void HM_A_TroopAttack()
    {
        let targ = target;
        if (targ)
        {
            if (CheckMeleeRange())
            {
                int damage = random[pr_troopattack](1, 8) * 3;
                if(global.IsMutationActive("HellsCaress"))
                {
                    damage *= 2;
                }

                A_StartSound ("imp/melee", CHAN_WEAPON);
                int newdam = targ.DamageMobj (self, self, damage, "Melee");
                targ.TraceBleed (newdam > 0 ? newdam : damage, self);
            }
            else
            {
                // launch a missile
                SpawnMissile (targ, "DoomImpBall");
            }
        }
    }
}