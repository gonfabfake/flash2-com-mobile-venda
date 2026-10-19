package goldmine.views
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.NumberImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import goldmine.GoldmineManager;
   import goldmine.model.GoldmineModel;
   import road7th.utils.MovieClipWrapper;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class GoldmineMainFrame extends Frame
   {
      
      private var _dateStartMonth1:NumberImage;
      
      private var _dateStartMonth2:NumberImage;
      
      private var _datePoint1:Bitmap;
      
      private var _dateStartDay1:NumberImage;
      
      private var _dateStartDay2:NumberImage;
      
      private var _dateIcon:Bitmap;
      
      private var _dateEndMonth1:NumberImage;
      
      private var _dateEndMonth2:NumberImage;
      
      private var _datePoint2:Bitmap;
      
      private var _dateEndDay1:NumberImage;
      
      private var _dateEndDay2:NumberImage;
      
      private var _infoText:Bitmap;
      
      private var _infoWord:FilterFrameText;
      
      private var _mineBtn:BaseButton;
      
      private var _mineTimesText:FilterFrameText;
      
      private var _nextScoreLeft:GradientText;
      
      private var _nextScoreRight:GradientText;
      
      private var _nextScoreText:FilterFrameText;
      
      private var _blackBg:Bitmap;
      
      private var _smallMine:MovieClip;
      
      private var _middleMine:MovieClip;
      
      private var _bigMine:MovieClip;
      
      private var _mineTextList:Vector.<NumberImage>;
      
      private var _smallMineText:NumberImage;
      
      private var _middleMineText:NumberImage;
      
      private var _bigMineText:NumberImage;
      
      private var _mineLight:Bitmap;
      
      private var _mineBaseBtm:Bitmap;
      
      private var _shineMc:MovieClip;
      
      private var _timeRemainTimer:TimerJuggler;
      
      private var _model:GoldmineModel;
      
      private var _lightPos:Vector.<Point>;
      
      private var _shinePos:Vector.<Point>;
      
      private var _btmPos:Vector.<Point>;
      
      private var _mineMc:Vector.<MovieClip>;
      
      private var _index:int = -1;
      
      private var _lastScore:int = 0;
      
      private var _clickNum:Number = 0;
      
      private var currentIndex:int = 0;
      
      private var _filter:Array = ComponentFactory.Instance.creatFilters("lightFilter");
      
      public function GoldmineMainFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.initData();
         this.initView();
         this.addEvent();
      }
      
      private function initData() : void
      {
         if(this._model == null)
         {
            this._model = GoldmineManager.Instance.model;
         }
         this._lightPos = new Vector.<Point>();
         var _loc1_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.lightPos1");
         var _loc2_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.lightPos2");
         var _loc3_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.lightPos3");
         this._lightPos.push(_loc1_);
         this._lightPos.push(_loc2_);
         this._lightPos.push(_loc3_);
         this._btmPos = new Vector.<Point>();
         var _loc4_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.btmMcPos1");
         var _loc5_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.btmMcPos2");
         var _loc6_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.btmMcPos3");
         this._btmPos.push(_loc4_);
         this._btmPos.push(_loc5_);
         this._btmPos.push(_loc6_);
         this._shinePos = new Vector.<Point>();
         var _loc7_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.shinePos1");
         var _loc8_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.shinePos2");
         var _loc9_:Point = ComponentFactory.Instance.creat("goldmineMainFrame.shinePos3");
         this._shinePos.push(_loc7_);
         this._shinePos.push(_loc8_);
         this._shinePos.push(_loc9_);
      }
      
      private function initView() : void
      {
         this._dateStartMonth1 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateStartMonthNum1");
         addToContent(this._dateStartMonth1);
         this._dateStartMonth2 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateStartMonthNum2");
         addToContent(this._dateStartMonth2);
         this._datePoint1 = ComponentFactory.Instance.creatBitmap("asset.goldmine.numpoint");
         PositionUtils.setPos(this._datePoint1,"goldmineMainFrame.pointPos1");
         addToContent(this._datePoint1);
         this._dateStartDay1 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateStartDayNum1");
         addToContent(this._dateStartDay1);
         this._dateStartDay2 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateStartDayNum2");
         addToContent(this._dateStartDay2);
         var _loc1_:int = GoldmineManager.Instance.dateStart.month + 1;
         this._dateStartMonth1.count = _loc1_ < 10 ? 0 : 1;
         this._dateStartMonth2.count = _loc1_ % 10;
         var _loc2_:int = GoldmineManager.Instance.dateStart.date;
         this._dateStartDay1.count = _loc2_ < 10 ? 0 : int(_loc2_ / 10);
         this._dateStartDay2.count = _loc2_ % 10;
         this._dateIcon = ComponentFactory.Instance.creatBitmap("asset.goldmine.numTo");
         addToContent(this._dateIcon);
         this._dateEndMonth1 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateEndMonthNum1");
         addToContent(this._dateEndMonth1);
         this._dateEndMonth2 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateEndMonthNum2");
         addToContent(this._dateEndMonth2);
         this._datePoint2 = ComponentFactory.Instance.creatBitmap("asset.goldmine.numpoint");
         PositionUtils.setPos(this._datePoint2,"goldmineMainFrame.pointPos2");
         addToContent(this._datePoint2);
         this._dateEndDay1 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateEndDayNum1");
         addToContent(this._dateEndDay1);
         this._dateEndDay2 = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.dateEndDayNum2");
         addToContent(this._dateEndDay2);
         var _loc3_:int = GoldmineManager.Instance.dateEnd.month + 1;
         this._dateEndMonth1.count = _loc3_ < 10 ? 0 : 1;
         this._dateEndMonth2.count = _loc3_ % 10;
         var _loc4_:int = GoldmineManager.Instance.dateEnd.date;
         this._dateEndDay1.count = _loc4_ < 10 ? 0 : int(_loc4_ / 10);
         this._dateEndDay2.count = _loc4_ % 10;
         this._infoText = ComponentFactory.Instance.creatBitmap("asset.goldmineInfoImg");
         addToContent(this._infoText);
         this._infoWord = ComponentFactory.Instance.creatComponentByStylename("GoldmineInfoWord");
         this._infoWord.text = LanguageMgr.GetTranslation("goldmine.infoWord",this._model.goldArr[0],this._model.goldArr[1],this._model.goldArr[2],this._model.goldArr[3],this._model.goldArr[4]);
         addToContent(this._infoWord);
         this._mineBtn = ComponentFactory.Instance.creat("goldmineMainFrame.mineBtn");
         addToContent(this._mineBtn);
         this._mineTimesText = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.mineTimesText");
         addToContent(this._mineTimesText);
         this._nextScoreLeft = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.nextScoreLeftText");
         addToContent(this._nextScoreLeft);
         this._smallMineText = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.smallMineNum");
         addToContent(this._smallMineText);
         this._middleMineText = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.middleMineNum");
         addToContent(this._middleMineText);
         this._bigMineText = ComponentFactory.Instance.creatComponentByStylename("goldmineMainFrame.bigMineNum");
         addToContent(this._bigMineText);
         this._mineTextList = new Vector.<NumberImage>();
         this._mineTextList.push(this._smallMineText,this._middleMineText,this._bigMineText);
         this._blackBg = ComponentFactory.Instance.creatBitmap("asset.goldmine.blackBg");
         this._blackBg.visible = false;
         addToContent(this._blackBg);
         this._mineLight = ComponentFactory.Instance.creat("asset.goldmine.lightBg");
         this._mineLight.visible = false;
         addToContent(this._mineLight);
         this._mineBaseBtm = ComponentFactory.Instance.creat("asset.goldmine.bottomBg");
         this._mineBaseBtm.visible = false;
         addToContent(this._mineBaseBtm);
         this._shineMc = ClassUtils.CreatInstance("asset.goldmine.shineMc");
         this._shineMc.mouseEnabled = false;
         this._shineMc.visible = false;
         addToContent(this._shineMc);
         this._smallMine = ClassUtils.CreatInstance("asset.goldmine.mineSmall");
         this._smallMine.mouseEnabled = false;
         this._smallMine.gotoAndStop(1);
         PositionUtils.setPos(this._smallMine,"goldmineMainFrame.smallPos");
         addToContent(this._smallMine);
         this._middleMine = ClassUtils.CreatInstance("asset.goldmine.mineMiddle");
         this._middleMine.mouseEnabled = false;
         this._middleMine.gotoAndStop(1);
         PositionUtils.setPos(this._middleMine,"goldmineMainFrame.middlePos");
         addToContent(this._middleMine);
         this._bigMine = ClassUtils.CreatInstance("asset.goldmine.mineBig");
         this._bigMine.mouseEnabled = false;
         this._bigMine.gotoAndStop(1);
         PositionUtils.setPos(this._bigMine,"goldmineMainFrame.bigPos");
         addToContent(this._bigMine);
         this._mineMc = new Vector.<MovieClip>();
         this._mineMc.push(this._smallMine);
         this._mineMc.push(this._bigMine);
         this._mineMc.push(this._middleMine);
         this.updateView();
      }
      
      public function updateView() : void
      {
         this._mineTimesText.text = String(this._model.currentTimes);
         if(this._model.usedTimes < this._model.maxTimes)
         {
            this._smallMineText.visible = this._middleMineText.visible = this._bigMineText.visible = true;
            this._smallMineText.count = this._model.mineSmall;
            this._middleMineText.count = this._model.mineMiddle;
            this._bigMineText.count = this._model.mineBig;
         }
         if(this._model.nextScoreNeed <= 0)
         {
            this._nextScoreLeft.text = LanguageMgr.GetTranslation("goldmine.fullMineTime");
         }
         else
         {
            this._nextScoreLeft.text = LanguageMgr.GetTranslation("goldmine.nextScoreLeft",this._model.nextScoreNeed);
         }
      }
      
      private function addEvent() : void
      {
         this._smallMine.addEventListener("rollOver",this.__onMouseRollover);
         this._smallMine.addEventListener("rollOut",this.__onMouseRollout);
         this._middleMine.addEventListener("rollOver",this.__onMouseRollover);
         this._middleMine.addEventListener("rollOut",this.__onMouseRollout);
         this._bigMine.addEventListener("rollOver",this.__onMouseRollover);
         this._bigMine.addEventListener("rollOut",this.__onMouseRollout);
         GoldmineManager.Instance.addEventListener("goldmine_use",this.__onUseGoldmine);
         this._mineBtn.addEventListener("click",this.__onClickMineBtn);
         this.addEventListener("response",this.__response);
      }
      
      private function __onClickMineBtn(param1:MouseEvent) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:* = null;
         var _loc3_:* = null;
         SoundManager.instance.playButtonSound();
         _loc4_ = new Date().time;
         if(_loc4_ - this._clickNum < 1000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc4_;
         if(this._model.usedTimes >= this._model.maxTimes)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("goldmine.emptyTxt"));
         }
         else if(this._model.currentTimes > 0)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("goldmine.comfirmTxt",this._model.goldNeedArr[this._model.usedTimes]),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,true,false,2);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener("response",this.__onMineResponse);
         }
         else
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("goldmine.noTimesTxt"),LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.supply"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,true,false,2);
            _loc3_.moveEnable = false;
            _loc3_.addEventListener("response",this.__poorManResponse);
         }
      }
      
      private function __onMineResponse(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener("response",this.__onMineResponse);
         _loc3_.dispose();
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            if(PlayerManager.Instance.Self.Money >= this._model.goldNeedArr[this._model.usedTimes])
            {
               GameInSocketOut.sendGoldmineUse();
            }
            else
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.point"),LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.supply"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,true,false,2);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener("response",this.__poorManResponse);
            }
         }
      }
      
      private function __timeRemainHandler(param1:Event) : void
      {
         if(this._index < 0)
         {
            return;
         }
         this._mineLight.visible = true;
         this._mineLight.x = this._lightPos[this.currentIndex].x;
         this._mineLight.y = this._lightPos[this.currentIndex].y;
         this.currentIndex = (this.currentIndex + 1) % this._lightPos.length;
      }
      
      private function __timeComHandler(param1:Event) : void
      {
         if(this._index < 0)
         {
            return;
         }
         this._timeRemainTimer.removeEventListener("timer",this.__timeRemainHandler);
         this._timeRemainTimer.removeEventListener("timerComplete",this.__timeComHandler);
         this._mineBaseBtm.visible = true;
         this._mineBaseBtm.x = this._btmPos[this._index].x;
         this._mineBaseBtm.y = this._btmPos[this._index].y;
         this._mineLight.x = this._lightPos[this._index].x;
         this._mineLight.y = this._lightPos[this._index].y;
         this._mineMc[this._index].visible = true;
         this._mineMc[this._index].addEventListener("enterFrame",this.__onMineHandler);
         this._mineMc[this._index].gotoAndPlay(1);
      }
      
      private function __onMineHandler(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(this._index < 0)
         {
            return;
         }
         if(this._mineMc[this._index].currentFrame == this._mineMc[this._index].totalFrames)
         {
            this._mineMc[this._index].removeEventListener("enterFrame",this.__onMineHandler);
            this._mineMc[this._index].gotoAndStop(1);
            this._mineMc[this._index].alpha = 0.3;
            this._mineTextList[this._index].alpha = 0.3;
            this._mineLight.visible = false;
            this._mineBaseBtm.visible = false;
            this._shineMc.visible = true;
            this._blackBg.visible = true;
            this._shineMc.x = this._shinePos[1].x;
            this._shineMc.y = this._shinePos[1].y;
            this._shineMc.play();
            _loc2_ = ClassUtils.CreatInstance("asset.goldmine.mineAction" + this._index);
            _loc3_ = new MovieClipWrapper(_loc2_,true,true);
            _loc3_.addEventListener("complete",this.__onPlayActionComplete);
            addChild(_loc3_.movie);
            PositionUtils.setPos(_loc3_.movie,this._mineMc[1]);
         }
      }
      
      private function __onPlayActionComplete(param1:Event) : void
      {
         var _loc2_:MovieClipWrapper = param1.currentTarget as MovieClipWrapper;
         _loc2_.removeEventListener("complete",this.__onPlayActionComplete);
         this._mineMc[this._index].alpha = 1;
         this._mineTextList[this._index].alpha = 1;
         this._shineMc.gotoAndStop(1);
         this._shineMc.visible = false;
         this._blackBg.visible = false;
         this._index = -1;
         this.currentIndex = 0;
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("goldmine.getRewardTxt",this._lastScore));
         this.mouseChildren = true;
         this.mouseEnabled = true;
         --this._model.currentTimes;
         ++this._model.usedTimes;
         this.updateView();
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__poorManResponse);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(_loc2_);
      }
      
      private function __onMouseRollout(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         _loc2_.filters = null;
      }
      
      private function __onMouseRollover(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         if(_loc2_.filters != this._filter)
         {
            _loc2_.filters = this._filter;
         }
      }
      
      private function removeEvent() : void
      {
         this._smallMine.removeEventListener("rollOver",this.__onMouseRollover);
         this._smallMine.removeEventListener("rollOut",this.__onMouseRollout);
         this._middleMine.removeEventListener("rollOver",this.__onMouseRollover);
         this._middleMine.removeEventListener("rollOut",this.__onMouseRollout);
         this._bigMine.removeEventListener("rollOver",this.__onMouseRollover);
         this._bigMine.removeEventListener("rollOut",this.__onMouseRollout);
         GoldmineManager.Instance.removeEventListener("goldmine_use",this.__onUseGoldmine);
         this.removeEventListener("response",this.__response);
         if(this._mineBtn != null)
         {
            this._mineBtn.removeEventListener("click",this.__onClickMineBtn);
         }
      }
      
      private function __onUseGoldmine(param1:CEvent) : void
      {
         var _loc2_:Object = param1.data;
         if(_loc2_ is Array)
         {
            if(_loc2_[0] < 0)
            {
               MessageTipManager.getInstance().show("数据异常");
               return;
            }
            this._index = int(_loc2_[0]);
            if(this._index < 0)
            {
               return;
            }
            this._lastScore = int(_loc2_[1]);
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this._timeRemainTimer = TimerManager.getInstance().addTimerJuggler(200,this._lightPos.length * 2 + this._index + 1);
            this._timeRemainTimer.addEventListener("timer",this.__timeRemainHandler);
            this._timeRemainTimer.addEventListener("timerComplete",this.__timeComHandler);
            this._timeRemainTimer.start();
         }
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
      }
      
      override protected function onResponse(param1:int) : void
      {
         GoldmineManager.Instance.dispatchEvent(new CEvent("goldmine_closeview"));
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.removeChildAllChildren(this);
         this._infoText = null;
         this._infoWord = null;
         this._mineBtn = null;
         this._mineLight = null;
         this._mineBaseBtm = null;
         this._blackBg = null;
         this._shineMc = null;
         this._smallMine = null;
         this._middleMine = null;
         this._bigMine = null;
         this._smallMineText = null;
         this._middleMineText = null;
         this._bigMineText = null;
         this._mineTimesText = null;
         this._nextScoreLeft = null;
         this._dateStartMonth1 = null;
         this._dateStartMonth2 = null;
         this._datePoint1 = null;
         this._dateStartDay1 = null;
         this._dateStartDay2 = null;
         this._dateIcon = null;
         this._dateEndMonth1 = null;
         this._dateEndMonth2 = null;
         this._datePoint1 = null;
         this._dateEndDay1 = null;
         this._dateEndDay2 = null;
         this._lightPos = null;
         this._shinePos = null;
         this._btmPos = null;
         this._mineMc = null;
         this._filter = null;
         this._mineTextList = null;
         super.dispose();
      }
   }
}

