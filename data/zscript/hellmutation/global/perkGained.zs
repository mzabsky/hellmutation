extend class HM_GlobalEventHandler
{
    void PerkGained(string perkKey, int playerNumber) 
    {
        let player = players[playerNumber].mo;

        RollNewPerks();

        if(perkKey == "basic_panic")
        {
            player.GiveInventory("InvulnerabilitySphere", 1);
        }
        else if(perkKey == "basic_recover")
        {
            player.A_SetHealth(100);
            player.GiveInventory("GreenArmor", 1);

            player.GiveInventory("ClipBox", 1000);
            player.GiveInventory("ShellBox", 1000);
            player.GiveInventory("RocketBox", 1000);
            player.GiveInventory("CellPack", 1000);
        }
    }

    void RollNewPerks()
    {
        for(let i = 0; i < PerksOnOffer.Size(); i++)
        {
            let perkKey = PerksOnOffer[i];
            if(PerkStates.At(perkKey) == "Offered")
            {
                PerkStates.Insert(perkKey, "None");
            }
        }

        PerksOnOffer.Clear();

        ChoosePerks();
    }
}