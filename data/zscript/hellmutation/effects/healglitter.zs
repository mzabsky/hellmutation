class HM_HealGlitter: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +MISSILE
        Gravity -0.25;
        RenderStyle "Add";
        Damage 0;
    }
  
    States
    {
        Spawn:
            TGLT A 2 Bright A_FadeOut(0.05);
            TGLT B 2 Bright A_FadeOut(0.05);
            TGLT C 2 Bright A_FadeOut(0.05);
            TGLT D 2 Bright A_FadeOut(0.05);
            TGLT E 2 Bright A_FadeOut(0.05);
            Loop;
        Crash:
        Death:
        XDeath:
            TNT1 A 1;
            stop;
  }
}

class HM_HealGlitterGenerator: Inventory
{
    int RemainingTics;

    override void BeginPlay ()
    {
        RemainingTics = 35;
        super.BeginPlay();
    }

    override void DoEffect()
    {
        if(!owner || owner.IsFrozen())
        {
            return;
        }

        if(RemainingTics <= 0)
        {
            Destroy();
            return;
        }

        RemainingTics--;

        if(owner.GetAge() % 4 == 0)
        {
            Spawn(
                "HM_HealGlitter",
                owner.Vec3Offset(
                    random[TeleGlitter](-owner.radius,owner.radius), random[TeleGlitter](-owner.radius,owner.radius), random[TeleGlitter](0,owner.height)
                )
            );
        }
        
        super.DoEffect();
    }
}