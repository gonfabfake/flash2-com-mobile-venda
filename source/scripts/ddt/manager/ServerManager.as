package ddt.manager
{
   import baglocked.BagLockedController;
   import calendar.CalendarManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.DDT;
   import ddt.data.ServerInfo;
   import ddt.data.analyze.ServerListAnalyzer;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   
   [Event(name="change",type="flash.events.Event")]
   public class ServerManager extends EventDispatcher
   {
      
      private static var _instance:ServerManager;
      
      public static const CHANGE_SERVER:String = "changeServer";
      
      public static var AUTO_UNLOCK:Boolean = false;
      
      private static const CONNENT_TIME_OUT:int = 30000;
      
      private var _list:Vector.<ServerInfo>;
      
      private var _current:ServerInfo;
      
      private var _zoneName:String;
      
      private var _agentid:int;
      
      private var _connentTimer:Timer;
      
      public function ServerManager()
      {
         super();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOGIN,this.__onLoginComplete);
      }
      
      public static function get Instance() : ServerManager
      {
         if(_instance == null)
         {
            _instance = new ServerManager();
         }
         return _instance;
      }
      
      public function get zoneName() : String
      {
         return this._zoneName;
      }
      
      public function set zoneName(param1:String) : void
      {
         this._zoneName = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get AgentID() : int
      {
         return this._agentid;
      }
      
      public function set AgentID(param1:int) : void
      {
         this._agentid = param1;
      }
      
      public function set current(param1:ServerInfo) : void
      {
         this._current = param1;
      }
      
      public function get current() : ServerInfo
      {
         return this._current;
      }
      
      public function get list() : Vector.<ServerInfo>
      {
         return this._list;
      }
      
      public function set list(param1:Vector.<ServerInfo>) : void
      {
         this._list = param1;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function setup(param1:ServerListAnalyzer) : void
      {
         this._list = param1.list;
         this._agentid = param1.agentId;
         this._zoneName = param1.zoneName;
      }
      
      public function canAutoLogin() : Boolean
      {
         this.searchAvailableServer();
         return this._current != null;
      }
      
      public function connentCurrentServer() : void
      {
         SocketManager.Instance.isLogin = false;
         SocketManager.Instance.connect(this._current.IP,this._current.Port);
      }
      
      private function searchAvailableServer() : void
      {
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         if(DDT.SERVER_ID != -1)
         {
            this._current = this._list[DDT.SERVER_ID];
            return;
         }
         this._current = this.searchServerByState(ServerInfo.UNIMPEDED);
         if(this._current == null)
         {
            this._current = this.searchServerByState(ServerInfo.HALF);
         }
         if(this._current == null)
         {
            this._current = this._list[0];
         }
      }
      
      private function searchServerByState(param1:int) : ServerInfo
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._list.length)
         {
            if(this._list[_loc2_].State == param1)
            {
               return this._list[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function connentServer(param1:ServerInfo) : Boolean
      {
         var _loc2_:BaseAlerFrame = null;
         if(param1 == null)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.choose"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.MustLevel < PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.your"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.LowestLevel > PlayerManager.Instance.Self.Grade)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.low"));
            this.alertControl(_loc2_);
            return false;
         }
         if(SocketManager.Instance.socket.connected && SocketManager.Instance.socket.isSame(param1.IP,param1.Port) && SocketManager.Instance.isLogin)
         {
            StateManager.setState(StateType.MAIN);
            return false;
         }
         if(param1.State == ServerInfo.ALL_FULL)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.full"));
            this.alertControl(_loc2_);
            return false;
         }
         if(param1.State == ServerInfo.MAINTAIN)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.serverlist.ServerListPosView.maintenance"));
            this.alertControl(_loc2_);
            return false;
         }
         this._current = param1;
         this.connentCurrentServer();
         dispatchEvent(new Event(CHANGE_SERVER));
         return true;
      }
      
      private function alertControl(param1:BaseAlerFrame) : void
      {
         param1.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         _loc2_.dispose();
      }
      
      private function __onLoginComplete(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:PackageIn = param1.pkg;
         var _loc7_:SelfInfo = PlayerManager.Instance.Self;
         if(_loc6_.readByte() == 0)
         {
            _loc7_.beginChanges();
            SocketManager.Instance.isLogin = true;
            _loc7_.ZoneID = _loc6_.readInt();
            _loc7_.Attack = _loc6_.readInt();
            _loc7_.Defence = _loc6_.readInt();
            _loc7_.Agility = _loc6_.readInt();
            _loc7_.Luck = _loc6_.readInt();
            _loc7_.GP = _loc6_.readInt();
            _loc7_.Repute = _loc6_.readInt();
            _loc7_.Gold = _loc6_.readInt();
            _loc7_.Money = _loc6_.readInt();
            _loc7_.medal = _loc6_.readInt();
            _loc7_.Score = _loc6_.readInt();
            _loc7_.Hide = _loc6_.readInt();
            _loc7_.FightPower = _loc6_.readInt();
            _loc7_.apprenticeshipState = _loc6_.readInt();
            _loc7_.masterID = _loc6_.readInt();
            _loc7_.setMasterOrApprentices(_loc6_.readUTF());
            _loc7_.graduatesCount = _loc6_.readInt();
            _loc7_.honourOfMaster = _loc6_.readUTF();
            _loc7_.freezesDate = _loc6_.readDate();
            _loc7_.typeVIP = _loc6_.readByte();
            _loc7_.VIPLevel = _loc6_.readInt();
            _loc7_.VIPExp = _loc6_.readInt();
            _loc7_.VIPExpireDay = _loc6_.readDate();
            _loc7_.LastDate = _loc6_.readDate();
            _loc7_.VIPNextLevelDaysNeeded = _loc6_.readInt();
            _loc7_.systemDate = _loc6_.readDate();
            _loc7_.canTakeVipReward = _loc6_.readBoolean();
            _loc7_.OptionOnOff = _loc6_.readInt();
            _loc7_.AchievementPoint = _loc6_.readInt();
            _loc7_.honor = _loc6_.readUTF();
            TimeManager.Instance.totalGameTime = _loc6_.readInt();
            _loc7_.Sex = _loc6_.readBoolean();
            _loc2_ = _loc6_.readUTF();
            _loc3_ = _loc2_.split("&");
            _loc7_.Style = _loc3_[0];
            _loc7_.Colors = _loc3_[1];
            _loc7_.Skin = _loc6_.readUTF();
            _loc7_.ConsortiaID = _loc6_.readInt();
            _loc7_.ConsortiaName = _loc6_.readUTF();
            _loc7_.badgeID = _loc6_.readInt();
            _loc7_.DutyLevel = _loc6_.readInt();
            _loc7_.DutyName = _loc6_.readUTF();
            _loc7_.Right = _loc6_.readInt();
            _loc7_.consortiaInfo.ChairmanName = _loc6_.readUTF();
            _loc7_.consortiaInfo.Honor = _loc6_.readInt();
            _loc7_.consortiaInfo.Riches = _loc6_.readInt();
            _loc4_ = _loc6_.readBoolean();
            _loc5_ = _loc7_.bagPwdState && !_loc7_.bagLocked;
            _loc7_.bagPwdState = _loc4_;
            if(_loc5_)
            {
               setTimeout(this.releaseLock,1000);
            }
            _loc7_.bagLocked = _loc4_;
            _loc7_.questionOne = _loc6_.readUTF();
            _loc7_.questionTwo = _loc6_.readUTF();
            _loc7_.leftTimes = _loc6_.readInt();
            _loc7_.LoginName = _loc6_.readUTF();
            _loc7_.Nimbus = _loc6_.readInt();
            TaskManager.requestCanAcceptTask();
            _loc7_.PvePermission = _loc6_.readUTF();
            _loc7_.fightLibMission = _loc6_.readUTF();
            _loc7_.userGuildProgress = _loc6_.readInt();
            BossBoxManager.instance.receiebox = _loc6_.readInt();
            BossBoxManager.instance.receieGrade = _loc6_.readInt();
            BossBoxManager.instance.needGetBoxTime = _loc6_.readInt();
            BossBoxManager.instance.currentGrade = PlayerManager.Instance.Self.Grade;
            BossBoxManager.instance.startGradeChangeEvent();
            BossBoxManager.instance.startDelayTime();
            _loc7_.LastSpaDate = _loc6_.readDate();
            _loc7_.shopFinallyGottenTime = _loc6_.readDate();
            _loc7_.UseOffer = _loc6_.readInt();
            _loc7_.matchInfo.dailyScore = _loc6_.readInt();
            _loc7_.matchInfo.dailyWinCount = _loc6_.readInt();
            _loc7_.matchInfo.dailyGameCount = _loc6_.readInt();
            _loc7_.DailyLeagueFirst = _loc6_.readBoolean();
            _loc7_.DailyLeagueLastScore = _loc6_.readInt();
            _loc7_.matchInfo.weeklyScore = _loc6_.readInt();
            _loc7_.matchInfo.weeklyGameCount = _loc6_.readInt();
            _loc7_.matchInfo.weeklyRanking = _loc6_.readInt();
            _loc7_.spdTexpExp = _loc6_.readInt();
            _loc7_.attTexpExp = _loc6_.readInt();
            _loc7_.defTexpExp = _loc6_.readInt();
            _loc7_.hpTexpExp = _loc6_.readInt();
            _loc7_.lukTexpExp = _loc6_.readInt();
            _loc7_.texpTaskCount = _loc6_.readInt();
            _loc7_.texpCount = _loc6_.readInt();
            _loc7_.texpTaskDate = _loc6_.readDate();
            _loc7_.isOldPlayerHasValidEquitAtLogin = _loc6_.readBoolean();
            _loc7_.badLuckNumber = _loc6_.readInt();
            _loc7_.luckyNum = _loc6_.readInt();
            _loc7_.lastLuckyNumDate = _loc6_.readDate();
            _loc7_.lastLuckNum = _loc6_.readInt();
            _loc7_.isOld = false;
            _loc7_.isOld2 = false;
            _loc7_.necklaceExp = _loc6_.readInt();
            _loc7_.totemId = _loc6_.readInt();
            _loc7_.accumulativeLoginDays = _loc6_.readInt();
            _loc7_.accumulativeAwardDays = _loc6_.readInt();
            _loc7_.honorId = _loc6_.readInt();
            _loc7_.createPlayerDate = _loc6_.readDate();
            _loc7_.canTakeVipReward = _loc6_.readBoolean();
            _loc7_.vipDiscount = _loc6_.readInt();
            _loc7_.vipDiscountValidity = _loc6_.readDate();
            _loc7_.ddtkingDiscount = _loc6_.readInt();
            _loc7_.ddtkingDiscountValidity = _loc6_.readDate();
            _loc7_.manualProInfo.manual_Level = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Agile = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Armor = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Attack = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Damage = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Defense = _loc6_.readInt();
            _loc7_.manualProInfo.pro_HP = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Lucky = _loc6_.readInt();
            _loc7_.manualProInfo.pro_MagicAttack = _loc6_.readInt();
            _loc7_.manualProInfo.pro_MagicResistance = _loc6_.readInt();
            _loc7_.manualProInfo.pro_Stamina = _loc6_.readInt();
            _loc7_.commitChanges();
            MapManager.buildMap();
            PlayerManager.Instance.Self.loadRelatedPlayersInfo();
            MainToolBar.Instance.signEffectEnable = true;
            StateManager.setState(StateType.MAIN);
            ExternalInterfaceManager.sendTo360Agent(4);
            StartupResourceLoader.Instance.startLoadRelatedInfo();
            SocketManager.Instance.out.sendPlayerGift(_loc7_.ID);
            CalendarManager.getInstance().requestLuckyNum();
            if(DesktopManager.Instance.isDesktop)
            {
               setTimeout(TaskManager.onDesktopApp,500);
            }
         }
         else
         {
            this.alertControl(AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),LanguageMgr.GetTranslation("ServerLinkError")));
         }
      }
      
      private function releaseLock() : void
      {
         AUTO_UNLOCK = true;
         SocketManager.Instance.out.sendBagLocked(BagLockedController.PWD,2);
      }
   }
}

