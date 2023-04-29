// This gets override by appropriate file in the filter directory if the IWAD supports
// Doom 2 features (like archviles, super shotgun and stuff)
class HM_DetectGame
{
    bool HasDoom2()
    {
        return false;
    }
}