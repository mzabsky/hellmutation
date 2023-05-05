class HM_Cacodemon : Cacodemon replaces Cacodemon
{
    mixin HM_GlobalRef;

    States
    {
        See:
            HEAD A 0 UpdatePainThreshold();
            HEAD A 3 A_Chase;
            Loop;
        Pain:
            HEAD E 0 UpdatePainThreshold();
            HEAD E 3;
            HEAD E 3 A_Pain;
            HEAD F 6;
            Goto See;
        Missile:
            HEAD B 5 A_FaceTarget;
            HEAD C 5 A_FaceTarget;
            HEAD D 5 BRIGHT HM_A_HeadAttack();
            Goto See;
        Crash:
            HEAD D 0 PomodoroSustenance();
            Goto Death;
        
    }

  //
    void HM_A_HeadAttack()
    {
        let targ = target;
        if (targ)
        {
            if (CheckMeleeRange())
            {
                int damage = random[pr_headattack](1, 6) * 10;
                A_StartSound (AttackSound, CHAN_WEAPON);
                int newdam = target.DamageMobj (self, self, damage, "Melee");
                targ.TraceBleed (newdam > 0 ? newdam : damage, self);
            }
            else
            {
                let isCacoblastersActive = global.IsMutationActive("Cacoblasters");

                if(isCacoblastersActive)
                {
                    A_SpawnProjectile ("CacodemonBall",26,0,-10,CMF_AIMOFFSET, 0);
                }
                
                A_SpawnProjectile ("CacodemonBall",26,0, 0,CMF_AIMOFFSET, 0);

                if(isCacoblastersActive)
                {
                    A_SpawnProjectile ("CacodemonBall",26,0,10,CMF_AIMOFFSET, 0);
                }
            }
        }
    }

    void UpdatePainThreshold()
    {
        if(global.IsMutationActive("unyielding"))
        {
            PainChance = 32;
        }
        else
        {
            PainChance = 128;
        }
    }

    void PomodoroSustenance()
    {
        if(!global.IsMutationActive("pomodorosustenance"))
        {
            return;
        }

        let range = 256;
        let healthAmount = 200;
        BlockThingsIterator it = BlockThingsIterator.Create(self, range);
        Actor mo;

        while (it.Next())
        {
            mo = it.thing;
            if (!mo || !mo.bIsMonster || mo.health <= 0 || Distance3D(mo) > range)
            {
                continue;
            }
                
            let startingHealth = min(mo.health + healthAmount, mo.spawnhealth());
            if(startingHealth <= mo.health)
            {
                continue;
            }

            mo.A_GiveInventory("HM_HealGlitterGenerator");
        }
    }
}