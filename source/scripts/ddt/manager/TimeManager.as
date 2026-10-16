package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class TimeManager
   {
      
      private static var _instance:TimeManager;
      
      public static const DAY_TICKS:Number = 1000 * 24 * 60 * 60;
      
      public static const HOUR_TICKS:Number = 1000 * 60 * 60;
      
      public static const Minute_TICKS:Number = 1000 * 60;
      
      public static const Second_TICKS:Number = 1000;
      
      private static var _dispatcher:EventDispatcher = new EventDispatcher();
      
      public static var CHANGE:String = "change";
      
      private var _serverDate:Date;
      
      private var _serverTick:int;
      
      private var _enterFightTime:Number;
      
      private var _startGameTime:Date;
      
      private var _currentTime:Date;
      
      private var _totalGameTime:Number;
      
      public function TimeManager()
      {
         super();
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.addEventListener(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.removeEventListener(param1,param2);
      }
      
      public static function get Instance() : TimeManager
      {
         if(_instance == null)
         {
            _instance = new TimeManager();
         }
         return _instance;
      }
      
      public static function getHHMMSSArr(param1:int) : Array
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(param1 > 0)
         {
            _loc3_ = setTwoDigit(param1 / 3600);
            _loc4_ = setTwoDigit(param1 % 3600 / 60);
            _loc5_ = setTwoDigit(param1 % 60);
            _loc2_ = [_loc3_,_loc4_,_loc5_];
         }
         return _loc2_;
      }
      
      public static function setTwoDigit(param1:int) : String
      {
         if(param1 < 10)
         {
            return "0" + param1;
         }
         return param1.toString();
      }
      
      public function setup() : void
      {
         this._serverDate = new Date();
         this._serverTick = getTimer();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SYS_DATE,this.__update);
      }
      
      private function __update(param1:CrazyTankSocketEvent) : void
      {
         this._serverTick = getTimer();
         this._serverDate = param1.pkg.readDate();
      }
      
      public function Now() : Date
      {
         return new Date(this._serverDate.getTime() + getTimer() - this._serverTick);
      }
      
      public function get serverDate() : Date
      {
         return this._serverDate;
      }
      
      public function get currentDay() : Number
      {
         return this.Now().getDay();
      }
      
      public function TimeSpanToNow(param1:Date) : Date
      {
         return new Date(Math.abs(this._serverDate.getTime() + getTimer() - this._serverTick - param1.time));
      }
      
      public function TotalDaysToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / DAY_TICKS;
      }
      
      public function TotalHoursToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / HOUR_TICKS;
      }
      
      public function TotalMinuteToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / Minute_TICKS;
      }
      
      public function TotalSecondToNow(param1:Date) : Number
      {
         return (this._serverDate.getTime() + getTimer() - this._serverTick - param1.time) / Second_TICKS;
      }
      
      public function TotalDaysToNow2(param1:Date) : Number
      {
         var _loc2_:Date = this.Now();
         _loc2_.setHours(0,0,0,0);
         var _loc3_:Date = new Date(param1.time);
         _loc3_.setHours(0,0,0,0);
         return (_loc2_.time - _loc3_.time) / DAY_TICKS;
      }
      
      public function set totalGameTime(param1:int) : void
      {
         this._totalGameTime = param1;
         _dispatcher.dispatchEvent(new Event(TimeManager.CHANGE));
      }
      
      public function get totalGameTime() : int
      {
         return this._totalGameTime;
      }
      
      public function get enterFightTime() : Number
      {
         return this._enterFightTime;
      }
      
      public function set enterFightTime(param1:Number) : void
      {
         this._enterFightTime = param1;
      }
      
      public function getMaxRemainDateStr(param1:Date, param2:int = 1) : String
      {
         var _loc3_:String = null;
         if(!param1)
         {
            return "0" + LanguageMgr.GetTranslation("second");
         }
         var _loc4_:Number = param1.getTime();
         var _loc5_:Number = this.Now().getTime();
         var _loc6_:Number = _loc4_ - _loc5_;
         _loc6_ = _loc6_ - 10000 < 0 ? Number(_loc6_) : Number(_loc6_ - 10000);
         _loc6_ = _loc6_ < 0 ? Number(0) : Number(_loc6_);
         var _loc7_:int = 0;
         if(_loc6_ / DAY_TICKS > 1)
         {
            if(param2 == 1)
            {
               _loc7_ = Math.floor(_loc6_ / DAY_TICKS);
            }
            else
            {
               _loc7_ = Math.ceil(_loc6_ / DAY_TICKS);
            }
            _loc3_ = _loc7_ + LanguageMgr.GetTranslation("day");
         }
         else if(_loc6_ / HOUR_TICKS > 1)
         {
            _loc7_ = _loc6_ / HOUR_TICKS;
            _loc3_ = _loc7_ + LanguageMgr.GetTranslation("hour");
         }
         else if(_loc6_ / Minute_TICKS > 1)
         {
            _loc7_ = _loc6_ / Minute_TICKS;
            _loc3_ = _loc7_ + LanguageMgr.GetTranslation("minute");
         }
         else
         {
            _loc7_ = _loc6_ / Second_TICKS;
            _loc3_ = _loc7_ + LanguageMgr.GetTranslation("second");
         }
         return _loc3_;
      }
      
      public function NowTime() : Number
      {
         return this._serverDate.getTime() + getTimer() - this._serverTick;
      }
   }
}

