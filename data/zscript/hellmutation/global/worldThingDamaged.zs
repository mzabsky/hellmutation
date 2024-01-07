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

            console.printf("%f Thing damaged: %s, Damage: %d, Health: %d, Source: %s, Source health %d, Damage type: %s", e.thing.FloorZ, e.thing.GetClassName(), e.damage, e.thing.health, e.damageSource.GetClassName(), e.damageSource.health, e.damageType);

            // Hematophagy
            if (e.inflictor is "Demon" && IsMutationActive("Hematophagy") && e.inflictor.health >= 0)
            {
                // This uses inflictor - we want the demon to be dealing the damage directly
                // (instead of eg. via a barrel)
                e.inflictor.A_ResetHealth();
                e.inflictor.A_GiveInventory("HM_HealGlitterGenerator");
            }

            if (e.damageSource is "PlayerPawn")
            {
                // Vampirism
                if(IsPerkActive("vampirism") && e.thing.bIsMonster)
                {
                    let percentMultiplier = 1;
                    let vampirismValue = e.damage * 10 * percentMultiplier / 100;

                    console.printf("vampirism: %d", vampirismValue);

                    if(vampirismValue < 10)
                    {
                        if(random[HM_GlobalHandler](0, 10) <= vampirismValue)
                        {
                            vampirismValue = 10;
                        }
                    }

                    e.damageSource.A_SetHealth(min(e.damageSource.health + vampirismValue / 10, e.damageSource.spawnhealth()));
                }
            }

            if (e.thing is "PlayerPawn")
            {
                let player = PlayerPawn(e.thing);

                /*let painSeed = HM_PainSeed(e.thing.Spawn("HM_PainSeed", e.thing.Vec3Offset(0, 0, 40)));
                if(painSeed != null)
                {
                    painSeed.SetSourceHealthLoss(e.damage);
                }*/

                // Anger - player was damaged by lost soul -> reset FAST to default state (the lost soul is no longer angry)
                if(e.damageSource.GetClassName() == 'HM_LostSoul' && IsMutationActive("anger"))
                {
                    e.damageSource.bAlwaysFast = false;
                }

                // Desecration - player was damaged by an imp
                if(e.damageSource.GetClassName() == 'HM_DoomImp' && IsMutationActive("Desecration") && e.inflictor.target.health >= 0)
                {
                    ReplaceActor(e.damageSource, "HM_ArchImp");
                    return;
                }

                // Promotion - player was damaged by a zombieman
                if(e.damageSource.GetClassName() == 'HM_ZombieMan' && IsMutationActive("Promotion"))
                {
                    ReplaceActor(e.damageSource, "HM_ShotgunGuy");
                    return;
                }

                // Lords of Souls - player was damaged by a hell knight -> resurrect a nearby monster
                if((e.damageSource is 'BaronOfHell' || e.damageSource is 'HellKnight') && IsMutationActive("lordsofsouls"))
                {
                    let range = 192;
                    BlockThingsIterator it = BlockThingsIterator.Create(e.thing, range);
                    Actor mo;

                    while (it.Next())
                    {
                        mo = it.thing;

                        if (!mo || !mo.bIsMonster || mo.health > 0 || e.thing.Distance3D(mo) > range || !mo.CanRaise())
                        {
                            continue;
                        }

                        if(e.damageSource.RaiseActor(mo))
                        {
                            break;
                        }
                    }

                    return;
                }

                // Ascension - player was damaged by a hell knight
                if(e.damageSource.GetClassName() == 'HM_HellKnight' && IsMutationActive("ascension"))
                {
                    ReplaceActor(e.damageSource, "HM_BaronOfHell");
                    return;
                }

                // Damping Jaws - player was damaged by a cacodemon -> remove powerups
                if(e.damageSource is 'Cacodemon' && IsMutationActive("dampingjaws"))
                {
                    player.A_TakeInventory("PowerStrength");
                    player.A_TakeInventory("PowerInvisibility");
                    player.A_TakeInventory("PowerLightAmp");
                    player.A_TakeInventory("PowerInvulnerable");
                    player.A_TakeInventory("PowerIronFeet");
                }
            }

            // Cyber-Neural Reflexes - Return fire
            if (e.thing is "HM_Arachnotron" && IsMutationActive("cyberneuralreflexes"))
            {
                let arachnotron = HM_ARachnotron(e.thing);
                arachnotron.target = e.damageSource;
                arachnotron.A_FaceTarget();
                arachnotron.HM_A_BspiAttack();
                arachnotron.SetState(arachnotron.ResolveState("InstantMissile"), 1);
            }

            // Decoys - Spawn a decoy
            if (e.thing is "HM_Revenant" && IsMutationActive("decoys"))
            {
                let revenant = HM_Revenant(e.thing);
                if(Level.time > revenant.lastDecoyTime + 35) // Max. once every second
                {
                    revenant.decoyRequested = true;
                }
            }

            // Reactive Camouflage - Make fuzzy
            if (e.thing is "HM_Demon" && IsMutationActive("reactivecamouflage"))
            {
                e.thing.A_SetRenderStyle(0.5, STYLE_OptFuzzy);
            }

            // Afinity - Damage the parent Pain Elemental as well
            if (e.thing is "HM_LostSoul" && IsMutationActive("affinity") && !(e.damageSource is 'LostSoul')) // We ignore infighting damage, makes it way too easy
            {
                let lostSoul = HM_LostSoul(e.thing);
                if(lostSoul != null && lostSoul.parent != null && lostSoul.parent.health > 0)
                {
                    lostSoul.parent.DamageMobj(lostSoul, e.damageSource, e.damage, 'Affinity', HM_DMG_REDIRECTED);
                }
            }

            // Triumvirate - Share the damage among the three cyberdemons
            if (e.thing is "HM_Cyberdemon" && (e.damageFlags & HM_DMG_REDIRECTED == 0)) // Do not share already shared damage
            {
                let cyberdemon = HM_Cyberdemon(e.thing);
                if(cyberdemon != null)
                {
                    if(cyberdemon.triumvirateMateA != null)
                    {
                        cyberdemon.triumvirateMateA.DamageMobj(cyberdemon, e.damageSource, e.damage, 'Triumvirate', HM_DMG_REDIRECTED);
                    }
                    
                    if(cyberdemon.triumvirateMateB != null)
                    {
                        cyberdemon.triumvirateMateB.DamageMobj(cyberdemon, e.damageSource, e.damage, 'Triumvirate', HM_DMG_REDIRECTED);
                    }
                }
            }

            // Tyranny - Reset tyranny counter whenever a cyberdemon hits its target
            if (e.damageSource is "HM_Cyberdemon" && IsMutationActive("tyranny") && e.thing == e.damageSource.target) // Only hitting the intended target counts
            {
                let cyberdemon = HM_Cyberdemon(e.damageSource);
                cyberdemon.lastScoredHitTime = Level.time;
            }
        }
    }
}