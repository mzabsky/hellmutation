class HM_RocketLauncher : DoomWeapon replaces RocketLauncher
{
    mixin HM_GlobalRef;

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
            MISG B 0 {
                // All In - as long as the player has 200 health and armor, use faster firing atk state
                let isAllInOn = player && player.mo
                    && invoker.global.IsPerkActive("allin")
                    && player.mo.Health >= 200
                    && player.mo.CountInv("BasicArmor") == 200;
                return isAllInOn 
                    ? ResolveState ("AllInFire") 
                    : ResolveState(null);
            }
            MISG B 8 A_GunFlash;
            MISG B 12 HM_A_FireMissile;
            MISG B 0 A_ReFire;
            Goto Ready;
        AllInFire:
            MISG B 4 A_GunFlash;
            MISG B 6 HM_A_FireMissile;
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
    
    // BeginPlay does not trigger properly during level transitions
    override void Travelled()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
        super.BeginPlay();
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

	// override State GetAtkState (bool hold)
	// {
    //     // All In - as long as the player has 200 health and armor, use faster firing atk state
    //     let isAllInOn = player && player.mo
    //         && global.IsPerkActive("allin")
    //         && player.mo.Health >= 200
    //         /*&& player.mo.CountInv("BasicArmor") == 200*/;
    //     console.printf(
    //         "all in %d %d %d => %d",
    //         global.IsPerkActive("allin"),
    //         player && player.mo && player.mo.Health,
    //         player && player.mo && player.mo.CountInv("BasicArmor"),
    //         isAllInOn
    //     );
	// 	return isAllInOn 
    //         ? FindState ("AllInFire") 
    //         : Super.GetAtkState(hold);
	// }
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