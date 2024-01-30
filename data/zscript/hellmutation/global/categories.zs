// Categories for both mutations and perks
enum HM_Category
{
    HM_CAT_NONE = 0,

    // Binding categories - these MUST be matched to allow the mutation/perk to appear
    HM_CAT_DOOM2 = 1, // Only allowed if the current IWAD allows DOOM2's feature set (arch viles, super shotgun and stuff)
    HM_CAT_NOFIRSTMAP = 2, // Can't appear in the first map in this save

    // Basic categories
    HM_CAT_META = 10001, // Affects the nature of perks, mutations, DNA, etc.
    HM_CAT_PLAYER = 10002,
    HM_CAT_DMGFLOOR = 10003,
    HM_CAT_BARREL = 10004, // Explosive barrels
    HM_CAT_HEALTH = 10005,
    HM_CAT_ARMOR = 10006,
    HM_CAT_AMMO = 10006,

    // Weapons
    HM_CAT_FIST = 20001,
    HM_CAT_CHAINSAW = 20002,
    HM_CAT_PISTOL = 20003,
    HM_CAT_SHOTGUN = 20004,
    HM_CAT_SUPERSHOTGUN = 20005,
    HM_CAT_CHAINGUN = 20006,
    HM_CAT_ROCKETLAUNCHER = 20007,
    HM_CAT_PLASMAGUN = 20008,
    HM_CAT_BFG = 20009,

    // Monsters
    HM_CAT_ALLMONSTERS = 30001, // Affects all monsters
    HM_CAT_ZOMBIEMAN = 30002,
    HM_CAT_SHOTGUNNER = 30003,
    HM_CAT_CHAINGUNNER = 30004,
    HM_CAT_IMP = 30005,
    HM_CAT_PINKY = 30006, // Spectres count as pinkys
    HM_CAT_REVENANT = 30007,
    HM_CAT_CACODEMON = 30008,
    HM_CAT_LOSTSOUL = 30009,
    HM_CAT_PAINELEMENTAL = 30010,
    HM_CAT_HELLKNIGHT = 30011,
    HM_CAT_BARONOFHELL = 30012,
    HM_CAT_MANCUBUS = 30013,
    HM_CAT_ARCHVILE = 30014,
    HM_CAT_ARACHNOTRON = 30015,
    HM_CAT_SPIDERMASTERMIND = 30016,
    HM_CAT_CYBERDEMON = 30017,
    HM_CAT_BOSSBRAIN = 30018,

    // Pickups
    HM_CAT_BLURSPHERE = 40001,
    HM_CAT_SOULSPHERE = 40002,
    HM_CAT_MEGASPHERE = 40003,
    HM_CAT_BACKPACK = 40004,
    HM_CAT_BERSERK = 40005,
    HM_CAT_RADSUIT = 40006,
    HM_CAT_KEY = 40007,
};

extend class HM_GlobalEventHandler
{
    bool HasCategory(Array<HM_Category> haystack, HM_Category needle)
    {
        return haystack.Find(needle) != haystack.Size();
    }

    bool AreCategoriesOverlapping(Array<HM_Category> a, Array<HM_Category> b)
    {
        // Yay, O(n^2)
        for(let i = 0; i < a.Size(); i++)
        {
            let currentA = a[i];
            for(let j = 0; j < b.Size(); j++)
            {
                let currentB = b[j];

                if(currentA == currentB)
                {
                    return true;
                }
            }
        }

        return false;
    }

    // Merges a list of new additions into an existing array
    // While maintaining the orderliness of the target array
    void MergeInCategories(Array<HM_Category> target, Array<HM_Category> additions)
    {
        // TODO: Optimize, this can be done in one pass
        for(let i = 0; i < additions.Size(); i++)
        {
            let currentAddition = additions[i];
            if(currentAddition == HM_CAT_DOOM2 || currentAddition == HM_CAT_NOFIRSTMAP)
            {
                // The categories never count as overlaps
                continue;
            }

            for(let j = 0; j < target.Size(); j++)
            {
                let currentTarget = target[j];
                if(currentAddition == currentTarget)
                {
                    // This addition is already in the target array
                    break;
                }
                else if (currentAddition > currentTarget)
                {
                    // Merge the element BEFORE the current element.
                    target.Insert(j, currentAddition);
                }
            }
        }
    }

    // Categories must be always ordered in ascending numeric order (to make matching operations more efficient)
    bool ValidateCategoryOrder(Array<HM_Category> categories)
    {
        let highestSoFar = -1;
        for(let i = 0; i < categories.Size(); i++)
        {
            let current = categories[i];
            if(highestSoFar >= current)
            {
                console.printf("Categories order error. Highest so far: %d, Current: %d", highestSoFar, current);
                return false;
            }
        }

        return true;
    }

    string CategoriesToString(Array<HM_Category> categories)
    {
        if(categories.Size() == 0)
        {
            return "EMPTY";
        }

        let str = "";
        for(let i = 0; i < categories.Size(); i++)
        {
            str.AppendFormat("|%s", CategoryToString(categories[i]));
        }

        return str.Mid(1, str.Length() - 1); // Strip the initial "|"; 
    }

    string CategoryToString(HM_Category category)
    {
        if((category == HM_CAT_NONE)) return ("NONE");

        if((category == HM_CAT_DOOM2)) return ("DOOM2");
        if((category == HM_CAT_NOFIRSTMAP)) return ("NOFIRSTMAP");

        if((category == HM_CAT_META)) return ("META");
        if((category == HM_CAT_PLAYER)) return ("PLAYER");
        if((category == HM_CAT_DMGFLOOR)) return ("DMGFLOOR");
        if((category == HM_CAT_BARREL)) return ("BARREL");
        if((category == HM_CAT_HEALTH)) return ("HEALTH");
        if((category == HM_CAT_ARMOR)) return ("ARMOR");
        if((category == HM_CAT_AMMO)) return ("AMMO");

        if((category == HM_CAT_FIST)) return ("FIST");
        if((category == HM_CAT_PISTOL)) return ("PISTOL");
        if((category == HM_CAT_SHOTGUN)) return ("SHOTGUN");
        if((category == HM_CAT_SUPERSHOTGUN)) return ("SUPERSHOTGUN");
        if((category == HM_CAT_CHAINGUN)) return ("CHAINGUN");
        if((category == HM_CAT_ROCKETLAUNCHER)) return ("ROCKETLAUNCHER");
        if((category == HM_CAT_PLASMAGUN)) return ("PLASMAGUN");
        if((category == HM_CAT_BFG)) return ("BFG");

        if((category == HM_CAT_ALLMONSTERS)) return ("ALLMONSTERS");
        if((category == HM_CAT_ZOMBIEMAN)) return ("ZOMBIEMAN");
        if((category == HM_CAT_SHOTGUNNER)) return ("SHOTGUNNER");
        if((category == HM_CAT_CHAINGUNNER)) return ("CHAINGUNNER");
        if((category == HM_CAT_IMP)) return ("IMP");
        if((category == HM_CAT_PINKY)) return ("PINKY");
        if((category == HM_CAT_REVENANT)) return ("REVENANT");
        if((category == HM_CAT_CACODEMON)) return ("CACODEMON");
        if((category == HM_CAT_LOSTSOUL)) return ("LOSTSOUL");
        if((category == HM_CAT_PAINELEMENTAL)) return ("PAINELEMENTAL");
        if((category == HM_CAT_HELLKNIGHT)) return ("HELLKNIGHT");
        if((category == HM_CAT_BARONOFHELL)) return ("BARONOFHELL");
        if((category == HM_CAT_MANCUBUS)) return ("MANCUBUS");
        if((category == HM_CAT_ARCHVILE)) return ("ARCHVILE");
        if((category == HM_CAT_ARACHNOTRON)) return ("ARACHNOTRON");
        if((category == HM_CAT_SPIDERMASTERMIND)) return ("SPIDERMASTERMIND");
        if((category == HM_CAT_CYBERDEMON)) return ("CYBERDEMON");
        if((category == HM_CAT_BOSSBRAIN)) return ("BOSSBRAIN");

        if((category == HM_CAT_BLURSPHERE)) return ("BLURSPHERE");
        if((category == HM_CAT_SOULSPHERE)) return ("SOULSPHERE");
        if((category == HM_CAT_MEGASPHERE)) return ("MEGASPHERE");
        if((category == HM_CAT_BACKPACK)) return ("BACKPACK");
        if((category == HM_CAT_BERSERK)) return ("BERSERK");
        if((category == HM_CAT_RADSUIT)) return ("RADSUIT");
        if((category == HM_CAT_KEY)) return ("KEY");

        return string.format("UNKNOWN(%d)", category);
    }

    // bool AddCategoriesTo(Array<HM_Category> from, Array<HM_Category> to)
    // {
    //     for(let i = 0; i < from.Size(); i++)
    //     {
            
    //     }
    // }
}