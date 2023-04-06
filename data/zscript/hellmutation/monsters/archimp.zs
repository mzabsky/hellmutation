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
            HELN AABBCCDDEEFF 2 A_Chase;
            loop;
	      Melee:
        Missile:
            HELN G 0 A_VileStart;
            HELN GHIJK 6 Bright A_FaceTarget;
            HELN L 6 Bright;
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-30,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-29,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-28,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-27,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-26,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-25,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-24,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-23,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-22,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-21,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-20,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-19,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-18,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-17,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-16,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-15,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-14,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-13,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-12,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-11,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-10,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-9,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-8,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-7,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-6,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-5,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-4,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-3,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-2,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,-1,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,0,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,1,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,2,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,3,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,4,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,5,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,6,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,7,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,9,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,10,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,11,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,12,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,13,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,14,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,15,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,16,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,17,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,18,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,19,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,20,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,21,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,22,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,23,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,24,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,25,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,26,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,27,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,28,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,29,CMF_AIMOFFSET,0);
            HELN L 0 Bright A_CustomMissile("HellionBall",32,0,30,CMF_AIMOFFSET,0);
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