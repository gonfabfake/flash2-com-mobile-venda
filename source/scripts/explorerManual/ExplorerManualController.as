package explorerManual
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperDataModuleLoad;
   import ddt.utils.HelperUIModuleLoad;
   import explorerManual.data.DebrisInfo;
   import explorerManual.data.ExplorerManualInfo;
   import explorerManual.data.ManualPageDebrisInfo;
   import explorerManual.view.ExplorerManualFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class ExplorerManualController extends EventDispatcher
   {
      
      private static var _instance:ExplorerManualController;
      
      private var _frame:ExplorerManualFrame = null;
      
      private var _manaualModel:ExplorerManualInfo;
      
      private var _autoUpgradeing:Boolean = false;
      
      private var _puzzleState:Boolean = false;
      
      public function ExplorerManualController()
      {
         super();
      }
      
      public static function get instance() : ExplorerManualController
      {
         if(!_instance)
         {
            _instance = new ExplorerManualController();
         }
         return _instance;
      }
      
      public function get puzzleState() : Boolean
      {
         return this._puzzleState;
      }
      
      public function set puzzleState(param1:Boolean) : void
      {
         this._puzzleState = param1;
      }
      
      public function setup() : void
      {
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         ExplorerManualManager.instance.addEventListener("openView",this.__openViewHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXPLORER_MANUAL_INIT,this.__initDataHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXPLORER_MANUAL_PAGE_UPDATE,this.__pageUpdateHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXPLORER_MANUAL_PAGE_ACTIVE,this.__pageActiveHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.EXPLORER_MANUAL_UPGRADE,this.__upgradeHandler);
      }
      
      private function __initDataHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         this._manaualModel.clear();
         this._manaualModel.beginChanges();
         this._manaualModel.manualLev = _loc3_.readInt();
         this._manaualModel.progress = _loc3_.readInt();
         this._manaualModel.maxProgress = _loc3_.readInt();
         this._manaualModel.havePage = _loc3_.readInt();
         this._manaualModel.conditionCount = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Agile = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Armor = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Attack = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Damage = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Defense = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_HP = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Lucky = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_MagicAttack = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_MagicResistance = _loc3_.readInt();
         this._manaualModel.pageAllPro.pro_Stamina = _loc3_.readInt();
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc5_.push(_loc3_.readInt());
            _loc2_++;
         }
         this._manaualModel.activePageID = _loc5_;
         this.updatePlayerManualPro();
         this._manaualModel.upgradeCondition.conditions = ExplorerManualManager.instance.getupgradeConditionByLev(this._manaualModel.manualLev);
         this._manaualModel.refreshData();
         this._manaualModel.commitChanges();
      }
      
      private function updatePlayerManualPro() : void
      {
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         _loc1_.manualProInfo.manual_Level = this._manaualModel.manualLev;
         _loc1_.manualProInfo.pro_Agile = this._manaualModel.pageAllPro.pro_Agile;
         _loc1_.manualProInfo.pro_Armor = this._manaualModel.pageAllPro.pro_Armor;
         _loc1_.manualProInfo.pro_Attack = this._manaualModel.pageAllPro.pro_Attack;
         _loc1_.manualProInfo.pro_Damage = this._manaualModel.pageAllPro.pro_Damage;
         _loc1_.manualProInfo.pro_Defense = this._manaualModel.pageAllPro.pro_Defense;
         _loc1_.manualProInfo.pro_HP = this._manaualModel.pageAllPro.pro_HP;
         _loc1_.manualProInfo.pro_Lucky = this._manaualModel.pageAllPro.pro_Lucky;
         _loc1_.manualProInfo.pro_MagicAttack = this._manaualModel.pageAllPro.pro_MagicAttack;
         _loc1_.manualProInfo.pro_MagicResistance = this._manaualModel.pageAllPro.pro_MagicResistance;
         _loc1_.manualProInfo.pro_Stamina = this._manaualModel.pageAllPro.pro_Stamina;
      }
      
      private function __openViewHandler(param1:Event) : void
      {
         var evt:Event = param1;
         if(ExplorerManualManager.instance.isInitData)
         {
            this.loadUIModule();
         }
         else
         {
            new HelperDataModuleLoad().loadDataModule([StartupResourceLoader.Instance.createManaualDebrisData,StartupResourceLoader.Instance.createChapterItemData,StartupResourceLoader.Instance.createManualUpgradeData,StartupResourceLoader.Instance.createPageItemData],(function():*
            {
               var loadedData:* = undefined;
               return loadedData = function():void
               {
                  ExplorerManualManager.instance.isInitData = true;
                  loadUIModule();
               };
            })());
         }
         this.puzzleState = false;
      }
      
      private function __upgradeHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PackageIn = null;
         var _loc2_:* = null;
         _loc3_ = param1.pkg;
         var _loc4_:Boolean = _loc3_.readBoolean();
         var _loc5_:Boolean = _loc3_.readBoolean();
         var _loc6_:Boolean = _loc3_.readBoolean();
         var _loc7_:int = _loc3_.readInt();
         var _loc8_:int = _loc3_.readInt();
         var _loc9_:int = this._manaualModel.progress;
         var _loc10_:* = _loc8_;
         if(Boolean(this._manaualModel))
         {
            if(this._manaualModel.manualLev != _loc7_)
            {
               if(!_loc4_)
               {
                  _loc2_ = LanguageMgr.GetTranslation("explorerManual.upgrade.succeed");
               }
               else
               {
                  _loc2_ = LanguageMgr.GetTranslation("explorerManual.upgrade.complete");
               }
               this.requestInitData();
               this.dispatchEvent(new Event("upgradeComplete"));
            }
            else
            {
               if(!_loc4_)
               {
                  _loc2_ = LanguageMgr.GetTranslation(_loc6_ ? "explorerManual.upgrade.critPrompt" : "explorerManual.upgrade.prompt",_loc8_ - _loc9_);
               }
               else
               {
                  _loc2_ = LanguageMgr.GetTranslation("explorerManual.upgrade.complete");
               }
               this._manaualModel.beginChanges();
               this._manaualModel.progress = _loc8_;
               this._manaualModel.commitChanges();
            }
         }
         MessageTipManager.getInstance().show(_loc2_);
      }
      
      private function __pageUpdateHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:PackageIn = param1.pkg;
         var _loc7_:int = _loc6_.readInt();
         var _loc8_:ManualPageDebrisInfo = new ManualPageDebrisInfo();
         _loc5_ = 0;
         while(_loc5_ < _loc7_)
         {
            _loc4_ = new DebrisInfo();
            _loc4_.debrisID = _loc6_.readInt();
            _loc4_.date = _loc6_.readDate();
            _loc8_.debris.push(_loc4_);
            _loc5_++;
         }
         this._manaualModel.beginChanges();
         this._manaualModel.debrisInfo = _loc8_;
         this._manaualModel.commitChanges();
      }
      
      private function __pageActiveHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PackageIn = null;
         var _loc5_:int = 0;
         var _loc2_:* = null;
         _loc3_ = param1.pkg;
         var _loc4_:Boolean = _loc3_.readBoolean();
         _loc5_ = _loc3_.readInt();
         if(_loc5_ == 1)
         {
            _loc2_ = _loc4_ ? "explorerManual.active.succeesMsg" : "explorerManual.active.failMsg";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(_loc2_));
            if(_loc4_)
            {
               this.requestInitData();
            }
         }
         else if(_loc5_ == 2)
         {
            _loc2_ = _loc4_ ? "explorerManual.akeyMuzzle.succeesMsg" : "explorerManual.akeyMuzzle.failMsg";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(_loc2_));
            this.dispatchEvent(new CEvent("akeyMuzzleComplete",_loc4_));
         }
      }
      
      private function loadUIModule() : void
      {
         new HelperUIModuleLoad().loadUIModule(["explorerManual"],function():void
         {
            openView();
         });
      }
      
      private function openView() : void
      {
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         this._manaualModel = new ExplorerManualInfo();
         this._frame = ComponentFactory.Instance.creat("explorerManual.explorerManual.Frame",[this._manaualModel,this]);
         if(Boolean(this._frame))
         {
            this._frame.show();
            this.requestInitData();
         }
      }
      
      public function startUpgrade(param1:Boolean, param2:Boolean) : void
      {
         this.upgrade(param1,param2);
      }
      
      public function autoUpgrade(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.upgrade(param1,param2,param3);
      }
      
      private function upgrade(param1:Boolean, param2:Boolean, param3:Boolean = false) : void
      {
         ExplorerManualManager.instance.startUpgrade(param1,param2,param3);
      }
      
      public function requestManualPageData(param1:int) : void
      {
         ExplorerManualManager.instance.requestManualPageData(param1);
      }
      
      public function switchChapterView(param1:int) : void
      {
         if(Boolean(this._frame))
         {
            this._frame.openPageView(param1);
         }
      }
      
      public function sendManualPageActive(param1:int, param2:int) : void
      {
         ExplorerManualManager.instance.sendManualPageActive(param1,param2);
      }
      
      private function requestInitData() : void
      {
         ExplorerManualManager.instance.requestInitData();
      }
      
      public function get autoUpgradeing() : Boolean
      {
         return this._autoUpgradeing;
      }
      
      public function set autoUpgradeing(param1:Boolean) : void
      {
         this._autoUpgradeing = param1;
      }
   }
}

