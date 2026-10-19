package morn.core.components
{
   import flash.display.DisplayObject;
   import morn.core.handlers.Handler;
   
   public class ViewStack extends Box implements IItem
   {
      
      protected var _items:Vector.<DisplayObject>;
      
      protected var _setIndexHandler:Handler;
      
      protected var _selectedIndex:int;
      
      public function ViewStack()
      {
         this._setIndexHandler = new Handler(this.setIndex);
         super();
      }
      
      public function setItems(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         removeAllChild();
         var _loc5_:int = 0;
         _loc2_ = 0;
         _loc3_ = int(param1.length);
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1[_loc2_];
            if(Boolean(_loc4_))
            {
               _loc4_.name = "item" + _loc5_;
               addChild(_loc4_);
               _loc5_++;
            }
            _loc2_++;
         }
         this.initItems();
      }
      
      public function addItem(param1:DisplayObject) : void
      {
         param1.name = "item" + this._items.length;
         addChild(param1);
         this.initItems();
      }
      
      public function initItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._items = new Vector.<DisplayObject>();
         _loc1_ = 0;
         while(_loc1_ < 2147483647)
         {
            _loc2_ = getChildByName("item" + _loc1_);
            if(_loc2_ == null)
            {
               break;
            }
            this._items.push(_loc2_);
            _loc2_.visible = _loc1_ == this._selectedIndex;
            _loc1_++;
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex != param1)
         {
            this.setSelect(this._selectedIndex,false);
            this._selectedIndex = param1;
            this.setSelect(this._selectedIndex,true);
         }
      }
      
      protected function setSelect(param1:int, param2:Boolean) : void
      {
         if(Boolean(this._items) && Boolean(param1 > -1) && param1 < this._items.length)
         {
            this._items[param1].visible = param2;
         }
      }
      
      public function get selection() : DisplayObject
      {
         return this._selectedIndex > -1 && this._selectedIndex < this._items.length ? this._items[this._selectedIndex] : null;
      }
      
      public function set selection(param1:DisplayObject) : void
      {
         this.selectedIndex = this._items.indexOf(param1);
      }
      
      public function get setIndexHandler() : Handler
      {
         return this._setIndexHandler;
      }
      
      public function set setIndexHandler(param1:Handler) : void
      {
         this._setIndexHandler = param1;
      }
      
      protected function setIndex(param1:int) : void
      {
         this.selectedIndex = param1;
      }
      
      public function get items() : Vector.<DisplayObject>
      {
         return this._items;
      }
      
      override public function set dataSource(param1:Object) : void
      {
         _dataSource = param1;
         if(param1 is int || param1 is String)
         {
            this.selectedIndex = int(param1);
         }
         else
         {
            super.dataSource = param1;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._items))
         {
            this._items.length = 0;
         }
         this._items = null;
         this._setIndexHandler = null;
      }
   }
}

