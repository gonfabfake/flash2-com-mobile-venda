package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import ddt.data.goods.InventoryItemInfo;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class InventoryItemAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
      
      private var _xml:XML;
      
      private var _timer:Timer;
      
      private var _xmllist:XMLList;
      
      private var _index:int;
      
      public function InventoryItemAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         this._xml = new XML(param1);
         this.list = new Vector.<InventoryItemInfo>();
         this.parseTemplate();
      }
      
      protected function parseTemplate() : void
      {
         if(this._xml.@value == "true")
         {
            this._xmllist = this._xml..Item;
            this._index = -1;
            this._timer = new Timer(30);
            this._timer.addEventListener(TimerEvent.TIMER,this.__partexceute);
            this._timer.start();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
      
      private function __partexceute(param1:TimerEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < 40)
         {
            ++this._index;
            if(this._index >= this._xmllist.length())
            {
               this._timer.removeEventListener(TimerEvent.TIMER,this.__partexceute);
               this._timer.stop();
               this._timer = null;
            }
         }
      }
   }
}

