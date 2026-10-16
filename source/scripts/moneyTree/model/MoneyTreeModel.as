package moneyTree.model
{
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import ddt.utils.Helpers;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import moneyTree.MoneyTreeManager;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class MoneyTreeModel extends EventDispatcher
   {
      
      public static const COST_PER_SPEEDUP:int = 200;
      
      public static const TIMER:String = "mt_timer";
      
      private var _numRedPkgRemain:int;
      
      private var _numPersonsWillSendRedPkg:Dictionary = new Dictionary();
      
      private var _infoList:Vector.<MT_FruitData>;
      
      private var _timer:TimerJuggler;
      
      private var _curTime:Date;
      
      public function MoneyTreeModel()
      {
         var _loc1_:int = 0;
         super();
         this._infoList = new Vector.<MT_FruitData>();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            this._infoList[_loc1_] = new MT_FruitData();
            _loc1_++;
         }
         this._timer = TimerManager.getInstance().addTimerJuggler(1000,0,false);
         this._timer.addEventListener("timer",this.onTimer);
         this._timer.start();
         this.onTimer(null);
      }
      
      protected function onTimer(param1:Event) : void
      {
         this._curTime = TimeManager.Instance.Now();
         this.hasMatureFruit();
         dispatchEvent(new Event("mt_timer"));
      }
      
      private function hasMatureFruit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._infoList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(Boolean(this._infoList[_loc1_].timeGrown) && this._infoList[_loc1_].timeGrown.time - this._curTime.time <= 0)
            {
               MoneyTreeManager.getInstance().becomeMature();
               break;
            }
            _loc1_++;
         }
      }
      
      public function getCountDownString(param1:int) : String
      {
         if(this._infoList[param1].timeGrown == null)
         {
            return "00:00:00";
         }
         var _loc2_:Number = this._infoList[param1].timeGrown.time - this._curTime.time;
         if(_loc2_ <= 0)
         {
            return LanguageMgr.GetTranslation("moneyTree.MoneyTreeModel.TreeOK");
         }
         return Helpers.getTimeString(_loc2_);
      }
      
      public function getCurSlctTimesSpeedUpToMature(param1:int) : int
      {
         if(this._infoList[param1].timeGrown == null)
         {
            return 0;
         }
         var _loc2_:Number = this._infoList[param1].timeGrown.time - this._curTime.time;
         if(_loc2_ <= 0)
         {
            return 0;
         }
         return Math.ceil(_loc2_ / 3600000);
      }
      
      public function isNoMoreRedPkg() : Boolean
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         for each(_loc2_ in this._numPersonsWillSendRedPkg)
         {
            _loc1_++;
         }
         return _loc1_ >= this._numRedPkgRemain;
      }
      
      public function addFriendsToSend(param1:int) : void
      {
         this._numPersonsWillSendRedPkg[param1] = param1;
      }
      
      public function reduceFriendsToSend(param1:int) : void
      {
         delete this._numPersonsWillSendRedPkg[param1];
      }
      
      public function resetWillSendNum() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._numPersonsWillSendRedPkg)
         {
            delete this._numPersonsWillSendRedPkg[_loc1_];
         }
      }
      
      public function getFriendsToSendList() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for(_loc2_ in this._numPersonsWillSendRedPkg)
         {
            _loc1_.push(this._numPersonsWillSendRedPkg[_loc2_]);
         }
         return _loc1_;
      }
      
      public function getTimesToGrown(param1:int) : int
      {
         var _loc2_:* = NaN;
         var _loc3_:Number = this._infoList[param1].timeGrown.time - new Date().time;
         if(_loc3_ < 0)
         {
            return 0;
         }
         _loc2_ = 3600000;
         return Math.ceil(_loc3_ / _loc2_);
      }
      
      public function getPriceSpeedUp(param1:int) : int
      {
         return this._infoList[param1].priceSpeedUp;
      }
      
      public function setNumRedPkgRemain(param1:int) : void
      {
         this._numRedPkgRemain = param1;
      }
      
      public function getNumRedPkgRemain() : int
      {
         return this._numRedPkgRemain;
      }
      
      public function setInfoAt(param1:int, param2:Date, param3:int) : void
      {
         this._infoList[param1].timeGrown = param2;
         this._infoList[param1].priceSpeedUp = param3;
      }
      
      public function getInfoAt(param1:int) : MT_FruitData
      {
         if(Boolean(this._infoList))
         {
            return this._infoList[param1];
         }
         return null;
      }
      
      public function hasFruitMature() : Boolean
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._infoList)
         {
            if(Boolean(_loc1_.isGrown))
            {
               return true;
            }
         }
         return false;
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         TimerManager.getInstance().removeJugglerByTimer(this._timer);
         this._timer.removeEventListener("timer",this.onTimer);
         this._timer = null;
      }
   }
}

