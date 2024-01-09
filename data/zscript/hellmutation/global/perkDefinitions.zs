extend class HM_GlobalEventHandler
{
    void CreatePerkDefinitions()
    {
        // Only chance perks appear here, basic perks are hard coded

        AddPerkDefinition( // TODO
            "bloodlust",
            "Bloodlust",
            HM_CAT_FIST,
            "Kills with fist briefly increase movement speed."
        );

        AddPerkDefinition(
            "brinkmanship",
            "Brinkmanship",
            HM_CAT_PLAYER,
            "As long as you have 25 or less life, your movement speed is increased."
        );

        AddPerkDefinition(
            "bonusbonus",
            "Bonus Bonus",
            HM_CAT_PLAYER,
            "Armor and Health bonuses grant 2 health and 2 armor each."
        );

        AddPerkDefinition(
            "carepackage",
            "Care Package",
            HM_CAT_PLAYER,
            "Backpacks fill all ammo completely."
        );

        AddPerkDefinition( // TODO
            "coherentplasma",
            "Coherent Plasma",
            HM_CAT_PLASMAGUN,
            "Plasma projectiles reflect off of surfaces."
        );

        AddPerkDefinition(
            "firstaid",
            "First Aid",
            HM_CAT_PLAYER,
            "Stimpacks and Medikits grant 10 extra health."
        );

        AddPerkDefinition(
            "focused",
            "Focused",
            HM_CAT_PLAYER,
            "Blur spheres affect you as if they were Soulspheres."
        );

        AddPerkDefinition(
            "highvoltage",
            "High Voltage",
            HM_CAT_PLASMAGUN,
            "Plasma Rifle deals double damage and consumes double ammo when your cell amount is within 100\nof the ammo capacity."
        );

        AddPerkDefinition( // TODO
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
            "performancebonus",
            "Performance Bonus",
            HM_CAT_ROCKETLAUNCHER,
            "Each rocket which kills five or more monsters is refunded."
        );

        AddPerkDefinition( // TODO
            "profitablecut",
            "Profitable Cut",
            HM_CAT_CHAINSAW,
            "Kills with Chainsaw drop random ammo."
        );

        AddPerkDefinition( // TODO
            "sawnoff",
            "Sawn Off",
            HM_CAT_SHOTGUN,
            "Shotgun has significantly increased spread and slightly increased number of pellets fired."
        );

        AddPerkDefinition(
            "shakedown",
            "Shake Down",
            HM_CAT_IMP,
            "Imps and their variants drop random ammo when killed."
        );

        AddPerkDefinition( // TODO
            "slayerssaw",
            "Slayer's Saw",
            HM_CAT_CHAINSAW,
            "Kills with chainsaw cause random ammo to drop."
        );

        AddPerkDefinition( // TODO
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

