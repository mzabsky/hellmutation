// Fields and small overrides methods
class HM_GlobalEventHandler: EventHandler
{
    // This could be better done with associative arrays, once their const methods are in stable version
    Array<HM_Definition> mutationDefinitions;
    Array<HM_Definition> perkDefinitions;

    //=================================
    // PERSISTENT FIELDS
    //=================================
    int MapNumber;

    Dictionary MutationStates; // Indexed by mutation key, values are: "None" (or not present), "Active" and "Removed"
    Array<string> MutationRemovalsOnOffer;
    Array<string> MetaLockedMutations;
    Dictionary PerkStates; // Indexed by perk key, values are: "None" (or not present), "Active" and "Removed"
    Array<string> PerksOnOffer;

    HM_GlobalThinker globalThinker;
    
    //=================================
    // NONPERSISTENT FIELDS
    //=================================
    bool hasDoom2;
    Array<Sector> ambushSectors; // For Deja Vu
    //Array<int> lastGorgonProtocolSpotted; // For Gorgon Protocol - time when each player has spotted a mastermind with GP, indexed by player index

    override void NewGame()
    {
        MapNumber = 0;
        MutationStates = Dictionary.Create();
        PerkStates = Dictionary.Create();

        //CVar attacksetting = CVar.FindCVar('m_yaw');
        //attackSetting.SetFloat(0.1);
        //MutationRemovalsOnOffer = new Array<string>();
    }

    override void PlayerSpawned (PlayerEvent e)
    {
        players[e.playerNumber].mo.ACS_NamedExecute("hm_hud", 0);
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        // This is required to support various healing and health manipulating functions
        if(e.thing.starthealth == 0)
        {
            e.thing.starthealth = e.thing.SpawnHealth();
        }

        // Insomnia
        if(e.thing.bIsMonster && players.Size() > 0 && players[0].mo != null && IsMutationActive("Insomnia"))
        {
            e.thing.target = players[0].mo;
            e.thing.A_AlertMonsters();
        }

        // Regality - Each monster need to have a regality modifier (it will check for the mutation on its own)
        if(e.thing.bIsMonster)
        {
            e.thing.GiveInventory("HM_RegalityModifier", 1);
        }
    }
}