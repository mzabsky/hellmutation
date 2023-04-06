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
        AddMutationDefinition(
            "Stormtroopers",
            "Stormtroopers",
            0,
            "BASIC ZOMBIEMEN ARE SIGNIFICANTLY MORE ACCURATE SHOTS."
        );

        AddMutationDefinition(
            "Fiends",
            "Fiends",
            0,
            "IMPS, THEIR VARIANTS AS WELL AS THEIR PROJECTILES ARE FASTER."
        );

        AddMutationDefinition(
            "Bloodlust",
            "Bloodlust",
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
            "Decapitation",
            "Decapitation",
            1,
            "FORMER HUMANS AND THEIR VARIANTS MAY SPAWN A LOST SOUL AFTER DYING,\nUNLESS GIBBED."
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

