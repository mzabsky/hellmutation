class HM_Revenant : Revenant replaces Revenant
{
    mixin HM_GlobalRef;

    int lastDecoyTime;
    bool decoyRequested;

    States
    {
        Missile:
            /*SKEL J 0 {    WIP
                if(true || random[HM_Revenant](0, 4) == 0)
                {
                    return ResolveState("SpecialMissile");
                }
                else
                {
                    return ResolveState(null);
                }
            }*/
            SKEL J 0 BRIGHT A_FaceTarget;
            SKEL J 10 BRIGHT A_FaceTarget;
            SKEL K 10 A_SkelMissile;
            SKEL K 10 A_FaceTarget;
            Goto See;
        SpecialMissile:
            SKEL J 0 BRIGHT A_FaceTarget;
            SKEL J 10 BRIGHT A_FaceTarget;
            SKEL K 10 LaunchBarrage();
            SKEL K 10 A_FaceTarget;
            Goto See;
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

    void LaunchBarrage()
    {
        if (target == null) return;
        A_FaceTarget();
        LaunchBarrageMissile(-32, 0);
        LaunchBarrageMissile(-32, 2);
        LaunchBarrageMissile(0, 2);
        LaunchBarrageMissile(32, 2);
        LaunchBarrageMissile(32, 0);
    }

    void LaunchBarrageMissile(int angleOffset, int vz)
    {
        //AddZ(16);
        let missile = HM_RevenantTracer(SpawnMissileAngleZSpeed(48, /*target, */"HM_RevenantTracer", angle + angleOffset, vz, 10));
        //AddZ(-16);
        if (missile != null)
        {
            //console.printf("missileS %d %d", missile.angle, missile.pitch);
            //missile.A_SetAngle(missile.angle + angleOffset);
            //missile.A_SetPitch(missile.pitch + pitchOffset);
            //console.printf("missileA %d %d", missile.angle, missile.pitch);
            missile.SetOrigin(missile.Vec3Offset(missile.Vel.X, missile.Vel.Y, 0.), false);
            missile.tracer = target;
            missile.EnsureTracer();
            missile.missileN = angleOffset * 1000 + vz;
            //missile.notTracerUntil = level.time + 5;
        }
    }

    override void Tick()
    {
        if(decoyRequested && health > 0)
        {
            let decoy = HM_RevenantDecoy(Spawn("HM_RevenantDecoy", Vec3Offset(0, 0, 0), ALLOW_REPLACE));
            if(decoy != null)
            {
                decoy.A_SetAngle(angle);
                decoy.SetState(decoy.ResolveState("pain"));
                lastDecoyTime = Level.time;
            }
            
            decoyRequested = false;
        }

        super.Tick();
    }
}

class HM_RevenantDecoy : Revenant
{
    Default
    {
        Health 1;
    }

    States
    {
        Melee:
            SKEL G 0 A_FaceTarget;
            SKEL G 6 A_SkelWhoosh;
            SKEL H 6 A_FaceTarget;
            SKEL I 6;
            Goto See;
        Missile:
            SKEL J 0 BRIGHT A_FaceTarget;
            SKEL J 10 BRIGHT A_FaceTarget;
            SKEL K 10;
            SKEL K 10 A_FaceTarget;
            Goto See;
        Death:
            SKEL L 0 A_NoBlocking;
            SKEL L 0 A_FadeOut(0.2);
            SKEL LM 7 A_FadeOut(0.2);
            SKEL N 7 A_FadeOut(0.2);
            SKEL O 7 A_FadeOut(0.2);
            SKEL P 7;
            SKEL Q -1;
            Stop;
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if(other is 'Revenant' || other is 'RevenantTracer')
        {
            return false;
        }

        return super.CanCollideWith(other, passive);
    }

    override bool CanResurrect(Actor other, bool passive)
    {
        return false;
    }
}


class HM_RevenantTracer : RevenantTracer replaces RevenantTracer
{
    mixin HM_GlobalRef;

    bool isLockOnActive;

    int levelTimeOffset;
    int notTracerUntil;
    int missileN;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("hyperfuel") && !(target is "PlayerPawn"))
        {
            A_ScaleVelocity(1.5);
        }

        isLockOnActive = global.IsMutationActive("lockon");
    }

    States
    {
        Spawn:
            FATB AB 2 BRIGHT HM_A_Tracer;
            Loop;
    }

    void HM_A_Tracer()
    {
        // killough 1/18/98: this is why some missiles do not have smoke
        // and some do. Also, internal demos start at random gametics, thus
        // the bug in which revenants cause internal demos to go out of sync.

        console.printf("tracercheck %d %d %d %d %d, ", missileN, level.time, notTracerUntil, levelTimeOffset, notTracerUntil > level.time || (level.maptime + levelTimeOffset) & 3);

        if (notTracerUntil > level.time || (level.maptime + levelTimeOffset) & 3) return;

        // spawn a puff of smoke behind the rocket
        SpawnPuff ("BulletPuff", pos, angle, angle, 3);
        Actor smoke = Spawn ("RevenantTracerSmoke", Vec3Offset(-Vel.X, -Vel.Y, 0.), ALLOW_REPLACE);
    
        if (smoke != null)
        {
            smoke.Vel.Z = 1.;
            smoke.tics -= random[Tracer](0, 3);
            if (smoke.tics < 1)
                smoke.tics = 1;
        }

        // The rest of this function was identical with Strife's version, except for the angle being used.
          (16.875);
    }

    void EnsureTracer()
    {
        // This needs to be called just after the missile is spawned
        if(level.maptime % 4 == 0)
        {
            console.printf("made tracer %d", level.time);
            levelTimeOffset = 1;
        }
        else
        {
            levelTimeOffset = 0;
        }
    }
}