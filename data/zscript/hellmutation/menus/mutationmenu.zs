
class HM_MutationMenuHandler : HM_ZFHandler
{
    // The menu this command handler belongs to.
    // We need this to be able to do anything with our menu.
    HM_MutationMenu link;

    override void elementHoverChanged(HM_ZFElement caller, Name command, bool unhovered)
    {
        if(caller is "HM_ZFButton") {
            let button = HM_ZFButton(caller);

            if(link.globalHandler.IsMutationRemoved(command))
            {
                button.SetTextColor(Font.CR_BLACK);
                return;
            }

            if(unhovered)
            {
                button.SetTextColor(Font.CR_WHITE);
            }
            else
            {
                button.SetTextColor(Font.CR_YELLOW);
            }
            
        }


    }

    override void buttonClickCommand (HM_ZFButton caller, Name command)
    {
        //console.printf("COMMAND CLICK %s", command);

		EventHandler.SendNetworkEvent(String.Format("HM_Remove:%s", command), consoleplayer);
        link.Close();
    }
}

class HM_MutationPageInfo
{
    HM_ZFButton Title;
    HM_ZFLabel Description;
}

class HM_MutationMenu : HM_ZFGenericMenu
{

    HM_GlobalEventHandler globalHandler;

    // The menu's command handler.
    // We need a command handler so we can make our menu interactable.
    HM_MutationMenuHandler handler;

    int resX;

    int pageCount;
    int pageNumber;
    int mutationsPerPage;
    Array<HM_MutationPageInfo> pageInfos;

    HM_ZFLabel titleLabel;

    // A font to use for text.
    Font smallFont;
    Font bigFont;
    Font doomFont;

    // A background image.
    HM_ZFImage background;
    // A simple single-texture button.
    HM_ZFButton aButton;
    // A text label.
    HM_ZFLabel aLabel;
    int buttonColor; 

    override void Init (Menu parent)
    {
        let dna = HM_Dna(players[consoleplayer].mo.FindInventory("HM_Dna"));

        globalHandler = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));

        resX = 640;
        Vector2 baseRes = (resX, 400);

        // Call GenericMenu's 'Init' function to do some required initialization.
        Super.Init (parent);
        // Set our base resolution to 320x200.
        SetBaseResolution (baseRes);

        // Get GZDoom's new options menu smallfont.
        smallFont = OptionFont ();
        bigFont = Font.GetFont ("BIGFONT");
        doomFont = Font.GetFont ("SMALLFONT");

        // Create an instance of the handler.
        handler = new ('HM_MutationMenuHandler');
        // Set the handler's "link" pointer to us.
        handler.link = self;

		let background = HM_ZFImage.Create(
			(-800, -100),
			(2400, 1200),
			image:"FLOOR7_2",
			imagescale:(2, 2),
            tiled: true
		);
		background.Pack(mainFrame);

        
        // Add a label.
        aLabel = titleLabel = HM_ZFLabel.Create
        (
            (0, 20),
            (0, bigFont.GetHeight ()),
            text: "",
            fnt: bigFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        mutationsPerPage = 7;
        for(let i = 0; i < mutationsPerPage; i++)
        {
            /*HM_Definition mutationDefinition;
            globalHandler.GetMutationDefinition(i, mutationDefinition);

            if(!globalHandler.IsMutationActive(mutationDefinition.Key))
            {
                continue;
            }*/

            aButton = HM_ZFButton.Create
            (
                (25, aLabel.GetPosY() + aLabel.GetHeight() + 10),
                (500, bigFont.GetHeight ()),
                text: "",
                command: "",
                fnt: bigFont,
                textColor: Font.CR_WHITE,
                alignment: HM_ZFButton.AlignType_TopLeft
            );
            aButton.Pack (mainFrame);
            
            aLabel = HM_ZFLabel.Create
            (
                (35, aButton.GetPosY() + aButton.GetHeight() + 3),
                (0, doomFont.GetHeight () * 2),
                text: "",
                fnt: doomFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_WHITE
            );
            aLabel.Pack (mainFrame);

            let pageInfo = new ("HM_MutationPageInfo");
            pageInfo.Title = aButton;
            pageInfo.Description = aLabel;
            pageInfos.Push(pageInfo);
        }

        let pressMutation = String.Format("\c[White][UP]\c[White]\c[Yellow] Previous page    \c[White][DOWN]\c[White]\c[Yellow] Next page    \c[White][%s]\c[Yellow] Remove mutations    \c[White][ESC]\c[White]\c[Yellow] Close", globalHandler.GetKeyForKeybind("hm_dnamenu"));
        aLabel = HM_ZFLabel.Create
        (
            (0, 375),
            (0, doomFont.GetHeight ()),
            text: pressMutation,
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomfont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        RedrawPage();
    }

    override bool onUIEvent(UIEvent e)
    {
        //console.printf("onuievent %d %s %d", e.Type, e.KeyString, e.KeyChar);

        if (e.type == UIEvent.Type_KeyDown && e.KeyString == globalHandler.GetKeyForKeybind("hm_dnamenu"))
        {
            Close();
            Menu.SetMenu("HM_DnaMenu");
            return true;
        }
        else if (e.type == UIEvent.Type_WheelDown)
        {
            NavigateToNextPage();
            return true;
        }
        else if (e.type == UIEvent.Type_WheelUp)
        {
            NavigateToPreviousPage();
            return true;
        }

        return super.onUIEvent(e);
    }

    override bool menuEvent(int mkey, bool fromcontroller)
    {
        //console.printf("menuevent %d %d", mkey, fromcontroller);

        switch (mkey)
        {
            case MKEY_Up: 
            case MKEY_Left:
            case MKEY_PageUp:
                NavigateToPreviousPage();
                break;
            case MKEY_Down:
            case MKEY_Right:
            case MKEY_PageDown:
                NavigateToNextPage();
                break;
        }
        
        return super.menuEvent(mkey, fromcontroller);
    }

    void NavigateToPreviousPage()
    {
        pageNumber = max(0, pageNumber - 1);
        RedrawPage();
    }


    void NavigateToNextPage()
    {
        let activeMutationCount = globalHandler.GetActiveMutationDefinitionCount();
        if((pageNumber + 1) < pageCount)
        {
            pageNumber++;
            RedrawPage();
        }
    }

    void RedrawPage()
    {
        let mutationDefinitionCount = globalHandler.GetMutationDefinitionCount();
        let activeMutationCount = globalHandler.GetActiveMutationDefinitionCount();

        pageCount = max(1, int(ceil(float(activeMutationCount) / float(mutationsPerPage))));

        let activeI = 0;
        let startingActiveI = mutationsPerPage * pageNumber;
        let endingActiveI = mutationsPerPage * (pageNumber + 1);
        //console.printf("redraw page %i %i", pageNumber, pageCount);
        //console.printf("range %d-%d (of %d)", startingActiveI, endingActiveI, activeMutationCount);

        let pageTitle = "ACTIVE MUTATIONS";
        if(activeMutationCount > mutationsPerPage)
        {
            pageTitle = String.Format("%s - PAGE %d of %d", pageTitle, pageNumber + 1, pageCount);
        }

        titleLabel.SetText(pageTitle);
        titleLabel.SetPosX ((resX - bigFont.stringWidth (titleLabel.GetText ())) / 2.); // Center on X axis

        // 
        for(int i = 0; i < mutationsPerPage; i++)
        {
            let pageInfo = pageInfos[i];
            pageInfo.Title.SetText("");
            pageInfo.Description.SetText("");
        }    

        for(int i = 0; i < mutationDefinitionCount; i++)
        {
            //console.printf("redraw i %d", i);
            HM_Definition mutationDefinition;

            globalHandler.GetMutationDefinition(i, mutationDefinition);
            //console.printf("mutation %s %d", mutationDefinition.Key, globalHandler.IsMutationActive(mutationDefinition.Key));
            if(!globalHandler.IsMutationActive(mutationDefinition.Key))
            {
                continue;
            }

            // We are past the page
            if(activeI >= endingActiveI)
            {
                break;
            }

            if(activeI >= startingActiveI)
            {
                let indexInPage = activeI - startingActiveI;
                let pageInfo = pageInfos[indexInPage];
                
                let mutationTitle = mutationDefinition.Name;
                if(globalHandler.CanMutationBeRemoved(mutationDefinition.Key))
                {
                    mutationTitle = String.format("%s - \c[Yellow]NEW!\c[Yellow]\c[White] \c[Green]CAN BE REMOVED", mutationTitle);
                }

                pageInfo.Title.SetText(mutationTitle);
                pageInfo.Description.SetText(mutationDefinition.Description);
            }
            
            activeI++;
        }
    }
}