package prayIndiana.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.InviteManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import prayIndiana.PrayIndianaManager;
   import store.HelpFrame;
   
   public class PrayIndianaFrame extends Frame
   {
      
      public static var isFlag:Boolean;
      
      private var _BG:Bitmap;
      
      private var _lotteryProTest:Bitmap;
      
      private var _paopao:Bitmap;
      
      private var _paopaoPray:Bitmap;
      
      private var _tweenFrameBG:Bitmap;
      
      private var _lotteryBtn:SimpleBitmapButton;
      
      private var _refreshBtn:SimpleBitmapButton;
      
      private var _prayBtn:SimpleBitmapButton;
      
      private var _perfectPrayBtn:SimpleBitmapButton;
      
      private var _helpText:FilterFrameText;
      
      private var _prayText:FilterFrameText;
      
      private var _paopaoText:FilterFrameText;
      
      private var _probabilityText:FilterFrameText;
      
      private var _paopaoPrayText:FilterFrameText;
      
      private var _helpBtn:BaseButton;
      
      private var _slide:SlideView;
      
      private var _target:MovieClip;
      
      private var _goodsView:PrayGoodsView;
      
      private var _timerGoods:Timer;
      
      private var _refreshTimer:Timer;
      
      private var _isQuit:Boolean;
      
      private var showStarTime:FilterFrameText;
      
      private var _selectBtn3:SelectedCheckButton;
      
      private var alert3:BaseAlerFrame;
      
      private var _showTimer:Timer;
      
      private var _selectBtn1:SelectedCheckButton;
      
      private var alert1:BaseAlerFrame;
      
      private var _selectBtn:SelectedCheckButton;
      
      private var alert:BaseAlerFrame;
      
      private var _selectBtn2:SelectedCheckButton;
      
      private var alert2:BaseAlerFrame;
      
      private var _goodsIndex:int;
      
      private var indexNum:int;
      
      public function PrayIndianaFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         InviteManager.Instance.enabled = false;
         isFlag = true;
         this._BG = ComponentFactory.Instance.creatBitmap("prayIndiana.FrameBG");
         addToContent(this._BG);
         this._lotteryProTest = ComponentFactory.Instance.creatBitmap("prayIndiana.lotteryProbabilityT");
         addToContent(this._lotteryProTest);
         this._tweenFrameBG = ComponentFactory.Instance.creatBitmap("prayIndiana.TweenFrameBG");
         addToContent(this._tweenFrameBG);
         this._lotteryBtn = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.lotteryBtn");
         addToContent(this._lotteryBtn);
         this._refreshBtn = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.refreshBtn");
         addToContent(this._refreshBtn);
         this._prayBtn = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.prayBtn");
         addToContent(this._prayBtn);
         this._perfectPrayBtn = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.perfectPrayBtn");
         addToContent(this._perfectPrayBtn);
         this._helpBtn = ComponentFactory.Instance.creat("PrayIndianaFrame.helpBtn");
         addToContent(this._helpBtn);
         this._helpText = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.helpText");
         this._helpText.text = LanguageMgr.GetTranslation("Pray.PrayIndianaFrame.helpText",5);
         addToContent(this._helpText);
         this.showStarTime = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.showStarTime");
         this.showStarTime.text = PrayIndianaManager.Instance.model.gameTimes;
         addToContent(this.showStarTime);
         this._prayText = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.prayText");
         this._prayText.text = LanguageMgr.GetTranslation("Pray.PrayIndianaFrame.prayText");
         addToContent(this._prayText);
         this._probabilityText = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.probabilityText");
         this._probabilityText.text = LanguageMgr.GetTranslation("Pray.PrayIndianaFrame.probabilityText",PrayIndianaManager.Instance.model.probabilityNum);
         addToContent(this._probabilityText);
         this._paopao = ComponentFactory.Instance.creatBitmap("prayIndiana.paopao");
         addToContent(this._paopao);
         this._paopaoText = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.paopaoText");
         this._paopaoText.text = PrayIndianaManager.Instance.model.PrayGoodsCount.toString();
         addToContent(this._paopaoText);
         this.visiblePaopao(int(this._paopaoText.text));
         this._paopaoPray = ComponentFactory.Instance.creatBitmap("prayIndiana.paopao");
         PositionUtils.setPos(this._paopaoPray,"prayIndiana.paopao.pos");
         addToContent(this._paopaoPray);
         this._paopaoPrayText = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaFrame.paopaoPrayText");
         this._paopaoPrayText.text = PrayIndianaManager.Instance.model.UpdateRateCount.toString();
         addToContent(this._paopaoPrayText);
         this.visiblePaopaoPray(int(this._paopaoPrayText.text));
         this._goodsView = ComponentFactory.Instance.creatCustomObject("PrayIndianaFrame.PrayGoodsView");
         if(PrayIndianaManager.Instance.model.goodsAll != null && PrayIndianaManager.Instance.model.goodsAll.length > 0)
         {
            this._goodsView.setInfo(PrayIndianaManager.Instance.model.goodsAll);
         }
         addToContent(this._goodsView);
         this._slide = ComponentFactory.Instance.creatCustomObject("PrayIndianaFrame.slide");
         this._slide.visible = false;
         this._slide.slide.gotoAndStop(1);
         addToContent(this._slide);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         this._helpBtn.addEventListener("click",this.__onHelpClick);
         this._prayBtn.addEventListener("click",this.__onPrayBtn);
         this._lotteryBtn.addEventListener("click",this.__lotteryBtn);
         this._perfectPrayBtn.addEventListener("click",this.__PerfectPrayBtn);
         this._refreshBtn.addEventListener("click",this.__refreshBtn);
         PrayIndianaManager.Instance.addEventListener("updateGoods",this.__updateGoods);
         PrayIndianaManager.Instance.addEventListener("prayStart",this.__prayStart);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
         this._helpBtn.removeEventListener("click",this.__onHelpClick);
         if(Boolean(this._prayBtn))
         {
            this._prayBtn.removeEventListener("click",this.__onPrayBtn);
         }
         if(Boolean(this._lotteryBtn))
         {
            this._lotteryBtn.removeEventListener("click",this.__lotteryBtn);
         }
         removeEventListener("keyDown",this.__onKeyDownHander);
         if(Boolean(this._perfectPrayBtn))
         {
            this._perfectPrayBtn.removeEventListener("click",this.__PerfectPrayBtn);
         }
         if(Boolean(this._refreshBtn))
         {
            this._refreshBtn.removeEventListener("click",this.__refreshBtn);
         }
         PrayIndianaManager.Instance.removeEventListener("updateGoods",this.__updateGoods);
         PrayIndianaManager.Instance.removeEventListener("prayStart",this.__prayStart);
      }
      
      private function __refreshBtn(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = int(PrayIndianaManager.Instance.model.prayInfo[4]);
         if(PrayIndianaManager.Instance.showBuyCountFram3)
         {
            _loc2_ = LanguageMgr.GetTranslation("horseRace.match.buyCountDescription",_loc3_);
            this.alert3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
            this._selectBtn3 = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
            this._selectBtn3.text = LanguageMgr.GetTranslation("horseRace.match.notTip");
            this._selectBtn3.addEventListener("click",this.__onClickRefreshSelectedBtn);
            this.alert3.addToContent(this._selectBtn3);
            this.alert3.moveEnable = false;
            this.alert3.addEventListener("response",this.__onRecoverRefreshResponse);
            this.alert3.height = 200;
            this._selectBtn3.x = 102;
            this._selectBtn3.y = 67;
         }
         else
         {
            if(PlayerManager.Instance.Self.Money < _loc3_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.prayIndianaGoodsRefresh();
         }
      }
      
      private function __updateGoods(param1:Event) : void
      {
         this.enableBtnToFalse();
         this._refreshTimer = new Timer(100,5);
         this._refreshTimer.addEventListener("timer",this.__refreshTimerHandler);
         this._refreshTimer.addEventListener("timerComplete",this.__refreshComplete);
         this._refreshTimer.start();
      }
      
      private function __refreshTimerHandler(param1:TimerEvent) : void
      {
         this._goodsView.goodsItemSprite.alpha -= 0.2;
         if(this._goodsView.goodsItemSprite.alpha <= 0)
         {
            this._goodsView.goodsItemSprite.alpha = 0;
         }
      }
      
      private function __refreshComplete(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         if(Boolean(this._refreshTimer))
         {
            this._refreshTimer.removeEventListener("timer",this.__showGoodsTimer);
            this._refreshTimer.stop();
            this._refreshTimer = null;
         }
         var _loc6_:Array = PrayIndianaManager.Instance.model.goodsAll;
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length)
         {
            this._goodsView.cellArr[_loc2_].info = null;
            this._goodsView.cellArr[_loc2_].filters = null;
            this._goodsView.cellArr[_loc2_].alpha = 1;
            _loc3_ = ItemManager.Instance.getTemplateById(_loc6_[_loc2_].TemplateID) as ItemTemplateInfo;
            _loc4_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc4_,_loc3_);
            _loc4_.ValidDate = _loc6_[_loc2_].ValidDate;
            _loc4_.StrengthenLevel = _loc6_[_loc2_].StrengthLevel;
            _loc4_.AttackCompose = _loc6_[_loc2_].AttackCompose;
            _loc4_.DefendCompose = _loc6_[_loc2_].DefendCompose;
            _loc4_.LuckCompose = _loc6_[_loc2_].LuckCompose;
            _loc4_.AgilityCompose = _loc6_[_loc2_].AgilityCompose;
            _loc4_.IsBinds = _loc6_[_loc2_].IsBind;
            _loc4_.Count = _loc6_[_loc2_].Count;
            _loc4_.Place = _loc6_[_loc2_].Position;
            _loc4_.exaltLevel = _loc6_[_loc2_].Quality;
            this._goodsView.cellArr[_loc2_].info = _loc4_;
            _loc5_ = this._goodsView.cellArr[_loc2_].info.exaltLevel < 5 ? 1 : 2;
            this._goodsView.goodItemContainerAll[_loc2_].gotoAndStop(_loc5_);
            _loc2_++;
         }
         this._goodsView.goodsItemSprite.alpha = 0;
         this._showTimer = new Timer(100,5);
         this._showTimer.addEventListener("timer",this.__showGoodsTimer);
         this._showTimer.start();
      }
      
      private function __showGoodsTimer(param1:TimerEvent) : void
      {
         this._goodsView.goodsItemSprite.alpha += 0.3;
         if(this._goodsView.goodsItemSprite.alpha >= 1)
         {
            this._goodsView.goodsItemSprite.alpha = 1;
            this.enableBtnToTrue();
            if(Boolean(this._showTimer))
            {
               this._isQuit = false;
               this._showTimer.removeEventListener("timer",this.__showGoodsTimer);
               this._showTimer.stop();
               this._showTimer = null;
            }
         }
      }
      
      private function __onClickRefreshSelectedBtn(param1:MouseEvent) : void
      {
         PrayIndianaManager.Instance.showBuyCountFram3 = !this._selectBtn3.selected;
      }
      
      private function __onRecoverRefreshResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = int(PrayIndianaManager.Instance.model.prayInfo[4]);
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.prayIndianaGoodsRefresh();
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            PrayIndianaManager.Instance.showBuyCountFram3 = true;
         }
         (param1.currentTarget as BaseAlerFrame).removeEventListener("response",this.__onRecoverRefreshResponse);
         if(Boolean(this._selectBtn))
         {
            this._selectBtn.removeEventListener("click",this.__onClickRefreshSelectedBtn);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __onKeyDownHander(param1:KeyboardEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.keyCode == 32)
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            this._slide.slide.gotoAndStop(this._slide.slide.currentFrame);
            _loc2_ = this.updateSlide();
            SocketManager.Instance.out.prayIndianaPray(2,this._slide.x + 14,this._target.x + 4.5,_loc2_);
            this.enableBtnToTrue();
            this._isQuit = false;
         }
      }
      
      private function __onPrayBtn(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = int(PrayIndianaManager.Instance.model.prayInfo[3]);
         if(PrayIndianaManager.Instance.model.UpdateRateCount > 0)
         {
            SocketManager.Instance.out.prayIndianaPray(1);
         }
         else if(PrayIndianaManager.Instance.showBuyCountFram1)
         {
            _loc2_ = LanguageMgr.GetTranslation("PrayIndianaFrame.PrayTip",_loc3_);
            this.alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
            this._selectBtn1 = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
            this._selectBtn1.text = LanguageMgr.GetTranslation("horseRace.match.notTip");
            this._selectBtn1.addEventListener("click",this.__onClickPraySelectedBtn);
            this.alert1.addToContent(this._selectBtn1);
            this.alert1.moveEnable = false;
            this.alert1.addEventListener("response",this.__onRecoverPrayResponse);
            this.alert1.height = 200;
            this._selectBtn1.x = 102;
            this._selectBtn1.y = 67;
         }
         else
         {
            if(PlayerManager.Instance.Self.Money < _loc3_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.prayIndianaPray(1);
         }
      }
      
      private function __prayStart(param1:Event) : void
      {
         this._isQuit = true;
         stage.focus = this;
         if(!this.hasEventListener("keyDown"))
         {
            addEventListener("keyDown",this.__onKeyDownHander);
         }
         this.showSlide();
         this.enableBtnToFalse();
         this._slide.slide.gotoAndPlay(1);
         this._slide.visible = true;
      }
      
      private function updateSlide() : Number
      {
         var _loc1_:int = this._slide.slide.currentFrame;
         var _loc2_:* = 0;
         if(_loc1_ <= 25)
         {
            return Number((_loc1_ - 1) * 13.375);
         }
         _loc1_ = 49 - _loc1_ + 1;
         return Number((_loc1_ - 1) * 13.375);
      }
      
      private function __PerfectPrayBtn(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = int(PrayIndianaManager.Instance.model.prayInfo[5]);
         if(this.hasEventListener("keyDown"))
         {
            removeEventListener("keyDown",this.__onKeyDownHander);
         }
         if(PrayIndianaManager.Instance.showBuyCountFram)
         {
            _loc2_ = LanguageMgr.GetTranslation("PrayIndianaFrame.PerfectPrayTip",_loc3_);
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
            this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
            this._selectBtn.text = LanguageMgr.GetTranslation("horseRace.match.notTip");
            this._selectBtn.addEventListener("click",this.__onClickSelectedBtn);
            this.alert.addToContent(this._selectBtn);
            this.alert.moveEnable = false;
            this.alert.addEventListener("response",this.__onRecoverResponse);
            this.alert.height = 200;
            this._selectBtn.x = 102;
            this._selectBtn.y = 67;
         }
         else
         {
            if(PlayerManager.Instance.Self.Money < _loc3_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if(this._slide != null)
            {
               this._slide.visible = false;
            }
            if(this._target != null)
            {
               ObjectUtils.disposeObject(this._target);
               this._target = null;
            }
            SocketManager.Instance.out.prayIndianaPray(3);
         }
      }
      
      private function __onClickSelectedBtn(param1:MouseEvent) : void
      {
         PrayIndianaManager.Instance.showBuyCountFram = !this._selectBtn.selected;
      }
      
      private function __onClickPraySelectedBtn(param1:MouseEvent) : void
      {
         PrayIndianaManager.Instance.showBuyCountFram1 = !this._selectBtn1.selected;
      }
      
      private function __onRecoverResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = int(PrayIndianaManager.Instance.model.prayInfo[5]);
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            if(this._slide != null)
            {
               this._slide.visible = false;
            }
            if(this._target != null)
            {
               ObjectUtils.disposeObject(this._target);
               this._target = null;
            }
            SocketManager.Instance.out.prayIndianaPray(3);
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            PrayIndianaManager.Instance.showBuyCountFram = true;
         }
         if(this._selectBtn != null)
         {
            this._selectBtn.removeEventListener("click",this.__onClickSelectedBtn);
            this._selectBtn.dispose();
            this._selectBtn = null;
         }
         if(this.alert != null)
         {
            this.alert.removeEventListener("response",this.__onRecoverResponse);
            this.alert.dispose();
            this.alert = null;
         }
      }
      
      private function __onRecoverPrayResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = int(PrayIndianaManager.Instance.model.prayInfo[3]);
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.prayIndianaPray(1);
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            PrayIndianaManager.Instance.showBuyCountFram1 = true;
         }
         if(this._selectBtn1 != null)
         {
            this._selectBtn1.removeEventListener("click",this.__onClickPraySelectedBtn);
            this._selectBtn1.dispose();
            this._selectBtn1 = null;
         }
         if(this.alert1 != null)
         {
            this.alert1.removeEventListener("response",this.__onRecoverPrayResponse);
            this.alert1.dispose();
            this.alert1 = null;
         }
         if(this.hasEventListener("keyDown"))
         {
            removeEventListener("keyDown",this.__onKeyDownHander);
         }
      }
      
      private function showSlide() : void
      {
         this._slide.visible = true;
         this.showTarget();
      }
      
      private function __lotteryBtn(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(this.hasEventListener("keyDown"))
         {
            removeEventListener("keyDown",this.__onKeyDownHander);
         }
         var _loc3_:int = int(PrayIndianaManager.Instance.model.prayInfo[2]);
         if(PrayIndianaManager.Instance.model.PrayGoodsCount > 0 && PrayIndianaManager.Instance.model.PrayLotteryGoodsCount > 0)
         {
            SocketManager.Instance.out.prayIndianaLottery();
         }
         else if(PrayIndianaManager.Instance.model.PrayLotteryGoodsCount > 0)
         {
            if(PrayIndianaManager.Instance.showBuyCountFram2)
            {
               _loc2_ = LanguageMgr.GetTranslation("horseRace.match.buyCountDescription",_loc3_);
               this.alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
               this._selectBtn2 = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
               this._selectBtn2.text = LanguageMgr.GetTranslation("horseRace.match.notTip");
               this._selectBtn2.addEventListener("click",this.__onClickLotterySelectedBtn);
               this.alert2.addToContent(this._selectBtn2);
               this.alert2.moveEnable = false;
               this.alert2.addEventListener("response",this.__onRecoverLotteryResponse);
               this.alert2.height = 200;
               this._selectBtn2.x = 102;
               this._selectBtn2.y = 67;
            }
            else
            {
               if(PlayerManager.Instance.Self.Money < _loc3_)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               SocketManager.Instance.out.prayIndianaLottery();
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("PrayIndianaFrame.LotteryNoNumberTip"));
         }
      }
      
      public function goodsJump() : void
      {
         if(this._slide != null)
         {
            this._slide.visible = false;
         }
         if(this._target != null)
         {
            ObjectUtils.disposeObject(this._target);
            this._target = null;
         }
         this.enableBtnToFalse();
         this._timerGoods = new Timer(400,10);
         this._timerGoods.addEventListener("timer",this.__goodsTimerHandler);
         this._timerGoods.addEventListener("timerComplete",this.__goodsTimerComplete);
         this._timerGoods.start();
      }
      
      private function __goodsTimerHandler(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         this.indexNum = Math.random() * 28;
         var _loc3_:Array = PrayIndianaManager.Instance.model.getGoods;
         if(_loc3_.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(int(_loc3_[_loc2_]) == this.indexNum)
               {
                  this.indexNum = Math.random() * 28;
               }
               _loc2_++;
            }
         }
         if(this.indexNum == this._goodsIndex)
         {
            this.indexNum = Math.random() * 28;
         }
         this._goodsIndex = this.indexNum;
         this._goodsView.goodItemContainerAll[this.indexNum].gotoAndStop(3);
         setTimeout(this.goodsTimerComplete,200,this.indexNum);
      }
      
      private function goodsTimerComplete(param1:int) : void
      {
         var _loc2_:int = this._goodsView.cellArr[param1].info.exaltLevel < 5 ? 1 : 2;
         this._goodsView.goodItemContainerAll[param1].gotoAndStop(_loc2_);
      }
      
      private function __goodsTimerComplete(param1:TimerEvent) : void
      {
         setTimeout(this.showGoodsItem,400);
      }
      
      private function showGoodsItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = this._goodsView.cellArr;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            if(_loc2_[_loc1_].info.TemplateID == PrayIndianaManager.Instance.model.templateID && _loc2_[_loc1_].info.Place == PrayIndianaManager.Instance.model.position)
            {
               PrayIndianaManager.Instance.model.getGoods.push(_loc1_);
               this._goodsView.goodItemContainerAll[_loc1_].gotoAndStop(3);
               this._goodsView.cellArr[_loc1_].filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._goodsView.cellArr[_loc1_].alpha = 0.4;
               this.enableBtnToTrue();
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("PrayIndianaFrame.GetGoodsTip",_loc2_[_loc1_].info.Name));
               setTimeout(this.showLotteryGoods,1000,_loc1_);
               return;
            }
            _loc1_++;
         }
      }
      
      private function showLotteryGoods(param1:int) : void
      {
         var _loc2_:int = this._goodsView.cellArr[param1].info.exaltLevel < 5 ? 1 : 2;
         this._goodsView.goodItemContainerAll[param1].gotoAndStop(_loc2_);
         this.updateLotteryNumber();
      }
      
      private function __onClickLotterySelectedBtn(param1:MouseEvent) : void
      {
         PrayIndianaManager.Instance.showBuyCountFram2 = !this._selectBtn2.selected;
      }
      
      private function __onRecoverLotteryResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = int(PrayIndianaManager.Instance.model.prayInfo[2]);
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.prayIndianaLottery();
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            PrayIndianaManager.Instance.showBuyCountFram2 = true;
         }
         if(this._selectBtn2 != null)
         {
            this._selectBtn2.removeEventListener("click",this.__onClickLotterySelectedBtn);
            this._selectBtn2.dispose();
            this._selectBtn2 = null;
         }
         if(this.alert2 != null)
         {
            this.alert2.removeEventListener("response",this.__onRecoverLotteryResponse);
            this.alert2.dispose();
            this.alert2 = null;
         }
      }
      
      protected function __onHelpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("PrayIndianaFrame.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("PrayIndianaFrame.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(_loc3_,1,true,1);
      }
      
      private function enableBtnToFalse() : void
      {
         this._isQuit = true;
         if(Boolean(this._prayBtn))
         {
            this._prayBtn.enable = this._prayBtn.mouseEnabled = this._prayBtn.mouseChildren = false;
         }
         if(Boolean(this._perfectPrayBtn))
         {
            this._perfectPrayBtn.enable = this._perfectPrayBtn.mouseEnabled = this._perfectPrayBtn.mouseChildren = false;
         }
         if(Boolean(this._lotteryBtn))
         {
            this._lotteryBtn.enable = this._lotteryBtn.mouseEnabled = this._lotteryBtn.mouseChildren = false;
         }
         if(Boolean(this._refreshBtn))
         {
            this._refreshBtn.enable = this._refreshBtn.mouseEnabled = this._refreshBtn.mouseChildren = false;
         }
      }
      
      private function enableBtnToTrue() : void
      {
         this._isQuit = false;
         if(Boolean(this._prayBtn))
         {
            this._prayBtn.enable = this._prayBtn.mouseEnabled = this._prayBtn.mouseChildren = true;
         }
         if(Boolean(this._perfectPrayBtn))
         {
            this._perfectPrayBtn.enable = this._perfectPrayBtn.mouseEnabled = this._perfectPrayBtn.mouseChildren = true;
         }
         if(Boolean(this._lotteryBtn))
         {
            this._lotteryBtn.enable = this._lotteryBtn.mouseEnabled = this._lotteryBtn.mouseChildren = true;
         }
         if(Boolean(this._refreshBtn))
         {
            this._refreshBtn.enable = this._refreshBtn.mouseEnabled = this._refreshBtn.mouseChildren = true;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(this._isQuit)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("PrayIndianaFrame.ExitNo"));
         }
         else if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            this._isQuit = false;
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function updateLotteryNumber() : void
      {
         this._paopaoText.text = PrayIndianaManager.Instance.model.PrayGoodsCount.toString();
         this.visiblePaopao(int(this._paopaoText.text));
         this._paopaoPrayText.text = PrayIndianaManager.Instance.model.UpdateRateCount.toString();
         this.visiblePaopaoPray(int(this._paopaoPrayText.text));
         this._probabilityText.text = LanguageMgr.GetTranslation("Pray.PrayIndianaFrame.probabilityText",PrayIndianaManager.Instance.model.probabilityNum.toString());
      }
      
      private function visiblePaopao(param1:int) : void
      {
         if(param1 >= 1)
         {
            this._paopaoText.visible = true;
            this._paopao.visible = true;
         }
         else
         {
            this._paopaoText.visible = false;
            this._paopao.visible = false;
         }
      }
      
      private function visiblePaopaoPray(param1:int) : void
      {
         if(param1 >= 1)
         {
            this._paopaoPrayText.visible = true;
            this._paopaoPray.visible = true;
         }
         else
         {
            this._paopaoPrayText.visible = false;
            this._paopaoPray.visible = false;
         }
      }
      
      private function showTarget() : void
      {
         if(Boolean(this._target))
         {
            ObjectUtils.disposeObject(this._target);
            this._target = null;
         }
         this._target = ComponentFactory.Instance.creat("prayIndiana.target");
         var _loc1_:Number = Math.random() * 295;
         this._target.x = _loc1_ < 85 ? 85 : Number(_loc1_);
         this._target.y = 420;
         addToContent(this._target);
      }
      
      override public function dispose() : void
      {
         isFlag = false;
         InviteManager.Instance.enabled = true;
         this.removeEvent();
         if(Boolean(this._lotteryBtn))
         {
            ObjectUtils.disposeObject(this._lotteryBtn);
         }
         this._lotteryBtn = null;
         if(Boolean(this._refreshBtn))
         {
            ObjectUtils.disposeObject(this._refreshBtn);
         }
         this._refreshBtn = null;
         if(Boolean(this._prayBtn))
         {
            ObjectUtils.disposeObject(this._prayBtn);
         }
         this._prayBtn = null;
         if(Boolean(this._perfectPrayBtn))
         {
            ObjectUtils.disposeObject(this._perfectPrayBtn);
         }
         this._perfectPrayBtn = null;
         if(Boolean(this._timerGoods))
         {
            ObjectUtils.disposeObject(this._timerGoods);
         }
         this._timerGoods = null;
         if(Boolean(this._slide))
         {
            this._slide.dispose();
            ObjectUtils.disposeObject(this._slide);
            this._slide = null;
         }
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

