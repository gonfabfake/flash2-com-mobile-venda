package vip.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.OpitionEnum;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.VipLevelIcon;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import vip.VipController;
   
   public class VipFrameHead extends Sprite implements Disposeable
   {
      
      private static var eachLevelEXP:Array = [0,150,350,700,1250,2050,3050,4250,5650];
      
      private var _topBG:DisplayObject;
      
      private var _selfName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _ClockImg:Bitmap;
      
      private var _dueTime:FilterFrameText;
      
      private var _vipLevelProgress:VipLevelProgress;
      
      private var _noticeOnVip12LoginSelectedBtn:SelectedButton;
      
      private var _noticeOnVip12LoginText:FilterFrameText;
      
      private var _vipHelpBtn:TextButton;
      
      private var _vipRuleDescriptionBtn:TextButton;
      
      private var _selfLevel:FilterFrameText;
      
      private var _nextLevel:FilterFrameText;
      
      private var _dueDataWord:FilterFrameText;
      
      private var _dueData:FilterFrameText;
      
      private var _DueTipSprite:Sprite;
      
      private var _DueTip:OneLineTip;
      
      private var _portrait:PlayerPortraitView;
      
      private var _isVipRechargeShow:Boolean = false;
      
      private var _isShowReward:Boolean = false;
      
      private var _descriptionFrame:Frame;
      
      private var _frameBg:Scale9CornerImage;
      
      private var _okBtn:TextButton;
      
      private var _contenttxt:MovieImage;
      
      private var _attestBtn:ScaleFrameImage;
      
      private var _getIntegralBtn:BaseButton;
      
      private var _helpFrame:VIPHelpFrame;
      
      public function VipFrameHead(param1:Boolean = false, param2:Boolean = true)
      {
         super();
         this._isVipRechargeShow = param1;
         this._isShowReward = param2;
         this.init();
      }
      
      private function init() : void
      {
         if(this._isVipRechargeShow)
         {
            this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topReChargeBG");
         }
         else
         {
            this._topBG = ComponentFactory.Instance.creatComponentByStylename("VIPFrame.topBG");
         }
         this._selfName = ComponentFactory.Instance.creat("VipStatusView.name");
         this._vipIcon = ComponentFactory.Instance.creatCustomObject("VipStatusView.vipIcon");
         this._ClockImg = ComponentFactory.Instance.creatBitmap("asset.vip.timeBitmap");
         this._dueTime = ComponentFactory.Instance.creat("VIPFrame.dueTime");
         this._vipLevelProgress = ComponentFactory.Instance.creat("VIPFrame.vipLevelProgress");
         if(!this._isVipRechargeShow)
         {
            this._dueDataWord = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.dueDateFontTxt");
            this._dueDataWord.text = LanguageMgr.GetTranslation("ddt.vip.dueDateFontTxt");
            this._dueData = ComponentFactory.Instance.creat("VipStatusView.dueDate");
            this._vipHelpBtn = ComponentFactory.Instance.creatComponentByStylename("VipStatusView.vipHelp");
            this._vipHelpBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipHelpBtn");
            this._vipRuleDescriptionBtn = ComponentFactory.Instance.creatComponentByStylename("vipHead.RuleDescriptionBtn");
            this._vipRuleDescriptionBtn.text = LanguageMgr.GetTranslation("ddt.vip.vipFrameHead.VipPrivilegeTxt");
         }
         if(PlayerManager.Instance.Self.VIPLevel >= 12 && PlayerManager.Instance.Self.IsVIP)
         {
            this._noticeOnVip12LoginSelectedBtn = ComponentFactory.Instance.creat("ddtvip.NoticeVip12LoginCheckBtn");
            this._noticeOnVip12LoginSelectedBtn.selected = true;
            this._noticeOnVip12LoginText = ComponentFactory.Instance.creat("ddtvip.UnselectText");
            if(PlayerManager.Instance.Self.VIPLevel >= 14)
            {
               this._noticeOnVip12LoginText.text = LanguageMgr.GetTranslation("ddt.vip.vip14notice");
            }
            else
            {
               this._noticeOnVip12LoginText.text = LanguageMgr.GetTranslation("ddt.vip.vip12notice");
            }
         }
         this._selfLevel = ComponentFactory.Instance.creat("VipStatusView.selfLevel");
         this._nextLevel = ComponentFactory.Instance.creat("VipStatusView.nextLevel");
         this._portrait = ComponentFactory.Instance.creatCustomObject("vip.PortraitView",["right"]);
         this._portrait.info = PlayerManager.Instance.Self;
         addChild(this._topBG);
         addChild(this._portrait);
         addChild(this._vipLevelProgress);
         if(Boolean(this._noticeOnVip12LoginSelectedBtn))
         {
            addChildAt(this._noticeOnVip12LoginSelectedBtn,1);
         }
         if(Boolean(this._noticeOnVip12LoginText))
         {
            addChildAt(this._noticeOnVip12LoginText,1);
         }
         if(!this._isVipRechargeShow)
         {
            addChild(this._vipRuleDescriptionBtn);
            addChild(this._dueDataWord);
            addChild(this._dueData);
         }
         addChild(this._selfLevel);
         this.addTipSprite();
         this.upView();
         this.creatGetIntegralBtn();
         this.addEvent();
      }
      
      private function creatGetIntegralBtn() : void
      {
         var _loc1_:int = 0;
         if(this._isShowReward)
         {
            this._getIntegralBtn = ComponentFactory.Instance.creatComponentByStylename("vip.getIntegralBtn");
            _loc1_ = this._portrait.info.VIPLevel;
            if(_loc1_ >= 15)
            {
               this._getIntegralBtn.tipData = LanguageMgr.GetTranslation("vipIntegralShopView.getReward.tipsText2",ServerConfigManager.instance.getVipIntegral()[_loc1_ - 1]);
            }
            else
            {
               this._getIntegralBtn.tipData = LanguageMgr.GetTranslation("vipIntegralShopView.getReward.tipsText1",ServerConfigManager.instance.getVipIntegral()[_loc1_ - 1],ServerConfigManager.instance.getVipIntegral()[_loc1_]);
            }
            addChild(this._getIntegralBtn);
            this._getIntegralBtn.enable = PlayerManager.Instance.Self.canTakeVipReward;
         }
      }
      
      private function addTipSprite() : void
      {
         this._DueTipSprite = new Sprite();
         this._DueTipSprite.graphics.beginFill(0,0);
         this._DueTipSprite.graphics.drawRect(0,0,this._vipLevelProgress.width,this._vipLevelProgress.height);
         this._DueTipSprite.graphics.endFill();
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("Vip.DueTipSpritePos");
         this._DueTipSprite.x = _loc1_.x;
         this._DueTipSprite.y = _loc1_.y;
         addChild(this._DueTipSprite);
         this._DueTip = new OneLineTip();
         addChild(this._DueTip);
         this._DueTip.x = this._DueTipSprite.x;
         this._DueTip.y = this._DueTipSprite.y + 37;
         this._DueTip.visible = false;
      }
      
      private function addEvent() : void
      {
         PlayerManager.Instance.addEventListener("VIPStateChange",this.vipStateChange);
         this._noticeOnVip12LoginSelectedBtn && this._noticeOnVip12LoginSelectedBtn.addEventListener("select",this.onSelectedChange);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__propertyChange);
         if(Boolean(this._vipHelpBtn))
         {
            this._vipHelpBtn.addEventListener("click",this.__showHelpFrame);
         }
         if(Boolean(this._vipRuleDescriptionBtn))
         {
            this._vipRuleDescriptionBtn.addEventListener("click",this.__helpHandler);
         }
         this._DueTipSprite.addEventListener("mouseOver",this.__showDueTip);
         this._DueTipSprite.addEventListener("mouseOut",this.__hideDueTip);
         if(this._getIntegralBtn != null)
         {
            this._getIntegralBtn.addEventListener("click",this.__onGetIntegralClick);
         }
      }
      
      protected function __onGetIntegralClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("vipIntegralShopView.getReward.tipsText3",ServerConfigManager.instance.getVipIntegral()[this._portrait.info.VIPLevel - 1]));
         SocketManager.Instance.out.sendDailyAward(3);
         PlayerManager.Instance.Self.canTakeVipReward = false;
         this._getIntegralBtn.enable = false;
      }
      
      protected function onSelectedChange(param1:Event) : void
      {
      }
      
      private function __helpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._descriptionFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipPrivilegeFrame");
         LayerManager.Instance.addToLayer(this._descriptionFrame,3,true,2);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this.disposeHelpFrame();
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function disposeHelpFrame() : void
      {
         this._okBtn.removeEventListener("click",this.__closeHelpFrame);
         this._descriptionFrame.dispose();
         this._okBtn = null;
         this._contenttxt = null;
         this._descriptionFrame = null;
      }
      
      private function removeEvent() : void
      {
         PlayerManager.Instance.removeEventListener("VIPStateChange",this.vipStateChange);
         this._noticeOnVip12LoginSelectedBtn && this._noticeOnVip12LoginSelectedBtn.removeEventListener("select",this.onSelectedChange);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__propertyChange);
         if(Boolean(this._vipHelpBtn))
         {
            this._vipHelpBtn.removeEventListener("click",this.__showHelpFrame);
         }
         if(Boolean(this._DueTipSprite))
         {
            this._DueTipSprite.removeEventListener("mouseOver",this.__showDueTip);
            this._DueTipSprite.removeEventListener("mouseOut",this.__hideDueTip);
         }
         if(this._getIntegralBtn != null)
         {
            this._getIntegralBtn.removeEventListener("click",this.__onGetIntegralClick);
         }
      }
      
      protected function vipStateChange(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.IsVIP)
         {
            if(PlayerManager.Instance.Self.VIPLevel == 12)
            {
               if(!this._noticeOnVip12LoginSelectedBtn)
               {
                  this._noticeOnVip12LoginSelectedBtn = ComponentFactory.Instance.creat("ddtvip.NoticeVip12LoginCheckBtn");
                  this._noticeOnVip12LoginSelectedBtn.selected = true;
                  this._noticeOnVip12LoginText = ComponentFactory.Instance.creat("ddtvip.UnselectText");
                  this._noticeOnVip12LoginText.text = LanguageMgr.GetTranslation("ddt.vip.vip12notice");
                  addChildAt(this._noticeOnVip12LoginSelectedBtn,1);
                  addChildAt(this._noticeOnVip12LoginText,1);
                  this._noticeOnVip12LoginSelectedBtn.addEventListener("select",this.onSelectedChange);
               }
            }
            if(this._getIntegralBtn != null)
            {
               this._getIntegralBtn.enable = PlayerManager.Instance.Self.canTakeVipReward;
            }
         }
      }
      
      private function __showDueTip(param1:MouseEvent) : void
      {
         this._DueTip.visible = true;
      }
      
      private function __hideDueTip(param1:MouseEvent) : void
      {
         this._DueTip.visible = false;
      }
      
      private function __showHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("vip.viphelpFrame");
         this._helpFrame.show();
         this._helpFrame.addEventListener("response",this.__responseHandler);
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         this._helpFrame.removeEventListener("response",this.__responseHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case 0:
            case 1:
               this._helpFrame.dispose();
               this._helpFrame = null;
         }
      }
      
      private function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["isVip"]) || Boolean(param1.changedProperties["VipExpireDay"]) || Boolean(param1.changedProperties["VIPNextLevelDaysNeeded"]))
         {
            this._portrait.info = PlayerManager.Instance.Self;
            this.upView();
         }
      }
      
      private function upView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(this._portrait.info.VIPLevel != 15 && this._portrait.info.IsVIP)
         {
            _loc1_ = Number(ServerConfigManager.instance.VIPExpNeededForEachLv[this._portrait.info.VIPLevel]) - this._portrait.info.VIPExp;
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.dueTime.tip",_loc1_,this._portrait.info.VIPLevel + 1);
         }
         else if(!this._portrait.info.IsVIP)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.reduceVipExp");
         }
         else
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipIcon.upGradFull");
         }
         if(!this._portrait.info.IsVIP && this._portrait.info.VIPExp <= 0)
         {
            this._DueTip.tipData = LanguageMgr.GetTranslation("ddt.vip.vipFrame.youarenovip");
         }
         this._selfName.text = this._portrait.info.NickName;
         if(this._portrait.info.IsVIP)
         {
            if(Boolean(this._vipName))
            {
               ObjectUtils.disposeObject(this._vipName);
            }
            this._vipName = VipController.instance.getVipNameTxt(263,this._portrait.info.typeVIP);
            this._vipName.textSize = 18;
            this._vipName.x = this._selfName.x;
            this._vipName.y = this._selfName.y;
            this._vipName.text = this._selfName.text;
            addChild(this._vipName);
            DisplayUtils.removeDisplay(this._selfName);
         }
         else
         {
            addChild(this._selfName);
            DisplayUtils.removeDisplay(this._vipName);
         }
         this._vipIcon.setInfo(this._portrait.info,true,true);
         if(this._portrait.info.IsVIP)
         {
            this._vipIcon.x = this._vipName.x + this._vipName.textWidth + 15;
         }
         else
         {
            this._vipIcon.x = this._selfName.x + this._selfName.textWidth + 15;
         }
         addChild(this._vipIcon);
         this._selfLevel.text = "LV:" + this._portrait.info.VIPLevel;
         this._nextLevel.text = "LV:" + (this._portrait.info.VIPLevel + 1);
         if(!this._isVipRechargeShow)
         {
            _loc2_ = PlayerManager.Instance.Self.VIPExpireDay as Date;
            this._dueData.text = _loc2_.fullYear + "-" + (_loc2_.month + 1) + "-" + _loc2_.date;
         }
         if(!this._portrait.info.IsVIP && !this._isVipRechargeShow)
         {
            this._dueData.text = "";
         }
         if(this._portrait.info.VIPLevel == 15)
         {
            this._nextLevel.text = "";
         }
         if(!this._portrait.info.IsVIP && this._portrait.info.VIPExp <= 0)
         {
            this._dueTime.text = 0 + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         }
         else
         {
            this._dueTime.text = PlayerManager.Instance.Self.VIPNextLevelDaysNeeded + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = this._portrait.info.VIPLevel;
         if(this._portrait.info.VIPLevel == 15)
         {
            _loc3_ = Number(ServerConfigManager.instance.VIPExpNeededForEachLv[11]) - Number(ServerConfigManager.instance.VIPExpNeededForEachLv[10]);
            this._vipLevelProgress.setProgress(1,1);
            this._vipLevelProgress.labelText = _loc3_ + "/" + _loc3_;
         }
         else
         {
            _loc4_ = this._portrait.info.VIPExp - Number(ServerConfigManager.instance.VIPExpNeededForEachLv[_loc6_ - 1]);
            _loc5_ = Number(ServerConfigManager.instance.VIPExpNeededForEachLv[_loc6_]) - Number(ServerConfigManager.instance.VIPExpNeededForEachLv[_loc6_ - 1]);
            this._vipLevelProgress.setProgress(_loc4_,_loc5_);
            this._vipLevelProgress.labelText = _loc4_ + "/" + _loc5_;
         }
         this.grayOrLightVIP();
         if(this._getIntegralBtn != null)
         {
            this._getIntegralBtn.enable = PlayerManager.Instance.Self.canTakeVipReward;
         }
      }
      
      private function grayOrLightVIP() : void
      {
         if(!this._portrait.info.IsVIP)
         {
            this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._vipLevelProgress.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._vipIcon.filters = null;
            this._vipLevelProgress.filters = null;
         }
      }
      
      public function dispose() : void
      {
         if(this._noticeOnVip12LoginSelectedBtn != null)
         {
            PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(!this._noticeOnVip12LoginSelectedBtn.selected,256);
            SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
            ObjectUtils.disposeObject(this._noticeOnVip12LoginSelectedBtn);
            this._noticeOnVip12LoginSelectedBtn = null;
         }
         this.removeEvent();
         if(Boolean(this._topBG))
         {
            ObjectUtils.disposeObject(this._topBG);
         }
         this._topBG = null;
         if(Boolean(this._vipIcon))
         {
            ObjectUtils.disposeObject(this._vipIcon);
         }
         this._vipIcon = null;
         if(Boolean(this._ClockImg))
         {
            ObjectUtils.disposeObject(this._ClockImg);
         }
         this._ClockImg = null;
         if(Boolean(this._dueTime))
         {
            ObjectUtils.disposeObject(this._dueTime);
         }
         this._dueTime = null;
         if(Boolean(this._vipLevelProgress))
         {
            ObjectUtils.disposeObject(this._vipLevelProgress);
         }
         this._vipLevelProgress = null;
         if(Boolean(this._noticeOnVip12LoginText))
         {
            ObjectUtils.disposeObject(this._noticeOnVip12LoginText);
         }
         this._noticeOnVip12LoginText = null;
         if(Boolean(this._vipHelpBtn))
         {
            ObjectUtils.disposeObject(this._vipHelpBtn);
            this._vipHelpBtn = null;
         }
         if(Boolean(this._selfLevel))
         {
            ObjectUtils.disposeObject(this._selfLevel);
         }
         this._selfLevel = null;
         if(Boolean(this._nextLevel))
         {
            ObjectUtils.disposeObject(this._nextLevel);
         }
         this._nextLevel = null;
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(this._DueTipSprite))
         {
            ObjectUtils.disposeObject(this._DueTipSprite);
         }
         this._DueTipSprite = null;
         if(Boolean(this._DueTip))
         {
            ObjectUtils.disposeObject(this._DueTip);
         }
         this._DueTip = null;
         if(Boolean(this._dueDataWord))
         {
            ObjectUtils.disposeObject(this._dueDataWord);
         }
         this._dueDataWord = null;
         if(Boolean(this._dueData))
         {
            ObjectUtils.disposeObject(this._dueData);
         }
         this._dueData = null;
         if(Boolean(this._helpFrame))
         {
            this._helpFrame.dispose();
         }
         this._helpFrame = null;
         if(Boolean(this._vipRuleDescriptionBtn))
         {
            this._vipRuleDescriptionBtn.dispose();
         }
         this._vipRuleDescriptionBtn = null;
         if(Boolean(this._attestBtn))
         {
            this._attestBtn.dispose();
         }
         this._attestBtn = null;
         if(Boolean(parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._portrait);
      }
   }
}

