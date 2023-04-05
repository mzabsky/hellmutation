class HM_Dna: Inventory
{
	Default
	{
		  +COUNTITEM
		  +INVENTORY.ALWAYSPICKUP
		  Inventory.MaxAmount 0;
		  Inventory.PickupMessage "Got DNA! You can remove a mutation now.";
      Translation "112:127=168:191","9:12=190:191";
	}

	States
	{
	    Spawn:
		  PINV ABCD 6 Bright;
		  Loop;
	}
}