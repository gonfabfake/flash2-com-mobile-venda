package magicHouse.magicCollection
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseModel;
   
   public class MagicHouseMagicPotionSelectFrame extends Frame
   {
      
      private var _numberSelecter:NumberSelecter;
      
      private var _countTxt:FilterFrameText;
      
      private var _needPotionTipTxt:FilterFrameText;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _count:int;
      
      private var _type:int;
      
      public function MagicHouseMagicPotionSelectFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.titleText = LanguageMgr.GetTranslation("magichouse.collectionView.magicpotionsCountTitle");
         this._numberSelecter = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItem.upgrade.magicpotion.NumberSelecter");
         addToContent(this._numberSelecter);
         var _loc1_:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(201489);
         this._numberSelecter.valueLimit = "1," + _loc1_;
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.chargeBoxNeedMoneyText");
         PositionUtils.setPos(this._countTxt,"magicHouse.collection.selectedCountTxtPos");
         this._countTxt.text = LanguageMgr.GetTranslation("magichouse.collectionView.magicpotionsCount");
         addToContent(this._countTxt);
         this._needPotionTipTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.chargeBoxNeedMoneyText");
         PositionUtils.setPos(this._needPotionTipTxt,"magicHouse.collection.selectedNeedTxtPos");
         this._needPotionTipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.upgradeLvNeedPotions",0);
         addToContent(this._needPotionTipTxt);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         PositionUtils.setPos(this._okBtn,"magicHouse.collection.selectedOkBtnPos");
         addToContent(this._okBtn);
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
         this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
         PositionUtils.setPos(this._cancelBtn,"magicHouse.collection.selectedCancekBtnPos");
         addToContent(this._cancelBtn);
      }
      
      private function _update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._type == 1)
         {
            _loc2_ = int(MagicHouseModel.instance.levelUpNumber[MagicHouseModel.instance.magicJuniorLv]);
            _loc3_ = MagicHouseModel.instance.magicJuniorExp;
         }
         else if(this._type == 2)
         {
            _loc2_ = int(MagicHouseModel.instance.levelUpNumber[MagicHouseModel.instance.magicMidLv]);
            _loc3_ = MagicHouseModel.instance.magicMidExp;
         }
         else
         {
            _loc2_ = int(MagicHouseModel.instance.levelUpNumber[MagicHouseModel.instance.magicSeniorLv]);
            _loc3_ = MagicHouseModel.instance.magicSeniorExp;
         }
         _loc1_ = Math.ceil((_loc2_ - _loc3_) / 10);
         this._numberSelecter.currentValue = _loc1_;
         this._numberSelecter.validate();
         this._needPotionTipTxt.htmlText = LanguageMgr.GetTranslation("magichouse.collectionView.upgradeLvNeedPotions",_loc1_);
      }
      
      private function initEvent() : void
      {
         this._numberSelecter.addEventListener("change",this.selectHandler);
         this._okBtn.addEventListener("click",this.__okBtnHandler);
         this._cancelBtn.addEventListener("click",this.__cancelBtnHandler);
         addEventListener("response",this._response);
      }
      
      private function removeEvent() : void
      {
         this._numberSelecter.removeEventListener("change",this.selectHandler);
         this._okBtn.removeEventListener("click",this.__okBtnHandler);
         this._cancelBtn.removeEventListener("click",this.__cancelBtnHandler);
      }
      
      private function selectHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._count = this._numberSelecter.currentValue;
      }
      
      private function __okBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(201489) > 0)
         {
            SocketManager.Instance.out.magicLibLevelUp(this._type,this._count);
            this.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionItem.magicPotionLess"));
         }
      }
      
      private function __cancelBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            this.dispose();
         }
         else if(param1.responseCode == 2)
         {
            this.__okBtnHandler(null);
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         this._update();
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

