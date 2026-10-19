package godsRoads.manager
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import godsRoads.analyze.GodsRoadsDataAnalyzer;
   import godsRoads.data.GodsRoadsMissionVo;
   import godsRoads.data.GodsRoadsPkgType;
   import godsRoads.data.GodsRoadsStepVo;
   import godsRoads.data.GodsRoadsVo;
   import godsRoads.model.GodsRoadsModel;
   import godsRoads.view.GodsRoadsView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GodsRoadsManager extends EventDispatcher
   {
      
      private static var _instance:GodsRoadsManager;
      
      public var _model:GodsRoadsModel;
      
      private var _isOpen:Boolean = false;
      
      public var _view:GodsRoadsView;
      
      private var _func:Function;
      
      private var _xml:XML;
      
      private var _funcParams:Array = [];
      
      public var lastStep:int = 0;
      
      public var lastMssion:int = 0;
      
      public function GodsRoadsManager(param1:PrivateClass)
      {
         super();
         this._model = new GodsRoadsModel();
      }
      
      public static function get instance() : GodsRoadsManager
      {
         if(GodsRoadsManager._instance == null)
         {
            GodsRoadsManager._instance = new GodsRoadsManager(new PrivateClass());
         }
         return GodsRoadsManager._instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GODS_ROADS,this.pkgHandler);
      }
      
      public function loadGodsRoadsModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GODSROADS);
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GODSROADS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GODSROADS)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:Boolean = false;
         _loc2_ = param1.pkg;
         var _loc4_:int = param1._cmd;
         switch(_loc4_)
         {
            case GodsRoadsPkgType.GODS_ROADS_OPEN:
               this._isOpen = _loc2_.readBoolean();
               if(this._isOpen)
               {
                  this.showGodsRoads();
               }
               else
               {
                  this.hideGodsRoadsIcon();
               }
               break;
            case GodsRoadsPkgType.ENTER_GODS_ROADS:
               this.doOpenGodsRoads(_loc2_);
               break;
            case GodsRoadsPkgType.GET_AWARDS:
               _loc3_ = _loc2_.readBoolean();
               if(_loc3_)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.godsRoads.getawards"));
               }
               this.sendEnter();
         }
      }
      
      public function changeSteps(param1:int) : void
      {
         this._view.changeSteps(param1);
      }
      
      public function templateDataSetup(param1:DataAnalyzer) : void
      {
         if(param1 is GodsRoadsDataAnalyzer)
         {
            this._model.missionInfo = GodsRoadsDataAnalyzer(param1).dataList;
         }
         dispatchEvent(new Event("XMLdata_Complete"));
      }
      
      public function showGodsRoads() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.GODSROADS,true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.GODSROADS,true,10);
         }
      }
      
      private function hideGodsRoadsIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GODSROADS,false);
         HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.GODSROADS,false);
      }
      
      public function openGodsRoads(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.Grade < 10)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
            return;
         }
         this.loadGodsRoadsModule(this.sendEnter);
      }
      
      private function sendEnter() : void
      {
         SocketManager.Instance.out.enterGodsRoads();
      }
      
      private function doOpenGodsRoads(param1:PackageIn) : void
      {
         var _loc2_:GodsRoadsStepVo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:GodsRoadsMissionVo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ItemTemplateInfo = null;
         var _loc9_:InventoryItemInfo = null;
         var _loc10_:int = 0;
         var _loc11_:ItemTemplateInfo = null;
         var _loc12_:InventoryItemInfo = null;
         this._model.godsRoadsData = new GodsRoadsVo();
         var _loc13_:GodsRoadsVo = this._model.godsRoadsData;
         _loc13_.Level = param1.readInt();
         _loc13_.currentLevel = param1.readInt();
         _loc13_.steps = new Vector.<GodsRoadsStepVo>();
         var _loc14_:int = 0;
         while(_loc14_ < _loc13_.Level)
         {
            _loc2_ = new GodsRoadsStepVo();
            _loc2_.isGetAwards = param1.readBoolean();
            _loc2_.missionsNum = param1.readInt();
            _loc2_.currentStep = _loc14_ + 1;
            _loc2_.awards = [];
            _loc2_.missionVos = [];
            _loc3_ = 0;
            while(_loc3_ < _loc2_.missionsNum)
            {
               _loc5_ = new GodsRoadsMissionVo();
               _loc5_.ID = param1.readInt();
               _loc5_.isFinished = param1.readBoolean();
               _loc5_.condition1 = param1.readInt();
               _loc5_.condition2 = param1.readInt();
               _loc5_.condition3 = param1.readInt();
               _loc5_.condition4 = param1.readInt();
               _loc5_.isGetAwards = param1.readBoolean();
               _loc5_.awardsNum = param1.readInt();
               _loc5_.awards = [];
               _loc6_ = 0;
               while(_loc6_ < _loc5_.awardsNum)
               {
                  _loc7_ = param1.readInt();
                  _loc8_ = ItemManager.Instance.getTemplateById(_loc7_);
                  _loc9_ = new InventoryItemInfo();
                  ObjectUtils.copyProperties(_loc9_,_loc8_);
                  _loc9_.TemplateID = _loc7_;
                  _loc9_.StrengthenLevel = param1.readInt();
                  _loc9_.Count = param1.readInt();
                  _loc9_.ValidDate = param1.readInt();
                  _loc9_.AttackCompose = param1.readInt();
                  _loc9_.DefendCompose = param1.readInt();
                  _loc9_.AgilityCompose = param1.readInt();
                  _loc9_.LuckCompose = param1.readInt();
                  _loc9_.IsBinds = param1.readBoolean();
                  _loc5_.awards.push(_loc9_);
                  _loc6_++;
               }
               _loc2_.missionVos.push(_loc5_);
               _loc3_++;
            }
            _loc13_.steps.push(_loc2_);
            _loc2_.awadsNum = param1.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.awadsNum)
            {
               _loc10_ = param1.readInt();
               _loc11_ = ItemManager.Instance.getTemplateById(_loc10_);
               _loc12_ = new InventoryItemInfo();
               ObjectUtils.copyProperties(_loc12_,_loc11_);
               _loc12_.TemplateID = _loc10_;
               _loc12_.StrengthenLevel = param1.readInt();
               _loc12_.Count = param1.readInt();
               _loc12_.ValidDate = param1.readInt();
               _loc12_.AttackCompose = param1.readInt();
               _loc12_.DefendCompose = param1.readInt();
               _loc12_.AgilityCompose = param1.readInt();
               _loc12_.LuckCompose = param1.readInt();
               _loc12_.IsBinds = param1.readBoolean();
               _loc2_.awards.push(_loc12_);
               _loc4_++;
            }
            _loc14_++;
         }
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creat("godsRoads.GodsRoadsView");
            this._view.initView();
            this._view.titleText = LanguageMgr.GetTranslation("ddt.godsRoads.title");
            this._view.addEventListener(Event.REMOVED_FROM_STAGE,this.disposeView);
            LayerManager.Instance.addToLayer(this._view,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._view.updateView(this._model,this.lastStep,this.lastMssion);
      }
      
      private function disposeView(param1:Event) : void
      {
         this._view.removeEventListener(Event.REMOVED_FROM_STAGE,this.disposeView);
         this._view = null;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get XMLData() : XML
      {
         return this._xml;
      }
      
      public function set XMLData(param1:XML) : void
      {
         this._xml = param1;
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
