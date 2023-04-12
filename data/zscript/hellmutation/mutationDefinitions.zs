class HM_MutationDefinition
{
    string Key;
    int MapNumber;
    string Name;
    string Description;
}

extend class HM_GlobalEventHandler
{
    void CreateMutationDefinitions() {
        // Level 0
        AddMutationDefinition(
            "stormtroopers",
            "Stormtroopers",
            0,
            "BASIC ZOMBIEMEN ARE SIGNIFICANTLY MORE ACCURATE."
        );

        AddMutationDefinition(
            "macropods",
            "Macropods",
            0,
            "PINKIES GAIN THE ABILITY TO POUNCE FROM A DISTANCE AND ACROSS GAPS."
        );

        AddMutationDefinition(
            "desecration",
            "Desecration",
            0,
            "IMPS WHO SCORE A HIT ON A PLAYER BECOME ARCH-IMPS."
        );

        AddMutationDefinition(
            "hyperfuel",
            "Hyper-Fuel",
            0,
            "ALL ROCKETS AND GUIDED ROCKETS FIRED BY MONSTERS ARE MUCH FASTER."
        );

        // Level 1
        AddMutationDefinition(
            "insomnia",
            "Insomnia",
            1,
            "MONSTERS DO NOT START THE LEVEL ASLEEP."
        );

        AddMutationDefinition(
            "promotion",
            "Promotion",
            1,
            "BASIC ZOMBIEMEN WHO SCORE A HIT ON A PLAYER BECOME SHOTGUNNERS."
        );

        AddMutationDefinition(
            "hematophagy",
            "Hematophagy",
            1,
            "Pinkies and their variants become fully healed whenever they deal damage."
        );

        AddMutationDefinition(
            "ego",
            "Ego",
            1,
            "Lost souls deal and take much more damage."
        );
        
        // Level 2
        AddMutationDefinition(
            "brightfire",
            "Brightfire",
            2,
            "IMPS AND THEIR VARIANTS ARE FASTER."
        );

        AddMutationDefinition(
            "decapitation",
            "Decapitation",
            2,
            "ZOMBIEMEN, SHOTGUNNERS, Chaingunners AND THEIR VARIANTS MAY SPAWN \nA LOST SOUL AFTER DYING, UNLESS GIBBED."
        );

        AddMutationDefinition(
            "hellscaress",
            "Hell's Caress",
            2,
            "Melee attacks of Imps, Revenants, Hell Knights, Barons of Hell \nand their  variants are much more powerful."
        );

        AddMutationDefinition(
            "cacoblasters",
            "Cacoblasters",
            2,
            "Cacodemons always fire two additional projectiles."
        );

        AddMutationDefinition(
            "adrenaline",
            "Adrenaline",
            3,
            "Zombiemen, Shotgunners and their variants are faster."
        );

        AddMutationDefinition(
            "slimeborne",
            "Slimeborne",
            3,
            "Player losing health to a damaging floor might cause Pinkies to spawn."
        );

        AddMutationDefinition(
            "sacrifice",
            "Sacrifice",
            3,
            "Arch-Viles and Arch-Imps redirect some of the damage they \nwould take to other nearby monsters."
        );

        AddMutationDefinition(
            "adipocytes",
            "Adipocytes",
            3,
            "Mancubuses and their variants have more health."
        );

       
        AddMutationDefinition(
            "barrage",
            "Barrage",
            4,
            "Imps fire three fireballs in a rapid barrage."
        );

       
        AddMutationDefinition(
            "ambushdeployment",
            "Ambush Deployment",
            4,
            "Chaingunners and their variants get a brief invulnerability\nshield when they first open fire."
        );
       
        AddMutationDefinition(
            "kleptomania",
            "Kleptomania",
            4,
            "Players lose all rockets and plasma ammo between levels."
        );
       
        AddMutationDefinition(
            "extremophilia",
            "Extremophilia",
            4,
            "Monsters recover some health each second on a damaging floor."
        );
    }
    
    private void AddMutationDefinition(string key, string name, int mapNumber, string description)
    {
        let mutationDefinition = new("HM_MutationDefinition");
        mutationDefinition.Key = key;
        mutationDefinition.Name = name;
        mutationDefinition.MapNumber = mapNumber;
        mutationDefinition.Description = description;
        MutationDefinitions.Push(mutationDefinition);
    }
}

