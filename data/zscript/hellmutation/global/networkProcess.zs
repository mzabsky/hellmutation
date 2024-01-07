extend class HM_GlobalEventHandler
{
    override void NetworkProcess(consoleevent e)
    {
        let commandName = e.name.MakeLower();
        if (commandName == "hm_dnamenu")
        {
            if(e.player == consoleplayer)
            {
                Menu.SetMenu("HM_DnaMenu");
            }
        }
        else if (commandName == "hm_mutationmenu")
        {
            if(e.player == consoleplayer)
            {
                Menu.SetMenu("HM_MutationMenu");
            }
        }
        else if (commandName == "hm_chooseperkmenu")
        {
            if(e.player == consoleplayer)
            {
                Menu.SetMenu("HM_ChoosePerkMenu");
            }
        }
        else if (commandName == "hm_perksmenu")
        {
            if(e.player == consoleplayer)
            {
                Menu.SetMenu("HM_PerksMenu");
            }
        }
        else if (commandName == "hm_addall")
        {
            for(let i = 0; i < MutationDefinitions.Size(); i++)
            {
                MutationStates.Insert(MutationDefinitions[i].Key, "Active");
            }
        }
        else if (commandName == "hm_clear")
        {
            for(let i = 0; i < MutationDefinitions.Size(); i++)
            {
                MutationStates.Insert(MutationDefinitions[i].Key, "None");
            }
        }
        else if (commandName.IndexOf("hm_remove:") >= 0) // sent by DNA menu
        {
            Array <String> parts;
			commandName.split(parts, ":");

            let playerNumber = e.args[0];
            let mutationKey = parts[1];

            if(IsMutationActive(mutationKey))
            {
                console.printf("%s removed mutation %s", players[playerNumber].GetUserName(), mutationKey);
                MutationStates.Insert(mutationKey, "Removed");

                let playerPawn = players[playerNumber].mo;
                playerPawn.TakeInventory("HM_Dna", 1);

                for (let i = 0; i < players.Size(); i++)
                {
                    if (players[i].mo != null)
                    {
                        players[i].mo.ACS_NamedExecute("hm_mutationremoved");
                    }
                }
            }
            else
            {
                console.printf("%s is not an active mutation.", mutationKey);
            }
        }
        else if (commandName.IndexOf("hm_add:") >= 0)
        {
            Array <String> parts;
            commandName.split(parts, ":");

            let mutationKey = parts[1];

            bool found = false;
            for(let i = 0; i < MutationDefinitions.Size(); i++)
            {
                if (MutationDefinitions[i].Key != mutationKey)
                {
                    continue;
                }

                found = true;
                break;
            }

            if(found)
            {

                let playerNumber = e.args[0];
                console.printf("%s added mutation %s", players[playerNumber].GetUserName(), mutationKey);
                MutationStates.Insert(mutationKey, "Active");
            }
            else
            {
                console.printf("Unknown mutation %s", mutationKey);
            }
        }
        else if (commandName.IndexOf("hm_offer:") >= 0)
        {
            Array <String> parts;
            commandName.split(parts, ":");

            MutationRemovalsOnOffer.Clear();
            for(let i = 1; i < parts.Size(); i++)
            {
                let mutationKey = parts[i];
                bool found = false;
                for(let j = 0; j < MutationDefinitions.Size(); j++)
                {
                    if (mutationDefinitions[j].Key != mutationKey)
                    {
                        continue;
                    }

                    found = true;
                    break;
                }

                if(found)
                {
                    MutationRemovalsOnOffer.Push(mutationKey);
                    console.printf("Added %s to offers.", mutationKey);
                }
                else
                {
                    console.printf("Unknown mutation %s", mutationKey);
                }
            }
        }
        else if (commandName == "hm_addallperks")
        {
            for(let i = 0; i < PerkDefinitions.Size(); i++)
            {
                PerkStates.Insert(PerkDefinitions[i].Key, "Active");
            }
        }
        else if (commandName == "hm_clearperks")
        {
            for(let i = 0; i < PerkDefinitions.Size(); i++)
            {
                PerkStates.Insert(PerkDefinitions[i].Key, "None");
            }
        }
        else if (commandName.IndexOf("hm_removeperk:") >= 0) // sent by Choose Perk menu
        {
            Array <String> parts;
			commandName.split(parts, ":");

            let playerNumber = e.args[0];
            let perkKey = parts[1];

            if(IsPerkActive(perkKey))
            {
                console.printf("%s removed perk %s", players[playerNumber].GetUserName(), perkKey);
                PerkStates.Insert(perkKey, "None");
            }
            else
            {
                console.printf("%s is not an active perk.", perkKey);
            }
        }
        else if (commandName.IndexOf("hm_addperk:") >= 0)
        {
            Array <String> parts;
            commandName.split(parts, ":");

            let perkKey = parts[1];
            let playerNumber = e.args[0];
            let player = players[playerNumber].mo;

            bool found = false;
            for(let i = 0; i < PerkDefinitions.Size(); i++)
            {
                if (PerkDefinitions[i].Key != perkKey)
                {
                    continue;
                }

                found = true;
                break;
            }

            if(found)
            {
                console.printf("%s gained perk %s", players[playerNumber].GetUserName(), perkKey);
                if(perkKey.IndexOf("basic_") <= 0)
                {
                    PerkStates.Insert(perkKey, "Active");
                }

                player.TakeInventory("HM_PerkPoint", 1);
                player.ACS_NamedExecute("hm_perkadded");

                PerkGained(perkKey, playerNumber);
            }
            else if(perkKey == "basic_recover" || perkKey == "basic_panic" || perkKey == "basic_undo")
            {
                console.printf("%s gained perk %s", players[playerNumber].GetUserName(), perkKey);
                PerkGained(perkKey, playerNumber);
                player.TakeInventory("HM_PerkPoint", 1);
                player.ACS_NamedExecute("hm_perkadded");
            }
            else
            {
                console.printf("Unknown perk %s", perkKey);
            }
        }
        else
        {
            console.printf("Unknown net command: %s", commandName);
        }
    }
}