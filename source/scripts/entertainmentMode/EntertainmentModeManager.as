package entertainmentMode
{
   import ddt.CoreManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperUIModuleLoad;
   import entertainmentMode.model.EntertainmentModel;
   import flash.events.Event;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class EntertainmentModeManager extends CoreManager
   {
      
      private static var _instance:EntertainmentModeManager;
      
      public static const SHOWMAINVIEW:String = "showMainView";
      
      public static const HIDEMAINVIEW:String = "hideMainView";
      
      public var isopen:Boolean = false;
      
      public var openTime:String;
      
      public function EntertainmentModeManager()
      {
         super();
      }
      
      public static function get instance() : EntertainmentModeManager
      {
         if(!_instance)
         {
            _instance = new EntertainmentModeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener("entertainment",this.__handler);
      }
      
      private function __handler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:PackageIn = param1.pkg;
         switch(int(param1._cmd) - 71)
         {
            case 0:
               this.isopen = _loc5_.readBoolean();
               _loc2_ = _loc5_.readDate();
               _loc3_ = _loc5_.readDate();
               this.openTime = (_loc4_ = String(_loc2_.fullYear) + "-" + String(_loc2_.month + 1) + "-" + String(_loc2_.date)) + " " + _loc2_.hours + ":" + (_loc2_.minutes < 10 ? "0" + String(_loc2_.minutes) : _loc2_.minutes) + "-" + _loc3_.hours + ":" + (_loc3_.minutes < 10 ? "0" + String(_loc3_.minutes) : _loc3_.minutes);
               this.showHideIcon(this.isopen);
               break;
            case 1:
               EntertainmentModel.instance.score = _loc5_.readInt();
         }
      }
      
      public function showHideIcon(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler("entertainment",param1);
      }
      
      public function hide() : void
      {
         dispatchEvent(new Event("hideMainView"));
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["entertainmentMode"],this.onLoadedNew);
      }
      
      private function onLoadedNew() : void
      {
         dispatchEvent(new Event("showMainView"));
      }
   }
}

