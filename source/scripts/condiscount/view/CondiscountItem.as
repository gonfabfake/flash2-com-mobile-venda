package condiscount.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import condiscount.CondiscountManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftChildInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class CondiscountItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _normalPriceTxt:FilterFrameText;
      
      private var _disCountPriceTxt:FilterFrameText;
      
      private var buyBtn:BaseButton;
      
      private var buyIcon:Bitmap;
      
      private var _info:GiftBagInfo;
      
      private var icon:Component;
      
      private var _goodsIcon:MovieClip;
      
      private var arrow:MovieClip;
      
      private var _type:String;
      
      private var frame:BaseAlerFrame;
      
      public function CondiscountItem()
      {
         super();
         this.init();
      }
      
      public function get info() : GiftBagInfo
      {
         return this._info;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("condiscount.view.item.bg");
         addChild(this._bg);
         this.icon = new Component();
         addChild(this.icon);
         this.icon.tipStyle = "ddt.view.tips.WordWrapLineTip";
         this._goodsIcon = ClassUtils.CreatInstance("condiscount.view.goods.icon");
         this._goodsIcon.gotoAndStop(1);
         PositionUtils.setPos(this._goodsIcon,"condiscount.view.goods.icon.pos");
         this.icon.addChild(this._goodsIcon);
         this.icon.tipDirctions = "7,5";
         PositionUtils.setPos(this.icon,"condiscount.view.goods.icon.component.pos");
         this._normalPriceTxt = ComponentFactory.Instance.creatComponentByStylename("condiscount.item.normalPriceText");
         addChild(this._normalPriceTxt);
         this._disCountPriceTxt = ComponentFactory.Instance.creatComponentByStylename("condiscount.item.discountPriceText");
         addChild(this._disCountPriceTxt);
         this.buyBtn = ComponentFactory.Instance.creatComponentByStylename("condiscount.view.buyBtn");
         addChild(this.buyBtn);
         this.buyBtn.addEventListener("click",this.clickHandler);
         this.buyIcon = ComponentFactory.Instance.creatBitmap("condiscount.view.buyIcon");
         addChild(this.buyIcon);
         this.buyIcon.visible = false;
         this.arrow = ClassUtils.CreatInstance("condiscount.view.arrow");
         this.arrow.gotoAndStop(1);
         PositionUtils.setPos(this.arrow,"condiscount.view.arrow.pos");
         addChild(this.arrow);
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = this._info.giftConditionArr[0].remain2.split("|")[0];
         if(_loc2_ == "-1")
         {
            this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.condiscount.item.buyalart",this._info.giftConditionArr[0].conditionValue),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2,null,"SimpleAlert",60,false,1);
            this.frame.addEventListener("response",this.onBuyConfirmResponse);
         }
         else if(_loc2_ == "-8")
         {
            this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.condiscount.item.buyalart",this._info.giftConditionArr[0].conditionValue),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2,null,"SimpleAlert",60,false);
            this.frame.isBand = false;
            this.frame.addEventListener("response",this.onBuyConfirmResponse);
         }
         else if(_loc2_ == "-9")
         {
            this.frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.condiscount.item.buyalart.band",this._info.giftConditionArr[0].conditionValue),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2,null,"SimpleAlert",60,false);
            this.frame.isBand = true;
            this.frame.addEventListener("response",this.onBuyConfirmResponse);
         }
      }
      
      private function onBuyConfirmResponse(param1:FrameEvent) : void
      {
         this.frame.removeEventListener("response",this.onBuyConfirmResponse);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            if(this._type == "-1")
            {
               CheckMoneyUtils.instance.checkMoney(this.frame.isBand,this._info.giftConditionArr[0].conditionValue,this.onCheckComplete);
               return;
            }
            if(this.frame.isBand && PlayerManager.Instance.Self.BandMoney < this._info.giftConditionArr[0].conditionValue)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("bindMoneyPoorNote"));
               return;
            }
            if(!this.frame.isBand && PlayerManager.Instance.Self.Money < this._info.giftConditionArr[0].conditionValue)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            this.onCheckComplete();
         }
      }
      
      protected function onCheckComplete() : void
      {
         var _loc1_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc2_:SendGiftInfo = new SendGiftInfo();
         _loc2_.activityId = CondiscountManager.instance.model.actId;
         var _loc3_:Array = [];
         var _loc4_:GiftChildInfo = new GiftChildInfo();
         _loc4_.giftId = this._info.giftbagId;
         if(this._type == "-1")
         {
            _loc4_.index = CheckMoneyUtils.instance.isBind ? -9 : -8;
         }
         else
         {
            _loc4_.index = this.frame.isBand ? -9 : -8;
         }
         _loc3_.push(_loc4_);
         _loc2_.giftIdArr = _loc3_;
         _loc1_.push(_loc2_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc1_);
      }
      
      public function setInfo(param1:GiftBagInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         this._info = param1;
         this._goodsIcon.gotoAndStop(this._info.rewardMark + 1);
         var _loc5_:String = "";
         _loc2_ = 0;
         while(_loc2_ < this._info.giftRewardArr.length)
         {
            _loc3_ = ItemManager.Instance.getTemplateById(this._info.giftRewardArr[_loc2_].templateId).beadName;
            _loc4_ = "*" + String(this._info.giftRewardArr[_loc2_].count);
            _loc5_ += _loc3_ + _loc4_ + "\n";
            _loc2_++;
         }
         this.icon.tipData = _loc5_;
         this._normalPriceTxt.text = LanguageMgr.GetTranslation("ddt.condiscount.item.normalPrice",this._info.giftConditionArr[0].remain1);
         this._disCountPriceTxt.text = LanguageMgr.GetTranslation("ddt.condiscount.item.discountPrice",this._info.giftConditionArr[0].conditionValue);
         this._type = this._info.giftConditionArr[0].remain2.split("|")[0];
      }
      
      public function changeData(param1:int) : void
      {
         this.buyBtn.enable = param1 == 2;
         if(param1 == 0)
         {
            this.arrow.gotoAndStop(1);
            this.buyIcon.visible = true;
         }
         else
         {
            this.arrow.gotoAndStop(2);
            this.buyIcon.visible = false;
         }
         if(this._info.giftbagOrder == 3)
         {
            this.arrow.visible = false;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._normalPriceTxt = null;
         this._disCountPriceTxt = null;
         this.buyBtn = null;
         this.buyIcon = null;
      }
   }
}

