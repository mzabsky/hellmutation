class HM_Player: DoomPlayer
{
    mixin HM_GlobalRef;

    // When the player has last spotted a gorgon protocol dummy
    int lastGorgonProtocolSpotted;

    // Number of ticks the player has looked at a Mastermind with Gorgon Protocol enabled
    int gorgonProtocolTicks;

    // Time of the last Boreal Gaze tick
    int lastBorealGazeTime;

    // The number of continuous Boreal Gaze stacked ticks
    int borealGazeTicks;


    override void PreTravelled()
    {
        lastGorgonProtocolSpotted = 0;
        gorgonProtocolTicks = 0;

        lastBorealGazeTime = 0;
        borealGazeTicks = 0;
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

        if(global.IsPerkActive("brinkmanship") && player.mo && player.health <= 25)
        {
            player.cmd.forwardmove *= 1.07;
            player.cmd.sidemove *= 1.07;
        }

        //console.printf("speed %f", originalSpeed > 0 ? float(player.cmd.forwardmove) / float(originalSpeed) : 0);
        
        // Run all the stuff from the original function
        super.PlayerThink();
    }
}