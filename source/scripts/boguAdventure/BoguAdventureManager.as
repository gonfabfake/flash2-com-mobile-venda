package boguAdventure
{
   import boguAdventure.model.BoguAdventureType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class BoguAdventureManager
   {
      
      private static var _this:BoguAdventureManager;
      
      private var _isOpen:Boolean;
      
      public function BoguAdventureManager()
      {
         super();
      }
      
      public static function get instance() : BoguAdventureManager
      {
         if(_this == null)
         {
            _this = new BoguAdventureManager();
         }
         return _this;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOGU_ADVENTURE,this.__onActivityState);
      }
      
      private function __onActivityState(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         if(param1._cmd == BoguAdventureType.ACTIVITY_OPEN)
         {
            this._isOpen = _loc2_.readBoolean();
            this.checkOpen();
         }
      }
      
      public function checkOpen() : void
      {
         if(this._isOpen)
         {
            if(PlayerManager.Instance.Self.Grade >= 10)
            {
               HallIconManager.instance.updateSwitchHandler(HallIconType.BOGUADVENTURE,true);
            }
            else
            {
               HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.BOGUADVENTURE,true,10);
            }
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.BOGUADVENTURE,false);
            HallIconManager.instance.executeCacheRightIconLevelLimit(HallIconType.BOGUADVENTURE,false);
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
   }
}

