extend class HM_GlobalEventHandler
{
    int ChooseMutations()
    {
        Array<HM_Definition> chosenOptions;
        ChooseByCategories(MutationDefinitions, 4, "mutation", chosenOptions);

        for(int i = 0; i < chosenOptions.Size(); i++)
        {
            MutationStates.Insert(chosenOptions[i].Key, "Active");
            MutationRemovalsOnOffer.Push(chosenOptions[i].Key);
        }

        return chosenOptions.Size();
    }

    int ChoosePerks()
    {
        Array<HM_Definition> chosenOptions;
        ChooseByCategories(PerkDefinitions, 3, "perk", chosenOptions);

        for(int i = 0; i < chosenOptions.Size(); i++)
        {
            //PerkStates.Insert(chosenOptions[i].Key, "Active");
            PerksOnOffer.Push(chosenOptions[i].Key);
            PerkStates.Insert(chosenOptions[i].Key, "Offered");
        }

        return chosenOptions.Size();
    }

    int ChooseByCategories(Array<HM_Definition> options, int numberOfOptionsToChoose, string optionLabel, Array<HM_Definition> chosenOptions)
    {
        let activeCategories = GetCategoriesForCurrentLevel();

        /*console.printf("Active:");
        DictionaryIterator dictIt = DictionaryIterator.Create(ActiveMutations);
        while(dictIt.Next())
        {
            console.printf(dictIt.Key());
        }*/

        // These are mutations/perks which do not break anything and are therefore technically allowed to be selected
        // Not breaking anything means that they are appropriate for the currenct IWAD (Doom vs. Doom 2)
        // and that they are not already active (from previous levels).
        Array<HM_Definition> legalOptions;

        // "Appropriate" mutations/perks are those that modify something that appears in the current level.
        Array<HM_Definition> appropriateOptions;
        for(let i = 0; i < options.Size(); i++)
        {
            let currentOption = options[i];

            if(currentOption.Category & HM_CAT_DOOM2 > 0 && !hasDoom2)
            {
                continue;
            }

            if(currentOption.Category & HM_CAT_NOFIRSTMAP > 0 && mapNumber == 0)
            {
                continue;
            }

            if(IsMutationActive(currentOption.key))
            {
                continue;
            }

            legalOptions.Push(currentOption);

            // We generally don't want to see mutations/perks which were already removed before all the possibilities are exhausted
            // But there should be a small chance that a removed mutation/perk is offered again still, to make things
            // a bit less predictable
            if(IsMutationRemoved(currentOption.key) && random[HM_GlobalEventHandler](0, 4) > 0)
            {
                console.printf("Rejected already picked %s: %s, Current chosen categories: %s", optionLabel, currentOption.key, CategoryToString(activeCategories));
                continue;
            }

            if(!(currentOption.Category & activeCategories))
            {
                // Does not apply to anything in the current level
                console.printf("Rejected not applicable %s: %s", optionLabel, currentOption.key, CategoryToString(activeCategories));
                continue;
            }

            appropriateOptions.Push(currentOption);
        }

        // We will try to choose mutations that don't overlap
        HM_Category chosenCategories = 0;
        numberOfOptionsToChoose = min(numberOfOptionsToChoose, appropriateOptions.Size());
        let i = 0;
        while(chosenOptions.Size() < numberOfOptionsToChoose)
        {
            i++;

            HM_Definition candidateOption;

            // This value determines how rigid the selection algorithm is.
            // First phase is when we try to choose non-overlapping options that match the level's conditions.
            // Second phase is when we loosen those conditions and allow overlaps and options that don't specifically apply to the level.
            // This number determines how many iterations are spent in the first phase.
            // Higher number means we try harder to find a nice set of matching mutations, but especially for levels with small set of matching
            // options (eg. MAP01) this will cause more predictable results.
            let firstPhaseStepCount = 12;
            if(i < firstPhaseStepCount) 
            {
                // We are in the initial stage of mutation selection - try to choose mutations which:
                // - Are appropriate for the level (reflect features/monsters of the level)
                // - Offer variety (do not overlap each other)
                let candidateIndex = random[HM_GlobalEventHandler](0, appropriateOptions.Size() - 1);
                candidateOption = appropriateOptions[candidateIndex];
                if(chosenCategories & candidateOption.Category)
                {
                    // Overlaps already selected mutations -> discard
                    
                    console.printf("#%d Rejected %s because of overlap: %s, current categories: %s", i, optionLabel, candidateOption.key, CategoryToString(chosenCategories));
                    continue;
                }
            }
            else if (i > 250)
            {
                console.printf("#%d Algorithm for selection of %ss is stuck! Aborting.", i, optionLabel);
            }
            else
            {
                // We are in second phase - we have given chance to select the appropriate options and couldn't manage to select
                // a nice set. Now just pick something that will work from all the legal mutations.
                let candidateIndex = random[HM_GlobalEventHandler](0, legalOptions.Size() - 1);
                candidateOption = legalOptions[candidateIndex];
            }

            // Undery any circumstances, no mutation can be selected twice
            bool alreadySelected;
            for(int j = 0; j < chosenOptions.Size(); j++)
            {
                if(chosenOptions[j].Key == candidateOption.Key)
                {
                    alreadySelected = true;
                }
            }

            if(alreadySelected)
            {
                console.printf("#%d Rejected already selected %s: %s", i, optionLabel, candidateOption.key);
                continue;
            }

            //console.printf("Chosen categories before: %s", HM_CategoryToString(chosenCategories));
            
            chosenCategories = (chosenCategories | candidateOption.Category)
                & ~(HM_CAT_DOOM2 | HM_CAT_NOFIRSTMAP); // These categories don't count as overlaps

            console.printf("#%d Accepted %s: %s, Current accepted categories: %s", i, optionLabel, candidateOption.Key, CategoryToString(chosenCategories));

            chosenOptions.Push(candidateOption);
        }

        return chosenOptions.Size();
    }

    HM_Category GetCategoriesForCurrentLevel()
    {
        // These are always active
        HM_Category activeCategories = HM_CAT_PLAYER | HM_CAT_ALLMONSTERS | HM_CAT_PISTOL | HM_CAT_FIST;

        // Does the sector have a damaging floor?
        for (let i = 0; i < Level.sectors.Size(); i++)
        {
            // One sector with damaging floor is enough
            if(Level.sectors[i].damageamount > 0)
            {
                activeCategories |= HM_CAT_DMGFLOOR;
            }
        }

        // Currently held weapon (weapon has to be either held or appear in the level)
        for(let i = 0; i < Players.Size(); i++)
        {
            let player = Players[i].mo;
            if(player == null)
            {
                continue;
            }

            if(player.FindInventory('Shotgun') != null) activeCategories |= HM_CAT_SHOTGUN;
            if(player.FindInventory('SuperShotgun') != null) activeCategories |= HM_CAT_SUPERSHOTGUN;
            if(player.FindInventory('Chaingun') != null) activeCategories |= HM_CAT_CHAINGUN;
            if(player.FindInventory('RocketLauncher') != null) activeCategories |= HM_CAT_ROCKETLAUNCHER;
            if(player.FindInventory('PlasmaRifle') != null) activeCategories |= HM_CAT_PLASMAGUN;
            if(player.FindInventory('Bfg9000') != null) activeCategories |= HM_CAT_BFG;
        }

        // current species categories, and barrels

        // Each actor category has to accumulate 100 points to activate (to prevent a single imp from making irrelevant imp categories appear)
        Map<HM_Category, int> categoryMap;
        let iterator = ThinkerIterator.Create("Actor");
        Actor current;
        while (current = Actor(iterator.Next()))
        {
            if(current is "ExplosiveBarrel") { categoryMap.Insert(HM_CAT_BARREL, categoryMap.Get(HM_CAT_BARREL) + 25); }

            else if(current is "Shotgun") categoryMap.Insert(HM_CAT_SHOTGUN, categoryMap.Get(HM_CAT_SHOTGUN) + 100);
            else if(current is "SuperShotgun") categoryMap.Insert(HM_CAT_SUPERSHOTGUN, categoryMap.Get(HM_CAT_SUPERSHOTGUN) + 100);
            else if(current is "Chaingun") categoryMap.Insert(HM_CAT_CHAINGUN, categoryMap.Get(HM_CAT_CHAINGUN) + 100);
            else if(current is "RocketLauncher") categoryMap.Insert(HM_CAT_ROCKETLAUNCHER, categoryMap.Get(HM_CAT_ROCKETLAUNCHER) + 100);
            else if(current is "PlasmaRifle") categoryMap.Insert(HM_CAT_PLASMAGUN, categoryMap.Get(HM_CAT_PLASMAGUN) + 100);
            else if(current is "Bfg9000") categoryMap.Insert(HM_CAT_BFG, categoryMap.Get(HM_CAT_BFG) + 100);

            else if(current is "ZombieMan") categoryMap.Insert(HM_CAT_ZOMBIEMAN, categoryMap.Get(HM_CAT_ZOMBIEMAN) + 20);
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

        MapIterator<HM_Category, int> mapIt;
        mapIt.Init(categoryMap);

        while (mapIt.Next())
        {
            let currentCategory = mapIt.GetKey();
            let currentScore = mapIt.GetValue();

            if(currentScore >= 100)
            {
                activeCategories |= currentCategory;
            }

            //console.printf("score %s => %d", HM_CategoryToString(currentCategory), currentScore);
        }

        console.printf("Categories for map: %s", CategoryToString(activeCategories));

        return activeCategories;
    }

    string CategoryToString(HM_Category category)
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
        if(category & HM_CAT_FIST) str.AppendFormat("|FIST");
        if(category & HM_CAT_PISTOL) str.AppendFormat("|PISTOL");
        if(category & HM_CAT_SHOTGUN) str.AppendFormat("|SHOTGUN");
        if(category & HM_CAT_SUPERSHOTGUN) str.AppendFormat("|SUPERSHOTGUN");
        if(category & HM_CAT_CHAINGUN) str.AppendFormat("|CHAINGUN");
        if(category & HM_CAT_ROCKETLAUNCHER) str.AppendFormat("|ROCKETLAUNCHER");
        if(category & HM_CAT_PLASMAGUN) str.AppendFormat("|PLASMAGUN");
        if(category & HM_CAT_BFG) str.AppendFormat("|BFG");
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
