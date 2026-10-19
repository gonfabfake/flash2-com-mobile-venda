package memoryGame
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.CoreManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelperDataModuleLoad;
   import ddt.utils.HelperUIModuleLoad;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import memoryGame.analyzer.MemoryGameAnalyzer;
   import memoryGame.data.MemoryGameGoodsInfo;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class MemoryGameManager extends CoreManager
   {
      
      private static var _instance:MemoryGameManager;
      
      public var turning:Boolean = false;
      
      public var getRewardList:DictionaryData;
      
      private var _isOpen:Boolean;
      
      private var _hall:HallStateView;
      
      private var _icon:BaseButton;
      
      private var _endDate:Date;
      
      private var _playOpenComplete:int;
      
      private var _playCloseComplete:int;
      
      private var _count:int;
      
      private var _score:int;
      
      private var _list:Vector.<MemoryGameGoodsInfo>;
      
      public function MemoryGameManager()
      {
         super();
         this.getRewardList = new DictionaryData();
      }
      
      public static function get instance() : MemoryGameManager
      {
         if(!_instance)
         {
            _instance = new MemoryGameManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MEMORYGAME_ISOPEN,this.__onGameOpen);
      }
      
      private function __onGameOpen(param1:CrazyTankSocketEvent) : void
      {
         this._isOpen = param1.pkg.readBoolean();
         this._endDate = param1.pkg.readDate();
         HallIconManager.instance.updateSwitchHandler("memoryGame",this._isOpen);
      }
      
      override protected function start() : void
      {
         new HelperDataModuleLoad().loadDataModule([StartupResourceLoader.Instance.creatMemoryGameAwardLoader],function():void
         {
            new HelperUIModuleLoad().loadUIModule(["memoryGame"],onComplete);
         });
      }
      
      private function onComplete() : void
      {
         var _loc1_:* = ComponentFactory.Instance.creatComponentByStylename("memoryGame.MemoryGameFrame");
         _loc1_.show();
      }
      
      public function playOpenAllComplete() : Boolean
      {
         return this._playOpenComplete == 0;
      }
      
      public function playCloseAllComplete() : Boolean
      {
         return this._playCloseComplete == 0;
      }
      
      public function playActionAllComplete() : Boolean
      {
         return this.playOpenAllComplete() && this.playCloseAllComplete();
      }
      
      public function playOpenStart() : void
      {
         ++this._playOpenComplete;
      }
      
      public function playOpenStop() : void
      {
         --this._playOpenComplete;
      }
      
      public function playCloseStart() : void
      {
         ++this._playCloseComplete;
      }
      
      public function playCloseStop() : void
      {
         --this._playCloseComplete;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function set score(param1:int) : void
      {
         if(this._score == param1)
         {
            return;
         }
         this._score = param1;
      }
      
      public function dateToString() : String
      {
         return DateUtils.dateFormat(this._endDate);
      }
      
      public function get endDate() : Date
      {
         return this._endDate;
      }
      
      public function analyzer(param1:MemoryGameAnalyzer) : void
      {
         this._list = param1.list;
      }
      
      public function goodsList() : Vector.<MemoryGameGoodsInfo>
      {
         return this._list;
      }
      
      public function get isValid() : Boolean
      {
         var _loc1_:Number = this._endDate.getTime();
         var _loc2_:Number = TimeManager.Instance.Now().getTime();
         if(_loc1_ > _loc2_)
         {
            return true;
         }
         return false;
      }
   }
}

