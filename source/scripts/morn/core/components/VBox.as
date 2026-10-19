package morn.core.components
{
   public class VBox extends LayoutBox
   {
      
      public static const NONE:String = "none";
      
      public static const LEFT:String = "left";
      
      public static const CENTER:String = "center";
      
      public static const RIGHT:String = "right";
      
      public function VBox()
      {
         super();
      }
      
      override protected function changeItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Array = [];
         var _loc5_:* = 0;
         _loc1_ = 0;
         _loc2_ = numChildren;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = getChildAt(_loc1_) as Component;
            if(Boolean(_loc3_))
            {
               _loc4_.push(_loc3_);
               _loc5_ = Number(Math.max(_loc5_,_loc3_.displayWidth));
            }
            _loc1_++;
         }
         _loc4_.sortOn(["y"],16);
         var _loc6_:* = 0;
         for each(_loc3_ in _loc4_)
         {
            _loc3_.y = _maxY = _loc6_;
            _loc6_ += _loc3_.displayHeight + _space;
            if(_align == "left")
            {
               _loc3_.x = 0;
            }
            else if(_align == "center")
            {
               _loc3_.x = (_loc5_ - _loc3_.displayWidth) * 0.5;
            }
            else if(_align == "right")
            {
               _loc3_.x = _loc5_ - _loc3_.displayWidth;
            }
         }
         changeSize();
      }
   }
}

