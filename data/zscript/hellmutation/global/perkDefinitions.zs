extend class HM_GlobalEventHandler
{
    void CreatePerkDefinitions()
    {
        // Only chance perks appear here, basic perks are hard coded

        AddPerkDefinition(
            "allin",
            "All In",
            "As long as you have 200 health and armor, any damage you take is brutally increased and your rocket launcher fires much faster.",
            HM_CAT_ROCKETLAUNCHER
        );

        AddPerkDefinition(
            "betrayal",
            "Betrayal",
            "Monsters killed by other monsters explode into a bounty of health an armor bonuses.",
            HM_CAT_ARMOR,
            HM_CAT_HEALTH
        );

        AddPerkDefinition(
            "bloodlust",
            "Bloodlust",
            "Kills with fist briefly increase movement speed.",
            HM_CAT_FIST
        );

        AddPerkDefinition(
            "brinkmanship",
            "Brinkmanship",
            "As long as you have 25 or less life, your movement speed is increased.",
            HM_CAT_PLAYER
        );

        AddPerkDefinition(
            "bonusbonus",
            "Bonus Bonus",
            "Armor and Health bonuses grant 2 health and 2 armor each.",
            HM_CAT_ARMOR,
            HM_CAT_HEALTH
        );

        AddPerkDefinition(
            "briefrest",
            "Brief Rest",
            "Heal up to 150 health after each level.",
            HM_CAT_HEALTH
        );

        AddPerkDefinition(
            "calciumregimen",
            "Calcium Regimen",
            "You are immune to crusher damage.",
            HM_CAT_PLAYER
        );

        AddPerkDefinition(
            "carepackage",
            "Care Package",
            "Backpacks fill all ammo completely.",
            HM_CAT_BACKPACK,
            HM_CAT_AMMO
        );

        AddPerkDefinition(
            "causticresonance",
            "Caustic Resonance",
            "Plasma Rifle deals more damage to monsters who are standing on a damaging surface.",
            HM_CAT_PLASMAGUN
        );

        AddPerkDefinition(
            "coherentplasma",
            "Coherent Plasma",
            "Plasma Rifle projectiles reflect off of surfaces.",
            HM_CAT_PLASMAGUN
        );


        AddPerkDefinition(
            "deflectingpunch",
            "Deflecting Punch",
            "You can punch projectiles to redirect their flight.",
            HM_CAT_FIST
        );

        AddPerkDefinition(
            "extremetanning",
            "Extreme Tanning",
            "Barrels heal you instead of dealing damage.",
            HM_CAT_BARREL,
            HM_CAT_HEALTH
        );

        AddPerkDefinition(
            "firstaid",
            "First Aid",
            "Stimpacks and Medikits grant 10 extra health.",
            HM_CAT_HEALTH
        );

        AddPerkDefinition(
            "flaregun",
            "Flare Gun",
            "\c[Red]Pistol ALT FIRE\c-: Fires flares which make enemies take significantly more damage.",
            HM_CAT_PISTOL
        );

        AddPerkDefinition(
            "focused",
            "Focused",
            "Blur spheres affect you as if they were Soulspheres instead of their normal effect.",
            HM_CAT_BLURSPHERE,
            HM_CAT_ARMOR
        );

        AddPerkDefinition(
            "glory",
            "Glory",
            "Soulspheres, Megaspheres, Blue Armor and Bonuses heal up to 300 health and armor.",
            HM_CAT_SOULSPHERE,
            HM_CAT_MEGASPHERE,
            HM_CAT_ARMOR,
            HM_CAT_HEALTH
        );

        AddPerkDefinition(
            "highvoltage",
            "High Voltage",
            "Plasma Rifle deals double damage and consumes double ammo when your cell amount is within 100\nof the ammo capacity.",
            HM_CAT_PLASMAGUN
        );

        AddPerkDefinition(
            "largecaliber",
            "Large Caliber",
            "Pistol deals double damage.",
            HM_CAT_PISTOL
        );

        AddPerkDefinition(
            "laststand",
            "Last Stand",
            "Once per level, you gain brief invulnerability if you would die.",
            HM_CAT_PLAYER
        );

        AddPerkDefinition(
            "longbarrels",
            "Long Barrels",
            "Chaingun has reduced bullet spread.",
            HM_CAT_CHAINGUN
        );

        AddPerkDefinition(
            "megalomania",
            "Megalomania",
            "Soulspheres affect you as if they were Megaspheres.",
            HM_CAT_SOULSPHERE // Should this have HM_CAT_DOOM2?
        );

        AddPerkDefinition(
            "mindfulness",
            "Mindfulness",
            "Take three times less self damage.",
            HM_CAT_PLAYER
        );

        AddPerkDefinition(
            "nuclearnukage",
            "Nuclear Nukage",
            "Explosive barrels destroyed by you explode with massive force.",
            HM_CAT_BARREL
        );

        AddPerkDefinition(
            "performancebonus",
            "Performance Bonus",
            "Each rocket fired by you which kills five or more monsters is refunded.",
            HM_CAT_ROCKETLAUNCHER
        );

        AddPerkDefinition(
            "precisionsurgery",
            "Precision Surgery",
            "Chainsaw deals triple damage and causes no pain.",
            HM_CAT_CHAINSAW
        );

        AddPerkDefinition(
            "profitablecut",
            "Profitable Cut",
            "Kills with Chainsaw drop random ammo.",
            HM_CAT_CHAINSAW,
            HM_CAT_AMMO
        );

        AddPerkDefinition(
            "rampage",
            "Rampage",
            "Shotgun reloads slowly, but reloads instantly when it scores a kill.",
            HM_CAT_SHOTGUN
        );

        AddPerkDefinition(
            "safetymeasures",
            "Safety Measures",
            "The first time you would be damaged by a damaging floor in each level,\nyou gain RadSuit for 60 seconds.",
            HM_CAT_DMGFLOOR
        );

        AddPerkDefinition( // TODO
            "sawnoff",
            "Sawn Off",
            "Super Shotgun has significantly increased spread and slightly increased number of pellets fired.",
            HM_CAT_SHOTGUN
        );

        AddPerkDefinition(
            "shakedown",
            "Shake Down",
            "Imps and their variants drop random ammo when killed.",
            HM_CAT_IMP
        );

        AddPerkDefinition(
            "suppressor",
            "Suppressor",
            "Pistol shots don't wake up monsters.",
            HM_CAT_PISTOL
        );

        AddPerkDefinition(
            "torrentrounds",
            "Torrent Rounds",
            "\c[Red]Chaingun ALT FIRE\c-: Fires explosive rounds, costs 2 bullets per shot.",
            HM_CAT_CHAINGUN
        );

        AddPerkDefinition(
            "tunedthrust",
            "Tuned Thrust",
            "Your Rockets are much faster.",
            HM_CAT_ROCKETLAUNCHER
        );

        AddPerkDefinition(
            "vampirism",
            "Vampirism",
            "Recover small percentage of damage you deal as health, up to 100.",
            HM_CAT_HEALTH
        );

    }
    
    private void AddPerkDefinition(
        string key,
        string name,
        string description,
        HM_Category category1 = HM_CAT_NONE,
        HM_Category category2 = HM_CAT_NONE,
        HM_Category category3 = HM_CAT_NONE,
        HM_Category category4 = HM_CAT_NONE
    )
    {
        let perkDefinition = new("HM_Definition");
        perkDefinition.Key = key;
        perkDefinition.Name = name;
        perkDefinition.MapNumber = 0;
        perkDefinition.Description = description;

        if(category1 != HM_CAT_NONE)
        {
            perkDefinition.Categories.Push(category1);
        }

        if(category2 != HM_CAT_NONE)
        {
            perkDefinition.Categories.Push(category2);
        }

        if(category3 != HM_CAT_NONE)
        {
            perkDefinition.Categories.Push(category3);
        }

        if(category4 != HM_CAT_NONE)
        {
            perkDefinition.Categories.Push(category4);
        }

        PerkDefinitions.Push(perkDefinition);

        if(!ValidateCategoryOrder(perkDefinition.Categories))
        {
            console.printf("...adding %s", perkDefinition.Key);
        }
    }
}

