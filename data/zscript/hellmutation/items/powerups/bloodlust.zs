class PowerBloodlust : PowerSpeed
{
    default
    {
        Speed 1.20;
        Powerup.Duration -3;
    }
}

class PowerGiverBloodlust : PowerupGiver
{
    default
	  {
        +INVENTORY.AutoActivate
        +Inventory.AlwaysPickup
        //Powerup.color "Yellow";
		    Powerup.Type "PowerBloodlust";
        Powerup.Duration -3;
	  }
}

// actor HieroSlow : PowerupGiver 
// { 
//   Inventory.PickupMessage "Your legs feel heavy." 
//   Powerup.color Yellow 0.33 
//   Inventory.MaxAmount 0 
//   Powerup.Type Slow
//   Powerup.Duration -10 
//   +AutoActivate
//   +Inventory.AlwaysPickup
//   states 
//   { 
//   Spawn: 
//     TNT1 A 1
//     Fail
//   } 
// }
