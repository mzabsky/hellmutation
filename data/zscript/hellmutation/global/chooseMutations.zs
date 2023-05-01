extend class HM_GlobalEventHandler
{
    int ChooseMutations()
    {
        let activeCategories = GetMutationCategoriesForCurrentLevel();

        /*console.printf("Active:");
        DictionaryIterator dictIt = DictionaryIterator.Create(ActiveMutations);
        while(dictIt.Next())
        {
            console.printf(dictIt.Key());
        }*/

        // These are mutations which do not break anything and are therefore technically allowed to be selected
        // Not breaking anything means that they are appropriate for the currenct IWAD (Doom vs. Doom 2)
        // and that they are not already active (from previous levels).
        Array<HM_MutationDefinition> legalMutations;

        // "Appropriate" mutations are those that modify something that appears in the current level.
        Array<HM_MutationDefinition> appropriateMutations;
        for(let i = 0; i < MutationDefinitions.Size(); i++)
        {
            let currentMutation = MutationDefinitions[i];

            if(currentMutation.Category & HM_CAT_DOOM2 > 0 && !hasDoom2)
            {
                continue;
            }

            if(currentMutation.Category & HM_CAT_NOFIRSTMAP > 0 && mapNumber == 0)
            {
                continue;
            }

            if(IsMutationActive(currentMutation.key))
            {
                continue;
            }

            legalMutations.Push(currentMutation);

            // We generally don't want to see mutations which were already removed before all the options are exhausted
            // But there should be a small chance that a removed mutation is offered again still, to make things
            // a bit less predictable
            if(IsMutationRemoved(currentMutation.key) && random[HM_GlobalEventHandler](0, 4) > 0)
            {
                continue;
            }

            if(!(currentMutation.Category & activeCategories))
            {
                // Does not apply to anything in the current level
                continue;
            }

            appropriateMutations.Push(currentMutation);
        }

        // We will try to choose mutations that don't overlap
        Array<HM_MutationDefinition> chosenMutations;
        MutationCategory chosenCategories = 0;
        let numberOfMutationsToChoose = min(4, appropriateMutations.Size());
        let i = 0;
        while(chosenMutations.Size() < numberOfMutationsToChoose)
        {
            i++;

            HM_MutationDefinition candidateMutation;
            if(i < 8)
            {
                // We are in the initial stage of mutation selection - try to choose mutations which:
                // - Are appropriate for the level (reflect features/monsters of the level)
                // - Offer variety (do not overlap each other)
                let candidateIndex = random[HM_GlobalEventHandler](0, appropriateMutations.Size() - 1);
                candidateMutation = appropriateMutations[candidateIndex];
                if(chosenCategories & candidateMutation.Category)
                {
                    // Overlaps already selected mutations -> discard
                    continue;
                }
            }
            else
            {
                // We have given chance to select the appropriate mutations and couldn't manage to select
                // a nice set. Now just pick something that will work from all the legal mutations.
                let candidateIndex = random[HM_GlobalEventHandler](0, legalMutations.Size() - 1);
                candidateMutation = legalMutations[candidateIndex];
            }

            // Undery any circumstances, no mutation can be selected twice
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
            
            chosenCategories |= candidateMutation.Category;
            chosenMutations.Push(candidateMutation);
        }

        for(int i = 0; i < chosenMutations.Size(); i++)
        {
            MutationStates.Insert(chosenMutations[i].Key, "Active");
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

            //console.printf("score %s => %d", MutationCategoryToString(currentCategory), currentScore);
        }

        //console.printf("categories: %s", MutationCategoryToString(activeCategories));

        return activeCategories;
    }

    string MutationCategoryToString(MutationCategory category)
    {
        if(category == 0)
        {
            return "0";
        }

        let str = "";
        if(category & HM_CAT_DOOM2) str.AppendFormat("|DOOM2");
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
