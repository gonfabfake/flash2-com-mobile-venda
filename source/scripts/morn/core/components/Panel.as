package morn.core.components
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import morn.editor.core.IContent;
   
   public class Panel extends Box implements IContent
   {
      
      protected var _content:Box;
      
      protected var _vScrollBar:VScrollBar;
      
      protected var _hScrollBar:HScrollBar;
      
      public function Panel()
      {
         super();
         this.width = this.height = 100;
      }
      
      override protected function createChildren() : void
      {
         super.addChild(this._content = new Box());
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         param1.addEventListener("resize",this.onResize);
         callLater(this.changeScroll);
         return this._content.addChild(param1);
      }
      
      private function onResize(param1:Event) : void
      {
         callLater(this.changeScroll);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         param1.addEventListener("resize",this.onResize);
         callLater(this.changeScroll);
         return this._content.addChildAt(param1,param2);
      }
      
      override public function getChildAt(param1:int) : DisplayObject
      {
         return this._content.getChildAt(param1);
      }
      
      override public function getChildByName(param1:String) : DisplayObject
      {
         return this._content.getChildByName(param1);
      }
      
      override public function getChildIndex(param1:DisplayObject) : int
      {
         return this._content.getChildIndex(param1);
      }
      
      override public function get numChildren() : int
      {
         return this._content.numChildren;
      }
      
      private function changeScroll() : void
      {
         var _loc1_:Number = this.contentWidth;
         var _loc2_:Number = this.contentHeight;
         var _loc3_:Boolean = Boolean(this._vScrollBar) && _loc2_ > _height;
         var _loc4_:Boolean = Boolean(this._hScrollBar) && _loc1_ > _width;
         var _loc5_:Number = _loc3_ ? _width - this._vScrollBar.width : Number(_width);
         var _loc6_:Number = _loc4_ ? _height - this._hScrollBar.height : Number(_height);
         this.setContentSize(_loc5_,_loc6_);
         if(Boolean(this._vScrollBar))
         {
            this._vScrollBar.x = _width - this._vScrollBar.width;
            this._vScrollBar.y = 0;
            this._vScrollBar.height = _height - (_loc4_ ? this._hScrollBar.height : 0);
            this._vScrollBar.scrollSize = Math.max(_height * 0.033,1);
            this._vScrollBar.thumbPercent = _loc6_ / _loc2_;
            this._vScrollBar.setScroll(0,_loc2_ - _loc6_,this._vScrollBar.value);
         }
         if(Boolean(this._hScrollBar))
         {
            this._hScrollBar.x = 0;
            this._hScrollBar.y = _height - this._hScrollBar.height;
            this._hScrollBar.width = _width - (_loc3_ ? this._vScrollBar.width : 0);
            this._hScrollBar.scrollSize = Math.max(_width * 0.033,1);
            this._hScrollBar.thumbPercent = _loc5_ / _loc1_;
            this._hScrollBar.setScroll(0,_loc1_ - _loc5_,this._hScrollBar.value);
         }
      }
      
      private function get contentWidth() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         _loc1_ = this._content.numChildren - 1;
         while(_loc1_ > -1)
         {
            _loc2_ = this._content.getChildAt(_loc1_);
            _loc3_ = Number(Math.max(_loc2_.x + _loc2_.width * _loc2_.scaleX,_loc3_));
            _loc1_--;
         }
         return _loc3_;
      }
      
      private function get contentHeight() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         _loc1_ = this._content.numChildren - 1;
         while(_loc1_ > -1)
         {
            _loc2_ = this._content.getChildAt(_loc1_);
            _loc3_ = Number(Math.max(_loc2_.y + _loc2_.height * _loc2_.scaleY,_loc3_));
            _loc1_--;
         }
         return _loc3_;
      }
      
      private function setContentSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.beginFill(16776960,0);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
         this._content.width = param1;
         this._content.height = param2;
         this._content.scrollRect = new Rectangle(0,0,param1,param2);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         callLater(this.changeScroll);
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         callLater(this.changeScroll);
      }
      
      public function get vScrollBarSkin() : String
      {
         return this._vScrollBar ? this._vScrollBar.skin : null;
      }
      
      public function set vScrollBarSkin(param1:String) : void
      {
         if(this._vScrollBar == null)
         {
            super.addChild(this._vScrollBar = new VScrollBar());
            this._vScrollBar.addEventListener("change",this.onScrollBarChange);
            this._vScrollBar.target = this;
            callLater(this.changeScroll);
         }
         this._vScrollBar.skin = param1;
      }
      
      public function get hScrollBarSkin() : String
      {
         return this._hScrollBar ? this._hScrollBar.skin : null;
      }
      
      public function set hScrollBarSkin(param1:String) : void
      {
         if(this._hScrollBar == null)
         {
            super.addChild(this._hScrollBar = new HScrollBar());
            this._hScrollBar.addEventListener("change",this.onScrollBarChange);
            this._hScrollBar.mouseWheelEnable = false;
            this._hScrollBar.target = this;
            callLater(this.changeScroll);
         }
         this._hScrollBar.skin = param1;
      }
      
      public function get vScrollBar() : ScrollBar
      {
         return this._vScrollBar;
      }
      
      public function get hScrollBar() : ScrollBar
      {
         return this._hScrollBar;
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
      
      protected function onScrollBarChange(param1:Event) : void
      {
         var _loc4_:Rectangle = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         _loc4_ = this._content.scrollRect;
         if(Boolean(_loc4_))
         {
            _loc2_ = param1.currentTarget as ScrollBar;
            _loc3_ = Math.round(_loc2_.value);
            if(_loc2_.direction == "vertical")
            {
               _loc4_.y = _loc3_;
            }
            else
            {
               Number(_loc4_.x = _loc3_);
            }
            this._content.scrollRect = _loc4_;
         }
      }
      
      override public function commitMeasure() : void
      {
         exeCallLater(this.changeScroll);
      }
      
      public function scrollTo(param1:Number = 0, param2:Number = 0) : void
      {
         this.commitMeasure();
         if(Boolean(this.vScrollBar))
         {
            this.vScrollBar.value = param2;
         }
         if(Boolean(this.hScrollBar))
         {
            this.hScrollBar.value = param1;
         }
      }
      
      public function refresh() : void
      {
         this.changeScroll();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._content && this._content.dispose();
         this._vScrollBar && this._vScrollBar.dispose();
         this._hScrollBar && this._hScrollBar.dispose();
         this._content = null;
         this._vScrollBar = null;
         this._hScrollBar = null;
      }
   }
}

