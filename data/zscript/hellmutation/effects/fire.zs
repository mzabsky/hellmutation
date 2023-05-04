Class HM_Fire : Actor
{
    Default
    {
      Obituary "%o was set ablaze by a Mancubus.";
      Radius 12;
      Height 1;
      Speed 0;
      RenderStyle "Add";
      DamageType "Fire";
      Alpha 0.9;
      +BOUNCEONWALLS;
      +BOUNCEONFLOORS;
      +BOUNCEONCEILINGS;
      +NOBLOCKMAP;
      BounceFactor 1;
      +NoTarget;
      +NoDamageThrust;
      +RANDOMIZE;
    }

    bool isFinished;

    States
    {
        Spawn:
            CFCF A 2 Bright FireAttack(1);
            CFCF B 2 Bright FireAttack(2);
            CFCF C 2 Bright FireAttack(2);
            CFCF D 2 Bright FireAttack(2);
            CFCF E 2 Bright FireAttack(1);
            CFCF F 2 Bright FireAttack(2);
            CFCF G 2 Bright FireAttack(2);
            CFCF H 2 Bright FireAttack(1);
            CFCF I 2 Bright FireAttack(2);
            CFCF J 2 Bright FireAttack(2);
            CFCF K 2 Bright FireAttack(1);
            CFCF L 2 Bright FireAttack(1);
            CFCF M 2 Bright FireAttack(1);
            Loop;
        Death:
            CFCF NOP 2 Bright;
            Stop;
  
  }

  override void BeginPlay()
  {
      if(random[HM_Fire](0, 1) == 0)
      {
          bSpriteFlip = true;
          A_SetScale(random[HM_Fire](90, 110) / 100.0);
      }
  }

  override void Tick()
  {
      if(!isFinished && GetAge() > 35 * 5 && random[HM_Fire](0, 10) == 0)
      {
          isFinished = true;
          SetState(ResolveState("Death"));
      }

      super.Tick();
  }

  override bool CanCollideWith(Actor other, bool passive)
  {
      return false;
  } 

  void FireAttack(int damage)
  {
    A_Explode(damage, 32);
    A_Fire();
  }
}