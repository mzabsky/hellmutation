extend class HM_GlobalEventHandler
{
    void CreatePerkDefinitions()
    {
        // Only chance perks appear here, basic perks are omitterd



        AddPerkDefinition(
            "bloodtrance",
            "Blood Trance",
            HM_CAT_FIST,
            "Kills with fist briefly increase movement speed."
        );

        AddPerkDefinition(
            "carepackage",
            "Care Package",
            HM_CAT_PLAYER,
            "Backpacks fill all ammo completely."
        );

        AddPerkDefinition(
            "coherentplasma",
            "Coherent Plasma",
            HM_CAT_PLASMAGUN,
            "Plasma projectiles reflect off of surfaces."
        );

        AddPerkDefinition(
            "focused",
            "Focused",
            HM_CAT_PLAYER,
            "Blur spheres affect you as if they were Soulspheres."
        );

        AddPerkDefinition(
            "longbarrels",
            "Long Barrels",
            HM_CAT_CHAINGUN,
            "Chaingun has reduced bullet spread."
        );

        AddPerkDefinition(
            "megalomania",
            "Megalomania",
            HM_CAT_PLAYER, // Should this have HM_CAT_DOOM2?
            "Soulspheres affect you as if they were Megaspheres."
        );

        AddPerkDefinition(
            "sawnoff",
            "Sawn Off",
            HM_CAT_SHOTGUN,
            "Shotgun has significantly increased spread and slightly increased number of pellets fired."
        );

        AddPerkDefinition(
            "slayerssaw",
            "Slayer's Saw",
            HM_CAT_CHAINSAW,
            "Kills with chainsaw cause random ammo to drop."
        );

        AddPerkDefinition(
            "tunedthrust",
            "Tuned Thrust",
            HM_CAT_ROCKETLAUNCHER,
            "Your Rockets are much faster."
        );

        AddPerkDefinition(
            "vampirism",
            "Vampirism",
            HM_CAT_PLAYER,
            "Recover small percentage of damage you deal as health, up to 100."
        );

    }
    
    private void AddPerkDefinition(string key, string name, HM_Category category, string description)
    {
        let perkDefinition = new("HM_Definition");
        perkDefinition.Key = key;
        perkDefinition.Name = name;
        perkDefinition.MapNumber = 0;
        perkDefinition.Category = category;
        perkDefinition.Description = description;
        PerkDefinitions.Push(perkDefinition);
    }
}

