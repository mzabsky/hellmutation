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
            "Stormtroopers",
            "Stormtroopers",
            0,
            "BASIC ZOMBIEMEN ARE SIGNIFICANTLY MORE ACCURATE SHOTS."
        );

        AddMutationDefinition(
            "Macropods",
            "Macropods",
            0,
            "PINKIES GAIN THE ABILITY TO POUNCE FROM A DISTANCE AND ACROSS GAPS."
        );

        AddMutationDefinition(
            "Desecration",
            "Desecration",
            0,
            "IMPS WHO SCORE A HIT ON A PLAYER BECOME ARCH-IMPS."
        );

        AddMutationDefinition(
            "HyperFuel",
            "Hyper-Fuel",
            0,
            "ALL ROCKETS (INCLUDING GUIDED ROCKETS) FIRED BY MONSTERS ARE MUCH FASTER."
        );

        // Level 1
        AddMutationDefinition(
            "Insomnia",
            "Insomnia",
            1,
            "MONSTERS DO NOT START THE LEVEL ASLEEP."
        );

        AddMutationDefinition( // Not implemented
            "Promotion",
            "Promotion",
            1,
            "BASIC ZOMBIEMEN WHO SCORE A HIT ON A PLAYER BECOME SHOTGUNNERS."
        );

        AddMutationDefinition(
            "Hematophagy",
            "Hematophagy",
            1,
            "Pinkies and their variants become fully healed whenever they deal damage."
        );

        AddMutationDefinition(
            "Ego",
            "Ego",
            1,
            "Lost souls deal and take much more damage."
        );
        
        // Level 2
        AddMutationDefinition( // Not implemented
            "Fiends",
            "Fiends",
            2,
            "IMPS, THEIR VARIANTS AS WELL AS THEIR PROJECTILES ARE FASTER."
        );

        AddMutationDefinition( // Not implemented
            "Decapitation",
            "Decapitation",
            2,
            "ZOMBIEMEN, SHOTGUNNERS AND THEIR VARIANTS MAY SPAWN A LOST SOUL AFTER DYING,\nUNLESS GIBBED."
        );

        AddMutationDefinition( // Not implemented
            "Claws",
            "Claws",
            2,
            "Melee attacks of Imps, Revenants, Hell Knights, Barons of Hell and their\nvariants are much more powerful."
        );

        AddMutationDefinition( // Not implemented
            "Cacoblasters",
            "Cacoblasters",
            2,
            "Cacodemons always fire two additional projectiles."
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

