class HM_Pistol : Pistol replaces Pistol
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SelectionOrder 1900;
        Weapon.SlotNumber 2;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 20;
        Weapon.AmmoType "Clip";
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
        super.BeginPlay();
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
}