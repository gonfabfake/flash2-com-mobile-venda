package welfareCenter.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import welfareCenter.WelfareCenterManager;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   import welfareCenter.callBackLotteryDraw.view.CallBackLotteryDrawFrame;
   import welfareCenter.icon.WelfareCenterItem;
   import welfareCenter.icon.WelfareCenterItemTime;
   
   public class WelfareCenterFrame extends Frame
   {
      
      private var _currentType:int = -1;
      
      private var _bg:ScaleBitmapImage;
      
      private var _content:Sprite;
      
      private var _itemList:Vector.<WelfareCenterItem>;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _vBox:VBox;
      
      private var _backFundView:CallBackFundView;
      
      private var _backLotteryView:CallBackLotteryDrawFrame;
      
      private var _gradeGiftView:OldPlayerGradeGiftView;
      
      public function WelfareCenterFrame()
      {
         super();
      }
      
      public function show() : void
      {
         InviteManager.Instance.enabled = false;
         LayerManager.Instance.addToLayer(this,3,true,1);
         WelfareCenterManager.instance.addEventListener("change",this.__onCheckItemShine);
         this.__onCheckItemShine(null);
      }
      
      override protected function init() : void
      {
         this._itemList = new Vector.<WelfareCenterItem>();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("welfareCenter.frameBg");
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("welfareCenter.frame.vBox");
         this._content = new Sprite();
         this.initItem();
         super.init();
         titleText = LanguageMgr.GetTranslation("ddt.welfareCenterFrame.title");
         this.updateView((this._itemList[0] as WelfareCenterItem).type);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addToContent(this._bg);
         addToContent(this._vBox);
         addToContent(this._content);
      }
      
      private function initItem() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         this._btnGroup = new SelectedButtonGroup();
         if(WelfareCenterManager.instance.getitemIsOpen(0))
         {
            _loc1_ = new WelfareCenterItem(0);
            this._vBox.addChild(_loc1_);
            _loc1_.addEventListener("click",this.__onClickItem);
            this._itemList.push(_loc1_);
            this._btnGroup.addSelectItem(_loc1_);
         }
         if(WelfareCenterManager.instance.getitemIsOpen(1))
         {
            _loc2_ = new WelfareCenterItemTime(1);
            this._vBox.addChild(_loc2_);
            _loc2_.addEventListener("click",this.__onClickItem);
            this._itemList.push(_loc2_);
            this._btnGroup.addSelectItem(_loc2_);
            CallBackLotteryDrawManager.instance.addEventListener("event_open_frame",this.onOpenView);
            CallBackLotteryDrawManager.instance.addEventListener("event_zero_fresh",this.onZeroFresh);
         }
         if(WelfareCenterManager.instance.getitemIsOpen(2))
         {
            _loc3_ = new WelfareCenterItem(2);
            this._vBox.addChild(_loc3_);
            _loc3_.addEventListener("click",this.__onClickItem);
            this._itemList.push(_loc3_);
            this._btnGroup.addSelectItem(_loc3_);
         }
         this._btnGroup.selectIndex = 0;
      }
      
      public function updateView(param1:int) : void
      {
         if(this._currentType == param1)
         {
            return;
         }
         this._currentType = param1;
         if(param1 == 0)
         {
            if(this._backFundView == null)
            {
               this._backFundView = new CallBackFundView();
               PositionUtils.setPos(this._backFundView,"welfareCenter.backFundViewPos");
               this._content.addChild(this._backFundView);
            }
            if(Boolean(this._backFundView))
            {
               this._backFundView.visible = true;
            }
            if(Boolean(this._backLotteryView))
            {
               this._backLotteryView.visible = false;
            }
            if(Boolean(this._gradeGiftView))
            {
               this._gradeGiftView.visible = false;
            }
            ObjectUtils.disposeObject(this._backLotteryView);
            this._backLotteryView = null;
         }
         else if(param1 == 1)
         {
            CallBackLotteryDrawManager.instance.queryLotteryGoods(0);
         }
         else if(param1 == 2)
         {
            if(this._gradeGiftView == null)
            {
               this._gradeGiftView = new OldPlayerGradeGiftView();
               PositionUtils.setPos(this._gradeGiftView,"welfareCenter.gradeGiftViewPos");
               this._content.addChild(this._gradeGiftView);
            }
            if(Boolean(this._backFundView))
            {
               this._backFundView.visible = false;
            }
            if(Boolean(this._backLotteryView))
            {
               this._backLotteryView.visible = false;
            }
            if(Boolean(this._gradeGiftView))
            {
               this._gradeGiftView.visible = true;
            }
            ObjectUtils.disposeObject(this._backLotteryView);
            this._backLotteryView = null;
         }
      }
      
      protected function onOpenView(param1:Event) : void
      {
         if(CallBackLotteryDrawManager.instance.type == 0 && this._currentType == 1)
         {
            ObjectUtils.disposeObject(this._backLotteryView);
            this._backLotteryView = new CallBackLotteryDrawFrame();
            PositionUtils.setPos(this._backLotteryView,"welfareCenter.backLotteryViewPos");
            this._content.addChild(this._backLotteryView);
            if(Boolean(this._backFundView))
            {
               this._backFundView.visible = false;
            }
            if(Boolean(this._gradeGiftView))
            {
               this._gradeGiftView.visible = false;
            }
         }
      }
      
      private function onZeroFresh(param1:Event) : void
      {
         if(Boolean(this._backLotteryView))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("callbacklotterdraw.zeroFresh"));
         }
         if(Boolean(this._backFundView))
         {
            this.updateView(0);
         }
         ObjectUtils.disposeObject(this._backLotteryView);
         this._backLotteryView = null;
      }
      
      private function __onClickItem(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:WelfareCenterItem = param1.currentTarget as WelfareCenterItem;
         _loc2_.isShine = false;
         if(WelfareCenterManager.instance.getitemIsOpen(_loc2_.type))
         {
            if(_loc2_.canClick)
            {
               this.updateView(_loc2_.type);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.welfareCenter.gift.waitActivity"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.welfareCenter.gift.activityEnd"));
            _loc2_.removeEventListener("click",this.__onClickItem);
            this._itemList.splice(this._itemList.indexOf(_loc2_),1);
            this._vBox.removeChild(_loc2_);
            ObjectUtils.disposeObject(_loc2_);
         }
      }
      
      private function __onCheckItemShine(param1:Event = null) : void
      {
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = null;
         InviteManager.Instance.enabled = true;
         WelfareCenterManager.instance.removeEventListener("change",this.__onCheckItemShine);
         CallBackLotteryDrawManager.instance.removeEventListener("event_open_frame",this.onOpenView);
         CallBackLotteryDrawManager.instance.removeEventListener("event_zero_fresh",this.onZeroFresh);
         while(Boolean(this._itemList.length))
         {
            _loc1_ = this._itemList.pop() as WelfareCenterItem;
            _loc1_.removeEventListener("click",this.__onClickItem);
         }
         this._btnGroup.dispose();
         this._vBox.dispose();
         this._vBox = null;
         ObjectUtils.disposeAllChildren(this._content);
         super.dispose();
         this._itemList = null;
         this._bg = null;
         this._content = null;
         this._backFundView = null;
         this._backLotteryView = null;
         this._gradeGiftView = null;
         this._btnGroup = null;
      }
   }
}

