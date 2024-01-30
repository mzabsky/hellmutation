class HM_Definition
{
    string Key;
    int MapNumber;
    string Name;
    Array<HM_Category> Categories;
    string Description;
    
}

extend class HM_GlobalEventHandler
{
    void CreateMutationDefinitions()
    {
        console.printf("TEST %d %d", HM_CAT_BOSSBRAIN, HM_CAT_CYBERDEMON);

        AddMutationDefinition(
            "abundance",
            "Abundance",
            "Mancubuses fire additional projectiles in each\nhorizontal direction.",
            HM_CAT_DOOM2,
            HM_CAT_MANCUBUS
        );

        AddMutationDefinition(
            "adrenaline",
            "Adrenaline",
            "Zombiemen, Shotgunners and their variants are more aggressive.",
            HM_CAT_ZOMBIEMAN,
            HM_CAT_SHOTGUNNER
        );

        AddMutationDefinition(
            "aethericritual",
            "Aetheric Ritual",
            "Arch-Viles do not require to be able to see a corpse\nto resurrect it.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "affinity",
            "Affinity",
            "Pain Elementals have much more health, but take damage along with\ntheir Lost Souls.",
            HM_CAT_DOOM2,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "ambushshield",
            "Ambush Shield",
            "Chaingunners get a brief invulnerability\nshield when they first open fire.",
            HM_CAT_DOOM2,
            HM_CAT_CHAINGUNNER
        );

        AddMutationDefinition(
            "anger",
            "Anger",
            "Lost Souls get angry when they see other monsters die.",
            HM_CAT_LOSTSOUL,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "argenthydraulics",
            "Argent Hydraulics",
            "Arachnotrons and Spider Masterminds walk much faster.",
            HM_CAT_ARACHNOTRON,
            HM_CAT_SPIDERMASTERMIND
        );
        
        AddMutationDefinition(
            "ascension",
            "Ascension",
            "Hell Knights who score a hit on the player become Barons of Hell.",
            HM_CAT_DOOM2,
            HM_CAT_HELLKNIGHT
        );

        AddMutationDefinition(
            "barrage",
            "Barrage",
            "Imps fire three fireballs in a rapid barrage.",
            HM_CAT_IMP
        );
        
        AddMutationDefinition(
            "bigfuckingwomp",
            "Big Fucking Womp",
            "Cyberdemons and Spider Masterminds take much less damage from BFG9000.",
            HM_CAT_CYBERDEMON,
            HM_CAT_SPIDERMASTERMIND
        );

        AddMutationDefinition(
            "bloodtax",
            "Blood Tax",
            "Player takes 25 damage when they pick up a keycard or a\nskull key (this damage cannot kill).",
            HM_CAT_KEY
        );

        AddMutationDefinition(
            "borealgaze",
            "Boreal Gaze",
            "Arch-Viles progressively slow down their target with their flame attack.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "brightfire",
            "Brightfire",
            "Imps and their variants are faster and more aggressive.",
            HM_CAT_IMP
        );
        
        AddMutationDefinition(
            "broodfabrication",
            "Brood Fabrication",
            "Spider Masterminds rapidly spawn Arachnotrons.",
            HM_CAT_DOOM2,
            HM_CAT_SPIDERMASTERMIND
        );

        AddMutationDefinition(
            "cacoblasters",
            "Cacoblasters",
            "Cacodemons fire two additional projectiles.",
            HM_CAT_CACODEMON
        );

        AddMutationDefinition(
            "camouflagefinesse",
            "Camouflage Finesse",
            "Spectres are completely invisible when they are not touching a player,\nattacking or being dealt damage.",
            HM_CAT_PINKY
        );

        AddMutationDefinition(
            "catastrophicreflux",
            "Catastrophic Reflux",
            "Mancubuses cause a powerful explosion on death.",
            HM_CAT_DOOM2,
            HM_CAT_MANCUBUS
        );

        AddMutationDefinition(
            "closure",
            "Closure",
            "Lost Souls explode on death, dealing light area damage.",
            HM_CAT_LOSTSOUL,
            HM_CAT_PAINELEMENTAL
        );
        
        AddMutationDefinition(
            "compassion",
            "Compassion",
            "Lost souls never attack each other.",
            HM_CAT_LOSTSOUL,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "craterhoof",
            "Craterhoof",
            "Cyberdemon hoof stomps damage and debilitate everything in\na moderate area.",
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "cyberneuralreflexes",
            "Cyber-Neural Reflexes",
            "Arachnotrons immediately return fire when attacked.",
            HM_CAT_DOOM2,
            HM_CAT_ARACHNOTRON
        );

        AddMutationDefinition(
            "dampingjaws",
            "Damping Jaws",
            "Damage from Cacodemons removes powerup effects from players.",
            HM_CAT_CACODEMON
        );

        AddMutationDefinition(
            "decapitation",
            "Decapitation",
            "Zombiemen, Shotgunners, Chaingunners may spawn a lost soul\nafter dying, unless gibbed.",
            HM_CAT_ZOMBIEMAN,
            HM_CAT_SHOTGUNNER,
            HM_CAT_CHAINGUNNER
        );

        AddMutationDefinition(
            "decoys",
            "Decoys",
            "Revenants may spawn a harmless decoy when they get hit.",
            HM_CAT_DOOM2,
            HM_CAT_REVENANT
        );

        AddMutationDefinition(
            "defundedresearch",
            "Defunded Research",
            "One less DNA might spawn in each level.",
            HM_CAT_META
        );

        AddMutationDefinition(
            "dejavu",
            "Deja Vu",
            "Monsters might ambush you more than once!",
            HM_CAT_ALLMONSTERS
        );

        AddMutationDefinition(
            "dependence",
            "Dependence",
            "Pain Elementals spawn Lost Souls much faster, but they all\ndie when it dies.",
            HM_CAT_DOOM2,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "desecration",
            "Desecration",
            "Imps who score a hit on the player become Arch-Imps.",
            HM_CAT_IMP
        );

        AddMutationDefinition(
            "desire",
            "Desire",
            "Lost souls charge at greater speed.",
            HM_CAT_LOSTSOUL,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "discord",
            "Discord",
            "Imps can damage and kill other Imps. Whenever an Imp kills another monster, they become an Arch-imp.",
            HM_CAT_IMP
        );

        AddMutationDefinition(
            "dominance",
            "Dominance",
            "Cyberdemons can attack while walking.",
            HM_CAT_CYBERDEMON
        );
        
        AddMutationDefinition(
            "doppelgangers",
            "Doppelgangers",
            "A dead copy of each monster is spawned somewhere in the level.",
            HM_CAT_IMP,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "explosivesurprise",
            "Explosive Surprise",
            "Barrels may spawn a monster after exploding.",
            HM_CAT_BARREL
        );

        AddMutationDefinition(
            "extendedaccelerators",
            "Extended Accelerators",
            "Arachnotron projectiles are much faster.",
            HM_CAT_DOOM2,
            HM_CAT_ARACHNOTRON
        );
       
        AddMutationDefinition(
            "extremophilia",
            "Extremophilia",
            "Monsters recover some health each second on a damaging floor.",
            HM_CAT_DMGFLOOR
        );

        AddMutationDefinition(
            "fistatrophy",
            "Fist Atrophy",
            "Revenants always use their ranged attack instead of punching.",
            HM_CAT_DOOM2,
            HM_CAT_REVENANT
        );

        AddMutationDefinition(
            "fleshinversion",
            "Flesh Inversion",
            "Swap current heath and armor after each level. This can't kill the player.",
            HM_CAT_PLAYER
        );

        AddMutationDefinition(
            "geneticinstability",
            "Genetic Instability",
            "An additional mutation might affect the monsters in each level.",
            HM_CAT_META
        );

        AddMutationDefinition(
            "gorgonprotocol",
            "Gorgon Protocol",
            "Laying gaze on a Spider Mastermind rapidly immobilizes the player.\n Their speed and especially strafing become greatly reduced.",
            HM_CAT_SPIDERMASTERMIND
        );

        AddMutationDefinition(
            "greaterritual",
            "Greater Ritual",
            "Arch-Imps and Arch-Viles can resurrect Arch-Imps, Arch-Viles,\nPain Elementals, Spider Masterminds and Cyberdemons.",
            HM_CAT_IMP,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "hellscaress",
            "Hell's Caress",
            "Melee attacks of Imps, Revenants, Hell Knights, Barons of Hell \nare much more powerful.",
            HM_CAT_IMP,
            HM_CAT_REVENANT,
            HM_CAT_HELLKNIGHT,
            HM_CAT_BARONOFHELL
        );

        AddMutationDefinition(
            "hematophagy",
            "Hematophagy",
            "Pinkies and their variants become fully healed whenever they deal damage.",
            HM_CAT_PINKY
        );

        AddMutationDefinition(
            "highground",
            "High Ground",
            "Zombiemen, Shotgunners, Chaingunners and their variants\ndeal more damage when attacking from above.",
            HM_CAT_ZOMBIEMAN,
            HM_CAT_SHOTGUNNER,
            HM_CAT_CHAINGUNNER
        );

        AddMutationDefinition(
            "hypercognition",
            "Hypercognition",
            "Arachnotrons lead their target when aiming.",
            HM_CAT_DOOM2,
            HM_CAT_ARACHNOTRON
        );

        AddMutationDefinition(
            "hyperfuel",
            "Hyper-Fuel",
            "All rockets and guided rockets fired by monsters are faster.",
            HM_CAT_REVENANT,
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "hyperphagy",
            "Hyperphagy",
            "Mancubuses are more aggressive.",
            HM_CAT_DOOM2,
            HM_CAT_MANCUBUS
        );

        AddMutationDefinition(
            "insomnia",
            "Insomnia",
            "Monsters do not start the level asleep.",
            HM_CAT_NOFIRSTMAP,
            HM_CAT_ALLMONSTERS
        );
       
        AddMutationDefinition(
            "kleptomania",
            "Kleptomania",
            "Players lose all rockets and plasma ammo between levels.",
            HM_CAT_PLAYER,
            HM_CAT_AMMO
        );

        AddMutationDefinition(
            "lordsofchaos",
            "Lords of Chaos",
            "Hell Knight and Baron of Hell projectile speed is\nchaotically randomized.",
            HM_CAT_HELLKNIGHT,
            HM_CAT_BARONOFHELL
        );

        AddMutationDefinition(
            "lordsofdarkness",
            "Lords of Darkness",
            "Hell Knights and Barons of Hell take less damage\nwhile in darkness.",
            HM_CAT_HELLKNIGHT,
            HM_CAT_BARONOFHELL
        );

        AddMutationDefinition(
            "lordsofreality",
            "Lords of Reality",
            "Hell Knight and Baron of Hell projectiles pass through\nother Hell Knights and Barons of Hell.",
            HM_CAT_HELLKNIGHT,
            HM_CAT_BARONOFHELL
        );

        AddMutationDefinition(
            "lordsofsouls",
            "Lords of Souls",
            "Players taking damage from Hell Knights and Barons of Hell\nmight cause a nearby monster to resurrect.",
            HM_CAT_HELLKNIGHT,
            HM_CAT_BARONOFHELL
        );

        AddMutationDefinition(
            "lordsofvengeance",
            "Lords of Vengeance",
            "Hell Knights and Barons of Hell get increasingly angry\nas they take damage.",
            HM_CAT_HELLKNIGHT,
            HM_CAT_BARONOFHELL
        );

        AddMutationDefinition(
            "macropods",
            "Macropods",
            "Pinkies and Spectres can pounce from a distance, and across gaps.",
            HM_CAT_PINKY
        );

        AddMutationDefinition(
            "metamutation",
            "Metamutation",
            "Each newly added mutation has a chance to be already unremovable.",
            HM_CAT_META
        );

        AddMutationDefinition(
            "momentum",
            "Momentum",
            "Cacodemons attack faster the faster they are moving.",
            HM_CAT_CACODEMON
        );

        AddMutationDefinition(
            "napalmpayload",
            "Napalm Payload",
            "Mancubuses spread fire with their attacks.",
            HM_CAT_DOOM2,
            HM_CAT_MANCUBUS
        );

        AddMutationDefinition(
            "obesity",
            "Obesity",
            "Mancubuses have more health.",
            HM_CAT_DOOM2,
            HM_CAT_MANCUBUS
        );

        AddMutationDefinition(
            "obsession",
            "Obsession",
            "Pain Elementals spawn a Lost Soul whenever they flinch with pain.",
            HM_CAT_DOOM2,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "odiousritual",
            "Odious Ritual",
            "Arch-Viles resurrect monsters continuously, without interruption.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "omnispectrality",
            "Omnispectrality",
            "All pinkes are replaced with spectres.",
            HM_CAT_PINKY
        );
        
        AddMutationDefinition(
            "overwhelmingfire",
            "Overwhelming Fire",
            "Arachnotron fire rate continuously ramps up as they fire.",
            HM_CAT_DOOM2,
            HM_CAT_ARACHNOTRON
        );

        AddMutationDefinition(
            "phylactery",
            "Phylactery",
            "Arch-Viles cannot die as long as the last monster they\nresurrected is alive.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );
        
        AddMutationDefinition(
            "pomodorosustenance",
            "Pomodoro Sustenance",
            "Dying Cacodemons heal other monsters around where they crash.",
            HM_CAT_CACODEMON
        );
        
        AddMutationDefinition(
            "trauma",
            "Trauma",
            "Pain Elementals spawn along with several Lost Souls.",
            HM_CAT_DOOM2,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "pride",
            "Pride",
            "Lost souls deal and take much more damage.",
            HM_CAT_LOSTSOUL,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "promotion",
            "Promotion",
            "Basic Zombiemen who score a hit on the player become Shotgunners.",
            HM_CAT_ZOMBIEMAN
        );

        AddMutationDefinition(
            "rage",
            "Rage",
            "Pinkies and Spectres are faster.",
            HM_CAT_PINKY
        );

        AddMutationDefinition(
            "rapidspin",
            "Rapid Spin",
            "Chaingunners react faster.",
            HM_CAT_DOOM2,
            HM_CAT_CHAINGUNNER
        );

        AddMutationDefinition(
            "reachingritual",
            "Reaching Ritual",
            "Arch-Viles can resurrect monsters from a greater distance.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "reactivecamouflage",
            "Reactive Camouflage",
            "Pinkies become spectral when damaged.",
            HM_CAT_PINKY
        );

        AddMutationDefinition(
            "regality",
            "Regality",
            "Cyberdemons deal devastating damage to other monsters\nand take very little damage from other monsters.",
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "regret",
            "Regret",
            "Pain Elementals failing to spawn a Lost Soul cause an explosion.",
            HM_CAT_DOOM2,
            HM_CAT_PAINELEMENTAL
        );

        AddMutationDefinition(
            "rhythmofwar",
            "Rhythm of War",
            "Whenever a Cyberdemon attacks, all other monsters fire as well.",
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "rushedritual",
            "Rushed Ritual",
            "Arch-Viles resurrect monsters faster, but with less health.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "sacrifice",
            "Sacrifice",
            "Arch-Viles and Arch-Imps redirect some of the damage they \nwould take to other nearby monsters.",
            HM_CAT_IMP,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "scorchinggaze",
            "Scorching Gaze",
            "Arch-Vile flames deal moderate damage.",
            HM_CAT_DOOM2,
            HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "sirenicgaze",
            "Sirenic Gaze",
            "Arch-Vile attack pulls its victim towards it.",
            HM_CAT_DOOM2,HM_CAT_ARCHVILE
        );

        AddMutationDefinition(
            "slimeborne",
            "Slimeborne",
            "Player losing health to a damaging floor might cause Pinkies to spawn.",
            HM_CAT_DMGFLOOR
        );

        AddMutationDefinition(
            "sovereignty",
            "Sovereignty",
            "Cyberdemons have a chance to shoot a Hell Cube instead of a rocket.",
            HM_CAT_DOOM2,
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "stormtroopers",
            "Stormtroopers",
            "Basic Zombiemen are significantly more accurate.",
            HM_CAT_ZOMBIEMAN
        );

        AddMutationDefinition(
            "torrentcannons",
            "Torrent Cannons",
            "Chaingunners and Spider Masterminds fire explosive rounds.",
            HM_CAT_CHAINGUNNER,
            HM_CAT_SPIDERMASTERMIND
        );

        AddMutationDefinition(
            "triumvirate",
            "Triumvirate",
            "Cyberdemons spawn as a trio, sharing a single health pool.",
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "tyranny",
            "Tyranny",
            "Cyberdemons get increasingly angry as their target evades them.",
            HM_CAT_CYBERDEMON
        );

        AddMutationDefinition(
            "unholylegion",
            "Unholy Legion",
            "Arch-Imps replace Imps three times as frequently.",
            HM_CAT_IMP
        );

        AddMutationDefinition(
            "unstoppable",
            "Unstoppable",
            "Pinkies and their variants are almost immune to pain.",
            HM_CAT_PINKY
        );

        AddMutationDefinition(
            "unyielding",
            "Unyelding",
            "Cacodemons are more resistant to pain.",
            HM_CAT_CACODEMON
        );

        AddMutationDefinition(
            "vileincursion",
            "Vile Incursion",
            "An additional Arch-Vile spawns somewhere in each level.",
            HM_CAT_DOOM2,
            HM_CAT_NOFIRSTMAP
        );

        AddMutationDefinition(
            "vitalitylimit",
            "Vitality Limit",
            "Player health over 100 slowly degenerates.",
            HM_CAT_PLAYER
        );
        
        AddMutationDefinition(
            "walloffire",
            "Wall of Fire",
            "Mancubus projectiles spread vertically as well as horizontally.",
            HM_CAT_DOOM2,
            HM_CAT_MANCUBUS
        );

        AddMutationDefinition(
            "workplacesafety",
            "Workplace Safety",
            "Removes all explosive barrels.",
            HM_CAT_BARREL
        );

        AddMutationDefinition(
            "zeal",
            "Zeal",
            "Whenever a Pain Elemental spawns a Lost Soul, all\nthe Lost Souls spawned by it immediately charge.",
            HM_CAT_DOOM2,
            HM_CAT_PAINELEMENTAL
        );
    }
    
    private void AddMutationDefinition(
        string key,
        string name,
        string description,
        HM_Category category1 = HM_CAT_NONE,
        HM_Category category2 = HM_CAT_NONE,
        HM_Category category3 = HM_CAT_NONE,
        HM_Category category4 = HM_CAT_NONE
    )
    {
        let mutationDefinition = new("HM_Definition");
        mutationDefinition.Key = key;
        mutationDefinition.Name = name;
        mutationDefinition.MapNumber = 0;
        mutationDefinition.Description = description;

        if(category1 != HM_CAT_NONE)
        {
            mutationDefinition.Categories.Push(category1);
        }

        if(category2 != HM_CAT_NONE)
        {
            mutationDefinition.Categories.Push(category2);
        }

        if(category3 != HM_CAT_NONE)
        {
            mutationDefinition.Categories.Push(category3);
        }

        if(category4 != HM_CAT_NONE)
        {
            mutationDefinition.Categories.Push(category4);
        }

        MutationDefinitions.Push(mutationDefinition);

        if(!ValidateCategoryOrder(mutationDefinition.Categories))
        {
            console.printf("...adding %s", mutationDefinition.Key);
        }
    }
}

