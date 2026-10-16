package farm
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.utils.MD5;
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.chat.ChatData;
   import farm.analyzer.FarmFriendListAnalyzer;
   import farm.analyzer.FarmTreePoultryListAnalyzer;
   import farm.analyzer.FoodComposeListAnalyzer;
   import farm.analyzer.SuperPetFoodPriceAnalyzer;
   import farm.control.FarmComposeHouseController;
   import farm.modelx.FieldVO;
   import farm.modelx.SuperPetFoodPriceInfo;
   import flash.events.TimerEvent;
   import flash.net.URLVariables;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   
   public class FarmModelController extends CoreManager
   {
      
      private static var _instance:FarmModelController;
      
      public static var MAXLEVEL:int = 0;
      
      private var _model:FarmModel;
      
      private var _timer:Timer;
      
      private var _canGoFarm:Boolean = true;
      
      private var _landInfoVector:Vector.<FieldVO>;
      
      public var gropPrice:int;
      
      public var midAutumnFlag:Boolean;
      
      public var FightPoultryFlag:Boolean;
      
      public function FarmModelController()
      {
         super();
      }
      
      public static function get instance() : FarmModelController
      {
         return _instance || (_instance = new FarmModelController());
      }
      
      public function setup() : void
      {
         this._model = new FarmModel();
         this._landInfoVector = new Vector.<FieldVO>();
         this.initEvent();
         FarmComposeHouseController.instance().setup();
      }
      
      public function get model() : FarmModel
      {
         return this._model;
      }
      
      public function stopTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
         this._canGoFarm = true;
      }
      
      public function startTimer() : void
      {
         if(this._timer == null)
         {
            this._timer = new Timer(1000);
            this._timer.addEventListener("timer",this.__timerhandler);
         }
         this._timer.reset();
         this._timer.start();
      }
      
      public function sendEnterFarmPkg(param1:int) : void
      {
         SocketManager.Instance.out.enterFarm(param1);
         if(param1 == PlayerManager.Instance.Self.ID)
         {
            this.startTimer();
         }
      }
      
      public function goFarm(param1:int, param2:String) : void
      {
         if(PlayerManager.Instance.Self.ID == param1 && PlayerManager.Instance.Self.Grade < 25)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.goFarm.need20"));
            return;
         }
         if(this._canGoFarm)
         {
            this._model.currentFarmerName = param2;
            this.sendEnterFarmPkg(param1);
            this._canGoFarm = false;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.goFarm.internal"));
         }
      }
      
      public function sowSeed(param1:int, param2:int) : void
      {
         SocketManager.Instance.out.seeding(param1,param2);
      }
      
      public function accelerateField(param1:int, param2:int, param3:int) : void
      {
         SocketManager.Instance.out.doMature(param1,param2,param3);
      }
      
      public function getHarvest(param1:int) : void
      {
         SocketManager.Instance.out.toGather(this.model.currentFarmerId,param1);
      }
      
      public function payField(param1:Array, param2:int, param3:Boolean) : void
      {
         SocketManager.Instance.out.toSpread(param1,param2,param3);
      }
      
      public function updateFriendListStolen() : void
      {
         this.updateSetupFriendListStolen(this.model.currentFarmerId);
      }
      
      public function setupFoodComposeList(param1:FoodComposeListAnalyzer) : void
      {
         dispatchEvent(new FarmEvent("accelerateField"));
      }
      
      public function killCrop(param1:int) : void
      {
         SocketManager.Instance.out.toKillCrop(param1);
      }
      
      public function farmHelperSetSwitch(param1:Array, param2:Boolean) : void
      {
         SocketManager.Instance.out.toFarmHelper(param1,param2);
      }
      
      public function helperRenewMoney(param1:int, param2:Boolean) : void
      {
         SocketManager.Instance.out.toHelperRenewMoney(param1,param2);
      }
      
      public function arrange() : void
      {
         SocketManager.Instance.out.arrange(this._model.currentFarmerId);
      }
      
      public function exitFarm(param1:int) : void
      {
         SocketManager.Instance.out.exitFarm(param1);
      }
      
      public function openPayFieldFrame(param1:int) : void
      {
         dispatchEvent(new CEvent("openview",{
            "type":2,
            "fieldId":param1
         }));
      }
      
      public function getTreePoultryListData(param1:FarmTreePoultryListAnalyzer) : void
      {
         this._model.farmPoultryInfo = param1.list;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_LAND_INFO,this.__onFarmLandInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ENTER_FARM,this.__onEnterFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAIN_FIELD,this.__gainFieldHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEEDING,this.__onSeeding);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PAY_FIELD,this.__payField);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DO_MATURE,this.__onDoMature);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_SWITCH,this.__onHelperSwitch);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.KILL_CROP,this.__onKillCrop);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HELPER_PAY,this.__onHelperPay);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PLAYER_EXIT_FARM,this.__onExitFarm);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_PET_EXP_ITEM,this.__updateBuyExpExpNum);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INVITE_WAKE,this.__onInviteWake);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARMBOSS_FULLLEVEL,this.__onFarmBoosFullLevel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ARRANGE_FRIEND_FARM,this.__arrangeFriendFarmHandler);
      }
      
      private function __arrangeFriendFarmHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readInt();
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.arrange" + _loc2_));
         if(_loc2_ == 0)
         {
            this._model.isArrange = true;
         }
         else
         {
            this._model.isArrange = false;
         }
         dispatchEvent(new FarmEvent("arrangeFriendFarm"));
      }
      
      protected function __onFarmBoosFullLevel(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:ChatData = new ChatData();
         _loc2_.channel = 21;
         _loc2_.childChannelArr = [7,14];
         _loc2_.type = 110;
         _loc2_.msg = LanguageMgr.GetTranslation("farm.poultry.farmBossFullLevel");
         ChatManager.Instance.chat(_loc2_);
      }
      
      protected function __onInviteWake(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = PlayerManager.Instance.Self.Sex ? 2 : 1;
         var _loc3_:ChatData = new ChatData();
         _loc3_.channel = 21;
         _loc3_.childChannelArr = [7,14];
         _loc3_.type = 109;
         _loc3_.msg = LanguageMgr.GetTranslation("farm.poultry.inviteWake" + _loc2_,PlayerManager.Instance.Self.SpouseName);
         ChatManager.Instance.chat(_loc3_);
      }
      
      protected function __onFarmLandInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:int = _loc4_.readInt();
         this._landInfoVector.length = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = new FieldVO();
            _loc3_.fieldID = _loc4_.readInt();
            _loc3_.seedID = _loc4_.readInt();
            _loc3_.plantTime = _loc4_.readDate();
            _loc4_.readInt();
            _loc3_.AccelerateTime = _loc4_.readInt();
            this._landInfoVector.push(_loc3_);
            _loc2_++;
         }
         this.midAutumnFlag = _loc4_.readBoolean();
         this.model.selfFieldsInfo = this._landInfoVector;
      }
      
      protected function __updateBuyExpExpNum(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.buyExpRemainNum = _loc2_.readInt();
         dispatchEvent(new FarmEvent("updateBuyExpRemainNum"));
      }
      
      private function __timerhandler(param1:TimerEvent) : void
      {
         this._timer.currentCount % 120 == 0;
         if(this._timer.currentCount % 120 == 0)
         {
         }
         if(this._timer.currentCount % 60 == 0)
         {
            dispatchEvent(new FarmEvent("frushField"));
         }
         if(this._timer.currentCount % 2 == 0)
         {
            this._canGoFarm = true;
         }
      }
      
      private function __onEnterFarm(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null;
         var _loc11_:* = null;
         this.model.fieldsInfo = null;
         this.model.fieldsInfo = new Vector.<FieldVO>();
         var _loc12_:PackageIn = param1.pkg;
         this._model.currentFarmerId = _loc12_.readInt();
         var _loc13_:Boolean = _loc12_.readBoolean();
         var _loc14_:int = _loc12_.readInt();
         var _loc15_:Date = _loc12_.readDate();
         var _loc16_:int = _loc12_.readInt();
         var _loc17_:int = _loc12_.readInt();
         var _loc18_:int = _loc12_.readInt();
         var _loc19_:int = _loc12_.readInt();
         this.model.helperArray = [];
         this.model.helperArray.push(_loc13_);
         this.model.helperArray.push(_loc14_);
         this.model.helperArray.push(_loc15_);
         this.model.helperArray.push(_loc16_);
         this.model.helperArray.push(_loc17_);
         this.model.helperArray.push(_loc18_);
         _loc2_ = 0;
         while(_loc2_ < _loc19_)
         {
            _loc3_ = _loc12_.readInt();
            _loc4_ = _loc12_.readInt();
            _loc5_ = _loc12_.readDate();
            _loc6_ = _loc12_.readDate();
            _loc7_ = _loc12_.readInt();
            _loc8_ = _loc12_.readInt();
            _loc9_ = _loc12_.readInt();
            if(this.model.getfieldInfoById(_loc3_) == null)
            {
               _loc10_ = new FieldVO();
               _loc10_.fieldID = _loc3_;
               _loc10_.seedID = _loc4_;
               _loc10_.payTime = _loc5_;
               _loc10_.plantTime = _loc6_;
               _loc10_.fieldValidDate = _loc8_;
               _loc10_.AccelerateTime = _loc9_;
               _loc10_.gainCount = _loc7_;
               _loc10_.autoSeedID = _loc14_;
               _loc10_.isAutomatic = _loc13_;
               this.model.fieldsInfo.push(_loc10_);
            }
            else
            {
               _loc11_ = this.model.getfieldInfoById(_loc3_);
               _loc11_.seedID = _loc4_;
               _loc11_.payTime = _loc5_;
               _loc11_.plantTime = _loc6_;
               _loc11_.fieldValidDate = _loc8_;
               _loc11_.AccelerateTime = _loc9_;
               _loc11_.gainCount = _loc7_;
               _loc11_.autoSeedID = _loc14_;
               _loc11_.isAutomatic = _loc13_;
            }
            _loc2_++;
         }
         if(this._model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.gropPrice = _loc12_.readInt();
            this._model.payFieldMoney = _loc12_.readUTF();
            this._model.payAutoMoney = _loc12_.readUTF();
            this._model.autoPayTime = _loc12_.readDate();
            this._model.autoValidDate = _loc12_.readInt();
            this._model.vipLimitLevel = _loc12_.readInt();
            this._model.selfFieldsInfo = this._model.fieldsInfo.concat();
            this._model.isAutoId = _loc14_;
            this._model.buyExpRemainNum = _loc12_.readInt();
            PlayerManager.Instance.Self.isFarmHelper = _loc13_;
         }
         else
         {
            this._model.isArrange = _loc12_.readBoolean();
         }
         StateManager.setState(StateType.FARM);
         dispatchEvent(new FarmEvent("fieldsInfoReady"));
         SocketManager.Instance.out.getFarmPoultryLevel(FarmModelController.instance.model.currentFarmerId);
      }
      
      override protected function start() : void
      {
         dispatchEvent(new CEvent("openview",{"type":1}));
      }
      
      private function __gainFieldHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:FieldVO = null;
         var _loc3_:Boolean = param1.pkg.readBoolean();
         if(_loc3_)
         {
            this.model.gainFieldId = param1.pkg.readInt();
            _loc2_ = this.model.getfieldInfoById(this.model.gainFieldId);
            _loc2_.seedID = param1.pkg.readInt();
            _loc2_.plantTime = param1.pkg.readDate();
            _loc2_.gainCount = param1.pkg.readInt();
            _loc2_.AccelerateTime = param1.pkg.readInt();
            dispatchEvent(new FarmEvent("gainField"));
         }
      }
      
      private function __payField(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc12_:PackageIn = param1.pkg;
         this._model.currentFarmerId = _loc12_.readInt();
         var _loc13_:int = param1.pkg.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc13_)
         {
            _loc3_ = _loc12_.readInt();
            _loc4_ = _loc12_.readInt();
            _loc5_ = _loc12_.readDate();
            _loc6_ = _loc12_.readDate();
            _loc7_ = _loc12_.readInt();
            _loc8_ = _loc12_.readInt();
            _loc9_ = _loc12_.readInt();
            if(this.model.getfieldInfoById(_loc3_) == null)
            {
               _loc10_ = new FieldVO();
               _loc10_.fieldID = _loc3_;
               _loc10_.seedID = _loc4_;
               _loc10_.payTime = _loc5_;
               _loc10_.plantTime = _loc6_;
               _loc10_.fieldValidDate = _loc8_;
               _loc10_.AccelerateTime = _loc9_;
               _loc10_.gainCount = _loc7_;
               this.model.fieldsInfo.push(_loc10_);
            }
            else
            {
               _loc11_ = this.model.getfieldInfoById(_loc3_);
               _loc11_.seedID = _loc4_;
               _loc11_.payTime = _loc5_;
               _loc11_.plantTime = _loc6_;
               _loc11_.fieldValidDate = _loc8_;
               _loc11_.AccelerateTime = _loc9_;
               _loc11_.gainCount = _loc7_;
            }
            dispatchEvent(new FarmEvent("fieldsInfoReady"));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.payField.success"));
            _loc2_++;
         }
      }
      
      private function __onSeeding(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc9_:FieldVO = null;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Date = _loc2_.readDate();
         var _loc6_:Date = _loc2_.readDate();
         var _loc7_:int = _loc2_.readInt();
         var _loc8_:int = _loc2_.readInt();
         _loc9_ = this.model.getfieldInfoById(_loc3_);
         _loc9_.seedID = _loc4_;
         _loc9_.plantTime = _loc5_;
         _loc9_.gainCount = _loc7_;
         this.model.seedingFieldInfo = _loc9_;
         dispatchEvent(new FarmEvent("hasSeeding"));
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.seeding.success"));
      }
      
      private function __onDoMature(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = param1.pkg.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = param1.pkg.readBoolean();
            if(_loc2_)
            {
               this.model.matureId = param1.pkg.readInt();
               _loc4_ = this.model.getfieldInfoById(this.model.matureId);
               _loc4_.gainCount = param1.pkg.readInt();
               _loc4_.AccelerateTime = param1.pkg.readInt();
               dispatchEvent(new FarmEvent("accelerateField"));
            }
            _loc3_++;
         }
      }
      
      private function __onKillCrop(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         _loc5_ = param1.pkg.readBoolean();
         if(_loc5_)
         {
            this.model.killCropId = param1.pkg.readInt();
            _loc2_ = param1.pkg.readInt();
            _loc3_ = param1.pkg.readInt();
            _loc4_ = this.model.getfieldInfoById(this.model.killCropId);
            _loc4_.seedID = _loc2_;
            _loc4_.AccelerateTime = _loc3_;
            dispatchEvent(new FarmEvent("killCropField"));
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.success"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.killCrop.fail"));
         }
      }
      
      private function __onHelperSwitch(param1:CrazyTankSocketEvent) : void
      {
         this.model.helperArray = [];
         var _loc2_:Boolean = param1.pkg.readBoolean();
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:Date = param1.pkg.readDate();
         var _loc5_:int = param1.pkg.readInt();
         var _loc6_:int = param1.pkg.readInt();
         var _loc7_:int = param1.pkg.readInt();
         this.model.helperArray.push(_loc2_);
         this.model.helperArray.push(_loc3_);
         this.model.helperArray.push(_loc4_);
         this.model.helperArray.push(_loc5_);
         this.model.helperArray.push(_loc6_);
         this.model.helperArray.push(_loc7_);
         PlayerManager.Instance.Self.isFarmHelper = _loc2_;
         if(_loc2_)
         {
            dispatchEvent(new FarmEvent("beginHelper"));
         }
         else
         {
            dispatchEvent(new FarmEvent("stopHelper"));
         }
      }
      
      private function __onHelperPay(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Date = param1.pkg.readDate();
         var _loc3_:int = param1.pkg.readInt();
         this.model.autoPayTime = _loc2_;
         this.model.autoValidDate = _loc3_;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.helperMoneyComfirmPnlSuccess"));
         this.model.dispatchEvent(new FarmEvent("payHepler"));
      }
      
      private function __onExitFarm(param1:CrazyTankSocketEvent) : void
      {
      }
      
      public function updateSetupFriendListLoader() : void
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc1_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc1_["rnd"] = Math.random();
         var _loc2_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FarmGetUserFieldInfos.ashx"),6,_loc1_);
         _loc2_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         _loc2_.analyzer = new FarmFriendListAnalyzer(this.setupFriendList);
         LoadResourceManager.Instance.startLoad(_loc2_);
      }
      
      public function updateSetupFriendListStolen(param1:int) : void
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc2_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         _loc2_["friendID"] = param1;
         _loc2_["rnd"] = Math.random();
         var _loc3_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("FarmGetUserFieldInfosSingle.ashx"),6,_loc2_);
         _loc3_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.updateSetupFriendListLoaderFailure");
         _loc3_.analyzer = new FarmFriendListAnalyzer(this.setupFriendStolen);
         LoadResourceManager.Instance.startLoad(_loc3_);
      }
      
      public function creatSuperPetFoodPriceList() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("PetExpItemPrice.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.loadSpuerPetFoodPricetListComposeListFail");
         _loc1_.analyzer = new SuperPetFoodPriceAnalyzer(this.setupSuperPetFoodPriceList);
         _loc1_.addEventListener("complete",this.__onloadSpuerPetFoodPricetListComplete);
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
      
      protected function __onloadSpuerPetFoodPricetListComplete(param1:LoaderEvent) : void
      {
         dispatchEvent(new FarmEvent("loaderSuperPetFoodPricetList"));
      }
      
      public function setupSuperPetFoodPriceList(param1:SuperPetFoodPriceAnalyzer) : void
      {
         this.model.priceList = param1.list;
         dispatchEvent(new FarmEvent("loaderSuperPetFoodPricetList"));
      }
      
      public function setupFriendList(param1:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateList = param1.list;
         dispatchEvent(new FarmEvent("friendInfoReady"));
      }
      
      public function setupFriendStolen(param1:FarmFriendListAnalyzer) : void
      {
         this.model.friendStateListStolenInfo = param1.list;
         dispatchEvent(new FarmEvent("friendList_updateStolen"));
      }
      
      public function getCurrentMoney() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 21 - this.model.buyExpRemainNum;
         _loc1_ = 0;
         while(_loc1_ < this.model.priceList.length)
         {
            if(this.model.priceList[_loc1_].Count == _loc2_)
            {
               return this.model.priceList[_loc1_].Money;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public function getCurrentSuperPetFoodPriceInfo() : SuperPetFoodPriceInfo
      {
         var _loc1_:int = 0;
         var _loc2_:int = 21 - this.model.buyExpRemainNum;
         _loc1_ = 0;
         while(_loc1_ < this.model.priceList.length)
         {
            if(this.model.priceList[_loc1_].Count == _loc2_)
            {
               return this.model.priceList[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
   }
}

