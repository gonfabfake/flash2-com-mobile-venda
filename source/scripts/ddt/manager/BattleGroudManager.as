package ddt.manager
{
   import battleGroud.BattleGroundAnalyer;
   import battleGroud.data.BatlleData;
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import ddt.events.PkgEvent;
   import flash.display.MovieClip;
   
   public class BattleGroudManager extends CoreManager
   {
      
      private static var _instance:BattleGroudManager;
      
      public static const BATTLE_OPENVIEW:String = "battleOpenView";
      
      private var _battleBtn:MovieClip;
      
      private var _lastCreatTime:int;
      
      private var _showModule:String = "";
      
      public var isShow:Boolean;
      
      public var initBattleIcon:Function;
      
      public var dispBattleIcon:Function;
      
      private var _battleDataList:Array;
      
      public function BattleGroudManager()
      {
         super();
      }
      
      public static function get Instance() : BattleGroudManager
      {
         if(!_instance)
         {
            _instance = new BattleGroudManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(PkgEvent.format(132,1),this.open);
         SocketManager.Instance.addEventListener(PkgEvent.format(132,2),this.over);
      }
      
      public function __onBattleBtnHander() : void
      {
      }
      
      public function createBattleRoom() : void
      {
      }
      
      private function playAllMc(param1:MovieClip) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         while(Boolean(param1.numChildren - _loc3_))
         {
            if(param1.getChildAt(_loc3_) is MovieClip)
            {
               _loc2_ = param1.getChildAt(_loc3_) as MovieClip;
               _loc2_.play();
               this.playAllMc(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function stopAllMc(param1:MovieClip) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         while(Boolean(param1.numChildren - _loc3_))
         {
            if(param1.getChildAt(_loc3_) is MovieClip)
            {
               _loc2_ = param1.getChildAt(_loc3_) as MovieClip;
               _loc2_.stop();
               this.stopAllMc(_loc2_);
            }
            _loc3_++;
         }
      }
      
      public function open(param1:PkgEvent) : void
      {
         this.isShow = true;
         if(PlayerManager.Instance.Self.Grade >= 20)
         {
            if(this.initBattleIcon != null)
            {
               this.initBattleIcon();
            }
         }
      }
      
      public function over(param1:PkgEvent) : void
      {
         this.isShow = false;
      }
      
      public function onShow() : void
      {
         this._showModule = "battleground";
         show();
      }
      
      override protected function start() : void
      {
         dispatchEvent(new CEvent("battleOpenView",this._showModule));
      }
      
      public function getBattleDataByPrestige(param1:int) : BatlleData
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._battleDataList.length);
         _loc2_ = _loc3_ - 1;
         while(_loc2_ >= 0)
         {
            if(param1 >= this._battleDataList[_loc2_].Prestige)
            {
               return this._battleDataList[_loc2_] as BatlleData;
            }
            _loc2_--;
         }
         return new BatlleData();
      }
      
      public function loadComplete(param1:BattleGroundAnalyer) : void
      {
         this._battleDataList = param1.battleDataList;
      }
      
      public function get battleDataList() : Array
      {
         return this._battleDataList;
      }
      
      public function getBattleDataByLevel(param1:int) : BatlleData
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._battleDataList.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 == this._battleDataList[_loc2_].Level)
            {
               return this._battleDataList[_loc2_] as BatlleData;
            }
            _loc2_++;
         }
         return new BatlleData();
      }
   }
}

