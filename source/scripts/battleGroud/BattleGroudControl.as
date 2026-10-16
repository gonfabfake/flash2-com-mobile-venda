package battleGroud
{
   import battleGroud.data.BattlPrestigeData;
   import battleGroud.data.BattleUpdateData;
   import battleGroud.data.BattleWeeklyAwardAnalyzer;
   import battleGroud.data.PlayerBattleData;
   import battleGroud.view.BattleGroudView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import ddt.manager.BattleGroudManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperDataModuleLoad;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   
   public class BattleGroudControl
   {
      
      private static var _instance:BattleGroudControl;
      
      private var _battlGroudView:BattleGroudView;
      
      private var _moduleComplete:Boolean;
      
      public var orderdata:BattleUpdateData;
      
      private var _isBattleUILoaded:Boolean;
      
      private var _battlePresDataList:Vector.<BattlPrestigeData>;
      
      public var playerBattleData:PlayerBattleData;
      
      public var awardDataList:Array;
      
      public function BattleGroudControl()
      {
         super();
         this.orderdata = new BattleUpdateData();
      }
      
      public static function get Instance() : BattleGroudControl
      {
         if(!_instance)
         {
            _instance = new BattleGroudControl();
         }
         return _instance;
      }
      
      private function realTimeUpdataValue(param1:PkgEvent) : void
      {
      }
      
      private function updataValue(param1:PkgEvent) : void
      {
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function sendPkg() : void
      {
      }
      
      private function initEvent() : void
      {
         BattleGroudManager.Instance.addEventListener("battleOpenView",this.__onOpenView);
         SocketManager.Instance.addEventListener(PkgEvent.format(132,3),this.updataValue);
         SocketManager.Instance.addEventListener(PkgEvent.format(132,4),this.realTimeUpdataValue);
         SocketManager.Instance.addEventListener(PkgEvent.format(132,5),this.playerDataUpDate);
      }
      
      protected function __onOpenView(param1:CEvent) : void
      {
         if(param1.data == "battleground")
         {
            this.initBattleView();
         }
         else if(param1.data == "ddtroom")
         {
            this.addBattleSingleRoom();
         }
      }
      
      protected function playerDataUpDate(param1:PkgEvent) : void
      {
         this.playerBattleData = new PlayerBattleData();
         this.playerBattleData.Attack = param1.pkg.readInt();
         this.playerBattleData.Defend = param1.pkg.readInt();
         this.playerBattleData.Agility = param1.pkg.readInt();
         this.playerBattleData.Lucky = param1.pkg.readInt();
         this.playerBattleData.Damage = param1.pkg.readInt();
         this.playerBattleData.Guard = param1.pkg.readInt();
         this.playerBattleData.Blood = param1.pkg.readInt();
         this.playerBattleData.Energy = param1.pkg.readInt();
         this.playerBattleData.ID = PlayerManager.Instance.Self.ID;
      }
      
      public function CelebByTotalPrestige() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.creatAndStartLoad(PathManager.solveRequestPath("CelebByTotalPrestige.xml"),5);
         _loc1_.analyzer = new CeleTotalPrestigeAnalyer(this.completeHander2);
         return _loc1_;
      }
      
      public function completeHander2(param1:CeleTotalPrestigeAnalyer) : void
      {
         this._battlePresDataList = param1.battleDataList;
         this.sendPkg();
      }
      
      public function getCurrBattlePresData(param1:int) : BattlPrestigeData
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._battlePresDataList.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this._battlePresDataList[_loc2_].ID)
            {
               return this._battlePresDataList[_loc2_];
            }
            _loc2_++;
         }
         return new BattlPrestigeData();
      }
      
      private function loadeDataComplete() : void
      {
         this.show();
      }
      
      public function initBattleView() : void
      {
         if(Boolean(this._battlGroudView) && Boolean(this._battlGroudView.parent))
         {
            this.hide();
         }
         else if(this._moduleComplete)
         {
            this.loadDataTemplate(this.show);
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp("battleground");
         }
      }
      
      public function addBattleSingleRoom() : void
      {
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == "battleground")
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function loadDataTemplate(param1:Function) : void
      {
         var _loc2_:Array = [this.CelebByTotalPrestige(),this.FairBatttleWeeklyAwardTemp()];
         new HelperDataModuleLoad().loadDataModule(_loc2_,param1);
      }
      
      public function FairBatttleWeeklyAwardTemp() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FairBatttleWeeklyAwardTemp.xml"),5);
         _loc1_.analyzer = new BattleWeeklyAwardAnalyzer(this.dataAnalyzer);
         return _loc1_;
      }
      
      private function dataAnalyzer(param1:BattleWeeklyAwardAnalyzer) : void
      {
         this.awardDataList = param1.dataList;
      }
      
      public function show() : void
      {
         if(Boolean(this._battlGroudView))
         {
            ObjectUtils.disposeObject(this._battlGroudView);
            this._battlGroudView = null;
         }
         this._battlGroudView = ComponentFactory.Instance.creatComponentByStylename("battleGroud.battleGroudView");
         LayerManager.Instance.addToLayer(this._battlGroudView,3,true,2);
      }
      
      public function hide() : void
      {
         if(Boolean(this._battlGroudView))
         {
            this._battlGroudView.dispose();
         }
         this._battlGroudView = null;
      }
      
      private function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == "battleground")
         {
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__onUIModuleComplete);
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            this._moduleComplete = true;
            UIModuleSmallLoading.Instance.hide();
            this.loadDataTemplate(this.show);
         }
         else if(param1.module == "ddtroom")
         {
         }
      }
      
      private function __onClose(param1:Event) : void
      {
         this._moduleComplete = false;
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__onProgress);
      }
   }
}

