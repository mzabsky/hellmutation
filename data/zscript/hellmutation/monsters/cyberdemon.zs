class HM_Cyberdemon : Cyberdemon replaces Cyberdemon
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;
    mixin HM_BigFuckingWomp;

    Actor triumvirateMateA;
    Actor triumvirateMateB;

    int lastScoredHitTime;

    States
    {
        See:
            CYBR A 3 A_Hoof;
            CYBR ABBCC 3 A_Chase;
            CYBR D 0 {
                if(global.IsMutationActive("dominance") && target != null && CheckSight(target))
                {
                    return ResolveState("FireSee");
                }
                else
                {
                    return ResolveState(null);
                }
            }      
            CYBR D 3 A_Metal;
            CYBR D 3 A_Chase;
            Loop;
        FireSee:
            CYBR F 3 {
                A_Metal();
                HM_A_CyberAttack();
            }
            CYBR F 3 A_Chase;
            Goto See;
        Raise:
            CYBR ON 10;
            CYBR M 10;
            CYBR LKJ 10;
            CYBR I 10;
            CYBR H 10;
            Goto See;
        Missile:
            CYBR E 0 {
                if(!global.IsMutationActive("tyranny"))
                {
                    bAlwaysFast = false;
                    Speed = 16;
                    return ResolveState("Missile12");
                }

                // Only start counting after firing the first missile at the target
                // This then gets re-cleared in the global handler
                if(lastScoredHitTime == 0)
                {
                    lastScoredHitTime = Level.time;
                }

                let sinceLastHit = Level.time - lastScoredHitTime;
                let secondsPerTyrannyLevel = 10;
                if(sinceLastHit <= 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 0");
		            Speed = 16;
                    bAlwaysFast = false;
                    return ResolveState("Missile12");
                }
                else if (sinceLastHit <= 2 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 1");
		            Speed = 17;
                    bAlwaysFast = false;
                    return ResolveState("Missile11");
                }
                else if (sinceLastHit <= 3 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 2");
		            Speed = 18;
                    bAlwaysFast = false;
                    return ResolveState("Missile10");
                }
                else if (sinceLastHit <= 4 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 3");
		            Speed = 19;
                    bAlwaysFast = false;
                    return ResolveState("Missile9");
                }
                else if (sinceLastHit <= 5 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 4");
		            Speed = 20;
                    bAlwaysFast = true;
                    return ResolveState("Missile8");
                }
                else if (sinceLastHit <= 6 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 5");
		            Speed = 21;
                    bAlwaysFast = true;
                    return ResolveState("Missile7");
                }
                else if (sinceLastHit <= 7 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 6");
		            Speed = 22;
                    bAlwaysFast = true;
                    return ResolveState("Missile6");
                }
                else if (sinceLastHit <= 8 * 35 * secondsPerTyrannyLevel)
                {
                    //console.printf("tyranny level 7");
		            Speed = 23;
                    bAlwaysFast = true;
                    return ResolveState("Missile5");
                }
                else
                {
                    //console.printf("tyranny level 8");
		            Speed = 24;
                    bAlwaysFast = true;
                    return ResolveState("Missile4");
                }
            }
        Missile12:
            CYBR E 6 A_FaceTarget;
            CYBR F 12 HM_A_CyberAttack;
            CYBR E 12 A_FaceTarget;
            CYBR F 12 HM_A_CyberAttack;
            CYBR E 12 A_FaceTarget;
            CYBR F 12 HM_A_CyberAttack;
            Goto See;
        Missile11:
            CYBR E 6 A_FaceTarget;
            CYBR F 11 HM_A_CyberAttack;
            CYBR E 11 A_FaceTarget;
            CYBR F 11 HM_A_CyberAttack;
            CYBR E 11 A_FaceTarget;
            CYBR F 11 HM_A_CyberAttack;
            Goto See;
        Missile10:
            CYBR E 5 A_FaceTarget;
            CYBR F 10 HM_A_CyberAttack;
            CYBR E 10 A_FaceTarget;
            CYBR F 10 HM_A_CyberAttack;
            CYBR E 10 A_FaceTarget;
            CYBR F 10 HM_A_CyberAttack;
            Goto See;
        Missile9:
            CYBR E 5 A_FaceTarget;
            CYBR F 9 HM_A_CyberAttack;
            CYBR E 9 A_FaceTarget;
            CYBR F 9 HM_A_CyberAttack;
            CYBR E 9 A_FaceTarget;
            CYBR F 9 HM_A_CyberAttack;
            Goto See;
        Missile8:
            CYBR E 4 A_FaceTarget;
            CYBR F 8 HM_A_CyberAttack;
            CYBR E 8 A_FaceTarget;
            CYBR F 8 HM_A_CyberAttack;
            CYBR E 8 A_FaceTarget;
            CYBR F 8 HM_A_CyberAttack;
            Goto See;
        Missile7:
            CYBR E 4 A_FaceTarget;
            CYBR F 7 HM_A_CyberAttack;
            CYBR E 7 A_FaceTarget;
            CYBR F 7 HM_A_CyberAttack;
            CYBR E 7 A_FaceTarget;
            CYBR F 7 HM_A_CyberAttack;
            Goto See;
        Missile6:
            CYBR E 3 A_FaceTarget;
            CYBR F 6 HM_A_CyberAttack;
            CYBR E 6 A_FaceTarget;
            CYBR F 6 HM_A_CyberAttack;
            CYBR E 6 A_FaceTarget;
            CYBR F 6 HM_A_CyberAttack;
            Goto See;
        Missile5:
            CYBR E 3 A_FaceTarget;
            CYBR F 5 HM_A_CyberAttack;
            CYBR E 5 A_FaceTarget;
            CYBR F 5 HM_A_CyberAttack;
            CYBR E 5 A_FaceTarget;
            CYBR F 5 HM_A_CyberAttack;
            Goto See;
        Missile4:
            CYBR E 2 A_FaceTarget;
            CYBR F 4 HM_A_CyberAttack;
            CYBR E 4 A_FaceTarget;
            CYBR F 4 HM_A_CyberAttack;
            CYBR E 4 A_FaceTarget;
            CYBR F 4 HM_A_CyberAttack;
            Goto See;
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if(other == triumvirateMateA || other == triumvirateMateB)
        {
            return false;
        }

        return super.CanCollideWith(other, passive);
    }

    void HM_A_CyberAttack()
    {
        if(global.IsMutationActive("sovereignty"))
        {
            let r = random[pr_spawnfly](0, 255);
            if(r < 80) // ~33%
            {
                SpawnHellCube();
                return;
            }
        }
        
        A_CyberAttack();
    }

    void SpawnHellCube()
    {
        A_FaceTarget();

        // Pre-determine the monster which will be spawned by the cube
        class<Actor> spawnClass;
        let r = random[pr_spawnfly](0, 255);
        if (r < 50)  spawnClass = "DoomImp";
        else if (r < 90)  spawnClass = "Demon";
        else if (r < 120) spawnClass = "Spectre";
        else if (r < 130) spawnClass = "PainElemental";
        else if (r < 160) spawnClass = "Cacodemon";
        else if (r < 162) spawnClass = "Archvile";
        else if (r < 172) spawnClass = "Revenant";
        else if (r < 192) spawnClass = "Arachnotron";
        else if (r < 222) spawnClass = "Fatso";
        else if (r < 246) spawnClass = "HellKnight";
        else			  spawnClass = "BaronOfHell";

        let hellCube = HM_CyberdemonHellCube(SpawnMissile(target, "HM_CyberdemonHellCube"));
        if(hellCube != null)
        {
            hellCube.spawnClass = spawnClass;
            hellCube.A_SetSize(GetDefaultByType(spawnClass).Radius, GetDefaultByType(spawnClass).Height);
        }
    }
}

// Normal hell cubes use a predetermined targeting mechanism where the cube flies
// without collisions to its target (which was placed in the level by the mapper).
// This has to behave more like a regular missile.
class HM_CyberdemonHellCube: Actor
{
    Default
    {
		Radius 6;
		Height 32;
		Speed 20;
		Damage 3;
		Projectile;
		+RANDOMIZE
		SeeSound "brain/spit";
		DeathSound "brain/cubeboom";
		Obituary "$OB_MPROCKET";
    }

    class<Actor> spawnClass;

    States
    {       
        Spawn:
            BOSF A 3 BRIGHT A_StartSound("brain/cube", CHAN_BODY);
            BOSF BCD 3 BRIGHT;
            Loop;
        XDeath:
        Death:
            BOSF B 8 Bright HellCubeDeath();
            BOSF C 6 Bright;
            BOSF D 4 Bright;
            Stop;
    }

    void HellCubeDeath()
    {
        //Spawn('SpawnFire', pos, ALLOW_REPLACE);

        let spawnee = Spawn(spawnClass, pos, ALLOW_REPLACE);
        if(!spawnee)
        {
            return;
        }

        if(!spawnee.TestMobjLocation())
        {
            spawnee.Destroy();
            return;
        }

        console.printf("assign master %s ", target.GetClassName());
        spawnee.master = target;
        spawnee.target = tracer;
        spawnee.GiveInventory("HM_CybredemonSpawneeShield", 1);
        if(spawnee.SeeState != null)
        {
            spawnee.SetState (spawnee.SeeState);
        }
    }
}

class HM_Rocket : Rocket replaces Rocket
{
    mixin HM_GlobalRef;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("HyperFuel") && !(target is "PlayerPawn"))
        {
            A_ScaleVelocity(2);
        }
    }
}

// This makes the monsters spawned by sovereignty hell cubes immune to the cybredemon's rockets
// for the first second (so that the monster does no immediately die when fired in a barrage)
class HM_CybredemonSpawneeShield: Inventory
{
    override void DoEffect()
    {
        if(GetAge() > 35)
        {
            Destroy();
        }
    }

    override void ModifyDamage (int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
    {
        if(passive && source == owner.master)
        {
            newDamage = 0;
        }
    }
}