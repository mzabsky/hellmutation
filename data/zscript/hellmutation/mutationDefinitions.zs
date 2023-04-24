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
    HM_CAT_PLAYER = 1 << 0,
    HM_CAT_DMGFLOOR = 1 << 1,
    HM_CAT_BARREL = 1 << 2,
    HM_CAT_ALLMONSTERS = 1 << 3,
    HM_CAT_ZOMBIEMAN = 1 << 4,
    HM_CAT_SHOTGUNNER = 1 << 5,
    HM_CAT_CHAINGUNNER = 1 << 6,
    HM_CAT_IMP = 1 << 7,
    HM_CAT_PINKY = 1 << 8,
    //HM_CAT_SPECTRE = 1 << 9, spectre counts as a pinky
    HM_CAT_REVENANT = 1 << 9,
    HM_CAT_CACODEMON = 1 << 10,
    HM_CAT_LOSTSOUL = 1 << 11,
    HM_CAT_PAINELEMENTAL = 1 << 12,
    HM_CAT_HELLKNIGHT = 1 << 13,
    HM_CAT_BARONOFHELL = 1 << 14,
    HM_CAT_MANCUBUS = 1 << 15,
    HM_CAT_ARCHVILE = 1 << 16,
    HM_CAT_ARACHNOTRON = 1 << 17,
    HM_CAT_SPIDERMASTERMIND = 1 << 18,
    HM_CAT_CYBERDEMON = 1 << 19,
    HM_CAT_BOSSBRAIN = 1 << 20
};

extend class HM_GlobalEventHandler
{
    void CreateMutationDefinitions() {

        // Level 0 - MAP01/EXM1
        AddMutationDefinition(
            "stormtroopers",
            "Stormtroopers",
            0,
            HM_CAT_ZOMBIEMAN,
            "BASIC ZOMBIEMEN ARE SIGNIFICANTLY MORE ACCURATE."
        );

        AddMutationDefinition(
            "macropods",
            "Macropods",
            0,
            HM_CAT_PINKY,
            "PINKIES GAIN THE ABILITY TO POUNCE FROM A DISTANCE AND ACROSS GAPS."
        );

        AddMutationDefinition(
            "desecration",
            "Desecration",
            0,
            HM_CAT_IMP,
            "IMPS WHO SCORE A HIT ON A PLAYER BECOME ARCH-IMPS."
        );

        AddMutationDefinition(
            "hyperfuel",
            "Hyper-Fuel",
            0,
            HM_CAT_REVENANT | HM_CAT_CYBERDEMON,
            "ALL ROCKETS AND GUIDED ROCKETS FIRED BY MONSTERS ARE MUCH FASTER."
        );

        // Level 1 - MAP02/EXM2
        AddMutationDefinition(
            "insomnia",
            "Insomnia",
            1,
            HM_CAT_ALLMONSTERS,
            "MONSTERS DO NOT START THE LEVEL ASLEEP."
        );

        AddMutationDefinition(
            "promotion",
            "Promotion",
            1,
            HM_CAT_ZOMBIEMAN,
            "BASIC ZOMBIEMEN WHO SCORE A HIT ON A PLAYER BECOME SHOTGUNNERS."
        );

        AddMutationDefinition(
            "hematophagy",
            "Hematophagy",
            1,
            HM_CAT_PINKY,
            "Pinkies and their variants become fully healed whenever they deal damage."
        );

        AddMutationDefinition(
            "ego",
            "Ego",
            1,
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls deal and take much more damage."
        );
        
        // Level 2 - MAP03/EXM3
        AddMutationDefinition(
            "brightfire",
            "Brightfire",
            2,
            HM_CAT_IMP,
            "IMPS AND THEIR VARIANTS ARE FASTER."
        );

        AddMutationDefinition(
            "decapitation",
            "Decapitation",
            2,
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER | HM_CAT_CHAINGUNNER,
            "ZOMBIEMEN, SHOTGUNNERS, Chaingunners AND THEIR VARIANTS MAY SPAWN \nA LOST SOUL AFTER DYING, UNLESS GIBBED."
        );

        AddMutationDefinition(
            "hellscaress",
            "Hell's Caress",
            2,
            HM_CAT_IMP | HM_CAT_REVENANT | HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Melee attacks of Imps, Revenants, Hell Knights, Barons of Hell \nand their  variants are much more powerful."
        );

        AddMutationDefinition(
            "cacoblasters",
            "Cacoblasters",
            2,
            HM_CAT_CACODEMON,
            "Cacodemons always fire two additional projectiles."
        );

        // Level 3 - MAP04/EXM4
        AddMutationDefinition(
            "adrenaline",
            "Adrenaline",
            3,
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER,
            "Zombiemen, Shotgunners and their variants are faster."
        );

        AddMutationDefinition(
            "slimeborne",
            "Slimeborne",
            3,
            HM_CAT_DMGFLOOR,
            "Player losing health to a damaging floor might cause Pinkies to spawn."
        );

        AddMutationDefinition(
            "sacrifice",
            "Sacrifice",
            3,
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "Arch-Viles and Arch-Imps redirect some of the damage they \nwould take to other nearby monsters."
        );

        AddMutationDefinition(
            "adipocytes",
            "Adipocytes",
            3,
            HM_CAT_MANCUBUS,
            "Mancubuses and their variants have more health."
        );

        // Level 4 - MAP05/EXM5
        AddMutationDefinition(
            "barrage",
            "Barrage",
            4,
            HM_CAT_IMP,
            "Imps fire three fireballs in a rapid barrage."
        );

       
        AddMutationDefinition(
            "ambushshield",
            "Ambush Shield",
            4,
            HM_CAT_CHAINGUNNER,
            "Chaingunners and their variants get a brief invulnerability\nshield when they first open fire."
        );
       
        AddMutationDefinition(
            "kleptomania",
            "Kleptomania",
            4,
            HM_CAT_PLAYER,
            "Players lose all rockets and plasma ammo between levels."
        );
       
        AddMutationDefinition(
            "extremophilia",
            "Extremophilia",
            4,
            HM_CAT_DMGFLOOR,
            "Monsters recover some health each second on a damaging floor."
        );

        // Level 5 - MAP06/EXM6
        AddMutationDefinition(
            "unyielding",
            "Unyelding",
            5,
            HM_CAT_CACODEMON,
            "Cacodemons are more resistant to pain."
        );

        AddMutationDefinition(
            "highground",
            "High Ground",
            5,
            HM_CAT_ZOMBIEMAN | HM_CAT_SHOTGUNNER | HM_CAT_CHAINGUNNER,
            "Zombiemen, Shotgunners, Chaingunners and their variants\ndeal more damage when attacking from above."
        );

        AddMutationDefinition(
            "lordsofdarkness",
            "Lords of Darkness",
            5,
            HM_CAT_HELLKNIGHT | HM_CAT_BARONOFHELL,
            "Hell Knights and Barons of Hell take less damage\nwhile in darkness."
        );

        AddMutationDefinition(
            "seekingsouls",
            "Seeking Souls",
            5,
            HM_CAT_LOSTSOUL | HM_CAT_PAINELEMENTAL,
            "Lost souls charge at greater speed."
        );

        // Level 6 - MAP07/EXM7
        AddMutationDefinition(
            "rapidspin",
            "Rapid Spin",
            6,
            HM_CAT_CHAINGUNNER,
            "Chaingunners and their variants are faster."
        );

        AddMutationDefinition(
            "cyberneuralreflexes",
            "Cyber-Neural Reflexes",
            6,
            HM_CAT_ARACHNOTRON,
            "Arachnotrons and their variants immediately return fire when attacked."
        );

        AddMutationDefinition(
            "abundance",
            "Abundance",
            6,
            HM_CAT_MANCUBUS,
            "Mancubuses fire additional projectiles in each\nhorizontal direction."
        );

        AddMutationDefinition(
            "decoys",
            "Decoys",
            6,
            HM_CAT_REVENANT,
            "Revenants may spawn a harmless decoy when they get hit."
        );

        AddMutationDefinition(
            "explosivesurprise",
            "Explosive Surprise",
            6,
            HM_CAT_BARREL,
            "Barrels may spawn a monster after exploding."
        );

        AddMutationDefinition(
            "greaterritual",
            "Greater Ritual",
            6,
            HM_CAT_IMP | HM_CAT_ARCHVILE,
            "Arch-Imps and Arch-Viles can resurrect Arch-Viles, Pain\nElementals, Spider Masterminds and Cyberdemons."
        );

        AddMutationDefinition(
            "bigfuckingwomp",
            "Big Fucking Womp",
            6,
            HM_CAT_CYBERDEMON | HM_CAT_SPIDERMASTERMIND,
            "Cyberdemons and Spider Mastermind take much less damage from BFG9000."
        );

        AddMutationDefinition(
            "unstoppable",
            "Unstoppable",
            6,
            HM_CAT_PINKY,
            "Pinkies and their variants are almost immune to pain."
        );

        AddMutationDefinition(
            "hypercognition",
            "Hypercognition",
            6,
            HM_CAT_ARACHNOTRON,
            "Arachnotrons can lead their target when aiming."
        );

        

        /*AddMutationDefinition( // Not implemented
            "coherentplasma",
            "Coherent Plasma",
            7,
            HM_CAT_ARACHNOTRON,
            "Arachnotron projectiles bounce off of walls."
        );*/
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

