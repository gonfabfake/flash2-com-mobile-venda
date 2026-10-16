package boguAdventure
{
   import boguAdventure.event.BoguAdventureEvent;
   import boguAdventure.model.BoguAdventureCellInfo;
   import boguAdventure.model.BoguAdventureModel;
   import boguAdventure.model.BoguAdventureType;
   import boguAdventure.player.BoguAdventurePlayer;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class BoguAdventureControl extends EventDispatcher
   {
      
      public static const SIGN_MAX_COUNT:int = 10;
      
      public var changeMouse:Boolean;
      
      public var currentIndex:int;
      
      private var _hp:int;
      
      public var isMove:Boolean;
      
      public var signFocus:Point;
      
      public var mineFocus:Point;
      
      public var mineNumFocus:Point;
      
      private var _bogu:BoguAdventurePlayer;
      
      private var _model:BoguAdventureModel;
      
      public function BoguAdventureControl()
      {
         super();
         this.init();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOGU_ADVENTURE,this.__onAllEvent);
      }
      
      private function init() : void
      {
         this._model = new BoguAdventureModel();
         this.signFocus = new Point(9,39);
         this.mineFocus = new Point(21,42);
         this.mineNumFocus = new Point(9,70);
      }
      
      private function __onAllEvent(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case BoguAdventureType.ENTER_BOGUADVENTURE:
               this.enterGame(_loc2_);
               break;
            case BoguAdventureType.UPDATE_CELL:
               this.updateCell(_loc2_);
               break;
            case BoguAdventureType.REVIVE_GAME:
               this.revive(_loc2_);
               break;
            case BoguAdventureType.ACQUIRE_AWARD:
               this.acquireAward(_loc2_);
               break;
            case BoguAdventureType.FREE_RESET:
               this._model.resetCount = _loc2_.readInt();
               this._model.isFreeReset = _loc2_.readBoolean();
               dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_RESET));
         }
      }
      
      private function enterGame(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BoguAdventureCellInfo = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Vector.<BoguAdventureCellInfo> = new Vector.<BoguAdventureCellInfo>();
         this.currentIndex = param1.readInt();
         this.hp = param1.readInt();
         this._model.isAcquireAward1 = Boolean(param1.readInt() == 1);
         this._model.isAcquireAward2 = Boolean(param1.readInt() == 1);
         this._model.isAcquireAward3 = Boolean(param1.readInt() == 1);
         this._model.openCount = param1.readInt();
         this._model.findMinePrice = param1.readInt();
         this._model.revivePrice = param1.readInt();
         this._model.resetPrice = param1.readInt();
         this._model.isFreeReset = param1.readBoolean();
         this._model.resetCount = param1.readInt();
         _loc2_ = param1.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_)
         {
            _loc3_ = new BoguAdventureCellInfo();
            _loc3_.index = param1.readInt();
            _loc3_.state = param1.readInt();
            _loc3_.result = param1.readInt();
            _loc3_.aroundMineCount = param1.readInt();
            _loc6_.push(_loc3_);
            _loc7_++;
         }
         this._model.mapInfoList = _loc6_;
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < 3)
         {
            _loc8_.push(param1.readInt());
            _loc2_ = param1.readInt();
            _loc4_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc4_ += ItemManager.Instance.getTemplateById(param1.readInt()).Name + "x";
               _loc4_ += param1.readInt().toString();
               _loc4_ += "\n";
               _loc5_++;
            }
            _loc9_.push(_loc4_);
            _loc7_++;
         }
         this._model.awardCount = _loc8_;
         this._model.awardGoodsTip = _loc9_;
         if(Boolean(this._bogu))
         {
            dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_MAP));
         }
      }
      
      private function updateCell(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:int = param1.readInt();
         var _loc4_:int = param1.readInt();
         this._model.findMinePrice = param1.readInt();
         if(_loc2_ == 4)
         {
            this.currentIndex = _loc3_;
            this.hp = param1.readInt();
            this._model.openCount = param1.readInt();
         }
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_CELL,{
            "type":_loc2_,
            "result":_loc4_,
            "index":_loc3_
         }));
      }
      
      private function revive(param1:PackageIn) : void
      {
         this.hp = param1.readInt();
      }
      
      private function acquireAward(param1:PackageIn) : void
      {
         this._model.isAcquireAward1 = Boolean(param1.readInt() == 1);
         this._model.isAcquireAward2 = Boolean(param1.readInt() == 1);
         this._model.isAcquireAward3 = Boolean(param1.readInt() == 1);
      }
      
      public function checkGameOver() : Boolean
      {
         if(this._model.openCount >= this._model.awardCount[2])
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.gameOver"));
            return true;
         }
         if(this._hp <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.hpNotEnough"));
            return true;
         }
         if(!BoguAdventureManager.instance.isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("boguAdventure.view.activityOver"));
            return true;
         }
         return false;
      }
      
      public function walk(param1:Array) : void
      {
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.WALK,param1));
      }
      
      public function walkComplete() : void
      {
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.STOP));
      }
      
      public function playActionComplete(param1:Object = null) : void
      {
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.ACTION_COMPLETE,param1));
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function set hp(param1:int) : void
      {
         if(this._hp == param1)
         {
            return;
         }
         this._hp = param1;
         dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.CHANGE_HP));
      }
      
      public function get bogu() : BoguAdventurePlayer
      {
         return this._bogu;
      }
      
      public function set bogu(param1:BoguAdventurePlayer) : void
      {
         this._bogu = param1;
         if(this._model.mapInfoList != null)
         {
            dispatchEvent(new BoguAdventureEvent(BoguAdventureEvent.UPDATE_MAP));
         }
      }
      
      public function get model() : BoguAdventureModel
      {
         return this._model;
      }
      
      public function checkGetAward() : Boolean
      {
         if(this._model.openCount >= this._model.awardCount[0] && !this._model.isAcquireAward1 || this._model.openCount >= this._model.awardCount[1] && !this._model.isAcquireAward2 || this._model.openCount >= this._model.awardCount[2] && !this._model.isAcquireAward3)
         {
            return true;
         }
         return false;
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOGU_ADVENTURE,this.__onAllEvent);
         this._bogu = null;
         this._model.dispose();
         this._model = null;
         this.signFocus = null;
         this.mineFocus = null;
         this.mineNumFocus = null;
      }
   }
}

