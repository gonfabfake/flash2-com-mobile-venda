package league
{
   import ddt.CoreManager;
   import ddt.bagStore.BagStore;
   import ddt.events.PkgEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   
   public class LeagueManager extends CoreManager
   {
      
      private static var _instance:LeagueManager;
      
      public static const LEAGUE_OPENVIEW:String = "leagueOpenView";
      
      public var maxCount:int = 30;
      
      public var restCount:int = 10;
      
      public var isOpen:Boolean = false;
      
      public var deleLeaIcon:Function;
      
      public function LeagueManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : LeagueManager
      {
         if(_instance == null)
         {
            _instance = new LeagueManager();
         }
         return _instance;
      }
      
      override protected function start() : void
      {
         dispatchEvent(new Event("leagueOpenView"));
      }
      
      public function showNew() : void
      {
         dispatchEvent(new Event("leagueOpenView"));
      }
      
      public function initLeagueStartNoticeEvent() : void
      {
         SocketManager.Instance.addEventListener("popup_leagueStart_notice",this.onLeagueNotice);
      }
      
      private function onLeagueNotice(param1:PkgEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         if(_loc3_ == 1)
         {
            this.restCount = _loc2_.readInt();
            this.maxCount = _loc2_.readInt();
            this.isOpen = true;
            if(StateManager.currentStateType == "main" || StateManager.currentStateType == "roomlist" || StateManager.currentStateType == "dungeon" || StateManager.currentStateType == "dungeonRoom" || StateManager.currentStateType == "matchRoom" || StateManager.currentStateType == "challengeRoom" || StateManager.currentStateType == "login")
            {
               if(BagStore.instance.storeOpenAble)
               {
                  return;
               }
            }
         }
         else if(_loc3_ == 2)
         {
            this.restCount = -1;
            this.maxCount = -1;
            this.isOpen = false;
            if(this.deleLeaIcon != null)
            {
               this.deleLeaIcon();
            }
         }
         else if(_loc3_ == 3)
         {
            this.restCount = _loc2_.readInt();
         }
      }
   }
}

