package levelFund
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.view.LevelFundIcon;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import levelFund.event.LevelFundEvent;
   import levelFund.model.LevelFundModel;
   import road7th.comm.PackageIn;
   
   public class LevelFundManager extends EventDispatcher
   {
      
      private static var _instance:LevelFundManager;
      
      private var _model:LevelFundModel;
      
      private var _frame:Frame;
      
      private var _levelFundActivityIcon:LevelFundIcon;
      
      private var _hallView:HallStateView;
      
      public function LevelFundManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : LevelFundManager
      {
         if(_instance == null)
         {
            _instance = new LevelFundManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new LevelFundModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LEVEL_FUND,this.__levelFundHandler);
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.LEVELFUND);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LEVELFUND)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LEVELFUND)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("levelFund.LevelFundFrame");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         }
      }
      
      public function addLevelFundActivityBtn(param1:HallStateView) : void
      {
         this._hallView = param1;
         if(this._model.isOpen)
         {
            this.initBtn();
         }
      }
      
      private function initBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler("levelfund",true);
      }
      
      public function deleteBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler("levelfund",false);
      }
      
      private function __levelFundHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readByte();
         if(_loc2_ == 1)
         {
            this.getInfoHandler(param1.pkg);
         }
         else if(_loc2_ == 2)
         {
            this.buyLevelFundHandler(param1.pkg);
         }
         else if(_loc2_ == 3)
         {
            this.getAwardLevelFundHandler(param1.pkg);
         }
      }
      
      private function getInfoHandler(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = this.model.isOpen;
         this.model.isOpen = param1.readBoolean();
         if(this.model.isOpen)
         {
            this.model.buyType = param1.readInt();
            _loc2_ = param1.readInt();
            this.model.dataArr = [];
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = param1.readInt();
               _loc5_ = param1.readInt();
               _loc6_ = param1.readInt();
               this.model.dataArr.push({
                  "level":_loc4_,
                  "money":_loc5_,
                  "state":_loc6_
               });
               _loc3_++;
            }
            dispatchEvent(new LevelFundEvent("update_view"));
            if(!_loc7_)
            {
               this.initBtn();
            }
         }
         else
         {
            this.deleteBtn();
         }
      }
      
      private function buyLevelFundHandler(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("levelFund.buyLevelFund.successMsg"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("levelFund.buyLevelFund.errorMsg"));
         }
      }
      
      private function getAwardLevelFundHandler(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("levelFund.getAwardLevelFund.successMsg"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("levelFund.getAwardLevelFund.errorMsg"));
         }
      }
      
      public function get levelFundActivityIcon() : LevelFundIcon
      {
         return this._levelFundActivityIcon;
      }
      
      public function get model() : LevelFundModel
      {
         return this._model;
      }
   }
}

