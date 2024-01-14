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
    }

    states
    {
        Spawn:
            PLSS AB 6 Bright;
            Loop;
        Death:
            PLSE ABCDE 4 Bright;
            Stop;
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