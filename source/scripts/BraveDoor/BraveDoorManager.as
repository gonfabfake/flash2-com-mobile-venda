package BraveDoor
{
   import BraveDoor.data.BraveDoorDuplicateInfo;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.data.UIModuleTypes;
   import ddt.data.analyze.BraveDoorDuplicateAnalyzer;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hall.HallStateView;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class BraveDoorManager extends EventDispatcher
   {
      
      private static var _instance:BraveDoorManager = null;
      
      private var _showFlag:Boolean = false;
      
      private var _endDate:Date;
      
      private var _hall:HallStateView = null;
      
      private var _iconBtn:BaseButton = null;
      
      private var _currentPage:int = 0;
      
      private var _isShow:Boolean = false;
      
      private var _duplicates:Vector.<BraveDoorDuplicateInfo>;
      
      private var _clickNum:Number = 0;
      
      public function BraveDoorManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : BraveDoorManager
      {
         if(_instance == null)
         {
            _instance = new BraveDoorManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BRAVE_DOOR,this._isOpen);
      }
      
      public function initHall(param1:HallStateView) : void
      {
         this._hall = param1;
         this.checkIcon();
      }
      
      protected function _isOpen(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._showFlag = _loc2_.readBoolean();
         if(this._showFlag && PlayerManager.Instance.Self.Grade >= 20)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("game.braveDoor.openMsg"));
         }
         this.checkIcon();
      }
      
      public function get isOpen() : Boolean
      {
         return this._showFlag;
      }
      
      public function checkIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("bravedoor",this._showFlag);
      }
      
      public function openView_Handler() : void
      {
         SoundManager.instance.playButtonSound();
         if(!this.isOpen)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.hall.scancode.avtivityNotOpen"));
            return;
         }
         var _loc1_:Number = new Date().time;
         if(_loc1_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc1_;
         this.show();
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.BRAVE_DOOR);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BRAVE_DOOR)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.BRAVE_DOOR)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(this._duplicates != null)
            {
               this.openView();
               return;
            }
         }
      }
      
      public function setupDuplicateTemplate(param1:BraveDoorDuplicateAnalyzer) : void
      {
         this._duplicates = param1.list;
      }
      
      public function openView() : void
      {
         if(!this._isShow)
         {
            this._isShow = true;
            dispatchEvent(new CEvent("openBraveDoorView"));
         }
      }
      
      public function getDuplicateTemInfo() : Vector.<BraveDoorDuplicateInfo>
      {
         return this._duplicates;
      }
      
      protected function get duplicateTemplatePath() : String
      {
         return PathManager.getBraveDoorDuplicateTemplete("braveDoor");
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      public function set currentPage(param1:int) : void
      {
         this._currentPage = param1;
      }
      
      public function get moduleIsShow() : Boolean
      {
         return this._isShow;
      }
      
      public function set moduleIsShow(param1:Boolean) : void
      {
         this._isShow = param1;
      }
   }
}

