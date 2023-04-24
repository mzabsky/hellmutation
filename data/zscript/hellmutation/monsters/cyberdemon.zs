class HM_Cyberdemon : Cyberdemon replaces Cyberdemon
{
    mixin HM_GlobalRef;
    mixin HM_GreaterRitual;
    mixin HM_BigFuckingWomp;

    States
    {
        Raise:
            CYBR ON 10;
            CYBR M 10;
            CYBR LKJ 10;
            CYBR I 10;
            CYBR H 10;
            Goto See;
    }
}

class HM_Rocket : Rocket replaces Rocket
{
    mixin HM_GlobalRef;

    override void PostBeginPlay()
    {
        if(global.IsMutationActive("HyperFuel") && !(target is "PlayerPawn"))
        {
            A_ScaleVelocity(2);
        }
    }
}