package morn.core.components
{
   import com.greensock.TweenLite;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import morn.core.events.DragEvent;
   import morn.core.handlers.Handler;
   import morn.editor.Builder;
   import morn.editor.Sys;
   import morn.editor.core.IRender;
   
   [Event(name="listRender",type="morn.core.events.UIEvent")]
   [Event(name="change",type="flash.events.Event")]
   public class List extends Box implements IRender, IItem
   {
      
      protected var _content:Box;
      
      protected var _scrollBar:ScrollBar;
      
      protected var _itemRender:*;
      
      protected var _repeatX:int;
      
      protected var _repeatY:int;
      
      protected var _repeatX2:int;
      
      protected var _repeatY2:int;
      
      protected var _spaceX:int;
      
      protected var _spaceY:int;
      
      protected var _cells:Vector.<Component> = new Vector.<Component>();
      
      protected var _array:Array;
      
      protected var _startIndex:int;
      
      protected var _selectedIndex:int = -1;
      
      protected var _selectHandler:Handler;
      
      protected var _renderHandler:Handler;
      
      protected var _mouseHandler:Handler;
      
      protected var _page:int;
      
      protected var _totalPage:int;
      
      protected var _isVerticalLayout:Boolean = true;
      
      protected var _cellSize:Number = 20;
      
      protected var _autoHideItem:Boolean = false;
      
      protected var _sliderOffset:int;
      
      public var autoHideScrollBar:Boolean = true;
      
      public function List()
      {
         super();
      }
      
      override protected function createChildren() : void
      {
         addChild(this._content = new Box());
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         return param1 != this._content ? super.removeChild(param1) : null;
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         return getChildAt(param1) != this._content ? super.removeChildAt(param1) : null;
      }
      
      public function get content() : Box
      {
         return this._content;
      }
      
      public function get scrollBar() : ScrollBar
      {
         return this._scrollBar;
      }
      
      public function set scrollBar(param1:ScrollBar) : void
      {
         if(this._scrollBar != param1)
         {
            this._scrollBar = param1;
            if(Boolean(param1))
            {
               addChild(this._scrollBar);
               this._scrollBar.target = this;
               this._scrollBar.addEventListener("change",this.onScrollBarChange);
               this._isVerticalLayout = this._scrollBar.direction == "vertical";
            }
         }
      }
      
      public function get itemRender() : *
      {
         return this._itemRender;
      }
      
      public function set itemRender(param1:*) : void
      {
         this._itemRender = param1;
         callLater(this.changeCells);
      }
      
      public function get repeatX() : int
      {
         return this._repeatX > 0 ? this._repeatX : (this._repeatX2 > 0 ? this._repeatX2 : 1);
      }
      
      public function set repeatX(param1:int) : void
      {
         this._repeatX = param1;
         callLater(this.changeCells);
      }
      
      public function get repeatY() : int
      {
         return this._repeatY > 0 ? this._repeatY : (this._repeatY2 > 0 ? this._repeatY2 : 1);
      }
      
      public function set repeatY(param1:int) : void
      {
         this._repeatY = param1;
         callLater(this.changeCells);
      }
      
      public function get spaceX() : int
      {
         return this._spaceX;
      }
      
      public function set spaceX(param1:int) : void
      {
         this._spaceX = param1;
         callLater(this.changeCells);
      }
      
      public function get spaceY() : int
      {
         return this._spaceY;
      }
      
      public function set spaceY(param1:int) : void
      {
         this._spaceY = param1;
         callLater(this.changeCells);
      }
      
      protected function changeCells() : void
      {
         var _loc1_:* = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(Boolean(this._itemRender))
         {
            this.destroyCells();
            this._cells.length = 0;
            this.scrollBar = getChildByName("scrollBar") as ScrollBar;
            _loc1_ = this.createItem();
            _loc2_ = _loc1_.width + this._spaceX;
            if(this._repeatX < 1 && !isNaN(_width))
            {
               this._repeatX2 = Math.round(_width / _loc2_);
            }
            _loc3_ = _loc1_.height + this._spaceY;
            if(this._repeatY < 1 && !isNaN(_height))
            {
               this._repeatY2 = Math.round(_height / _loc3_);
            }
            _loc4_ = isNaN(_width) ? _loc2_ * this.repeatX - this._spaceX : Number(_width);
            _loc5_ = isNaN(_height) ? _loc3_ * this.repeatY - this._spaceY : Number(_height);
            this._cellSize = this._isVerticalLayout ? _loc3_ : Number(_loc2_);
            if(this._isVerticalLayout && Boolean(this._scrollBar))
            {
               this._scrollBar.height = _loc5_;
            }
            else if(!this._isVerticalLayout && Boolean(this._scrollBar))
            {
               this._scrollBar.width = _loc4_;
            }
            this.setContentSize(_loc4_,_loc5_);
            _loc6_ = this._isVerticalLayout ? this.repeatX : int(this.repeatY);
            _loc7_ = (this._isVerticalLayout ? this.repeatY : int(this.repeatX)) + (this._scrollBar ? 1 : 0);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc6_)
               {
                  _loc1_ = this.createItem();
                  _loc1_.x = (this._isVerticalLayout ? _loc9_ : int(_loc8_)) * (this._spaceX + _loc1_.width);
                  _loc1_.y = (this._isVerticalLayout ? _loc8_ : int(_loc9_)) * (this._spaceY + _loc1_.height);
                  _loc1_.name = "item" + (_loc8_ * _loc6_ + _loc9_);
                  this._content.addChild(_loc1_);
                  this.addCell(_loc1_);
                  _loc9_++;
               }
               _loc8_++;
            }
         }
         if(Boolean(this._array))
         {
            this.array = this._array;
            exeCallLater(this.renderItems);
         }
      }
      
      public function updateCellSpaceX() : void
      {
         TweenLite.killTweensOf(this.updateCellSpaceXReal);
         TweenLite.delayedCall(2,this.updateCellSpaceXReal,null,true);
      }
      
      private function updateCellSpaceXReal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = this.repeatX;
         var _loc4_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._cells[_loc1_];
            _loc2_.x = _loc4_;
            _loc4_ = Number(_loc2_.x + _loc2_.width + this._spaceX);
            _loc1_++;
         }
      }
      
      public function updateCellSpaceYReal() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = int(this._cells.length);
         var _loc4_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this._cells[_loc1_];
            _loc2_.y = _loc4_;
            _loc4_ = Number(_loc2_.y + _loc2_.height + this._spaceY);
            _loc1_++;
         }
      }
      
      private function createItem() : Box
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(!Builder.isEditor)
         {
            return this._itemRender is Class ? new this._itemRender() : View.createComp(this._itemRender) as Box;
         }
         _loc2_ = Sys.getCompInstance(this._itemRender);
         _loc3_ = new Box();
         _loc3_.addChild(_loc2_);
         return _loc3_;
      }
      
      private function destroyCells() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener("click",this.onCellMouse);
            _loc1_.removeEventListener("rollOver",this.onCellMouse);
            _loc1_.removeEventListener("rollOut",this.onCellMouse);
            _loc1_.removeEventListener("mouseDown",this.onCellMouse);
            _loc1_.removeEventListener("mouseUp",this.onCellMouse);
            _loc1_.removeEventListener("doubleClick",this.onCellMouse);
            ObjectUtils.disposeObject(_loc1_);
         }
      }
      
      protected function addCell(param1:Component) : void
      {
         param1.addEventListener("click",this.onCellMouse);
         param1.addEventListener("rollOver",this.onCellMouse);
         param1.addEventListener("rollOut",this.onCellMouse);
         param1.addEventListener("mouseDown",this.onCellMouse);
         param1.addEventListener("mouseUp",this.onCellMouse);
         param1.addEventListener("doubleClick",this.onCellMouse);
         this._cells.push(param1);
      }
      
      public function initItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(!this._itemRender)
         {
            _loc1_ = 0;
            while(_loc1_ < 2147483647)
            {
               _loc2_ = getChildByName("item" + _loc1_) as Component;
               if(!_loc2_)
               {
                  break;
               }
               this.addCell(_loc2_);
               _loc1_++;
            }
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         callLater(this.changeCells);
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         callLater(this.changeCells);
      }
      
      public function setContentSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.beginFill(16711680,0);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
         this._content.width = param1;
         this._content.height = param2;
         if(Boolean(this._scrollBar))
         {
            this._content.scrollRect = new Rectangle(0,0,param1,param2);
         }
      }
      
      protected function onCellMouse(param1:MouseEvent) : void
      {
         var _loc2_:Component = param1.currentTarget as Component;
         if(!_loc2_.selectEnable)
         {
            return;
         }
         var _loc3_:int = this._startIndex + this._cells.indexOf(_loc2_);
         if(param1.type == "click" || param1.type == "rollOver" || param1.type == "rollOut")
         {
            if(param1.type == "click")
            {
               if(_selectEnable)
               {
                  this.selectedIndex = _loc3_;
               }
               else
               {
                  this.changeCellState(_loc2_,true,0);
                  this.changeCellBg(_loc2_,0);
               }
            }
            else if(this._selectedIndex != _loc3_)
            {
               this.changeCellState(_loc2_,param1.type == "rollOver",0);
            }
         }
         if(this._mouseHandler != null)
         {
            this._mouseHandler.executeWith([param1,_loc3_]);
         }
      }
      
      protected function changeCellState(param1:Component, param2:Boolean, param3:int) : void
      {
         var _loc4_:Component = null;
         _loc4_ = param1.getChildByName("selectBox") as Component;
         if(Boolean(_loc4_))
         {
            _loc4_.visible = param2;
            if(_loc4_ is Clip)
            {
               (_loc4_ as Clip).frame = param3;
            }
         }
      }
      
      protected function changeCellBg(param1:Component, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Clip = param1.getChildByName("selectBg") as Clip;
         if(Boolean(_loc4_))
         {
            _loc4_.frame = param2;
         }
         _loc3_ = 0;
         while(_loc3_ < 2147483647)
         {
            _loc4_ = param1.getChildByName("selectBg" + _loc3_) as Clip;
            if(!_loc4_)
            {
               break;
            }
            _loc4_.frame = param2;
            _loc3_++;
         }
      }
      
      protected function onScrollBarChange(param1:Event) : void
      {
         exeCallLater(this.changeCells);
         var _loc2_:Rectangle = this._content.scrollRect;
         var _loc3_:Number = this._scrollBar.value;
         if(isNaN(_loc3_))
         {
            this._scrollBar.value = 0;
            return;
         }
         var _loc4_:int = int(_loc3_ / this._cellSize) * (this._isVerticalLayout ? this.repeatX : int(this.repeatY));
         if(_loc4_ != this._startIndex)
         {
            this.startIndex = _loc4_;
         }
         if(this._isVerticalLayout)
         {
            _loc2_.y = _loc3_ % this._cellSize;
         }
         else
         {
            _loc2_.x = _loc3_ % this._cellSize;
         }
         this._content.scrollRect = _loc2_;
      }
      
      public function get autoHideItem() : Boolean
      {
         return this._autoHideItem;
      }
      
      public function set autoHideItem(param1:Boolean) : void
      {
         this._autoHideItem = param1;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex != param1)
         {
            this._selectedIndex = param1;
            this.changeSelectStatus();
         }
         sendEvent("change");
         sendEvent("select");
         if(this._selectHandler != null)
         {
            this._selectHandler.executeWith([param1]);
         }
      }
      
      public function resetSelect() : void
      {
         this._selectedIndex = -1;
      }
      
      protected function changeSelectStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         _loc2_ = int(this._cells.length);
         while(_loc1_ < _loc2_)
         {
            this.changeCellState(this._cells[_loc1_],this._selectedIndex == this._startIndex + _loc1_,1);
            this.changeCellBg(this._cells[_loc1_],this._selectedIndex == this._startIndex + _loc1_ ? 1 : 0);
            _loc1_++;
         }
      }
      
      public function get selectedItem() : Object
      {
         return this._selectedIndex != -1 ? this._array[this._selectedIndex] : null;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         this.selectedIndex = this._array.indexOf(param1);
      }
      
      public function get selection() : Component
      {
         return this.getCell(this._selectedIndex);
      }
      
      public function set selection(param1:Component) : void
      {
         this.selectedIndex = this._startIndex + this._cells.indexOf(param1);
      }
      
      public function get selectHandler() : Handler
      {
         return this._selectHandler;
      }
      
      public function set selectHandler(param1:Handler) : void
      {
         this._selectHandler = param1;
      }
      
      public function get renderHandler() : Handler
      {
         return this._renderHandler;
      }
      
      public function set renderHandler(param1:Handler) : void
      {
         this._renderHandler = param1;
      }
      
      public function get mouseHandler() : Handler
      {
         return this._mouseHandler;
      }
      
      public function set mouseHandler(param1:Handler) : void
      {
         this._mouseHandler = param1;
      }
      
      public function get startIndex() : int
      {
         return this._startIndex;
      }
      
      public function set startIndex(param1:int) : void
      {
         this._startIndex = param1 > 0 ? param1 : 0;
         callLater(this.renderItems);
      }
      
      public function get sliderOffset() : int
      {
         return this._sliderOffset;
      }
      
      public function set sliderOffset(param1:int) : void
      {
         this._sliderOffset = param1 > 0 ? param1 : 0;
         callLater(this.resetScrollBar);
      }
      
      public function renderItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         _loc2_ = int(this._cells.length);
         while(_loc1_ < _loc2_)
         {
            this.renderItem(this._cells[_loc1_],this._startIndex + _loc1_);
            _loc1_++;
         }
         this.changeSelectStatus();
      }
      
      protected function renderItem(param1:Component, param2:int) : void
      {
         param1.visible = true;
         if(param2 < this._array.length)
         {
            param1.dataSource = this._array[param2];
         }
         else
         {
            if(this._autoHideItem)
            {
               param1.visible = false;
            }
            param1.dataSource = null;
         }
         this.changeItemBg(param1,param2);
         sendEvent("listRender",[param1,param2]);
         if(this._renderHandler != null)
         {
            this._renderHandler.executeWith([param1,param2]);
         }
      }
      
      private function changeItemBg(param1:Component, param2:int) : void
      {
         var _loc3_:Clip = param1.getChildByName("itemBg") as Clip;
         if(Boolean(_loc3_))
         {
            _loc3_.index = param2 % 2;
         }
      }
      
      public function get array() : Array
      {
         return this._array;
      }
      
      public function set array(param1:Array) : void
      {
         exeCallLater(this.changeCells);
         this._array = param1 || [];
         var _loc2_:int = int(this._array.length);
         this._totalPage = Math.ceil(_loc2_ / (this.repeatX * this.repeatY));
         this._selectedIndex = this._selectedIndex < _loc2_ ? this._selectedIndex : int(_loc2_ - 1);
         this.startIndex = this._startIndex;
         this.resetScrollBar();
      }
      
      protected function resetScrollBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(Boolean(this._scrollBar))
         {
            _loc1_ = this._isVerticalLayout ? this.repeatX : int(this.repeatY);
            _loc2_ = this._isVerticalLayout ? this.repeatY : int(this.repeatX);
            _loc3_ = this._isVerticalLayout ? 0 : this._sliderOffset;
            _loc4_ = this._isVerticalLayout ? this._sliderOffset : 0;
            _loc5_ = Math.ceil(this.length / _loc1_);
            if(this.autoHideScrollBar)
            {
               this._scrollBar.visible = this._totalPage > 1;
            }
            else
            {
               this._scrollBar.visible = true;
            }
            if(this._scrollBar.visible)
            {
               this._scrollBar.scrollSize = this._cellSize;
               this._scrollBar.thumbPercent = _loc2_ / _loc5_;
               this._scrollBar.setScroll(_loc3_,(_loc5_ - _loc2_) * this._cellSize + _loc4_,this._startIndex / _loc1_ * this._cellSize);
            }
            else
            {
               this._scrollBar.setScroll(_loc3_,_loc4_,0);
            }
         }
      }
      
      public function get totalPage() : int
      {
         return this._totalPage;
      }
      
      public function set totalPage(param1:int) : void
      {
         this._totalPage = param1;
      }
      
      public function get page() : int
      {
         return this._page;
      }
      
      public function set page(param1:int) : void
      {
         this._page = param1;
         if(Boolean(this._array))
         {
            this._page = param1 > 0 ? param1 : 0;
            this._page = this._page < this._totalPage ? this._page : int(this._totalPage - 1);
            this.startIndex = this._page * this.repeatX * this.repeatY;
         }
      }
      
      public function get length() : int
      {
         return this._array ? int(this._array.length) : 0;
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
            this.array = param1 as Array;
         }
         else
         {
            super.dataSource = param1;
         }
      }
      
      public function get cells() : Vector.<Component>
      {
         exeCallLater(this.changeCells);
         return this._cells;
      }
      
      public function get vScrollBarSkin() : String
      {
         return this._scrollBar ? this._scrollBar.skin : null;
      }
      
      public function set vScrollBarSkin(param1:String) : void
      {
         removeChildByName("scrollBar");
         var _loc2_:ScrollBar = new VScrollBar();
         _loc2_.name = "scrollBar";
         _loc2_.right = 0;
         _loc2_.skin = param1;
         addChild(_loc2_);
         callLater(this.changeCells);
      }
      
      public function get hScrollBarSkin() : String
      {
         return this._scrollBar ? this._scrollBar.skin : null;
      }
      
      public function set hScrollBarSkin(param1:String) : void
      {
         removeChildByName("scrollBar");
         var _loc2_:ScrollBar = new HScrollBar();
         _loc2_.name = "scrollBar";
         _loc2_.bottom = 0;
         _loc2_.skin = param1;
         addChild(_loc2_);
         callLater(this.changeCells);
      }
      
      override public function commitMeasure() : void
      {
         exeCallLater(this.changeCells);
      }
      
      public function refresh() : void
      {
         this.array = this._array;
      }
      
      public function getItem(param1:int) : Object
      {
         if(param1 > -1 && param1 < this._array.length)
         {
            return this._array[param1];
         }
         return null;
      }
      
      public function changeItem(param1:int, param2:Object) : void
      {
         if(param1 > -1 && param1 < this._array.length)
         {
            this._array[param1] = param2;
            if(param1 >= this._startIndex && param1 < this._startIndex + this._cells.length)
            {
               this.renderItem(this.getCell(param1),param1);
            }
         }
      }
      
      public function addItem(param1:Object) : void
      {
         this._array.push(param1);
         this.array = this._array;
      }
      
      public function addItemAt(param1:Object, param2:int) : void
      {
         this._array.splice(param2,0,param1);
         this.array = this._array;
      }
      
      public function deleteItem(param1:int) : void
      {
         this._array.splice(param1,1);
         this.array = this._array;
      }
      
      public function updateItem(param1:int, param2:*) : void
      {
         this._array[param1] = param2;
      }
      
      public function getCell(param1:int) : Box
      {
         exeCallLater(this.changeCells);
         if(param1 > -1 && Boolean(this._cells))
         {
            return this._cells[(param1 - this._startIndex) % this._cells.length] as Box;
         }
         return null;
      }
      
      public function scrollTo(param1:int) : void
      {
         var _loc2_:int = 0;
         this.startIndex = param1;
         if(Boolean(this._scrollBar))
         {
            _loc2_ = this._isVerticalLayout ? this.repeatX : int(this.repeatY);
            this._scrollBar.value = param1 / _loc2_ * this._cellSize;
         }
      }
      
      public function getDropIndex(param1:DragEvent) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = param1.data.dropTarget;
         _loc2_ = 0;
         _loc3_ = int(this._cells.length);
         while(_loc2_ < _loc3_)
         {
            if(this._cells[_loc2_].contains(_loc4_))
            {
               return this._startIndex + _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         TweenLite.killTweensOf(this.updateCellSpaceXReal);
         this.destroyCells();
         this._content && this._content.dispose();
         this._scrollBar && this._scrollBar.dispose();
         this._content = null;
         this._scrollBar = null;
         this._itemRender = null;
         this._cells = null;
         this._array = null;
         this._selectHandler = null;
         this._renderHandler = null;
         this._mouseHandler = null;
      }
   }
}

