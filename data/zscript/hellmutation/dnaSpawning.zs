class WeightedChoiceOption
{
    Actor Target;
    int Weight;
}

extend class HM_GlobalEventHandler
{
    WeightedChoiceOption WeightedRandomChoice(Array<WeightedChoiceOption> options)
    {
        if(options.Size() == 0)
        {
            return null;
        }

        int sum = 0;
        for(let i = 0; i < options.Size(); i++)
        {
            //console.printf("option %s %d", options[i].target.GetClassName(), sum);
            sum += options[i].Weight;
        }

        let roll = random[HM_GlobalEventHandler](0, sum - 1);
        //console.printf("roll %d %d", sum, roll);
        let sum2 = 0;
        for(let i = 0; i < options.Size(); i++)
        {
            if(roll < sum2 + options[i].Weight)
            {
                return options[i];
            }

            sum2 += options[i].Weight;
        }

        return options[options.Size() - 1];
    }

    void AddChoiceOption(Array<WeightedChoiceOption> options, Actor target, int weight)
    {
        WeightedChoiceOption option = new("WeightedChoiceOption");
        option.Target = target;
        option.Weight = weight;
        options.Push(option);
    }

    void SpawnDna()
    {
        let firstDnaPlace = FindPlaceForFirstDna();
        if(firstDnaPlace != null)
        {
            firstDnaPlace.Spawn("HM_Dna", firstDnaPlace.Vec3Offset(0, 0, 32), ALLOW_REPLACE);
            //console.printf("Spawned first DNA on a %s.", firstDnaPlace.GetClassName());
        }
        else
        {
            //console.printf("Could not find place to spawn first DNA.");
        }

        let secondDnaPlace = FindPlaceForSecondDna();
        if(secondDnaPlace != null)
        {
            secondDnaPlace.Spawn("HM_Dna", secondDnaPlace.Vec3Offset(0, 0, 32), ALLOW_REPLACE);
            //console.printf("Spawned second DNA on a %s.", secondDnaPlace.GetClassName());
        }
        else
        {
            //console.printf("Could not find place to spawn second DNA.");
        }

        let thirdDnaPlace = FindPlaceForThirdDna();
        if(thirdDnaPlace != null)
        {
            let thirdDna = thirdDnaPlace.Spawn("HM_Dna", thirdDnaPlace.Vec3Offset(0, 0, 0), ALLOW_REPLACE);
            thirdDna.bNoGravity = false; // Apply gravity to this DNA specifically (primarily for MAP02 where the cyberdemon spawns on a lowering platform)
            console.printf("Spawned third DNA on a %s.", thirdDnaPlace.GetClassName());
        }
        else
        {
            //console.printf("Could not find place to spawn third DNA.");
        }
    }


    Actor FindPlaceForFirstDna()
    {
        Array<WeightedChoiceOption> options;

        let finder = ThinkerIterator.Create("Inventory");
        Actor actor;
        while((actor = Actor(finder.next())) != null)
        {
            if(actor is 'Shotgun')
            {
                AddChoiceOption(options, actor, 1000);
            }
            else if(actor is 'SuperShotgun')
            {
                AddChoiceOption(options, actor, 700);
            }
            else if(actor is 'Chaingun')
            {
                AddChoiceOption(options, actor, 400);
            }
            else if(actor is 'GreenArmor')
            {
                AddChoiceOption(options, actor, 100);
            }
            else if(actor is 'GreenArmor')
            {
                AddChoiceOption(options, actor, 100);
            }
            else if(actor is 'Medikit')
            {
                AddChoiceOption(options, actor, 20);
            }
            else if(actor is 'Stimpack')
            {
                AddChoiceOption(options, actor, 20);
            }
            else if(actor is 'HealthBonus')
            {
                AddChoiceOption(options, actor, 1);
            }
            else if(actor is 'ArmorBonus')
            {
                AddChoiceOption(options, actor, 1);
            }
            else if(actor is 'YellowCard' || actor is 'RedCard' || actor is 'BlueCard' || actor is 'YellowSkull' || actor is 'RedSkull' || actor is 'BlueSkull')
            {
                AddChoiceOption(options, actor, 1);
            }
        }

        let rolledChoice = WeightedRandomChoice(options);
        if(!rolledChoice)
        {
            return null;
        }

        return rolledChoice.Target;
    }

    Actor FindPlaceForSecondDna()
    {
        Array<WeightedChoiceOption> options;

        let finder = ThinkerIterator.Create("Inventory");
        Actor actor;
        while((actor = Actor(finder.next())) != null)
        {
            if(actor is 'Megasphere')
            {
                AddChoiceOption(options, actor, 1000);
            }
            else if(actor is 'Soulsphere')
            {
                AddChoiceOption(options, actor, 500);
            }
            else if(actor is 'BlueArmor')
            {
                AddChoiceOption(options, actor, 250);
            }
            else if(actor is 'Backpack')
            {
                AddChoiceOption(options, actor, 350);
            }
            else if(actor is 'BFG9000')
            {
                AddChoiceOption(options, actor, 50);
            }
            else if(actor is 'PlasmaRifle')
            {
                AddChoiceOption(options, actor, 10);
            }
            else if(actor is 'RocketLauncher')
            {
                AddChoiceOption(options, actor, 10);
            }
            else if(actor is 'YellowCard' || actor is 'RedCard' || actor is 'BlueCard' || actor is 'YellowSkull' || actor is 'RedSkull' || actor is 'BlueSkull')
            {
                AddChoiceOption(options, actor, 1);
            }
        }

        let rolledChoice = WeightedRandomChoice(options);
        if(!rolledChoice)
        {
            return null;
        }

        return rolledChoice.Target;
    }

    private Actor FindPlaceForThirdDna()
    {
        Array<WeightedChoiceOption> options;

        let finder = ThinkerIterator.Create("Actor");
        Actor actor;
        while((actor = Actor(finder.next())) != null)
        {
            if(actor is 'Cyberdemon')
            {
                AddChoiceOption(options, actor, 1000);
            }
            else if(actor is 'SpiderMastermind')
            {
                AddChoiceOption(options, actor, 1000);
            }
        }

        let rolledChoice = WeightedRandomChoice(options);
        if(!rolledChoice)
        {
            return null;
        }

        return rolledChoice.Target;
    }
}