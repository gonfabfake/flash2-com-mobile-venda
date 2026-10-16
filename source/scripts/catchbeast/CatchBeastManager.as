package catchbeast
{
   import catchbeast.date.CatchBeastPackageType;
   import catchbeast.view.CatchBeastView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class CatchBeastManager extends EventDispatcher
   {
      
      private static var _instance:CatchBeastManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      public var RoomType:int = 0;
      
      private var _isBegin:Boolean;
      
      private var _catchBeastView:CatchBeastView;
      
      public function CatchBeastManager()
      {
         super();
      }
      
      public static function get instance() : CatchBeastManager
      {
         if(!_instance)
         {
            _instance = new CatchBeastManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_BEGIN,this.__addCatchBeastBtn);
      }
      
      public function get isBegin() : Boolean
      {
         return this._isBegin;
      }
      
      protected function __addCatchBeastBtn(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         param1 = null;
         switch(_loc3_)
         {
            case CatchBeastPackageType.CATCHBEAST_BEGIN:
               this.openOrclose(_loc2_);
               break;
            case CatchBeastPackageType.CATCHBEAST_VIEWINFO:
               param1 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_VIEWINFO,_loc2_);
               break;
            case CatchBeastPackageType.CATCHBEAST_GETAWARD:
               param1 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_GETAWARD,_loc2_);
               break;
            case CatchBeastPackageType.CATCHBEAST_BUYBUFF:
               param1 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_BUYBUFF,_loc2_);
               break;
            case CatchBeastPackageType.CATCHBEAST_CHALLENGE:
               param1 = new CrazyTankSocketEvent(CrazyTankSocketEvent.CATCHBEAST_CHALLENGE,_loc2_);
         }
         if(Boolean(param1))
         {
            dispatchEvent(param1);
         }
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         this._isBegin = param1.readBoolean();
         if(this._isBegin)
         {
            this.createCatchBeastBtn();
         }
         else
         {
            this.deleteCatchBeastBtn();
         }
      }
      
      public function createCatchBeastBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CATCHBEAST,true);
      }
      
      public function deleteCatchBeastBtn() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.CATCHBEAST,false);
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showCatchBeastFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CATCH_BEAST);
         }
      }
      
      public function hide() : void
      {
         this.RoomType = 0;
         if(this._catchBeastView != null)
         {
            this._catchBeastView.dispose();
         }
         this._catchBeastView = null;
      }
      
      public function onCatchBeastShow(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.show();
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CATCH_BEAST)
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
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CATCH_BEAST)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function showCatchBeastFrame() : void
      {
         this._catchBeastView = ComponentFactory.Instance.creatComponentByStylename("catchBeast.CatchBeastView");
         this._catchBeastView.show();
      }
   }
}

