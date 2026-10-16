package BraveDoor.data
{
   import flash.events.EventDispatcher;
   
   public class BraveDoorDuplicateInfo extends EventDispatcher
   {
      
      private var _mapUrl:String;
      
      private var _mapWidth:int;
      
      private var _mapHeight:int;
      
      private var _mapX:int;
      
      private var _mapY:int;
      
      private var _page:int;
      
      private var _duplicateInfo:Vector.<DuplicateInfo> = null;
      
      public function BraveDoorDuplicateInfo()
      {
         super();
         this._duplicateInfo = new Vector.<DuplicateInfo>();
      }
      
      public function get duplicateInfo() : Vector.<DuplicateInfo>
      {
         return this._duplicateInfo;
      }
      
      public function addDuplicateInfo(param1:DuplicateInfo) : void
      {
         this._duplicateInfo.push(param1);
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function set page(param1:int) : void
      {
         this._page = param1;
      }
      
      public function get mapY() : int
      {
         return this._mapY;
      }
      
      public function set mapY(param1:int) : void
      {
         this._mapY = param1;
      }
      
      public function get mapX() : int
      {
         return this._mapX;
      }
      
      public function set mapX(param1:int) : void
      {
         this._mapX = param1;
      }
      
      public function get mapHeight() : int
      {
         return this._mapHeight;
      }
      
      public function set mapHeight(param1:int) : void
      {
         this._mapHeight = param1;
      }
      
      public function get mapWidth() : int
      {
         return this._mapWidth;
      }
      
      public function set mapWidth(param1:int) : void
      {
         this._mapWidth = param1;
      }
      
      public function get mapUrl() : String
      {
         return this._mapUrl;
      }
      
      public function set mapUrl(param1:String) : void
      {
         this._mapUrl = param1;
      }
   }
}

