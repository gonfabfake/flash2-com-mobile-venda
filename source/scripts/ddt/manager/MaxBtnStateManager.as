package ddt.manager
{
   import ddt.events.CrazyTankSocketEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class MaxBtnStateManager extends EventDispatcher
   {
      
      private static var instance:MaxBtnStateManager;
      
      public static const MAX_BTN_STATE_CHANGE:String = "maxbtnstate_change";
      
      private var _maxBtnIsPackUp:Boolean = false;
      
      public function MaxBtnStateManager()
      {
         super();
         if(instance != null)
         {
            throw "MaxStateManager is a singleton.";
         }
      }
      
      public static function getInstance() : MaxBtnStateManager
      {
         if(!instance)
         {
            instance = new MaxBtnStateManager();
         }
         return instance;
      }
      
      public function dropDown() : void
      {
         GameInSocketOut.sendMaxBtnState(false);
      }
      
      public function packUp() : void
      {
         GameInSocketOut.sendMaxBtnState(true);
      }
      
      public function requireState() : void
      {
         GameInSocketOut.sendRequireMaxBtnState();
      }
      
      protected function onSetStateHandler(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         this._maxBtnIsPackUp = _loc2_;
         dispatchEvent(new Event("maxbtnstate_change"));
      }
      
      protected function onGetStateHandler(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         this._maxBtnIsPackUp = _loc2_;
         dispatchEvent(new Event("maxbtnstate_change"));
      }
      
      private function __stateHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = param1.pkg.readByte();
         if(_loc2_ == 1)
         {
            this.onGetStateHandler(param1.pkg);
         }
         else if(_loc2_ == 2)
         {
            this.onSetStateHandler(param1.pkg);
         }
      }
      
      public function addEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MAX_BUTTON_STATE,this.__stateHandler);
      }
      
      public function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MAX_BUTTON_STATE,this.__stateHandler);
      }
      
      public function dispose() : void
      {
         instance = null;
      }
      
      public function get maxBtnIsPackUp() : Boolean
      {
         return this._maxBtnIsPackUp;
      }
   }
}

