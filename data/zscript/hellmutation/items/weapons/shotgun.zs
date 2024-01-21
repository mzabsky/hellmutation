class HM_Shotgun : Shotgun replaces Shotgun
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SlotNumber 3;
        Weapon.SelectionOrder 1300;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 8;
        Weapon.AmmoType "Shell";
        Inventory.PickupMessage "$GOTSHOTGUN";
        Obituary "$OB_MPSHOTGUN";
        Tag "$TAG_SHOTGUN";
    }

    states
    {
        Ready:
            SHTG A 1 A_WeaponReady;
            Loop;
        Deselect:
            SHTG A 1 A_Lower;
            Loop;
        Select:
            SHTG A 1 A_Raise;
            Loop;
        Fire:
            SHTG A 0 {
                if(invoker.global.IsPerkActive("rampage"))
                {
                    console.printf("slow fire");
                    return ResolveState("SlowFire");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            SHTG A 3;
            SHTG A 7 A_FireShotgun;
            SHTG BC 5;
            SHTG D 4;
            SHTG CB 5;
            SHTG A 3;
            SHTG A 7 A_ReFire;
            Goto Ready;
        SlowFire:
            SHTG A 6;
        RampageFreeReloadZoneStart:
            SHTG A 7 {
                A_FireShotgun();
                if(
                    invoker.global.IsPerkActive("rampage")
                    && invoker.owner is 'HM_Player'
                    && Level.Time - HM_Player(invoker.owner).lastShotgunKillTime <= 0
                )
                {
                    invoker.owner.player.bonusCount += 10;
                    return ResolveState("Ready");
                }
                else
                {
                    return ResolveState(null);
                }
            }
            SHTG A 0;
            SHTG BC 5;
            SHTG D 6;
            SHTG CB 8;
            SHTG A 5;
            SHTG A 10 A_ReFire;
        RampageFreeReloadZoneEnd:
            SHTG A 0;
            Goto Ready;
        Flash:
            SHTF A 4 Bright A_Light1;
            SHTF B 3 Bright A_Light2;
            Goto LightDone;
        Spawn:
            SHOT A -1;
            Stop;
    }
    
    // BeginPlay does not trigger properly during level transitions
    override void Travelled()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
        super.BeginPlay();
    }
}