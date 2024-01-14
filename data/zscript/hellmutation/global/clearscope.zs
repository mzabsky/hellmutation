// Clearscope methods which can be called from both the UI and the game logic
extend class HM_GlobalEventHandler
{
    clearscope bool IsMutationRemoved(string mutationName)
    {
        let foundValue = MutationStates.At(mutationName.MakeLower());
        let isRemoved = foundValue == "Removed";

        //console.printf("IS MUTATION REMOVED %s %i", mutationName, isRemoved);
        return isRemoved;
    }
    
    clearscope bool IsMutationActive(string mutationName)
    {
        let foundValue = MutationStates.At(mutationName.MakeLower());
        let isActive = foundValue == "Active";

        //console.printf("IS MUTATION ACTIVE %s %i", mutationName, isActive);
        return isActive;
    }

    clearscope void GetMutationRemovalOnOffer(int index, out HM_Definition mutationDefinition) const
    {
        let mutationKey = MutationRemovalsOnOffer[index];
        for(let i = 0; i < MutationDefinitions.Size(); i++)
        {
            let currentMutationDefinition = MutationDefinitions[i];
            if(currentMutationDefinition.Key == mutationKey)
            {
                mutationDefinition = currentMutationDefinition;
                return;
            }
        }
    }

    clearscope int GetMutationRemovalOnOfferCount() const
    {
        return MutationRemovalsOnOffer.Size();
    }
    
    clearscope int GetMutationDefinitionCount() const
    {
        return MutationDefinitions.Size();
    }
    
    clearscope int GetActiveMutationDefinitionCount() const
    {
        let activeCount = 0;
        for(int i = 0; i < MutationDefinitions.Size(); i++)
        {
            if(IsMutationActive(MutationDefinitions[i].Key))
            {
                activeCount++;
            }
        }
        return activeCount;
    }

    clearscope void GetMutationDefinition(int index, out HM_Definition mutationDefinition) const
    {
        mutationDefinition = MutationDefinitions[index];
    }

    clearscope bool CanMutationBeRemoved(string mutationKey)
    {
        for(let i = 0; i < MutationRemovalsOnOffer.Size(); i++)
        {
            if(mutationKey == MutationRemovalsOnOffer[i])
            {
                return true;
            }
        }

        return false;
    }
    
    clearscope bool IsPerkActive(string perkName)
    {
        let foundValue = PerkStates.At(perkName.MakeLower());
        let isActive = foundValue == "Active";

        return isActive;
    }

    clearscope void GetPerkOnOffer(int index, out HM_Definition perkDefinition) const
    {
        let mutationKey = PerksOnOffer[index];
        for(let i = 0; i < PerkDefinitions.Size(); i++)
        {
            let currentPerkDefinition = PerkDefinitions[i];
            if(currentPerkDefinition.Key == mutationKey)
            {
                perkDefinition = currentPerkDefinition;
                return;
            }
        }
    }

    clearscope int GetPerksOnOfferCount() const
    {
        return PerksOnOffer.Size();
    }
    
    clearscope int GetPerkDefinitionCount() const
    {
        return PerkDefinitions.Size();
    }
    
    clearscope int GetActivePerkDefinitionCount() const
    {
        let activeCount = 0;
        for(int i = 0; i < PerkDefinitions.Size(); i++)
        {
            if(IsPerkActive(PerkDefinitions[i].Key))
            {
                activeCount++;
            }
        }
        return activeCount;
    }

    clearscope void GetPerkDefinition(int index, out HM_Definition perkDefinition) const
    {
        perkDefinition = PerkDefinitions[index];
    }

    clearscope bool CanPerkBeGained(string perkKey)
    {
        for(let i = 0; i < PerksOnOffer.Size(); i++)
        {
            if(perkKey == PerksOnOffer[i])
            {
                return true;
            }
        }

        return false;
    }



    clearscope string GetKeyForKeybind(string keybind) 
    {
        Array<int> keyInts;
        Bindings.GetAllKeysForCommand(keyInts, keybind);
        if (keyInts.Size() == 0)
            return string.Format("[%s]", keybind);
        return Bindings.NameAllKeys(keyInts);
    }
}