package gypsyShop.ui.confirmAlertFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   
   public class ConfirmFrameHonourWithNotShowCheckManager
   {
      
      private var _confirmFrame:ConfirmWithNotShowCheckAlert;
      
      private var _frameType:String;
      
      private var _needMoney:int;
      
      private var _title:String = "";
      
      private var _detail:String = "";
      
      private var _onNotShowAgain:Function;
      
      private var _isBind:Function;
      
      private var _onComfirm:Function;
      
      public function ConfirmFrameHonourWithNotShowCheckManager()
      {
         super();
      }
      
      protected static function showFillFrame() : BaseAlerFrame
      {
         var _loc1_:BaseAlerFrame = null;
         _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("gypsy.honourNotEnough"),LanguageMgr.GetTranslation("ok"),"",true,false,false,2);
         _loc1_.addEventListener(FrameEvent.RESPONSE,__onResponse);
         return _loc1_;
      }
      
      private static function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,__onResponse);
         _loc2_.dispose();
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
      
      public function alert() : ConfirmFrameHonourWithNotShowCheckAlert
      {
         if(PlayerManager.Instance.Self.myHonor < this._needMoney)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.honourNotEnough"),0,true,3);
            return null;
         }
         var _loc1_:ConfirmFrameHonourWithNotShowCheckAlert = ComponentFactory.Instance.creat("gypsy.confirmViewHonour");
         _loc1_.titleTxt = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc1_.detail = LanguageMgr.GetTranslation("tank.game.GameView.gypsyHonourConfirm",this._needMoney);
         _loc1_.onNotShowAgain = this._onNotShowAgain;
         _loc1_.onComfirm = this._onComfirm;
         _loc1_.initView();
         _loc1_.moveEnable = false;
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         return _loc1_;
      }
      
      private function comfirmHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ConfirmFrameHonourWithNotShowCheckAlert = param1.currentTarget as ConfirmFrameHonourWithNotShowCheckAlert;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(PlayerManager.Instance.Self.myHonor < this._needMoney)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.honourNotEnough"),0,true,3);
            }
            else
            {
               this._onComfirm != null && this._onComfirm();
            }
            if(_loc2_.isNoPrompt)
            {
               this._onNotShowAgain != null && this._onNotShowAgain(true);
            }
         }
      }
   }
}

