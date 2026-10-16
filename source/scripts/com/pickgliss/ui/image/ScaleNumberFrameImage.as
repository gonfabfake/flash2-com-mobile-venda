package com.pickgliss.ui.image
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ScaleNumberFrameImage extends ScaleFrameImage
   {
      
      private var _cutWidth:int;
      
      private var _image:Bitmap;
      
      public function ScaleNumberFrameImage()
      {
         super();
      }
      
      public function set cutWidth(param1:int) : void
      {
         if(this._cutWidth == param1)
         {
            return;
         }
         this._cutWidth = param1;
      }
      
      override protected function addChildren() : void
      {
         if(Boolean(this._image))
         {
            addChild(this._image);
         }
      }
      
      override protected function resetDisplay() : void
      {
         _display = ComponentFactory.Instance.creat(_resourceLink);
         _display.blendMode = "layer";
         if(this._cutWidth == 0)
         {
            this.cutWidth = _display.width / 10;
         }
      }
      
      override public function setFrame(param1:int) : void
      {
         if(param1 > 10)
         {
            return;
         }
         _currentFrame = param1;
         if(param1 == 10)
         {
            param1 = 0;
         }
         ObjectUtils.disposeObject(this._image);
         var _loc2_:BitmapData = (_display as Bitmap).bitmapData;
         var _loc3_:Rectangle = new Rectangle(this._cutWidth * param1,0,this._cutWidth,_display.height);
         var _loc4_:BitmapData = new BitmapData(this._cutWidth,_display.height);
         _loc4_.copyPixels(_loc2_,_loc3_,new Point(0,0));
         this._image = new Bitmap(_loc4_);
         if(_width != Math.round(this._image.width))
         {
            _width = Math.round(this._image.width);
            _changedPropeties["width"] = true;
         }
         this.addChildren();
         fillRect();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._image);
         super.dispose();
      }
   }
}

