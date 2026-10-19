package levelFund
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import levelFund.event.LevelFundEvent;
   import levelFund.view.LevelFundFrame;
   
   public class LevelFundControl extends EventDispatcher
   {
      
      private static var _instance:LevelFundControl;
      
      private var _frame:LevelFundFrame;
      
      private var _isLoaded:Boolean = false;
      
      public function LevelFundControl(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : LevelFundControl
      {
         if(_instance == null)
         {
            _instance = new LevelFundControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         LevelFundManager.instance.addEventListener("levelFundOpenView",this.__onOpenView);
      }
      
      protected function __onOpenView(param1:LevelFundEvent) : void
      {
         if(this._isLoaded)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("levelFund.LevelFundFrame");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LEVELFUND);
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LEVELFUND)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler() : void
      {
         this._isLoaded = true;
         this._frame = ComponentFactory.Instance.creatComponentByStylename("levelFund.LevelFundFrame");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
   }
}

