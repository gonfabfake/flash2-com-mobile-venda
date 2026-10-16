package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.manager.VipIntegralShopManager;
   import ddt.utils.PositionUtils;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.VipInfoTipBox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import vip.VipController;
   
   public class GiveYourselfOpenView extends Sprite implements Disposeable
   {
      
      public static var vip_reward_arr:Array;
      
      public static const VIP_LEVEL1:String = "112112";
      
      public static const VIP_LEVEL2:String = "112113";
      
      public static const VIP_LEVEL3:String = "112114";
      
      public static const VIP_LEVEL4:String = "112115";
      
      public static const VIP_LEVEL5:String = "112116";
      
      public static const VIP_LEVEL6:String = "112117";
      
      public static const VIP_LEVEL7:String = "112118";
      
      public static const VIP_LEVEL8:String = "112119";
      
      public static const VIP_LEVEL9:String = "112120";
      
      public static const VIP_LEVEL10:String = "112204";
      
      public static const VIP_LEVEL11:String = "112205";
      
      public static const VIP_LEVEL12:String = "112206";
      
      public static var _vipChestsArr:Array = ["112112","112113","112114","112115","112116","112117","112118","112119","112120","112204","112205","112206"];
      
      public static var millisecondsPerDay:int = 86400000;
      
      private static const ONE_MONTH_PAY:int = ServerConfigManager.instance.VIPRenewalPrice[0];
      
      private static const THREE_MONTH_PAY:int = ServerConfigManager.instance.VIPRenewalPrice[1];
      
      private static const HALF_YEAR_PAY:int = ServerConfigManager.instance.VIPRenewalPrice[2];
      
      private static const VIP_VALIDITY:int = 24;
      
      private var _BG:MutipleImage;
      
      protected var _showPayMoneyBG:Image;
      
      protected var _openVipBtn:BaseButton;
      
      protected var _renewalVipBtn:BaseButton;
      
      protected var _rewardBtn:BaseButton;
      
      private var _rewardEffet:IEffect;
      
      protected var _money:FilterFrameText;
      
      protected var _isSelf:Boolean;
      
      private var _halfYearBtn:SelectedButton;
      
      private var _threeMonthBtn:SelectedButton;
      
      private var _oneMonthBtn:SelectedButton;
      
      protected var _vipPrivilegeTxt:VipPrivilegeTxt;
      
      private var _vipPrivilegeTxtBg:Image;
      
      private var _openVipTimeBtnGroup:SelectedButtonGroup;
      
      private var _selectedBtnImage:Image;
      
      public var discountCode:int;
      
      private var _halfYearTxt:FilterFrameText;
      
      private var _threeMonthTxt:FilterFrameText;
      
      private var _oneMonthTxt:FilterFrameText;
      
      private var awards:AwardsViewII;
      
      private var alertFrame:BaseAlerFrame;
      
      private var _vipInfoTipBox:VipInfoTipBox;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      protected var days:int = 0;
      
      protected var payNum:int = 0;
      
      protected var time:String = "";
      
      public function GiveYourselfOpenView(param1:int = 0)
      {
         super();
         this.discountCode = param1;
         this._init();
      }
      
      public static function getVipinfo() : Array
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         vip_reward_arr = [];
         _loc2_ = 0;
         while(_loc2_ < _vipChestsArr[_loc2_])
         {
            _loc1_ = ItemManager.Instance.getTemplateById(_vipChestsArr[_loc2_]);
            vip_reward_arr.push(_loc1_);
            _loc2_++;
         }
         return vip_reward_arr;
      }
      
      private function _init() : void
      {
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._isSelf = true;
         this.initContent();
         this.addTextAndBtn();
         this.upPayMoneyText();
         this.showOpenOrRenewal();
         this.rewardBtnCanUse();
      }
      
      private function initContent() : void
      {
         this._BG = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.BGI");
         this._halfYearBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.halfYearBtn");
         this._threeMonthBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.threeMonthBtn");
         this._oneMonthBtn = ComponentFactory.Instance.creatComponentByStylename("ddtvip.oneMonthBtn");
         this._halfYearTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.halfYearTxt");
         this._threeMonthTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.threeMonthTxt");
         this._oneMonthTxt = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.oneMonthTxt");
         this._halfYearTxt.htmlText = LanguageMgr.GetTranslation("ddt.vipView.halfYearDiscount",int(PlayerManager.Instance.vipPriceArr[2]) > 0 ? PlayerManager.Instance.vipPriceArr[2] : HALF_YEAR_PAY);
         this._threeMonthTxt.htmlText = LanguageMgr.GetTranslation("ddt.vipView.threeMonthDiscount",int(PlayerManager.Instance.vipPriceArr[1]) > 0 ? PlayerManager.Instance.vipPriceArr[1] : THREE_MONTH_PAY);
         this._oneMonthTxt.htmlText = LanguageMgr.GetTranslation("ddt.vipView.oneMonthDiscount",int(PlayerManager.Instance.vipPriceArr[0]) > 0 ? PlayerManager.Instance.vipPriceArr[0] : ONE_MONTH_PAY);
         this._vipPrivilegeTxtBg = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeTxtBg");
         this._vipPrivilegeTxt = ComponentFactory.Instance.creatCustomObject("vip.vipPrivilegeTxt");
         this._vipPrivilegeTxt.AlertContent = 6;
         this._selectedBtnImage = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.selectedBtnImage");
         addChild(this._BG);
         addChild(this._halfYearBtn);
         addChild(this._threeMonthBtn);
         addChild(this._oneMonthBtn);
         addChild(this._halfYearTxt);
         addChild(this._threeMonthTxt);
         addChild(this._oneMonthTxt);
         addChild(this._vipPrivilegeTxtBg);
         addChild(this._vipPrivilegeTxt);
         addChild(this._selectedBtnImage);
         this._openVipTimeBtnGroup = new SelectedButtonGroup();
         this._openVipTimeBtnGroup.addSelectItem(this._halfYearBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._threeMonthBtn);
         this._openVipTimeBtnGroup.addSelectItem(this._oneMonthBtn);
         this._openVipTimeBtnGroup.selectIndex = 0;
      }
      
      private function addTextAndBtn() : void
      {
         this._money = ComponentFactory.Instance.creat("GiveYourselfOpenView.money");
         this._openVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.openVipBtn");
         this._renewalVipBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.renewalVipBtn");
         this._rewardBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.rewardBtn");
         addChild(this._openVipBtn);
         addChild(this._renewalVipBtn);
         addChild(this._rewardBtn);
         this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
      }
      
      protected function showOpenOrRenewal() : void
      {
         if(this._isSelf)
         {
            if(PlayerManager.Instance.Self.VIPExp <= 0 && !PlayerManager.Instance.Self.IsVIP)
            {
               this._openVipBtn.visible = true;
               this._renewalVipBtn.visible = false;
            }
            else
            {
               this._openVipBtn.visible = false;
               this._renewalVipBtn.visible = true;
            }
         }
         else
         {
            this._openVipBtn.visible = true;
            this._renewalVipBtn.visible = false;
         }
      }
      
      protected function rewardBtnCanUse() : void
      {
         if(this._isSelf && PlayerManager.Instance.Self.IsVIP)
         {
            PositionUtils.setPos(this._openVipBtn,"vip.rewardState.OpenRenewalBtnPos");
            PositionUtils.setPos(this._renewalVipBtn,"vip.rewardState.OpenRenewalBtnPos");
         }
         else
         {
            PositionUtils.setPos(this._openVipBtn,"vip.normalState.OpenRenewalBtnPos");
            PositionUtils.setPos(this._renewalVipBtn,"vip.normalState.OpenRenewalBtnPos");
         }
      }
      
      private function initEvent() : void
      {
         this._openVipBtn.addEventListener("click",this.__openVip);
         this._renewalVipBtn.addEventListener("click",this.__openVip);
         this._openVipTimeBtnGroup.addEventListener("change",this.__upPayNum);
         this._rewardBtn.addEventListener("click",this.__reward);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__propertyChange);
      }
      
      private function removeEvent() : void
      {
         this._openVipBtn.removeEventListener("click",this.__openVip);
         this._renewalVipBtn.removeEventListener("click",this.__openVip);
         this._openVipTimeBtnGroup.removeEventListener("change",this.__upPayNum);
         this._rewardBtn.removeEventListener("click",this.__reward);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__propertyChange);
      }
      
      private function __reward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         VipIntegralShopManager.Instance.show();
      }
      
      private function __alertHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.alertFrame.removeEventListener("response",this.__alertHandler);
         if(Boolean(this.alertFrame) && Boolean(this.alertFrame.parent))
         {
            this.alertFrame.parent.removeChild(this.alertFrame);
         }
         if(Boolean(this.alertFrame))
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
      }
      
      private function __responseVipInfoTipHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._vipInfoTipBox.removeEventListener("response",this.__responseHandler);
         switch(param1.responseCode)
         {
            case 0:
            case 1:
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
               break;
            case 2:
               this.showAwards(this._vipInfoTipBox.selectCellInfo);
               this._vipInfoTipBox.dispose();
               this._vipInfoTipBox = null;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.awards.removeEventListener("response",this.__responseHandler);
         switch(param1.responseCode)
         {
            case 0:
            case 1:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function showAwards(param1:ItemTemplateInfo) : void
      {
         this.awards = ComponentFactory.Instance.creat("vip.awardFrame");
         this.awards.escEnable = true;
         this.awards.boxType = 2;
         this.awards.vipAwardGoodsList = this._getStrArr(BossBoxManager.instance.inventoryItemList);
         this.awards.addEventListener("_haveBtnClick",this.__sendReward);
         this.awards.addEventListener("response",this.__responseHandler);
         LayerManager.Instance.addToLayer(this.awards,3,true,1);
      }
      
      private function __sendReward(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener("_haveBtnClick",this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
         this.rewardBtnCanUse();
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["Money"]))
         {
            this._money.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("money");
         }
         if(Boolean(param1.changedProperties["isVip"]) || Boolean(param1.changedProperties["canTakeVipReward"]))
         {
            this.showOpenOrRenewal();
            this.rewardBtnCanUse();
         }
      }
      
      private function __upPayNum(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.upPayMoneyText();
      }
      
      protected function __openVip(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this.upPayMoneyText();
         var _loc3_:* = false;
         var _loc4_:int = PlayerManager.Instance.Self.vipDiscount;
         var _loc5_:Date = PlayerManager.Instance.Self.vipDiscountValidity;
         var _loc6_:Date = new Date(_loc5_.time);
         _loc6_["hours"] += 24;
         if(_loc5_ != null)
         {
            _loc2_ = TimeManager.Instance.Now().getTime();
            _loc3_ = _loc6_.getTime() >= _loc2_;
         }
         var _loc7_:int = this.payNum;
         var _loc8_:int = 0;
         if(_loc4_ > 0 && Boolean(_loc3_))
         {
            this.payNum = _loc7_ * _loc4_ / 10;
            _loc8_ = _loc7_ - this.payNum;
         }
         var _loc9_:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforSelf",this.time,this.payNum);
         if(_loc4_ > 0 && Boolean(_loc3_))
         {
            _loc9_ += "\n" + LanguageMgr.GetTranslation("ddt.vip.vipView.useVipCoupons.tipMsg",_loc8_);
         }
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc9_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,1,null,"SimpleAlert",30,true);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener("response",this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener("response",this.__moneyConfirmHandler);
         switch(param1.responseCode - 2)
         {
            case 0:
            case 1:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(Boolean(this._moneyConfirm.parent))
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode - 2)
         {
            case 0:
            case 1:
               this.sendVip();
               this.upVipDiscount();
               this.upPayMoneyText();
         }
         this._confirmFrame.removeEventListener("response",this.__confirm);
         this._confirmFrame.dispose();
         if(Boolean(this._confirmFrame.parent))
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      private function upVipDiscount() : void
      {
         PlayerManager.Instance.Self.vipDiscount = 0;
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
      
      protected function upPayMoneyText() : void
      {
         this.payNum = 0;
         this.time = "";
         switch(this._openVipTimeBtnGroup.selectIndex)
         {
            case 0:
               this.time = "6 meses";
               this._vipPrivilegeTxt.AlertContent = 6;
               this.payNum = PlayerManager.Instance.vipPriceArr[2] > 0 ? int(PlayerManager.Instance.vipPriceArr[2]) : HALF_YEAR_PAY;
               break;
            case 1:
               this.time = "3 meses";
               this._vipPrivilegeTxt.AlertContent = 4;
               this.payNum = PlayerManager.Instance.vipPriceArr[1] > 0 ? int(PlayerManager.Instance.vipPriceArr[1]) : THREE_MONTH_PAY;
               break;
            case 2:
               this.time = "1 meses";
               this._vipPrivilegeTxt.AlertContent = 1;
               this.payNum = PlayerManager.Instance.vipPriceArr[0] > 0 ? int(PlayerManager.Instance.vipPriceArr[0]) : ONE_MONTH_PAY;
         }
      }
      
      private function _getStrArr(param1:DictionaryData) : Array
      {
         return param1[_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function getVIPInfoTip(param1:DictionaryData) : Array
      {
         var _loc2_:* = null;
         return PlayerManager.Instance.Self.VIPLevel == 12 ? [ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 2])),ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]))] : [ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1])),ItemManager.Instance.getTemplateById(int(_vipChestsArr[PlayerManager.Instance.Self.VIPLevel]))];
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._halfYearBtn);
         this._halfYearBtn = null;
         ObjectUtils.disposeObject(this._threeMonthBtn);
         this._threeMonthBtn = null;
         ObjectUtils.disposeObject(this._oneMonthBtn);
         this._oneMonthBtn = null;
         ObjectUtils.disposeObject(this._halfYearTxt);
         this._halfYearTxt = null;
         ObjectUtils.disposeObject(this._threeMonthTxt);
         this._threeMonthTxt = null;
         ObjectUtils.disposeObject(this._oneMonthTxt);
         this._oneMonthTxt = null;
         ObjectUtils.disposeObject(this._vipPrivilegeTxt);
         this._vipPrivilegeTxt = null;
         ObjectUtils.disposeObject(this._vipPrivilegeTxtBg);
         this._vipPrivilegeTxtBg = null;
         ObjectUtils.disposeObject(this._selectedBtnImage);
         this._selectedBtnImage = null;
         if(Boolean(this._rewardEffet))
         {
            this._rewardEffet.dispose();
         }
         this._rewardEffet = null;
         if(Boolean(this._openVipBtn))
         {
            ObjectUtils.disposeObject(this._openVipBtn);
         }
         this._openVipBtn = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._money))
         {
            ObjectUtils.disposeObject(this._money);
         }
         this._money = null;
         if(Boolean(this._showPayMoneyBG))
         {
            ObjectUtils.disposeObject(this._showPayMoneyBG);
         }
         this._showPayMoneyBG = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(Boolean(this._moneyConfirm))
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
         if(Boolean(this._renewalVipBtn))
         {
            ObjectUtils.disposeObject(this._renewalVipBtn);
         }
         this._renewalVipBtn = null;
         if(Boolean(this._rewardBtn))
         {
            ObjectUtils.disposeObject(this._rewardBtn);
         }
         this._rewardBtn = null;
         if(Boolean(this.alertFrame))
         {
            this.alertFrame.dispose();
         }
         this.alertFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

