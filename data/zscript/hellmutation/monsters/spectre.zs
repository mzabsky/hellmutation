class HM_Spectre : Spectre replaces Spectre
{
    // Copied in its entirety from HM_Demon
    mixin HM_GlobalRef;
    mixin HM_Macropods;
    mixin HM_Unstoppable;

    int lastDecloakTime;

    Default
    {
        Species "Demon";
    }

    States
    {
        See:
            SARG A 0 {
                bAlwaysFast = global.IsMutationActive("rage");
            }
            SARG A 0 UpdatePainThreshold();
            SARG AABBCCDD 2 Fast A_PounceChase;
            Loop;
        Melee: 
            SARG EF 8 A_FaceTarget;
            SARG G 8 SpectreAttack;
            Goto See;
        Pounce:
            SARG E 0 {
                lastPounceTime = Level.Time;
            }
            SARG E 4 A_FaceTarget;
            //SARG F 0 Thrust(5000, 0);
            SARG F 10 A_SkullAttack;
            SARG G 5 A_Gravity;
            Goto See;
        FastRaise:
            SARG N 3;
            SARG MLKJ 3;
            Goto See;
    }

    override void PostBeginPlay ()
    {
        // Born cloaked
        lastDecloakTime = -9999;
    }

	override bool CanCollideWith(Actor other, bool passive)
	{
        if(other is 'PlayerPawn')
        {
            lastDecloakTime = Level.Time;
        }

        return super.CanCollideWith(other, passive);
	}

    override void Tick()
    {
        if(bSkullfly)
        {
            lastDecloakTime = Level.Time;
        }

        if(global.IsMutationActive("camouflagefinesse"))
        {
            let decloakThreshold = 70;
            let ticksSinceDecloak = Level.time - lastDecloakTime;
            if(ticksSinceDecloak < decloakThreshold)
            {
                A_SetRenderStyle(double(decloakThreshold - ticksSinceDecloak) / double(decloakThreshold) * 0.5, STYLE_Translucent);
            }
            else
            {
                A_SetRenderStyle(0, STYLE_None);
            }
        }

        super.Tick();
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        lastDecloakTime = Level.Time;
        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }

    void SpectreAttack()
    {
        if(target != null)
        {
            lastDecloakTime = Level.Time;
        }
        A_SargAttack();
    }
}