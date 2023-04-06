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
         Missile:
            POSS E 0 {
                if(global.IsMutationActive("Stormtroopers")) {
                    SetState(FindState("StormTrooperMissile"));
                }
            }
            POSS E 10 A_FaceTarget;
            POSS F 8 A_PosAttack;
            POSS E 8;
            goto See;
        StormTrooperMissile:
            POSS E 10 A_FaceTarget;
            POSS F 8 A_CustomBulletAttack(5, 0, 1, random(1,5)*3, "BulletPuff", 0, CBAF_NORANDOM);
            POSS E 8;
            goto See;
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
                    Spawnee.A_FaceTarget();
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
