class HM_TorrentExplosion: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +NOGRAVITY
        +PUFFONACTORS
        RenderStyle "Add";
        Scale 0.6;
        Damage 8;
    }
  
    States
    {
        Spawn:
            MISL B 0 Bright;
            MISL B 8 Bright {
              A_Explode(CalculateTorrentDamage(), 64, XF_HURTSOURCE, 0, 32);
            }
            MISL C 6 Bright;
            MISL D 4 Bright;
            Stop;
    }

    virtual int CalculateTorrentDamage()
    {
        return 8;
    }
}

class HM_ChaingunTorrentExplosion: HM_TorrentExplosion
{
    override int CalculateTorrentDamage()
    {
        return 5 * random(1, 3);
    }
}

class HM_HighGroundTorrentExplosion: Actor
{
    Default
    {
        Damage 9;
    }
}