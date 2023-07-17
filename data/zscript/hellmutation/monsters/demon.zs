class HM_Demon : Demon replaces Demon
{
    mixin HM_GlobalRef;
    mixin HM_Macropods;
    mixin HM_Unstoppable;

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
            SARG AABBCCDD 2 Fast A_PounceChase();
            Loop;
        Melee:
            SARG EF 8 A_FaceTarget;
            SARG G 8 A_SargAttack;
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
        Hatch:
        Raise:
            SARG N 5;
            SARG MLKJI 5;
            Goto See;
        FastRaise:
            SARG N 3;
            SARG MLKJI 3;
            Goto See;
    }
}

class HM_DemonEgg: Actor
{
    States
    {
        Spawn:
        Active:
            TNT1 A 70;
            TNT1 A 0
            {
                let spawnee = Spawn("HM_Demon", VEc3Offset(0, 0, 0), ALLOW_REPLACE);
                spawnee.SetState(spawnee.FindState("Hatch"));

                // Make sure the spawnee fits wherever the originator of the egg (a player presumably)
                // could fit.
                let demonRadius = 16;
                if(spawnee.target != null)
                {
                    demonRadius = spawnee.radius;
                }

                spawnee.A_SetSize(demonRadius);
            }
            Stop;
    }
}