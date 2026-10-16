package welfareCenter.icon
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.TimeManager;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   
   public class WelfareCenterItemTime extends WelfareCenterItem
   {
      
      private var _leftTimeTf:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _firstEnterCdSec:int;
      
      public function WelfareCenterItemTime(param1:int)
      {
         super(param1);
      }
      
      override protected function init() : void
      {
         super.init();
         this._leftTimeTf = ComponentFactory.Instance.creat("bossbox.TimeBoxStyle");
         this._leftTimeTf.x = _icon.x + (_icon.width - this._leftTimeTf.width) / 2 - 12;
         this._leftTimeTf.y = _icon.y + 1;
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
      
      override public function get canClick() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = CallBackLotteryDrawManager.instance.callBackLotteryDrawModel.phase;
         if(this._firstEnterCdSec <= 0 && _loc1_ == 0 || _loc1_ > 0)
         {
            return true;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         this._timer && this._timer.removeEventListener("timer",this.onTimerTick);
         this._timer && this._timer.stop();
         super.dispose();
         this._leftTimeTf = null;
         this._timer = null;
      }
   }
}

