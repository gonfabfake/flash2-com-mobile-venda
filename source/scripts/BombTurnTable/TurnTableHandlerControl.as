package BombTurnTable
{
   import BombTurnTable.view.quality.BaseTurnTable;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class TurnTableHandlerControl
   {
      
      private static const FREQUENCY:int = 80;
      
      private var _timer:Timer;
      
      private var _turnTable:BaseTurnTable;
      
      private var _winName:String;
      
      private var _winIndex:int;
      
      private var _meedAngle:Number;
      
      private var _totalAngle:Number;
      
      private var _rounds:int = 4;
      
      private var _curTurnTableAngle:Number;
      
      private var _curSpeed:Number;
      
      private var _addSpeed:Number = 2;
      
      private var _maxSpeed:Number = 40;
      
      private var _obstruct:Number = 0.1;
      
      private var _accelerate:Boolean = true;
      
      private var _meedList:DictionaryData;
      
      public var _backFun:Function;
      
      public function TurnTableHandlerControl(param1:Function)
      {
         super();
         this._backFun = param1;
         this.init();
      }
      
      public function setData(param1:BaseTurnTable, param2:int, param3:String = null, param4:DictionaryData = null) : void
      {
         this._turnTable = param1;
         this._winIndex = param2 - 1;
         this._meedList = param4;
         this._curTurnTableAngle = this._turnTable.turnTable.rotation;
         this._curSpeed = 0;
         this._accelerate = true;
         this._meedAngle = this._winIndex * -1 * 45 - 22.5;
         this._totalAngle = this._meedAngle + this._rounds * 360;
      }
      
      public function startLottery() : void
      {
         if(Boolean(this._turnTable) && Boolean(this._turnTable.turnTable))
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function init() : void
      {
         this._timer = new Timer(80);
         this._timer.addEventListener("timer",this._frameRotation_Handler);
      }
      
      private function _frameRotation_Handler(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._accelerate)
         {
            if(this._curSpeed < this._maxSpeed)
            {
               this._curSpeed += this._addSpeed;
            }
            else
            {
               this._accelerate = false;
            }
         }
         else
         {
            _loc2_ = (this._totalAngle - this._curTurnTableAngle) * this._obstruct;
            this._curSpeed = _loc2_ > this._maxSpeed ? this._maxSpeed : Number(_loc2_);
            if(this._curSpeed < 0.1 || this._curTurnTableAngle >= this._totalAngle)
            {
               this._timer.stop();
               this.lotteryComplate();
            }
         }
         this._curTurnTableAngle += this._curSpeed;
         this._turnTable.turnTable.rotation = Number(this._curTurnTableAngle.toFixed(2));
      }
      
      private function lotteryComplate() : void
      {
         if(Boolean(this._backFun))
         {
            this._backFun(this._winIndex + 1);
         }
      }
      
      public function stop() : void
      {
         this._timer.stop();
         this._turnTable = null;
         if(Boolean(this._meedList))
         {
            this._meedList.clear();
         }
         this._meedList = null;
         this._backFun = null;
      }
   }
}

