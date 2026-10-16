package godOfWealth
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class GodOfWealthManager extends EventDispatcher
   {
      
      private static var instance:GodOfWealthManager;
      
      public static const OPEN_VIEW:String = "gow_open_view";
      
      public static const UPDATE:String = "gow_update";
      
      public static const RESULT_SUC:String = "gow_result_suc";
      
      private var _nextPayNeeded:int;
      
      private var _nextRewardMin:int;
      
      private var _nextRewardMax:int;
      
      private var _reward:int;
      
      private var _dateEndTime:Number = 0;
      
      private var _btnEnter:MovieClip;
      
      private var _isOpen:Boolean = false;
      
      public function GodOfWealthManager(param1:GodOfWealthInstance, param2:IEventDispatcher = null)
      {
         super(param2);
      }
      
      public static function getInstance() : GodOfWealthManager
      {
         if(!instance)
         {
            instance = new GodOfWealthManager(new GodOfWealthInstance());
         }
         return instance;
      }
      
      public function get nextPayNeeded() : int
      {
         return this._nextPayNeeded;
      }
      
      public function get nextRewardMin() : int
      {
         return this._nextRewardMin;
      }
      
      public function get nextRewardMax() : int
      {
         return this._nextRewardMax;
      }
      
      public function get reward() : int
      {
         return this._reward;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOD_OF_WEALTH,this._socketManagerHandler);
      }
      
      private function _socketManagerHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case 1:
               this.onIsOpen(_loc2_);
               break;
            case 2:
               this.onPay(_loc2_);
               break;
            case 3:
               this.onInfo(_loc2_);
         }
      }
      
      protected function onInfo(param1:PackageIn) : void
      {
         this._nextPayNeeded = param1.readInt();
         this._nextRewardMin = param1.readInt();
         this._nextRewardMax = param1.readInt();
         this._dateEndTime = param1.readDate().time;
         dispatchEvent(new CEvent("gow_update"));
      }
      
      protected function onPay(param1:PackageIn) : void
      {
         this._reward = param1.readInt();
         this._nextPayNeeded = param1.readInt();
         this._nextRewardMin = param1.readInt();
         this._nextRewardMax = param1.readInt();
         if(this._reward > 0)
         {
            dispatchEvent(new CEvent("gow_result_suc"));
         }
         dispatchEvent(new CEvent("gow_update"));
      }
      
      protected function onIsOpen(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         if(_loc2_)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("godOfWealth.activity.isOpen"));
         }
         else if(!_loc2_)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("godOfWealth.activity.isClose"));
         }
         this._isOpen = _loc2_;
         HallIconManager.instance.updateSwitchHandler("godOfWealth",this._isOpen);
      }
      
      private function onEnterBtnClick(param1:MouseEvent) : void
      {
         this.show();
      }
      
      public function show() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.dispatchShow);
         UIModuleLoader.Instance.addUIModuleImp("godOfWealth");
      }
      
      private function dispatchShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "godOfWealth")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.dispatchShow);
            dispatchEvent(new CEvent("gow_open_view"));
         }
      }
      
      public function endTime() : Number
      {
         return this._dateEndTime;
      }
   }
}

class GodOfWealthInstance
{
   
   public function GodOfWealthInstance()
   {
      super();
   }
}
