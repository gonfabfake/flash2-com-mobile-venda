package godOfWealth
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.LayerManager;
   import ddt.CoreController;
   import ddt.events.CEvent;
   import ddt.manager.GameInSocketOut;
   import godOfWealth.view.GodOfWealthMainView;
   
   public class GodOfWealthController extends CoreController
   {
      
      private static var instance:GodOfWealthController;
      
      private var _godOfWealthView:GodOfWealthMainView;
      
      public function GodOfWealthController(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : GodOfWealthController
      {
         if(!instance)
         {
            instance = new GodOfWealthController(new inner());
         }
         return instance;
      }
      
      public function setup() : void
      {
         GodOfWealthManager.getInstance().addEventListener("gow_open_view",this.onOpenView);
         GodOfWealthManager.getInstance().addEventListener("gow_update",this.onUpdate);
         GodOfWealthManager.getInstance().addEventListener("gow_result_suc",this.onResultSuc);
      }
      
      private function onOpenView(param1:CEvent) : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.onViewLoaded);
         UIModuleLoader.Instance.addUIModuleImp("godOfWealth");
      }
      
      private function onViewLoaded(param1:UIModuleEvent) : void
      {
         if(param1.module == "godOfWealth")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.onViewLoaded);
            GameInSocketOut.sendGodOfWealthInfo();
            this._godOfWealthView = new GodOfWealthMainView();
            LayerManager.Instance.addToLayer(this._godOfWealthView,3,true,1);
         }
      }
      
      private function onUpdate(param1:CEvent) : void
      {
         if(Boolean(this._godOfWealthView) && Boolean(this._godOfWealthView.parent))
         {
            this._godOfWealthView.update();
         }
      }
      
      private function onResultSuc(param1:CEvent) : void
      {
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
