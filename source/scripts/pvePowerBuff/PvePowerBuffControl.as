package pvePowerBuff
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.EventDispatcher;
   
   public class PvePowerBuffControl extends EventDispatcher
   {
      
      private static var _instance:PvePowerBuffControl;
      
      public static const SELECT_PLAYER:String = "select_player";
      
      private var _uiLoader:HelperUIModuleLoad;
      
      public var mainView:PvePowerBuffMainView;
      
      public function PvePowerBuffControl(param1:pvppowerbuffinstance)
      {
         super();
      }
      
      public static function get instance() : PvePowerBuffControl
      {
         if(_instance == null)
         {
            _instance = new PvePowerBuffControl(new pvppowerbuffinstance());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         PvePowerBuffManager.instance.addEventListener("pvePowerBuffOpenView",this.__openView);
         PvePowerBuffManager.instance.addEventListener("pvePowerBuffDispose",this.__disposeView);
      }
      
      private function __openView(param1:PvePowerBuffEvent) : void
      {
         this._uiLoader = new HelperUIModuleLoad();
         this._uiLoader.loadUIModule(["pvePowerBuff"],this.__openPvePowerBuffView);
      }
      
      private function __openPvePowerBuffView() : void
      {
         this._uiLoader = null;
         this.mainView = ComponentFactory.Instance.creatCustomObject("pvePowerBuffMainView");
         var _loc1_:PvePowerBuffEvent = new PvePowerBuffEvent("pvePowerBuffLoadComplete");
         _loc1_.info = this.mainView;
         PvePowerBuffManager.instance.dispatchEvent(_loc1_);
      }
      
      private function __disposeView(param1:PvePowerBuffEvent) : void
      {
         this.mainView = null;
      }
   }
}

class pvppowerbuffinstance
{
   
   public function pvppowerbuffinstance()
   {
      super();
   }
}
