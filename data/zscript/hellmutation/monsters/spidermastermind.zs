class HM_SpiderMastermind: SpiderMastermind replaces SpiderMastermind
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;
    mixin HM_BigFuckingWomp;

    int nextEggTime;

    States
    {
        See:
            SPID A 0 {
                if(global.IsMutationActive("argenthydraulics"))
                {
                    Speed = 24;
                    return ResolveState("FastSee");
                }
                else {
                    Speed = 12;
                    return ResolveState(null);
                }
            }
            SPID A 3 A_Metal;
            SPID ABB 3 A_Chase;
            SPID C 3 A_Metal;
            SPID CDD 3 A_Chase;
            SPID E 3 A_Metal;
            SPID EFF 3 A_Chase;
            Loop;
        FastSee:
            SPID A 2 A_Metal;
            SPID ABB 2 A_Chase;
            SPID C 2 A_Metal;
            SPID CDD 2 A_Chase;
            SPID E 2 A_Metal;
            SPID EFF 2 A_Chase;
            Goto See;
        Missile:
            SPID A 20 BRIGHT A_FaceTarget;
            SPID A 0 BRIGHT {
                if(!global.IsMutationActive("broodfabrication"))
                {
                    return;
                }

                // Spawn at most every 10 seconds
                if(nextEggTime > Level.time)
                {
                    return;
                }

                let startingHorizontalAngle = -50;
                let endingHorizontalAngle = 50;
                let horizontalAngleIncrement = 50;
                let epsilon = 0.0000001;
                for(let currentHorizontalAngle = startingHorizontalAngle; currentHorizontalAngle <= endingHorizontalAngle + epsilon; currentHorizontalAngle += horizontalAngleIncrement)
                {
                    A_CustomMissile("HM_SpiderEgg",32,0, currentHorizontalAngle,CMF_AIMOFFSET | CMF_OFFSETPITCH, 0);
                }

                nextEggTime = Level.time + 35 * 10;
            }
            SPID G 4 BRIGHT HM_A_SPosAttackUseAtkSound();
            SPID H 4 BRIGHT HM_A_SPosAttackUseAtkSound();
            SPID H 1 BRIGHT A_SpidRefire;
            Goto Missile+1;
        Raise:
            SPID RQPONML 10;
            SPID K 10;
            SPID J 20;
            Goto See;
        FastRaise:
            SPID RQPONML 5;
            SPID K 5;
            SPID J 10;
            Goto See;
    }

    private void HM_A_SPosAttackInternal()
    {
        if (target)
        {
            A_FaceTarget();
            double bangle = angle;
            double slope = AimLineAttack(bangle, MISSILERANGE);
        
            for (int i=0 ; i<3 ; i++)
            {
                double ang = bangle + Random2[SPosAttack]() * (22.5/256);
                int damage = Random[SPosAttack](1, 5) * 3;

                if(global.IsMutationActive("torrentcannons"))
                {
                    LineAttack(ang, MISSILERANGE, slope, 0, "Hitscan", "HM_TorrentExplosion");
                }
                else
                {
                    LineAttack(ang, MISSILERANGE, slope, DAMAGE, "Hitscan", "BulletPuff");
                }
            }
        }
    }

	void HM_A_SPosAttackUseAtkSound()
	{
		if (target)
		{
			A_StartSound(AttackSound, CHAN_WEAPON);
			HM_A_SPosAttackInternal();
		}
	}

    override bool OkayToSwitchTarget(Actor other)
    {
        // Do not infight with children
        if(other is 'HM_ChildArachnotron')
        {
            return false;
        }

        return super.OkayToSwitchTarget(other);
    }
}

/*class HM_SM_BulletPuff : Actor
{
	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+ALLOWPARTICLES
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Translucent";
		Alpha 0.5;
		VSpeed 1;
		Mass 5;
	}
	States
	{
	Spawn:
		PUFF A 4 Bright;
		PUFF B 4;
	Melee:
		PUFF CD 4;
		Stop;
	}

    override int SpecialMissileHit(Actor victim)
    {
        console.printf("smissile hit");
        return super.SpecialMissileHit(victim);
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        console.printf("puff collide with %s %d", other.GetClassName(), passive);
        return super.CanCollideWith(other, passive);
    }
}*/
	

class HM_SpiderEgg: Actor
{
    Default
	{
		Radius 64;
		Height 64;
		Speed 20;
		Damage 8;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 1;
		SeeSound "fatso/attack";
		DeathSound "fatso/shotx";
	}

    Actor originalTarget;

	States
	{
	Spawn:
		TNT1 AB 4 BRIGHT;
		Loop;
	Death:
        BSPI A 0 BRIGHT {
            SpawnArachnotron();
            Destroy();
            return;
        }
		TNT1 B 8 BRIGHT;
		TNT1 C 6 BRIGHT;
		TNT1 D 4 BRIGHT;
		Stop;
	}

    override void PostBeginPlay()
    {
        if(target)
        {
            originalTarget = target.target;
        }
        super.PostBeginPlay();
    }

    override void Tick()
    {
        // Do not let the eggs fly too far
        if(GetAge() > 20)
        {
            SpawnArachnotron();
            Destroy();
            return;
        }

        super.Tick();
    }

    void SpawnArachnotron()
    {
        let spawnee = HM_ChildArachnotron(Spawn("HM_ChildArachnotron", pos));
        if(!spawnee)
        {
            return;
        }
        
        if(!spawnee.TestMobjLocation())
        {
            spawnee.Destroy();
        }

        spawnee.target = originalTarget;
        spawnee.A_FaceTarget();
    }
}

class HM_ChildArachnotron: HM_Arachnotron
{
    Default
    {
        Species "Arachnotron";
    }

    /*override bool CanCollideWith(Actor other, bool passive)
    {
        console.printf("tron collide with %s %d", other.GetClassName(), passive);
        return super.CanCollideWith(other, passive);
    }*/

    override bool OkayToSwitchTarget(Actor other)
    {
        // Do not infight with mother
        if(other is 'SpiderMastermind')
        {
            return false;
        }

        return super.OkayToSwitchTarget(other);
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        // Do not get pained by spider masterminds (the mother painlocking her children is a bit silly)
        if(source is 'SpiderMastermind')
        {
            flags = flags | DMG_NO_PAIN;
        }

        // ... but still take the damage, otherwise it would be annoying
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}