extend class HM_GlobalEventHandler
{
    void PerkGained(string perkKey, int playerNumber) 
    {
        let player = players[playerNumber].mo;
        if(perkKey == "basic_recover")
        {
            player.A_SetHealth(100);
            player.GiveInventory("GreenArmor", 1);

            player.GiveInventory("ClipBox", 1000);
            player.GiveInventory("ShellBox", 1000);
            player.GiveInventory("RocketBox", 1000);
            player.GiveInventory("CellPack", 1000);
        }
    }
}