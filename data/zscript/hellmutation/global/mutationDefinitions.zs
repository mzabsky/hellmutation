class HM_Definition
{
    string Key;
    int MapNumber;
    string Name;
    HM_Category Category;
    string Description;
    
}

// Categories for both mutations and perks
enum HM_Category
{
    HM_CAT_DOOM2 = 1 << 0, // Only allowed if the current IWAD allows DOOM2's feature set (arch viles, super shotgun and stuff)
    HM_CAT_NOFIRSTMAP = 1 << 1, // Can't appear in the first map in this save
    HM_CAT_PLAYER = 1 << 2,
    HM_CAT_DMGFLOOR = 1 << 3,
    HM_CAT_BARREL = 1 << 4,

    // Weapons
    HM_CAT_FIST = 1 << 5,
    HM_CAT_PISTOL = 1 << 6,
    HM_CAT_CHAINSAW = 1 << 7,
    HM_CAT_SHOTGUN = 1 << 8,
    HM_CAT_SUPERSHOTGUN = 1 << 9,
    HM_CAT_CHAINGUN = 1 << 10,
    HM_CAT_ROCKETLAUNCHER = 1 << 11,
    HM_CAT_PLASMAGUN = 1 << 12,
    HM_CAT_BFG = 1 << 13,

    HM_CAT_ALLMONSTERS = 1 << 14, // Affects all monsters

    // Enemy types
    HM_CAT_ZOMBIEMAN = 1 << 15,
    HM_CAT_SHOTGUNNER = 1 << 16,
    HM_CAT_CHAINGUNNER = 1 << 17,
    HM_CAT_IMP = 1 << 18,
    HM_CAT_PINKY = 1 << 19, // Spectres count as pinkys
    HM_CAT_REVENANT = 1 << 20,
    HM_CAT_CACODEMON = 1 << 21,
    HM_CAT_LOSTSOUL = 1 << 22,
    HM_CAT_PAINELEMENTAL = 1 << 23,
    HM_CAT_HELLKNIGHT = 1 << 24,
    HM_CAT_BARONOFHELL = 1 << 25,
    HM_CAT_MANCUBUS = 1 << 26,
    HM_CAT_ARCHVILE = 1 << 27,
    HM_CAT_ARACHNOTRON = 1 << 28,
    HM_CAT_SPIDERMASTERMIND = 1 << 29,
    HM_CAT_CYBERDEMON = 1 << 30,
    HM_CAT_BOSSBRAIN = 1 << 31
};

extend class HM_GlobalEventHandler
{
    void CreateMutationDefinitions()
    {
        console.printf("TEST %d %d", HM_CAT_BOSSBRAIN, HM_CAT_CYBERDEMON);

        AddMutationDefinition(
            "abundance",
            "Abundance",
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses fire additional projectiles in each\nhorizontal direction."
        );

        AddMutationDefinition(
            "adrenaline",
            "Adrenaline",
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER,
            "Zombiemen, Shotgunners and their variants are more aggressive."
        );

        AddMutationDefinition(
            "aethericritual",
            "Aetheric Ritual",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles do not require to be able to see a corpse\nto resurrect it."
        );

        AddMutationDefinition(
            "affinity",
            "Affinity",
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Pain Elementals have much more health, but take damage along with\ntheir Lost Souls."
        );

        AddMutationDefinition(
            "ambushshield",
            "Ambush Shield",
            HM_CAT_DOOM2 | HM_CAT_CHAINGUNNER,
            "Chaingunners get a brief invulnerability\nshield when they first open fire."
        );

        AddMutationDefinition(
            "anger",
            "Anger",
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost Souls get angry when they see other monsters die."
        );

        AddMutationDefinition(
            "argenthydraulics",
            "Argent Hydraulics",
            HM_CAT_ARACHNOTRON | HM_CAT_SPIDERMASTERMIND,
            "Arachnotrons and Spider Masterminds walk much faster."
        );
        
        AddMutationDefinition(
            "ascension",
            "Ascension",
            HM_CAT_DOOM2 | HM_CAT_HELLKNIGHT,
            "Hell Knights who score a hit on the player become Barons of Hell."
        );

        AddMutationDefinition(
            "barrage",
            "Barrage",
            HM_CAT_IMP,
            "Imps fire three fireballs in a rapid barrage."
        );
        
        AddMutationDefinition(
            "bigfuckingwomp",
            "Big Fucking Womp",
            HM_CAT_CYBERDEMON | HM_CAT_SPIDERMASTERMIND,
            "Cyberdemons and Spider Masterminds take much less damage from BFG9000."
        );

        AddMutationDefinition(
            "bloodtax",
            "Blood Tax",
            HM_CAT_PLAYER,
            "Player takes 25 damage when they pick up a keycard or a\nskull key (this damage cannot kill)."
        );

        AddMutationDefinition(
            "borealgaze",
            "Boreal Gaze",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles progressively slow down their target with their flame attack."
        );

        AddMutationDefinition(
            "brightfire",
            "Brightfire",
            HM_CAT_IMP,
            "Imps and their variants are faster."
        );
        
        AddMutationDefinition(
            "broodfabrication",
            "Brood Fabrication",
            HM_CAT_DOOM2 | HM_CAT_SPIDERMASTERMIND,
            "Spider Masterminds rapidly spawn Arachnotrons."
        );

        AddMutationDefinition(
            "cacoblasters",
            "Cacoblasters",
            HM_CAT_CACODEMON,
            "Cacodemons fire two additional projectiles."
        );

        AddMutationDefinition(
            "camouflagefinesse",
            "Camouflage Finesse",
            HM_CAT_PINKY,
            "Spectres are completely invisible when they are not touching a player,\nattacking or being dealt damage."
        );

        AddMutationDefinition(
            "catastrophicreflux",
            "Catastrophic Reflux",
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses cause a powerful explosion on death."
        );

        AddMutationDefinition(
            "closure",
            "Closure",
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost Souls explode on death, dealing light area damage."
        );
        
        AddMutationDefinition(
            "compassion",
            "Compassion",
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls never attack each other."
        );

        AddMutationDefinition(
            "craterhoof",
            "Craterhoof",
            HM_CAT_CYBERDEMON,
            "Cyberdemon hoof stomps damage and debilitate everything in\na moderate area."
        );

        AddMutationDefinition(
            "cyberneuralreflexes",
            "Cyber-Neural Reflexes",
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotrons immediately return fire when attacked."
        );

        AddMutationDefinition(
            "dampingjaws",
            "Damping Jaws",
            HM_CAT_CACODEMON,
            "Damage from Cacodemons removes powerup effects from players."
        );

        AddMutationDefinition(
            "decapitation",
            "Decapitation",
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER | HM_CAT_CHAINGUNNER,
            "Zombiemen, Shotgunners, Chaingunners may spawn a lost soul\nafter dying, unless gibbed."
        );

        AddMutationDefinition(
            "decoys",
            "Decoys",
            HM_CAT_DOOM2 | HM_CAT_REVENANT,
            "Revenants may spawn a harmless decoy when they get hit."
        );

        AddMutationDefinition(
            "defundedresearch",
            "Defunded Research",
            HM_CAT_PLAYER,
            "One less DNA might spawn in each level."
        );

        AddMutationDefinition(
            "dejavu",
            "Deja Vu",
            HM_CAT_ALLMONSTERS,
            "Monsters might ambush you more than once!"
        );

        AddMutationDefinition(
            "dependence",
            "Dependence",
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Pain Elementals spawn Lost Souls much faster, but they all\ndie when it dies."
        );

        AddMutationDefinition(
            "desecration",
            "Desecration",
            HM_CAT_IMP,
            "Imps who score a hit on the player become Arch-Imps."
        );

        AddMutationDefinition(
            "desire",
            "Desire",
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls charge at greater speed."
        );

        AddMutationDefinition(
            "discord",
            "Discord",
            HM_CAT_IMP,
            "Imps can damage and kill other Imps. Whenever an Imp kills another monster, they become an Arch-imp."
        );

        AddMutationDefinition(
            "dominance",
            "Dominance",
            HM_CAT_CYBERDEMON,
            "Cyberdemons can attack while walking."
        );
        
        AddMutationDefinition(
            "doppelgangers",
            "Doppelgangers",
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "A dead copy of each monster is spawned somewhere in the level."
        );

        AddMutationDefinition(
            "explosivesurprise",
            "Explosive Surprise",
            HM_CAT_BARREL,
            "Barrels may spawn a monster after exploding."
        );

        AddMutationDefinition(
            "extendedaccelerators",
            "Extended Acelerators",
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotron projectiles are much faster."
        );
       
        AddMutationDefinition(
            "extremophilia",
            "Extremophilia",
            HM_CAT_DMGFLOOR,
            "Monsters recover some health each second on a damaging floor."
        );

        AddMutationDefinition(
            "fistatrophy",
            "Fist Atrophy",
            HM_CAT_DOOM2 | HM_CAT_REVENANT,
            "Revenants always use their ranged attack instead of punching."
        );

        AddMutationDefinition(
            "fleshinversion",
            "Flesh Inversion",
            HM_CAT_PLAYER,
            "Swap current heath and armor after each level. This can't kill the player."
        );

        AddMutationDefinition(
            "geneticinstability",
            "Genetic Instability",
            HM_CAT_ALLMONSTERS,
            "An additional mutation might affect the monsters in each level."
        );

        AddMutationDefinition(
            "gorgonprotocol",
            "Gorgon Protocol",
            HM_CAT_SPIDERMASTERMIND,
            "Laying gaze on a Spider Mastermind rapidly immobilizes the player.\n Their speed and especially strafing become greatly reduced."
        );

        AddMutationDefinition(
            "greaterritual",
            "Greater Ritual",
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "Arch-Imps and Arch-Viles can resurrect Arch-Imps, Arch-Viles,\nPain Elementals, Spider Masterminds and Cyberdemons."
        );

        AddMutationDefinition(
            "hellscaress",
            "Hell's Caress",
            HM_CAT_IMP | HM_CAT_REVENANT | HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Melee attacks of Imps, Revenants, Hell Knights, Barons of Hell \nare much more powerful."
        );

        AddMutationDefinition(
            "hematophagy",
            "Hematophagy",
            HM_CAT_PINKY,
            "Pinkies and their variants become fully healed whenever they deal damage."
        );

        AddMutationDefinition(
            "highground",
            "High Ground",
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER | HM_CAT_CHAINGUNNER,
            "Zombiemen, Shotgunners, Chaingunners and their variants\ndeal more damage when attacking from above."
        );

        AddMutationDefinition(
            "hypercognition",
            "Hypercognition",
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotrons lead their target when aiming."
        );

        AddMutationDefinition(
            "hyperfuel",
            "Hyper-Fuel",
            HM_CAT_REVENANT | HM_CAT_CYBERDEMON,
            "All rockets and guided rockets fired by monsters are faster."
        );

        AddMutationDefinition(
            "hyperphagy",
            "Hyperphagy",
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses are more aggressive."
        );

        AddMutationDefinition(
            "insomnia",
            "Insomnia",
            HM_CAT_NOFIRSTMAP | HM_CAT_ALLMONSTERS,
            "Monsters do not start the level asleep."
        );
       
        AddMutationDefinition(
            "kleptomania",
            "Kleptomania",
            HM_CAT_PLAYER,
            "Players lose all rockets and plasma ammo between levels."
        );

        AddMutationDefinition(
            "lordsofchaos",
            "Lords of Chaos",
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knight and Baron of Hell projectile speed is\nchaotically randomized."
        );

        AddMutationDefinition(
            "lordsofdarkness",
            "Lords of Darkness",
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knights and Barons of Hell take less damage\nwhile in darkness."
        );

        AddMutationDefinition(
            "lordsofreality",
            "Lords of Reality",
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knight and Baron of Hell projectiles pass through\nother Hell Knights and Barons of Hell."
        );

        AddMutationDefinition(
            "lordsofsouls",
            "Lords of Souls",
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Players taking damage from Hell Knights and Barons of Hell\nmight cause a nearby monster to resurrect."
        );

        AddMutationDefinition(
            "lordsofvengeance",
            "Lords of Vengeance",
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knights and Barons of Hell get increasingly angry\nas they take damage."
        );

        AddMutationDefinition(
            "macropods",
            "Macropods",
            HM_CAT_PINKY,
            "Pinkies and Spectres can pounce from a distance, and across gaps."
        );

        AddMutationDefinition(
            "metamutation",
            "Metamutation",
            HM_CAT_PLAYER,
            "Each newly added mutation has a chance to be already unremovable."
        );

        AddMutationDefinition(
            "momentum",
            "Momentum",
            HM_CAT_CACODEMON,
            "Cacodemons attack faster the faster they are moving."
        );

        AddMutationDefinition(
            "napalmpayload",
            "Napalm Payload",
            HM_CAT_DOOM2| HM_CAT_MANCUBUS,
            "Mancubuses spread fire with their attacks."
        );

        AddMutationDefinition(
            "obesity",
            "Obesity",
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubuses have more health."
        );

        AddMutationDefinition(
            "obsession",
            "Obsession",
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Pain Elementals spawn a Lost Soul whenever they flinch with pain."
        );

        AddMutationDefinition(
            "odiousritual",
            "Odious Ritual",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles resurrect monsters continuously, without interruption."
        );

        AddMutationDefinition(
            "omnispectrality",
            "Omnispectrality",
            HM_CAT_PINKY,
            "All pinkes are replaced with spectres."
        );
        
        AddMutationDefinition(
            "overwhelmingfire",
            "Overwhelming Fire",
            HM_CAT_DOOM2 | HM_CAT_ARACHNOTRON,
            "Arachnotron fire rate continuously ramps up as they fire."
        );

        AddMutationDefinition(
            "phylactery",
            "Phylactery",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles cannot die as long as the last monster they\nresurrected is alive."
        );
        
        AddMutationDefinition(
            "pomodorosustenance",
            "Pomodoro Sustenance",
            HM_CAT_CACODEMON,
            "Dying Cacodemons heal other monsters around where they crash."
        );
        
        AddMutationDefinition(
            "trauma",
            "Trauma",
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Pain Elementals spawn along with several Lost Souls."
        );

        AddMutationDefinition(
            "pride",
            "Pride",
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls deal and take much more damage."
        );

        AddMutationDefinition(
            "promotion",
            "Promotion",
            HM_CAT_ZOMBIEMAN,
            "Basic Zombiemen who score a hit on the player become Shotgunners."
        );

        AddMutationDefinition(
            "rage",
            "Rage",
            HM_CAT_PINKY,
            "Pinkies and Spectres are faster."
        );

        AddMutationDefinition(
            "rapidspin",
            "Rapid Spin",
            HM_CAT_DOOM2 | HM_CAT_CHAINGUNNER,
            "Chaingunners react faster."
        );

        AddMutationDefinition(
            "reachingritual",
            "Reaching Ritual",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles can resurrect monsters from a greater distance."
        );

        AddMutationDefinition(
            "reactivecamouflage",
            "Reactive Camouflage",
            HM_CAT_PINKY,
            "Pinkies become spectral when damaged."
        );

        AddMutationDefinition(
            "regality",
            "Regality",
            HM_CAT_CYBERDEMON,
            "Cyberdemons deal devastating damage to other monsters\nand take very little damage from other monsters."
        );

        AddMutationDefinition(
            "regret",
            "Regret",
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Pain Elementals failing to spawn a Lost Soul cause an explosion."
        );

        AddMutationDefinition(
            "rhythmofwar",
            "Rhythm of War",
            HM_CAT_CYBERDEMON,
            "Whenever a Cyberdemon attacks, all other monsters fire as well."
        );

        AddMutationDefinition(
            "rushedritual",
            "Rushed Ritual",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Viles resurrect monsters faster, but with less health."
        );

        AddMutationDefinition(
            "sacrifice",
            "Sacrifice",
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "Arch-Viles and Arch-Imps redirect some of the damage they \nwould take to other nearby monsters."
        );

        AddMutationDefinition(
            "scorchinggaze",
            "Scorching Gaze",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Vile flames deal moderate damage."
        );

        AddMutationDefinition(
            "sirenicgaze",
            "Sirenic Gaze",
            HM_CAT_DOOM2 | HM_CAT_ARCHVILE,
            "Arch-Vile attack pulls its victim towards it."
        );

        AddMutationDefinition(
            "slimeborne",
            "Slimeborne",
            HM_CAT_DMGFLOOR,
            "Player losing health to a damaging floor might cause Pinkies to spawn."
        );

        AddMutationDefinition(
            "sovereignty",
            "Sovereignty",
            HM_CAT_DOOM2 | HM_CAT_CYBERDEMON,
            "Cyberdemons have a chance to shoot a Hell Cube instead of a rocket."
        );

        AddMutationDefinition(
            "stormtroopers",
            "Stormtroopers",
            HM_CAT_ZOMBIEMAN,
            "Basic Zombiemen are significantly more accurate."
        );

        AddMutationDefinition(
            "torrentcannons",
            "Torrent Cannons",
            HM_CAT_CHAINGUNNER | HM_CAT_SPIDERMASTERMIND,
            "Chaingunners and Spider Masterminds fire explosive rounds."
        );

        AddMutationDefinition(
            "triumvirate",
            "Triumvirate",
            HM_CAT_CYBERDEMON,
            "Cyberdemons spawn as a trio, sharing a single health pool."
        );

        AddMutationDefinition(
            "tyranny",
            "Tyranny",
            HM_CAT_CYBERDEMON,
            "Cyberdemons get increasingly angry as their target evades them."
        );

        AddMutationDefinition(
            "unholylegion",
            "Unholy Legion",
            HM_CAT_IMP,
            "Arch-Imps replace Imps three times as frequently."
        );

        AddMutationDefinition(
            "unstoppable",
            "Unstoppable",
            HM_CAT_PINKY,
            "Pinkies and their variants are almost immune to pain."
        );

        AddMutationDefinition(
            "unyielding",
            "Unyelding",
            HM_CAT_CACODEMON,
            "Cacodemons are more resistant to pain."
        );

        AddMutationDefinition(
            "vileincursion",
            "Vile Incursion",
            HM_CAT_DOOM2 | HM_CAT_NOFIRSTMAP,
            "An additional Arch-Vile spawns somewhere in each level."
        );

        AddMutationDefinition(
            "vitalitylimit",
            "Vitality Limit",
            HM_CAT_PLAYER,
            "Player health over 100 slowly degenerates."
        );
        
        AddMutationDefinition(
            "walloffire",
            "Wall of Fire",
            HM_CAT_DOOM2 | HM_CAT_MANCUBUS,
            "Mancubus projectiles spread vertically as well as horizontally."
        );

        AddMutationDefinition(
            "workplacesafety",
            "Workplace Safety",
            HM_CAT_BARREL,
            "Removes all explosive barrels."
        );

        AddMutationDefinition(
            "zeal",
            "Zeal",
            HM_CAT_DOOM2 | HM_CAT_PAINELEMENTAL,
            "Whenever a Pain Elemental spawns a Lost Soul, all\nthe Lost Souls spawned by it immediately charge."
        );
    }
    
    private void AddMutationDefinition(string key, string name, HM_Category category, string description)
    {
        let mutationDefinition = new("HM_Definition");
        mutationDefinition.Key = key;
        mutationDefinition.Name = name;
        mutationDefinition.MapNumber = 0;
        mutationDefinition.Category = category;
        mutationDefinition.Description = description;
        MutationDefinitions.Push(mutationDefinition);
    }
}

