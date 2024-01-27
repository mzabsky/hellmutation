class HM_Chainsaw : Chainsaw
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SlotNumber 1;
        Weapon.Kickback 0;
        Weapon.SelectionOrder 2200;
        Weapon.UpSound "weapons/sawup";
        Weapon.ReadySound "weapons/sawidle";
        Inventory.PickupMessage "$GOTCHAINSAW";
        Obituary "$OB_MPCHAINSAW";
        Tag "$TAG_CHAINSAW";
        +WEAPON.MELEEWEAPON		
        +WEAPON.NOAUTOSWITCHTO
    }

    states
    {
        Ready:
            SAWG CD 4 A_WeaponReady;
            Loop;
        Deselect:
            SAWG C 1 A_Lower;
            Loop;
        Select:
            SAWG C 1 A_Raise;
            Loop;
        Fire:
            SAWG AB 4 HM_A_Saw;
            SAWG B 0 A_ReFire;
            Goto Ready;
        Spawn:
            CSAW A -1;
            Stop;
    }

    action void HM_A_Saw(
        sound fullsound = "weapons/sawfull",
        sound hitsound = "weapons/sawhit",
        int damage = 2,
        class<Actor> pufftype = "BulletPuff",
        int flags = 0,
        double range = 0,
        double spread_xy = 2.8125,
        double spread_z = 0
    )
    {
        FTranslatedLineTarget t;

        if (player == null)
        {
            return;
        }

        if (pufftype == null)
        {
            pufftype = 'BulletPuff';
        }

        if (damage == 0)
        {
            damage = 2;
        }

        if (invoker.global.IsPerkActive("precisionsurgery"))
        {
            pufftype = 'NoPainPuff';
            damage *= 3;
        }
        
        if (!(flags & SF_NORANDOM))
        {
            damage *= random[Saw](1, 10);
        }
        
        if (range == 0)
        { 
            range = MeleeRange + MELEEDELTA + (1. / 65536.); // MBF21 SAWRANGE;
        }

        double ang = angle + spread_xy * (Random2[Saw]() / 255.);
        double slope = AimLineAttack (ang, range, t) + spread_z * (Random2[Saw]() / 255.);

        Weapon weap = player.ReadyWeapon;


        int puffFlags = (flags & SF_NORANDOMPUFFZ) ? LAF_NORANDOMPUFFZ : 0;

        Actor puff;
        int actualdamage;
        [puff, actualdamage] = LineAttack (ang, range, slope, damage, 'Melee', pufftype, puffFlags, t);

        if (!t.linetarget)
        {
            if ((flags & SF_RANDOMLIGHTMISS) && (Random[Saw]() > 64))
            {
                player.extralight = !player.extralight;
            }

            A_StartSound (fullsound, CHAN_WEAPON);
            return;
        }

        A_StartSound (hitsound, CHAN_WEAPON);

        // turn to face target
        if (!(flags & SF_NOTURN))
        {
            double anglediff = deltaangle(angle, t.angleFromSource);

            if (anglediff < 0.0)
            {
                if (anglediff < -4.5)
                    angle = t.angleFromSource + 90.0 / 21;
                else
                    angle -= 4.5;
            }
            else
            {
                if (anglediff > 4.5)
                    angle = t.angleFromSource - 90.0 / 21;
                else
                    angle += 4.5;
            }
        }

        if (!(flags & SF_NOPULLIN))
            bJustAttacked = true;
    }
}