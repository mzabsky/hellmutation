class HM_Fist : Weapon replaces Fist
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SlotNumber 1;
        Weapon.SelectionOrder 3700;
        Weapon.Kickback 100;
        Obituary "$OB_MPFIST";
        Tag "$TAG_FIST";
        +WEAPON.WIMPY_WEAPON
        +WEAPON.MELEEWEAPON
        +WEAPON.NOAUTOSWITCHTO
    }

    states
    {
        Ready:
            PUNG A 1 A_WeaponReady;
            Loop;
        Deselect:
            PUNG A 1 A_Lower;
            Loop;
        Select:
            PUNG A 1 A_Raise;
            Loop;
        Fire:
            PUNG B 4;
            PUNG C 4 {
                A_Punch();
                PunchAwayProjectiles();
            }
            PUNG D 5;
            PUNG C 4;
            PUNG B 5 A_ReFire;
            Goto Ready;
    }
    
    // BeginPlay does not trigger properly during level transitions
    override void Travelled()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
        super.Travelled();
    }

    // Deflecting Punch - Punching deflects projectiles in direction where the player is looking
    action void PunchAwayProjectiles()
    {
        if (!invoker.global.IsPerkActive("deflectingpunch"))
        {
            return;
        }

        let range = 128;
        // Can't use the BlockThingsIterator, projectiles do not exist in the block map
        ThinkerIterator finder = ThinkerIterator.Create("Actor");
        Actor actor;
        while((actor = Actor(finder.next())) != null)
        {
            if (!actor || !actor.bMissile || Distance3D(actor) > range)
            {
                continue;
            }

            // The projectile can now hit the enemy who fired it, and gets credited to the player
            actor.target = player.mo;

            // Many of the projectiles would do very little at their initial damage (monsters have a lot of health)
            actor.SetDamage(actor.Damage * 2);

            // Maintain absolute velocity, change direction to players looking direction
            actor.Vel3DFromAngle(actor.vel.Length(), player.mo.angle, player.mo.pitch);
        }
    }
}
