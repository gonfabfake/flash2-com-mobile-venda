package treasure.model
{
   import flash.events.EventDispatcher;
   import treasure.data.TreasureTempInfo;
   
   public class TreasureModel extends EventDispatcher
   {
      
      private static var _instance:TreasureModel = null;
      
      private var _logoinDays:int;
      
      private var _leftTimes:int;
      
      private var _friendHelpTimes:int;
      
      private var _itemList:Vector.<TreasureTempInfo>;
      
      public var isClick:Boolean = true;
      
      private var _isEndTreasure:Boolean;
      
      private var _isBeginTreasure:Boolean;
      
      public function TreasureModel()
      {
         super();
      }
      
      public static function get instance() : TreasureModel
      {
         if(_instance == null)
         {
            _instance = new TreasureModel();
         }
         return _instance;
      }
      
      public function get logoinDays() : int
      {
         return this._logoinDays;
      }
      
      public function set logoinDays(param1:int) : void
      {
         this._logoinDays = param1;
      }
      
      public function get leftTimes() : int
      {
         return this._leftTimes;
      }
      
      public function set leftTimes(param1:int) : void
      {
         this._leftTimes = param1;
      }
      
      public function get friendHelpTimes() : int
      {
         return this._friendHelpTimes;
      }
      
      public function set friendHelpTimes(param1:int) : void
      {
         this._friendHelpTimes = param1;
      }
      
      public function get itemList() : Vector.<TreasureTempInfo>
      {
         return this._itemList;
      }
      
      public function set itemList(param1:Vector.<TreasureTempInfo>) : void
      {
         this._itemList = param1;
      }
      
      public function get isEndTreasure() : Boolean
      {
         return this._isEndTreasure;
      }
      
      public function set isEndTreasure(param1:Boolean) : void
      {
         this._isEndTreasure = param1;
      }
      
      public function get isBeginTreasure() : Boolean
      {
         return this._isBeginTreasure;
      }
      
      public function set isBeginTreasure(param1:Boolean) : void
      {
         this._isBeginTreasure = param1;
      }
   }
}

