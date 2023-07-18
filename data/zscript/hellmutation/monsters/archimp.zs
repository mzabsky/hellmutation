class HM_ArchImp : DoomImp
{
    // The replacement of Imp is done by the global event handler -> WorldThingDamaged.

    mixin HM_GlobalRef;
    mixin HM_SacrificeAndPhylactery;
    mixin HM_GreaterRitual;

    Default
    {
        Tag "Arch-Imp";
        species "DoomImp";
        obituary "%o did not respect the Arch-Imp.";
        seesound "monster/hlnsit";
        painsound "monster/hlnpai";
        deathsound "monster/hlndth";
        activesound "monster/hlnact";
        Health 100;
		PainChance 100;
    }

    States
	{
        Spawn:
            HELN A 0;
            HELN AB 10 A_Look;
            goto Spawn;
        See:
            HELN A 0 {
                bAlwaysFast = global.IsMutationActive("Brightfire");
            }
            HELN AABBCCDDEEFF 2 FAST ResurrectChase();
            loop;
        Heal:
            HELN G 45 BRIGHT;
            Goto See;
        Melee:
        Missile:
            HELN G 0 FAST A_VileStart;
            HELN GHIJK 6 Bright FAST A_FaceTarget;
            HELN L 6 Bright FAST;
            HELN L 0 Bright ArchImpAttack();
            HELN L 2 FAST;
            goto See;
        Pain:
            HELN M 2;
            HELN M 2 A_Pain;
            goto See;
        Death:
            HELN N 6;
            HELN O 6 A_Scream;
            HELN PQR 6;
            HELN S 6 A_NoBlocking;
            HELN T -1;
            stop;
        XDeath:
            HELN U 5;
            HELN V 5 A_XScream;
            HELN W 5;
            HELN X 5 A_NoBlocking;
            HELN YZ 5;
            HELN "[\]" 5;
            HELN ] -1;
            stop;
        Raise:
            HELN TSRQPON 6;
            goto See;
        FastRaise:
            HELN TSRQPON 3;
            goto See;
    }

    void ArchImpAttack()
    {
        A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,-4);
        A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,-2);
        A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,0);
        A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,2);
        A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,4);
    }

    void ResurrectChase()
    {
        //if(global.IsMutationActive("reachingritual"))
        {
            let range = 386;
            BlockThingsIterator it = BlockThingsIterator.Create(self, range);
            Actor mo;

            while (it.Next())
            {
                mo = it.thing;
                if (!mo || mo == self || !mo.bIsMonster || mo.health > 0 || !CheckSight(mo) || !mo.CanRaise())
                {
                    continue;
                }

                let actualRange = radius + mo/*.GetDefault()*/.radius + 30; // I'm not sure why the 30 is necessary...
                        
                // This is the way P_CheckForResurrection does things
                let manhattanDist = min(
                    abs(pos.x - mo.pos.x),
                    abs(pos.y - mo.pos.y)
                );

                if(Distance3D(mo) > actualRange)
                {
                    //console.printf("out of range %d %d (%d/%d vs. %d/%d)", Distance3D(mo), actualRange, pos.x, pos.y, mo.pos.x, mo.pos.y);
                    continue;
                }

                if(RaiseActor(mo))
                {
                    A_Face(mo);
                    SetState(ResolveState("Heal"));

                    mo.target = target;

                    // Arch-imps are not eligible for phylactery

                    return;
                }
            }
        }

        A_Chase("Melee", "Missile");
    }
}

class HellionBall : CacodemonBall
{
    Default
    {
        Damage 3;
        Speed 10;
        Alpha 0.80;
        +THRUGHOST;
        +FORCEXYBILLBOARD;
        SeeSound "Monster/hlnatk";
        DeathSound "Monster/hlnexp";
    }

    States
    {
        Spawn:
            HLBL AB 3 bright A_SpawnItemEx("HellionPuff",0,0,0,0,0,0);
            loop;
        Death:
            HLBL JKLMN 3 bright;
            stop;
    }
}

class HellionPuff : Actor
{  
    Default
    {
        Radius 3;
        Height 3;
        //RENDERSTYLE ADD;
        Alpha 0.67;
        +NOGRAVITY;
        +NOBLOCKMAP;
        +DONTSPLASH;
        +FORCEXYBILLBOARD;
    } 
    
    States
    {
        Spawn:
            NULL A 3 Bright;
            HLBL CDEFGHI 3 BRIGHT;
            Stop;
    }
}