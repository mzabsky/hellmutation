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

        AddPerkDefinition(
            "causticresonance",
            "Caustic Resonance",
            HM_CAT_PLASMAGUN,
            "Plasma Rifle deals more damage to monsters who are standing on a damaging surface."
        );

        AddPerkDefinition(
            "coherentplasma",
            "Coherent Plasma",
            HM_CAT_PLASMAGUN,
            "Plasma Rifle projectiles reflect off of surfaces."
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

        AddPerkDefinition(
            "largecaliber",
            "Large Caliber",
            HM_CAT_PISTOL,
            "Pistol deals double damage."
        );

        AddPerkDefinition(
            "laststand",
            "Last Stand",
            HM_CAT_PLAYER,
            "Once per level, you gain brief invulnerability if you would die."
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
            "nuclearnukage",
            "Nuclear Nukage",
            HM_CAT_BARREL,
            "Explosive barrels destroyed by you explode with massive force."
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

        AddPerkDefinition(
            "safetymeasures",
            "Safety Measures",
            HM_CAT_DMGFLOOR,
            "The first time you would be damaged by a damaging floor in each level,\nyou gain RadSuit for 60 seconds."
        );

        AddPerkDefinition( // TODO
            "sawnoff",
            "Sawn Off",
            HM_CAT_SHOTGUN,
            "Super Shotgun has significantly increased spread and slightly increased number of pellets fired."
        );

        AddPerkDefinition(
            "shakedown",
            "Shake Down",
            HM_CAT_IMP,
            "Imps and their variants drop random ammo when killed."
        );

        AddPerkDefinition(
            "suppressor",
            "Suppressor",
            HM_CAT_PISTOL,
            "Pistol shots don't wake up monsters."
        );

        AddPerkDefinition(
            "torrentrounds",
            "Torrent Rounds",
            HM_CAT_CHAINGUN,
            "\c[Red]Chaingun ALT FIRE\c-: Fires explosive rounds, costs 2 bullets per shot."
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

