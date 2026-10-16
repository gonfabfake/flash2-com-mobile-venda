package com.pickgliss.ui.controls.container
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class VBox extends BoxContainer
   {
      
      public function VBox()
      {
         super();
      }
      
      override public function arrange() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         _loc1_ = NaN;
         _loc2_ = 0;
         _loc3_ = null;
         _width = 0;
         _height = 0;
         _loc1_ = 0;
         var _loc4_:Number = 0;
         _loc2_ = 0;
         while(_loc2_ < _childrenList.length)
         {
            _loc3_ = _childrenList[_loc2_];
            _loc3_.y = _loc1_;
            _loc1_ += this.getItemHeight(_loc3_);
            _loc1_ += _spacing;
            if(_autoSize == CENTER && _loc2_ != 0)
            {
               _loc4_ = _childrenList[0].x - (_loc3_.width - _childrenList[0].width) / 2;
            }
            else if(_autoSize == RIGHT_OR_BOTTOM && _loc2_ != 0)
            {
               _loc4_ = _childrenList[0].x - (_loc3_.width - _childrenList[0].width);
            }
            else
            {
               _loc4_ = _loc3_.x;
            }
            _loc3_.x = _loc4_;
            _height += this.getItemHeight(_loc3_);
            _width = Math.max(_width,_loc3_.width);
            _loc2_++;
         }
         _height += _spacing * (numChildren - 1);
         _height = Math.max(0,_height);
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function getItemHeight(param1:DisplayObject) : Number
      {
         if(isStrictSize)
         {
            return _strictSize;
         }
         return param1.height;
      }
   }
}

