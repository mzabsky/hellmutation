class HM_Chaingun : Chaingun replaces Chaingun
{
    mixin HM_GlobalRef;

    default
    {
        Weapon.SlotNumber 4;
    }

    states
    {
        Ready:
            CHGG A 1 A_WeaponReady;
            Loop;
        Deselect:
            CHGG A 1 A_Lower;
            Loop;
        Select:
            CHGG A 1 A_Raise;
            Loop;
        Fire:
            CHGG AB 4 {
              HM_A_FireCGun();
            }
            CHGG B 0 A_ReFire;
            Goto Ready;
        Flash:
            CHGF A 5 Bright A_Light1;
            Goto LightDone;
            CHGF B 5 Bright A_Light2;
            Goto LightDone;
        Spawn:
            MGUN A -1;
            Stop;
    }

    action void HM_A_FireCGun()
    {
        if (player == null)
        {
            return;
        }

        Weapon weap = player.ReadyWeapon;
        if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
        {
          if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
            return;

          A_StartSound ("weapons/chngun", CHAN_WEAPON);

          State flash = weap.FindState('Flash');
          if (flash != null)
          {
            // Removed most of the mess that was here in the C++ code because SetSafeFlash already does some thorough validation.
            State atk = weap.FindState('Fire');
            let psp = player.GetPSprite(PSP_WEAPON);
            if (psp) 
            {
              State cur = psp.CurState;
              int theflash = atk == cur? 0:1;
              player.SetSafeFlash(weap, flash, theflash);
            }
          }
        }
        player.mo.PlayAttacking2 ();

        HM_GunShot (!player.refire, "BulletPuff", BulletSlope ());
	  }

    protected action void HM_GunShot(bool accurate, Class<Actor> pufftype, double pitch)
    {
        int damage = 5 * random[GunShot](1, 3);
        double ang = angle;

        if (!accurate)
        {
          let longBarrelDivisor = 1;
          if(invoker.global.IsPerkActive("longbarrels"))
          {
              longBarrelDivisor = 2;
          }

          ang += Random2[GunShot]() * (5.625 / 256 / longBarrelDivisor);

          if (GetCVar ("vertspread") && !sv_novertspread)
          {
            pitch += Random2[GunShot]() * (3.549 / 256 / longBarrelDivisor);
          }
        }

        LineAttack(ang, PLAYERMISSILERANGE, pitch, damage, 'Hitscan', pufftype);
    }
}