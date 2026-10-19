package welfareCenter.callBackLotteryDraw.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   import welfareCenter.callBackLotteryDraw.LotteryDrawModel;
   
   public class CallBackLotteryDrawInitSp extends Sprite implements Disposeable
   {
      
      private var _nextCDTimeTf:FilterFrameText;
      
      private var _timer:Timer;
      
      private var _leftSec:int;
      
      private var _offsetLeftSec:int;
      
      private var _bg:Bitmap;
      
      private var _startDrawBtn:SimpleBitmapButton;
      
      private var _manager:CallBackLotteryDrawManager;
      
      private var _model:LotteryDrawModel;
      
      public function CallBackLotteryDrawInitSp()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._bg = UICreatShortcut.creatAndAdd("callbacklotterydraw.pic1",this);
         this._manager = CallBackLotteryDrawManager.instance;
         this._model = this._manager.callBackLotteryDrawModel;
         this._nextCDTimeTf = UICreatShortcut.creatAndAdd("callbacklotterydraw.nextCDTimeTf",this);
         _loc1_ = 1;
         while(_loc1_ <= 5)
         {
            _loc2_ = UICreatShortcut.creatAndAdd("callbacklotterydraw.pic5",this);
            PositionUtils.setPos(_loc2_,"callbacklotterydraw.cardBackSidePos" + _loc1_);
            _loc1_++;
         }
         this._startDrawBtn = UICreatShortcut.creatAndAdd("callbacklotterydraw.startDrawBtn",this);
         this._startDrawBtn.enable = false;
         this.onInfoChange(null);
      }
      
      private function onInfoChange(param1:Event) : void
      {
         this._leftSec = this._manager.getCallBackLeftSec();
         this._offsetLeftSec = this._leftSec + 2;
         if(this._offsetLeftSec > 0)
         {
            if(Boolean(this._timer))
            {
               this._timer.reset();
               this._timer.delay = 1000;
               this._timer.repeatCount = this._offsetLeftSec;
               this._timer.addEventListener("timer",this.onTimerTick);
               this._timer.start();
            }
            else
            {
               this._timer = new Timer(1000,this._offsetLeftSec);
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
         }
         --this._offsetLeftSec;
         if(this._offsetLeftSec <= 0)
         {
            this._offsetLeftSec = 0;
            this._timer.removeEventListener("timer",this.onTimerTick);
            this._timer.stop();
            if(this._model.phase == 0)
            {
               this._manager.queryLotteryGoods(0);
            }
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
      
      public function dispose() : void
      {
         this._timer && this._timer.removeEventListener("timer",this.onTimerTick);
         this._timer && this._timer.stop();
         ObjectUtils.disposeAllChildren(this);
         this._nextCDTimeTf = null;
         this._timer = null;
         this._bg = null;
         this._startDrawBtn = null;
         this._manager = null;
         this._model = null;
      }
   }
}

