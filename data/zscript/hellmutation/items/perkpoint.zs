class HM_PerkPoint: Inventory
{
	Default
	{
		  +COUNTITEM
		  +INVENTORY.ALWAYSPICKUP
		  +INVENTORY.FANCYPICKUPSOUND;
      Inventory.Amount 1;
		  Inventory.MaxAmount 999;
		  Inventory.PickupMessage "Got a perk point! You can add a new perk now.";
      Translation "112:127=250:254","9:12=254:254", "168:191=192:207", "160:162=250:254", "224:231=250:254";
	}

	States
	{
	    Spawn:
		  PINV ABCD 6 Bright;
		  Loop;
	}
}