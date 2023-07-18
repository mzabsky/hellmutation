// Originally developed by Agent_Ash at https://github.com/jekyllgrim/GZDoom-Target-Dummy
class HM_TargetDummy : Actor
{
    const DAMPING = 0.032;
    const PI = 3.14159;
    int receivedDmg;
    int dmgStaggerTime;
    string inf;
    string src;
    double pitchangVel;
    double pitchang;
    double rollangVel;
    double rollang;
    double hitDir;
    double hitangle;
    vector3 dmgpos;
    double basepitch;
    int classhealth;
    state spriteMainState;
    state spriteDeathState;    
    int deadtics;

    int damageThisSecond;
    int damageThisTenSecond;
    bool wasDamagedByPlayer;

    Default
    {
        +ISMONSTER
        +SHOOTABLE
        +SOLID
        +DONTTHRUST
        +NOTIMEFREEZE
        +NODAMAGE
        +NOBLOOD
        Radius 20;
        Height 56;
        Mass 100;
        painchance 0;
        Tag "Target dummy";        
    }

    States {
    Spawn:
        AMRK A -1;
        stop;
    }

    static clearscope double LinearMap(double val, double source_min, double source_max, double out_min, double out_max, bool clampIt = false)
    {
        double d = (val - source_min) * (out_max - out_min) / (source_max - source_min) + out_min;
        if (clampit)
        {
            double truemax = out_max > out_min ? out_max : out_min;
            double truemin = out_max > out_min ? out_min : out_max;
            d = Clamp(d, truemin, truemax);
        }
        return d;
    }

    void StartSwing(int damage)
    {
        double swingSpeed = Clamp(damage * 0.006, -0.5, 0.5) * LinearMap(mass, 100, 1000, 1, 0.1, true);    
        double pitchFacFront = LinearMap(abs(hitangle), 0, 90, -1., 0., true);
        double pitchFacBack = LinearMap(abs(hitangle), 90, 180, 0., 1., true);
        pitchangVel = (swingspeed * swingSpeed * pitchFacFront) + (swingspeed * swingSpeed * pitchFacBack);
        double rollFacFront = LinearMap(hitangle, 0, -90, 0, -1., true);
        double rollFacBack = LinearMap(hitangle, 0, 90, 0, 1., true);
        rollangVel = (swingspeed * swingSpeed * rollFacFront) + (swingspeed * swingSpeed * rollFacBack);
    }

    void SpawnDamageNumbers(Class<Actor> damageNumberClass, int damage, int zOffset, int lifetimeMultiplier)
    {
        string dmgstring = String.Format("%d", damage);
        int len = dmgstring.CodePointCount();
        for (int i = 0; i < len; i++)
        {
            let dnum = HM_DamageNumber(Spawn(damageNumberClass, (dmgpos.x, dmgpos.y, dmgpos.z + zOffset)));
            if (dnum)
            {
        dnum.lifetimeMultiplier = lifetimeMultiplier;
                dnum.A_SpriteOffset(i * 14 * dnum.scale.x);
                //string thisnum = dmgstring.Mid(i, 1);
                dnum.frame = dmgstring.ByteAt(i) - int("0");// thisnum.ToInt();
                if (!bSHOOTABLE)
                {
                    dnum.scale.y *= 1.2;
                }        
            }
        }
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        inf = inflictor ? inflictor.GetTag() : "unknown";
        src = source ?  source.GetTag() : "unknown";

        receivedDmg += damage;
        if (classhealth > 0)
            classhealth -= damage;
        
        if (random[simpainch](1, 256) <= painchance)
            A_StartSound(painsound, CHAN_BODY, CHANF_NOSTOP);

        hitangle = DeltaAngle(self.angle, AngleTo(inflictor));
        dmgStaggerTime = 1;

        dmgpos = pos + (0,0,height * 0.5);
        if (inflictor && inflictor != source)
        {
            let diff = Level.Vec2Diff(dmgpos.xy, inflictor.pos.xy);
            let dir = diff.unit();
            dmgpos.xy += (dir * radius * 0.75);
            dmgpos.z = inflictor.pos.z;
        }

    damageThisSecond += damage;
    damageThisTenSecond += damage;

    if(source && source is 'PlayerPawn')
    {
        wasDamagedByPlayer = true;
    }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }

    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        angle = Normalize180(angle);
    }

    override void Tick()
    {        
        super.Tick();

        if (deadtics > 0)
        {
            deadtics--;
            if (deadtics == 0)
            {
                bSHOOTABLE = true;
                sprite = spriteMainState.sprite;
                frame = spriteMainState.frame;
            }
        }

        if (dmgStaggerTime > 0)
        {
            dmgStaggerTime--;
            if (dmgStaggerTime <= 0)
            {
                string died;
                if (bFLATSPRITE && classhealth <= 0)
                {
                    died = " \c[Red]and died";
                    A_StartSound(deathsound, CHAN_BODY, CHANF_NOSTOP);
                    classhealth = health;
                    bSHOOTABLE = false;
                    sprite = spriteDeathState.sprite;
                    frame = spriteDeathState.frame;
                    deadtics = 70;
                }
                else
                {
                    StartSwing(receivedDmg);                
                    //if (receivedDmg > 15)
                    //    A_StartSound(painsound, CHAN_BODY, CHANF_NOSTOP);
                }
                SpawnDamageNumbers("HM_DamageNumber", receivedDmg, 0, 1);

                console.printfEx(PRINT_NOLOG, "\c[Green]%s received \c[Red]%d damage\c[Green] from \c[Cyan]%s\c[Green] (source: \c[Cyan]%s\c[Green])%s", GetTag(), receivedDmg, inf, src, died);
                receivedDmg = 0;
            }
        }

        if(Level.Time % 35 == 0 && damageThisSecond > 0)
        {
            
            SpawnDamageNumbers("HM_SecondDamageNumber", damageThisSecond, 28, 2);
            damageThisSecond = 0;
        }

        if(Level.Time % 350 == 0 && damageThisTenSecond > 0)
        {
            
            SpawnDamageNumbers("HM_TenSecondDamageNumber", damageThisTenSecond, 56, 3);
            damageThisTenSecond = 0;
        }

        pitchang = Clamp(pitchang += pitchangVel, -1.5, 1.5);
        pitchangVel += -(DAMPING * pitchang) - pitchangVel*DAMPING;
        pitch = pitchang * 180.0 / PI - (bFLATSPRITE ? 90 : 0);
        rollang = Clamp(rollang += rollangVel, -1.2, 1.2);
        rollangVel += -(DAMPING * rollang) - rollangVel*DAMPING;
        roll = rollang * 180.0 / PI * (bFLATSPRITE ? -1 : 1);

        // If a player damaged this, make all monsters currently targeting a player target this instead
        if(wasDamagedByPlayer)
        {
            let monsterFinder = ThinkerIterator.Create("Actor");
            Actor monster;
            while((monster = Actor(monsterFinder.next())) != null)
            {
                if(monster.bIsMonster && monster.health > 0 && monster.target && monster.target is 'PlayerPawn')
                {
                    monster.target = self;
                }
            }
            wasDamagedByPlayer = false;
        }
    }
}

class HM_DamageNumber : Actor
{
    Default
    {
        +NOBLOCKMAP
        scale 0.6;
    }

    int lifetimeMultiplier;

    override void Tick()
    {
        SetZ(pos.z+0.75);
        if (GetAge() > 25 * lifetimeMultiplier)
            A_FadeOut(0.05);
    }
    
    States {
    Spawn:
        TDNU A -1;
        stop;
    }
}

class HM_SecondDamageNumber : HM_DamageNumber
{
    Default
    {
        Translation "168:190=208:223";
        scale 1.1;
    }
}

class HM_TenSecondDamageNumber : HM_DamageNumber
{
    Default
    {
        scale 2.0;
        Translation "168:190=192:204", "191:191=244:244";
    }
}