package BraveDoor.event
{
   import BombTurnTable.event.TurnTableEvent;
   import flash.events.Event;
   
   public class BraveDoorEvent extends Event
   {
      
      private var _data:Object;
      
      public function BraveDoorEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         this._data = param2;
         super(param1,param3,param4);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      override public function clone() : Event
      {
         return new TurnTableEvent(type,this._data,bubbles,cancelable);
      }
   }
}

