class HM_ExplosiveBarrel: ExplosiveBarrel replaces ExplosiveBarrel
{
    mixin HM_GlobalRef;
    
    States
    {
        Death:
            BEXP A 5 BRIGHT;
            BEXP B 5 BRIGHT A_Scream;
            BEXP C 5 BRIGHT;
            BEXP D 10 BRIGHT A_Explode;
            BEXP E 10 BRIGHT;
            TNT1 A 0 SpawnSurprise();
            TNT1 A 1050 BRIGHT A_BarrelDestroy;
            TNT1 A 5 A_Respawn;
            Wait;
    }

    void SpawnSurprise()
    {
        if(global.IsMutationActive("explosivesurprise"))
        {
            let roll = random[HM_ExplosiveBarrel](0, 15);
            Class<Actor> klass;
            switch(roll)
            {
                case 0: klass = "HM_ZombieMan"; break;
                case 1: case 2: klass = "HM_ShotgunGuy"; break;
                case 3: klass = "HM_ZombieMan"; break; // HM_ChaingunGuy - needs check for doom 2
                case 4: case 5: case 6: klass = "HM_DoomImp"; break;
                case 7: klass = "HM_LostSoul"; break;
                case 8: klass = "HM_ArchImp"; break;
                case 9: klass = "HM_Demon"; break;
                case 10: klass = "HM_Spectre"; break;
                default: return; // Spawn nothing
            }
            let spawnee = Spawn(klass, pos, ALLOW_REPLACE);
            if(!spawnee)
            {
                return;
            }

            spawnee.A_SetSize(10); // Make sure the spawnee fits into whatever space the barrel fit into

            if(target)
            {
                spawnee.target = target;
                spawnee.A_Look();
            }
        }
    }
}