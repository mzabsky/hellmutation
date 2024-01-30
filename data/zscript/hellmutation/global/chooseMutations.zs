extend class HM_GlobalEventHandler
{
    int ChooseMutations()
    {
        // Mutations which are already removed can never be offered for removal
        Array<string> blockedOptionKeys;
        DictionaryIterator dictIt = DictionaryIterator.Create(MutationStates);
        while(dictIt.Next())
        {
            if(dictIt.Value() == "Removed")
            {
                blockedOptionKeys.Push(dictIt.Key());
            }
        }

        Array<HM_Definition> chosenOptions;
        let numberOfMutationsToChoose = 4;
        if(IsMutationActive("geneticinstability") && random[HM_GlobalEventHandler](1, 2) == 1)
        {
            numberOfMutationsToChoose++;
        }

        ChooseByCategories(MutationDefinitions, numberOfMutationsToChoose, "mutation", blockedOptionKeys, chosenOptions);

        for(int i = 0; i < chosenOptions.Size(); i++)
        {
            MutationStates.Insert(chosenOptions[i].Key, "Active");
            MutationRemovalsOnOffer.Push(chosenOptions[i].Key);
        }

        ApplyMutationMetaLocks();

        return chosenOptions.Size();
    }

    int ChoosePerks()
    {
        // Perks which are already active can never be offered for gaining
        Array<string> blockedOptionKeys;
        DictionaryIterator dictIt = DictionaryIterator.Create(PerkStates);
        while(dictIt.Next())
        {
            if(dictIt.Value() == "Active")
            {
                blockedOptionKeys.Push(dictIt.Key());
                //console.printf("blocked perk %s", dictIt.Key());
            }
        }

        Array<HM_Definition> chosenOptions;
        ChooseByCategories(PerkDefinitions, 3, "perk", blockedOptionKeys, chosenOptions);

        for(int i = 0; i < chosenOptions.Size(); i++)
        {
            //PerkStates.Insert(chosenOptions[i].Key, "Active");
            PerksOnOffer.Push(chosenOptions[i].Key);
            PerkStates.Insert(chosenOptions[i].Key, "Offered");
        }

        return chosenOptions.Size();
    }

    int ChooseByCategories(Array<HM_Definition> options, int numberOfOptionsToChoose, string optionLabel, Array<string> blockedOptionKeys, Array<HM_Definition> chosenOptions)
    {
        Array<HM_Category> activeCategories;
        GetCategoriesForCurrentLevel(activeCategories);

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

            if(HasCategory(currentOption.Categories, HM_CAT_DOOM2) && !hasDoom2)
            {
                continue;
            }

            if(HasCategory(currentOption.Categories, HM_CAT_NOFIRSTMAP) && mapNumber == 0)
            {
                continue;
            }

            // Mutations that are already removed/perks that are already active are not legal
            if(blockedOptionKeys.Find(currentOption.key) != blockedOptionKeys.Size())
            {    
                continue;
            }

            legalOptions.Push(currentOption);

            // We generally don't want to see mutations/perks which were already removed before all the possibilities are exhausted
            // But there should be a small chance that a removed mutation/perk is offered again still, to make things
            // a bit less predictable
            if(IsMutationRemoved(currentOption.key) && random[HM_GlobalEventHandler](0, 4) > 0) // TODO: Make applicable to perks
            {
                console.printf("Rejected already picked %s: %s, Current chosen categories: %s", optionLabel, currentOption.key, CategoriesToString(activeCategories));
                continue;
            }

            if(!AreCategoriesOverlapping(activeCategories, currentOption.Categories))
            {
                // Does not apply to anything in the current level
                console.printf("Rejected not applicable %s: %s", optionLabel, currentOption.key);
                continue;
            }

            appropriateOptions.Push(currentOption);
        }

        // We will try to choose mutations that don't overlap
        Array<HM_Category> chosenCategories;
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
                if(AreCategoriesOverlapping(chosenCategories, candidateOption.Categories))
                {
                    // Overlaps already selected mutations -> discard
                    
                    console.printf("#%d Rejected %s because of overlap: %s, current categories: %s, candidate categories: %s", i, optionLabel, candidateOption.key, CategoriesToString(chosenCategories), CategoriesToString(candidateOption.Categories));
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

            //console.printf("Chosen categories before: %s", HM_CategoriesToString(chosenCategories));
            
            // Accumulate the categories to detect overlaps
            MergeInCategories(chosenCategories, candidateOption.Categories);

            //chosenCategories = (chosenCategories | candidateOption.Category)
            //    & ~(HM_CAT_DOOM2 | HM_CAT_NOFIRSTMAP); // These categories don't count as overlaps

            console.printf("#%d Accepted %s: %s, Current accepted categories: %s", i, optionLabel, candidateOption.Key, CategoriesToString(chosenCategories));

            chosenOptions.Push(candidateOption);
        }

        return chosenOptions.Size();
    }

    void GetCategoriesForCurrentLevel(Array<HM_Category> activeCategories)
    {
        // These are always active
        activeCategories.Push(HM_CAT_META);
        activeCategories.Push(HM_CAT_PLAYER);
        activeCategories.Push(HM_CAT_HEALTH);
        activeCategories.Push(HM_CAT_ARMOR);
        activeCategories.Push(HM_CAT_AMMO);

        activeCategories.Push(HM_CAT_FIST);
        activeCategories.Push(HM_CAT_PISTOL);
        
        activeCategories.Push(HM_CAT_ALLMONSTERS);

        // Does the sector have a damaging floor?
        for (let i = 0; i < Level.sectors.Size(); i++)
        {
            // One sector with damaging floor is enough
            if(Level.sectors[i].damageamount > 0)
            {
                activeCategories.Push(HM_CAT_DMGFLOOR);
                break;
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

            if(player.FindInventory('Shotgun') != null) activeCategories.Push(HM_CAT_SHOTGUN);
            if(player.FindInventory('SuperShotgun') != null) activeCategories.Push(HM_CAT_SUPERSHOTGUN);
            if(player.FindInventory('Chaingun') != null) activeCategories.Push(HM_CAT_CHAINGUN);
            if(player.FindInventory('RocketLauncher') != null) activeCategories.Push(HM_CAT_ROCKETLAUNCHER);
            if(player.FindInventory('PlasmaRifle') != null) activeCategories.Push(HM_CAT_PLASMAGUN);
            if(player.FindInventory('Bfg9000') != null) activeCategories.Push(HM_CAT_BFG);
        }

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
            
            else if(current is "BlurSphere") categoryMap.Insert(HM_CAT_BLURSPHERE, categoryMap.Get(HM_CAT_BLURSPHERE) + 100);
            else if(current is "SoulSphere") categoryMap.Insert(HM_CAT_SOULSPHERE, categoryMap.Get(HM_CAT_SOULSPHERE) + 100);
            else if(current is "MegaSphere") categoryMap.Insert(HM_CAT_MEGASPHERE, categoryMap.Get(HM_CAT_MEGASPHERE) + 100);
            else if(current is "Backpack") categoryMap.Insert(HM_CAT_BACKPACK, categoryMap.Get(HM_CAT_BACKPACK) + 100);
            else if(current is "Berserk") categoryMap.Insert(HM_CAT_BERSERK, categoryMap.Get(HM_CAT_BERSERK) + 100);
            else if(current is "RadSuit") categoryMap.Insert(HM_CAT_RADSUIT, categoryMap.Get(HM_CAT_RADSUIT) + 100);
            
            else if(current is "RedCard" || current is "BlueCard" || current is "YellowCard" || current is "RedSkull" || current is "BlueSkull" || current is "YellowSkull") categoryMap.Insert(HM_CAT_KEY, categoryMap.Get(HM_CAT_KEY) + 100);
        }

        MapIterator<HM_Category, int> mapIt;
        mapIt.Init(categoryMap);

        while (mapIt.Next())
        {
            let currentCategory = mapIt.GetKey();
            let currentScore = mapIt.GetValue();

            if(currentScore >= 100)
            {
                activeCategories.Push(currentCategory);
            }

            console.printf("score %d => %d", currentCategory, currentScore);
        }

        console.printf("Categories for map: %s", CategoriesToString(activeCategories));
    }

    void ApplyMutationMetaLocks()
    {
        // Metamutations - each newly active mutation has 20% chance to become locked
        for(let i = 0; i < MutationRemovalsOnOffer.Size(); i++)
        {
            if(IsMutationActive("metamutation") && random[HM_GlobalEventHandler](0, 5) == 0)
            {
                MetaLockedMutations.Push(MutationRemovalsOnOffer[i]);
            }
        }
    }
}
