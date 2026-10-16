package condiscount
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import condiscount.model.CondiscountModel;
   import condiscount.view.CondiscountFrame;
   import ddt.CoreManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.IEventDispatcher;
   import hallIcon.HallIconManager;
   
   public class CondiscountManager extends CoreManager
   {
      
      private static var _instance:CondiscountManager;
      
      public var model:CondiscountModel;
      
      private var _frame:CondiscountFrame;
      
      public function CondiscountManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : CondiscountManager
      {
         if(_instance == null)
         {
            _instance = new CondiscountManager();
         }
         return _instance;
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["condiscount"],this.onComplete);
      }
      
      private function onComplete() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("condiscount.MainFrame");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      public function setup() : void
      {
         this.model = new CondiscountModel();
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("condiscount",this.model.isOpen);
      }
   }
}

