package foodActivity
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.CoreManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.view.FoodActivityEnterIcon;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import foodActivity.event.FoodActivityEvent;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class FoodActivityManager extends CoreManager
   {
      
      private static var _instance:FoodActivityManager;
      
      private var _info:GmActivityInfo;
      
      public var _isStart:Boolean;
      
      public var ripeNum:int;
      
      public var cookingCount:int;
      
      public var state:int;
      
      public var currentSumTime:int;
      
      public var delayTime:int;
      
      private var _timer:Timer;
      
      public var sumTime:int;
      
      private var _actId:String;
      
      private var _foodActivityEnterIcon:FoodActivityEnterIcon;
      
      private var _hallView:HallStateView;
      
      public function FoodActivityManager()
      {
         super();
      }
      
      public static function get Instance() : FoodActivityManager
      {
         if(_instance == null)
         {
            _instance = new FoodActivityManager();
         }
         return _instance;
      }
      
      public function setUp() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FOOD_ACTIVITY,this.pkgHandler);
      }
      
      protected function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case FoodActivityEvent.ACTIVITY_STATE:
               this.openOrCloseHandler(_loc2_);
               break;
            case FoodActivityEvent.UPDATE_COUNT:
               this.updateCookingCount(_loc2_);
               break;
            case FoodActivityEvent.SIMPLE_COOKING:
               this.cookingHanlder(_loc2_);
               break;
            case FoodActivityEvent.PAY_COOKING:
               this.cookingHanlder(_loc2_);
               break;
            case FoodActivityEvent.REWARD:
               dispatchEvent(new FoodActivityEvent(FoodActivityEvent.FOOD_REWARD,_loc2_));
               break;
            case FoodActivityEvent.CLEAN_DATA:
               this.cleanDataHandler(_loc2_);
         }
      }
      
      private function cleanDataHandler(param1:PackageIn) : void
      {
         this.sumTime = this.currentSumTime = this.cookingCount = this.ripeNum = 0;
         this.updateView();
         if(!this._info)
         {
            return;
         }
         if(this.info.activityChildType == 0)
         {
            this.startTime();
         }
      }
      
      private function cookingHanlder(param1:PackageIn) : void
      {
         this.cookingCount = param1.readInt();
         this.ripeNum = param1.readInt();
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.text = "" + this.cookingCount;
         }
         dispatchEvent(new FoodActivityEvent(FoodActivityEvent.FOOD_UPDATEVIEW));
      }
      
      private function updateCookingCount(param1:PackageIn) : void
      {
         this.cookingCount = param1.readInt();
         this.currentSumTime = param1.readInt();
         this.delayTime = param1.readInt();
         if(!this._info)
         {
            return;
         }
         if(this.info.activityChildType == 0)
         {
            if(this.cookingCount == 0)
            {
               this.startTime(true);
            }
            else
            {
               this.endTime();
            }
         }
         this.updateView();
      }
      
      private function openOrCloseHandler(param1:PackageIn) : void
      {
         this._actId = param1.readUTF();
         this._isStart = param1.readBoolean();
         this.cookingCount = param1.readInt();
         this.ripeNum = param1.readInt();
         this.state = param1.readInt();
         this.currentSumTime = param1.readInt();
         if(this._isStart)
         {
            this.initData();
            if(Boolean(this._info))
            {
               this.initBtn();
               HallIconManager.instance.updateSwitchHandler("FoodActivity",this._isStart);
            }
         }
         else
         {
            this.info = null;
            this.sumTime = 0;
            if(Boolean(this._timer))
            {
               this._timer.stop();
               this._timer.removeEventListener("timer",this.__timerHandler);
               this._timer = null;
            }
            this.deleteBtn();
            dispatchEvent(new FoodActivityEvent(FoodActivityEvent.FOOD_CLOSEVIEW));
         }
      }
      
      public function checkOpen() : void
      {
         this.initData();
         if(Boolean(this._info))
         {
            this.initBtn();
         }
      }
      
      private function initData() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Dictionary = WonderfulActivityManager.Instance.activityData;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.activityType == 13 && (_loc3_.activityChildType == 0 || _loc3_.activityChildType == 1) && _loc1_.time >= Date.parse(_loc3_.beginTime) && _loc1_.time <= Date.parse(_loc3_.endShowTime))
            {
               this._info = _loc2_[this._actId] ? _loc2_[this._actId] : null;
               break;
            }
         }
      }
      
      public function initBtn() : void
      {
         if(!this._foodActivityEnterIcon)
         {
            this._foodActivityEnterIcon = new FoodActivityEnterIcon();
         }
         if(Boolean(this.info) && this.info.activityChildType == 0)
         {
            this._foodActivityEnterIcon.showTxt();
         }
      }
      
      public function startTime(param1:Boolean = false) : void
      {
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.startTime(param1);
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this.__timerHandler);
            this._timer = null;
         }
         this._timer = new Timer(1000,this.sumTime);
         this._timer.addEventListener("timer",this.__timerHandler);
         this._timer.start();
      }
      
      public function endTime() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.endTime();
         }
      }
      
      public function stopTime() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
         }
      }
      
      protected function __timerHandler(param1:TimerEvent) : void
      {
         --this.sumTime;
         if(Boolean(this._foodActivityEnterIcon))
         {
            this._foodActivityEnterIcon.updateTime();
         }
         if(FoodActivityManager.Instance.sumTime == 0)
         {
            this.stopTime();
            SocketManager.Instance.out.updateCookingCountByTime();
         }
      }
      
      public function deleteBtn() : void
      {
         if(Boolean(this._foodActivityEnterIcon))
         {
            HallIconManager.instance.updateSwitchHandler("FoodActivity",this._isStart);
            ObjectUtils.disposeObject(this._foodActivityEnterIcon);
            this._foodActivityEnterIcon = null;
         }
      }
      
      override protected function start() : void
      {
         dispatchEvent(new FoodActivityEvent(FoodActivityEvent.FOOD_OPENVIEW));
      }
      
      public function get info() : GmActivityInfo
      {
         return this._info;
      }
      
      public function set info(param1:GmActivityInfo) : void
      {
         this._info = param1;
      }
      
      public function get isStart() : Boolean
      {
         return this._isStart;
      }
      
      public function get foodActivityIcon() : FoodActivityEnterIcon
      {
         return this._foodActivityEnterIcon;
      }
   }
}

