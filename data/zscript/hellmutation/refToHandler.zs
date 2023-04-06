mixin class RefToHandler
{
    HM_GlobalEventHandler global;
    
    override void PostBeginPlay()
    {
        global = HM_GlobalEventHandler(EventHandler.Find("HM_GlobalEventHandler"));
    }
}