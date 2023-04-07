class HM_Cacodemon : Cacodemon replaces Cacodemon
{
    mixin HM_GlobalRef;

    States
    {
      	Missile:
		        HEAD B 5 A_FaceTarget;
		        HEAD C 5 A_FaceTarget;
		        HEAD D 5 BRIGHT HM_A_HeadAttack();
		        Goto See;
    }

  //
	  void HM_A_HeadAttack()
	  {
		    let targ = target;
		    if (targ)
		    {
			      if (CheckMeleeRange())
			      {
				        int damage = random[pr_headattack](1, 6) * 10;
				        A_StartSound (AttackSound, CHAN_WEAPON);
				        int newdam = target.DamageMobj (self, self, damage, "Melee");
				        targ.TraceBleed (newdam > 0 ? newdam : damage, self);
			      }
			      else
			      {
                let isCacoblastersActive = global.IsMutationActive("Cacoblasters");

                if(isCacoblastersActive)
                {
                    A_SpawnProjectile ("CacodemonBall",26,0,-10,CMF_AIMOFFSET, 0);
                }
                
                A_SpawnProjectile ("CacodemonBall",26,0, 0,CMF_AIMOFFSET, 0);

                if(isCacoblastersActive)
                {
                    A_SpawnProjectile ("CacodemonBall",26,0,10,CMF_AIMOFFSET, 0);
                }
			      }
		  }
	}
}