extend class HM_GlobalEventHandler
{
    override void WorldThingDamaged(WorldEvent e)
    {
        if (e.damageSource == null)
        {
            // No source

            if (e.thing is "PlayerPawn")
            {
                if(IsMutationActive("slimeborne"))
                {
                    let roll = Random(0, 100);
                    //console.printf("slimeborne roll %d", roll);
                    if(roll <= e.damage * 2)
                    {
                        let spawnee = e.thing.Spawn("HM_DemonEgg", e.thing.pos, ALLOW_REPLACE);
                        spawnee.target = e.thing;
                    }
                }
            }
        }
        else
        {
            // Has damage source

            //console.printf("%f Thing damaged: %s, Health: %d, Source: %s, Source health %d", e.thing.FloorZ, e.thing.GetClassName(), e.thing.health, e.damageSource.GetClassName(), e.damageSource.health);

            // Hematophagy
            if (e.inflictor is "Demon" && IsMutationActive("Hematophagy") && e.inflictor.health >= 0)
            {
                // This uses inflictor - we want the demon to be dealing the damage directly
                // (instead of eg. via a barrel)
                e.inflictor.A_ResetHealth();
                e.inflictor.A_GiveInventory("HM_HealGlitterGenerator");
            }

            if (e.thing is "PlayerPawn")
            {
                let player = PlayerPawn(e.thing);

                /*let painSeed = HM_PainSeed(e.thing.Spawn("HM_PainSeed", e.thing.Vec3Offset(0, 0, 40)));
                if(painSeed != null)
                {
                    painSeed.SetSourceHealthLoss(e.damage);
                }*/

                // Desecration - player was damaged by an imp
                if(e.damageSource.GetClassName() == 'HM_DoomImp' && IsMutationActive("Desecration") && e.inflictor.target.health >= 0)
                {
                    ReplaceActor(e.damageSource, "HM_ArchImp");
                    return;
                }

                // Promotiom - player was damaged by a zombieman
                if(e.damageSource.GetClassName() == 'HM_ZombieMan' && IsMutationActive("Promotion"))
                {
                    ReplaceActor(e.damageSource, "HM_ShotgunGuy");
                    return;
                }

                // Ascension - player was damaged by a hell knight
                if(e.damageSource.GetClassName() == 'HM_HellKnight' && IsMutationActive("ascension"))
                {
                    ReplaceActor(e.damageSource, "HM_BaronOfHell");
                    return;
                }

                // Promotiom - player was damaged by a zombieman
                if(e.damageSource is 'Cacodemon' && IsMutationActive("dampingjaws"))
                {
                    player.A_TakeInventory("PowerStrength");
                    player.A_TakeInventory("PowerInvisibility");
                    player.A_TakeInventory("PowerLightAmp");
                    player.A_TakeInventory("PowerInvulnerable");
                    player.A_TakeInventory("PowerIronFeet");
                }
            }

            // Cyber-Neural Reflexes
            if (e.thing is "HM_Arachnotron" && IsMutationActive("cyberneuralreflexes"))
            {
                let arachnotron = HM_ARachnotron(e.thing);
                arachnotron.target = e.damageSource;
                arachnotron.A_FaceTarget();
                arachnotron.HM_A_BspiAttack();
                arachnotron.SetState(arachnotron.ResolveState("InstantMissile"), 1);
            }

            // Decoys
            if (e.thing is "HM_Revenant" && IsMutationActive("decoys"))
            {
                let revenant = HM_Revenant(e.thing);
                if(Level.time > revenant.lastDecoyTime + 35) // Max. once every second
                {
                    revenant.decoyRequested = true;
                }
            }
        }
    }
}