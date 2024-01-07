extend class HM_GlobalEventHandler
{
    override void WorldUnloaded(WorldEvent e) 
    {
        //console.printf("WORLD UNLOADED MAP %d", MapNumber);

        MapNumber++;

        globalThinker.MapNumber = MapNumber;
        globalThinker.MutationStates = MutationStates;
        globalThinker.PerkStates = PerkStates;
                    console.printf("ITERATOR");

            DictionaryIterator dictIt = DictionaryIterator.Create(PerkStates);
            while(dictIt.Next())
            {
                console.printf(dictIt.Key());
            }

        // Still active mutations become active, and grant perk points
        for(let i = 0; i < Players.Size(); i++)
        {
            let player = Players[i].mo;
            if(player == null)
            {
                continue;
            }

            let offeredMutationCount = GetMutationRemovalOnOfferCount();
            for(let j = 0; j < offeredMutationCount; j++)
            {
                HM_Definition mutationDefinition;
                GetMutationRemovalOnOffer(j, mutationDefinition);
                if(IsMutationRemoved(mutationDefinition.Key))
                {
                    continue;
                }

                console.printf("Mutation became locked in %s", mutationDefinition.Key);

                player.GiveInventory('HM_LockedMutationCounter', 1);

                if(player.CountInv('HM_LockedMutationCounter') % 5 == 0)
                {
                    player.GiveInventory('HM_PerkPoint', 1);
                }
            }
        }
    }

}