class HM_ArchVile : ArchVile replaces ArchVile
{
    mixin HM_GlobalRef;
    mixin HM_Sacrifice;
    mixin HM_GreaterRitual;
    
    States
    {
        Raise:
            VILE YXWVUT 7;
            VILE S 7;
            VILE R 7;
            VILE Q 7;
            Goto See;
        Missile:
            VILE G 0 BRIGHT A_VileStart;
            VILE G 10 BRIGHT A_FaceTarget;
            VILE H 8 BRIGHT A_VileTarget;
            VILE IJKLMN 8 BRIGHT A_FaceTarget;
            VILE O 8 BRIGHT HM_A_VileAttack;
            VILE P 20 BRIGHT;
            Goto See;
    }

    void HM_A_VileAttack(sound snd = "vile/stop", int initialdmg = 20, int blastdmg = 70, int blastradius = 70, double thrust = 1.0, name damagetype = "Fire", int flags = 0)
    {
        Actor targ = target;
        if (targ)
        {
            A_FaceTarget();
            if (!CheckSight(targ, 0)) return;
            A_StartSound(snd, CHAN_WEAPON);
            int newdam = targ.DamageMobj (self, self, initialdmg, (flags & VAF_DMGTYPEAPPLYTODIRECT)? damagetype : 'none');

            targ.TraceBleed (newdam > 0 ? newdam : initialdmg, self);
            
            Actor fire = tracer;
            if (fire)
            {
                // move the fire between the vile and the player
                fire.SetOrigin(targ.Vec3Angle(-24., angle, 0), true);
                fire.A_Explode(blastdmg, blastradius, XF_NOSPLASH, false, 0, 0, 0, "BulletPuff", damagetype);
            }
            if (!targ.bDontThrust)
            {
                if(global.IsMutationActive("tractorspell"))
                {
                    // Pull towards the caster
                    let to = Vec3To(targ);
                    targ.Vel.x = -to.x / 50;
                    targ.Vel.y = -to.y / 50;
                    targ.Vel.z = thrust * 1700 / max(1, targ.Mass);    
                }
                else {
                    targ.Vel.z = thrust * 1000 / max(1, targ.Mass);
                }
            }
        }
    }
}
