package moneyTree.ui
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.SimpleAlert;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.DisplayUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import moneyTree.MoneyTreeManager;
   
   public class MoneyTreeRmbConfirmAlert extends SimpleAlert
   {
      
      private var _scb:SelectedCheckButton;
      
      private var _selectGroup:SelectedButtonGroup;
      
      private var vBox:VBox;
      
      private var radio1Times:SelectedCheckButton;
      
      private var radioToGrown:SelectedCheckButton;
      
      private var _txt1TimesCommon:String;
      
      private var _txt1TimesSelected:String;
      
      private var _txtToGrownCommon:String;
      
      private var _txtToGrownSelected:String;
      
      private var msg:String;
      
      public function MoneyTreeRmbConfirmAlert()
      {
         super();
         this._txt1TimesCommon = LanguageMgr.GetTranslation("renshen.su1time.cmn");
         this._txt1TimesSelected = LanguageMgr.GetTranslation("renshen.su1time.slct");
         this._txtToGrownCommon = LanguageMgr.GetTranslation("renshen.sutogrown.cmn");
         this._txtToGrownSelected = LanguageMgr.GetTranslation("renshen.sutogrown.cmn");
      }
      
      public function get isNoPrompt() : Boolean
      {
         return this._scb.selected;
      }
      
      public function get type() : int
      {
         return this._selectGroup.selectIndex;
      }
      
      override public function set info(param1:AlertInfo) : void
      {
         this.msg = param1.data as String;
         super.info = param1;
         this._selectGroup = new SelectedButtonGroup();
         this.radio1Times = ComponentFactory.Instance.creatComponentByStylename("moneytree.CartItemSelectBtn");
         this.radio1Times.addEventListener("click",this.__radioClick);
         this.radio1Times.text = this._txt1TimesSelected;
         this.radioToGrown = ComponentFactory.Instance.creatComponentByStylename("moneytree.CartItemSelectBtn");
         this.radioToGrown.addEventListener("click",this.__radioClick);
         this.radioToGrown.text = this._txtToGrownCommon;
         this._selectGroup.addSelectItem(this.radio1Times);
         this._selectGroup.addSelectItem(this.radioToGrown);
         this._selectGroup.selectIndex = 0;
         this.vBox = new VBox();
         this.vBox.x = 32;
         this.vBox.y = 69;
         this.vBox.addChild(this.radio1Times);
         this.vBox.addChild(this.radioToGrown);
         this.vBox.arrange();
         this.vBox.x = 20;
         this.vBox.height = 40;
         addToContent(this.vBox);
         this._scb = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
         addToContent(this._scb);
         this._scb.text = LanguageMgr.GetTranslation("ddt.consortiaBattle.buyConfirm.noAlertTxt");
         this._scb.x = 66;
         this._scb.y = 124;
         _textField.x = 46;
         _textField.y = 68;
      }
      
      protected function __radioClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.target)
         {
            case this.radio1Times:
               this.msg = MoneyTreeManager.getInstance().getCurSpeedUpOnce();
               this.radio1Times.text = this._txt1TimesSelected;
               this.radioToGrown.text = this._txtToGrownCommon;
               break;
            case this.radioToGrown:
               this.msg = MoneyTreeManager.getInstance().getCurSpeedUpToMature();
               this.radio1Times.text = this._txt1TimesCommon;
               this.radioToGrown.text = LanguageMgr.GetTranslation("renshen.sutogrown.slct",MoneyTreeManager.getInstance().onSpeedUpTypeSelected());
         }
         this.updateMsg();
      }
      
      override protected function updateMsg() : void
      {
         _textField.autoSize = "left";
         if(_info.mutiline)
         {
            _textField.multiline = true;
            if(!info.enableHtml)
            {
               _textField.wordWrap = true;
            }
            if(_info.textShowWidth > 0)
            {
               _textField.width = _info.textShowWidth;
            }
            else
            {
               _textField.width = DisplayUtils.getTextFieldMaxLineWidth(String(this.msg),_textField.defaultTextFormat,info.enableHtml);
            }
         }
         if(_info.enableHtml)
         {
            _textField.htmlText = String(this.msg);
         }
         else
         {
            _textField.text = String(this.msg);
         }
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         if(!_seleContent)
         {
            return;
         }
         _backgound.width = Math.max(_width,_seleContent.width + 14);
         _backgound.height = _height + 40;
         _submitButton.y += 40;
         _cancelButton.y += 40;
      }
   }
}

