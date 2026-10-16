package petIsland.model
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import petIsland.event.PetIslandEvent;
   
   public class PetIslandModel extends EventDispatcher
   {
      
      public var isOpen:Boolean;
      
      private var _pList:Array = [];
      
      public var infoStr:String = "";
      
      private var _openType:int;
      
      private var _playerBlood:int;
      
      private var _npcBlood:int;
      
      private var _playerScore:int;
      
      private var _npcScore:int;
      
      private var _round:int;
      
      private var _step:int;
      
      private var _currentLevel:int;
      
      private var _rewardRecord:String;
      
      private var _saveLifeCount:int;
      
      private var _saveLife2Count:int;
      
      public function PetIslandModel(param1:IEventDispatcher = null)
      {
         super();
      }
      
      public function get pList() : Array
      {
         return this._pList;
      }
      
      public function set pList(param1:Array) : void
      {
         this._pList = param1;
      }
      
      public function get openType() : int
      {
         return this._openType;
      }
      
      public function set openType(param1:int) : void
      {
         var _loc2_:int = this._openType;
         this._openType = param1;
         if(_loc2_ != param1)
         {
            dispatchEvent(new PetIslandEvent("openType"));
         }
      }
      
      public function get playerBlood() : int
      {
         return this._playerBlood;
      }
      
      public function set playerBlood(param1:int) : void
      {
         var _loc2_:int = this._playerBlood - param1;
         this._playerBlood = param1;
         dispatchEvent(new PetIslandEvent("playerBlood",_loc2_));
      }
      
      public function get npcBlood() : int
      {
         return this._npcBlood;
      }
      
      public function set npcBlood(param1:int) : void
      {
         var _loc2_:int = this._npcBlood - param1;
         this._npcBlood = param1;
         dispatchEvent(new PetIslandEvent("npcBlood",_loc2_));
      }
      
      public function get playerScore() : int
      {
         return this._playerScore;
      }
      
      public function set playerScore(param1:int) : void
      {
         this._playerScore = param1;
         dispatchEvent(new PetIslandEvent("playerscore"));
      }
      
      public function get npcScore() : int
      {
         return this._npcScore;
      }
      
      public function set npcScore(param1:int) : void
      {
         this._npcScore = param1;
         dispatchEvent(new PetIslandEvent("npcscore"));
      }
      
      public function get round() : int
      {
         return this._round;
      }
      
      public function set round(param1:int) : void
      {
         this._round = param1;
         dispatchEvent(new PetIslandEvent("round"));
      }
      
      public function get step() : int
      {
         return this._step;
      }
      
      public function set step(param1:int) : void
      {
         this._step = param1;
         dispatchEvent(new PetIslandEvent("step"));
      }
      
      public function get currentLevel() : int
      {
         return this._currentLevel;
      }
      
      public function set currentLevel(param1:int) : void
      {
         var _loc2_:int = this._currentLevel;
         this._currentLevel = param1;
         if(_loc2_ != param1)
         {
            dispatchEvent(new PetIslandEvent("currentLevel",this._npcBlood));
         }
      }
      
      public function get rewardRecord() : String
      {
         return this._rewardRecord;
      }
      
      public function set rewardRecord(param1:String) : void
      {
         var _loc2_:String = this._rewardRecord;
         this._rewardRecord = param1;
         if(_loc2_ != param1)
         {
            dispatchEvent(new PetIslandEvent("rewardRecord"));
         }
      }
      
      public function get saveLifeCount() : int
      {
         return this._saveLifeCount;
      }
      
      public function set saveLifeCount(param1:int) : void
      {
         this._saveLifeCount = param1;
         dispatchEvent(new PetIslandEvent("useSkill"));
      }
      
      public function get saveLife2Count() : int
      {
         return this._saveLife2Count;
      }
      
      public function set saveLife2Count(param1:int) : void
      {
         this._saveLife2Count = param1;
         dispatchEvent(new PetIslandEvent("useSkillTwo"));
      }
   }
}

