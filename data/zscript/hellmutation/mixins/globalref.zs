mixin class HM_GlobalRef
{
    HM_GlobalEventHandler global;
    
    override void BeginPlay()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));

        super.BeginPlay();
    }
}