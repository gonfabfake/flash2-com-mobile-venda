package wonderfulActivity
{
   import RechargeRank.RechargeRankManager;
   import activeEvents.data.ActiveEventsInfo;
   import calendar.CalendarManager;
   import carnivalActivity.RookieRankInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import condiscount.CondiscountManager;
   import consumeRank.ConsumeRankManager;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TimeManager;
   import ddt.states.StateType;
   import ddt.utils.FilterWordManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import foodActivity.FoodActivityManager;
   import panicBuying.PanicBuyingManager;
   import rank.RankManager;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   import roleRecharge.RoleRechargeMgr;
   import shop.view.ShopPresentClearingFrame;
   import signActivity.SignActivityMgr;
   import wonderfulActivity.data.ActivityTypeData;
   import wonderfulActivity.data.CanGetData;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.LeftViewInfoVo;
   import wonderfulActivity.data.PlayerCurInfo;
   import wonderfulActivity.data.WonderfulActivityTypeData;
   import wonderfulActivity.event.WonderfulActivityEvent;
   import wonderfulActivity.items.JoinIsPowerView;
   import wonderfulActivity.limitActivity.LimitActivityFrame;
   import wonderfulActivity.limitActivity.SendGiftActivityFrame;
   import wonderfulActivity.newActivity.returnActivity.ReturnActivityView;
   
   public class WonderfulActivityManager extends EventDispatcher
   {
      
      private static var _instance:WonderfulActivityManager;
      
      public static const UPDATE_MOUNT_MASTER:String = "updateMountMaster";
      
      public var activityData:Dictionary;
      
      public var activityInitData:Dictionary;
      
      public var leftViewInfoDic:Dictionary;
      
      public var currentView:*;
      
      private var _frame:LimitActivityFrame;
      
      private var _sendGiftFrame:SendGiftActivityFrame;
      
      private var _info:GmActivityInfo;
      
      private var _actList:Array;
      
      public var activityTypeList:Vector.<ActivityTypeData>;
      
      public var activityFighterList:Vector.<ActivityTypeData>;
      
      public var activityExpList:Vector.<ActivityTypeData>;
      
      public var activityRechargeList:Vector.<ActivityTypeData>;
      
      public var chickenEndTime:Date;
      
      public var rouleEndTime:Date;
      
      private var _timerHanderFun:Dictionary;
      
      private var _timer:Timer;
      
      public var xiaoFeiScore:int;
      
      public var chongZhiScore:int;
      
      public var _stateList:Vector.<CanGetData>;
      
      public var deleWAIcon:Function;
      
      public var addWAIcon:Function;
      
      public var hasActivity:Boolean = false;
      
      public var isRuning:Boolean = true;
      
      public var currView:String;
      
      public var frameCanClose:Boolean = true;
      
      public var clickWonderfulActView:Boolean;
      
      public var stateDic:Dictionary;
      
      public var isSkipFromHall:Boolean;
      
      public var skipType:String;
      
      public var leftUnitViewType:int;
      
      private var lastActList:Array = [];
      
      private var sendGiftIsOut:Boolean = false;
      
      private var firstShowSendGiftFrame:Boolean = true;
      
      private var _giveFriendOpenFrame:ShopPresentClearingFrame;
      
      private var _battleCompanionInfo:InventoryItemInfo;
      
      private var _eventsActiveDic:Dictionary;
      
      public var selectId:String = "";
      
      public var rankDic:Dictionary;
      
      public var rankActDic:Dictionary;
      
      public var rankFlag:Boolean;
      
      public function WonderfulActivityManager()
      {
         super();
         this._actList = [];
         this._timerHanderFun = new Dictionary();
         this._stateList = new Vector.<CanGetData>();
         this.activityInitData = new Dictionary();
         this.leftViewInfoDic = new Dictionary();
         this.activityFighterList = new Vector.<ActivityTypeData>();
         this.activityExpList = new Vector.<ActivityTypeData>();
         this.activityRechargeList = new Vector.<ActivityTypeData>();
         this._eventsActiveDic = new Dictionary();
         this.stateDic = new Dictionary();
         this.rankActDic = new Dictionary();
         this.rankDic = new Dictionary();
      }
      
      public static function get Instance() : WonderfulActivityManager
      {
         if(!_instance)
         {
            _instance = new WonderfulActivityManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initAdvIdName();
         this.addEvents();
         ConsumeRankManager.instance.setup();
         RechargeRankManager.instance.setup();
      }
      
      private function initAdvIdName() : void
      {
         this.leftViewInfoDic[ActivityType.CHONGZHIHUIKUI] = new LeftViewInfoVo(ActivityType.CHONGZHIHUIKUI,LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt1"));
         this.leftViewInfoDic[ActivityType.XIAOFEIHUIKUI] = new LeftViewInfoVo(ActivityType.XIAOFEIHUIKUI,LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt2"));
         this.leftViewInfoDic[ActivityType.ZHANYOUCHONGZHIHUIKUI] = new LeftViewInfoVo(ActivityType.ZHANYOUCHONGZHIHUIKUI,LanguageMgr.GetTranslation("wonderfulActivityManager.btnTxt6"));
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WONDERFUL_ACTIVITY,this.rechargeReturnHander);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WONDERFUL_ACTIVITY_INIT,this.activityInitHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WONDERFUL_ROOKIE_RANK,this.rookieRankHandler);
      }
      
      private function activityInitHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         _loc2_ = _loc3_.readInt();
         if(_loc2_ == 0)
         {
            this.updateNewActivityXml();
         }
         else if(_loc2_ == 1)
         {
            this.activityInit(_loc3_);
            this.checkActivity();
            this.initFrame(this.isSkipFromHall,this.skipType);
            SocketManager.Instance.out.updateConsumeRank();
            SocketManager.Instance.out.updateRechargeRank();
            SocketManager.Instance.out.sendWonderfulActivity(0,-1);
         }
         else if(_loc2_ == 2)
         {
            this.activityInit(_loc3_);
            this.checkActivity();
         }
         else if(_loc2_ == 3)
         {
            this.activityInit(_loc3_);
            this.checkActivity(_loc2_);
         }
      }
      
      private function updateNewActivityXml() : void
      {
         var _loc1_:BaseLoader = StartupResourceLoader.Instance.createWonderfulActivityXml();
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
      
      private function activityInit(param1:PackageIn) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Dictionary = null;
         var _loc8_:int = 0;
         var _loc9_:PlayerCurInfo = null;
         var _loc10_:GiftCurInfo = null;
         var _loc11_:String = null;
         var _loc12_:int = param1.readInt();
         var _loc13_:int = 0;
         while(_loc13_ <= _loc12_ - 1)
         {
            _loc2_ = param1.readUTF();
            _loc3_ = param1.readInt();
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ <= _loc3_ - 1)
            {
               _loc9_ = new PlayerCurInfo();
               _loc9_.statusID = param1.readInt();
               _loc9_.statusValue = param1.readInt();
               _loc4_.push(_loc9_);
               _loc5_++;
            }
            _loc6_ = param1.readInt();
            _loc7_ = new Dictionary();
            _loc8_ = 0;
            while(_loc8_ <= _loc6_ - 1)
            {
               _loc10_ = new GiftCurInfo();
               _loc11_ = param1.readUTF();
               _loc10_.times = param1.readInt();
               _loc10_.allGiftGetTimes = param1.readInt();
               _loc7_[_loc11_] = _loc10_;
               _loc8_++;
            }
            this.activityInitData[_loc2_] = {
               "statusArr":_loc4_,
               "giftInfoDic":_loc7_
            };
            _loc13_++;
         }
         if(Boolean(this.currentView))
         {
            if(this.currentView is JoinIsPowerView || this.currentView is ReturnActivityView)
            {
               this.currentView.refresh();
            }
            else if(Boolean(this.currentView.hasOwnProperty("updateAwardState")))
            {
               this.currentView.updateAwardState();
            }
         }
      }
      
      private function rechargeReturnHander(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Date = null;
         var _loc5_:Date = null;
         var _loc6_:CanGetData = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Date = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = param1.pkg.readByte();
         if(_loc12_ == 2)
         {
            if(StateManager.currentStateType == StateType.MAIN || Boolean(this._frame))
            {
               this.updateFirstRechargeXml();
            }
         }
         else if(_loc12_ == 0)
         {
            _loc3_ = param1.pkg.readInt();
            _loc7_ = 0;
            while(_loc7_ < _loc3_)
            {
               _loc8_ = -1;
               _loc6_ = new CanGetData();
               _loc6_.id = param1.pkg.readInt();
               switch(_loc6_.id)
               {
                  case ActivityType.ZHANYOUCHONGZHIHUIKUI:
                     _loc8_ = ActivityType.ZHANYOUCHONGZHIHUIKUI;
                     _loc10_ = param1.pkg.readInt();
                     break;
                  case ActivityType.CHONGZHIHUIKUI:
                     _loc8_ = ActivityType.CHONGZHIHUIKUI;
                     this.chongZhiScore = param1.pkg.readInt();
                     break;
                  case ActivityType.XIAOFEIHUIKUI:
                     _loc8_ = ActivityType.XIAOFEIHUIKUI;
                     this.xiaoFeiScore = param1.pkg.readInt();
                     break;
                  default:
                     _loc11_ = param1.pkg.readInt();
               }
               _loc6_.num = param1.pkg.readInt();
               _loc4_ = param1.pkg.readDate();
               _loc5_ = param1.pkg.readDate();
               this.setActivityTime(_loc6_.id,_loc4_,_loc5_);
               this.updateStateList(_loc6_);
               if(_loc8_ != -1)
               {
                  _loc9_ = TimeManager.Instance.Now();
                  if(_loc9_.getTime() > _loc4_.getTime() && _loc9_.getTime() < _loc5_.getTime() && _loc6_.num != -2)
                  {
                     this.addElement(_loc8_);
                  }
                  else
                  {
                     this.removeElement(_loc8_);
                  }
               }
               _loc7_++;
            }
            if(Boolean(_loc3_ == 1) && Boolean(this._frame) && Boolean(this._frame.parent))
            {
               if(Boolean(_loc6_))
               {
                  this._frame.setState(_loc6_.num,_loc6_.id);
               }
            }
         }
      }
      
      private function updateFirstRechargeXml() : void
      {
      }
      
      public function updateChargeActiveTemplateXml() : void
      {
      }
      
      public function updateRealEndTime() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(PlayerManager.Instance.Self.createPlayerDate == null)
         {
            return;
         }
         for each(_loc3_ in this.activityData)
         {
            if(_loc3_.activityType == 39 && Boolean(PlayerManager.Instance.Self.createPlayerDate))
            {
               _loc3_.beginTime = DateUtils.dateFormat3(PlayerManager.Instance.Self.createPlayerDate);
               _loc3_.beginShowTime = DateUtils.dateFormat3(PlayerManager.Instance.Self.createPlayerDate);
               _loc1_ = new Date(PlayerManager.Instance.Self.createPlayerDate.time + (_loc3_.remain1 - 1) * 86400000);
               _loc2_ = new Date(PlayerManager.Instance.Self.createPlayerDate.time + (_loc3_.remain2 - 1) * 86400000);
               _loc3_.endShowTime = DateUtils.dateFormat4(_loc2_);
               _loc3_.endTime = DateUtils.dateFormat4(_loc1_);
               break;
            }
         }
      }
      
      private function dispatchCheckEvent() : void
      {
         if(!this._frame && !this.clickWonderfulActView)
         {
            dispatchEvent(new WonderfulActivityEvent(WonderfulActivityEvent.CHECK_ACTIVITY_STATE));
         }
      }
      
      private function updateStateList(param1:CanGetData) : void
      {
         var _loc2_:int = int(this._stateList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1.id == this._stateList[_loc3_].id)
            {
               this._stateList[_loc3_] = param1;
               return;
            }
            _loc3_++;
         }
         this._stateList.push(param1);
      }
      
      private function timerHander(param1:TimerEvent) : void
      {
         var _loc2_:Function = null;
         for each(_loc2_ in this._timerHanderFun)
         {
            _loc2_();
         }
      }
      
      public function addTimerFun(param1:String, param2:Function) : void
      {
         this._timerHanderFun[param1] = param2;
         if(!this._timer)
         {
            this._timer = new Timer(1000);
            this._timer.start();
            this._timer.addEventListener(TimerEvent.TIMER,this.timerHander);
         }
      }
      
      public function delTimerFun(param1:String) : void
      {
         if(Boolean(this._timerHanderFun[param1]))
         {
            delete this._timerHanderFun[param1];
         }
         if(this.isEmptyDictionary(this._timerHanderFun))
         {
            if(Boolean(this._timer))
            {
               this._timer.stop();
               this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
               this._timer = null;
            }
         }
      }
      
      private function isEmptyDictionary(param1:Dictionary) : Boolean
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            if(Boolean(_loc2_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function getTimeDiff(param1:Date, param2:Date) : String
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Number = Math.round((param1.getTime() - param2.getTime()) / 1000);
         if(_loc7_ >= 0)
         {
            _loc3_ = Math.floor(_loc7_ / 60 / 60 / 24);
            _loc7_ %= 60 * 60 * 24;
            _loc4_ = Math.floor(_loc7_ / 60 / 60);
            _loc7_ %= 60 * 60;
            _loc5_ = Math.floor(_loc7_ / 60);
            _loc6_ = _loc7_ % 60;
            if(_loc3_ > 0)
            {
               return _loc3_ + " " + LanguageMgr.GetTranslation("wonderfulActivityManager.d");
            }
            if(_loc4_ > 0)
            {
               return this.fixZero(_loc4_) + " " + LanguageMgr.GetTranslation("wonderfulActivityManager.h");
            }
            if(_loc5_ > 0)
            {
               return this.fixZero(_loc5_) + " " + LanguageMgr.GetTranslation("wonderfulActivityManager.m");
            }
            if(_loc6_ > 0)
            {
               return this.fixZero(_loc6_) + " " + LanguageMgr.GetTranslation("wonderfulActivityManager.s");
            }
         }
         return "0";
      }
      
      private function fixZero(param1:uint) : String
      {
         return param1 < 10 ? String(param1) : String(param1);
      }
      
      private function setActivityTime(param1:int, param2:Date, param3:Date) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == ActivityType.ZHANYOUCHONGZHIHUIKUI)
         {
            if(this.activityFighterList.length == 0)
            {
               return;
            }
            this.activityFighterList[0].StartTime = param2;
            this.activityFighterList[0].EndTime = param3;
         }
         else if(param1 >= ActivityType.CHONGZHIHUIKUI && param1 < ActivityType.XIAOFEIHUIKUI)
         {
            if(this.activityRechargeList.length == 0)
            {
               return;
            }
            _loc4_ = 0;
            while(_loc4_ < this.activityRechargeList.length)
            {
               if(param1 == this.activityRechargeList[_loc4_].ID)
               {
                  this.activityRechargeList[_loc4_].StartTime = param2;
                  this.activityRechargeList[_loc4_].EndTime = param3;
                  break;
               }
               _loc4_++;
            }
         }
         else if(param1 >= ActivityType.XIAOFEIHUIKUI)
         {
            if(this.activityExpList.length == 0)
            {
               return;
            }
            _loc5_ = 0;
            while(_loc5_ < this.activityExpList.length)
            {
               if(param1 == this.activityExpList[_loc4_].ID)
               {
                  this.activityExpList[_loc4_].StartTime = param2;
                  this.activityExpList[_loc4_].EndTime = param3;
                  break;
               }
               _loc5_++;
            }
         }
      }
      
      public function wonderfulGMActiveInfo(param1:WonderfulGMActAnalyer) : void
      {
         this.activityData = param1.ActivityData;
         this.hasActivity = param1.Count > 0;
         FoodActivityManager.Instance.checkOpen();
         SocketManager.Instance.out.updateRechargeRank();
         SocketManager.Instance.out.updateConsumeRank();
         PanicBuyingManager.instance.checkOpen();
      }
      
      public function wonderfulActiveType(param1:WonderfulActAnalyer) : void
      {
         this.activityFighterList = new Vector.<ActivityTypeData>();
         this.activityExpList = new Vector.<ActivityTypeData>();
         this.activityRechargeList = new Vector.<ActivityTypeData>();
         this.activityTypeList = param1.itemList;
         var _loc2_:int = int(this.activityTypeList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.activityTypeList[_loc3_].StartTime = new Date();
            this.activityTypeList[_loc3_].EndTime = new Date();
            if(this.activityTypeList[_loc3_].ID == ActivityType.ZHANYOUCHONGZHIHUIKUI)
            {
               this.activityFighterList.push(this.activityTypeList[_loc3_]);
            }
            else if(this.activityTypeList[_loc3_].ID >= ActivityType.CHONGZHIHUIKUI && this.activityTypeList[_loc3_].ID < ActivityType.XIAOFEIHUIKUI)
            {
               this.activityRechargeList.push(this.activityTypeList[_loc3_]);
            }
            else
            {
               this.activityExpList.push(this.activityTypeList[_loc3_]);
            }
            _loc3_++;
         }
         SocketManager.Instance.out.sendWonderfulActivity(0,-1);
      }
      
      public function initFrame(param1:Boolean = false, param2:String = "0") : void
      {
         this.isSkipFromHall = param1;
         this.skipType = param2;
         this.leftUnitViewType = Boolean(this.leftViewInfoDic[this.skipType]) ? int(this.leftViewInfoDic[this.skipType].unitIndex) : int(2);
         if(!this._frame)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.onSmallLoadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.DDT_CALENDAR);
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.WONDERFULACTIVI);
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this._frame.addElement(this.actList);
         }
      }
      
      public function addElement(param1:*) : void
      {
         param1 = String(param1);
         if(this._actList.indexOf(param1) == -1)
         {
            this._actList.unshift(param1);
         }
         if(this._actList.length > 0)
         {
            if(this.addWAIcon != null)
            {
               this.addWAIcon();
            }
         }
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.addElement(this.actList);
         }
      }
      
      public function removeElement(param1:*) : void
      {
         param1 = String(param1);
         var _loc2_:int = this._actList.indexOf(param1);
         if(_loc2_ == -1)
         {
            return;
         }
         this._actList.splice(_loc2_,1);
         if(this._actList.length == 0)
         {
            this.dispose();
            return;
         }
         if(this._actList.length > 0)
         {
            if(this.currView == param1)
            {
               this.currView = this._actList[0];
            }
         }
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.addElement(this.actList);
         }
      }
      
      public function dispose() : void
      {
         if(!this.isRuning)
         {
            return;
         }
         this.clickWonderfulActView = false;
         ObjectUtils.disposeObject(this._frame);
         this._frame = null;
         this.currentView = null;
         this.isSkipFromHall = false;
         this.skipType = "0";
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.timerHander);
            this._timer = null;
         }
         if(this._actList.length == 0)
         {
            if(this.deleWAIcon != null)
            {
               this.deleWAIcon();
            }
         }
      }
      
      protected function onUIProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.WONDERFULACTIVI)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function createActivityFrame(param1:UIModuleEvent) : void
      {
         var _loc2_:BaseLoader = null;
         if(param1.module != UIModuleTypes.WONDERFULACTIVI)
         {
            return;
         }
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
         if(!WonderfulActivityManager.Instance.activityTypeList)
         {
            WonderfulActivityManager.Instance.activityTypeList = new Vector.<ActivityTypeData>();
         }
         if(Boolean(WonderfulActivityManager.Instance.activityTypeList))
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this._frame.addElement(this.actList);
         }
      }
      
      private function __dataLoaderCompleteHandler(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.loader;
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__dataLoaderCompleteHandler);
         this._frame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.LimitActivityFrame");
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._frame.addElement(this.actList);
      }
      
      private function checkActivity(param1:int = 0) : void
      {
         var _loc2_:GmActivityInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         this.rankFlag = false;
         var _loc7_:Boolean = false;
         var _loc8_:LeftViewInfoVo = null;
         var _loc9_:Boolean = false;
         var _loc10_:LeftViewInfoVo = null;
         var _loc11_:Boolean = false;
         var _loc12_:LeftViewInfoVo = null;
         if(this.activityData == null)
         {
            return;
         }
         var _loc13_:Array = [];
         var _loc14_:Date = TimeManager.Instance.Now();
         this.checkActState2();
         RoleRechargeMgr.instance.isOpen = false;
         SignActivityMgr.instance.isOpen = false;
         ConRechargeManager.instance.isOpen = false;
         for each(_loc2_ in this.activityData)
         {
            if(_loc14_.time < Date.parse(_loc2_.beginTime) || _loc14_.time > Date.parse(_loc2_.endShowTime))
            {
               continue;
            }
            switch(_loc2_.activityType)
            {
               case WonderfulActivityTypeData.MAIN_PAY_ACTIVITY:
                  switch(_loc2_.activityChildType)
                  {
                     case WonderfulActivityTypeData.FIRST_CONTACT:
                        break;
                     case WonderfulActivityTypeData.ACC_FIRST_PAY:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.ONE_OFF_PAY:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.ACCUMULATIVE_PAY:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACCUMULATIVE_PAY,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.NEWGAMEBENIFIT:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.NEWGAMEBENIFIT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.PAY_RETURN:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.PAY_RETURN,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.ONE_OFF_IN_TIME:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MAIN_CONSUME_ACTIVITY:
                  switch(_loc2_.activityChildType)
                  {
                     case WonderfulActivityTypeData.ONE_OFF_CONSUME:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.CONSUME_RETURN:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.CONSUME_RETURN,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                        break;
                     case WonderfulActivityTypeData.SPECIFIC_COUNT_CONSUME:
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                        _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MAIN_FAMOUS_ACTIVITY:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.HERO_POWER || _loc2_.activityChildType == WonderfulActivityTypeData.HERO_GRADE)
                  {
                     for each(_loc8_ in this.leftViewInfoDic)
                     {
                        if(_loc8_.viewType == ActivityType.HERO)
                        {
                           _loc7_ = true;
                           break;
                        }
                     }
                     if(!_loc7_)
                     {
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.HERO,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                     }
                     if(_loc13_.indexOf(_loc2_.activityId) == -1)
                     {
                        _loc13_.push(_loc2_.activityId);
                     }
                  }
                  break;
               case WonderfulActivityTypeData.CONSORTION_ACTIVITY:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.TUANJIE_POWER)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.TUANJIE_POWER,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.STRENGTHEN_ACTIVITY:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.STRENGTHEN_DAREN)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.STRENGTHEN_DAREN,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.EXCHANGE_ACTIVITY:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.NORMAL_EXCHANGE)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.NORMAL_EXCHANGE,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MARRY_ACTIVITY:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.HOLD_WEDDING)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ACT_ANNOUNCEMENT,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.RECEIVE_ACTIVITY:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.USER_ID_RECEIVE || _loc2_.activityChildType == WonderfulActivityTypeData.DAILY_RECEIVE)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.RECEIVE_ACTIVITY,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  else if(_loc2_.activityChildType == WonderfulActivityTypeData.SEND_GIFT)
                  {
                     this._info = _loc2_;
                     if(Boolean(this._sendGiftFrame && this.activityInitData[this._info.activityId]) && Boolean(this.activityInitData[this._info.activityId].giftInfoDic[this._info.giftbagArray[0].giftbagId].times != 0) && this._sendGiftFrame.nowId == this._info.activityId)
                     {
                        this._sendGiftFrame.setBtnFalse();
                     }
                     if(param1 != 3)
                     {
                        break;
                     }
                     if(Boolean(PlayerManager.Instance.Self.Grade > 2 && !this.sendGiftIsOut && this.activityInitData[this._info.activityId]) && Boolean(this.activityInitData[this._info.activityId].giftInfoDic[this._info.giftbagArray[0].giftbagId].times == 0) && !this._sendGiftFrame)
                     {
                        this._sendGiftFrame = ComponentFactory.Instance.creatComponentByStylename("com.wonderfulActivity.sendGiftFrame");
                        this._sendGiftFrame.setData(this._info);
                        this.sendGiftIsOut = true;
                     }
                  }
                  break;
               case WonderfulActivityTypeData.CARNIVAL_ACTIVITY:
                  switch(_loc2_.activityChildType)
                  {
                     case WonderfulActivityTypeData.CARNIVAL_GRADE:
                        _loc6_ = ActivityType.CARNIVAL_GRADE;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_STRENGTH:
                        _loc6_ = ActivityType.CARNIVAL_STRENGTH;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_FUSION:
                        _loc6_ = ActivityType.CARNIVAL_FUSION;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ROOKIE:
                     case WonderfulActivityTypeData.CARNIVAL_ROOKIE + 8:
                        for each(_loc10_ in this.leftViewInfoDic)
                        {
                           if(_loc10_.viewType == ActivityType.CARNIVAL_ROOKIE)
                           {
                              _loc9_ = true;
                              break;
                           }
                        }
                        if(!_loc9_)
                        {
                           _loc6_ = ActivityType.CARNIVAL_ROOKIE;
                        }
                        else
                        {
                           _loc6_ = 0;
                        }
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_BEAD:
                        _loc6_ = ActivityType.CARNIVAL_BEAD;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_TOTEM:
                        _loc6_ = ActivityType.CARNIVAL_TOTEM;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_PRACTICE:
                        _loc6_ = ActivityType.CARNIVAL_PRACTICE;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_CARD:
                        _loc6_ = ActivityType.CARNIVAL_CARD;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_ZHANHUN:
                        _loc6_ = ActivityType.CARNIVAL_ZHANHUN;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_MOUNT_LEVEL:
                        _loc6_ = ActivityType.CARNIVAL_MOUNT_MASTER;
                        break;
                     case WonderfulActivityTypeData.CARNIVAL_PET:
                        _loc6_ = ActivityType.CARNIVAL_PET;
                  }
                  if(_loc6_ != 0)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(_loc6_,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                  }
                  if(_loc13_.indexOf(_loc2_.activityId) == -1)
                  {
                     _loc13_.push(_loc2_.activityId);
                  }
                  break;
               case WonderfulActivityTypeData.MOUNT_MASTER:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.MOUNT_LEVEL)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.MOUNT_MASTER_LEVEL,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  else if(_loc2_.activityChildType == WonderfulActivityTypeData.MOUNT_SKILL)
                  {
                     this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.MOUNT_MASTER_SKILL,"· " + _loc2_.activityName,_loc2_.icon);
                     this.addElement(_loc2_.activityId);
                     _loc13_.push(_loc2_.activityId);
                  }
                  dispatchEvent(new Event(UPDATE_MOUNT_MASTER));
                  break;
               case WonderfulActivityTypeData.WHOLEPEOPLE_VIP:
                  this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.WHOLEPEOPLE_VIP,"· " + _loc2_.activityName,_loc2_.icon);
                  this.addElement(_loc2_.activityId);
                  _loc13_.push(_loc2_.activityId);
                  break;
               case WonderfulActivityTypeData.WHOLEPEOPLE_PET:
                  this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.WHOLEPEOPLE_PET,"· " + _loc2_.activityName,_loc2_.icon);
                  this.addElement(_loc2_.activityId);
                  _loc13_.push(_loc2_.activityId);
                  break;
               case WonderfulActivityTypeData.ROLERECHARGE:
                  this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.ROLERECHARGE,"· " + _loc2_.activityName,_loc2_.icon);
                  RoleRechargeMgr.instance.model.giftbagArray = _loc2_.giftbagArray;
                  RoleRechargeMgr.instance.model.beginTime = _loc2_.beginShowTime.split(" ")[0];
                  RoleRechargeMgr.instance.model.endTime = _loc2_.endShowTime.split(" ")[0];
                  RoleRechargeMgr.instance.model.actId = _loc2_.activityId;
                  RoleRechargeMgr.instance.isOpen = true;
                  break;
               case WonderfulActivityTypeData.SIGNACTIVITY:
                  this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(100,"· " + _loc2_.activityName,_loc2_.icon);
                  SignActivityMgr.instance.model.giftbagArray = _loc2_.giftbagArray;
                  SignActivityMgr.instance.model.beginTime = _loc2_.beginShowTime.split(" ")[0];
                  SignActivityMgr.instance.model.endTime = _loc2_.endShowTime.split(" ")[0];
                  SignActivityMgr.instance.model.actId = _loc2_.activityId;
                  SignActivityMgr.instance.isOpen = true;
                  break;
               case WonderfulActivityTypeData.CONRECHARGE:
                  ConRechargeManager.instance.giftbagArray = _loc2_.giftbagArray;
                  ConRechargeManager.instance.beginTime = _loc2_.beginShowTime;
                  ConRechargeManager.instance.endTime = _loc2_.endShowTime;
                  ConRechargeManager.instance.actId = _loc2_.activityId;
                  ConRechargeManager.instance.isOpen = true;
                  break;
               case WonderfulActivityTypeData.CON_DISCOUNT_GOODS:
                  this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.CON_DISCOUNT,"· " + _loc2_.activityName,_loc2_.icon);
                  CondiscountManager.instance.model.giftbagArray = _loc2_.giftbagArray;
                  CondiscountManager.instance.model.beginTime = _loc2_.beginTime;
                  CondiscountManager.instance.model.endTime = _loc2_.endTime;
                  CondiscountManager.instance.model.actId = _loc2_.activityId;
                  CondiscountManager.instance.model.isOpen = true;
                  break;
               case WonderfulActivityTypeData.DAILY_GIFT:
                  if(_loc2_.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_BEAD || _loc2_.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_CARD || _loc2_.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_PLANT || _loc2_.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_STONE || _loc2_.activityChildType == WonderfulActivityTypeData.DAILY_GIFT_USE)
                  {
                     for each(_loc12_ in this.leftViewInfoDic)
                     {
                        if(_loc12_.viewType == ActivityType.DAILY_GIFT)
                        {
                           _loc11_ = true;
                           break;
                        }
                     }
                     if(!_loc11_)
                     {
                        this.leftViewInfoDic[_loc2_.activityId] = new LeftViewInfoVo(ActivityType.DAILY_GIFT,"· " + _loc2_.activityName,_loc2_.icon);
                        this.addElement(_loc2_.activityId);
                     }
                     if(_loc13_.indexOf(_loc2_.activityId) == -1)
                     {
                        _loc13_.push(_loc2_.activityId);
                     }
                  }
                  break;
               case 30:
                  this.rankDic[_loc2_.activityChildType] = _loc2_;
                  this.rankFlag = true;
                  RankManager.instance.model.beginTime = _loc2_.beginTime;
                  RankManager.instance.model.endTime = _loc2_.endTime;
            }
         }
         _loc3_ = -1;
         _loc4_ = 0;
         while(_loc4_ <= _loc13_.length - 1)
         {
            _loc3_ = this.lastActList.indexOf(_loc13_[_loc4_]);
            if(_loc3_ >= 0)
            {
               this.lastActList.splice(_loc3_,1);
            }
            _loc4_++;
         }
         for each(_loc5_ in this.lastActList)
         {
            this.removeElement(_loc5_);
         }
         this.lastActList = _loc13_;
         this.checkActState();
      }
      
      public function checkShowSendGiftFrame() : void
      {
         if(this.sendGiftIsOut && this.firstShowSendGiftFrame)
         {
            this.firstShowSendGiftFrame = false;
            LayerManager.Instance.addToLayer(this._sendGiftFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      public function getActIdWithViewId(param1:int) : String
      {
         var _loc2_:* = null;
         var _loc3_:LeftViewInfoVo = null;
         for(_loc2_ in this.leftViewInfoDic)
         {
            _loc3_ = this.leftViewInfoDic[_loc2_];
            if(_loc3_.viewType == param1)
            {
               return _loc2_;
            }
         }
         return "";
      }
      
      private function checkActState() : void
      {
         var _loc1_:* = null;
         var _loc2_:LeftViewInfoVo = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:GmActivityInfo = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:GiftBagInfo = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:PlayerCurInfo = null;
         var _loc16_:GiftBagInfo = null;
         var _loc17_:int = 0;
         var _loc18_:GiftBagInfo = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:PlayerCurInfo = null;
         for(_loc1_ in this.leftViewInfoDic)
         {
            this.stateDic[this.leftViewInfoDic[_loc1_].viewType] = false;
            if(!this.activityData[_loc1_] || !this.activityInitData[_loc1_])
            {
               continue;
            }
            _loc2_ = this.leftViewInfoDic[_loc1_];
            _loc3_ = this.activityInitData[_loc1_].giftInfoDic;
            _loc4_ = this.activityInitData[_loc1_].statusArr;
            _loc5_ = this.activityData[_loc1_];
            _loc6_ = new Date().time;
            switch(_loc2_.viewType)
            {
               case ActivityType.PAY_RETURN:
               case ActivityType.CONSUME_RETURN:
                  for each(_loc12_ in _loc5_.giftbagArray)
                  {
                     if(!_loc3_[_loc12_.giftbagId])
                     {
                        break;
                     }
                     _loc13_ = int(_loc3_[_loc12_.giftbagId].times);
                     if(_loc12_.giftConditionArr[2].conditionValue == 0)
                     {
                        _loc14_ = int(Math.floor(_loc4_[0].statusValue / _loc12_.giftConditionArr[0].conditionValue)) - _loc13_;
                        if(_loc14_ > 0)
                        {
                           this.stateDic[_loc2_.viewType] = true;
                           break;
                        }
                     }
                     else if(_loc13_ == 0 && Math.floor(_loc4_[0].statusValue / _loc12_.giftConditionArr[0].conditionValue) > 0)
                     {
                        this.stateDic[_loc2_.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_LEVEL:
                  for each(_loc15_ in _loc4_)
                  {
                     if(_loc15_.statusID == 0)
                     {
                        _loc7_ = _loc15_.statusValue;
                     }
                     else if(_loc15_.statusID == 1)
                     {
                        _loc8_ = _loc15_.statusValue;
                     }
                  }
                  for each(_loc16_ in _loc5_.giftbagArray)
                  {
                     if(!_loc3_[_loc16_.giftbagId])
                     {
                        break;
                     }
                     _loc17_ = 0;
                     while(_loc17_ < _loc16_.giftConditionArr.length)
                     {
                        if(_loc16_.giftConditionArr[_loc17_].conditionIndex == 0)
                        {
                           _loc9_ = _loc16_.giftConditionArr[_loc17_].remain1;
                           break;
                        }
                        _loc17_++;
                     }
                     if(_loc6_ >= Date.parse(_loc5_.beginShowTime) && _loc6_ <= Date.parse(_loc5_.endShowTime) && _loc3_[_loc16_.giftbagId].times == 0 && _loc9_ > _loc7_ && _loc9_ <= _loc8_)
                     {
                        this.stateDic[_loc2_.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_SKILL:
                  for each(_loc18_ in _loc5_.giftbagArray)
                  {
                     if(!_loc3_[_loc18_.giftbagId])
                     {
                        break;
                     }
                     _loc19_ = 0;
                     while(_loc19_ < _loc18_.giftConditionArr.length)
                     {
                        if(_loc18_.giftConditionArr[_loc19_].conditionIndex == 0)
                        {
                           _loc10_ = _loc18_.giftConditionArr[_loc19_].conditionValue;
                           break;
                        }
                        _loc11_ = _loc18_.giftConditionArr[_loc19_].conditionValue;
                        _loc19_++;
                     }
                     for each(_loc22_ in _loc4_)
                     {
                        if(_loc22_.statusID == _loc10_)
                        {
                           _loc20_ = _loc22_.statusValue;
                        }
                        else if(_loc22_.statusID == 100 + _loc10_)
                        {
                           _loc21_ = _loc22_.statusValue;
                        }
                     }
                     if(_loc6_ >= Date.parse(_loc5_.beginShowTime) && _loc6_ <= Date.parse(_loc5_.endShowTime) && _loc3_[_loc18_.giftbagId].times == 0 && _loc11_ > _loc20_ && _loc11_ <= _loc21_)
                     {
                        this.stateDic[_loc2_.viewType] = true;
                        break;
                     }
                  }
            }
         }
         this.dispatchCheckEvent();
      }
      
      private function checkActState2() : void
      {
         var _loc1_:* = null;
         var _loc2_:LeftViewInfoVo = null;
         var _loc3_:Dictionary = null;
         var _loc4_:Array = null;
         var _loc5_:GmActivityInfo = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:GiftBagInfo = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:PlayerCurInfo = null;
         var _loc16_:GiftBagInfo = null;
         var _loc17_:int = 0;
         var _loc18_:GiftBagInfo = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:PlayerCurInfo = null;
         for(_loc1_ in this.leftViewInfoDic)
         {
            this.stateDic[this.leftViewInfoDic[_loc1_].viewType] = false;
            if(!this.activityData[_loc1_] || !this.activityInitData[_loc1_])
            {
               continue;
            }
            _loc2_ = this.leftViewInfoDic[_loc1_];
            _loc3_ = this.activityInitData[_loc1_].giftInfoDic;
            _loc4_ = this.activityInitData[_loc1_].statusArr;
            _loc5_ = this.activityData[_loc1_];
            _loc6_ = new Date().time;
            switch(_loc2_.viewType)
            {
               case ActivityType.PAY_RETURN:
               case ActivityType.CONSUME_RETURN:
                  for each(_loc12_ in _loc5_.giftbagArray)
                  {
                     if(!_loc3_[_loc12_.giftbagId])
                     {
                        break;
                     }
                     _loc13_ = int(_loc3_[_loc12_.giftbagId].times);
                     if(_loc12_.giftConditionArr[2].conditionValue == 0)
                     {
                        _loc14_ = int(Math.floor(_loc4_[0].statusValue / _loc12_.giftConditionArr[0].conditionValue)) - _loc13_;
                        if(_loc14_ > 0)
                        {
                           this.stateDic[_loc2_.viewType] = true;
                           break;
                        }
                     }
                     else if(_loc13_ == 0 && Math.floor(_loc4_[0].statusValue / _loc12_.giftConditionArr[0].conditionValue) > 0)
                     {
                        this.stateDic[_loc2_.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_LEVEL:
                  for each(_loc15_ in _loc4_)
                  {
                     if(_loc15_.statusID == 0)
                     {
                        _loc7_ = _loc15_.statusValue;
                     }
                     else if(_loc15_.statusID == 1)
                     {
                        _loc8_ = _loc15_.statusValue;
                     }
                  }
                  for each(_loc16_ in _loc5_.giftbagArray)
                  {
                     if(!_loc3_[_loc16_.giftbagId])
                     {
                        break;
                     }
                     _loc17_ = 0;
                     while(_loc17_ < _loc16_.giftConditionArr.length)
                     {
                        if(_loc16_.giftConditionArr[_loc17_].conditionIndex == 0)
                        {
                           _loc9_ = _loc16_.giftConditionArr[_loc17_].remain1;
                           break;
                        }
                        _loc17_++;
                     }
                     if(_loc6_ >= Date.parse(_loc5_.beginShowTime) && _loc6_ <= Date.parse(_loc5_.endShowTime) && _loc3_[_loc16_.giftbagId].times == 0 && _loc9_ > _loc7_ && _loc9_ <= _loc8_)
                     {
                        this.stateDic[_loc2_.viewType] = true;
                        break;
                     }
                  }
                  break;
               case ActivityType.MOUNT_MASTER_SKILL:
                  for each(_loc18_ in _loc5_.giftbagArray)
                  {
                     if(!_loc3_[_loc18_.giftbagId])
                     {
                        break;
                     }
                     _loc19_ = 0;
                     while(_loc19_ < _loc18_.giftConditionArr.length)
                     {
                        if(_loc18_.giftConditionArr[_loc19_].conditionIndex == 0)
                        {
                           _loc10_ = _loc18_.giftConditionArr[_loc19_].conditionValue;
                           break;
                        }
                        _loc11_ = _loc18_.giftConditionArr[_loc19_].conditionValue;
                        _loc19_++;
                     }
                     for each(_loc22_ in _loc4_)
                     {
                        if(_loc22_.statusID == _loc10_)
                        {
                           _loc20_ = _loc22_.statusValue;
                        }
                        else if(_loc22_.statusID == 100 + _loc10_)
                        {
                           _loc21_ = _loc22_.statusValue;
                        }
                     }
                     if(_loc6_ >= Date.parse(_loc5_.beginShowTime) && _loc6_ <= Date.parse(_loc5_.endShowTime) && _loc3_[_loc18_.giftbagId].times == 0 && _loc11_ > _loc20_ && _loc11_ <= _loc21_)
                     {
                        this.stateDic[_loc2_.viewType] = true;
                        break;
                     }
                  }
            }
         }
      }
      
      protected function onSmallLoadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.onSmallLoadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createActivityFrame);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUIProgress);
      }
      
      public function useBattleCompanion(param1:InventoryItemInfo) : void
      {
         this._battleCompanionInfo = param1;
         this._giveFriendOpenFrame = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.ShopPresentClearingFrame");
         this._giveFriendOpenFrame.show();
         this._giveFriendOpenFrame.presentBtn.addEventListener(MouseEvent.CLICK,this.__presentBtnClick,false,0,true);
         this._giveFriendOpenFrame.addEventListener(FrameEvent.RESPONSE,this.__responseHandler2,false,0,true);
      }
      
      private function __responseHandler2(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            this.removeBattleCompanion();
            this._giveFriendOpenFrame = null;
         }
      }
      
      private function removeBattleCompanion() : void
      {
         if(Boolean(this._giveFriendOpenFrame) && Boolean(this._giveFriendOpenFrame.presentBtn))
         {
            this._giveFriendOpenFrame.presentBtn.removeEventListener(MouseEvent.CLICK,this.__presentBtnClick);
         }
         if(Boolean(this._giveFriendOpenFrame))
         {
            this._giveFriendOpenFrame.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler2);
         }
         this._battleCompanionInfo = null;
      }
      
      private function __presentBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:String = this._giveFriendOpenFrame.nameInput.text;
         if(_loc2_ == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.give"));
            return;
         }
         if(FilterWordManager.IsNullorEmpty(_loc2_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.ShopIIPresentView.space"));
            return;
         }
         this.removeBattleCompanion();
         ObjectUtils.disposeObject(this._giveFriendOpenFrame);
         this._giveFriendOpenFrame = null;
      }
      
      private function getTodayList() : Array
      {
         var _loc1_:ActiveEventsInfo = null;
         var _loc2_:Array = [];
         var _loc3_:int = int(CalendarManager.getInstance().eventActives.length);
         var _loc4_:Date = TimeManager.Instance.Now();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc1_ = CalendarManager.getInstance().eventActives[_loc5_];
            if(_loc4_.time > _loc1_.start.time && _loc4_.time < _loc1_.end.time)
            {
               _loc2_.push(_loc1_);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function get eventsActiveDic() : Dictionary
      {
         return this._eventsActiveDic;
      }
      
      public function getActiveEventsInfoByID(param1:int) : ActiveEventsInfo
      {
         return this._eventsActiveDic[param1];
      }
      
      public function setLimitActivities(param1:Array) : void
      {
         var _loc2_:ActiveEventsInfo = null;
         var _loc3_:String = null;
         var _loc4_:int = 10000;
         this._eventsActiveDic = new Dictionary();
         var _loc5_:Date = TimeManager.Instance.Now();
         for each(_loc2_ in param1)
         {
            if(_loc5_.time > _loc2_.start.time && _loc5_.time < _loc2_.end.time)
            {
               this._eventsActiveDic[_loc4_] = _loc2_;
               _loc3_ = _loc4_.toString();
               this.leftViewInfoDic[_loc3_] = new LeftViewInfoVo(_loc4_,"· " + _loc2_.Title,1);
               this.addElement(_loc3_);
               _loc4_++;
            }
         }
      }
      
      public function getActivityDataById(param1:String) : GmActivityInfo
      {
         return this.activityData[param1];
      }
      
      public function getActivityInitDataById(param1:String) : Object
      {
         return this.activityInitData[param1];
      }
      
      public function get frame() : LimitActivityFrame
      {
         return this._frame;
      }
      
      public function get sendFrame() : SendGiftActivityFrame
      {
         return this._sendGiftFrame;
      }
      
      public function get actList() : Array
      {
         return this._actList;
      }
      
      protected function rookieRankHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:PackageIn = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         _loc8_ = param1.pkg;
         var _loc9_:int = _loc8_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc9_)
         {
            _loc3_ = _loc8_.readUTF();
            _loc4_ = _loc8_.readInt();
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc7_ = new RookieRankInfo();
               _loc7_.userId = _loc8_.readInt();
               _loc7_.rank = _loc8_.readInt();
               _loc7_.playerName = _loc8_.readUTF();
               _loc7_.fightPower = _loc8_.readInt();
               _loc5_.push(_loc7_);
               _loc6_++;
            }
            if(_loc5_.length > 10)
            {
               _loc5_ = _loc5_.slice(0,10);
            }
            _loc5_.sortOn("rank",16);
            this.rankActDic[_loc3_] = _loc5_;
            _loc2_++;
         }
      }
   }
}

