class HM_Pistol : Pistol replaces Pistol
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SelectionOrder 1900;
        Weapon.SlotNumber 2;
        Weapon.AmmoUse 1;
        Weapon.AmmoUse2 5;
        Weapon.AmmoGive 20;
        Weapon.AmmoType "Clip";
        Weapon.AmmoType2 "Clip";
        Obituary "$OB_MPPISTOL";
        +WEAPON.WIMPY_WEAPON
        Inventory.Pickupmessage "$PICKUP_PISTOL_DROPPED";
        Tag "$TAG_PISTOL";
    }

    states
    {
        Ready:
            PISG A 1 {
                A_WeaponReady();
                invoker.bNoAlert = invoker.global.IsPerkActive("suppressor");
            }
            Loop;
        Deselect:
            PISG A 1 A_Lower;
            Loop;
        Select:
            PISG A 1 A_Raise;
            Loop;
        Fire:
            PISG A 4;
            PISG B 6 HM_A_FirePistol;
            PISG C 4;
            PISG B 5 A_ReFire;
            Goto Ready;
        AltFire:
            PISG A 0 {
                if(!invoker.global.IsPerkActive("flaregun"))
                {
                    return ResolveState("Ready");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            PISG A 4;
            PISG B 6 FireFlare();
            PISG C 4;
            PISG B 5 A_ReFire;
            Goto Ready;
        Flash:
            PISF A 7 Bright A_Light1;
            Goto LightDone;
            PISF A 7 Bright A_Light1;
            Goto LightDone;
        Spawn:
            PIST A -1;
            Stop;
    }
    
    // BeginPlay does not trigger properly during level transitions
    override void Travelled()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
        super.Travelled();
    }

    action void HM_A_FirePistol()
    {
        bool accurate;

        if (player != null)
        {
            Weapon weap = player.ReadyWeapon;
            if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
            {
              if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
                return;

              player.SetPsprite(PSP_FLASH, weap.FindState('Flash'), true);
            }
            player.mo.PlayAttacking2 ();

            accurate = !player.refire;
        }
        else
        {
            accurate = true;
        }

        if(!invoker.global.IsPerkActive("suppressor"))
        {
            A_StartSound ("weapons/pistol", CHAN_WEAPON);
        }
        HM_GunShot (accurate, BulletSlope ());
    }

    protected action void HM_GunShot(bool accurate, double pitch)
    {
        int damage = 5 * random[GunShot](1, 3);
        double ang = angle;

        if(invoker.global.IsPerkActive("largecaliber"))
        {
            damage *= 2;
        }

        if (!accurate)
        {
            ang += Random2[GunShot]() * (5.625 / 256);

            if (GetCVar ("vertspread") && !sv_novertspread)
            {
                pitch += Random2[GunShot]() * (3.549 / 256);
            }
        }

        LineAttack(ang, PLAYERMISSILERANGE, pitch, damage, 'Hitscan', 'BulletPuff');
    }

    private action void FireFlare()
    {
        if (player != null)
        {
            Weapon weap = player.ReadyWeapon;
            if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
            {
              if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
                return;

              player.SetPsprite(PSP_FLASH, weap.FindState('Flash'), true);
            }
            player.mo.PlayAttacking2 ();
        }

        SpawnPlayerMissile ("HM_PistolFlare");
    }
}

// Flare Gun projectile - Applies debuffs which makes enemies take more damage
class HM_PistolFlare: HereticImpBall
{
    default
    {
        Radius 8;
        Height 8;
        Speed 30;
        Damage 3;
        Scale 0.5;
        Projectile;
        SeeSound "himp/leaderattack";
        +SPAWNSOUNDSOURCE;
        RenderStyle "Add";
    }
  
    states
    {
        Spawn:
            FX10 ABC 6 Bright;
            Loop;
        Death:
            FX10 DEFG 5 Bright;
            Stop;
    }

    override int DoSpecialDamage(Actor target, int damage, name damagetype)
    {
        target.GiveInventoryType("HM_PistolFlareEffect");
        return super.DoSpecialDamage(target, damage, damagetype);
    }

    static void FlareSparks(Actor actor, int particleCount)
    {
        FSpawnParticleParams fp;
        fp.flags = SPF_FULLBRIGHT|SPF_REPLACE;
        fp.color1 = "fcb946"; // Yellowish orange
        for (int i = particleCount; i > 0; i--)
        {
            fp.lifetime = random[fp](40, 80);
            
            fp.pos.x = actor.pos.x + frandom[fp](-actor.radius, actor.radius);
            fp.pos.y = actor.pos.y + frandom[fp](-actor.radius, actor.radius);
            fp.pos.z = actor.pos.z + frandom[fp](0, actor.height);
            
            fp.vel.xy = (frandom[fp](-2, 2), frandom[fp](-2, 2));
            fp.vel.z = frandom[fp](-2, 2);
            fp.accel.xy = -(fp.vel.xy * 0.035); //acceleration is aimed to the opposite of velocity
            fp.accel.z = -0.035;

            fp.size = random[fp](1, 4);
            fp.sizeStep = -(fp.size / fp.lifetime); //size reduces to 0 over lifetime
            fp.startalpha = frandom[fp](0.75, 1.0);
            fp.fadestep = -1;
            fp.startRoll = frandom[fp](0, 360);
            fp.rollvel = frandom[fp](-15, 15);
            fp.rollacc = -(fp.rollvel / fp.lifetime); //rollvel reduces to 0 over lifetime

            Level.SpawnParticle(fp);
        }
    }

    override void Tick()
    {
        FlareSparks(self, 3);

        super.Tick();
    }
}

class HM_PistolFlareEffect: Inventory
{
    int RemainingTics;

    override void BeginPlay ()
    {
        RemainingTics = 35 * 15;
        super.BeginPlay();
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
    {
        if(passive) // Taking damage, do not consider damage from itself
        {
            newDamage = max(0, ApplyDamageFactors(GetClass(), damageType, damage, damage * 1.5));
        }
    }

    override void DoEffect()
    {
        if(!owner || owner.IsFrozen())
        {
            return;
        }

        if(RemainingTics <= 0)
        {
            Destroy();
            return;
        }

        RemainingTics--;

        if(owner.GetAge() % 4 == 0)
        {
            let particleCount = RemainingTics / 60 + 1;
            HM_PistolFlare.FlareSparks(owner, particleCount);
        }
        
        super.DoEffect();
    }
}