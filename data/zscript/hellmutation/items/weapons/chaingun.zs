// class HM_Chaingun : Chaingun replaces Chaingun
// {
//     mixin HM_GlobalRef;

//     States
//     {
//         Ready:
//             CHGG A 1 A_WeaponReady;
//             Loop;
//         Deselect:
//             CHGG A 1 A_Lower;
//             Loop;
//         Select:
//             CHGG A 1 A_Raise;
//             Loop;
//         Fire:
//             CHGG AB 4 {
//               //HM_A_FireCGun();
//             }
//             CHGG B 0 A_ReFire;
//             Goto Ready;
//         Flash:
//             CHGF A 5 Bright A_Light1;
//             Goto LightDone;
//             CHGF B 5 Bright A_Light2;
//             Goto LightDone;
//         Spawn:
//             MGUN A -1;
//             Stop;
//     }

//     void HM_A_FireCGun()
//     {
//       if (player == null)
//       {
//           return;
//       }

//       console.printf("fire cg");

//       // Weapon weap = player.ReadyWeapon;
//       // if (weap != null && invoker == weap && stateinfo != null && stateinfo.mStateType == STATE_Psprite)
//       // {
//       //   if (!weap.DepleteAmmo (weap.bAltFire, true, 1))
//       //     return;

//       //   A_StartSound ("weapons/chngun", CHAN_WEAPON);

//       //   State flash = weap.FindState('Flash');
//       //   if (flash != null)
//       //   {
//       //     // Removed most of the mess that was here in the C++ code because SetSafeFlash already does some thorough validation.
//       //     State atk = weap.FindState('Fire');
//       //     let psp = player.GetPSprite(PSP_WEAPON);
//       //     if (psp) 
//       //     {
//       //       State cur = psp.CurState;
//       //       int theflash = atk == cur? 0:1;
//       //       player.SetSafeFlash(weap, flash, theflash);
//       //     }
//       //   }
//       // }
//       player.mo.PlayAttacking2 ();

//       GunShot (!player.refire, "BulletPuff", BulletSlope ());
// 	}
// }