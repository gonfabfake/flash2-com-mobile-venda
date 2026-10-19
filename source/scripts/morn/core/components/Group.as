package morn.core.components
{
   import flash.display.DisplayObject;
   import morn.core.handlers.Handler;
   
   [Event(name="change",type="flash.events.Event")]
   public class Group extends Box implements IItem
   {
      
      protected var _items:Vector.<ISelect>;
      
      protected var _selectHandler:Handler;
      
      protected var _selectedIndex:int = -1;
      
      protected var _skin:String;
      
      protected var _labels:String;
      
      protected var _labelColors:String;
      
      protected var _labelStroke:String;
      
      protected var _labelSize:Object;
      
      protected var _labelBold:Object;
      
      protected var _labelMargin:String;
      
      protected var _direction:String;
      
      protected var _space:Number = 0;
      
      public function Group(param1:String = null, param2:String = null)
      {
         super();
         this.skin = param2;
         this.labels = param1;
      }
      
      public function addItem(param1:ISelect, param2:Boolean = true) : int
      {
         var _loc3_:* = null;
         var _loc4_:DisplayObject = param1 as DisplayObject;
         var _loc5_:int = int(this._items.length);
         _loc4_.name = "item" + _loc5_;
         addChild(_loc4_);
         this.initItems();
         if(param2 && _loc5_ > 0)
         {
            _loc3_ = this._items[_loc5_ - 1] as DisplayObject;
            if(this._direction == "horizontal")
            {
               _loc4_.x = _loc3_.x + _loc3_.width + this._space;
            }
            else
            {
               _loc4_.y = _loc3_.y + _loc3_.height + this._space;
            }
         }
         return _loc5_;
      }
      
      public function delItem(param1:ISelect, param2:Boolean = true) : void
      {
         var _loc7_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         _loc7_ = this._items.indexOf(param1);
         if(_loc7_ != -1)
         {
            _loc3_ = param1 as DisplayObject;
            removeChild(_loc3_);
            _loc4_ = _loc7_ + 1;
            _loc5_ = int(this._items.length);
            while(_loc4_ < _loc5_)
            {
               _loc6_ = this._items[_loc4_] as DisplayObject;
               _loc6_.name = "item" + (_loc4_ - 1);
               if(param2)
               {
                  if(this._direction == "horizontal")
                  {
                     _loc6_.x -= _loc3_.width + this._space;
                  }
                  else
                  {
                     _loc6_.y -= _loc3_.height + this._space;
                  }
               }
               _loc4_++;
            }
            this.initItems();
            if(this._selectedIndex > -1)
            {
               this.selectedIndex = this._selectedIndex < this._items.length ? this._selectedIndex : int(this._selectedIndex - 1);
            }
         }
      }
      
      public function initItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._items = new Vector.<ISelect>();
         _loc1_ = 0;
         while(_loc1_ < 2147483647)
         {
            _loc2_ = getChildByName("item" + _loc1_) as ISelect;
            if(_loc2_ == null)
            {
               break;
            }
            this._items.push(_loc2_);
            _loc2_.selected = _loc1_ == this._selectedIndex;
            _loc2_.clickHandler = new Handler(this.itemClick,[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function itemClick(param1:int) : void
      {
         this.selectedIndex = param1;
      }
      
      public function resetSelect() : void
      {
         this.setSelect(this._selectedIndex,false);
         this._selectedIndex = -1;
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
            sendEvent("change");
            sendEvent("select");
            if(this._selectHandler != null)
            {
               this._selectHandler.executeWith([this._selectedIndex]);
            }
         }
      }
      
      public function set selectedIndexWithoutEvent(param1:int) : void
      {
         if(this._selectedIndex != param1)
         {
            this.setSelect(this._selectedIndex,false);
            this._selectedIndex = param1;
            this.setSelect(this._selectedIndex,true);
            sendEvent("change");
         }
      }
      
      protected function setSelect(param1:int, param2:Boolean) : void
      {
         if(Boolean(this._items) && Boolean(param1 > -1) && param1 < this._items.length)
         {
            this._items[param1].selected = param2;
         }
      }
      
      public function get selectHandler() : Handler
      {
         return this._selectHandler;
      }
      
      public function set selectHandler(param1:Handler) : void
      {
         this._selectHandler = param1;
      }
      
      public function get skin() : String
      {
         return this._skin;
      }
      
      public function set skin(param1:String) : void
      {
         if(this._skin != param1)
         {
            this._skin = param1;
            callLater(this.changeLabels);
         }
      }
      
      public function get labels() : String
      {
         return this._labels;
      }
      
      public function set labels(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         if(this._labels != param1)
         {
            this._labels = param1;
            removeAllChild();
            callLater(this.changeLabels);
            if(Boolean(this._labels))
            {
               _loc2_ = this._labels.split(",");
               _loc3_ = 0;
               _loc4_ = int(_loc2_.length);
               while(_loc3_ < _loc4_)
               {
                  _loc5_ = this.createItem(this._skin,_loc2_[_loc3_]);
                  _loc5_.name = "item" + _loc3_;
                  addChild(_loc5_);
                  _loc3_++;
               }
            }
            this.initItems();
         }
      }
      
      protected function createItem(param1:String, param2:String) : DisplayObject
      {
         return null;
      }
      
      public function get labelColors() : String
      {
         return this._labelColors;
      }
      
      public function set labelColors(param1:String) : void
      {
         if(this._labelColors != param1)
         {
            this._labelColors = param1;
            callLater(this.changeLabels);
         }
      }
      
      public function get labelStroke() : String
      {
         return this._labelStroke;
      }
      
      public function set labelStroke(param1:String) : void
      {
         if(this._labelStroke != param1)
         {
            this._labelStroke = param1;
            callLater(this.changeLabels);
         }
      }
      
      public function get labelSize() : Object
      {
         return this._labelSize;
      }
      
      public function set labelSize(param1:Object) : void
      {
         if(this._labelSize != param1)
         {
            this._labelSize = param1;
            callLater(this.changeLabels);
         }
      }
      
      public function get labelBold() : Object
      {
         return this._labelBold;
      }
      
      public function set labelBold(param1:Object) : void
      {
         if(this._labelBold != param1)
         {
            this._labelBold = param1;
            callLater(this.changeLabels);
         }
      }
      
      public function get labelMargin() : String
      {
         return this._labelMargin;
      }
      
      public function set labelMargin(param1:String) : void
      {
         if(this._labelMargin != param1)
         {
            this._labelMargin = param1;
            callLater(this.changeLabels);
         }
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         this._direction = param1;
         callLater(this.changeLabels);
      }
      
      public function get space() : Number
      {
         return this._space;
      }
      
      public function set space(param1:Number) : void
      {
         this._space = param1;
         callLater(this.changeLabels);
      }
      
      protected function changeLabels() : void
      {
      }
      
      override public function commitMeasure() : void
      {
         exeCallLater(this.changeLabels);
      }
      
      public function get items() : Vector.<ISelect>
      {
         return this._items;
      }
      
      public function get selection() : ISelect
      {
         return this._selectedIndex > -1 && this._selectedIndex < this._items.length ? this._items[this._selectedIndex] : null;
      }
      
      public function set selection(param1:ISelect) : void
      {
         this.selectedIndex = this._items.indexOf(param1);
      }
      
      override public function set dataSource(param1:Object) : void
      {
         _dataSource = param1;
         if(param1 is int || param1 is String)
         {
            this.selectedIndex = int(param1);
         }
         else if(param1 is Array)
         {
            this.labels = (param1 as Array).join(",");
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
         this._selectHandler = null;
      }
   }
}

