//Hades Sphere
Class HM_PainSeed : Actor
{
    int seedDamage;
    int seedRadius;

    Default
    {
      Health 35;
      Radius 24;
      Height 48;
      Mass 3000;
      Speed 0;
      RenderStyle "Add";
      Obituary "%o couldn't handle the pain.";
      SeeSound "monster/hadsit";
      DeathSound "monster/hadexp";
      Monster;
      +LOOKALLAROUND
      +DONTGIB
      +NOTARGET
      +NOGRAVITY
      +FLOAT
      +DONTFALL
    }

    States
    {
        Spawn:
            HADE ABCDEFGH 4 Bright;
            HADE H 0 {
              A_Explode(seedDamage, seedRadius, 0, 0, seedRadius);
            } 
            Loop;
        Death:
            HADE M 4 Bright;
            HADE NOPQ 5 Bright;
            Stop;
    }

    void SetSourceHealthLoss(int healthLoss)
    {
        seedRadius = 128;
        seedDamage = healthLoss / 5;
        A_SetHealth(healthLoss * 3);
        A_SetScale(max(0.3, healthLoss / 100));
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if(!other)
        {
            return false;
        }

        if(other is 'PlayerPawn' || other.bIsMonster)
        {
            return false;
        }

        return super.CanCollideWith(other, passive);
    }
}