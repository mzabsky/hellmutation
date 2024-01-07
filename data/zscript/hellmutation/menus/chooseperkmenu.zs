class HM_ChoosePerkMenuHandler : HM_ZFHandler
{
    HM_ChoosePerkMenu link;

    override void elementHoverChanged(HM_ZFElement caller, Name command, bool unhovered)
    {
        if(!link.canAddPerk) {
            return;
        }

        if(caller is "HM_ZFButton") {
            let activatedButton = HM_ZFButton(caller);

            link.currentHighlightedPerkIndex = - 1;
            for(let i = 0; i < link.perkTitles.Size(); i++)
            {
                let currentButton = link.perkTitles[i];

                if(activatedButton == currentButton && !unhovered/* && !link.globalHandler.IsPerkActive(command)*/)
                {
                    link.currentHighlightedPerkIndex = i;
                }
            }

            link.UpdateItemHighlights();
        }


    }

    override void buttonClickCommand (HM_ZFButton caller, Name command)
    {
        if(!link.canAddPerk) {
            return;
        }

        //console.printf("COMMAND CLICK %s", command);

		EventHandler.SendNetworkEvent(String.Format("HM_AddPerk:%s", command), consoleplayer);
        link.Close();
    }
}

class HM_ChoosePerkMenu : HM_ZFGenericMenu
{
    HM_GlobalEventHandler globalHandler;

    HM_ChoosePerkMenuHandler handler;

    bool canAddPerk;

    // A font to use for text.
    Font smallFont;
    Font bigFont;
    Font doomFont;

    // A background image.
    HM_ZFImage background;
    
    HM_ZFButton aButton;
    HM_ZFLabel aLabel;
    int buttonColor;

    Array<HM_ZFButton> perkTitles;
    int currentHighlightedPerkIndex;

    override void Init (Menu parent)
    {
        let perkPointCount = players[consoleplayer].mo.CountInv("HM_PerkPoint");
        if(perkPointCount > 0)
        {
            canAddPerk = true;
        }

        globalHandler = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));

        currentHighlightedPerkIndex = -1;
        buttonColor = Font.CR_WHITE;

        Vector2 baseRes = (800, 600);

        Super.Init (parent);
        SetBaseResolution (baseRes);

        // Get GZDoom's new options menu smallfont.
        smallFont = OptionFont ();
        bigFont = Font.GetFont ("BIGFONT");
        doomFont = Font.GetFont ("SMALLFONT");

        handler = new ('HM_ChoosePerkMenuHandler');
        handler.link = self;

		let background = HM_ZFImage.Create(
			(-800, -100),
			(2400, 1200),
			image:"FLOOR7_2",
			imagescale:(2, 2),
            tiled: true
		);
		background.Pack(mainFrame);

        aLabel = HM_ZFLabel.Create
        (
            (0, 20),
            (0, bigFont.GetHeight ()),
            text: "GAIN A PERK",
            fnt: bigFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);
        
        if(!canAddPerk) {
            aLabel = HM_ZFLabel.Create
            (
                (0, aLabel.GetPosY() + 40),
                (0, bigFont.GetHeight ()),
                text: "YOU HAVE NO \c[Purple]PERK POINTS\c[Red]",
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
                text: "YOU GAIN ONE \c[Purple]PERK POINT\c[Red] FOR EVERY FIVE LOCKED-IN MUTATIONS",
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
            let youHaveXPerkPoints = String.Format("You have \c[Green]%d \c[Purple]PERK POINTS\c[Yellow]. \c[White]Click\c[Yellow] a perk to gain it. This costs \c[Green]1 \c[Purple]PERK POINT\c[Yellow].", perkPointCount);
            aLabel = HM_ZFLabel.Create
            (
                (0, aLabel.GetPosY() + 40),
                (0, doomFont.GetHeight ()),
                text: youHaveXPerkPoints,
                fnt: doomFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_YELLOW
            );
            aLabel.SetPosX ((baseRes.x - doomFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
            aLabel.Pack (mainFrame);
        }

        aLabel = HM_ZFLabel.Create
        (
            (0, aLabel.GetPosY() + aLabel.GetHeight() + 15),
            (0, bigFont.GetHeight ()),
            text: "BASIC PERKS",
            fnt: bigFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);
        
        aLabel = HM_ZFLabel.Create
        (
            (0, aLabel.GetPosY() + aLabel.GetHeight() + 5),
            (0, doomFont.GetHeight ()),
            text: "Basic perks are always on offer and can be taken repeatedly.",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        aButton = HM_ZFButton.Create
        (
            (25, aLabel.GetPosY() + aLabel.GetHeight() + 15),
            (300, bigFont.GetHeight ()),
            text: "Recover",
            cmdHandler: handler,
            command: "basic_recover",
            fnt: bigFont,
            textColor: buttonColor,
            alignment: HM_ZFButton.AlignType_TopLeft
        );
        aButton.Pack (mainFrame);
        perkTitles.Push(aButton);
        
        aLabel = HM_ZFLabel.Create
        (
            (35, aButton.GetPosY() + aButton.GetHeight() + 5),
            (0, doomFont.GetHeight () * 2),
            text: "Heal to 100 health, 100 armor and full ammo.",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: buttonColor
        );
        aLabel.Pack (mainFrame);

        aButton = HM_ZFButton.Create
        (
            (25, aLabel.GetPosY() + aLabel.GetHeight() + 15),
            (300, bigFont.GetHeight ()),
            text: "Panic",
            cmdHandler: handler,
            command: "basic_panic",
            fnt: bigFont,
            textColor: buttonColor,
            alignment: HM_ZFButton.AlignType_TopLeft
        );
        aButton.Pack (mainFrame);
        perkTitles.Push(aButton);
        
        aLabel = HM_ZFLabel.Create
        (
            (35, aButton.GetPosY() + aButton.GetHeight() + 5),
            (0, doomFont.GetHeight () * 2),
            text: "Become invulnerable for 30 seconds.",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: buttonColor
        );
        aLabel.Pack (mainFrame);

        aButton = HM_ZFButton.Create
        (
            (25, aLabel.GetPosY() + aLabel.GetHeight() + 15),
            (300, bigFont.GetHeight ()),
            text: "Undo",
            cmdHandler: handler,
            command: "basic_undo",
            fnt: bigFont,
            textColor: buttonColor,
            alignment: HM_ZFButton.AlignType_TopLeft
        );
        aButton.Pack (mainFrame);
        perkTitles.Push(aButton);
        
        aLabel = HM_ZFLabel.Create
        (
            (35, aButton.GetPosY() + aButton.GetHeight() + 5),
            (0, doomFont.GetHeight () * 2),
            text: "The next \c[Purple]DNA\c[White] you spend will be able to remove locked-in mutations.",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: buttonColor
        );
        aLabel.Pack (mainFrame);



        

        aLabel = HM_ZFLabel.Create
        (
            (0, aLabel.GetPosY() + aLabel.GetHeight() + 15),
            (0, bigFont.GetHeight ()),
            text: "CHANCE PERKS",
            fnt: bigFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);
        
        aLabel = HM_ZFLabel.Create
        (
            (0, aLabel.GetPosY() + aLabel.GetHeight() + 5),
            (0, doomFont.GetHeight ()),
            text: "Chance perks are randomly offered. New perks will be offered after you spend a \c[Purple]PERK POINT\c[Yellow].",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        let offeredPerkCount = globalHandler.GetPerksOnOfferCount();
        for(let i = 0; i < offeredPerkCount; i++)
        {
            HM_Definition perkDefinition;
            globalHandler.GetPerkOnOffer(i, perkDefinition);

            if(globalHandler.IsPerkActive(perkDefinition.Key))
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
                text: perkDefinition.Name,
                cmdHandler: handler,
                command: perkDefinition.Key,
                fnt: bigFont,
                textColor: buttonColor,
                alignment: HM_ZFButton.AlignType_TopLeft
            );
            aButton.Pack (mainFrame);
            
            aLabel = HM_ZFLabel.Create
            (
                (35, aButton.GetPosY() + aButton.GetHeight() + 5),
                (0, doomFont.GetHeight () * 2),
                text: perkDefinition.Description,
                fnt: doomFont,
                wrap: false,
                autoSize: true,
                textColor: buttonColor
            );
            aLabel.Pack (mainFrame);

            perkTitles.Push(aButton);
        }

        aLabel = HM_ZFLabel.Create
        (
            (0, baseRes.y - 75),
            (0, doomFont.GetHeight ()),
            text: "Unspent \c[Purple]PERK POINTS\c[Yellow] are carried over to the next level",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomfont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        aLabel = HM_ZFLabel.Create
        (
            (0, baseRes.y - 60),
            (0, doomFont.GetHeight ()),
            text: "\c[White][Up]\c[Yellow] Previous perk    \c[White][Down]\c[Yellow] Next perk    \c[White][Click]/[Enter]\c[White] \c[Yellow] Gain perk",
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomfont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);

        let pressPerk = String.Format("\c[White][%s]\c[Yellow] View active perks    \c[White][ESC]\c[White]\c[Yellow] Close", globalHandler.GetKeyForKeybind("hm_perksmenu"));
        aLabel = HM_ZFLabel.Create
        (
            (0, baseRes.y - 45),
            (0, doomFont.GetHeight ()),
            text: pressPerk,
            fnt: doomFont,
            wrap: false,
            autoSize: true,
            textColor: Font.CR_YELLOW
        );
        aLabel.SetPosX ((baseRes.x - doomfont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
        aLabel.Pack (mainFrame);
    }

    override bool onUIEvent(UIEvent e) {
        if (e.type == UIEvent.Type_KeyDown && e.KeyString == globalHandler.GetKeyForKeybind("hm_chooseperkmenu")) {
            Close();
            Menu.SetMenu("HM_ChoosePerkMenu");
            return true;
        }

        return super.onUIEvent(e);
    }

    override bool menuEvent(int mkey, bool fromcontroller)
    {
        if(perkTitles.Size() > 0 && canAddPerk)
        {
            switch (mkey)
            {
                case MKEY_Up: 

                    // Fix navigation jumping to the second item from the bottom if
                    // navigation UP is the first thing the player does after opening the menu
                    if(currentHighlightedPerkIndex == -1)
                    {
                        currentHighlightedPerkIndex = 0;
                    }

                    currentHighlightedPerkIndex = (currentHighlightedPerkIndex - 1 + perkTitles.Size()) % perkTitles.Size();
                    break;
                case MKEY_Down:
                    currentHighlightedPerkIndex = (currentHighlightedPerkIndex + 1 + perkTitles.Size()) % perkTitles.Size();
                    break;
                case MKEY_Enter:
                    // if(currentHighlightedPerkIndex != -1)
                    // {
                    //     HM_PerkDefinition perkDefinition;
                    //     globalHandler.GetPerkRemovalOnOffer(currentHighlightedPerkIndex, perkDefinition);
                    //     EventHandler.SendNetworkEvent(String.Format("HM_Remove:%s", perkDefinition.Key), consoleplayer);
                    //     Close();
                    //     return true;
                    // }
            }
        }

        UpdateItemHighlights();

        return super.menuEvent(mkey, fromcontroller);
    }

    void UpdateItemHighlights()
    {
        for(let i = 0; i < perkTitles.Size(); i++)
        {
            let currentButton = perkTitles[i];
            if(currentButton.GetTextColor() == Font.CR_BLACK)
            {
                continue;
            }
            else if(currentHighlightedPerkIndex == i)
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