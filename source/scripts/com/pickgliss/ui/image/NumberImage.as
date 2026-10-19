package com.pickgliss.ui.image
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   
   public class NumberImage extends Component
   {
      
      private var _countList:Vector.<ScaleFrameImage>;
      
      private var _count:String;
      
      private var _stylename:String;
      
      private var _countWidth:int;
      
      private var _space:int;
      
      public function NumberImage()
      {
         super();
         mouseEnabled = mouseChildren = false;
         this._countList = new Vector.<ScaleFrameImage>();
      }
      
      public function set imageStyle(param1:String) : void
      {
         this._stylename = param1;
      }
      
      public function set countWidth(param1:int) : void
      {
         this._countWidth = param1;
      }
      
      public function set space(param1:int) : void
      {
         this._space = param1;
      }
      
      public function set count(param1:int) : void
      {
         if(this._count == param1.toString())
         {
            return;
         }
         this._count = param1.toString();
         this.updateView();
      }
      
      public function set countStr(param1:String) : void
      {
         if(this._count == param1)
         {
            return;
         }
         this._count = param1;
         this.updateView();
      }
      
      public function get count() : int
      {
         return int(this._count);
      }
      
      private function updateView() : void
      {
         var _loc1_:int = 0;
         var _loc4_:Array = null;
         _loc1_ = 0;
         var _loc2_:int = 0;
         var _loc3_:int = this._count.length;
         _loc4_ = this._count.split("");
         while(_loc3_ > this._countList.length)
         {
            this._countList.unshift(this.createCountImage(10));
         }
         while(_loc3_ < this._countList.length)
         {
            ObjectUtils.disposeObject(this._countList.shift());
         }
         var _loc5_:int = 0;
         if(this._countWidth > 0)
         {
            _loc5_ = (this._countWidth - this._countList[0].width * _loc3_) / 2;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            this._countList[_loc1_].x = _loc5_;
            _loc2_ = int(_loc4_[_loc1_]) == 0 ? 10 : int(_loc4_[_loc1_]);
            this._countList[_loc1_].setFrame(_loc2_);
            _loc5_ += this._countList[_loc1_].width + this._space;
            _loc1_++;
         }
         width = _loc5_;
      }
      
      private function createCountImage(param1:int = 0) : ScaleFrameImage
      {
         var _loc2_:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename(this._stylename);
         _loc2_.setFrame(param1);
         addChild(_loc2_);
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         while(Boolean(this._countList.length))
         {
            ObjectUtils.disposeObject(this._countList.shift());
         }
         this._countList = null;
      }
   }
}

