package welfareCenter.callBackLotteryDraw
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.CoreManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelperUIModuleLoad;
   import ddt.view.LuckeyLotteryDrawIcon;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   import welfareCenter.WelfareCenterManager;
   
   public class CallBackLotteryDrawManager extends CoreManager
   {
      
      public static var _firstEnterCdSec:int;
      
      private static var _instance:CallBackLotteryDrawManager;
      
      public static const TYPE_CALLBACK:int = 0;
      
      public static const TYPE_LUCKEY:int = 1;
      
      public static const EACH_PHASE_CARD_NUM:int = 5;
      
      public static const EVENT_OPEN_FRAME:String = "event_open_frame";
      
      public static const EVENT_ZERO_FRESH:String = "event_zero_fresh";
      
      public static const EVENT_INFO_CHANGE:String = "event_info_change";
      
      public static const EVENT_OP_BACK_BUY:String = "event_op_back_buy";
      
      public static const CLICK_CARD_OPEN_ITEM:String = "click_card_open_item";
      
      public static const CLICK_CARD_OPEN_PLAY_OVER:String = "click_card_open_play_over";
      
      public var callBackLotteryDrawModel:LotteryDrawModel;
      
      public var luckeyLotteryDrawModel:LotteryDrawModel;
      
      public var type:int;
      
      private var _callBackTimer:Timer;
      
      private var _luckeyTimer:Timer;
      
      private var _timer:Timer;
      
      private var _luckeyLotteryDrawIcon:LuckeyLotteryDrawIcon;
      
      public function CallBackLotteryDrawManager(param1:IEventDispatcher = null)
      {
         super(param1);
         _instance = this;
         this.callBackLotteryDrawModel = new LotteryDrawModel();
         this.luckeyLotteryDrawModel = new LotteryDrawModel();
      }
      
      public static function get instance() : CallBackLotteryDrawManager
      {
         if(_instance == null)
         {
            _instance = new CallBackLotteryDrawManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(PkgEvent.format(343,8),this.onPackTypeInfo);
         SocketManager.Instance.addEventListener(PkgEvent.format(343,9),this.onPackTypeGoods);
         SocketManager.Instance.addEventListener(PkgEvent.format(343,4),this.onPackTypeBuy);
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["welfareCenter"],function():void
         {
            queryLotteryGoods(type);
         });
      }
      
      public function queryLotteryGoods(param1:int) : void
      {
         this.type = param1;
         SocketManager.Instance.out.refreshCallLotteryDrawInfo(this.type);
         SocketManager.Instance.out.queryCallLotteryDrawGoods(this.type);
      }
      
      private function onPackTypeInfo(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.initModel(this.callBackLotteryDrawModel,_loc2_);
         this.initModel(this.luckeyLotteryDrawModel,_loc2_);
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            dispatchEvent(new Event("event_zero_fresh"));
         }
         this.checkCallBackActiveOpen();
         this.checkLuckeyActiveOpen();
         this.checkLuckIconAndShowIcon();
         WelfareCenterManager.instance.showMainIcon();
         if(this.callBackLotteryDrawModel.isOpen)
         {
            if(Boolean(this._callBackTimer))
            {
               this._callBackTimer.reset();
            }
            else
            {
               this._callBackTimer = new Timer(1000,2147483647);
            }
            this._callBackTimer.start();
            this._callBackTimer.addEventListener("timer",this.onCheckOpenCallBackTimer);
         }
         if(this.luckeyLotteryDrawModel.isOpen)
         {
            if(Boolean(this._luckeyTimer))
            {
               this._luckeyTimer.reset();
            }
            else
            {
               this._luckeyTimer = new Timer(1000,2147483647);
            }
            this._luckeyTimer.start();
            this._luckeyTimer.addEventListener("timer",this.onCheckOpenLuckeyTimer);
         }
         dispatchEvent(new Event("event_info_change"));
      }
      
      public function checkLuckIconAndShowIcon() : void
      {
         _firstEnterCdSec = CallBackLotteryDrawManager.instance.getLuckeyLeftSec();
         if(_firstEnterCdSec > 0)
         {
            this._timer = new Timer(1000,_firstEnterCdSec);
            this._timer.addEventListener("timer",this.onTimerTick);
            this._timer.start();
         }
         else
         {
            _firstEnterCdSec = 0;
            HallIconManager.instance.updateSwitchHandler("luckLotteryDraw",this.luckeyLotteryDrawModel.isOpen);
         }
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         _firstEnterCdSec = CallBackLotteryDrawManager.instance.getLuckeyLeftSec();
         --_firstEnterCdSec;
         if(_firstEnterCdSec <= 0)
         {
            _firstEnterCdSec = 0;
            this._timer.stop();
            this._timer.removeEventListener("timer",this.onTimerTick);
         }
         this.updateLeftTimeTf();
      }
      
      private function updateLeftTimeTf() : void
      {
         var _loc1_:Array = TimeManager.getHHMMSSArr(_firstEnterCdSec);
         if(Boolean(_loc1_))
         {
            HallIconManager.instance.updateSwitchHandler("luckLotteryDraw",this.luckeyLotteryDrawModel.isOpen,_loc1_.join(":"));
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler("luckLotteryDraw",this.luckeyLotteryDrawModel.isOpen,"");
         }
      }
      
      private function onCheckOpenCallBackTimer(param1:TimerEvent) : void
      {
         this.checkCallBackActiveOpen();
         if(!this.callBackLotteryDrawModel.isOpen)
         {
            this._callBackTimer.removeEventListener("timer",this.onCheckOpenCallBackTimer);
            this._callBackTimer.stop();
            WelfareCenterManager.instance.showMainIcon();
         }
      }
      
      private function onCheckOpenLuckeyTimer(param1:TimerEvent) : void
      {
         this.checkLuckeyActiveOpen();
         if(!this.luckeyLotteryDrawModel.isOpen)
         {
            this._luckeyTimer.removeEventListener("timer",this.onCheckOpenLuckeyTimer);
            this._luckeyTimer.stop();
            WelfareCenterManager.instance.showMainIcon();
         }
      }
      
      public function checkCallBackActiveOpen() : void
      {
         WelfareCenterManager.instance.checkShineIcon();
         this.callBackLotteryDrawModel.isOpen = false;
         var _loc1_:Number = TimeManager.Instance.NowTime();
         if(_loc1_ >= this.callBackLotteryDrawModel.startTime.time && _loc1_ <= this.callBackLotteryDrawModel.endTime.time && PlayerManager.Instance.Self.isOld2)
         {
            if(this.callBackLotteryDrawModel.phase < this.callBackLotteryDrawModel.phaseEndTimeArr.length - 1 || this.callBackLotteryDrawModel.phase >= this.callBackLotteryDrawModel.phaseEndTimeArr.length - 1 && this.callBackLotteryDrawModel.currPhaseHasGetCount < 5)
            {
               this.callBackLotteryDrawModel.isOpen = true;
            }
         }
      }
      
      public function checkLuckeyActiveOpen() : void
      {
         this.luckeyLotteryDrawModel.isOpen = false;
         var _loc1_:Number = TimeManager.Instance.NowTime();
         if(_loc1_ >= this.luckeyLotteryDrawModel.startTime.time && _loc1_ <= this.luckeyLotteryDrawModel.endTime.time)
         {
            if(this.luckeyLotteryDrawModel.phase < this.luckeyLotteryDrawModel.phaseEndTimeArr.length - 1 || this.luckeyLotteryDrawModel.phase >= this.luckeyLotteryDrawModel.phaseEndTimeArr.length - 1 && this.luckeyLotteryDrawModel.currPhaseHasGetCount < 5)
            {
               this.luckeyLotteryDrawModel.isOpen = true;
            }
         }
      }
      
      private function initModel(param1:LotteryDrawModel, param2:PackageIn) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         param1.startTime = param2.readDate();
         param1.endTime = param2.readDate();
         param1.phase = param2.readInt();
         param1.currPhaseHasGetCount = param2.readInt();
         param1.lastRefreshTime = param2.readDate();
         param1.phaseEndTimeArr = [];
         var _loc5_:int = param2.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = {
               "Order":param2.readInt(),
               "Time":param2.readInt()
            };
            param1.phaseEndTimeArr.push(_loc4_);
            _loc3_++;
         }
         if(_loc5_ > 0)
         {
            param1.phaseEndTimeArr.sortOn("Order",16);
         }
      }
      
      private function onPackTypeGoods(param1:PkgEvent) : void
      {
         var _loc8_:int = 0;
         var _loc9_:PackageIn = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         _loc9_ = param1.pkg;
         _loc8_ = _loc9_.readInt();
         if(_loc8_ == 0)
         {
            _loc2_ = this.callBackLotteryDrawModel;
         }
         else
         {
            _loc2_ = this.luckeyLotteryDrawModel;
         }
         var _loc10_:Array = [];
         var _loc11_:int = _loc9_.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            _loc4_ = _loc9_.readInt();
            _loc9_.readInt();
            _loc5_ = {
               "Index":_loc4_,
               "LimitCount":_loc9_.readInt(),
               "TemplateID":_loc9_.readInt(),
               "Count":_loc9_.readInt(),
               "VaildDate":_loc9_.readInt(),
               "Cost":_loc9_.readInt(),
               "IsCanGet":_loc9_.readBoolean()
            };
            _loc6_ = ItemManager.Instance.getTemplateById(_loc5_["TemplateID"]);
            _loc7_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc7_,_loc6_);
            _loc7_.ValidDate = _loc5_["ValidDate"];
            _loc7_.Count = _loc5_["Count"];
            _loc7_.IsBinds = true;
            _loc5_["InventoryItemInfo"] = _loc7_;
            _loc10_.push(_loc5_);
            _loc3_++;
         }
         _loc2_.awardArr = _loc10_;
         if(Boolean(_loc2_.isOpen))
         {
            dispatchEvent(new Event("event_open_frame"));
         }
      }
      
      public function getCallBackLeftSec() : int
      {
         if(this.callBackLotteryDrawModel.phase != 0 && this.callBackLotteryDrawModel.currPhaseHasGetCount == 0)
         {
            return 0;
         }
         if(this.callBackLotteryDrawModel.phase < this.callBackLotteryDrawModel.phaseEndTimeArr.length)
         {
            return (this.callBackLotteryDrawModel.lastRefreshTime.time + this.callBackLotteryDrawModel.phaseEndTimeArr[this.callBackLotteryDrawModel.phase].Time * 1000 - TimeManager.Instance.Now().time) / 1000;
         }
         return 0;
      }
      
      public function getLuckeyLeftSec() : int
      {
         if(this.luckeyLotteryDrawModel.phase != 0 && this.luckeyLotteryDrawModel.currPhaseHasGetCount == 0)
         {
            return 0;
         }
         if(this.luckeyLotteryDrawModel.phase < this.luckeyLotteryDrawModel.phaseEndTimeArr.length)
         {
            return (this.luckeyLotteryDrawModel.lastRefreshTime.time + this.luckeyLotteryDrawModel.phaseEndTimeArr[this.luckeyLotteryDrawModel.phase].Time * 1000 - TimeManager.Instance.Now().time) / 1000;
         }
         return 0;
      }
      
      public function onPackTypeBuy(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc5_:Boolean = false;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         _loc5_ = _loc2_.readBoolean();
         var _loc6_:* = !_loc5_;
         var _loc7_:Object = {
            "index":_loc4_,
            "res":_loc6_
         };
         if(_loc3_ == 0)
         {
            if(Boolean(_loc6_))
            {
               this.callBackLotteryDrawModel.awardArr[_loc4_]["IsCanGet"] = false;
               if(this.callBackLotteryDrawModel.currPhaseHasGetCount > 1)
               {
                  ++this.callBackLotteryDrawModel.currPhaseHasGetCount;
               }
            }
         }
         else if(_loc3_ == 1)
         {
            if(Boolean(_loc6_))
            {
               this.luckeyLotteryDrawModel.awardArr[_loc4_]["IsCanGet"] = false;
               if(this.luckeyLotteryDrawModel.currPhaseHasGetCount > 1)
               {
                  ++this.luckeyLotteryDrawModel.currPhaseHasGetCount;
               }
            }
         }
         dispatchEvent(new CEvent("event_op_back_buy",_loc7_));
      }
   }
}

