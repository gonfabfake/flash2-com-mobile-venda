package Indiana
{
   import Indiana.analyzer.IndianaGoodsItemInfo;
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.model.IndianaShowData;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.NumberImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import road7th.utils.DateUtils;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class IndianaInfoPanel extends Sprite implements Disposeable
   {
      
      private var _progressBar:IndianaProgressBar;
      
      private var _hasJoin:FilterFrameText;
      
      private var _totleJoin:FilterFrameText;
      
      private var _line:MutipleImage;
      
      private var _timesDis:FilterFrameText;
      
      private var _timesDis1:FilterFrameText;
      
      private var _timesDisII:FilterFrameText;
      
      private var _times:TextInput;
      
      private var _timesBg:ScaleBitmapImage;
      
      private var _addTimeBtn:BaseButton;
      
      private var _subtractTimeBtn:BaseButton;
      
      private var _timeHelpBtn:BaseButton;
      
      private var _indianaBtn:BaseButton;
      
      private var _indianaDis:FilterFrameText;
      
      private var _lookNumSelf:FilterFrameText;
      
      private var _indianaDisII:FilterFrameText;
      
      private var _countDown:MovieClip;
      
      private var _scoller:ScrollPanel;
      
      private var _secondNum01:NumberImage;
      
      private var _secondNum02:NumberImage;
      
      private var _minuteNum01:NumberImage;
      
      private var _minuteNum02:NumberImage;
      
      private var _hourNum01:NumberImage;
      
      private var _hourNum02:NumberImage;
      
      private var _hourNum03:NumberImage;
      
      private var _itemDisBg:Bitmap;
      
      private var _info:IndianaShopItemInfo;
      
      private var _itemInfo:IndianaGoodsItemInfo;
      
      private var _timer:TimerJuggler;
      
      private var _countDownDate:Number;
      
      private var _endtimer:Date;
      
      private var showdata:IndianaShowData;
      
      private var countDownComplete:Boolean = false;
      
      private var baseAlerFrame:BaseAlerFrame;
      
      private var time:int;
      
      public function IndianaInfoPanel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._hasJoin = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         this._totleJoin = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         PositionUtils.setPos(this._totleJoin,"indiana.totlejoin.pos");
         this._line = ComponentFactory.Instance.creatComponentByStylename("indiana.line");
         this._countDown = ComponentFactory.Instance.creat("asset.countDown.bg");
         PositionUtils.setPos(this._countDown,"indiana.countDown.pos");
         this._timesDis = ComponentFactory.Instance.creatComponentByStylename("indiana.timesDisI.Txt");
         this._timesDis.text = LanguageMgr.GetTranslation("Indiana.join.count");
         this._timesDis1 = ComponentFactory.Instance.creatComponentByStylename("indiana.timesDisI.Txt");
         this._timesDis1.text = LanguageMgr.GetTranslation("Indiana.join.count1");
         PositionUtils.setPos(this._timesDis1,"indiana.timesDisI.Txt.pos");
         this._timesDisII = ComponentFactory.Instance.creatComponentByStylename("indiana.timesDisII.Txt");
         this._timesDisII.text = LanguageMgr.GetTranslation("Indiana.infopanel.dis");
         this._timesBg = ComponentFactory.Instance.creatComponentByStylename("indiana.timesTxt.bg");
         this._times = ComponentFactory.Instance.creatComponentByStylename("indiana.timesDisI.inputTxt");
         PositionUtils.setPos(this._times,"itemDisII.pos");
         this._addTimeBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.addTimebtn");
         this._subtractTimeBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.subtractTimebtn");
         this._indianaBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.btn");
         this._indianaDis = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         this._indianaDis.htmlText = LanguageMgr.GetTranslation("Indiana.infopanel.disII");
         this._lookNumSelf = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         this._lookNumSelf.mouseEnabled = true;
         this._lookNumSelf.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCode");
         PositionUtils.setPos(this._lookNumSelf,"indiana.infopanel.lookself.pos");
         this._indianaDisII = ComponentFactory.Instance.creatComponentByStylename("indiana.hasJoin.Txt");
         this._indianaDisII.text = LanguageMgr.GetTranslation("Indiana.infopanel.disIII");
         this._timeHelpBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.timehelpbtn");
         this._timeHelpBtn.tipStyle = "ddt.view.tips.OneLineTip";
         this._timeHelpBtn.tipDirctions = "0";
         PositionUtils.setPos(this._indianaDis,"indiana.Dis.pos");
         PositionUtils.setPos(this._indianaDisII,"indiana.DisII.pos");
         this._progressBar = new IndianaProgressBar();
         this._progressBar.setProgress(0);
         PositionUtils.setPos(this._progressBar,"indiana.progressbar.pos");
         this._secondNum01 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         this._secondNum02 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         this._secondNum01.count = 0;
         this._secondNum02.count = 0;
         PositionUtils.setPos(this._secondNum01,"indiana.countDown.second01pos");
         PositionUtils.setPos(this._secondNum02,"indiana.countDown.second02pos");
         this._minuteNum01 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         this._minuteNum02 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         PositionUtils.setPos(this._minuteNum01,"indiana.countDown.minute01pos");
         PositionUtils.setPos(this._minuteNum02,"indiana.countDown.minute02pos");
         this._minuteNum01.count = 0;
         this._minuteNum02.count = 0;
         this._hourNum01 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         this._hourNum02 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         this._hourNum03 = ComponentFactory.Instance.creatComponentByStylename("indiana.snum");
         PositionUtils.setPos(this._hourNum01,"indiana.countDown.hour01pos");
         PositionUtils.setPos(this._hourNum02,"indiana.countDown.hour02pos");
         PositionUtils.setPos(this._hourNum03,"indiana.countDown.hour03pos");
         this._hourNum01.count = 0;
         this._hourNum02.count = 0;
         this._hourNum03.count = 0;
         this._timer = TimerManager.getInstance().addTimerJuggler(1000,10000);
         this._timer.stop();
         addChild(this._hasJoin);
         addChild(this._totleJoin);
         addChild(this._line);
         addChild(this._timesDis);
         addChild(this._timesDis1);
         addChild(this._timesDisII);
         addChild(this._timesBg);
         addChild(this._times);
         addChild(this._addTimeBtn);
         addChild(this._subtractTimeBtn);
         addChild(this._timeHelpBtn);
         addChild(this._indianaBtn);
         addChild(this._indianaDis);
         addChild(this._indianaDisII);
         addChild(this._countDown);
         addChild(this._secondNum01);
         addChild(this._secondNum02);
         addChild(this._minuteNum01);
         addChild(this._minuteNum02);
         addChild(this._hourNum01);
         addChild(this._hourNum02);
         addChild(this._hourNum03);
         addChild(this._progressBar);
         addChild(this._lookNumSelf);
      }
      
      private function initEvent() : void
      {
         this._addTimeBtn.addEventListener("click",this.__addClickHandler);
         this._subtractTimeBtn.addEventListener("click",this.__subClickHandler);
         this._indianaBtn.addEventListener("click",this.__indianaBtnClickHandler);
         this._timer.addEventListener("timer",this.__TimerHander);
         this._timer.addEventListener("timerComplete",this.__TimerCompleteHander);
         this._lookNumSelf.addEventListener("link",this.__linkHandler);
         this._times.addEventListener("textInput",this.__inputHandler);
         this._times.addEventListener("focusOut",this.__outFocusHandler);
         this._times.addEventListener("mouseOver",this.__overTimeHandler);
         this._times.addEventListener("mouseOut",this.__outTimeHandler);
         this._times.addEventListener("change",this.__txtChangeHandler);
      }
      
      private function __overTimeHandler(param1:MouseEvent) : void
      {
      }
      
      private function __outTimeHandler(param1:MouseEvent) : void
      {
      }
      
      private function __txtChangeHandler(param1:Event) : void
      {
         this.setTimesTips();
      }
      
      private function setTimesTips() : void
      {
         var _loc1_:int = int(this._times.text);
         var _loc2_:int = this._itemInfo.Cost / 100;
         var _loc3_:* = Number(int(_loc1_ / _loc2_ * 1000) / 10);
         if(_loc3_ < 0.1)
         {
            _loc3_ = 0.1;
         }
         this._times.tipData = LanguageMgr.GetTranslation("Indiana.resoult.getPro",_loc3_.toString() + "%");
      }
      
      private function __outFocusHandler(param1:FocusEvent) : void
      {
         if(this._times.text == "")
         {
            this._times.text = "1";
         }
      }
      
      private function __inputHandler(param1:TextEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         param1.preventDefault();
         if(isNaN(Number(param1.text)))
         {
            param1.text = "";
            this.setTimesTips();
         }
         else
         {
            _loc3_ = _loc2_ = this._times.text + param1.text;
            _loc4_ = this._itemInfo.Cost / 100 - this.showdata.buyNumber;
            _loc5_ = _loc4_;
            if(_loc3_ < _loc5_)
            {
               if(_loc3_ / this._info.MinBuyTimes == 0)
               {
                  this._times.appendText(param1.text);
               }
               else if(_loc3_ < this._info.MinBuyTimes)
               {
                  this._times.text = this._info.MinBuyTimes.toString();
               }
               else
               {
                  this._times.text = int(Math.floor(_loc3_ / this._info.MinBuyTimes)).toString();
               }
               this.setTimesTips();
            }
            else
            {
               this._times.text = _loc5_.toString();
               this.setTimesTips();
            }
         }
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
         SocketManager.Instance.out.sendIndianaCode(this.showdata.per_id,_loc2_);
      }
      
      private function __TimerHander(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._countDownDate > 0)
         {
            this._countDownDate -= 1000;
            if(this._countDownDate / 3600000 > 0)
            {
               _loc4_ = this._countDownDate / 3600000;
            }
            if(this._countDownDate / 60000 > 0)
            {
               _loc3_ = this._countDownDate / 60000 - _loc4_ * 60;
            }
            if(this._countDownDate % 60000 / 1000 > 0)
            {
               _loc2_ = this._countDownDate % 60000 / 1000;
            }
            if(_loc4_ == 0 && _loc3_ == 0 && _loc2_ == 0)
            {
               this.countDownComplete = true;
               SocketManager.Instance.out.sendUpdateSysDate();
               SocketManager.Instance.out.sendIndianaEnterGame(0);
            }
            this.setDownValue(_loc2_,_loc3_,_loc4_);
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
            if(param3 > 9 && param3 < 99)
            {
               this._hourNum01.count = int(param3.toString().charAt(1));
               this._hourNum02.count = int(param3.toString().charAt(0));
               this._hourNum03.count = 0;
            }
            else if(param3 > 99)
            {
               this._hourNum01.count = int(param3.toString().charAt(2));
               this._hourNum02.count = int(param3.toString().charAt(1));
               this._hourNum03.count = int(param3.toString().charAt(0));
            }
            else
            {
               this._hourNum01.count = param3;
               this._hourNum02.count = 0;
               this._hourNum03.count = 0;
            }
         }
         else
         {
            this._hourNum01.count = 0;
            this._hourNum02.count = 0;
            this._hourNum03.count = 0;
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
      
      public function setInfo(param1:IndianaShopItemInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         this._info = param1;
         if(Boolean(this._info))
         {
            this._itemInfo = IndianaDataManager.instance.getIndianaGoodsItemInfoByshopId(this._info.ShopId);
            this.showdata = IndianaDataManager.instance.currentShowData;
            _loc2_ = this._itemInfo.Cost / 100;
            _loc3_ = this.showdata.buyNumber;
            _loc4_ = _loc3_ / _loc2_;
            this._times.maxChars = this._info.MinBuyTimes * 10;
            if(this._info.MinBuyTimes > 1)
            {
               this._timeHelpBtn.visible = true;
               this._timeHelpBtn.tipData = LanguageMgr.GetTranslation("Indiana.buy.dis",this._info.MinBuyTimes);
            }
            else
            {
               this._timeHelpBtn.visible = false;
            }
            this._endtimer = DateUtils.decodeDated(this._info.EndTime);
            this._countDownDate = this._endtimer.time - TimeManager.Instance.Now().time;
            if(this.showdata.joinCount > 0)
            {
               this._indianaDis.htmlText = LanguageMgr.GetTranslation("Indiana.resoult.checkSelfCodeII",this.showdata.joinCount);
               this._lookNumSelf.visible = true;
            }
            else
            {
               this._indianaDis.htmlText = LanguageMgr.GetTranslation("Indiana.infopanel.disII");
               this._lookNumSelf.visible = false;
            }
            this._hasJoin.text = LanguageMgr.GetTranslation("Indiana.has.join.count",_loc3_);
            this._totleJoin.text = LanguageMgr.GetTranslation("Indiana.totle.count",_loc2_);
            this._progressBar.setProgress(_loc4_);
            this._times.text = this._info.MinBuyTimes.toString();
            this.setTimesTips();
            if(!this._timer.running)
            {
               this._timer.start();
            }
            if(_loc4_ == 1)
            {
               SocketManager.Instance.out.sendIndianaEnterGame(0);
            }
         }
      }
      
      private function __indianaBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         if(Boolean(this._info))
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this.time = int(this._times.text);
            _loc2_ = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"));
            _loc3_ = IndianaDataManager.instance.getIndianaGoodsItemInfoByshopId(this._info.ShopId);
            if(Boolean(_loc3_))
            {
               if(_loc3_.IsBindMoney == 0)
               {
                  _loc4_ = LanguageMgr.GetTranslation("Indiana.propt.money",this.time * 100,LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text2"));
                  _loc2_.data = _loc4_;
                  this.baseAlerFrame = AlertManager.Instance.alert("SimpleAlert",_loc2_,2);
                  this.baseAlerFrame.addEventListener("response",this.__frameEvent);
               }
               else
               {
                  _loc5_ = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text2") + "(" + LanguageMgr.GetTranslation("consortion.skillFrame.richesText3") + ")";
                  _loc4_ = LanguageMgr.GetTranslation("Indiana.propt.money",this.time * 100,_loc5_);
                  _loc6_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),_loc4_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2,null,"SimpleAlert",60,false);
                  _loc6_.addEventListener("response",this.__onAlertBuyStiveFrame);
               }
            }
         }
      }
      
      private function __onAlertBuyStiveFrame(param1:FrameEvent) : void
      {
         var e:FrameEvent = param1;
         var alertFrame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         alertFrame.removeEventListener("response",this.__onAlertBuyStiveFrame);
         if(e.responseCode == 2 || e.responseCode == 3)
         {
            CheckMoneyUtils.instance.checkMoney(alertFrame.isBand,this.time * 100,function():void
            {
               SocketManager.Instance.out.sendIndiana(_info.PeriodId,time,CheckMoneyUtils.instance.isBind);
               if(IndianaDataManager.instance.updataRecode)
               {
                  SocketManager.Instance.out.sendIndianaCurrentData(_info.PeriodId);
               }
            });
         }
         alertFrame.dispose();
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var evt:FrameEvent = param1;
         this.baseAlerFrame.removeEventListener("response",this.__frameEvent);
         ObjectUtils.disposeObject(this.baseAlerFrame);
         this.baseAlerFrame = null;
         SoundManager.instance.play("008");
         switch(int(evt.responseCode) - 2)
         {
            case 0:
            case 1:
               CheckMoneyUtils.instance.checkMoney(false,this.time * 100,function():void
               {
                  SocketManager.Instance.out.sendIndiana(_info.PeriodId,time,false);
                  if(IndianaDataManager.instance.updataRecode)
                  {
                     SocketManager.Instance.out.sendIndianaCurrentData(_info.PeriodId);
                  }
               });
         }
      }
      
      private function __subClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this._times.text);
         if(_loc2_ > this._info.MinBuyTimes)
         {
            _loc2_ -= this._info.MinBuyTimes;
         }
         else
         {
            _loc2_ = this._info.MinBuyTimes;
         }
         this._times.text = _loc2_.toString();
         this.setTimesTips();
      }
      
      private function __addClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = int(this._times.text);
         var _loc3_:int = this._itemInfo.Cost / 100 - this.showdata.buyNumber;
         var _loc4_:* = _loc3_;
         if(_loc2_ < _loc4_)
         {
            _loc2_ += this._info.MinBuyTimes;
         }
         else
         {
            _loc2_ = _loc4_;
         }
         this._times.text = _loc2_.toString();
         this.setTimesTips();
      }
      
      private function removeEvent() : void
      {
         this._addTimeBtn.removeEventListener("click",this.__addClickHandler);
         this._subtractTimeBtn.removeEventListener("click",this.__subClickHandler);
         this._indianaBtn.removeEventListener("click",this.__indianaBtnClickHandler);
         this._timer.removeEventListener("timer",this.__TimerHander);
         this._timer.removeEventListener("timerComplete",this.__TimerCompleteHander);
         this._lookNumSelf.removeEventListener("link",this.__linkHandler);
         this._times.removeEventListener("textInput",this.__inputHandler);
         this._times.removeEventListener("focusOut",this.__outFocusHandler);
         this._times.removeEventListener("change",this.__txtChangeHandler);
         this._times.removeEventListener("mouseOver",this.__overTimeHandler);
         this._times.removeEventListener("mouseOut",this.__outTimeHandler);
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         this.removeEvent();
         TimerManager.getInstance().removeJugglerByTimer(this._timer);
         this._timer = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._hasJoin = null;
         this._totleJoin = null;
         this._line = null;
         this._timesDis = null;
         this._timesDis1 = null;
         this._timesDisII = null;
         this._timesBg = null;
         this._times = null;
         this._addTimeBtn = null;
         this._subtractTimeBtn = null;
         this._timeHelpBtn = null;
         this._indianaBtn = null;
         this._indianaDis = null;
         this._indianaDisII = null;
         this._countDown = null;
         this._secondNum01 = null;
         this._secondNum02 = null;
         this._minuteNum01 = null;
         this._minuteNum02 = null;
         this._hourNum01 = null;
         this._hourNum02 = null;
         this._hourNum03 = null;
         this._progressBar = null;
         this._endtimer = null;
         this._lookNumSelf = null;
      }
   }
}

