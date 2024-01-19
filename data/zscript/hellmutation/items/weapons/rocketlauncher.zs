class HM_RocketLauncher : DoomWeapon replaces RocketLauncher
{
    default
    {
        Weapon.SelectionOrder 2500;
        Weapon.SlotNumber 5;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 2;
        Weapon.AmmoType "RocketAmmo";
        +WEAPON.NOAUTOFIRE
        Inventory.PickupMessage "$GOTLAUNCHER";
        Tag "$TAG_ROCKETLAUNCHER";
    }

    states
    {
        Ready:
            MISG A 1 A_WeaponReady;
            Loop;
        Deselect:
            MISG A 1 A_Lower;
            Loop;
        Select:
            MISG A 1 A_Raise;
            Loop;
        Fire:
            MISG B 8 A_GunFlash;
            MISG B 12 HM_A_FireMissile;
            MISG B 0 A_ReFire;
            Goto Ready;
        Flash:
            MISF A 3 Bright A_Light1;
            MISF B 4 Bright;
            MISF CD 4 Bright A_Light2;
            Goto LightDone;
        Spawn:
            LAUN A -1;
            Stop;
    }

    action void HM_A_FireMissile()
    {
        console.printf("Fire rocket");

        if (player == null)
        {
            return;
        }

        Weapon weap = player.ReadyWeapon;
        if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
        {
            if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
                return;
        }

        SpawnPlayerMissile ("HM_PlayerRocket");
    }
}

class HM_PlayerRocket : Rocket
{
    mixin HM_GlobalRef;

    // Performance Bonus - count kills so that ammo can be refunded (in WorldThingDied)
    int KillCount;

    override void PostBeginPlay()
    {
        if(global.IsPerkActive("tunedthrust"))
        {
            vel.x = vel.x * 2;
            vel.y = vel.y * 2;
            vel.z = vel.z * 2;
        }
    }
}