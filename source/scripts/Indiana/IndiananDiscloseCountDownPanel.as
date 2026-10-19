package Indiana
{
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.model.IndianaShowData;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.NumberImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
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
   import flash.events.TextEvent;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class IndiananDiscloseCountDownPanel extends Sprite implements Disposeable
   {
      
      private var _coutDown:MovieClip;
      
      private var _isMeImag:Bitmap;
      
      private var _line:MutipleImage;
      
      private var _hasNum:FilterFrameText;
      
      private var _linkNum:FilterFrameText;
      
      private var _secondNum01:NumberImage;
      
      private var _secondNum02:NumberImage;
      
      private var _minuteNum01:NumberImage;
      
      private var _minuteNum02:NumberImage;
      
      private var _hourNum01:NumberImage;
      
      private var _hourNum02:NumberImage;
      
      private var _info:IndianaShopItemInfo;
      
      private var _timer:TimerJuggler;
      
      private var _countDownDate:Number = 0;
      
      private var _endtimer:Date;
      
      private var _showdata:IndianaShowData;
      
      private var countDownComplete:Boolean = false;
      
      private var baseAlerFrame:BaseAlerFrame;
      
      public function IndiananDiscloseCountDownPanel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._coutDown = ComponentFactory.Instance.creat("asset.countDown.resoult.bg");
         PositionUtils.setPos(this._coutDown,"indiana.countDownII.pos");
         this._isMeImag = ComponentFactory.Instance.creatBitmap("asset.indiana.isMe");
         this._line = ComponentFactory.Instance.creatComponentByStylename("indiana.line_1");
         this._hasNum = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         PositionUtils.setPos(this._hasNum,"indiana.hasNum.pos");
         this._hasNum.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCodeII");
         this._linkNum = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         PositionUtils.setPos(this._linkNum,"indiana.hasNumII.pos");
         this._linkNum.mouseEnabled = true;
         this._secondNum01 = ComponentFactory.Instance.creatComponentByStylename("indiana.bnum");
         this._secondNum02 = ComponentFactory.Instance.creatComponentByStylename("indiana.bnum");
         this._secondNum01.count = 0;
         this._secondNum02.count = 0;
         this._minuteNum01 = ComponentFactory.Instance.creatComponentByStylename("indiana.bnum");
         this._minuteNum02 = ComponentFactory.Instance.creatComponentByStylename("indiana.bnum");
         this._minuteNum01.count = 0;
         this._minuteNum02.count = 0;
         this._hourNum01 = ComponentFactory.Instance.creatComponentByStylename("indiana.bnum");
         this._hourNum02 = ComponentFactory.Instance.creatComponentByStylename("indiana.bnum");
         this._hourNum01.count = 0;
         this._hourNum02.count = 0;
         PositionUtils.setPos(this._secondNum01,"indiana.countDown.second01pos_1");
         PositionUtils.setPos(this._secondNum02,"indiana.countDown.second02pos_1");
         PositionUtils.setPos(this._minuteNum01,"indiana.countDown.minute01pos_1");
         PositionUtils.setPos(this._minuteNum02,"indiana.countDown.minute02pos_1");
         PositionUtils.setPos(this._hourNum01,"indiana.countDown.hour01pos_1");
         PositionUtils.setPos(this._hourNum02,"indiana.countDown.hour02pos_1");
         this._timer = TimerManager.getInstance().addTimerJuggler(1000,10000);
         this._timer.stop();
         addChild(this._coutDown);
         addChild(this._isMeImag);
         addChild(this._line);
         addChild(this._hasNum);
         addChild(this._secondNum01);
         addChild(this._secondNum02);
         addChild(this._minuteNum01);
         addChild(this._minuteNum02);
         addChild(this._hourNum01);
         addChild(this._hourNum02);
         addChild(this._linkNum);
      }
      
      public function setInfo(param1:IndianaShopItemInfo) : void
      {
         var _loc2_:* = null;
         this._info = param1;
         if(Boolean(this._info))
         {
            this._showdata = IndianaDataManager.instance.currentShowData;
            _loc2_ = TimeManager.Instance.Now();
            this._countDownDate = (this._showdata.humanFullTime.time - _loc2_.time) / 1000 + this._info.CountDown;
            this._timer.start();
            if(this._showdata.joinCount > 0)
            {
               this._linkNum.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCode");
               this._hasNum.text = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCodeII",this._showdata.joinCount);
               this._linkNum.x = this._hasNum.x + this._hasNum.textWidth + 3;
            }
            else
            {
               this._hasNum.text = LanguageMgr.GetTranslation("Indiana.infopanel.disIII");
               this._linkNum.text = "";
            }
         }
      }
      
      private function initEvent() : void
      {
         this._timer.addEventListener("timer",this.__TimerHander);
         this._timer.addEventListener("timerComplete",this.__TimerCompleteHander);
         this._linkNum.addEventListener("link",this.__linkHandler);
      }
      
      public function stopTime() : void
      {
      }
      
      private function __linkHandler(param1:TextEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.text.split("|");
         _loc4_ = _loc3_[0];
         if(_loc4_ == "clickother")
         {
            _loc2_ = int(_loc3_[1]);
         }
         if(_loc4_ == "clickself")
         {
            _loc2_ = PlayerManager.Instance.Self.ID;
         }
         SocketManager.Instance.out.sendIndianaCode(this._showdata.per_id,_loc2_);
      }
      
      private function removeEvent() : void
      {
         this._timer.removeEventListener("timer",this.__TimerHander);
         this._timer.removeEventListener("timerComplete",this.__TimerCompleteHander);
         this._linkNum.removeEventListener("link",this.__linkHandler);
      }
      
      private function __TimerHander(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._countDownDate > 0)
         {
            --this._countDownDate;
            if(this._countDownDate / 3600 > 0)
            {
               _loc4_ = this._countDownDate / 3600;
            }
            if(this._countDownDate / 60 > 0)
            {
               _loc3_ = this._countDownDate / 60;
            }
            if(this._countDownDate % 60 > 0)
            {
               _loc2_ = this._countDownDate % 60;
            }
            if(_loc4_ == 0 && _loc3_ == 0 && _loc2_ == 0)
            {
               this.countDownComplete = true;
               if(Boolean(this._timer))
               {
                  this._timer.stop();
               }
               this.alert();
            }
            this.setDownValue(_loc2_,_loc3_,_loc4_);
         }
      }
      
      private function alert() : void
      {
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
         _loc1_.data = LanguageMgr.GetTranslation("Indiana.update.view");
         this.baseAlerFrame = AlertManager.Instance.alert("SimpleAlert",_loc1_,2);
         this.baseAlerFrame.addEventListener("response",this.__frameEvent);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         this.baseAlerFrame.removeEventListener("response",this.__frameEvent);
         ObjectUtils.disposeObject(this.baseAlerFrame);
         this.baseAlerFrame = null;
         SoundManager.instance.play("008");
         switch(int(param1.responseCode) - 2)
         {
            case 0:
            case 1:
               SocketManager.Instance.out.sendUpdateSysDate();
               SocketManager.Instance.out.sendIndianaEnterGame(0);
         }
      }
      
      private function setDownValue(param1:int, param2:int, param3:int) : void
      {
         if(param1 > 0)
         {
            if(param1 > 9)
            {
               this._secondNum01.count = int(param1.toString().charAt(1));
               this._secondNum02.count = int(param1.toString().charAt(0));
            }
            else
            {
               this._secondNum01.count = param1;
               this._secondNum02.count = 0;
            }
         }
         else
         {
            this._secondNum01.count = 0;
            this._secondNum02.count = 0;
         }
         if(param2 > 0)
         {
            if(param2 > 9)
            {
               this._minuteNum01.count = int(param2.toString().charAt(1));
               this._minuteNum02.count = int(param2.toString().charAt(0));
            }
            else
            {
               this._minuteNum01.count = param2;
               this._minuteNum02.count = 0;
            }
         }
         else
         {
            this._minuteNum01.count = 0;
            this._minuteNum02.count = 0;
         }
         if(param3 > 0)
         {
            if(param3 > 9)
            {
               this._hourNum01.count = int(param3.toString().charAt(1));
               this._hourNum02.count = int(param3.toString().charAt(0));
            }
            else
            {
               this._hourNum01.count = param3;
               this._hourNum02.count = 0;
            }
         }
         else
         {
            this._hourNum01.count = 0;
            this._hourNum02.count = 0;
         }
      }
      
      private function __TimerCompleteHander(param1:Event) : void
      {
         if(this.countDownComplete)
         {
            this._timer.stop();
            this.countDownComplete = false;
         }
         else
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.baseAlerFrame))
         {
            this.baseAlerFrame.removeEventListener("response",this.__frameEvent);
            this.baseAlerFrame.dispose();
            this.baseAlerFrame = null;
         }
         TimerManager.getInstance().removeJugglerByTimer(this._timer);
         this._timer = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._hourNum01 = null;
         this._hourNum02 = null;
         this._minuteNum01 = null;
         this._minuteNum02 = null;
         this._secondNum01 = null;
         this._secondNum02 = null;
         this._coutDown = null;
         this._isMeImag = null;
         this._line = null;
         this._hasNum = null;
         this._linkNum = null;
      }
   }
}

