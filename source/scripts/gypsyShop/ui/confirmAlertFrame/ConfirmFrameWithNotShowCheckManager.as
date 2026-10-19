package gypsyShop.ui.confirmAlertFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import gypsyShop.model.GypsyPurchaseModel;
   
   public class ConfirmFrameWithNotShowCheckManager
   {
      
      private var _confirmFrame:ConfirmWithNotShowCheckAlert;
      
      private var _frameType:String;
      
      private var _needMoney:int;
      
      private var _title:String = "";
      
      private var _detail:String = "";
      
      private var _onNotShowAgain:Function;
      
      private var _isBind:Function;
      
      private var _onComfirm:Function;
      
      public function ConfirmFrameWithNotShowCheckManager()
      {
         super();
      }
      
      public function set detail(param1:String) : void
      {
         this._detail = param1;
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
      }
      
      public function set frameType(param1:String) : void
      {
         this._frameType = param1;
      }
      
      public function set needMoney(param1:int) : void
      {
         this._needMoney = param1;
      }
      
      public function set onNotShowAgain(param1:Function) : void
      {
         this._onNotShowAgain = param1;
      }
      
      public function set isBind(param1:Function) : void
      {
         this._isBind = param1;
      }
      
      public function set onComfirm(param1:Function) : void
      {
         this._onComfirm = param1;
      }
      
      public function alert() : ConfirmWithNotShowCheckAlert
      {
         var _loc1_:ConfirmWithNotShowCheckAlert = AlertManager.Instance.simpleAlert(this._title,this._detail,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND,null,this._frameType,30,true,AlertManager.SELECTBTN) as ConfirmWithNotShowCheckAlert;
         _loc1_.moveEnable = false;
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
         return _loc1_;
      }
      
      private function comfirmHandler(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc3_:ConfirmWithNotShowCheckAlert = param1.currentTarget as ConfirmWithNotShowCheckAlert;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(_loc3_.isBand && PlayerManager.Instance.Self.BandMoney < this._needMoney)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.reConfirmHandler,false,0,true);
               return;
            }
            if(!_loc3_.isBand && PlayerManager.Instance.Self.Money < this._needMoney)
            {
               this._onNotShowAgain != null && this._onNotShowAgain(false);
               LeavePageManager.showFillFrame();
               return;
            }
            if(_loc3_.isNoPrompt)
            {
               this._onNotShowAgain != null && this._onNotShowAgain(true);
            }
            this._isBind != null && this._isBind(_loc3_.isBand);
            this._onComfirm != null && this._onComfirm();
         }
      }
      
      private function reConfirmHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._onNotShowAgain != null && this._onNotShowAgain(false);
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this._needMoney)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            GypsyPurchaseModel.getInstance().updateIsUseBindRmbTicket(false);
            this._onComfirm != null && this._onComfirm();
         }
      }
   }
}

