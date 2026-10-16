package gypsyShop.model
{
   import ddt.events.GypsyShopEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import hallIcon.HallIconManager;
   
   public class GypsyNPCModel extends EventDispatcher
   {
      
      private static var instance:GypsyNPCModel;
      
      private var _isStart:Boolean = false;
      
      private var _isOpen:Boolean = false;
      
      public function GypsyNPCModel(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : GypsyNPCModel
      {
         if(!instance)
         {
            instance = new GypsyNPCModel(new inner());
         }
         return instance;
      }
      
      public function init() : void
      {
         SocketManager.Instance.addEventListener(GypsyShopEvent.NPC_STATE_CHANGE,this.onNPCStateChange);
      }
      
      protected function onNPCStateChange(param1:GypsyShopEvent) : void
      {
         var _loc2_:ByteArray = param1.data;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            this._isStart = true;
            HallIconManager.instance.updateSwitchHandler("gypsyShop",true);
         }
         else
         {
            this._isStart = false;
            HallIconManager.instance.updateSwitchHandler("gypsyShop",false);
         }
         if(_loc3_)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("gypsy.open"));
         }
         else if(this._isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("gypsy.close"));
         }
         this._isOpen = _loc3_;
      }
      
      public function refreshNPCState() : void
      {
         if(this._isOpen)
         {
            this._isStart = true;
            HallIconManager.instance.updateSwitchHandler("gypsyShop",true);
         }
         else
         {
            this._isStart = false;
            HallIconManager.instance.updateSwitchHandler("gypsyShop",false);
         }
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(GypsyShopEvent.NPC_STATE_CHANGE,this.onNPCStateChange);
      }
      
      public function isStart() : Boolean
      {
         return this._isStart;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
