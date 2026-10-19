package cloudBuyLottery.model
{
   import cloudBuyLottery.view.WinningLogItemInfo;
   
   public class CloudBuyLotteryModel
   {
      
      private var _isOpen:Boolean;
      
      private var _luckTime:Date;
      
      public var myGiftData:Vector.<WinningLogItemInfo>;
      
      public var packsLen:int = 15;
      
      private var _moneyNum:int = 200;
      
      private var _templateId:int;
      
      private var _templatedIdCount:int;
      
      private var _validDate:int;
      
      private var _property:Array;
      
      private var _count:int;
      
      private var _buyGoodsIDArray:Array;
      
      private var _buyGoodsCountArray:Array;
      
      private var _buyMoney:int;
      
      private var _maxNum:int;
      
      private var _currentNum:int;
      
      private var _totalSeconds:int;
      
      private var _luckCount:int;
      
      private var _remainTimes:int;
      
      private var _luckDrawId:int;
      
      private var _isGame:Boolean;
      
      private var _isGetReward:Boolean;
      
      public function CloudBuyLotteryModel()
      {
         super();
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
      }
      
      public function get luckTime() : Date
      {
         return this._luckTime;
      }
      
      public function set luckTime(param1:Date) : void
      {
         this._luckTime = param1;
      }
      
      public function get moneyNum() : int
      {
         return this._moneyNum;
      }
      
      public function set moneyNum(param1:int) : void
      {
         this._moneyNum = param1;
      }
      
      public function get templateId() : int
      {
         return this._templateId;
      }
      
      public function set templateId(param1:int) : void
      {
         this._templateId = param1;
      }
      
      public function get validDate() : int
      {
         return this._validDate;
      }
      
      public function set validDate(param1:int) : void
      {
         this._validDate = param1;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get buyGoodsIDArray() : Array
      {
         return this._buyGoodsIDArray;
      }
      
      public function set buyGoodsIDArray(param1:Array) : void
      {
         this._buyGoodsIDArray = param1;
      }
      
      public function get buyGoodsCountArray() : Array
      {
         return this._buyGoodsCountArray;
      }
      
      public function set buyGoodsCountArray(param1:Array) : void
      {
         this._buyGoodsCountArray = param1;
      }
      
      public function get buyMoney() : int
      {
         return this._buyMoney;
      }
      
      public function set buyMoney(param1:int) : void
      {
         this._buyMoney = param1;
      }
      
      public function get maxNum() : int
      {
         return this._maxNum;
      }
      
      public function set maxNum(param1:int) : void
      {
         this._maxNum = param1;
      }
      
      public function get currentNum() : int
      {
         return this._currentNum;
      }
      
      public function set currentNum(param1:int) : void
      {
         this._currentNum = param1;
      }
      
      public function get totalSeconds() : int
      {
         return this._totalSeconds;
      }
      
      public function set totalSeconds(param1:int) : void
      {
         this._totalSeconds = param1;
      }
      
      public function get luckCount() : int
      {
         return this._luckCount;
      }
      
      public function set luckCount(param1:int) : void
      {
         this._luckCount = param1;
      }
      
      public function get remainTimes() : int
      {
         return this._remainTimes;
      }
      
      public function set remainTimes(param1:int) : void
      {
         this._remainTimes = param1;
      }
      
      public function get property() : Array
      {
         return this._property;
      }
      
      public function set property(param1:Array) : void
      {
         this._property = param1;
      }
      
      public function get luckDrawId() : int
      {
         return this._luckDrawId;
      }
      
      public function set luckDrawId(param1:int) : void
      {
         this._luckDrawId = param1;
      }
      
      public function get isGame() : Boolean
      {
         return this._isGame;
      }
      
      public function set isGame(param1:Boolean) : void
      {
         this._isGame = param1;
      }
      
      public function get isGetReward() : Boolean
      {
         return this._isGetReward;
      }
      
      public function set isGetReward(param1:Boolean) : void
      {
         this._isGetReward = param1;
      }
      
      public function get templatedIdCount() : int
      {
         return this._templatedIdCount;
      }
      
      public function set templatedIdCount(param1:int) : void
      {
         this._templatedIdCount = param1;
      }
   }
}

