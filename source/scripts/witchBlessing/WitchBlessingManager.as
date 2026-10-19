package witchBlessing
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import witchBlessing.data.WitchBlessingModel;
   import witchBlessing.data.WitchBlessingPackageType;
   import witchBlessing.view.WitchBlessingMainView;
   
   public class WitchBlessingManager extends EventDispatcher
   {
      
      private static var _instance:WitchBlessingManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _frame:WitchBlessingMainView;
      
      private var _model:WitchBlessingModel;
      
      public function WitchBlessingManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get Instance() : WitchBlessingManager
      {
         if(_instance == null)
         {
            _instance = new WitchBlessingManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new WitchBlessingModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WITCHBLESSING_DATA,this.__witchBlessingHandle);
      }
      
      public function get model() : WitchBlessingModel
      {
         return this._model;
      }
      
      public function get frame() : WitchBlessingMainView
      {
         return this._frame;
      }
      
      public function isOpen() : Boolean
      {
         return this._model.isOpen;
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this._model.itemInfoList = param1;
      }
      
      private function __witchBlessingHandle(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case WitchBlessingPackageType.WITCHBLESSING_OPEN_CLOSE:
               this.isOpenIcon(_loc2_);
               break;
            case WitchBlessingPackageType.WITCHBLESSING_INFO:
               this.enterView(_loc2_);
               break;
            case WitchBlessingPackageType.WITCHBLESSING_BLESS:
         }
      }
      
      private function enterView(param1:PackageIn) : void
      {
         this._model.isDouble = param1.readBoolean();
         this._model.totalExp = param1.readInt();
         this._model.lv1GetAwardsTimes = param1.readInt();
         this._model.lv1CD = param1.readInt();
         this._model.lv2GetAwardsTimes = param1.readInt();
         this._model.lv2CD = param1.readInt();
         this._model.lv3GetAwardsTimes = param1.readInt();
         this._model.lv3CD = param1.readInt();
         if(loadComplete)
         {
            this.showMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WITCH_BLESSING);
         }
      }
      
      public function testEnter() : void
      {
         if(loadComplete)
         {
            this.showMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.WITCH_BLESSING);
         }
      }
      
      public function isOpenIcon(param1:PackageIn) : void
      {
         this._model.isOpen = param1.readBoolean();
         this._model.startDate = param1.readDate();
         this._model.endDate = param1.readDate();
         HallIconManager.instance.updateSwitchHandler(HallIconType.WITCHBLESSING,this._model.isOpen);
      }
      
      public function onClickIcon() : void
      {
         SocketManager.Instance.out.witchBlessing_enter();
      }
      
      private function showMainView() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.show();
         }
         else
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.WitchBlessingMainView");
            this._frame.show();
         }
         this._frame.flushData();
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.WITCH_BLESSING)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __completeShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.WITCH_BLESSING)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showMainView();
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this._frame))
         {
            this._frame = null;
         }
      }
   }
}

