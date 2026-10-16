package bagAndInfo.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CharacterSecondProTxtTip extends CharacterPropTxtTip
   {
      
      private var _line1:Image;
      
      private var _line2:Image;
      
      public function CharacterSecondProTxtTip()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._line1))
         {
            addChild(this._line1);
         }
         if(Boolean(this._line2))
         {
            addChild(this._line2);
         }
      }
      
      override protected function init() : void
      {
         super.init();
         property_txt = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.secondProTips.titleName");
         this._line1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         addChild(this._line1);
         detail_txt = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.secondProTips.desc");
         this._line2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
         addChild(this._line2);
         _propertySourceTxt = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.secondProTips.conten");
      }
      
      override protected function propertySourceText(param1:String) : void
      {
         _propertySourceTxt.htmlText = param1;
         this.updateWH();
         this.updateWidth();
      }
      
      override protected function updateWH(param1:Boolean = false) : void
      {
         if(!_propertySourceTxt)
         {
            return;
         }
         this._line1.y = property_txt.y + property_txt.textHeight + 10;
         _propertySourceTxt.y = this._line1.y + 10;
         this._line2.y = _propertySourceTxt.y + _propertySourceTxt.textHeight + 10;
         detail_txt.y = this._line2.y + 10;
         if(detail_txt.y + detail_txt.height >= _oriH)
         {
            _bg.height = detail_txt.y + detail_txt.height + 8;
         }
         else
         {
            _bg.height = _oriH;
         }
         _height = _bg.height;
      }
      
      override protected function updateWidth() : void
      {
         if(_propertySourceTxt.x + _propertySourceTxt.width >= _oriW)
         {
            _bg.width = _propertySourceTxt.x + _propertySourceTxt.textWidth + 2;
         }
         else
         {
            _bg.width = _oriW;
         }
         _width = _bg.width;
         if(Boolean(this._line1) && Boolean(this._line2))
         {
            this._line1.width = this._line2.width = _width;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._line1);
         this._line1 = null;
         ObjectUtils.disposeObject(this._line2);
         this._line2 = null;
      }
   }
}

