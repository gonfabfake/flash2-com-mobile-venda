package panicBuying
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import panicBuying.event.PanicBuyingEvent;
   import panicBuying.views.PanicBuyingFrame;
   
   public class PanicBuyingControl
   {
      
      private static var _instance:PanicBuyingControl;
      
      private var _frame:PanicBuyingFrame;
      
      public function PanicBuyingControl()
      {
         super();
      }
      
      public static function get instance() : PanicBuyingControl
      {
         if(!_instance)
         {
            _instance = new PanicBuyingControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         PanicBuyingManager.instance.addEventListener("panicBuyingOpenView",this.__panicBuyingOpenView);
         PanicBuyingManager.instance.addEventListener("updateView",this.__updateView);
      }
      
      protected function __updateView(param1:PanicBuyingEvent) : void
      {
         if(Boolean(this._frame))
         {
            this._frame.refreshActivity();
         }
      }
      
      protected function __panicBuyingOpenView(param1:PanicBuyingEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.openPanicBuyingFrame);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PANIC_BUYING);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PANIC_BUYING)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function openPanicBuyingFrame(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PANIC_BUYING)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("panicBuying.frame");
            LayerManager.Instance.addToLayer(this._frame,3,true,1,true);
            SocketManager.Instance.out.requestWonderfulActInit(2);
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.openPanicBuyingFrame);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         }
      }
   }
}

