package prayIndiana.model
{
   public class PrayIndianaModel
   {
      
      private var _isOpen:Boolean = false;
      
      private var _goodsAll:Array;
      
      private var _position:int;
      
      private var _templateID:int;
      
      private var _getGoods:Array = [];
      
      private var _PrayGoodsCount:int;
      
      private var _UpdateRateCount:int;
      
      private var _PrayLotteryGoodsCount:int;
      
      private var _prayInfo:Array;
      
      private var _IsPray:Boolean;
      
      private var _type:int;
      
      private var _probabilityNum:int;
      
      private var _gameTimes:String;
      
      public function PrayIndianaModel()
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
      
      public function get goodsAll() : Array
      {
         return this._goodsAll;
      }
      
      public function set goodsAll(param1:Array) : void
      {
         this._goodsAll = param1;
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function set position(param1:int) : void
      {
         this._position = param1;
      }
      
      public function get templateID() : int
      {
         return this._templateID;
      }
      
      public function set templateID(param1:int) : void
      {
         this._templateID = param1;
      }
      
      public function get getGoods() : Array
      {
         return this._getGoods;
      }
      
      public function set getGoods(param1:Array) : void
      {
         this._getGoods = param1;
      }
      
      public function get prayInfo() : Array
      {
         return this._prayInfo;
      }
      
      public function get PrayGoodsCount() : int
      {
         return this._PrayGoodsCount;
      }
      
      public function set PrayGoodsCount(param1:int) : void
      {
         this._PrayGoodsCount = param1;
      }
      
      public function get UpdateRateCount() : int
      {
         return this._UpdateRateCount;
      }
      
      public function set UpdateRateCount(param1:int) : void
      {
         this._UpdateRateCount = param1;
      }
      
      public function get PrayLotteryGoodsCount() : int
      {
         return this._PrayLotteryGoodsCount;
      }
      
      public function set PrayLotteryGoodsCount(param1:int) : void
      {
         this._PrayLotteryGoodsCount = param1;
      }
      
      public function set prayInfo(param1:Array) : void
      {
         this._prayInfo = param1;
      }
      
      public function get IsPray() : Boolean
      {
         return this._IsPray;
      }
      
      public function set IsPray(param1:Boolean) : void
      {
         this._IsPray = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get probabilityNum() : int
      {
         return this._probabilityNum;
      }
      
      public function set probabilityNum(param1:int) : void
      {
         this._probabilityNum = param1;
      }
      
      public function get gameTimes() : String
      {
         return this._gameTimes;
      }
      
      public function set gameTimes(param1:String) : void
      {
         this._gameTimes = param1;
      }
   }
}

