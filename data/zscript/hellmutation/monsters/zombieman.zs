class HM_ZombieMan : ZombieMan replaces ZombieMan
{
    Default
    {
    }

    HM_GlobalEventHandler global;
    bool CollisionDisabled;
    Actor Spawnee;

    States
	{
        Death:
            POSS H 5;
            POSS I 5 A_Scream;
            POSS J 5 A_NoBlocking;
            POSS K 0 {
                if(!global.IsMutationRemoved("Decapitation"))
                {
                    CollisionDisabled = true;
                    Spawnee = Spawn("LostSoul", Vec3Offset(0, 0, 0), ALLOW_REPLACE);
                    Spawnee.A_Look();
                    SetState(FindState("XDeath+2"));
                }
            }
            POSS K 5;
            POSS L -1;
            Stop;
    }

    override void PostBeginPlay()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
    }

    override bool CanCollideWith(Actor other, bool passive)
    {
        if (CollisionDisabled)
        {
            return false;
        }

        return Super.CanCollideWIth(other, passive);
    }
}
