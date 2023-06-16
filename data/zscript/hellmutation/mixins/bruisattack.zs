// Replacement action for A_BruisAttack (for Baron of Hell and Hell Knight), which takes into consideration mutations.
mixin class HM_BruisAttack
{
    void HM_A_BruisAttack()
    {
        let targ = target;
        if (targ)
        {
            if (CheckMeleeRange())
            {
                int damage = random[pr_bruisattack](1, 8) * 10;
                if(global.IsMutationActive("hellscaress"))
                {
                    damage *= 2;
                }

                A_StartSound ("baron/melee", CHAN_WEAPON);
                int newdam = target.DamageMobj (self, self, damage, "Melee");
                targ.TraceBleed (newdam > 0 ? newdam : damage, self);
            }
            else
            {
                // launch a missile
                let missile = SpawnMissile (target, "BaronBall");
                if(missile && global.IsMutationActive("lordsofchaos"))
                {
                    let roll = random[hm_bruisattack](20, 200);
                    missile.vel.x = missile.vel.x * roll / 100;
                    missile.vel.y = missile.vel.y * roll / 100;
                    missile.vel.z = missile.vel.z * roll / 100;
                }
            }
        }
    }
}