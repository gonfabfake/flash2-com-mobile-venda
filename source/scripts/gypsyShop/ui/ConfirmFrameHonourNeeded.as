package gypsyShop.ui
{
   import ddt.manager.LanguageMgr;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyPurchaseModel;
   import gypsyShop.ui.confirmAlertFrame.ConfirmFrameHonourWithNotShowCheckManager;
   
   public class ConfirmFrameHonourNeeded
   {
      
      private var _confirmFrameMngr:ConfirmFrameHonourWithNotShowCheckManager;
      
      public function ConfirmFrameHonourNeeded()
      {
         super();
         this._confirmFrameMngr = new ConfirmFrameHonourWithNotShowCheckManager();
      }
      
      public function alert() : void
      {
         var _loc1_:String = LanguageMgr.GetTranslation("tank.game.GameView.gypsyHonourConfirm",this.getPrice());
         var _loc2_:String = LanguageMgr.GetTranslation("AlertDialog.Info");
         var _loc3_:String = "SimpleAlert";
         this._confirmFrameMngr.detail = _loc1_;
         this._confirmFrameMngr.title = _loc2_;
         this._confirmFrameMngr.frameType = _loc3_;
         this._confirmFrameMngr.needMoney = this.getPrice();
         this._confirmFrameMngr.onComfirm = this.onConfirm;
         this._confirmFrameMngr.onNotShowAgain = this.onNotShowAgain;
         this._confirmFrameMngr.onComfirm = GypsyShopManager.getInstance().confirmToRefresh;
         this._confirmFrameMngr.isBind = this.isBind;
         this._confirmFrameMngr.alert();
      }
      
      protected function onNotShowAgain(param1:Boolean) : void
      {
         GypsyPurchaseModel.getInstance().updateShowAlertHonourRefresh(!param1);
      }
      
      protected function isBind(param1:Boolean) : void
      {
      }
      
      protected function onConfirm() : void
      {
         GypsyShopManager.getInstance().confirmToRefresh();
      }
      
      protected function getPrice() : int
      {
         return GypsyPurchaseModel.getInstance().getHonourNeeded();
      }
   }
}

