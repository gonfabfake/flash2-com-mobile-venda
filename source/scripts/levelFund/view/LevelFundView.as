package levelFund.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import levelFund.LevelFundManager;
   import levelFund.event.LevelFundEvent;
   
   public class LevelFundView extends Sprite implements Disposeable
   {
      
      private var _panel:ScrollPanel;
      
      private var _itemsSprite:Sprite;
      
      private var _items:Array;
      
      private var _buyLevelTxt:FilterFrameText;
      
      private var _buyFundBtn1:BaseButton;
      
      private var _buyFundBtn2:BaseButton;
      
      private var _buyFundBtn3:BaseButton;
      
      private var _buyCompleteIcon:Bitmap;
      
      private var _buyType:int = 0;
      
      private var _buyPrice:int = 0;
      
      public function LevelFundView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._buyLevelTxt = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundView.buyLevelTxt");
         this._buyLevelTxt.text = LanguageMgr.GetTranslation("levelFund.levelFundView.buyLevelTxtMsg");
         addChild(this._buyLevelTxt);
         this._buyFundBtn1 = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundView.buyFundBtn1");
         this._buyFundBtn2 = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundView.buyFundBtn2");
         this._buyFundBtn3 = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundView.buyFundBtn3");
         addChild(this._buyFundBtn1);
         addChild(this._buyFundBtn2);
         addChild(this._buyFundBtn3);
         this._buyCompleteIcon = ComponentFactory.Instance.creatBitmap("levelFund.levelFundView.buyCompleteIcon");
         this._buyCompleteIcon.visible = false;
         addChild(this._buyCompleteIcon);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("levelFund.levelFundViewPanel");
         this._itemsSprite = new Sprite();
         this._panel.setView(this._itemsSprite);
         addChild(this._panel);
         this.addItems();
         this.setBuyCompleteState(LevelFundManager.instance.model.buyType);
         this.updateItems(LevelFundManager.instance.model.getBuyMultiple);
      }
      
      private function setBuyCompleteState(param1:int = 0) : void
      {
         if(param1 > 0)
         {
            this._buyCompleteIcon.visible = true;
            PositionUtils.setPos(this._buyCompleteIcon,"levelFund.levelFundView.getAwardCompleteIconPos" + param1);
            this._buyFundBtn1.mouseEnabled = false;
            this._buyFundBtn2.mouseEnabled = false;
            this._buyFundBtn3.mouseEnabled = false;
         }
         else
         {
            this._buyFundBtn1.mouseEnabled = true;
            this._buyFundBtn2.mouseEnabled = true;
            this._buyFundBtn3.mouseEnabled = true;
            this._buyCompleteIcon.visible = false;
         }
      }
      
      private function addItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._items = [];
         var _loc3_:Array = LevelFundManager.instance.model.dataArr;
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc2_ = new LevelFundViewItem(_loc1_);
            _loc2_.y = _loc1_ * 39;
            this._items.push(_loc2_);
            this._itemsSprite.addChild(_loc2_);
            _loc1_++;
         }
         this._panel.invalidateViewport();
      }
      
      private function updateItems(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Array = LevelFundManager.instance.model.dataArr;
         _loc2_ = 0;
         while(_loc2_ < this._items.length)
         {
            _loc3_ = this._items[_loc2_];
            _loc3_.updateView(_loc4_[_loc2_],param1);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         this._buyFundBtn1.addEventListener("click",this.__buyFundBtnClickHandler);
         this._buyFundBtn2.addEventListener("click",this.__buyFundBtnClickHandler);
         this._buyFundBtn3.addEventListener("click",this.__buyFundBtnClickHandler);
         this._buyFundBtn1.addEventListener("mouseOver",this.__buyFundBtnOverHandler);
         this._buyFundBtn2.addEventListener("mouseOver",this.__buyFundBtnOverHandler);
         this._buyFundBtn3.addEventListener("mouseOver",this.__buyFundBtnOverHandler);
         this._buyFundBtn1.addEventListener("mouseOut",this.__buyFundBtnOutHandler);
         this._buyFundBtn2.addEventListener("mouseOut",this.__buyFundBtnOutHandler);
         this._buyFundBtn3.addEventListener("mouseOut",this.__buyFundBtnOutHandler);
         LevelFundManager.instance.addEventListener("update_view",this.__updateViewHandler);
      }
      
      private function __buyFundBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:int = 3;
         if(param1.target == this._buyFundBtn1)
         {
            _loc2_ = 1;
         }
         else if(param1.target == this._buyFundBtn2)
         {
            _loc2_ = 2;
         }
         this.showBuyTipFrame(_loc2_);
      }
      
      private function showBuyTipFrame(param1:int) : void
      {
         var _loc3_:Array = null;
         this._buyType = param1;
         var _loc2_:int = 5;
         if(this._buyType == 1)
         {
            _loc2_ = 1;
         }
         else if(this._buyType == 2)
         {
            _loc2_ = 3;
         }
         _loc3_ = ServerConfigManager.instance.levelFundPrice;
         if(Boolean(_loc3_))
         {
            this._buyPrice = int(_loc3_[this._buyType - 1]);
         }
         var _loc4_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("levelFund.buyLevelFund.buyTipTxt",this._buyPrice,_loc2_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2,null,"SimpleAlert",60,false,0);
         _loc4_.addEventListener("response",this.confirmResponse);
      }
      
      private function confirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.confirmResponse);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            CheckMoneyUtils.instance.checkMoney(_loc2_.isBand,this._buyPrice,this.onCheckComplete);
         }
         _loc2_.dispose();
      }
      
      protected function onCheckComplete() : void
      {
         SocketManager.Instance.out.sendBuyLevelFund(CheckMoneyUtils.instance.isBind,this._buyType);
      }
      
      private function __buyFundBtnOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 5;
         if(param1.target == this._buyFundBtn1)
         {
            _loc2_ = 1;
         }
         else if(param1.target == this._buyFundBtn2)
         {
            _loc2_ = 3;
         }
         this.updateItems(_loc2_);
      }
      
      private function __buyFundBtnOutHandler(param1:MouseEvent) : void
      {
         this.updateItems(LevelFundManager.instance.model.getBuyMultiple);
      }
      
      private function __updateViewHandler(param1:LevelFundEvent) : void
      {
         this.setBuyCompleteState(LevelFundManager.instance.model.buyType);
         this.updateItems(LevelFundManager.instance.model.getBuyMultiple);
      }
      
      private function removeEvent() : void
      {
         this._buyFundBtn1.removeEventListener("click",this.__buyFundBtnClickHandler);
         this._buyFundBtn2.removeEventListener("click",this.__buyFundBtnClickHandler);
         this._buyFundBtn3.removeEventListener("click",this.__buyFundBtnClickHandler);
         this._buyFundBtn1.removeEventListener("mouseOver",this.__buyFundBtnOverHandler);
         this._buyFundBtn2.removeEventListener("mouseOver",this.__buyFundBtnOverHandler);
         this._buyFundBtn3.removeEventListener("mouseOver",this.__buyFundBtnOverHandler);
         this._buyFundBtn1.removeEventListener("mouseOut",this.__buyFundBtnOutHandler);
         this._buyFundBtn2.removeEventListener("mouseOut",this.__buyFundBtnOutHandler);
         this._buyFundBtn3.removeEventListener("mouseOut",this.__buyFundBtnOutHandler);
         LevelFundManager.instance.removeEventListener("update_view",this.__updateViewHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._buyLevelTxt);
         this._buyLevelTxt = null;
         ObjectUtils.disposeObject(this._buyCompleteIcon);
         this._buyCompleteIcon = null;
         ObjectUtils.disposeObject(this._panel);
         this._panel = null;
         ObjectUtils.disposeAllChildren(this._itemsSprite);
         ObjectUtils.disposeObject(this._itemsSprite);
         this._itemsSprite = null;
         ObjectUtils.disposeObject(this._buyFundBtn1);
         this._buyFundBtn1 = null;
         ObjectUtils.disposeObject(this._buyFundBtn2);
         this._buyFundBtn2 = null;
         ObjectUtils.disposeObject(this._buyFundBtn3);
         this._buyFundBtn3 = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

