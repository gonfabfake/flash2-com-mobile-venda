package sanXiao
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.CoreController;
   import ddt.events.CEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.GameInSocketOut;
   import ddt.utils.HelperDataModuleLoad;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.Event;
   import sanXiao.game.SanXiaoGameMediator;
   import sanXiao.view.SanXiaoMainView;
   
   public class SanXiaoController extends CoreController
   {
      
      private static var instance:SanXiaoController;
      
      private var _manager:SanXiaoManager;
      
      private var _sanxiaoMainView:SanXiaoMainView;
      
      private var _eventsLists:Array;
      
      public function SanXiaoController(param1:inner)
      {
         this._eventsLists = [["sanxiao_map_status",this.onMapStatus],["sanxiao_update_data",this.onViewUpdate],["sanxiao_drop_out_item_gained",this.onDropOutItemUpdate]];
         super();
      }
      
      public static function getInstance() : SanXiaoController
      {
         if(!instance)
         {
            instance = new SanXiaoController(new inner());
         }
         return instance;
      }
      
      public function setup() : void
      {
         this._manager = SanXiaoManager.getInstance();
         addEvents(["sanxiao_show_view"],this._manager);
      }
      
      override protected function eventsHandler(param1:CEvent) : void
      {
         var _loc2_:* = param1.type;
         if("sanxiao_show_view" === _loc2_)
         {
            this.onShowView(param1);
         }
      }
      
      private function onShowView(param1:CEvent) : void
      {
         if(Boolean(this._sanxiaoMainView))
         {
            this._sanxiaoMainView = null;
         }
         new HelperUIModuleLoad().loadUIModule(["sanxiao"],this.onResLoaded);
      }
      
      private function onResLoaded() : void
      {
         new HelperDataModuleLoad().loadDataModule([StartupResourceLoader.Instance.createSanXiaoScoreRewardDataLoader,StartupResourceLoader.Instance.createSanXiaoStoreDataLoader],this.onDataLoaded);
      }
      
      private function onDataLoaded() : void
      {
         this._sanxiaoMainView = ComponentFactory.Instance.creatComponentByStylename("sanxiao.frame");
         LayerManager.Instance.addToLayer(this._sanxiaoMainView,3,true,1);
         this.mainViewInited();
         GameInSocketOut.sendSXRequireMapInfo();
         GameInSocketOut.sendSXRequireViewData();
      }
      
      protected function onRFS(param1:Event) : void
      {
         this.mainViewDisposed();
      }
      
      private function mainViewInited() : void
      {
         !this._sanxiaoMainView.hasEventListener("removedFromStage") && this._sanxiaoMainView.addEventListener("removedFromStage",this.onRFS);
         this._manager = SanXiaoManager.getInstance();
         addEventsMap(this._eventsLists,this._manager);
      }
      
      private function mainViewDisposed() : void
      {
         this._sanxiaoMainView.hasEventListener("removedFromStage") && this._sanxiaoMainView.removeEventListener("removedFromStage",this.onRFS);
         removeEventsMap(this._eventsLists,this._manager);
         this._sanxiaoMainView = null;
      }
      
      private function onDropOutItemUpdate(param1:CEvent) : void
      {
         this._sanxiaoMainView && this._sanxiaoMainView.updateDropOutItem();
      }
      
      private function onViewUpdate(param1:CEvent) : void
      {
         this._sanxiaoMainView && this._sanxiaoMainView.update();
      }
      
      private function onMapStatus(param1:CEvent) : void
      {
         SanXiaoGameMediator.getInstance().startGame();
      }
      
      public function lockFrame() : void
      {
         if(this._sanxiaoMainView != null && this._sanxiaoMainView.parent != null)
         {
            this._sanxiaoMainView.closeButton.enable = false;
            this._sanxiaoMainView.closeButton.mouseEnabled = false;
            this._sanxiaoMainView.autoExit = false;
            this._sanxiaoMainView.lockProps();
         }
      }
      
      public function unLockFrame() : void
      {
         if(this._sanxiaoMainView != null && this._sanxiaoMainView.parent != null)
         {
            this._sanxiaoMainView.closeButton.enable = true;
            this._sanxiaoMainView.closeButton.mouseEnabled = true;
            this._sanxiaoMainView.autoExit = true;
            this._sanxiaoMainView.unLockProps();
         }
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
