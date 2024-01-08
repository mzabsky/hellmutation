class HM_PowerBloodlust : PowerSpeed
{
    default
    {
        Speed 1.20;
        Powerup.Duration -3;
    }
}

class HM_PowerGiverBloodlust : PowerupGiver
{
    default
	  {
        +INVENTORY.AutoActivate
        +Inventory.AlwaysPickup
        //Powerup.color "Yellow";
		    Powerup.Type "HM_PowerBloodlust";
        Powerup.Duration -3;
	  }
}