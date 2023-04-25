class HM_LostSoul: LostSoul replaces LostSoul
{
    mixin HM_GlobalRef;

    States
    {
        Missile:
            SKUL C 0 BRIGHT{
                if (global.IsMutationActive("Ego"))
                {
                    SetDamage(8);
                }
                else
                {
                    RestoreDamage();
                }
            }
            SKUL C 10 BRIGHT A_FaceTarget;
            SKUL D 4 BRIGHT {
                if(global.IsMutationActive("seekingsouls"))
                {
                    A_SkullAttack(35);
                }
                else
                {
                    A_SkullAttack(20);
                }
            }
        Charge:
            SKUL D 0 {

            }
            SKUL CD 4 BRIGHT;
            Goto Charge;
        Death:
            SKUL F 0 BRIGHT {
                if(global.IsMutationActive("terminalpurpose"))
                {
                    A_Explode(10, 96, XF_NOTMISSILE, 1, 96);
                    Spawn("HM_LostSoulExplosion", Vec3Offset(0, 0, 20));
                }
            }
            SKUL F 6 BRIGHT;
            SKUL G 6 BRIGHT A_Scream;
            SKUL H 6 BRIGHT;
            SKUL I 6 BRIGHT A_NoBlocking;
            SKUL J 6;
            SKUL K 6;
            Stop;
    }

    override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        if(global.IsMutationActive("Ego"))
        {
            return super.DamageMobj(inflictor, source, damage * 2, mod, flags, angle);
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }
}

class HM_LostSoulExplosion: Actor
{
    Default
    {
        Species "LostSoul";
        RenderStyle "Add";
        alpha 0.9;
        +RANDOMIZE;
        +NOCLIP;
        +NOGRAVITY;
        Scale 1.0;
        ExplosionDamage 10;
        ExplosionRadius 32;
    }
    
    States
    {
        Spawn:
            MISL B 4 Bright;
            MISL C 3 Bright;
            MISL D 2 Bright;
            Stop;
    }
}
