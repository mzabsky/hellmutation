// See https://aka.ms/new-console-template for more information

using System.Text.RegularExpressions;

Console.WriteLine(string.Join("|", args));

var inputFileName = args[0];
var outputFileName = args[1];
var contents = File.ReadAllText(inputFileName);

var matches = Regex.Matches(
    contents,
    @"AddMutationDefinition\(\s*\""(?<key>[^""]+)\"",\s*\""(?<name>[^""]+)\"",\s*(?<categories>[^,]+),\s*\""(?<description>[^""]+)\"""
);

using var streamWriter = new StreamWriter(outputFileName);
streamWriter.WriteLine("# Mutations");
foreach (Match match in matches)
{
    streamWriter.WriteLine($"## {match.Groups["name"]}");
    streamWriter.WriteLine();

    var categories = match
        .Groups["categories"].ToString()
        .Split("|")
        .Select(categoryIdentifier =>
        {
            switch (categoryIdentifier.Trim())
            {
                case "HM_CAT_DOOM2":
                    return "Doom 2 only";
                case "HM_CAT_NOFIRSTMAP":
                    return "Not first map";
                case "HM_CAT_PLAYER":
                    return "Player";
                case "HM_CAT_DMGFLOOR":
                    return "Damaging floor";
                case "HM_CAT_BARREL":
                    return "Barrel";
                case "HM_CAT_ALLMONSTERS":
                    return "All monsters";
                case "HM_CAT_ZOMBIEMAN":
                    return "Zombieman";
                case "HM_CAT_SHOTGUNNER":
                    return "Shotgunner";
                case "HM_CAT_CHAINGUNNER":
                    return "Chaingunner";
                case "HM_CAT_IMP":
                    return "Imp";
                case "HM_CAT_PINKY":
                    return "Pinky";
                case "HM_CAT_REVENANT":
                    return "Revenant";
                case "HM_CAT_CACODEMON":
                    return "Cacodemon";
                case "HM_CAT_LOSTSOUL":
                    return "Lost Soul";
                case "HM_CAT_PAINELEMENTAL":
                    return "Pain Elemental";
                case "HM_CAT_HELLKNIGHT":
                    return "Hell Knight";
                case "HM_CAT_BARONOFHELL":
                    return "Baron of Hell";
                case "HM_CAT_MANCUBUS":
                    return "Mancubus";
                case "HM_CAT_ARCHVILE":
                    return "Arch-Vile";
                case "HM_CAT_ARACHNOTRON":
                    return "Arachnotron";
                case "HM_CAT_SPIDERMASTERMIND":
                    return "Spider Mastermind";
                case "HM_CAT_CYBERDEMON":
                    return "Cyberdemon";
                case "HM_CAT_BOSSBRAIN":
                    return "Boss Brain (Icon of Sin)";
                default:
                    throw new Exception("Unknown category " + categoryIdentifier.Trim() + " in mutation " + match.Groups["name"]);
            }
        });
    
    streamWriter.WriteLine($"**Applies to**: {string.Join(", ", categories)}&emsp;&emsp;&emsp;**Key**: `{match.Groups["key"]}`");
    streamWriter.WriteLine();
    streamWriter.WriteLine($"{match.Groups["description"].ToString().Replace("\\n", " ")}");
    streamWriter.WriteLine();
    streamWriter.WriteLine();
}

Console.WriteLine("Done");