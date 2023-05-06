class HM_MutationDefinition
{
    string Key;
    int MapNumber;
    string Name;
    MutationCategory Category;
    string Description;
}

enum MutationCategory
{
    HM_CAT_DOOM2 = 1 << 0, // Only allowed if the current IWAD allows DOOM2's feature set (arch viles and stuff)
    HM_CAT_NOFIRSTMAP = 1 << 1, // Can't appear in the first map in this save
    HM_CAT_PLAYER = 1 << 2,
    HM_CAT_DMGFLOOR = 1 << 3,
    HM_CAT_BARREL = 1 << 4,

    HM_CAT_ALLMONSTERS = 1 << 13, // Affects all monsters

    // Enemy types
    HM_CAT_ZOMBIEMAN = 1 << 14,
    HM_CAT_SHOTGUNNER = 1 << 15,
    HM_CAT_CHAINGUNNER = 1 << 16,
    HM_CAT_IMP = 1 << 17,
    HM_CAT_PINKY = 1 << 18, // Spectres count as pinkys
    HM_CAT_REVENANT = 1 << 19,
    HM_CAT_CACODEMON = 1 << 20,
    HM_CAT_LOSTSOUL = 1 << 21,
    HM_CAT_PAINELEMENTAL = 1 << 22,
    HM_CAT_HELLKNIGHT = 1 << 23,
    HM_CAT_BARONOFHELL = 1 << 24,
    HM_CAT_MANCUBUS = 1 << 25,
    HM_CAT_ARCHVILE = 1 << 26,
    HM_CAT_ARACHNOTRON = 1 << 27,
    HM_CAT_SPIDERMASTERMIND = 1 << 28,
    HM_CAT_CYBERDEMON = 1 << 29,
    HM_CAT_BOSSBRAIN = 1 << 30
};

extend class HM_GlobalEventHandler
{
    void CreateMutationDefinitions()
    {
        AddMutationDefinition(
            "abundance",
            "Abundance",
            6,
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses fire additional projectiles in each\nhorizontal direction."
        );

        AddMutationDefinition(
            "adipocytes",
            "Adipocytes",
            3,
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses and their variants have more health."
        );

        AddMutationDefinition(
            "adrenaline",
            "Adrenaline",
            3,
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER,
            "Zombiemen, Shotgunners and their variants are more aggressive."
        );

        AddMutationDefinition(
            "ambushshield",
            "Ambush Shield",
            4,
            HM_CAT_DOOM2 | HM_CAT_CHAINGUNNER,
            "Chaingunners and their variants get a brief invulnerability\nshield when they first open fire."
        );
        
        AddMutationDefinition(
            "ascension",
            "Ascension",
            6,
            HM_CAT_DOOM2 | HM_CAT_HELLKNIGHT,
            "Hell Knights who score a hit on the player become Barons of Hell."
        );

        AddMutationDefinition(
            "barrage",
            "Barrage",
            4,
            HM_CAT_IMP,
            "Imps fire three fireballs in a rapid barrage."
        );
        
        AddMutationDefinition(
            "bigfuckingwomp",
            "Big Fucking Womp",
            6,
            HM_CAT_CYBERDEMON | HM_CAT_SPIDERMASTERMIND,
            "Cyberdemons and Spider Masterminds take much less damage from BFG9000."
        );

        AddMutationDefinition(
            "bloodtax",
            "Blood Tax",
            6,
            HM_CAT_PLAYER,
            "Player takes 25 damage when they pick up a keycard or a\nskull key (this damage cannot kill)."
        );

        AddMutationDefinition(
            "brightfire",
            "Brightfire",
            2,
            HM_CAT_IMP,
            "IMPS AND THEIR VARIANTS ARE FASTER."
        );

        AddMutationDefinition(
            "cacoblasters",
            "Cacoblasters",
            2,
            HM_CAT_CACODEMON,
            "Cacodemons always fire two additional projectiles."
        );

        AddMutationDefinition(
            "catastrophicreflux",
            "Catastrophic Reflux",
            6,
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses cause a powerful explosion on death."
        );

        AddMutationDefinition(
            "cyberneuralreflexes",
            "Cyber-Neural Reflexes",
            6,
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotrons and their variants immediately return fire when attacked."
        );

        AddMutationDefinition(
            "dampingjaws",
            "Damping Jaws",
            6,
            HM_CAT_CACODEMON,
            "Damage from Cacodemons removes powerup effects from players."
        );

        AddMutationDefinition(
            "decapitation",
            "Decapitation",
            2,
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER | HM_CAT_CHAINGUNNER,
            "ZOMBIEMEN, SHOTGUNNERS, Chaingunners AND THEIR VARIANTS MAY SPAWN \nA LOST SOUL AFTER DYING, UNLESS GIBBED."
        );

        AddMutationDefinition(
            "decoys",
            "Decoys",
            6,
            HM_CAT_DOOM2 | HM_CAT_REVENANT,
            "Revenants may spawn a harmless decoy when they get hit."
        );

        AddMutationDefinition(
            "dejavu",
            "Deja Vu",
            5,
            HM_CAT_ALLMONSTERS,
            "Monsters might ambush you more than once!"
        );

        AddMutationDefinition(
            "desecration",
            "Desecration",
            0,
            HM_CAT_IMP,
            "IMPS WHO SCORE A HIT ON A PLAYER BECOME ARCH-IMPS."
        );

        AddMutationDefinition(
            "ego",
            "Ego",
            1,
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls deal and take much more damage."
        );

        AddMutationDefinition(
            "explosivesurprise",
            "Explosive Surprise",
            6,
            HM_CAT_BARREL,
            "Barrels may spawn a monster after exploding."
        );

        AddMutationDefinition(
            "extendedaccelerators",
            "Extended Acelerators",
            6,
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotron projectiles are much faster."
        );
       
        AddMutationDefinition(
            "extremophilia",
            "Extremophilia",
            4,
            HM_CAT_DMGFLOOR,
            "Monsters recover some health each second on a damaging floor."
        );

        AddMutationDefinition(
            "fistatrophy",
            "Fist Atrophy",
            6,
            HM_CAT_DOOM2 | HM_CAT_REVENANT,
            "Revenants always use their ranged attack instead of punching."
        );

        AddMutationDefinition(
            "greaterritual",
            "Greater Ritual",
            6,
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "Arch-Imps and Arch-Viles can resurrect Arch-Imps, Arch-Viles,\nPain Elementals, Spider Masterminds and Cyberdemons."
        );

        AddMutationDefinition(
            "hellscaress",
            "Hell's Caress",
            2,
            HM_CAT_IMP | HM_CAT_REVENANT | HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Melee attacks of Imps, Revenants, Hell Knights, Barons of Hell \nand their  variants are much more powerful."
        );

        AddMutationDefinition(
            "hematophagy",
            "Hematophagy",
            1,
            HM_CAT_PINKY,
            "Pinkies and their variants become fully healed whenever they deal damage."
        );

        AddMutationDefinition(
            "highground",
            "High Ground",
            5,
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER | HM_CAT_CHAINGUNNER,
            "Zombiemen, Shotgunners, Chaingunners and their variants\ndeal more damage when attacking from above."
        );

        AddMutationDefinition(
            "hypercognition",
            "Hypercognition",
            6,
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotrons can lead their target when aiming."
        );

        AddMutationDefinition(
            "hyperfuel",
            "Hyper-Fuel",
            0,
            HM_CAT_REVENANT | HM_CAT_CYBERDEMON,
            "ALL ROCKETS AND GUIDED ROCKETS FIRED BY MONSTERS ARE MUCH FASTER."
        );

        AddMutationDefinition(
            "hyperphagy",
            "Hyperphagy",
            6,
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses are more aggressive."
        );

        AddMutationDefinition(
            "insomnia",
            "Insomnia",
            1,
            HM_CAT_NOFIRSTMAP | HM_CAT_ALLMONSTERS,
            "MONSTERS DO NOT START THE LEVEL ASLEEP."
        );
       
        AddMutationDefinition(
            "kleptomania",
            "Kleptomania",
            4,
            HM_CAT_PLAYER,
            "Players lose all rockets and plasma ammo between levels."
        );

        AddMutationDefinition(
            "lordsofdarkness",
            "Lords of Darkness",
            5,
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knights and Barons of Hell take less damage\nwhile in darkness."
        );

        AddMutationDefinition(
            "lordsofreality",
            "Lords of Reality",
            5,
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knight and Baron of Hell projectiles pass through\nother Hell Knights and Barons of Hell."
        );

        AddMutationDefinition(
            "lordsofsouls",
            "Lords of Souls",
            6,
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Players taking damage from Hell Knights and Barons of Hell might cause a nearby monster to resurrect."
        );

        AddMutationDefinition(
            "lordsofvengeance",
            "Lords of Vengeance",
            6,
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knights and Barons of Hell get increasingly angry\nas they take damage."
        );
        
        AddMutationDefinition(
            "losttogether",
            "Lost Together",
            6,
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls never attack each other."
        );

        AddMutationDefinition(
            "macropods",
            "Macropods",
            0,
            HM_CAT_PINKY,
            "PINKIES GAIN THE ABILITY TO POUNCE FROM A DISTANCE AND ACROSS GAPS."
        );

        AddMutationDefinition(
            "momentum",
            "Momentum",
            0,
            HM_CAT_CACODEMON,
            "Cacodemons attack faster the faster they are moving."
        );
        
        AddMutationDefinition(
            "motherhood",
            "Motherhood",
            6,
            HM_CAT_DOOM2 | HM_CAT_SPIDERMASTERMIND,
            "Spider Masterminds rapidly spawn Arachnotrons."
        );

        AddMutationDefinition(
            "napalmpayload",
            "Napalm Payload",
            0,
            HM_CAT_DOOM2| HM_CAT_MANCUBUS,
            "Mancubuses spread fire with their attacks."
        );
        
        AddMutationDefinition(
            "pomodorosustenance",
            "Pomodoro Sustenance",
            6,
            HM_CAT_CACODEMON,
            "Dying Cacodemons heal other monsters around where they crash."
        );
        
        AddMutationDefinition(
            "prepained",
            "Pre-Pained",
            6,
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Pain Elementals spawn with several Lost Souls."
        );

        AddMutationDefinition(
            "promotion",
            "Promotion",
            1,
            HM_CAT_ZOMBIEMAN,
            "BASIC ZOMBIEMEN WHO SCORE A HIT ON A PLAYER BECOME SHOTGUNNERS."
        );

        AddMutationDefinition(
            "rage",
            "Rage",
            6,
            HM_CAT_PINKY,
            "Pinkies and Spectres are faster."
        );

        AddMutationDefinition(
            "rapidspin",
            "Rapid Spin",
            6,
            HM_CAT_DOOM2 | HM_CAT_CHAINGUNNER,
            "Chaingunners and their variants are faster."
        );

        AddMutationDefinition(
            "reachingritual",
            "Reaching Ritual",
            6,
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles can resurrect monster from a greater distance."
        );

        AddMutationDefinition(
            "reactivecamouflage",
            "Reactive Camouflage",
            3,
            HM_CAT_PINKY,
            "Pinkies become spectral when damaged."
        );

        AddMutationDefinition(
            "sacrifice",
            "Sacrifice",
            3,
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "Arch-Viles and Arch-Imps redirect some of the damage they \nwould take to other nearby monsters."
        );

        AddMutationDefinition(
            "seekingsouls",
            "Seeking Souls",
            5,
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls charge at greater speed."
        );

        AddMutationDefinition(
            "slimeborne",
            "Slimeborne",
            3,
            HM_CAT_DMGFLOOR,
            "Player losing health to a damaging floor might cause Pinkies to spawn."
        );

        AddMutationDefinition(
            "stormtroopers",
            "Stormtroopers",
            0,
            HM_CAT_ZOMBIEMAN,
            "BASIC ZOMBIEMEN ARE SIGNIFICANTLY MORE ACCURATE."
        );

        AddMutationDefinition(
            "terminalpurpose",
            "Terminal Purpose",
            6,
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost Souls explode on death, dealing light damage."
        );

        AddMutationDefinition(
            "tractorspell",
            "Tractor Spell",
            3,
            HM_CAT_ARCHVILE,
            "Arch-Vile attack pulls its target towards it."
        );

        AddMutationDefinition(
            "unholylegion",
            "Unholy Legion",
            6,
            HM_CAT_IMP,
            "Arch-Imps replace Imps three times as frequently."
        );

        AddMutationDefinition(
            "unstoppable",
            "Unstoppable",
            6,
            HM_CAT_PINKY,
            "Pinkies and their variants are almost immune to pain."
        );

        AddMutationDefinition(
            "unyielding",
            "Unyelding",
            5,
            HM_CAT_CACODEMON,
            "Cacodemons are more resistant to pain."
        );

        AddMutationDefinition(
            "vitalitylimit",
            "Vitality Limit",
            6,
            HM_CAT_PLAYER,
            "Player health over 100 slowly degenerates."
        );
        
        AddMutationDefinition(
            "walloffire",
            "Wall of Fire",
            6,
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubus projectiles spread vertically as well as horizontally."
        );
    }
    
    private void AddMutationDefinition(string key, string name, int mapNumber, MutationCategory category, string description)
    {
        let mutationDefinition = new("HM_MutationDefinition");
        mutationDefinition.Key = key;
        mutationDefinition.Name = name;
        mutationDefinition.MapNumber = mapNumber;
        mutationDefinition.Category = category;
        mutationDefinition.Description = description;
        MutationDefinitions.Push(mutationDefinition);
    }
}

