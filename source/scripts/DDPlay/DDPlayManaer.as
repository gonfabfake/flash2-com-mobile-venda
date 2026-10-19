package DDPlay
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
   
   public class DDPlayManaer extends EventDispatcher
   {
      
      private static var _instance:DDPlayManaer;
      
      public static const UPDATE_SCORE:String = "update_score";
      
      private static var loadComplete:Boolean = false;
      
      private static var useFirst:Boolean = true;
      
      public var isOpen:Boolean;
      
      public var DDPlayScore:int;
      
      public var DDPlayMoney:int;
      
      public var exchangeFold:int;
      
      public var beginDate:Date;
      
      public var endDate:Date;
      
      private var _ddPlayView:DDPlayView;
      
      public function DDPlayManaer(param1:DDPlayInstance, param2:IEventDispatcher = null)
      {
         super(param2);
      }
      
      public static function get Instance() : DDPlayManaer
      {
         var _loc1_:DDPlayInstance = null;
         if(_instance == null)
         {
            _loc1_ = new DDPlayInstance();
            _instance = new DDPlayManaer(_loc1_);
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DDPLAY_BEGIN,this.__addDDPlayBtn);
      }
      
      protected function __addDDPlayBtn(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         param1 = null;
         switch(_loc3_)
         {
            case DDPlayType.DDPLAY_BEGIN:
               this.openOrClose(_loc2_);
               break;
            case DDPlayType.ENTER_DDPLAY:
               param1 = new CrazyTankSocketEvent(CrazyTankSocketEvent.DDPLAY_ENTER,_loc2_);
               break;
            case DDPlayType.DDPLAY_START:
               param1 = new CrazyTankSocketEvent(CrazyTankSocketEvent.DDPLAY_START,_loc2_);
         }
         if(Boolean(param1))
         {
            dispatchEvent(param1);
         }
      }
      
      private function openOrClose(param1:PackageIn) : void
      {
         this.isOpen = param1.readBoolean();
         this.beginDate = param1.readDate();
         this.endDate = param1.readDate();
         this.DDPlayMoney = param1.readInt();
         this.exchangeFold = param1.readInt();
         if(this.isOpen)
         {
            this.createDDPlayBtn();
         }
         else
         {
            this.deleteDDPlayBtn();
         }
      }
      
      public function createDDPlayBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.DDPLAY,true);
      }
      
      public function deleteDDPlayBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.DDPLAY,false);
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showDDPlayView();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDPLAY);
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDPLAY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDPLAY)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function showDDPlayView() : void
      {
         this._ddPlayView = ComponentFactory.Instance.creatComponentByStylename("ddPlay.view.ddPlayView");
         this._ddPlayView.show();
      }
   }
}

class DDPlayInstance
{
   
   public function DDPlayInstance()
   {
      super();
   }
}
