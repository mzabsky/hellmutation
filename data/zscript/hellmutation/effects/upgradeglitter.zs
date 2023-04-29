class HM_UpgradeGlitter: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +MISSILE
        Gravity -0.4;
        RenderStyle "Add";
        Damage 0;
    }
  
    States
    {
        Spawn:
            TGLT F 2 Bright A_FadeOut(0.1);
            TGLT G 2 Bright A_FadeOut(0.1);
            TGLT H 2 Bright A_FadeOut(0.1);
            TGLT I 2 Bright A_FadeOut(0.1);
            TGLT J 2 Bright A_FadeOut(0.1);
            Loop;
        Crash:
        Death:
        XDeath:
            TNT1 A 1;
            stop;
  }
}

class HM_UpgradeGlitterGenerator: Inventory
{
    int RemainingTics;

    override void BeginPlay ()
    {
        RemainingTics = 13;
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

        if(true/* || owner.GetAge() % 2 == 0*/)
        {
            Spawn(
                "HM_UpgradeGlitter",
                owner.Vec3Offset(
                    random[TeleGlitter](-owner.radius,owner.radius), random[TeleGlitter](-owner.radius,owner.radius), random[TeleGlitter](0,owner.height)
                )
            );
            Spawn(
                "HM_UpgradeGlitter",
                owner.Vec3Offset(
                    random[TeleGlitter](-owner.radius,owner.radius), random[TeleGlitter](-owner.radius,owner.radius), random[TeleGlitter](0,owner.height)
                )
            );
        }
        
        super.DoEffect();
    }
}