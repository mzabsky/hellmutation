class HM_ArchImp : DoomImp
{
    // The replacement of Imp is done by the global event handler -> WorldThingDamaged.

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

    HM_GlobalEventHandler global;

    States
	{
        Spawn:
            HELN A 0;
            HELN AB 10 A_Look;
            goto Spawn;
        See:
            HELN AABBCCDDEEFF 2 A_Chase("Melee", "Missile", CHF_RESURRECT);
            loop;
        Heal:
            HELN G 30 BRIGHT;
            Goto See;
        Melee:
        Missile:
            HELN G 0 A_VileStart;
            HELN GHIJK 6 Bright A_FaceTarget;
            HELN L 6 Bright;
            HELN L 0 Bright A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,-4);
            HELN L 0 Bright A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,-2);
            HELN L 0 Bright A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,0);
            HELN L 0 Bright A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,2);
            HELN L 0 Bright A_SpawnProjectile ("HellionBall",32,0,0,CMF_OFFSETPITCH ,4);
            HELN L 2;
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
    }

    override void PostBeginPlay()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
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