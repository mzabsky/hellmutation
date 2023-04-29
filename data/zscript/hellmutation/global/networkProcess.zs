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
        else if (commandName == "hm_addall")
        {
            for(let i = 0; i < mutationDefinitions.Size(); i++)
            {
                MutationStates.Insert(mutationDefinitions[i].Key, "Active");
            }
        }
        else if (commandName == "hm_clear")
        {
            for(let i = 0; i < mutationDefinitions.Size(); i++)
            {
                MutationStates.Insert(mutationDefinitions[i].Key, "None");
            }
        }
        else if (commandName.IndexOf("hm_remove:") >= 0) // sent by DNA menu
        {
            Array <String> parts;
			      commandName.split(parts, ":");

            let playerNumber = e.args[0];
            let mutationName = parts[1];

            if(IsMutationActive(mutationName))
            {
                console.printf("%s removed mutation %s", players[playerNumber].GetUserName(), mutationName);
                MutationStates.Insert(mutationName, "Removed");

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
                console.printf("%s is not an active mutation.", mutationName);
            }
        }
        else if (commandName.IndexOf("hm_add:") >= 0)
        {
            Array <String> parts;
            commandName.split(parts, ":");

            let mutationName = parts[1];

            bool found = false;
            for(let i = 0; i < mutationDefinitions.Size(); i++)
            {
                if (mutationDefinitions[i].Key != mutationName)
                {
                    continue;
                }

                found = true;
                break;
            }

            if(found)
            {

                let playerNumber = e.args[0];
                console.printf("%s added mutation %s", players[playerNumber].GetUserName(), mutationName);
                MutationStates.Insert(mutationName, "Active");
            }
            else
            {
                console.printf("Unknown mutation %s", mutationName);
            }
        }
        else
        {
            console.printf("Unknown net command: %s", commandName);
        }
    }
}