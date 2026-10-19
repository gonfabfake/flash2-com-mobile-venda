package welfareCenter.callBackFund
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PkgEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import welfareCenter.WelfareCenterManager;
   
   public class CallBackFundManager extends EventDispatcher
   {
      
      private static var _instance:CallBackFundManager;
      
      public static const EVENT_STATE_CHANGE:String = "event_state_change";
      
      public static const STATE_QUICK_BUY:int = 0;
      
      public static const STATE_QUICK_RECEIVE:int = 1;
      
      public static const STATE_TOMORROW_COME:int = 2;
      
      public static const STATE_RECEIVE_OVER:int = 3;
      
      private var _state:int;
      
      private var _isOpen:Boolean;
      
      public var startTime:Date;
      
      public var endTime:Date;
      
      public var buyFundTime:Date;
      
      public var lastGetRewardTime:Date;
      
      public var isBuyFund:Boolean;
      
      public var firstReturnCount:int;
      
      public var dailyReturnCount:int;
      
      public var buyFundCount:int;
      
      public var totalReturnCount:int;
      
      private var _timer:Timer;
      
      public var downRewardInfoList:Array;
      
      public var dailyRewardInfoList:Array;
      
      public function CallBackFundManager(param1:IEventDispatcher = null)
      {
         super();
         _instance = this;
      }
      
      public static function get instance() : CallBackFundManager
      {
         if(_instance == null)
         {
            _instance = new CallBackFundManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(PkgEvent.format(343,1),this.onPackTypeBuyFund);
         SocketManager.Instance.addEventListener(PkgEvent.format(343,2),this.onPackTypeGetFund);
         SocketManager.Instance.addEventListener(PkgEvent.format(343,7),this.onPackTypeFundInfo);
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         if(Boolean(param1))
         {
            this.downRewardInfoList = [];
            this.dailyRewardInfoList = [];
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               if(_loc3_.Quality == 1)
               {
                  this.downRewardInfoList.push(_loc3_);
               }
               else
               {
                  this.dailyRewardInfoList.push(_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      public function createCell(param1:CallBackFundRewardInfo) : BagCell
      {
         var _loc2_:InventoryItemInfo = CallBackFundManager.instance.getInventoryItemInfo(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:BagCell = new BagCell(0,_loc2_,true);
         _loc3_.width = 64;
         _loc3_.height = 64;
         _loc3_.setCount(_loc2_.Count);
         return _loc3_;
      }
      
      public function getInventoryItemInfo(param1:CallBackFundRewardInfo) : InventoryItemInfo
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc3_.LuckCompose = param1.TemplateID;
         _loc3_.ValidDate = param1.ValidDate;
         _loc3_.Count = param1.Count;
         _loc3_.IsBinds = param1.IsBind;
         _loc3_.StrengthenLevel = param1.StrengthLevel;
         _loc3_.AttackCompose = param1.AttackCompose;
         _loc3_.DefendCompose = param1.DefendCompose;
         _loc3_.AgilityCompose = param1.AgilityCompose;
         _loc3_.LuckCompose = param1.LuckCompose;
         return _loc3_;
      }
      
      private function onPackTypeBuyFund(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.isBuyFund = _loc2_.readBoolean();
         this.buyFundTime = _loc2_.readDate();
         this.updateLastGetRewardTime();
         dispatchEvent(new Event("event_state_change"));
      }
      
      private function onPackTypeGetFund(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.lastGetRewardTime = _loc2_.readDate();
         this.updateLastGetRewardTime();
         if(this._state == 3)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("callBackFund.frame.receiveOverTip"));
            this._isOpen = false;
            WelfareCenterManager.instance.showMainIcon();
         }
         dispatchEvent(new Event("event_state_change"));
      }
      
      private function onPackTypeFundInfo(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.startTime = _loc2_.readDate();
         this.endTime = _loc2_.readDate();
         this.buyFundTime = _loc2_.readDate();
         this.lastGetRewardTime = _loc2_.readDate();
         this.isBuyFund = _loc2_.readBoolean();
         this.firstReturnCount = _loc2_.readInt();
         this.dailyReturnCount = _loc2_.readInt();
         this.buyFundCount = _loc2_.readInt();
         this.totalReturnCount = this.firstReturnCount + 6 * this.dailyReturnCount;
         this.updateLastGetRewardTime();
         var _loc3_:Number = TimeManager.Instance.NowTime();
         this._isOpen = PlayerManager.Instance.Self.isOld2 && (!this.isBuyFund && _loc3_ >= this.startTime.time && _loc3_ <= this.endTime.time || this.isBuyFund && this._state != 3);
         if(PlayerManager.Instance.Self.isOld2 && (!this.isBuyFund && _loc3_ >= this.startTime.time && _loc3_ <= this.endTime.time))
         {
            if(Boolean(this._timer))
            {
               this._timer.reset();
            }
            else
            {
               this._timer = new Timer(1000,2147483647);
            }
            this._timer.start();
            this._timer.addEventListener("timer",this.onCheckOpenTimer);
         }
         WelfareCenterManager.instance.showMainIcon();
      }
      
      private function onCheckOpenTimer(param1:TimerEvent) : void
      {
         var _loc2_:Number = TimeManager.Instance.NowTime();
         this._isOpen = PlayerManager.Instance.Self.isOld2 && (!this.isBuyFund && _loc2_ >= this.startTime.time && _loc2_ <= this.endTime.time || this.isBuyFund && this._state != 3);
         if(!this._isOpen)
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this.onCheckOpenTimer);
            WelfareCenterManager.instance.showMainIcon();
         }
      }
      
      public function getLeftReceiveTime() : int
      {
         var _loc1_:Date = this.getBuyFundTimeAfter6Day();
         return int((_loc1_.time - this.lastGetRewardTime.time) / 86400000);
      }
      
      public function getBuyFundTimeAfter6Day() : Date
      {
         var _loc1_:Date = new Date(this.buyFundTime.time + 518400000);
         _loc1_.hours = 23;
         _loc1_.minutes = 59;
         _loc1_.seconds = 59;
         return _loc1_;
      }
      
      private function updateLastGetRewardTime() : void
      {
         var _loc1_:* = null;
         var _loc2_:Date = TimeManager.Instance.Now();
         this._state = 0;
         if(this.isBuyFund)
         {
            _loc1_ = this.getBuyFundTimeAfter6Day();
            if(_loc1_.time > _loc2_.time)
            {
               if(_loc2_.fullYear == this.lastGetRewardTime.fullYear && _loc2_.month == this.lastGetRewardTime.month && _loc2_.date == this.lastGetRewardTime.date)
               {
                  if(_loc1_.date == this.lastGetRewardTime.date)
                  {
                     this._state = 3;
                  }
                  else
                  {
                     this._state = 2;
                  }
               }
               else
               {
                  this._state = 1;
               }
            }
            else
            {
               this._state = 3;
            }
         }
         WelfareCenterManager.instance.checkShineIcon();
      }
      
      public function getTodayBindQuanNum() : int
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         if(_loc1_.fullYear == this.buyFundTime.fullYear && _loc1_.month == this.buyFundTime.month && _loc1_.date == this.buyFundTime.date)
         {
            return this.firstReturnCount;
         }
         return this.dailyReturnCount;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get state() : int
      {
         return this._state;
      }
      
      public function set state(param1:int) : void
      {
         this._state = param1;
      }
   }
}

