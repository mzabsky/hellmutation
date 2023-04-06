
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
        if(!link.canRemoveMutation) {
            return;
        }

        console.printf("COMMAND CLICK %s", command);

		EventHandler.SendNetworkEvent(String.Format("HM_RemoveMutation:%s", command), consoleplayer);
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
    Font conFont;

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
        canRemoveMutation = !!dna;

        globalHandler = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));

        Vector2 baseRes = (640, 400);

        // Call GenericMenu's 'Init' function to do some required initialization.
        Super.Init (parent);
        // Set our base resolution to 320x200.
        SetBaseResolution (baseRes);

        // Get GZDoom's new options menu smallfont.
        smallFont = OptionFont ();
        bigFont = Font.GetFont ("BIGFONT");
        conFont = Font.GetFont ("CONFONT");

        // Create an instance of the handler.
        handler = new ('HM_DnaMenuHandler');
        // Set the handler's "link" pointer to us.
        handler.link = self;

        // Add a background.
        /*background = HM_ZFImage.Create
        (
            // Position
            (0, 0),
            // Size
            (320, 200),
            // Image path/name
            "graphics/ZFormsExamples/Panel.png",
            // Alignment options
            HM_ZFImage.AlignType_TopLeft
        );
        // Add the image element into the main frame.
        background.Pack (mainFrame);*/

        // Create the box image's textures.
        /*let boxTexture = HM_ZFBoxTextures.CreateTexturePixels
        (
            // The texture itself.
            "graphics/ZFormsExamples/BoxTexture.png",
            // The top-left corner of the middle of the box.
            (32, 32),
            // The bottom-right corner of the middle of the box.
            (64, 64),
            // Whether to scale (true) or tile (false) the sides.
            false,
            // Whether to scale (true) or tile (false) the middle.
            false
        );
        // Add a box image.
        let boxSize = (128, 128);
        let aBoxImage = HM_ZFBoxImage.Create
        (
            // Position
            ((baseRes.X - boxSize.X) / 2., (baseRes.Y - boxSize.Y) / 2.),
            // Size
            boxSize,
            // Texture
            boxTexture,
            // Scale
            (0.25, 0.25)
        );
        // Add the box image element into the main frame.
        aBoxImage.Pack (mainFrame);*/

        // Create the button's textures.
        /*let buttonIdle = HM_ZFBoxTextures.CreateSingleTexture ("graphics/ZFormsExamples/SmallButtonIdle.png", true);
        let buttonHover = HM_ZFBoxTextures.CreateSingleTexture ("graphics/ZFormsExamples/SmallButtonHovered.png", false);
        let buttonClick = HM_ZFBoxTextures.CreateSingleTexture ("graphics/ZFormsExamples/SmallButtonClicked.png", false);
        // Add a button.
        aButton = HM_ZFButton.Create
        (
            // Position
            ((baseRes.X - 18.) / 2., (baseRes.Y - 18.) / 2.),
            // Size
            (18, 18),
            // Our command handler
            cmdHandler: handler,
            // A command string for the button
            command: "aButton",
            // The button's textures
            inactive: buttonIdle,
            hover: buttonHover,
            click: buttonClick
        );
        // Add the button element into the main frame.
        aButton.Pack (mainFrame);*/

        // Add a label.
        /*aLabel = HM_ZFLabel.Create
        (
            // Position
            (0, aButton.GetPosY () + aButton.GetHeight () + 4),
            // Size.
            (0, smallFont.GetHeight ()),
            // The label's text
            text: "Click me!",
            // The font to use
            fnt: smallFont,
            // Whether to automatically wrap the text or not
            wrap: false,
            // Whether to automatically resize the element based on the text width
            autoSize: true,
            // The text's colour
            textColor: Font.CR_WHITE
        );
        // Calculate the horizontal position for the label so that it's centered on the screen.
        aLabel.SetPosX ((baseRes.x - smallFont.stringWidth (aLabel.GetText ())) / 2.);
        // Add the label element to the main frame.
        aLabel.Pack (mainFrame);*/


        
        // Add a label.
        aLabel = HM_ZFLabel.Create
        (
            (0, 40),
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
                (0, bigFont.GetHeight ()),
                text: "FIND \c[Purple]DNA\c[Red] TO REMOVE A MUTATION",
                fnt: bigFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_RED
            );
            aLabel.SetPosX ((baseRes.x - bigFont.stringWidth (aLabel.GetText ())) / 2.); // Center on X axis
            aLabel.Pack (mainFrame);
        }

        let offeredMutationCount = globalHandler.GetMutationRemovalOnOfferCount();
        for(let i = 0; i < offeredMutationCount; i++)
        {
            HM_MutationDefinition mutationDefinition;
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
                (0, conFont.GetHeight () * 2),
                text: mutationDefinition.Description,
                fnt: conFont,
                wrap: false,
                autoSize: true,
                textColor: Font.CR_WHITE
            );
            aLabel.Pack (mainFrame);
        }
    }
}