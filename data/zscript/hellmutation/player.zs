class HM_Player: DoomPlayer
{
    // Number of ticks the player has looked at a Mastermind with Gorgon Protocol enabled
    int gorgonProtocolTicks;

    override void PlayerThink()
    {


        if(gorgonProtocolTicks > 0)
        {
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

        
        // Run all the stuff from the original function
        super.PlayerThink();
    }
}