package toyMachine
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import toyMachine.view.ToyMachineFrame;
   
   public class ToyMachineManager extends EventDispatcher
   {
      
      private static var _instance:ToyMachineManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _toyMachineFrame:ToyMachineFrame;
      
      public function ToyMachineManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : ToyMachineManager
      {
         if(!_instance)
         {
            _instance = new ToyMachineManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showToyFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp("toyMachine");
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "toyMachine")
         {
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "toyMachine")
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
      }
      
      private function showToyFrame() : void
      {
         this._toyMachineFrame = ComponentFactory.Instance.creatComponentByStylename("toyMachine.toyMachineFrame");
         LayerManager.Instance.addToLayer(this._toyMachineFrame,2,true,1);
      }
      
      public function hide() : void
      {
         if(this._toyMachineFrame != null)
         {
            this._toyMachineFrame.dispose();
            this._toyMachineFrame = null;
         }
      }
   }
}

