class HM_ExplosiveBarrel: ExplosiveBarrel replaces ExplosiveBarrel
{
    mixin HM_GlobalRef;
    
    States
    {
        Death:
            BEXP A 5 BRIGHT;
            BEXP B 5 BRIGHT A_Scream;
            BEXP C 5 BRIGHT {
                if(global.IsPerkActive("nuclearnukage"))
                {
                    Spawn("HM_NuclearNukageGenerator", pos);
                }
            }
            BEXP D 10 BRIGHT {
                if(global.IsPerkActive("nuclearnukage"))
                {
                    A_Explode(180, 136);
                }
                else
                {
                    A_Explode();
                }
            }
            BEXP E 10 BRIGHT;
            TNT1 A 0 SpawnSurprise(false);
            TNT1 A 1050 BRIGHT A_BarrelDestroy;
            TNT1 A 5 A_Respawn;
            Wait;
    }

    void SpawnSurprise(bool ambush)
    {
        if(global.IsMutationActive("explosivesurprise"))
        {
            // Lower chance to spawn monsters in ambush mode
            let roll = random[HM_ExplosiveBarrel](0, 35 + ambush ? 24 : 0); 
            Class<Actor> klass;
            switch(roll)
            {
                case 0: case 1: case 22: case 23: klass = "HM_ZombieMan"; break;
                case 2: case 3: case 4: case 5: klass = "HM_ShotgunGuy"; break;
                case 6: case 7: klass = "HM_ZombieMan"; break; // HM_ChaingunGuy - needs check for doom 2
                case 8: case 9: case 10: case 11: case 12: case 13: klass = "HM_DoomImp"; break;
                case 14: case 15: klass = "HM_LostSoul"; break;
                case 16: klass = "HM_ArchImp"; break;
                case 17: case 18: case 19: klass = "HM_Demon"; break;
                case 20: case 21: klass = "HM_Spectre"; break;
                default: return; // Spawn nothing
            }
            let spawnee = Spawn(klass, pos, ALLOW_REPLACE);
            if(!spawnee)
            {
                return;
            }

            spawnee.A_SetSize(10); // Make sure the spawnee fits into whatever space the barrel fit into

            if(ambush)
            {
                // Spawn the monsters with ambush flag and make them face away from the player
                // and make them face away from the player
                // so that places like MAP23 are actually possible to complete in combination with
                // Workplace Safety.
                spawnee.SpawnFlags |= MTF_AMBUSH;
                spawnee.HandleSpawnFlags();

                if(players.Size() > 0 && players[0].mo)
                {
                    spawnee.angle = players[0].mo.AngleTo(spawnee);
                }
            }
            else
            {
                if(target)
                {
                    spawnee.target = target;
                    spawnee.A_Look();
                }
            }

            
        }
    }
}

class HM_NuclearNukageGenerator: Actor
{    
    mixin HM_GlobalRef;

    int RemainingTics;

    States
    {
        Spawn:
            TNT1 A -1;
            Stop;
    }

    override void PostBeginPlay ()
    {
        RemainingTics = 20;
        super.PostBeginPlay();
    }

    override void Tick()
    {
        if(RemainingTics <= 0)
        {
            Destroy();
            return;
        }

        RemainingTics--;

        if(RemainingTics % 2 == 0)
        {
            let spread = 64 - RemainingTics * 3;
            Spawn(
                "HM_NuclearNukageExplosion",
                Vec3Offset(
                    random[HM_NuclearNukageExplosion](-spread, spread), random[HM_NuclearNukageExplosion](-spread, spread), random[HM_NuclearNukageExplosion](0,64)
                )
            );
        }
        
        super.Tick();
    }
}

class HM_NuclearNukageExplosion: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +NOGRAVITY
        RenderStyle "Add";
        Damage 0;
        Translation "168:191=112:127", "32:47=9:12";
    }
  
    States
    {
        Spawn:
            MISL B 8 Bright;
            MISL C 6 Bright;
            MISL D 4 Bright;
            Stop;
  }
}