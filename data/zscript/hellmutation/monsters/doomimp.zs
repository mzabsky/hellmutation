class HM_DoomImp : DoomImp replaces DoomImp // Replacement is handled by MH_DoomImp_Spawner
{
    mixin HM_GlobalRef;

    // The ArchImp replacement is done in the global handler

    states
    {
        See:
            TROO A 0 {
                // Brightfire - Imps are faster
                bAlwaysFast = global.IsMutationActive("Brightfire");
                
                // Discord - Allow damaging other imps
                bDoHarmSpecies = global.IsMutationActive("discord");
            }
            TROO AABBCCDD 3 FAST A_Chase;
            Loop;
        Melee:
        Missile:
            TROO EF 8 FAST A_FaceTarget;
            TROO G 6 FAST HM_A_TroopAttack;
            TROO G 0 {
                if(global.IsMutationActive("barrage"))
                {
                    return ResolveState("BarrageMissile");
                }
                else {
                    return ResolveState(null);
                }
            }
            Goto See;
        BarrageMissile:
            TROO EF 3 FAST A_FaceTarget;
            TROO G 1 FAST HM_A_TroopAttack;
            TROO EF 3 FAST A_FaceTarget;
            TROO G 1 FAST HM_A_TroopAttack;
            Goto See;
        FastRaise:
            TROO ML 4;
            TROO KJI 3;
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
