package farm.viewx.poultry
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.PkgEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class WakeFeedCountDown extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _wakeFeed:ScaleFrameImage;
      
      private var _timeText:FilterFrameText;
      
      private var _cdTime:Number;
      
      private var _feedTimer:Timer;
      
      private var _lastClick:Number = 0;
      
      public function WakeFeedCountDown()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.countdown.bg");
         addChild(this._bg);
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.countdownTime");
         addChild(this._timeText);
         this._wakeFeed = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.wakefeedBtn");
         addChild(this._wakeFeed);
         this.creatTimer();
      }
      
      private function creatTimer() : void
      {
         this._feedTimer = new Timer(1000);
         this._feedTimer.addEventListener("timer",this.__onTimer);
      }
      
      protected function __onTimer(param1:TimerEvent) : void
      {
         --this._cdTime;
         if(this._cdTime > 0)
         {
            this._timeText.text = this.transSecond(this._cdTime);
         }
         else
         {
            this._bg.visible = this._timeText.visible = false;
            this._feedTimer.stop();
         }
      }
      
      public function setCountDownTime(param1:Date) : void
      {
         var _loc2_:Number = param1.time - TimeManager.Instance.Now().time;
         if(_loc2_ <= 0)
         {
            this._bg.visible = this._timeText.visible = false;
            this._feedTimer.stop();
         }
         else
         {
            this._bg.visible = this._timeText.visible = true;
            this._cdTime = _loc2_ / 1000;
            if(!this._feedTimer.running)
            {
               this._timeText.text = this.transSecond(this._cdTime);
               this._feedTimer.start();
            }
         }
      }
      
      private function transSecond(param1:Number) : String
      {
         var _loc2_:int = Math.floor(param1 / 3600);
         var _loc3_:int = Math.floor((param1 - _loc2_ * 3600) / 60);
         var _loc4_:int = param1 - _loc2_ * 3600 - _loc3_ * 60;
         return String("0" + _loc2_).substr(-2) + ":" + String("0" + _loc3_).substr(-2) + ":" + String("0" + _loc4_).substr(-2);
      }
      
      protected function __onWakeFeedClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._wakeFeed.getFrame == 1)
         {
            if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
            {
               if(getTimer() - this._lastClick > 5000)
               {
                  this._lastClick = getTimer();
                  SocketManager.Instance.out.inviteWakeFarmPoultry();
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.poultry.wakefeedLimitTxt"));
               }
            }
            else
            {
               SocketManager.Instance.out.wakeFarmPoultry(FarmModelController.instance.model.currentFarmerId);
            }
         }
         else
         {
            SocketManager.Instance.out.feedFarmPoultry(FarmModelController.instance.model.currentFarmerId);
         }
      }
      
      protected function __onFeedOver(param1:PkgEvent) : void
      {
         FarmModelController.instance.updateFriendListStolen();
      }
      
      public function setFrame(param1:int) : void
      {
         this._wakeFeed.setFrame(param1);
         this._bg.visible = this._timeText.visible = param1 != 1;
      }
      
      public function set tipData(param1:*) : void
      {
         this._wakeFeed.tipData = param1;
      }
      
      private function initEvent() : void
      {
         this._wakeFeed.addEventListener("click",this.__onWakeFeedClick);
         SocketManager.Instance.addEventListener(PkgEvent.format(81,33),this.__onFeedOver);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._wakeFeed))
         {
            this._wakeFeed.removeEventListener("click",this.__onWakeFeedClick);
         }
         SocketManager.Instance.removeEventListener(PkgEvent.format(81,33),this.__onFeedOver);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._wakeFeed))
         {
            this._wakeFeed.dispose();
            this._wakeFeed = null;
         }
         if(Boolean(this._timeText))
         {
            this._timeText.dispose();
            this._timeText = null;
         }
         if(Boolean(this._feedTimer))
         {
            this._feedTimer.removeEventListener("timer",this.__onTimer);
            this._feedTimer.stop();
            this._feedTimer = null;
         }
      }
   }
}

