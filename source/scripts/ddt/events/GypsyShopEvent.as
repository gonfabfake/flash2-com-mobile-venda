package ddt.events
{
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   public class GypsyShopEvent extends Event
   {
      
      public static const NPC_STATE_CHANGE:String = "npc_state_change";
      
      public static const GOT_NEW_ITEM_LIST:String = "got_new_item_list";
      
      public static const ON_BUY_RESULT:String = "on_buy_result";
      
      public static const ON_RARE_ITEM_UPDATED:String = "on_rare_item_updated";
      
      private var _data:ByteArray;
      
      public function GypsyShopEvent(param1:String, param2:ByteArray, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      public function get data() : ByteArray
      {
         return this._data;
      }
   }
}

