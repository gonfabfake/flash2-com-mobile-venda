package welfareCenter.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.DateUtils;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   import welfareCenter.WelfareCenterManager;
   
   public class OldPlayerGradeGiftView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _awardBg:ScaleBitmapImage;
      
      private var _progress:MovieClip;
      
      private var _awardArrow:Bitmap;
      
      private var _giftBtnList:Vector.<OldPlayerGradeGiftBox>;
      
      private var _hBox:HBox;
      
      private var _gainProgress:int;
      
      private var _timeText:FilterFrameText;
      
      private var _timer:TimerJuggler;
      
      private const goodsIDList:Array = [[11025,9024,12559],[11025,40002,313000,12559],[11150,100100,40002,334102,12559,11994],[11150,100100,40002,334102,20150,12559]];
      
      private const goodsCountList:Array = [[20,2,1],[50,10,5,1],[3,30,15,3,2,1],[5,50,20,8,3,3]];
      
      private const gradeList:Array = [12,20,30,35];
      
      public function OldPlayerGradeGiftView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._gainProgress = WelfareCenterManager.instance.gradeGiftProgress;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.welfareCeneter.gift.bg");
         this._awardArrow = ComponentFactory.Instance.creatBitmap("asset.welfareCeneter.gift.awardArrow");
         this._awardBg = ComponentFactory.Instance.creatComponentByStylename("welfareCenter.gift.awardBg");
         this._progress = ComponentFactory.Instance.creat("asset.welfareCeneter.gift.progress");
         this._progress.gotoAndStop(this._gainProgress + 1);
         PositionUtils.setPos(this._progress,"welfareCenter.gradeGiftView.ProgressPos");
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("welfareCenter.gift.hBox");
         this._giftBtnList = new Vector.<OldPlayerGradeGiftBox>();
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("callbacklotterydraw.nextCDTimeTf");
         PositionUtils.setPos(this._timeText,"welfareCenter.gradeGiftView.timeTextPos");
         addChild(this._bg);
         addChild(this._awardBg);
         addChild(this._awardArrow);
         addChild(this._progress);
         addChild(this._hBox);
         addChild(this._timeText);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("welfareCenter.gift.btn" + _loc1_);
            _loc2_.addEventListener("click",this.__onClickGiftBtn);
            addChild(_loc2_);
            this._giftBtnList.push(_loc2_);
            _loc1_++;
         }
         WelfareCenterManager.instance.addEventListener("change",this.__onGainComplete);
         this.updateAwardView(this._gainProgress + 1);
         this.updateGiftView();
         this.__onUpdateTimer(null);
         this._timer = TimerManager.getInstance().addTimerJuggler(1000);
         this._timer.addEventListener("timer",this.__onUpdateTimer);
         this._timer.start();
      }
      
      private function __onGainComplete(param1:Event) : void
      {
         this._giftBtnList[this._gainProgress].isShine = false;
         this._gainProgress = WelfareCenterManager.instance.gradeGiftProgress;
         this.updateGiftView();
      }
      
      public function updateAwardView(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         PositionUtils.setPos(this._awardArrow,"welfareCenter.gradeGiftView.arrowPos" + param1);
         this._hBox.clearAllChild();
         var _loc5_:Array = this.goodsIDList[param1 - 1];
         var _loc6_:Array = this.goodsCountList[param1 - 1];
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            _loc3_ = ItemManager.fillByID(_loc5_[_loc2_]);
            _loc3_.IsBinds = true;
            _loc3_.Count = _loc6_[_loc2_];
            _loc4_ = new BagCell(0,_loc3_);
            _loc4_.width = 70;
            _loc4_.height = 70;
            this._hBox.addChild(_loc4_);
            _loc2_++;
         }
      }
      
      private function __onClickGiftBtn(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         _loc2_ = 0;
         while(_loc2_ < this._giftBtnList.length)
         {
            if(this._giftBtnList[_loc2_] == param1.currentTarget)
            {
               if(_loc2_ == this._gainProgress && this.isGainAward())
               {
                  SocketManager.Instance.out.sendGainOldPlayerGift();
               }
               this.updateAwardView(_loc2_ + 1);
               return;
            }
            _loc2_++;
         }
      }
      
      private function updateGiftView() : void
      {
         var _loc1_:int = 0;
         this._progress.gotoAndStop(this._gainProgress + 1);
         _loc1_ = 0;
         while(_loc1_ < this._gainProgress)
         {
            this._giftBtnList[_loc1_].isGain = true;
            _loc1_++;
         }
         if(PlayerManager.Instance.Self.Grade >= this.gradeList[this._gainProgress])
         {
            this._giftBtnList[this._gainProgress].isShine = true;
         }
      }
      
      private function __onUpdateTimer(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = (WelfareCenterManager.instance.gradeGiftEndTime - TimeManager.Instance.Now().time) / 1000;
         if(_loc3_ > 0)
         {
            _loc2_ = int(DateUtils.dateTimeRemainArr(_loc3_)[0]);
            if(_loc2_ >= 1)
            {
               this._timeText.text = LanguageMgr.GetTranslation("newChickenBox.timePlayTxt") + _loc2_ + LanguageMgr.GetTranslation("day");
            }
            else
            {
               this._timeText.text = LanguageMgr.GetTranslation("newChickenBox.timePlayTxt") + TimeManager.getHHMMSSArr(_loc3_).join(":");
            }
         }
         else
         {
            this._timeText.text = LanguageMgr.GetTranslation("ddt.welfareCenter.gift.activityEnd");
            this.disposeTimer();
         }
      }
      
      private function isGainAward() : Boolean
      {
         var _loc1_:int = int(this.gradeList[this._gainProgress]);
         if(PlayerManager.Instance.Self.Grade >= _loc1_)
         {
            return true;
         }
         return false;
      }
      
      private function cellBg() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,60,60);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      private function disposeTimer() : void
      {
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this.__onUpdateTimer);
            TimerManager.getInstance().removeTimerJuggler(this._timer.id);
            this._timer = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         this.disposeTimer();
         WelfareCenterManager.instance.removeEventListener("change",this.__onGainComplete);
         while(Boolean(this._giftBtnList.length))
         {
            _loc1_ = this._giftBtnList.pop() as BaseButton;
            _loc1_.removeEventListener("click",this.__onClickGiftBtn);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._progress = null;
         this._awardBg = null;
         this._awardArrow = null;
         this._giftBtnList = null;
         this._hBox = null;
         this._timeText = null;
      }
   }
}

