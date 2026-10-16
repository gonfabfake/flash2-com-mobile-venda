package gypsyShop.ui
{
   import ddt.manager.LanguageMgr;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyPurchaseModel;
   import gypsyShop.ui.confirmAlertFrame.ConfirmFrameWithNotShowCheckManager;
   
   public class ConfirmFrameMoneyNeeded
   {
      
      private var _confirmFrameMngr:ConfirmFrameWithNotShowCheckManager;
      
      private var _id:int;
      
      public function ConfirmFrameMoneyNeeded()
      {
         super();
         this._confirmFrameMngr = new ConfirmFrameWithNotShowCheckManager();
      }
      
      public function setID(param1:int) : void
      {
         this._id = param1;
      }
      
      public function alert() : void
      {
         var _loc1_:String = LanguageMgr.GetTranslation("tank.game.GameView.gypsyRMBTicketConfirm",this.getPrice());
         var _loc2_:String = LanguageMgr.GetTranslation("AlertDialog.Info");
         var _loc3_:String = "gypsy.confirmView";
         this._confirmFrameMngr.detail = _loc1_;
         this._confirmFrameMngr.title = _loc2_;
         this._confirmFrameMngr.frameType = _loc3_;
         this._confirmFrameMngr.needMoney = this.getPrice();
         this._confirmFrameMngr.onNotShowAgain = this.onNotShowAgain;
         this._confirmFrameMngr.onComfirm = this.onConfirm;
         this._confirmFrameMngr.isBind = this.isBind;
         this._confirmFrameMngr.alert();
      }
      
      protected function onNotShowAgain(param1:Boolean) : void
      {
         GypsyPurchaseModel.getInstance().updateShowAlertRmbTicketBuy(!param1);
      }
      
      protected function isBind(param1:Boolean) : void
      {
         GypsyPurchaseModel.getInstance().updateIsUseBindRmbTicket(param1);
      }
      
      protected function onConfirm() : void
      {
         GypsyShopManager.getInstance().confirmToBuy(this._id);
      }
      
      public function getPrice() : int
      {
         return GypsyPurchaseModel.getInstance().getRmbTicketNeeded(this._id);
      }
   }
}

