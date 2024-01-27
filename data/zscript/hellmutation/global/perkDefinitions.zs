extend class HM_GlobalEventHandler
{
    void CreatePerkDefinitions()
    {
        // Only chance perks appear here, basic perks are hard coded

        AddPerkDefinition(
            "allin",
            "All In",
            HM_CAT_ROCKETLAUNCHER,
            "As long as you have 200 health and armor, any damage you take is brutally increased and your rocket launcher fires much faster."
        );

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
            "briefrest",
            "Brief Rest",
            HM_CAT_PLAYER,
            "Heal up to 150 health after each level."
        );

        AddPerkDefinition(
            "calciumregimen",
            "Calcium Regimen",
            HM_CAT_PLAYER,
            "You are immune to crusher damage."
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
            "deflectingpunch",
            "Deflecting Punch",
            HM_CAT_FIST,
            "You can punch projectiles to redirect their flight."
        );

        AddPerkDefinition(
            "extremetanning",
            "Extreme Tanning",
            HM_CAT_BARREL,
            "Barrels heal you instead of dealing damage."
        );

        AddPerkDefinition(
            "firstaid",
            "First Aid",
            HM_CAT_PLAYER,
            "Stimpacks and Medikits grant 10 extra health."
        );

        AddPerkDefinition(
            "flaregun",
            "Flare Gun",
            HM_CAT_PLAYER,
            "\c[Red]Pistol ALT FIRE\c-: Fires flares which make enemies take significantly more damage."
        );

        AddPerkDefinition(
            "focused",
            "Focused",
            HM_CAT_PLAYER,
            "Blur spheres affect you as if they were Soulspheres."
        );

        AddPerkDefinition(
            "glory",
            "Glory",
            HM_CAT_PLAYER,
            "Soulspheres, Megaspheres, Blue Armor and Bonuses heal up to 300 health and armor."
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
            "mindfulness",
            "Mindfulness",
            HM_CAT_PLAYER,
            "Take three times less self damage."
        );

        AddPerkDefinition(
            "nuclearnukage",
            "Nuclear Nukage",
            HM_CAT_BARREL,
            "Explosive barrels destroyed by you explode with massive force."
        );

        AddPerkDefinition(
            "rampage",
            "Rampage",
            HM_CAT_SHOTGUN,
            "Shotgun reloads slowly, but reloads instantly when it scores a kill."
        );

        AddPerkDefinition(
            "performancebonus",
            "Performance Bonus",
            HM_CAT_ROCKETLAUNCHER,
            "Each rocket fired by you which kills five or more monsters is refunded."
        );

        AddPerkDefinition(
            "precisionsurgery",
            "Precision Surgery",
            HM_CAT_CHAINSAW,
            "Chainsaw deals triple damage and causes no pain."
        );

        AddPerkDefinition(
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

