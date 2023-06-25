// Made by @Agent_Ash
class MonsterCorpseSpawner : Actor
{
    Actor tokill;
    
    Default
    {
        +NOBLOCKMAP
        +NOINTERACTION
        +NOSECTOR
    }
    
    static MonsterCorpseSpawner SpawnCorpse(class<Actor> who, vector3 pos)
    {
        let idc = MonsterCorpseSpawner(Actor.Spawn("MonsterCorpseSpawner", pos));
        let bod = Actor.Spawn(who, pos);
        if (idc && bod)
        {
            idc.tokill = bod;
        }
        return idc;
    }
    
    override void Tick()
    {
        if (!tokill)
        {
            Destroy();
            return;
        }
        
        if (tokill)
        {
            if (tokill.health > 0)
            {
                tokill.bCorpse = true;
                tokill.bSolid = false;
                tokill.bShootable = false;
                toKill.health = 0;
            }

            let finalState = tokill.ResolveState("Death");

            while (finalState.nextstate)
            {
                finalState = finalState.nextstate;
            }

            tokill.SetState(finalState);

            if (tokill.tics == -1)
            {
                tokill.SetOrigin((tokill.pos.x, tokill.pos.y, tokill.floorz), false);
                Destroy();
            }
        }

    }
}