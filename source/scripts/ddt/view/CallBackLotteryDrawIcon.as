package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   
   public class CallBackLotteryDrawIcon extends Sprite implements Disposeable
   {
      
      private var _activityIcon:Bitmap;
      
      private var _leftTimeTf:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _firstEnterCdSec:int;
      
      public function CallBackLotteryDrawIcon()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._activityIcon = ComponentFactory.Instance.creat("asset.hall.callBackLotteryDrawIcon1");
         this.buttonMode = true;
         this.useHandCursor = true;
         addChild(this._activityIcon);
         this._leftTimeTf = ComponentFactory.Instance.creat("bossbox.TimeBoxStyle");
         this._leftTimeTf.x = this._activityIcon.x + (this._activityIcon.width - this._leftTimeTf.width) / 2;
         this._leftTimeTf.y = this._activityIcon.y + 1;
         addChild(this._leftTimeTf);
         this._firstEnterCdSec = CallBackLotteryDrawManager.instance.getCallBackLeftSec();
         if(this._firstEnterCdSec > 0)
         {
            this._timer = new Timer(1000,this._firstEnterCdSec);
            this._timer.addEventListener("timer",this.onTimerTick);
            this._timer.start();
         }
         this.updateLeftTimeTf();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         --this._firstEnterCdSec;
         if(this._firstEnterCdSec <= 0)
         {
            this._firstEnterCdSec = 0;
            this._timer.stop();
            this._timer.removeEventListener("timer",this.onTimerTick);
         }
         this.updateLeftTimeTf();
      }
      
      private function updateLeftTimeTf() : void
      {
         var _loc1_:Array = TimeManager.getHHMMSSArr(this._firstEnterCdSec);
         if(Boolean(_loc1_))
         {
            this._leftTimeTf.text = _loc1_.join(":");
         }
         else
         {
            this._leftTimeTf.text = "";
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener("click",this.showFrame);
      }
      
      protected function showFrame(param1:MouseEvent) : void
      {
         var _loc2_:int = CallBackLotteryDrawManager.instance.callBackLotteryDrawModel.phase;
         if(this._firstEnterCdSec <= 0 && _loc2_ == 0 || this._firstEnterCdSec >= 0 && _loc2_ > 0)
         {
            SoundManager.instance.playButtonSound();
            CallBackLotteryDrawManager.instance.type = 0;
            CallBackLotteryDrawManager.instance.show();
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener("click",this.showFrame);
         this._timer && this._timer.removeEventListener("timer",this.onTimerTick);
         this._timer && this._timer.stop();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._activityIcon);
         this._activityIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

