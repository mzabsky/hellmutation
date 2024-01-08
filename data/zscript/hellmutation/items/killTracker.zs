// Holds information about which player weapon was used to kill an actor.
class HM_KillTracker: Inventory
{
	  Class<Weapon> KillWeapon;
    PlayerPawn Killer;
}