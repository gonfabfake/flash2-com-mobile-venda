package magicHouse
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.DoubleSelectedItem;
   
   public class MagicHouseTipFrame extends Frame
   {
      
      private var _tipTxt:FilterFrameText;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _item:DoubleSelectedItem;
      
      public function MagicHouseTipFrame()
      {
         super();
         this.initView();
      }
      
      public function set item(param1:DoubleSelectedItem) : void
      {
         this._item = param1;
      }
      
      public function get item() : DoubleSelectedItem
      {
         return this._item;
      }
      
      private function initView() : void
      {
         this._tipTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.tipFrame.tipText");
         addToContent(this._tipTxt);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.chargeBoxframe.confirmBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         PositionUtils.setPos(this._okBtn,"magicHouse.tipFrame.OkBtnPos");
         addToContent(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.chargeBoxframe.cancleBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         PositionUtils.setPos(this._cancelBtn,"magicHouse.tipFrame.CancekBtnPos");
         addToContent(this._cancelBtn);
         this._item = new DoubleSelectedItem();
         this._item.x = 144;
         this._item.y = 107;
      }
      
      public function get okBtn() : TextButton
      {
         return this._okBtn;
      }
      
      public function get cancelBtn() : TextButton
      {
         return this._cancelBtn;
      }
      
      public function setTipText(param1:String) : void
      {
         this._tipTxt.text = param1;
      }
      
      public function setTipHtmlText(param1:String) : void
      {
         this._tipTxt.htmlText = param1;
      }
      
      public function setFrameWidth(param1:int) : void
      {
         this.width = param1;
      }
      
      public function setFrameHeight(param1:int) : void
      {
         this.height = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

