package superWinner.model
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import road7th.data.DictionaryData;
   import superWinner.data.SuperWinnerAwardsMode;
   import superWinner.data.SuperWinnerPlayerInfo;
   import superWinner.event.SuperWinnerEvent;
   
   public class SuperWinnerModel extends EventDispatcher
   {
      
      private const AWARDSNAME:Array = [LanguageMgr.GetTranslation("ddt.superWinner.award1"),LanguageMgr.GetTranslation("ddt.superWinner.award2"),LanguageMgr.GetTranslation("ddt.superWinner.award3"),LanguageMgr.GetTranslation("ddt.superWinner.award4"),LanguageMgr.GetTranslation("ddt.superWinner.award5"),LanguageMgr.GetTranslation("ddt.superWinner.award6")];
      
      private var _playerlist:DictionaryData;
      
      private var _self:PlayerInfo;
      
      private var _playerNum:uint;
      
      private var _awardArr:Array = [];
      
      private var _myAwardArr:Array = [];
      
      private var _isCurrentDiceGetAward:Boolean = false;
      
      private var _currentAwardLevel:uint;
      
      private var _currentDicePoints:Vector.<int>;
      
      private var _lastDicePoints:Vector.<int>;
      
      private var _championDices:Vector.<int>;
      
      private var _championInfo:SuperWinnerPlayerInfo;
      
      private var _roomId:int;
      
      private var _showMsg:Boolean;
      
      private var _endDate:Date;
      
      private var _awardsVector:Vector.<SuperWinnerAwardsMode>;
      
      public function SuperWinnerModel()
      {
         super();
         this._playerlist = new DictionaryData(true);
         this._self = PlayerManager.Instance.Self;
      }
      
      public function setRoomInfo(param1:PackageIn) : void
      {
         this.formatPlayerList(param1);
         this.formatAwards(param1);
         this.formatMyAwards(param1);
         this.flushChampion(param1);
         this._endDate = param1.readDate();
         this._roomId = param1.readInt();
      }
      
      public function formatPlayerList(param1:PackageIn) : void
      {
         var _loc2_:SuperWinnerPlayerInfo = null;
         this.playerNum = param1.readByte();
         var _loc3_:uint = 0;
         while(_loc3_ < this.playerNum)
         {
            _loc2_ = new SuperWinnerPlayerInfo();
            _loc2_.ID = param1.readInt();
            _loc2_.NickName = param1.readUTF();
            _loc2_.IsVIP = param1.readBoolean();
            _loc2_.Sex = param1.readBoolean();
            _loc2_.IsOnline = param1.readBoolean();
            _loc2_.Grade = param1.readByte();
            this._playerlist.add(_loc2_.ID,_loc2_);
            _loc3_++;
         }
         dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.INIT_PLAYERS));
      }
      
      public function formatAwards(param1:PackageIn) : void
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 6)
         {
            _loc2_.push(param1.readByte());
            _loc3_++;
         }
         this.awards = _loc2_;
         dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.FLUSH_AWARDS));
      }
      
      public function sendGetAwardsMsg(param1:PackageIn) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:SuperWinnerEvent = null;
         var _loc7_:int = param1.readByte();
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc2_ = param1.readUTF();
            _loc3_ = uint(param1.readByte());
            if(_loc3_ != 6)
            {
               _loc4_ = this.getAwardNameByLevel(_loc3_);
               _loc5_ = LanguageMgr.GetTranslation("ddt.superWinner.someoneGetAward",_loc2_,_loc4_);
               _loc6_ = new SuperWinnerEvent(SuperWinnerEvent.NOTICE);
               _loc6_.resultData = _loc5_;
               dispatchEvent(_loc6_);
            }
            _loc8_++;
         }
      }
      
      public function getAwardNameByLevel(param1:int) : String
      {
         return this.AWARDSNAME[param1 - 1];
      }
      
      public function formatMyAwards(param1:PackageIn) : void
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < 6)
         {
            _loc2_.push(param1.readByte());
            _loc3_++;
         }
         this.myAwards = _loc2_;
         dispatchEvent(new SuperWinnerEvent(SuperWinnerEvent.FLUSH_MY_AWARDS));
      }
      
      public function flushChampion(param1:PackageIn, param2:Boolean = false) : void
      {
         var _loc3_:SuperWinnerEvent = null;
         var _loc4_:Boolean = false;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:int = param1.readInt();
         this._showMsg = param2;
         if(_loc7_ == 0)
         {
            return;
         }
         _loc4_ = false;
         _loc5_ = new Vector.<int>(6);
         if(Boolean(this.championItem))
         {
            _loc4_ = true;
         }
         this.setChampionItem(_loc7_);
         _loc6_ = 0;
         while(_loc6_ < 6)
         {
            _loc5_[_loc6_] = param1.readByte();
            _loc6_++;
         }
         this.championDices = _loc5_;
         _loc3_ = new SuperWinnerEvent(SuperWinnerEvent.CHAMPIOM_CHANGE);
         _loc3_.resultData = _loc4_;
         dispatchEvent(_loc3_);
      }
      
      public function get isShowChampionMsg() : Boolean
      {
         return this._showMsg;
      }
      
      public function joinRoom(param1:PackageIn) : void
      {
         var _loc2_:SuperWinnerPlayerInfo = new SuperWinnerPlayerInfo();
         _loc2_.ID = param1.readInt();
         _loc2_.NickName = param1.readUTF();
         _loc2_.IsVIP = param1.readBoolean();
         _loc2_.Sex = param1.readBoolean();
         _loc2_.IsOnline = param1.readBoolean();
         _loc2_.Grade = param1.readByte();
         this._playerlist.add(_loc2_.ID,_loc2_);
      }
      
      public function set lastDicePoints(param1:Vector.<int>) : void
      {
         this._lastDicePoints = param1;
      }
      
      public function get lastDicePoints() : Vector.<int>
      {
         return this._lastDicePoints;
      }
      
      public function set currentDicePoints(param1:Vector.<int>) : void
      {
         this._currentDicePoints = param1;
      }
      
      public function get currentDicePoints() : Vector.<int>
      {
         return this._currentDicePoints;
      }
      
      public function set isCurrentDiceGetAward(param1:Boolean) : void
      {
         this._isCurrentDiceGetAward = param1;
      }
      
      public function get isCurrentDiceGetAward() : Boolean
      {
         return this._isCurrentDiceGetAward;
      }
      
      public function set currentAwardLevel(param1:uint) : void
      {
         this._currentAwardLevel = param1;
      }
      
      public function get currentAwardLevel() : uint
      {
         return this._currentAwardLevel;
      }
      
      public function getPlayerList() : DictionaryData
      {
         return this._playerlist;
      }
      
      public function getSelfPlayerInfo() : PlayerInfo
      {
         return this._self;
      }
      
      public function set playerNum(param1:uint) : void
      {
         this._playerNum = param1;
      }
      
      public function get playerNum() : uint
      {
         return this._playerNum;
      }
      
      public function set awards(param1:Array) : void
      {
         this._awardArr = param1;
      }
      
      public function get awards() : Array
      {
         return this._awardArr;
      }
      
      public function set myAwards(param1:Array) : void
      {
         this._myAwardArr = param1;
      }
      
      public function get myAwards() : Array
      {
         return this._myAwardArr;
      }
      
      public function set championDices(param1:Vector.<int>) : void
      {
         this._championDices = param1;
      }
      
      public function get championDices() : Vector.<int>
      {
         return this._championDices;
      }
      
      public function setChampionItem(param1:int) : void
      {
         this._championInfo = this.getPlayerList()[param1];
      }
      
      public function get championItem() : SuperWinnerPlayerInfo
      {
         return this._championInfo;
      }
      
      public function get roomId() : int
      {
         return this._roomId;
      }
      
      public function get endData() : Date
      {
         return this._endDate;
      }
      
      public function get awardsVector() : Vector.<SuperWinnerAwardsMode>
      {
         return this._awardsVector;
      }
      
      public function set awardsVector(param1:Vector.<SuperWinnerAwardsMode>) : void
      {
         this._awardsVector = param1;
      }
   }
}

