package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import vip.VipController;
   
   public class VipGrowUpFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _titleBm:Bitmap;
      
      private var _halfYearBtn:SelectedButton;
      
      private var _threeMonthBtn:SelectedButton;
      
      private var _oneMonthBtn:SelectedButton;
      
      private var _openVipTimeBtnGroup:SelectedButtonGroup;
      
      private var _discountIcon:Image;
      
      private var _openVipTip1:FilterFrameText;
      
      private var _openVipTip2:FilterFrameText;
      
      private var _openVipBtn:BaseButton;
      
      protected var payNum:int = 0;
      
      protected var time:String = "";
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      protected var days:int = 0;
      
      public function VipGrowUpFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this._openVipTimeBtnGroup.selectIndex = 0;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.vipGrowUpFrame.bg");
         addToContent(this._bg);
         this._titleBm = ComponentFactory.Instance.creatBitmap("asset.vipGrowUpFrame.title");
         addToContent(this._titleBm);
         this._halfYearBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.halfYearBtn");
         addToContent(this._halfYearBtn);
         this._threeMonthBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.threeMonthBtn");
         addToContent(this._threeMonthBtn);
         this._oneMonthBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.oneMonthBtn");
         addToContent(this._oneMonthBtn);
         this._discountIcon = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.discountIcon");
         addToContent(this._discountIcon);
         this._openVipTimeBtnGroup = new SelectedButtonGroup();
         this._openVipTimeBtnGroup.addSelectItem(this._halfYearBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._threeMonthBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._oneMonthBtn);
         this._openVipTip1 = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.openVipTip1");
         this._openVipTip1.text = LanguageMgr.GetTranslation("vip.VipGrowUpFrame.openVipTipMsg",6);
         addToContent(this._openVipTip1);
         this._openVipTip2 = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.openVipTip2");
         this._openVipTip2.text = LanguageMgr.GetTranslation("vip.VipGrowUpFrame.openVipTipMsg",4);
         addToContent(this._openVipTip2);
         this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("vip.VipGrowUpFrame.OpenVipBtn");
         addToContent(this._openVipBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__frameEventHandler);
         this._openVipTimeBtnGroup.addEventListener("change",this.__upPayNum);
         this._openVipBtn.addEventListener("click",this.__openVipBtnClickHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__frameEventHandler);
         if(Boolean(this._openVipTimeBtnGroup))
         {
            this._openVipTimeBtnGroup.removeEventListener("change",this.__upPayNum);
         }
         if(Boolean(this._openVipBtn))
         {
            this._openVipBtn.removeEventListener("click",this.__openVipBtnClickHandler);
         }
      }
      
      private function __upPayNum(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.upPayMoneyText();
      }
      
      protected function upPayMoneyText() : void
      {
         this.payNum = 0;
         this.time = "";
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 0:
               this.payNum = ServerConfigManager.instance.VIPRenewalPrice[2];
               this.time = "6个月";
               break;
            case 1:
               this.payNum = ServerConfigManager.instance.VIPRenewalPrice[1];
               this.time = "3个月";
               break;
            case 2:
               this.payNum = ServerConfigManager.instance.VIPRenewalPrice[0];
               this.time = "1个月";
         }
      }
      
      private function __openVipBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforSelf",this.time,this.payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,1,null,"SimpleAlert",30,true);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener("response",this.__confirm);
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode - 2)
         {
            case 0:
            case 1:
               this.sendVip();
               this.upPayMoneyText();
         }
         this._confirmFrame.removeEventListener("response",this.__confirm);
         this._confirmFrame.dispose();
         if(Boolean(this._confirmFrame.parent))
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      protected function sendVip() : void
      {
         this.days = 0;
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 0:
               this.days = 180;
               break;
            case 1:
               this.days = 90;
               break;
            case 2:
               this.days = 30;
         }
         this.send();
      }
      
      protected function send() : void
      {
         VipController.instance.sendOpenVip(PlayerManager.Instance.Self.NickName,this.days,this._confirmFrame.isBand);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case 0:
            case 1:
               this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,2);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._bg = null;
         this._titleBm = null;
         this._openVipBtn = null;
         this._halfYearBtn = null;
         this._threeMonthBtn = null;
         this._oneMonthBtn = null;
         this._openVipTimeBtnGroup = null;
         this._discountIcon = null;
         this._openVipTip1 = null;
         this._openVipTip2 = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

