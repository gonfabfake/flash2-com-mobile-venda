package Indiana.item
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class AttributeItem extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _txt:FilterFrameText;
      
      public function AttributeItem(param1:String = "indiana.attribute.Txt")
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("indiana.attribute.bg");
         this._txt = ComponentFactory.Instance.creatComponentByStylename(param1);
         this._txt.x = 4;
         this._txt.y = 1;
         addChild(this._bg);
         addChild(this._txt);
      }
      
      public function setWidth(param1:int) : void
      {
         if(Boolean(this._bg))
         {
            this._bg.width = param1;
         }
      }
      
      public function setView(param1:DisplayObject) : void
      {
         if(Boolean(param1))
         {
            addChild(param1);
         }
      }
      
      override public function get width() : Number
      {
         return 24;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      public function set fontColor(param1:int) : void
      {
         var _loc2_:* = null;
         if(Boolean(this._txt))
         {
            _loc2_ = this._txt.defaultTextFormat;
            _loc2_.color = param1;
            this._txt.defaultTextFormat = _loc2_;
         }
      }
      
      public function set Filter(param1:Array) : void
      {
         var _loc2_:* = null;
         if(Boolean(this._txt))
         {
            _loc2_ = this._txt.defaultTextFormat;
            this._txt.filters = param1;
         }
      }
      
      public function get textField() : FilterFrameText
      {
         return this._txt;
      }
      
      public function setDis(param1:String) : void
      {
         if(Boolean(this._txt))
         {
            this._txt.text = param1;
         }
         this._bg.width = this._txt.textWidth + 10;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._txt = null;
      }
   }
}

