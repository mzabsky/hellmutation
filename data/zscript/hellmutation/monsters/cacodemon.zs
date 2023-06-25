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
            HEAD B 0 JumpByMomentum("MissileMomentum0", "MissileMomentum10", "MissileMomentum20", "MissileMomentum30", "MissileMomentum40");
        MissileMomentum0:
            HEAD B 5 A_FaceTarget;
            HEAD C 5 A_FaceTarget;
            HEAD D 5 BRIGHT HM_A_HeadAttack();
            Goto See;
        MissileMomentum10:
            HEAD B 4 A_FaceTarget;
            HEAD C 4 A_FaceTarget;
            HEAD D 4 BRIGHT HM_A_HeadAttack();
            Goto See;
        MissileMomentum20:
            HEAD B 3 A_FaceTarget;
            HEAD C 3 A_FaceTarget;
            HEAD D 3 BRIGHT HM_A_HeadAttack();
            Goto See;
        MissileMomentum30:
            HEAD B 2 A_FaceTarget;
            HEAD C 2 A_FaceTarget;
            HEAD D 2 BRIGHT HM_A_HeadAttack();
            Goto See;
        MissileMomentum40:
            HEAD B 1 A_FaceTarget;
            HEAD C 1 A_FaceTarget;
            HEAD D 1 BRIGHT HM_A_HeadAttack();
            Goto See;
        Crash:
            HEAD D 0 PomodoroSustenance();
            Goto Death;
        FastRaise:
            HEAD L 4 A_UnSetFloorClip;
            HEAD KJIHG 4;
            Goto See;
        
    }

    Vector3 lastPos;
    double momentum;
    override void Tick()
    {
        let age = GetAge();
        if(age % 10 == 0) 
        {
            if(age > 0)
            {

                momentum = sqrt((lastPos.x - pos.x) * (lastPos.x - pos.x) + (lastPos.y - pos.y) * (lastPos.y - pos.y) + (lastPos.z - pos.z) * (lastPos.z - pos.z));
            }
            lastPos = pos;
        }

        super.Tick();
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

    state JumpByMomentum(StateLabel momentum0, StateLabel momentum10, StateLabel momentum20, StateLabel momentum30, StateLabel momentum40)
    {
        if(!global.IsMutationActive("momentum"))
        {
            return ResolveState(momentum0);
        }

        if(momentum > 24)
        {
            bAlwaysFast = true;
        }

        if(momentum > 52)
        {
            return ResolveState(momentum40);
        }
        else if(momentum > 39)
        {
            return ResolveState(momentum30);
        }
        else if(momentum > 26)
        {
            return ResolveState(momentum20);
        }
        else if(momentum > 13)
        {
            return ResolveState(momentum10);
        }

        return ResolveState(momentum0);
    }
}