package BombTurnTable
{
   import BombTurnTable.event.TurnTableEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.IEventDispatcher;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class BombTurnTableManager extends CoreManager
   {
      
      public static const TURNTABLE_OPENVIEW:String = "TurnTableOpenView";
      
      public static const TURNTABLE_END:String = "TurnTableEnd";
      
      private static var _instance:BombTurnTableManager = null;
      
      private var _showFlag:Boolean = false;
      
      private var _iconBtn:BaseButton = null;
      
      private var _hall:HallStateView = null;
      
      private var _endDate:Date;
      
      private var _clickNum:Number = 0;
      
      public function BombTurnTableManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : BombTurnTableManager
      {
         if(_instance == null)
         {
            _instance = new BombTurnTableManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOMBTURNTABLE_ISOPEN,this._isOpen);
      }
      
      protected function _isOpen(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._showFlag = _loc2_.readBoolean();
         this._endDate = _loc2_.readDate();
         this.checkIcon();
      }
      
      private function checkIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("bombTurnTable",this._showFlag);
         if(this._showFlag == false)
         {
            this.dispatchEvent(new TurnTableEvent("TurnTableEnd",null));
         }
      }
      
      public function openView_Handler() : void
      {
         SoundManager.instance.playButtonSound();
         var _loc1_:Number = new Date().time;
         if(_loc1_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc1_;
         this.showNew();
      }
      
      public function get isValid() : Boolean
      {
         var _loc1_:Number = this._endDate.getTime() - 2000;
         var _loc2_:Number = TimeManager.Instance.Now().getTime();
         if(_loc1_ < _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public function sendStartLottery() : void
      {
         SocketManager.Instance.out.sendBombTurnTableLottery();
      }
      
      public function requestViewData() : void
      {
         SocketManager.Instance.out.requestBombTurnTableData();
      }
      
      private function showNew() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
         UIModuleLoader.Instance.addUIModuleImp("bombTurnTable");
      }
      
      private function showFrame(param1:UIModuleEvent) : void
      {
         if(param1.module == "bombTurnTable")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
            dispatchEvent(new CEvent("TurnTableOpenView"));
         }
      }
   }
}

