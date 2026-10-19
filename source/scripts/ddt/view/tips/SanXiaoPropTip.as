package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class SanXiaoPropTip extends Sprite implements ITransformableTip, Disposeable
   {
      
      private var _width:Number = 304;
      
      private var _height:Number = 82;
      
      private var _isDiscount:Boolean;
      
      private var _data:Object;
      
      private var _bg:ScaleBitmapImage;
      
      private var _detail:FilterFrameText;
      
      private var _cost:FilterFrameText;
      
      private var _discount:FilterFrameText;
      
      private var _separator:Image;
      
      public function SanXiaoPropTip()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.commonTipBg");
         addChild(this._bg);
         this._detail = ComponentFactory.Instance.creat("core.commonTipText");
         this._detail.multiline = true;
         this._detail.wordWrap = true;
         this._detail.width = this._width - 8;
         this._detail.x = 4;
         this._detail.y = 4;
         addChild(this._detail);
         this._cost = ComponentFactory.Instance.creat("core.GoodsTipItemTxt");
         this._cost.width = this._width - 8;
         this._cost.x = 4;
         this._cost.y = 60;
         addChild(this._cost);
      }
      
      public function get tipWidth() : int
      {
         return this._width;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return this._isDiscount ? int(this._height + 28) : int(Number(this._height));
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
      
      public function get tipData() : Object
      {
         return null;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._detail.text = param1.detail;
         this._cost.text = LanguageMgr.GetTranslation("sanxiao.propTipPrice",param1.price);
         this._cost.textColor = 16711935;
         this._isDiscount = param1.isDiscount;
         if(this._isDiscount)
         {
            this._separator || (this._separator = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset"));
            this._separator.x = 14;
            this._separator.y = 80;
            addChild(this._separator);
            this._discount || (this._discount = ComponentFactory.Instance.creat("core.redTxt"));
            this._discount.x = 4;
            this._discount.y = 82;
            this._discount.text = LanguageMgr.GetTranslation("sanxiao.propTipCurPrice",param1.curPrice);
            addChild(this._discount);
         }
         else
         {
            ObjectUtils.disposeObject(this._separator);
            ObjectUtils.disposeObject(this._discount);
         }
         this._bg.width = this.tipWidth;
         this._bg.height = this.tipHeight;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._detail);
         ObjectUtils.disposeObject(this._cost);
         ObjectUtils.disposeObject(this._separator);
         ObjectUtils.disposeObject(this._discount);
         this._bg = null;
         this._detail = null;
         this._separator = null;
         this._discount = null;
      }
   }
}

