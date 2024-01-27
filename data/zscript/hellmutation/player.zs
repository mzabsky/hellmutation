class HM_Player: DoomPlayer
{
    mixin HM_GlobalRef;

    default
    {
        Player.StartItem "HM_Pistol";
		Player.StartItem "HM_Fist";
        Player.StartItem "Clip", 50;
    }

    // When the player has last spotted a gorgon protocol dummy
    int lastGorgonProtocolSpotted;

    // Number of ticks the player has looked at a Mastermind with Gorgon Protocol enabled
    int gorgonProtocolTicks;

    // Time of the last Boreal Gaze tick
    int lastBorealGazeTime;

    // The number of continuous Boreal Gaze stacked ticks
    int borealGazeTicks;

    // Time of last kill with a Shotgun (for Rampage)
    int lastShotgunKillTime;
    
    // This helps out the mixin, which does not trigger properly during level transitions
    override void Travelled()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
        super.Travelled();
    }

    override void PreTravelled()
    {
        lastGorgonProtocolSpotted = 0;
        gorgonProtocolTicks = 0;

        lastBorealGazeTime = 0;
        borealGazeTicks = 0;

        TakeInventory('HM_SafetyMeasures', 1);
    }

    override void Tick()
    {

        // Gorgon Protocol - check if each player was spotted by a dummy in this tick
        if(lastGorgonProtocolSpotted >= Level.Time - 1)
        {
            gorgonProtocolTicks++;
        }
        else
        {
            gorgonProtocolTicks /= 2;
        }

        //console.printf("%d tick %d %d", Level.Time, lastBorealGazeTime, borealGazeTicks);

        if(lastBorealGazeTime < Level.Time - 4)
        {
            borealGazeTicks = 0;

            //console.printf("%d tick reset", Level.Time);
        }
        else
        {
          //console.printf("%d tick keep boreal", Level.Time);
        }

        super.Tick();
    }

    override void PlayerThink()
    {
        let originalSpeed = player.cmd.forwardmove;

        // Apply Gorgon Protocol immobilizations
        if(gorgonProtocolTicks > 0)
        {
            //console.printf("gorgonprotocolticks %d %d", lastGorgonProtocolSpotted, gorgonProtocolTicks);

            let maxoutTime = 10 * 35; // How many ticks it takes for the effect to max out
            let maxPitchYawReduction = 4.0;
            let maxForwardMoveReduction = 3.0;
            let maxSideMoveReduction = 50.0;

            let applicableTicks = min(gorgonProtocolTicks, maxoutTime);
            let factor = float(applicableTicks) / float(maxoutTime);

            //console.printf("gorgon protocol %d %f", gorgonProtocolTicks, factor);

            // set an easy varible for prediction check.
            // This is just easier than typicing the full check
            bool notpredicting = !(player.cheats & CF_PREDICTING);


            player.cheats |= CF_INTERPVIEW;

            // If the player action is NOT being predicted,
            // reduce both yaw and pitch raw inputs by 50%
            if (notpredicting) {
                player.cmd.yaw /= 1+(factor * maxPitchYawReduction); // Effect caps at 1/10th pitch/yaw rate
                player.cmd.pitch /= 1+(factor * maxPitchYawReduction);
            }

            player.cmd.forwardmove /= 1+(factor * maxForwardMoveReduction); // effect caps at 1/3.5th;
            player.cmd.sidemove /= 1+(factor * maxSideMoveReduction);
            
        }
        else
        {
            //console.printf("gorgon protocol %d", gorgonProtocolTicks);
        }

        if(borealGazeTicks > 0)
        {
            let maxoutTime = 60;
            let maxReduction = 1.5;

            let applicableTicks = min(borealGazeTicks, maxoutTime);

            let factor = float(applicableTicks) / float(maxoutTime);

            let divisor = 1+(factor * maxReduction);

            bool notpredicting = !(player.cheats & CF_PREDICTING);


            player.cheats |= CF_INTERPVIEW;

            //console.printf("%d move %d %f", Level.Time, borealGazeTicks, factor);

            if(notPredicting)
            {
                player.cmd.yaw /= divisor;
                player.cmd.pitch /= divisor;
            }
            player.cmd.forwardmove /= divisor;
            player.cmd.sidemove /= divisor;
        }

        if(global != null && global.IsPerkActive("brinkmanship") && player.mo && player.health <= 25)
        {
            player.cmd.forwardmove *= 1.07;
            player.cmd.sidemove *= 1.07;
        }

        //console.printf("speed %f", originalSpeed > 0 ? float(player.cmd.forwardmove) / float(originalSpeed) : 0);
        
        // Run all the stuff from the original function
        super.PlayerThink();
    }

    override int DamageMobj (Actor inflictor, Actor source, int damage, Name mod, int flags, double angle)
    {
        // Safety Measures - Give RadSuit if not activated in this level yet
        if (inflictor == null && global.IsPerkActive("safetymeasures") && GiveInventoryType("HM_SafetyMeasures") != null)
        {
            GiveInventoryType("RadSuit");
            return 0;
        }

        // Mindfulness - Take three times less self damage
        if (source == self && global.isPerkActive("mindfulness"))
        {
            damage /= 3;
        }

        // All In - As long as the player has 200 health and armor, take much more damage
        let isAllInOn = global.IsPerkActive("allin")
            && Health >= 200
            && CountInv("BasicArmor") == 200;
        if(isAllInOn)
        {
            damage = damage * 2.5;
        }

        // Last Stand - Give a brief invulnerability shield if the player would die for the first time in a level
        if (damage >= Health && global.IsPerkActive("laststand") && GiveInventoryType("HM_LastStand") != null)
        {
            let result = super.DamageMobj(inflictor, source, Health - 1, mod, flags, angle);
            GiveInventoryType("HM_LastStandPowerupGiver");
            return result;
        }

        if(inflictor is 'ExplosiveBarrel' && global.IsPerkActive("extremetanning"))
        {
            GiveInventoryType('HM_HealGlitterGenerator');
            GiveBody(damage);
            return 0;
        }

        if(mod == "Crush" && global.IsPerkActive("calciumregimen"))
        {
            return 0;
        }

        return super.DamageMobj(inflictor, source, damage, mod, flags, angle);
    }    
}