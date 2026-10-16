package morn.core.ex
{
   import flash.geom.Rectangle;
   import morn.core.components.AutoBitmap;
   import morn.core.components.Component;
   import morn.core.components.HBox;
   
   public class HBoxEx extends HBox
   {
      
      protected var _autoBg:AutoBitmap;
      
      protected var _autoBgBorderSpace:Rectangle;
      
      public function HBoxEx()
      {
         super();
      }
      
      override protected function changeItems() : void
      {
         var _loc5_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Array = [];
         _loc5_ = 0;
         var _loc6_:* = 0;
         _loc1_ = 0;
         _loc2_ = numChildren;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = getChildAt(_loc1_) as Component;
            if(Boolean(_loc3_) && Boolean(_loc3_.visible))
            {
               _loc4_.push(_loc3_);
               _loc6_ = Number(Math.max(_loc6_,_loc3_.height));
            }
            _loc1_++;
         }
         _loc4_.sortOn(["x"],16);
         var _loc7_:* = 0;
         for each(_loc3_ in _loc4_)
         {
            _loc3_.x = _maxX = _loc7_;
            _loc7_ += _loc3_.width + _space;
            if(_align == "top")
            {
               _loc3_.y = 0;
            }
            else if(_align == "middle")
            {
               _loc3_.y = (_loc6_ - _loc3_.height) * 0.5;
            }
            else if(_align == "bottom")
            {
               _loc3_.y = _loc6_ - _loc3_.height;
            }
            _loc5_ += _loc3_.width + _space;
         }
         changeSize();
         if(Boolean(this._autoBg))
         {
            if(Boolean(this._autoBgBorderSpace))
            {
               this._autoBg.x = this._autoBgBorderSpace.x;
               this._autoBg.y = this._autoBgBorderSpace.y;
               this._autoBg.width = _loc5_ - _space + this._autoBgBorderSpace.width + this._autoBgBorderSpace.height;
            }
            else
            {
               this._autoBg.x = 0;
               this._autoBg.width = _loc5_ - _space;
            }
         }
      }
      
      public function set autoBgSkin(param1:String) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(param1 != "" || param1 != null)
         {
            if(this._autoBg == null)
            {
               addChildAt(this._autoBg = new AutoBitmap(),0);
            }
            _loc2_ = param1.split("|");
            this._autoBg.bitmapData = App.asset.getBitmapData(_loc2_[0]);
            if(_loc2_.length > 1)
            {
               _loc3_ = _loc2_[1].split(",");
               if(_loc3_.length > 2)
               {
                  this._autoBgBorderSpace = new Rectangle(_loc3_[0],_loc3_[1],_loc3_[2],_loc3_[3]);
               }
               else
               {
                  this._autoBg.x = _loc3_[0];
                  this._autoBg.y = _loc3_[1];
               }
            }
            if(_loc2_.length > 2)
            {
               _loc4_ = _loc2_[2].split(",");
               this._autoBg.sizeGrid = _loc4_;
            }
         }
         else
         {
            this.removeAutoBg();
         }
      }
      
      private function removeAutoBg() : void
      {
         if(Boolean(this._autoBg))
         {
            if(Boolean(this._autoBg.parent))
            {
               this._autoBg.parent.removeChild(this._autoBg);
            }
            this._autoBg.dispose();
            this._autoBg = null;
         }
         this._autoBgBorderSpace = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeAutoBg();
      }
   }
}

