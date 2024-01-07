
// The menu's command handler.
// This is needed so we can make our menu interactable.
class HM_DnaMenuHandler : HM_ZFHandler
{
    // The menu this command handler belongs to.
    // We need this to be able to do anything with our menu.
    HM_DnaMenu link;

    override void elementHoverChanged(HM_ZFElement caller, Name command, bool unhovered)
    {
        if(!link.canRemoveMutation) {
            return;
        }

        if(caller is "HM_ZFButton") {
            let activatedButton = HM_ZFButton(caller);

            link.currentHighlightedMutationIndex = - 1;
            for(let i = 0; i < link.mutationTitles.Size(); i++)
            {
                let currentButton = link.mutationTitles[i];

                if(activatedButton == currentButton && !unhovered/* && !link.globalHandler.IsMutationActive(command)*/)
                {
                    link.currentHighlightedMutationIndex = i;
                }
            }

            link.UpdateItemHighlights();
        }


    }

    override void buttonClickCommand (HM_ZFButton caller, Name command)
    {
        if(!link.canRemoveMutation) {
            return;
        }

        //console.printf("COMMAND CLICK %s", command);

		EventHandler.SendNetworkEvent(String.Format("HM_Remove:%s", command), consoleplayer);
        link.Close();
    }
}

class HM_DnaMenu : HM_ZFGenericMenu
{
    HM_GlobalEventHandler globalHandler;

    // The menu's command handler.
    // We need a command handler so we can make our menu interactable.
    HM_DnaMenuHandler handler;

    bool canRemoveMutation;

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

    Array<HM_ZFButton> mutationTitles;
    int currentHighlightedMutationIndex;

    override void Init (Menu parent)
    {
        let dna = HM_Dna(players[consoleplayer].mo.FindInventory("HM_Dna"));
        let dnaCount = players[consoleplayer].mo.CountInv("HM_Dna");
        canRemoveMutation = !!dna;

        globalHandler = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));

        currentHighlightedMutationIndex = -1;

        Vector2 baseRes = (640, 400);

        // Call GenericMenu's 'Init' function to do some required initialization.
        Super.Init (parent);
        // Set our base resolution to 320x200.
        SetBaseResolution (baseRes);

        // Get GZDoom's new options menu smallfont.
        smallFont = OptionFont ();
        bigFont = Font.GetFont ("BIGFONT");
        doomFont = Font.GetFont ("SMALLFONT");

        // Create an instance of the handler.
        handler = new ('HM_DnaMenuHandler');
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
        aLabel = HM_ZFLabel.Create
        (
            (0, 20),
            (0, bigFont.GetHeight ()),
            text: "REMOVE A MUTATION",
            fnt: bigFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);
        
        if(!canRemoveMutation) {
            aLabel = HM_ZFLabel.Create
            (
                (0, aLabel.GetPosY() + 40),
                (0, bigFont.GetHeight ()),
                text: "YOU HAVE NO \c[Purple]DNA\c[Red]",
                fnt: bigFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_RED
            );
            aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
            aLabel.Pack (mainFrame);

            aLabel = HM_ZFLabel.Create
            (
                (0, aLabel.GetPosY() + 20),
                (0, doomFont.GetHeight ()),
                text: "\c[Purple]DNA\c[Red] IS REQUIRED TO REMOVE A MUTATION",
                fnt: doomFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_RED
            );
            aLabel.SetPosX ((baseRes.x - doomFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
            aLabel.Pack (mainFrame);
        }
        else
        {
            let youHaveXDna = String.Format("You have \c[Green]%d \c[Purple]DNA\c[Yellow]. \c[White]Click\c[Yellow] a mutation to permanently remove it. This costs \c[Green]1 \c[Purple]DNA\c[Yellow].", dnaCount);
            aLabel = HM_ZFLabel.Create
            (
                (0, aLabel.GetPosY() + 40),
                (0, doomFont.GetHeight ()),
                text: youHaveXDna,
                fnt: doomFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_YELLOW
            );
            aLabel.SetPosX ((baseRes.x - doomFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
            aLabel.Pack (mainFrame);
        }

        let offeredMutationCount = globalHandler.GetMutationRemovalOnOfferCount();
        for(let i = 0; i < offeredMutationCount; i++)
        {
            HM_Definition mutationDefinition;
            globalHandler.GetMutationRemovalOnOffer(i, mutationDefinition);

            if(globalHandler.IsMutationRemoved(mutationDefinition.Key))
            {
                buttonColor = Font.CR_BLACK;
            }
            else {
                buttonColor = Font.CR_WHITE;
            }
            aButton = HM_ZFButton.Create
            (
                (25, aLabel.GetPosY() + aLabel.GetHeight() + 15),
                (300, bigFont.GetHeight ()),
                text: mutationDefinition.Name,
                cmdHandler: handler,
                command: mutationDefinition.Key,
                fnt: bigFont,
                textColor: buttonColor,
                alignment: HM_ZFButton.AlignType_TopLeft
            );
            aButton.Pack (mainFrame);
            
            aLabel = HM_ZFLabel.Create
            (
                (35, aButton.GetPosY() + aButton.GetHeight() + 5),
                (0, doomFont.GetHeight () * 2),
                text: mutationDefinition.Description,
                fnt: doomFont,
                wrap: false,
                autoSize: true,
                textColor: buttonColor
            );
            aLabel.Pack (mainFrame);

            mutationTitles.Push(aButton);
        }

        aLabel = HM_ZFLabel.Create
        (
            (0, 345),
            (0, doomFont.GetHeight ()),
            text: "Unspent \c[Purple]DNA\c[Yellow] is carried over to the next level",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomfont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        aLabel = HM_ZFLabel.Create
        (
            (0, 360),
            (0, doomFont.GetHeight ()),
            text: "\c[White][Up]\c[Yellow] Previous mutation    \c[White][Down]\c[Yellow] Next mutation    \c[White][Click]/[Enter]\c[White] \c[Yellow] Remove mutation",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomfont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        let pressMutation = String.Format("\c[White][%s]\c[Yellow] View active mutations    \c[White][ESC]\c[White]\c[Yellow] Close", globalHandler.GetKeyForKeybind("hm_mutationmenu"));
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
    }

    override bool onUIEvent(UIEvent e) {
        if (e.type == UIEvent.Type_KeyDown && e.KeyString == globalHandler.GetKeyForKeybind("hm_mutationmenu")) {
            Close();
            Menu.SetMenu("HM_MutationMenu");
            return true;
        }

        return super.onUIEvent(e);
    }

    override bool menuEvent(int mkey, bool fromcontroller)
    {
        if(mutationTitles.Size() > 0 && canRemoveMutation)
        {
            switch (mkey)
            {
                case MKEY_Up: 

                    // Fix navigation jumping to the second item from the bottom if
                    // navigation UP is the first thing the player does after opening the menu
                    if(currentHighlightedMutationIndex == -1)
                    {
                        currentHighlightedMutationIndex = 0;
                    }

                    currentHighlightedMutationIndex = (currentHighlightedMutationIndex - 1 + mutationTitles.Size()) % mutationTitles.Size();
                    break;
                case MKEY_Down:
                    currentHighlightedMutationIndex = (currentHighlightedMutationIndex + 1 + mutationTitles.Size()) % mutationTitles.Size();
                    break;
                case MKEY_Enter:
                    if(currentHighlightedMutationIndex != -1)
                    {
                        HM_Definition mutationDefinition;
                        globalHandler.GetMutationRemovalOnOffer(currentHighlightedMutationIndex, mutationDefinition);
                        EventHandler.SendNetworkEvent(String.Format("HM_Remove:%s", mutationDefinition.Key), consoleplayer);
                        Close();
                        return true;
                    }
            }
        }

        UpdateItemHighlights();

        return super.menuEvent(mkey, fromcontroller);
    }

    void UpdateItemHighlights()
    {
        for(let i = 0; i < mutationTitles.Size(); i++)
        {
            let currentButton = mutationTitles[i];
            if(currentButton.GetTextColor() == Font.CR_BLACK)
            {
                continue;
            }
            else if(currentHighlightedMutationIndex == i)
            {
                currentButton.SetTextColor(Font.CR_RED);
            }
            else
            {
                currentButton.SetTextColor(Font.CR_WHITE);
            }
        }
    }
}