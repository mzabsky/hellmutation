// Serves as a marker of how many mutations the player has locked in
// The count is independent of how many locked mutations there currently are (because a perk point might have been spent on )
class HM_LockedMutationCounter: Inventory
{
	Default
	{
		  +COUNTITEM
		  +INVENTORY.ALWAYSPICKUP
		  +INVENTORY.FANCYPICKUPSOUND;
      Inventory.Amount 1;
		  Inventory.MaxAmount 999;
      Translation "112:127=250:254","9:12=254:254", "168:191=192:207", "160:162=250:254", "224:231=250:254";
	}

	States
	{
	    Spawn:
		  PINV ABCD 6 Bright;
		  Loop;
	}
}