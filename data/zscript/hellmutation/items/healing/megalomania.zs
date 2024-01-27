class HM_MegaSphere: MegaSphere replaces MegaSphere
{
    mixin HM_GlobalRef;

	states
	{
	    Spawn:
		    MEGA ABCD 6 BRIGHT;
		    Loop;
	    Pickup:
		    TNT1 A 0 A_GiveInventory("HM_BlueArmorForMegasphere", 1);
		    TNT1 A 0 A_GiveInventory("HM_MegasphereHealth", 1);
		    Stop;
	}
}

class HM_BlueArmorForMegasphere : BasicArmorBonus
{
    mixin HM_GlobalRef;

	default
	{
		Armor.SavePercent 50;
		Armor.SaveAmount 200;
		Armor.MaxSaveAmount 200;
	}

    override bool TryPickup (in out Actor toucher)
    {
        console.printf("armorformega trypickup");
        if(global.IsPerkActive("glory"))
        {
            MaxSaveAmount = 300;
        }
        else
        {
            MaxSaveAmount = 200;
        }

        return super.TryPickup(toucher);
    }
}

class HM_MegasphereHealth : MegasphereHealth
{
    mixin HM_GlobalRef;

	default
	{
		Inventory.Amount 200;
		Inventory.MaxAmount 200;
		+INVENTORY.ALWAYSPICKUP
	}

    override bool TryPickup (in out Actor toucher)
    {
        if(global.IsPerkActive("glory"))
        {
            MaxAmount = 300;
        }
        else
        {
            MaxAmount = 200;
        }

        return super.TryPickup(toucher);
    }
}
