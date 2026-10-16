package foodActivity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class FoodActivityTip extends Sprite implements ITransformableTip, Disposeable
   {
      
      protected var _data:Object;
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _contentTxt:FilterFrameText;
      
      protected var _awardsTxt:FilterFrameText;
      
      public function FoodActivityTip()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
         this._awardsTxt = ComponentFactory.Instance.creatComponentByStylename("core.commonTipText");
         addChild(this._bg);
         addChild(this._contentTxt);
         addChild(this._awardsTxt);
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(param1:int) : void
      {
         if(this._tipWidth != param1)
         {
            this._tipWidth = param1;
            this.updateTransform();
         }
      }
      
      public function get tipData() : Object
      {
         return this._data;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._data = param1;
         this._contentTxt.text = this._data["content"];
         this._awardsTxt.text = this._data["awards"];
         this.updateTransform();
      }
      
      protected function updateTransform() : void
      {
         var _loc1_:int = this._contentTxt.width > this._awardsTxt.width ? int(this._contentTxt.width) : int(Number(this._awardsTxt.width));
         this._bg.width = _loc1_ + 16;
         this._bg.height = this._contentTxt.height + this._awardsTxt.height + 8;
         this._contentTxt.x = this._bg.x + 8;
         this._contentTxt.y = this._bg.y + 4;
         this._awardsTxt.x = this._contentTxt.x;
         this._awardsTxt.y = this._contentTxt.y + this._contentTxt.height;
      }
      
      public function get tipHeight() : int
      {
         return this._bg.height;
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._contentTxt);
         this._contentTxt = null;
         ObjectUtils.disposeObject(this._awardsTxt);
         this._awardsTxt = null;
         this._data = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

