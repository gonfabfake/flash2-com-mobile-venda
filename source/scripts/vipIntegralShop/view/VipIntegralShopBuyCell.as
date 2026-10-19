package vipIntegralShop.view
{
   import ddt.command.QuickBuyAlertBase;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   
   public class VipIntegralShopBuyCell extends QuickBuyAlertBase
   {
      
      private var _buyNum:int;
      
      public function VipIntegralShopBuyCell()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         _sprite.mouseEnabled = _sprite.mouseChildren = _sprite.visible = false;
         _totalTipText.text = LanguageMgr.GetTranslation("vipIntegralShopView.todayBuyText");
         _totalTipText.x = 34;
         totalText.x = 259;
         totalText.y = 70;
         _submitButton.x = 124;
         _submitButton.y = 152;
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
      
      public function setBuyNum(param1:int) : void
      {
         this._buyNum = param1;
         this.refreshNumText();
         _number.maximum = this._buyNum;
      }
      
      override protected function __buy(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         dispose();
         SocketManager.Instance.out.buyVipIntegralShopGoods(_shopGoodsId,_number.number);
      }
   }
}

