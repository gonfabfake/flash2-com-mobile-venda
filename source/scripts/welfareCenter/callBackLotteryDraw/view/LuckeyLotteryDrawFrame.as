package welfareCenter.callBackLotteryDraw.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ArrayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawController;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   import welfareCenter.callBackLotteryDraw.LotteryDrawModel;
   
   public class LuckeyLotteryDrawFrame extends Frame
   {
      
      private var _nextCDTimeTf:FilterFrameText;
      
      private var _cardShowMC:MovieClip;
      
      private var _cardShuffleMC:MovieClip;
      
      private var _cardOpenItemArr:Array;
      
      private var _clickCardOpenItem:LuckeyCardOpenItem;
      
      private var _startDrawBtn:SimpleBitmapButton;
      
      private var _manager:CallBackLotteryDrawManager;
      
      private var _model:LotteryDrawModel;
      
      private var _timer:Timer;
      
      private var _leftSec:int;
      
      private var _buyBtnArr:Array;
      
      private var _buyBtnClickIndex:int = -1;
      
      private var _maskSp:Sprite;
      
      private var _radomAwardArr:Array;
      
      public function LuckeyLotteryDrawFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._manager = CallBackLotteryDrawManager.instance;
         this._model = this._manager.luckeyLotteryDrawModel;
         this._nextCDTimeTf = UICreatShortcut.creatAndAdd("luckeylotterydraw.nextCDTimeTf",_container);
         this._startDrawBtn = UICreatShortcut.creatAndAdd("luckeylotterydraw.startDrawBtn",_container);
         this._startDrawBtn.visible = false;
         this._maskSp = new Sprite();
         if(this._model.currPhaseHasGetCount > 0)
         {
            this._radomAwardArr = this._model.awardArr;
         }
         else
         {
            this._radomAwardArr = this._model.awardArr.concat();
            ArrayUtils.disorder(this._radomAwardArr);
         }
         this.playCardShow();
         this.onInfoChange(null);
      }
      
      private function onInfoChange(param1:Event) : void
      {
         this._leftSec = this._manager.getLuckeyLeftSec();
         if(this._leftSec > 0)
         {
            if(Boolean(this._timer))
            {
               this._timer.reset();
               this._timer.delay = 1000;
               this._timer.repeatCount = this._leftSec;
               this._timer.addEventListener("timer",this.onTimerTick);
               this._timer.start();
            }
            else
            {
               this._timer = new Timer(1000,this._leftSec);
               this._timer.addEventListener("timer",this.onTimerTick);
               this._timer.start();
            }
         }
         this.updateNextCDTimeTf();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         --this._leftSec;
         if(this._leftSec <= 0)
         {
            this._leftSec = 0;
            this._timer.removeEventListener("timer",this.onTimerTick);
            this._timer.stop();
         }
         this.updateNextCDTimeTf();
      }
      
      private function updateNextCDTimeTf() : void
      {
         var _loc1_:Array = TimeManager.getHHMMSSArr(this._leftSec);
         if(Boolean(_loc1_))
         {
            this._nextCDTimeTf.text = LanguageMgr.GetTranslation("callbacklotterdraw.nextCDTimeTxt") + _loc1_.join(":");
         }
         else
         {
            this._nextCDTimeTf.text = LanguageMgr.GetTranslation("callbacklotterdraw.nextCDTimeTxt") + "00:00:00";
         }
      }
      
      private function playCardShow() : void
      {
         this._cardShowMC = ComponentFactory.Instance.creat("luckeylotterydraw.cardShow");
         PositionUtils.setPos(this._cardShowMC,"luckeylotterydraw.cardShow.pos");
         addToContent(this._cardShowMC);
         this._cardShowMC.addEventListener("enterFrame",this.onCardShowEnterFrame);
      }
      
      private function onCardShowEnterFrame(param1:Event) : void
      {
         var _loc10_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         _loc10_ = this._cardShowMC.currentFrame;
         if(_loc10_ == 5)
         {
            this._cardShowMC.gotoAndStop(5);
            _loc2_ = this._radomAwardArr[2];
            _loc5_ = CallBackLotteryDrawController.instance.getCardShowFont(_loc2_,"luckeylotterydraw");
            _loc5_.x = -5;
            _loc5_.y = 18;
            this._cardShowMC["c3"].addChild(_loc5_);
            this._cardShowMC.play();
         }
         else if(_loc10_ == 10)
         {
            this._cardShowMC.gotoAndStop(10);
            _loc4_ = 1;
            while(_loc4_ < 6)
            {
               if(_loc4_ != 3)
               {
                  _loc6_ = "c" + _loc4_;
                  _loc2_ = this._radomAwardArr[_loc4_ - 1];
                  _loc7_ = CallBackLotteryDrawController.instance.getCardShowFont(_loc2_,"luckeylotterydraw");
                  _loc7_.x = -5;
                  _loc7_.y = 18;
                  this._cardShowMC[_loc6_].addChild(_loc7_);
               }
               _loc4_++;
            }
            this._cardShowMC.play();
         }
         else if(_loc10_ == this._cardShowMC.totalFrames)
         {
            this._cardShowMC.stop();
            this._cardShowMC.removeEventListener("enterFrame",this.onCardShowEnterFrame);
            this._startDrawBtn.visible = true;
            if(this._model.currPhaseHasGetCount > 0)
            {
               this._startDrawBtn.enable = false;
               this._buyBtnArr = [];
               _loc4_ = 1;
               while(_loc4_ < 6)
               {
                  _loc8_ = "c" + _loc4_;
                  _loc2_ = this._model.awardArr[_loc4_ - 1];
                  if(Boolean(_loc2_["IsCanGet"]))
                  {
                     _loc9_ = UICreatShortcut.creatAndAdd("luckeylotterydraw.buyBtn",this._cardShowMC[_loc8_]);
                     _loc9_.addEventListener("click",this.onBtnClick);
                     this._buyBtnArr.push(_loc9_);
                  }
                  else
                  {
                     this._buyBtnArr.push(null);
                     UICreatShortcut.creatAndAdd("luckeylotterydraw.pic7",this._cardShowMC[_loc8_]);
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      private function playCardShuffle() : void
      {
         ObjectUtils.disposeObject(this._cardShowMC);
         this._cardShuffleMC = ComponentFactory.Instance.creat("luckeylotterydraw.cardShuffle");
         PositionUtils.setPos(this._cardShuffleMC,"luckeylotterydraw.cardShuffle.pos");
         addToContent(this._cardShuffleMC);
         this._cardShuffleMC.addEventListener("enterFrame",this.onCardShuffleEnterFrame);
      }
      
      private function onCardShuffleEnterFrame(param1:Event) : void
      {
         var _loc2_:int = this._cardShuffleMC.currentFrame;
         if(_loc2_ == this._cardShuffleMC.totalFrames)
         {
            this._cardShuffleMC.removeEventListener("enterFrame",this.onCardShuffleEnterFrame);
            this._cardShuffleMC.parent.removeChild(this._cardShuffleMC);
            this.onCardShuffleOver();
         }
      }
      
      private function onCardShuffleOver() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._cardOpenItemArr = [];
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new LuckeyCardOpenItem(_loc1_,47 + _loc1_ * 123,85);
            addToContent(_loc2_);
            this._cardOpenItemArr.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function onClickCardOpenItem(param1:CEvent) : void
      {
         var _loc2_:* = undefined;
         this._clickCardOpenItem = param1.data as LuckeyCardOpenItem;
         for each(_loc2_ in this._cardOpenItemArr)
         {
            _loc2_.mouseEnabled = false;
         }
      }
      
      private function onCardOpenPlayOver(param1:Event) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._cardOpenItemArr)
         {
            if(_loc2_ != this._clickCardOpenItem)
            {
               _loc2_.playCardOpen();
            }
         }
         TweenLite.delayedCall(_loc2_.getMCTotalFrames() + 5,this.onAllCardOpenPlayOver,null,true);
      }
      
      private function onAllCardOpenPlayOver() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._cardOpenItemArr)
         {
            _loc1_.mouseEnabled = true;
            _loc1_.mouseChildren = true;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.responseHandler);
         this._startDrawBtn.addEventListener("click",this.onBtnClick);
         CallBackLotteryDrawManager.instance.addEventListener("click_card_open_item",this.onClickCardOpenItem);
         CallBackLotteryDrawManager.instance.addEventListener("click_card_open_play_over",this.onCardOpenPlayOver);
         CallBackLotteryDrawManager.instance.addEventListener("event_info_change",this.onInfoChange);
         CallBackLotteryDrawManager.instance.addEventListener("event_op_back_buy",this.onBuy);
      }
      
      private function removeEvent() : void
      {
         var _loc1_:* = undefined;
         removeEventListener("response",this.responseHandler);
         this._startDrawBtn.removeEventListener("click",this.onBtnClick);
         this._cardShowMC && this._cardShowMC.removeEventListener("enterFrame",this.onCardShowEnterFrame);
         this._cardShuffleMC && this._cardShuffleMC.removeEventListener("enterFrame",this.onCardShuffleEnterFrame);
         CallBackLotteryDrawManager.instance.removeEventListener("click_card_open_item",this.onClickCardOpenItem);
         CallBackLotteryDrawManager.instance.removeEventListener("click_card_open_play_over",this.onCardOpenPlayOver);
         CallBackLotteryDrawManager.instance.removeEventListener("event_info_change",this.onInfoChange);
         CallBackLotteryDrawManager.instance.removeEventListener("event_op_back_buy",this.onBuy);
         TweenLite.killTweensOf(this.onAllCardOpenPlayOver);
         this._timer && this._timer.removeEventListener("timer",this.onTimerTick);
         this._timer && this._timer.stop();
         if(Boolean(this._buyBtnArr))
         {
            for each(_loc1_ in this._buyBtnArr)
            {
               _loc1_ && _loc1_.removeEventListener("click",this.onBtnClick);
            }
         }
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         var target:*;
         var onAlertFrameResponse:* = undefined;
         var onCheckComplete:* = undefined;
         var index:int = 0;
         var award:Object = null;
         var newPrice:int = 0;
         var msg:String = null;
         var _payAlert:BaseAlerFrame = null;
         var evt:MouseEvent = param1;
         SoundManager.instance.playButtonSound();
         target = evt.target;
         if(target == this._startDrawBtn)
         {
            this._startDrawBtn.enable = false;
            this.playCardShuffle();
         }
         else
         {
            onAlertFrameResponse = function(param1:FrameEvent):void
            {
               if(param1.responseCode == 3 || param1.responseCode == 2)
               {
                  CheckMoneyUtils.instance.checkMoney(_payAlert.isBand,newPrice,onCheckComplete);
               }
               _payAlert.removeEventListener("response",onAlertFrameResponse);
               ObjectUtils.disposeObject(_payAlert);
            };
            onCheckComplete = function():void
            {
               _buyBtnClickIndex = index;
               LayerManager.Instance.addToLayer(_maskSp,3,true,2);
               SocketManager.Instance.out.buyCallLotteryDrawGood(1,award["Index"],CheckMoneyUtils.instance.isBind);
            };
            index = this._buyBtnArr.indexOf(target);
            award = this._model.awardArr[index];
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            newPrice = award["Cost"] * award["LimitCount"] / 100;
            msg = LanguageMgr.GetTranslation("callbacklotterdraw.buyGoodTip",newPrice,award["InventoryItemInfo"].Name);
            _payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true,1);
            _payAlert.enterEnable = false;
            _payAlert.addEventListener("response",onAlertFrameResponse);
         }
      }
      
      private function onBuy(param1:CEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Object = param1.data;
         if(_loc3_.index == this._buyBtnClickIndex)
         {
            if(Boolean(_loc3_.res))
            {
               _loc2_ = this._buyBtnArr[this._buyBtnClickIndex];
               _loc2_.visible = false;
               UICreatShortcut.creatAndAdd("luckeylotterydraw.pic7",_loc2_.parent);
            }
            this._maskSp.parent.removeChild(this._maskSp);
         }
      }
      
      private function responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            CallBackLotteryDrawController.instance.disposeFrame();
         }
      }
      
      override public function dispose() : void
      {
         this._manager.checkLuckeyActiveOpen();
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         this._nextCDTimeTf = null;
         this._cardShowMC = null;
         this._cardShuffleMC = null;
         this._cardOpenItemArr = null;
         this._clickCardOpenItem = null;
         this._startDrawBtn = null;
         this._manager = null;
         this._model = null;
         this._timer = null;
         this._buyBtnArr = null;
         this._maskSp = null;
      }
   }
}

