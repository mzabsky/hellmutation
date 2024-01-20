class HM_PlasmaRifle : DoomWeapon replaces PlasmaRifle
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SelectionOrder 100;
        Weapon.SlotNumber 6;
        Weapon.AmmoUse 1;
        Weapon.AmmoGive 40;
        Weapon.AmmoType "Cell";
        Inventory.PickupMessage "$GOTPLASMA";
        Tag "$TAG_PLASMARIFLE";
    }
    States
    {
        Ready:
            PLSG A 1 A_WeaponReady;
            Loop;
        Deselect:
            PLSG A 1 A_Lower;
            Loop;
        Select:
            PLSG A 1 A_Raise;
            Loop;
        Fire:
            PLSG A 3 HM_A_FirePlasma;
            PLSG B 20 A_ReFire;
            Goto Ready;
        Flash:
            PLSF A 4 Bright A_Light1;
            Goto LightDone;
            PLSF B 4 Bright A_Light1;
            Goto LightDone;
        Spawn:
            PLAS A -1;
        Stop;
    }
    
    // BeginPlay does not trigger properly during level transitions
    override void Travelled()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
        super.Travelled();
    }

    action void HM_A_FirePlasma()
    {
        if (player == null)
        {
            return;
        }

        let powerLimit = self.GetAmmoCapacity("Cell") - 100;
        int ammoCost = 1;
        Class<Actor> projectileType;
        if(invoker.global.IsPerkActive("highvoltage") && self.CountInv("Cell") > powerLimit)
        {
            projectileType = "HM_PowerPlasmaBall";
            ammoCost = 2;
        }
        else
        {
            projectileType = "HM_PlasmaBall";
        }

        Weapon weap = player.ReadyWeapon;
        if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
        {
            if (!weap.DepleteAmmo (weap.bAltFire, true, ammoCost, true))
                return;

            State flash = weap.FindState('Flash');
            if (flash != null)
            {
                player.SetSafeFlash(weap, flash, random[FirePlasma](0, 1));
            }

        }

        SpawnPlayerMissile (projectileType);
    }
}

class HM_PlasmaBall : Actor
{
    mixin HM_GlobalRef;
    
    default
    {
        Radius 13;
        Height 8;
        Speed 25;
        Damage 5;
        Projectile;
        +RANDOMIZE
        +ZDOOMTRANS
        RenderStyle "Add";
        Alpha 0.75;
        SeeSound "weapons/plasmaf";
        DeathSound "weapons/plasmax";
        Obituary "$OB_MPPLASMARIFLE";

        //
        //BounceCount 0;
    }

    override void PostBeginPlay()
    {
        if(global.IsPerkActive("coherentplasma"))
        {
            BounceCount = 2;
            bBounceOnWalls = true;
            bBounceOnFloors = true;
            bBounceOnCeilings = true;
            bUseBounceState = true;
        }
    }

    states
    {
        Bounce:
            PLSE A 4 Bright { bHitOwner = true; } // The projectiles can hit the player who fired them once they bounce
        Spawn:
            PLSS AB 6 Bright;
            Loop;
        Death:
            PLSE ABCDE 4 Bright;
            Stop;
    }

    override int DoSpecialDamage(Actor target, int damage, name damagetype)
    {
        if(target != null && target.cursector != null && global.IsPerkActive("causticresonance") && target.cursector.damageamount > 0)
        {
            return super.DoSpecialDamage(target, damage, damagetype) * 3 / 2;
        }

        return super.DoSpecialDamage(target, damage, damagetype);
    }
}

class HM_PowerPlasmaBall : HM_PlasmaBall
{
    default
    {
        Damage 10;
        Scale 1.5;
        Alpha 0.85;
    }
}