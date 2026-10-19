package moneyTree
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.CheckMoneyUtils;
   import flash.events.Event;
   import moneyTree.model.MoneyTreeModel;
   import road7th.comm.PackageIn;
   
   public class MoneyTreeManager extends CoreManager
   {
      
      private static var instance:MoneyTreeManager;
      
      public static const SHOW_MAIN_FRAME:String = "mt_show_main_frame";
      
      public static const HIDE_MAIN_FRAME:String = "mt_hide_main_frame";
      
      public static const UPDATE_INFO:String = "mt_update_info";
      
      public static const UPDATE_REMAIN_NUM:String = "mt_update_remain";
      
      public static const UPDATE_TIMER:String = "mt_update_timer";
      
      public static const RESET_FRIEND_LIST:String = "mt_reset_friends_list";
      
      public static const PICK_MOVIE:String = "mt_pick_movie";
      
      public static const SPEEDUP_SUC:String = "mt_speedup_suc";
      
      public static const SET_FOCUS:String = "mt_set_focus";
      
      private var _model:MoneyTreeModel;
      
      private var _isListening:Boolean = false;
      
      private var _type:int;
      
      private var _positon:int;
      
      private var _isBind:Boolean = false;
      
      private var _showAgain:Boolean = true;
      
      private var _TempShowAgain:Boolean = true;
      
      public function MoneyTreeManager(param1:inner)
      {
         super();
         this._model = new MoneyTreeModel();
      }
      
      public static function getInstance() : MoneyTreeManager
      {
         if(!instance)
         {
            instance = new MoneyTreeManager(new inner());
         }
         return instance;
      }
      
      public function get model() : MoneyTreeModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.out.sendUpdateSysDate();
         this.addEvents();
      }
      
      private function addEvents() : void
      {
         if(this._isListening)
         {
            return;
         }
         this._isListening = true;
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONEYTREE_INFO,this.onPkgUpdateInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONEYTREE_SPEED_UP,this.onPkgSpeedUp);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MONEYTREE_SEND_RED_PACKAGE,this.onPkgSendRedPkg);
         this._model.addEventListener("mt_timer",this.onTimer);
      }
      
      protected function onTimer(param1:Event) : void
      {
         dispatchEvent(new CEvent("mt_update_timer"));
      }
      
      public function onPkgUpdateInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         this._model.setNumRedPkgRemain(_loc3_.readInt());
         this._model.resetWillSendNum();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            this._model.setInfoAt(_loc2_,_loc3_.readDate(),_loc3_.readInt());
            _loc2_++;
         }
         dispatchEvent(new CEvent("mt_update_info"));
         dispatchEvent(new CEvent("mt_reset_friends_list"));
      }
      
      public function onPkgSendRedPkg(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.setNumRedPkgRemain(_loc2_.readInt());
         this._model.resetWillSendNum();
         dispatchEvent(new CEvent("mt_update_remain"));
         dispatchEvent(new CEvent("mt_reset_friends_list"));
      }
      
      public function onPkgSpeedUp(param1:CrazyTankSocketEvent) : void
      {
         dispatchEvent(new CEvent("mt_speedup_suc"));
      }
      
      public function getCurSpeedUpToMature() : String
      {
         return LanguageMgr.GetTranslation("moneytree.cost.perspeedup",this._model.getPriceSpeedUp(this._positon) * this._model.getTimesToGrown(this._positon));
      }
      
      public function getCurSpeedUpOnce() : String
      {
         return LanguageMgr.GetTranslation("moneytree.cost.perspeedup",this._model.getPriceSpeedUp(this._positon).toString());
      }
      
      public function showMainFrame() : void
      {
         show();
      }
      
      override protected function start() : void
      {
         this.addEvents();
         dispatchEvent(new CEvent("mt_show_main_frame"));
      }
      
      public function hideMainFrame() : void
      {
         dispatchEvent(new CEvent("mt_hide_main_frame"));
      }
      
      public function npcClicked() : void
      {
         this.showMainFrame();
      }
      
      public function inviteBtnClicked(param1:int, param2:String) : void
      {
         switch(param2)
         {
            case "invite":
               this._model.addFriendsToSend(param1);
               break;
            case "unInvite":
               this._model.reduceFriendsToSend(param1);
         }
         dispatchEvent(new CEvent("mt_set_focus"));
      }
      
      public function sendRedPkgBtnClicked() : void
      {
         var _loc1_:* = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Array = this._model.getFriendsToSendList();
         if(_loc2_.length == 0)
         {
            _loc1_ = LanguageMgr.GetTranslation("moneytree.noneFriendSelected");
            MessageTipManager.getInstance().show(_loc1_,0,false,1);
         }
         else
         {
            this.requireSendRedPkg(this._model.getFriendsToSendList());
         }
         this._model.resetWillSendNum();
         dispatchEvent(new CEvent("mt_reset_friends_list"));
         dispatchEvent(new CEvent("mt_set_focus"));
      }
      
      public function pick(param1:int) : void
      {
         this.requirePick(param1);
      }
      
      public function becomeMature() : void
      {
         dispatchEvent(new CEvent("mt_update_info"));
      }
      
      public function onSpeedUpTypeSelected() : int
      {
         return this._model.getCurSlctTimesSpeedUpToMature(this._positon);
      }
      
      public function onSpeedUpClick(param1:int) : void
      {
         var _loc2_:* = NaN;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._positon = param1;
         if(!this._showAgain)
         {
            _loc2_ = 0;
            this._TempShowAgain = this._showAgain;
            this._showAgain = true;
            if(this._type == 0)
            {
               _loc2_ = Number(this._model.getPriceSpeedUp(this._positon));
            }
            else
            {
               _loc2_ = Number(this._model.getPriceSpeedUp(this._positon) * this._model.getTimesToGrown(this._positon));
            }
            CheckMoneyUtils.instance.checkMoney(this._isBind,_loc2_,this.onCheckComplete);
            return;
         }
         var _loc3_:String = this.getCurSpeedUpOnce();
         var _loc4_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),_loc3_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,1,null,"moneyTree.confirmView",60,false,0);
         _loc4_.addEventListener("response",this.confirmResponse);
      }
      
      public function get positon() : int
      {
         return this._positon;
      }
      
      private function confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener("response",this.confirmResponse);
         this._type = _loc3_["type"];
         this._TempShowAgain = !_loc3_["isNoPrompt"];
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            _loc2_ = 0;
            if(this._type == 0)
            {
               _loc2_ = Number(this._model.getPriceSpeedUp(this._positon));
            }
            else
            {
               _loc2_ = Number(this._model.getPriceSpeedUp(this._positon) * this._model.getTimesToGrown(this._positon));
            }
            CheckMoneyUtils.instance.checkMoney(this._isBind,_loc2_,this.onCheckComplete);
         }
         _loc3_.dispose();
         dispatchEvent(new CEvent("mt_set_focus"));
      }
      
      protected function onCheckComplete() : void
      {
         this._showAgain = this._TempShowAgain;
         this.requireSpeedUp(this._positon,this._type,CheckMoneyUtils.instance.isBind);
         dispatchEvent(new CEvent("mt_set_focus"));
      }
      
      public function dispose() : void
      {
         this._isListening = false;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MONEYTREE_INFO,this.onPkgUpdateInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MONEYTREE_SPEED_UP,this.onPkgSpeedUp);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MONEYTREE_SEND_RED_PACKAGE,this.onPkgSendRedPkg);
      }
      
      private function requireSpeedUp(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(param2 == 0)
         {
            _loc4_ = 1;
         }
         else
         {
            _loc4_ = this._model.getTimesToGrown(this._positon);
         }
         GameInSocketOut.sendMoneyTreeSpeedUp(param1,_loc4_,param3);
      }
      
      public function requirePick(param1:int) : void
      {
         if(this.model == null)
         {
            return;
         }
         if(this.model.getInfoAt(param1).isGrown)
         {
            dispatchEvent(new CEvent("mt_pick_movie",param1));
            GameInSocketOut.sendMoneyTreePick(param1);
         }
      }
      
      public function requireUpdateInfo() : void
      {
         GameInSocketOut.sendMoneyTreeRequireInfo();
      }
      
      private function requireSendRedPkg(param1:Array) : void
      {
         if(param1.length != 0)
         {
            GameInSocketOut.sendMoneyTreeSendRedPackage(param1);
         }
      }
      
      public function get isShowNPC() : Boolean
      {
         return true;
      }
   }
}

