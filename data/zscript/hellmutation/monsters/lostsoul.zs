class HM_LostSoul: LostSoul replaces LostSoul
{
    mixin RefToHandler;

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
		        SKUL D 4 BRIGHT A_SkullAttack;
		        SKUL CD 4 BRIGHT;
		        Goto Missile+3;
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