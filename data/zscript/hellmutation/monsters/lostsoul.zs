class HM_LostSoul: LostSoul replaces LostSoul
{
    mixin HM_GlobalRef;

    HM_PainElemental parent;

    States
    {
        Missile:
            SKUL C 0 BRIGHT{
                if (global.IsMutationActive("pride"))
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
                if(global.IsMutationActive("desire"))
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
                if(global.IsMutationActive("closure"))
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
        // Take no damage from Regret explosions
        if(mod == 'Regret')
        {
            return 0;
        }

        if(global.IsMutationActive("ego"))
        {
            return super.DamageMobj(inflictor, source, damage * 2, mod, flags, angle);
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }

    override bool OkayToSwitchTarget(Actor other)
    {
        if((other is 'LostSoul' || other is 'PainElemental') && global.IsMutationActive("losttogether"))
        {
            return false;
        }

        return super.OkayToSwitchTarget(other);
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
