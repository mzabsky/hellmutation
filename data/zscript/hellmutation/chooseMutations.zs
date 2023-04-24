extend class HM_GlobalEventHandler
{
    int ChooseMutations()
    {
        let activeCategories = GetMutationCategoriesForCurrentLevel();

        console.printf("Active:");
        DictionaryIterator dictIt = DictionaryIterator.Create(ActiveMutations);
        while(dictIt.Next())
        {
            console.printf(dictIt.Key());
        }

        Array<HM_MutationDefinition> legalMutations;
        Array<HM_MutationDefinition> matchingMutations;
        for(let i = 0; i < MutationDefinitions.Size(); i++)
        {
            let currentMutation = MutationDefinitions[i];

            if(IsMutationActive(currentMutation.key))
            {
                console.printf("already active: %s", currentMutation.Key);
                continue;
            }

            legalMutations.Push(currentMutation);

            // There must be some overlap between the categories of mutation and the level
            // This indicates that the mutation applies to something that appears in the level
            if(!(currentMutation.Category & activeCategories))
            {
                //console.printf("Does not apply: %s %s", currentMutation.Key, MutationCategoryToString(currentMutation.Category));
                continue;
            }

            console.printf("Candidate mutation: %s %s", currentMutation.Key, MutationCategoryToString(currentMutation.Category));
            matchingMutations.Push(currentMutation);
        }

        // We will try to choose mutations that don't overlap
        Array<HM_MutationDefinition> chosenMutations;
        MutationCategory chosenCategories = 0;
        let numberOfMutationsToChoose = min(4, matchingMutations.Size());
        let i = 0;
        while(chosenMutations.Size() < numberOfMutationsToChoose)
        {
            i++;
            let candidateIndex = random[HM_GlobalEventHandler](0, matchingMutations.Size() - 1);
            let candidateMutation = matchingMutations[candidateIndex];

            // We try to choose mutations that don't overlap with the mutations chosen so far
            // But if we get stuck and can't find a mutation which would fit, just grab the first one that comes by
            if(!(chosenCategories & candidateMutation.Category) || i > 10)
            {
                bool alreadySelected;
                for(int j = 0; j < chosenMutations.Size(); j++)
                {
                    if(chosenMutations[j].Key == candidateMutation.Key)
                    {
                        alreadySelected = true;
                    }
                }

                if(alreadySelected)
                {
                    continue;
                }

                chosenMutations.Push(candidateMutation);
                chosenCategories |= candidateMutation.Category;
                console.printf("Chosen mutation: %s", candidateMutation.Key);
            }
        }

        console.printf("Finished %d", chosenMutations.Size());

        for(int i = 0; i < chosenMutations.Size(); i++)
        {
            ActiveMutations.Insert(chosenMutations[i].Key, "1");
            MutationRemovalsOnOffer.Push(chosenMutations[i].Key);
        }

        return chosenMutations.Size();
    }

    MutationCategory GetMutationCategoriesForCurrentLevel()
    {
        // These are always active
        MutationCategory activeCategories = HM_CAT_PLAYER |HM_CAT_ALLMONSTERS;

        // HM_CAT_DMGFLOOR
        for (let i = 0; i < Level.sectors.Size(); i++)
        {
            // One sector with damaging floor is enough
            if(Level.sectors[i].damageamount > 0)
            {
                activeCategories |= HM_CAT_DMGFLOOR;
            }
        }

        // current species categories, and barrels

        // Each category has to accumulate 100 points to activate
        Map<MutationCategory, int> categoryMap;
        let iterator = ThinkerIterator.Create("Actor");
        Actor current;
        while (current = Actor(iterator.Next()))
        {
            if(current is "ExplosiveBarrel") { categoryMap.Insert(HM_CAT_BARREL, categoryMap.Get(HM_CAT_BARREL) + 25); }

            if(!current.bIsMonster)
            {
                continue;
            }

            if(current is "ZombieMan") categoryMap.Insert(HM_CAT_ZOMBIEMAN, categoryMap.Get(HM_CAT_ZOMBIEMAN) + 20);
            else if(current is "ShotgunGuy") categoryMap.Insert(HM_CAT_SHOTGUNNER, categoryMap.Get(HM_CAT_SHOTGUNNER) + 20);
            else if(current is "ChaingunGuy") categoryMap.Insert(HM_CAT_CHAINGUNNER, categoryMap.Get(HM_CAT_CHAINGUNNER) + 35);
            else if(current is "DoomImp") categoryMap.Insert(HM_CAT_IMP, categoryMap.Get(HM_CAT_IMP) + 25);
            else if(current is "Demon") categoryMap.Insert(HM_CAT_PINKY, categoryMap.Get(HM_CAT_PINKY) + 25);
            else if(current is "Spectre") categoryMap.Insert(HM_CAT_PINKY, categoryMap.Get(HM_CAT_PINKY) + 25);
            else if(current is "Revenant") categoryMap.Insert(HM_CAT_REVENANT, categoryMap.Get(HM_CAT_REVENANT) + 35);
            else if(current is "Cacodemon") categoryMap.Insert(HM_CAT_CACODEMON, categoryMap.Get(HM_CAT_CACODEMON) + 50);
            else if(current is "LostSoul") categoryMap.Insert(HM_CAT_LOSTSOUL, categoryMap.Get(HM_CAT_LOSTSOUL) + 20);
            else if(current is "PainElemental") categoryMap.Insert(HM_CAT_PAINELEMENTAL, categoryMap.Get(HM_CAT_PAINELEMENTAL) + 100);
            else if(current is "HellKnight") categoryMap.Insert(HM_CAT_HELLKNIGHT, categoryMap.Get(HM_CAT_HELLKNIGHT) + 100);
            else if(current is "BaronOfHell") categoryMap.Insert(HM_CAT_BARONOFHELL, categoryMap.Get(HM_CAT_BARONOFHELL) + 100);
            else if(current is "Fatso") categoryMap.Insert(HM_CAT_MANCUBUS, categoryMap.Get(HM_CAT_MANCUBUS) + 100);
            else if(current is "ArchVile") categoryMap.Insert(HM_CAT_ARCHVILE, categoryMap.Get(HM_CAT_ARCHVILE) + 100);
            else if(current is "Arachnotron") categoryMap.Insert(HM_CAT_ARACHNOTRON, categoryMap.Get(HM_CAT_ARACHNOTRON) + 100);
            else if(current is "SpiderMastermind") categoryMap.Insert(HM_CAT_SPIDERMASTERMIND, categoryMap.Get(HM_CAT_SPIDERMASTERMIND) + 100);
            else if(current is "Cyberdemon") categoryMap.Insert(HM_CAT_CYBERDEMON, categoryMap.Get(HM_CAT_CYBERDEMON) + 100);
            else if(current is "BossBrain") categoryMap.Insert(HM_CAT_BOSSBRAIN, categoryMap.Get(HM_CAT_BOSSBRAIN) + 100);
        }

        MapIterator<MutationCategory, int> mapIt;
        mapIt.Init(categoryMap);

        
        while (mapIt.Next())
        {
            let currentCategory = mapIt.GetKey();
            let currentScore = mapIt.GetValue();

            if(currentScore >= 100)
            {
                activeCategories |= currentCategory;
            }

            console.printf("score %s => %d", MutationCategoryToString(currentCategory), currentScore);
        }

        console.printf("categories: %s", MutationCategoryToString(activeCategories));

        return activeCategories;
    }


    /*

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
        HM_CAT_PAINELEMENTAL = 1 << 11,
        HM_CAT_HELLKNIGHT = 1 << 12,
        HM_CAT_BARONOFHELL = 1 << 13,
        HM_CAT_MANCUBUS = 1 << 14,
        HM_CAT_ARCHVILE = 1 << 15,
        HM_CAT_ARACHNOTRON = 1 << 16,
        HM_CAT_SPIDERMASTERMIND = 1 << 17,
        HM_CAT_CYBERDEMON = 1 << 18,
        HM_CAT_BOSSBRAIN = 1 << 19
    };

    */


    string MutationCategoryToString(MutationCategory category)
    {
        if(category == 0)
        {
            return "0";
        }

        let str = "";
        if(category & HM_CAT_PLAYER) str.AppendFormat("|PLAYER");
        if(category & HM_CAT_DMGFLOOR) str.AppendFormat("|DMGFLOOR");
        if(category & HM_CAT_BARREL) str.AppendFormat("|BARREL");
        if(category & HM_CAT_ALLMONSTERS) str.AppendFormat("|ALLMONSTERS");
        if(category & HM_CAT_ZOMBIEMAN) str.AppendFormat("|ZOMBIEMAN");
        if(category & HM_CAT_SHOTGUNNER) str.AppendFormat("|SHOTGUNNER");
        if(category & HM_CAT_CHAINGUNNER) str.AppendFormat("|CHAINGUNNER");
        if(category & HM_CAT_IMP) str.AppendFormat("|IMP");
        if(category & HM_CAT_PINKY) str.AppendFormat("|PINKY");
        if(category & HM_CAT_REVENANT) str.AppendFormat("|REVENANT");
        if(category & HM_CAT_CACODEMON) str.AppendFormat("|CACODEMON");
        if(category & HM_CAT_LOSTSOUL) str.AppendFormat("|LOSTSOUL");
        if(category & HM_CAT_PAINELEMENTAL) str.AppendFormat("|PAINELEMENTAL");
        if(category & HM_CAT_HELLKNIGHT) str.AppendFormat("|HELLKNIGHT");
        if(category & HM_CAT_BARONOFHELL) str.AppendFormat("|BARONOFHELL");
        if(category & HM_CAT_MANCUBUS) str.AppendFormat("|MANCUBUS");
        if(category & HM_CAT_ARCHVILE) str.AppendFormat("|ARCHVILE");
        if(category & HM_CAT_ARACHNOTRON) str.AppendFormat("|ARACHNOTRON");
        if(category & HM_CAT_SPIDERMASTERMIND) str.AppendFormat("|SPIDERMASTERMIND");
        if(category & HM_CAT_CYBERDEMON) str.AppendFormat("|CYBERDEMON");
        if(category & HM_CAT_BOSSBRAIN) str.AppendFormat("|BOSSBRAIN");

        return str.Mid(1, str.Length() - 1); // Strip the initial "|"; 
    }
}
