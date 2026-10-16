package growthPackage
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import growthPackage.event.GrowthPackageEvent;
   import growthPackage.model.GrowthPackageModel;
   import growthPackage.view.GrowthPackageFrame;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GrowthPackageManager extends EventDispatcher
   {
      
      private static var _instance:GrowthPackageManager;
      
      public static var indexMax:int = 9;
      
      private var _model:GrowthPackageModel;
      
      private var growthPackageIsOpen:Boolean;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      public function GrowthPackageManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : GrowthPackageManager
      {
         if(!_instance)
         {
            _instance = new GrowthPackageManager();
         }
         return _instance;
      }
      
      public function get model() : GrowthPackageModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new GrowthPackageModel();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GROWTHPACKAGE,this.__growthPackageHandler);
         this.model.addEventListener(GrowthPackageEvent.ICON_CLOSE,this.__iconCloseHandler);
      }
      
      private function __growthPackageHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         switch(_loc3_)
         {
            case GrowthPackageType.GROWTHPACKAGE_OPEN:
               this.updateData(_loc2_);
               break;
            case GrowthPackageType.GROWTHPACKAGE_UPDATEDATA:
               this.updateData(_loc2_);
               break;
            case GrowthPackageType.GROWTHPACKAGE_ISOPEN:
               this.isOpenHandler(_loc2_);
         }
      }
      
      private function updateData(param1:PackageIn) : void
      {
         this.model.isBuy = param1.readInt();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < indexMax)
         {
            _loc2_.push(param1.readInt());
            _loc3_++;
         }
         this.model.isCompleteList = _loc2_;
         this.model.dataChange(GrowthPackageEvent.DATA_CHANGE);
      }
      
      private function isOpenHandler(param1:PackageIn) : void
      {
         this.growthPackageIsOpen = param1.readBoolean();
         this.showEnterIcon();
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this.model.itemInfoList = param1;
      }
      
      private function __iconCloseHandler(param1:GrowthPackageEvent) : void
      {
         this.disposeEnterIcon();
      }
      
      public function showEnterIcon() : void
      {
         if(this.model.isShowIcon && this.growthPackageIsOpen)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.GROWTHPACKAGE,true);
         }
         else
         {
            this.disposeEnterIcon();
         }
      }
      
      public function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GROWTHPACKAGE,false);
      }
      
      public function onClickIcon(param1:MouseEvent) : void
      {
         var _loc2_:BaseLoader = null;
         if(Boolean(this.model.itemInfoList))
         {
            this.loadUIModule(this.showFrame);
         }
         else
         {
            _loc2_ = StartupResourceLoader.Instance.createActivitySystemItemsLoader();
            _loc2_.addEventListener(Event.COMPLETE,this.__dataLoaderCompleteHandler);
            LoadResourceManager.Instance.startLoad(_loc2_);
         }
      }
      
      private function __dataLoaderCompleteHandler(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.loader;
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__dataLoaderCompleteHandler);
         this.loadUIModule(this.showFrame);
      }
      
      public function showBuyFrame() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc1_:Number = ServerConfigManager.instance.growthPackagePrice;
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.growthPackage.buyPriceMsg",_loc1_),"",LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onBuyFrameResponse);
      }
      
      private function __onBuyFrameResponse(param1:FrameEvent) : void
      {
         var _loc2_:Number = NaN;
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc2_ = ServerConfigManager.instance.growthPackagePrice;
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               SocketManager.Instance.out.sendGrowthPackageOpen();
            }
         }
         var _loc3_:BaseAlerFrame = BaseAlerFrame(param1.currentTarget);
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__onBuyFrameResponse);
         ObjectUtils.disposeAllChildren(_loc3_);
         ObjectUtils.disposeObject(_loc3_);
         _loc3_ = null;
      }
      
      public function showFrame() : void
      {
         var _loc1_:GrowthPackageFrame = ComponentFactory.Instance.creatComponentByStylename("GrowthPackageFrame");
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function loadUIModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GROWTH_PACKAGE);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GROWTH_PACKAGE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GROWTH_PACKAGE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

