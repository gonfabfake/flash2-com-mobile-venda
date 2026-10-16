package Indiana.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.geom.Matrix;
   
   public class GradientBitmapText extends Component
   {
      
      private var _field:FilterFrameText;
      
      private var _bmp:Bitmap;
      
      private var currentMatix:Matrix;
      
      private var _graidenBmp:ScaleBitmapImage;
      
      public function GradientBitmapText()
      {
         super();
         this._graidenBmp = new ScaleBitmapImage();
         addChild(this._graidenBmp);
      }
      
      public function set FilterTxtStyle(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         if(Boolean(this._field))
         {
            removeChild(this._field);
            ObjectUtils.disposeObject(this._field);
            this._field = null;
         }
         this._field = ComponentFactory.Instance.creatComponentByStylename(param1);
         this._field.x = 0;
         this._field.y = 0;
         addChild(this._field);
      }
      
      public function set FontSize(param1:int) : void
      {
         var _loc2_:* = null;
         if(Boolean(this._field))
         {
            _loc2_ = this._field.defaultTextFormat;
            _loc2_.size = param1;
            this._field.defaultTextFormat = _loc2_;
         }
      }
      
      public function set BitMapStyle(param1:String) : void
      {
         if(param1 == "")
         {
            return;
         }
         if(Boolean(this._bmp))
         {
            this._bmp.bitmapData.dispose();
            this._bmp = null;
         }
         this._bmp = ComponentFactory.Instance.creatBitmap(param1);
      }
      
      public function setText(param1:String) : void
      {
         this._field.text = param1;
         this.render();
      }
      
      public function get textWidth() : Number
      {
         if(Boolean(this._field))
         {
            return this._field.textWidth;
         }
         return 0;
      }
      
      private function render() : void
      {
         this.drawBox();
         this._field.cacheAsBitmap = true;
         this._graidenBmp.cacheAsBitmap = true;
         this._graidenBmp.x = this._field.x;
         this._graidenBmp.y = this._field.y;
         this._graidenBmp.width = this._field.textWidth + 5;
         this._graidenBmp.height = this._field.textHeight + 5;
         this._graidenBmp.mask = this._field;
      }
      
      private function drawBox() : void
      {
         if(Boolean(this._bmp))
         {
            if(this._graidenBmp == null)
            {
               this._graidenBmp = new ScaleBitmapImage();
            }
            this._graidenBmp.resource = this._bmp.bitmapData;
            this._graidenBmp.scaleGridString = "6,6,55,44";
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._field))
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         if(Boolean(this._bmp))
         {
            ObjectUtils.disposeObject(this._bmp);
         }
         this._bmp = null;
         if(Boolean(this._graidenBmp))
         {
            ObjectUtils.disposeObject(this._graidenBmp);
         }
         this._graidenBmp = null;
         super.dispose();
      }
   }
}

