package newYearRice.model
{
   import newYearRice.view.NewYearRiceOpenFrameView;
   
   public class NewYearRiceModel
   {
      
      private var _isOpen:Boolean;
      
      private var _playerNum:int;
      
      private var _currentNum:Array = [10,20,30,40];
      
      private var _maxNum:Array = [40,40,40,40];
      
      private var _itemInfoList:Array;
      
      private var _yearFoodInfo:int;
      
      private var _playersLength:int;
      
      private var _playersArray:Array;
      
      private var _roomType:int;
      
      private var _openFrameView:NewYearRiceOpenFrameView;
      
      private var _playerID:int;
      
      private var _playerName:String;
      
      public function NewYearRiceModel()
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
      
      public function get currentNum() : Array
      {
         return this._currentNum;
      }
      
      public function set currentNum(param1:Array) : void
      {
         this._currentNum = param1;
      }
      
      public function get maxNum() : Array
      {
         return this._maxNum;
      }
      
      public function set maxNum(param1:Array) : void
      {
         this._maxNum = param1;
      }
      
      public function get itemInfoList() : Array
      {
         return this._itemInfoList;
      }
      
      public function set itemInfoList(param1:Array) : void
      {
         this._itemInfoList = param1;
      }
      
      public function get yearFoodInfo() : int
      {
         return this._yearFoodInfo;
      }
      
      public function set yearFoodInfo(param1:int) : void
      {
         this._yearFoodInfo = param1;
      }
      
      public function get playerNum() : int
      {
         return this._playerNum;
      }
      
      public function set playerNum(param1:int) : void
      {
         this._playerNum = param1;
      }
      
      public function get playersLength() : int
      {
         return this._playersLength;
      }
      
      public function get playersArray() : Array
      {
         return this._playersArray;
      }
      
      public function set playersArray(param1:Array) : void
      {
         this._playersArray = param1;
      }
      
      public function get openFrameView() : NewYearRiceOpenFrameView
      {
         return this._openFrameView;
      }
      
      public function set openFrameView(param1:NewYearRiceOpenFrameView) : void
      {
         this._openFrameView = param1;
      }
      
      public function set playersLength(param1:int) : void
      {
         this._playersLength = param1;
      }
      
      public function get roomType() : int
      {
         return this._roomType;
      }
      
      public function set roomType(param1:int) : void
      {
         this._roomType = param1;
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function set playerID(param1:int) : void
      {
         this._playerID = param1;
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
      
      public function set playerName(param1:String) : void
      {
         this._playerName = param1;
      }
   }
}

