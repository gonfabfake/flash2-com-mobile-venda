package battlePass
{
   import battlePass.data.QuestBattlePassInfo;
   import battlePass.loader.QuestBattlePassAnalyzer;
   import battlePass.loader.QuestBattlePassItemAnalyzer;
   import battlePass.view.BattlePassView;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperDataModuleLoad;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   
   public class BattlePassManager extends EventDispatcher
   {
      
      private static var _instance:BattlePassManager;
      
      public static const BATTLE_PASS_GET_INFO:String = "getBattlePassInfo";
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _battlePassView:BattlePassView;
      
      public var battlePassQuestList:Dictionary;
      
      public var battlePassQuestItems:Dictionary;
      
      public function BattlePassManager()
      {
         super();
      }
      
      public static function get instance() : BattlePassManager
      {
         if(!_instance)
         {
            _instance = new BattlePassManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         this.showBattlePassFrame();
      }
      
      public function __battlePassHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         var _loc3_:int = 0;
         var _loc4_:QuestBattlePassInfo = null;
         var _loc5_:int = 1;
         if(this._battlePassView == null)
         {
            this._battlePassView = ComponentFactory.Instance.creatComponentByStylename("battlePass.battlePassView");
         }
         _loc2_ = param1.pkg;
         this._battlePassView._point = _loc2_.readInt();
         this._battlePassView.isPayBattlePass = _loc2_.readBoolean();
         this._battlePassView.battlePassMoney = _loc2_.readInt();
         this._battlePassView.battleRemainTime = _loc2_.readInt();
         _loc5_ = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = _loc2_.readInt();
            _loc4_ = this.battlePassQuestList[_loc7_];
            if(_loc4_ == null)
            {
               _loc4_ = this.battlePassQuestList[_loc3_];
            }
            if(_loc4_ != null)
            {
               _loc4_.Completed = _loc2_.readInt();
            }
            _loc7_++;
         }
         this._battlePassView.SetSeasonNum(_loc5_);
         this._battlePassView.UpdateRemainTime(this._battlePassView.battleRemainTime);
         this._battlePassView._buildSlots(1);
         this._battlePassView._buildQuests(0,0);
         this._battlePassView.show();
         dispatchEvent(new Event(BATTLE_PASS_GET_INFO));
      }
      
      public function hide() : void
      {
         if(this._battlePassView != null)
         {
            this._battlePassView.dispose();
         }
         this._battlePassView = null;
      }
      
      private function showBattlePassFrame() : void
      {
         new HelperDataModuleLoad().loadDataModule([StartupResourceLoader.Instance.createBattlePassLoader,StartupResourceLoader.Instance.createBattlePassItemsLoader],function():void
         {
            new HelperUIModuleLoad().loadUIModule(["battlePass"],onComplete);
         });
      }
      
      private function onComplete() : void
      {
         this._battlePassView = ComponentFactory.Instance.creatComponentByStylename("battlePass.battlePassView");
         SocketManager.Instance.out.getBattlePassInfo(true);
      }
      
      public function setBattlePassQuestList(param1:QuestBattlePassAnalyzer) : void
      {
         this.battlePassQuestList = param1.list;
      }
      
      public function setBattlePassQuestItems(param1:QuestBattlePassItemAnalyzer) : void
      {
         this.battlePassQuestItems = param1.list;
      }
   }
}

