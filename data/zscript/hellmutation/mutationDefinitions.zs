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
            "Decapitation",
            "Decapitation",
            0,
            "FORMER HUMANS AND THEIR VARIANTS MAY SPAWN A LOST SOUL AFTER DYING,\nUNLESS GIBBED."
        );

        AddMutationDefinition(
            "Fiends",
            "Fiends",
            0,
            "IMPS AS WELL AS THEIR PROJECTILES ARE FASTER."
        );

        AddMutationDefinition(
            "Bloodlust",
            "Bloodlust",
            0,
            "PINKIES GAIN THE ABILITY TO POUNCE FROM DISTANCE AND ACROSS GAPS."
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

