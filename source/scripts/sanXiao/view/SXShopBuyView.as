package sanXiao.view
{
   import ddt.command.QuickBuyAlertBase;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class SXShopBuyView extends QuickBuyAlertBase
   {
      
      private var _buyNum:int;
      
      private var _ShopID:int;
      
      public function SXShopBuyView()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         titleText = LanguageMgr.GetTranslation("store.view.shortcutBuy.exchangeBtn");
         _submitButton.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.exchangeBtn");
         _sprite.mouseEnabled = _sprite.mouseChildren = _sprite.visible = false;
         _totalTipText.text = LanguageMgr.GetTranslation("sanxiao.buyStore");
         _submitButton.y = 152;
         totalText.x = 283;
         totalText.y = 69;
      }
      
      override protected function refreshNumText() : void
      {
         var _loc1_:String = String(_number.number * _perPrice);
         totalText.text = _loc1_ + "\n\n" + this._buyNum;
      }
      
      override public function setData(param1:int, param2:int, param3:int) : void
      {
         super.setData(param1,param2,param3);
      }
      
      public function setID(param1:int) : void
      {
         this._ShopID = param1;
      }
      
      public function setBuyNum(param1:int) : void
      {
         this._buyNum = param1;
         this.refreshNumText();
         _number.maximum = this._buyNum;
         _submitButton.enable = this._buyNum > 0;
      }
      
      override protected function __buy(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         dispose();
         GameInSocketOut.sendSXBuyItem(this._ShopID,_number.number);
      }
   }
}

