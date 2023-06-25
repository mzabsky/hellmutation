class HM_TorrentExplosion: Actor
{
    Default
    {
        +NOBLOCKMAP;
        +NOTRIGGER;
        +NOGRAVITY
        +PUFFONACTORS
        RenderStyle "Add";
        Damage 8;
    }
  
    States
    {
        Spawn:
            MISL B 0 Bright;
            MISL B 8 Bright {
              A_Explode(Damage, 64, XF_HURTSOURCE, 0, 32);
            }
            MISL C 6 Bright;
            MISL D 4 Bright;
            Stop;
  }
}

class HM_HighGroundTorrentExplosion: Actor
{
    Default
    {
        Damage 9;
    }
}