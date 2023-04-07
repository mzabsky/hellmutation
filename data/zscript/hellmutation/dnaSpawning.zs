extend class HM_GlobalEventHandler
{
    void SpawnDna()
    {
        let firstDnaPlace = FindPlaceForFirstDna();
        if(firstDnaPlace != null)
        {
            firstDnaPlace.Spawn("HM_Dna", firstDnaPlace.Vec3Offset(0, 0, 32), ALLOW_REPLACE);
            console.printf("Spawned first DNA on a %s.", firstDnaPlace.GetClassName());
        }
        else
        {
            console.printf("Could not find place to spawn first DNA.");
        }

        let secondDnaPlace = FindPlaceForSecondDna();
        if(secondDnaPlace != null)
        {
            secondDnaPlace.Spawn("HM_Dna", secondDnaPlace.Vec3Offset(0, 0, 32), ALLOW_REPLACE);
            console.printf("Spawned second DNA on a %s.", secondDnaPlace.GetClassName());
        }
        else
        {
            console.printf("Could not find place to spawn second DNA.");
        }

        let thirdDnaPlace = FindPlaceForThirdDna();
        if(thirdDnaPlace != null)
        {
            let thirdDna = thirdDnaPlace.Spawn("HM_Dna", thirdDnaPlace.Vec3Offset(0, 0, 0), ALLOW_REPLACE);
            thirdDna.bNoGravity = false; // Apply gravity to this DNA specifically (primarily for MAP02 where the cyberdemon spawns on a lowering platform)
            console.printf("Spawned third DNA on a %s.", thirdDnaPlace.GetClassName());
        }
        else
        {
            console.printf("Could not find place to spawn third DNA.");
        }
    }

    private Actor FindPlaceForFirstDna()
    {
        let finder = ThinkerIterator.Create("Megasphere");
        let actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Soulsphere");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Backpack");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("BlueArmor");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("BFG9000");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("PlasmaRifle");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("RocketLauncher");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("YellowSkull");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("RedSkull");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("BlueSkull");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("YellowCard");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("RedCard");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("BlueCard");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        return null;
    }

    private Actor FindPlaceForSecondDna()
    {
        let finder = ThinkerIterator.Create("Shotgun");
        let actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Chaingun");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("SuperShotgun");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("GreenArmor");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Medikit");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("Stimpack");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        return null;
    }

    private Actor FindPlaceForThirdDna()
    {
        let finder = ThinkerIterator.Create("Cyberdemon");
        let actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        finder = ThinkerIterator.Create("SpiderMastermind");
        actor = Actor(finder.Next());
        if(actor != null) {
            return actor;
        }

        return null;
    }
}