package cloudBuyLottery.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
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
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import store.HelpFrame;
   
   public class CloudBuyLotteryFrame extends Frame
   {
      
      public static var logFrameFlag:Boolean;
      
      public static const MOVE_SPEED:Number = 0.8;
      
      private var _bg:Bitmap;
      
      private var showTimes:MovieClip;
      
      private var timeArray:Array;
      
      private var _timer:Timer;
      
      private var _helpBtn:BaseButton;
      
      private var _jubaoBtn:BaseButton;
      
      private var _buyBtn:BaseButton;
      
      private var _finish:Bitmap;
      
      private var _expBar:ExpBar;
      
      private var _luckNumTxt:FilterFrameText;
      
      private var _chanceTxt:FilterFrameText;
      
      private var _showBuyNumTxt:FilterFrameText;
      
      private var _buyNumTxt:FilterFrameText;
      
      private var _buyGoodsMoneyTxt:FilterFrameText;
      
      private var _helpTxt:FilterFrameText;
      
      private var _tipsframe:BaseAlerFrame;
      
      private var _inputBg:Bitmap;
      
      private var _inputText:FilterFrameText;
      
      private var _moneyNumText:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _text:FilterFrameText;
      
      private var _cell:BagCell;
      
      private var _logTxt:FilterFrameText;
      
      private var _logSprite:Sprite;
      
      private var winningLogFrame:TheWinningLog;
      
      private var _infoWidth:Number;
      
      private var _numberK:Bitmap;
      
      private var _numberKTxt:FilterFrameText;
      
      private var luckLooteryFrame:IndividualLottery;
      
      private var _buyGoodsSprite:Component;
      
      public function CloudBuyLotteryFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         _titleText = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.title");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.bg");
         this.showTimes = ClassUtils.CreatInstance("asset.cloudbuy.showTime") as MovieClip;
         PositionUtils.setPos(this.showTimes,"CloudBuyLotteryFrame.showTimesMC");
         this._helpBtn = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.helpBtn");
         this._jubaoBtn = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.jubaoBtn");
         this._buyBtn = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.buyBtn");
         this._finish = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.finish");
         this._expBar = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.expBar");
         this._luckNumTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.luckNumTxt");
         this._luckNumTxt.text = CloudBuyLotteryManager.Instance.model.luckCount.toString();
         this._chanceTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.chanceTxt");
         this._chanceTxt.text = CloudBuyLotteryManager.Instance.model.luckCount + "/" + CloudBuyLotteryManager.Instance.model.maxNum;
         this._showBuyNumTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.showBuyNumTxt");
         this._showBuyNumTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.showBuyNum",CloudBuyLotteryManager.Instance.model.currentNum.toString());
         this._buyNumTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.buyNumTxt");
         this._buyNumTxt.text = CloudBuyLotteryManager.Instance.model.currentNum.toString();
         this._buyGoodsMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.buyGoodsMoneyTxt");
         this._buyGoodsMoneyTxt.text = LanguageMgr.GetTranslation("cloudBuyLotteryFrame.buyGoodsMoneyTxt",CloudBuyLotteryManager.Instance.model.buyMoney.toString());
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.helpTxt");
         this._helpTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.help");
         this._logTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.logTxt");
         this._logTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.log");
         this._logSprite = new Sprite();
         this._logSprite.addChild(this._logTxt);
         this._logSprite.buttonMode = true;
         PositionUtils.setPos(this._logSprite,"CloudBuyLotteryFrame.logSprite");
         this._numberK = ComponentFactory.Instance.creatBitmap("asset.cloudbuy.numberK");
         this._numberKTxt = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.numberKTxt");
         this._numberKTxt.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
         addToContent(this._bg);
         addToContent(this.showTimes);
         addToContent(this._helpBtn);
         addToContent(this._jubaoBtn);
         addToContent(this._buyBtn);
         addToContent(this._finish);
         addToContent(this._expBar);
         addToContent(this._luckNumTxt);
         addToContent(this._chanceTxt);
         addToContent(this._showBuyNumTxt);
         addToContent(this._buyGoodsMoneyTxt);
         addToContent(this._helpTxt);
         addToContent(this._logSprite);
         addToContent(this._numberK);
         addToContent(this._numberKTxt);
         this.timesNum();
         this.luckGoodsCell(CloudBuyLotteryManager.Instance.model.templateId);
         this.buyGoodsCell(CloudBuyLotteryManager.Instance.model.buyGoodsIDArray);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__updateTimes);
         this._timer.start();
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._jubaoBtn.addEventListener(MouseEvent.CLICK,this.__onJuBaoClick);
         this._logSprite.addEventListener(MouseEvent.CLICK,this.__onLogClick);
         CloudBuyLotteryManager.Instance.addEventListener(CloudBuyLotteryManager.UPDATE_INFO,this.__updateInfo);
         CloudBuyLotteryManager.Instance.addEventListener(CloudBuyLotteryManager.FRAMEUPDATE,this.__frmeUpdateInfo);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyClick);
         this._jubaoBtn.removeEventListener(MouseEvent.CLICK,this.__onJuBaoClick);
         this._logSprite.removeEventListener(MouseEvent.CLICK,this.__onLogClick);
         CloudBuyLotteryManager.Instance.removeEventListener(CloudBuyLotteryManager.UPDATE_INFO,this.__updateInfo);
         CloudBuyLotteryManager.Instance.removeEventListener(CloudBuyLotteryManager.FRAMEUPDATE,this.__frmeUpdateInfo);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this._infoWidth = param1;
      }
      
      private function __updateInfo(param1:Event) : void
      {
         this.timesNum();
         this.luckGoodsCell(CloudBuyLotteryManager.Instance.model.templateId);
         this.buyGoodsCell(CloudBuyLotteryManager.Instance.model.buyGoodsIDArray);
         this._buyNumTxt.text = CloudBuyLotteryManager.Instance.model.currentNum.toString();
         this._showBuyNumTxt.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.showBuyNum",CloudBuyLotteryManager.Instance.model.currentNum.toString());
         this._chanceTxt.text = CloudBuyLotteryManager.Instance.model.luckCount + "/" + CloudBuyLotteryManager.Instance.model.maxNum;
         this._luckNumTxt.text = CloudBuyLotteryManager.Instance.model.luckCount.toString();
         this._numberKTxt.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
         var _loc2_:int = CloudBuyLotteryManager.Instance.model.maxNum - CloudBuyLotteryManager.Instance.model.currentNum;
         CloudBuyLotteryManager.Instance.expBar.initBar(_loc2_,CloudBuyLotteryManager.Instance.model.maxNum);
      }
      
      private function __frmeUpdateInfo(param1:Event) : void
      {
         this._numberKTxt.text = CloudBuyLotteryManager.Instance.model.remainTimes.toString();
      }
      
      private function __onLogClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(!logFrameFlag)
         {
            logFrameFlag = true;
            this.winningLogFrame = ComponentFactory.Instance.creatComponentByStylename("winningLogFrame.frame");
            this.winningLogFrame.addEventListener(FrameEvent.RESPONSE,this.__onclose);
            addChildAt(this.winningLogFrame,0);
            _loc2_ = this._infoWidth + this.winningLogFrame.width;
            TweenLite.to(this,MOVE_SPEED,{"x":(StageReferance.stage.stageWidth - _loc2_) / 2});
            TweenLite.to(this.winningLogFrame,MOVE_SPEED,{"x":this._infoWidth});
         }
         else
         {
            logFrameFlag = false;
            this.hideFrame();
         }
      }
      
      public function hideFrame() : void
      {
         TweenLite.to(this,MOVE_SPEED,{"x":(StageReferance.stage.stageWidth - this._infoWidth) / 2});
         TweenLite.to(this.winningLogFrame,MOVE_SPEED,{
            "x":this.winningLogFrame.width,
            "onComplete":this.releaseRight,
            "onCompleteParams":[this.winningLogFrame]
         });
         this.winningLogFrame = null;
      }
      
      private function releaseRight(param1:Frame) : void
      {
         if(Boolean(param1))
         {
            param1.removeEventListener(FrameEvent.RESPONSE,this.__onclose);
         }
         ObjectUtils.disposeObject(param1);
      }
      
      protected function __onclose(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.hideFrame();
         }
      }
      
      private function __onBuyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!CloudBuyLotteryManager.Instance.model.isGame)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("cloudBuyLottery.isGameOver"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < CloudBuyLotteryManager.Instance.model.buyMoney)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._tipsframe = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("CloudBuyLotteryFrame.buy.tips"),"","",LanguageMgr.GetTranslation("cancel"),true,true,false,2,null,"SimpleAlert2");
         this._tipsframe.width = 360;
         this._tipsframe.height = 200;
         this._text = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.tipsframeText");
         this._text.text = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.autoOpenCount.text");
         PositionUtils.setPos(this._text,"CloudBuyLotteryFrame.autoOpenCount.textPos");
         this._inputBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.openBatchView.inputBg");
         this._inputText = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.inputTxt");
         this._inputText.text = "1";
         PositionUtils.setPos(this._inputBg,"CloudBuyLotteryFrame.autoOpenCount.textPos1");
         PositionUtils.setPos(this._inputText,"CloudBuyLotteryFrame.autoOpenCount.textPos2");
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("openBatchView.maxBtn");
         PositionUtils.setPos(this._maxBtn,"CloudBuyLotteryFrame.autoOpenCount.textPos3");
         this._moneyNumText = ComponentFactory.Instance.creatComponentByStylename("CloudBuyLotteryFrame.moneyNumText");
         this._tipsframe.addToContent(this._text);
         this._tipsframe.addToContent(this._inputBg);
         this._tipsframe.addToContent(this._inputText);
         this._tipsframe.addToContent(this._maxBtn);
         this._tipsframe.addToContent(this._moneyNumText);
         this._tipsframe.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.changeMaxHandler,false,0,true);
         this._inputText.addEventListener(Event.CHANGE,this.inputTextChangeHandler,false,0,true);
         this.showMoneyNum();
      }
      
      private function changeMaxHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inputText.text = this._buyNumTxt.text;
         this.showMoneyNum();
      }
      
      private function inputTextChangeHandler(param1:Event) : void
      {
         var _loc2_:int = int(this._buyNumTxt.text);
         var _loc3_:int = int(this._inputText.text);
         if(_loc3_ > _loc2_)
         {
            this._inputText.text = _loc2_.toString();
         }
         else if(_loc3_ < 1)
         {
            this._inputText.text = "1";
         }
         this.showMoneyNum();
      }
      
      private function showMoneyNum() : void
      {
         var _loc1_:int = int(this._inputText.text) * CloudBuyLotteryManager.Instance.model.buyMoney;
         this._moneyNumText.htmlText = LanguageMgr.GetTranslation("CloudBuyLotteryFrame.moneyNumText.LG",_loc1_);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:int = int(this._inputText.text);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendYGBuyGoods(_loc2_);
         }
         if(Boolean(this._tipsframe))
         {
            this._tipsframe.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
            ObjectUtils.disposeAllChildren(this._tipsframe);
            ObjectUtils.disposeObject(this._tipsframe);
            this._tipsframe = null;
         }
      }
      
      private function __onJuBaoClick(param1:MouseEvent) : void
      {
         if(this.luckLooteryFrame != null)
         {
            ObjectUtils.disposeObject(this.luckLooteryFrame);
            this.luckLooteryFrame = null;
         }
         if(this.luckLooteryFrame == null)
         {
            this.luckLooteryFrame = ComponentFactory.Instance.creatComponentByStylename("individualLottery.frame");
            LayerManager.Instance.addToLayer(this.luckLooteryFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function luckGoodsCell(param1:int) : void
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1) as ItemTemplateInfo;
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc3_.ValidDate = CloudBuyLotteryManager.Instance.model.validDate;
         _loc3_.StrengthenLevel = CloudBuyLotteryManager.Instance.model.property[0];
         _loc3_.AttackCompose = CloudBuyLotteryManager.Instance.model.property[1];
         _loc3_.DefendCompose = CloudBuyLotteryManager.Instance.model.property[2];
         _loc3_.LuckCompose = CloudBuyLotteryManager.Instance.model.property[3];
         _loc3_.AgilityCompose = CloudBuyLotteryManager.Instance.model.property[4];
         _loc3_.IsBinds = CloudBuyLotteryManager.Instance.model.property[5] == 1;
         if(this._cell != null)
         {
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
         }
         this._cell = new BagCell(0,_loc3_);
         PositionUtils.setPos(this._cell,"CloudBuyLotteryFrame.cellPos");
         this._cell.setContentSize(78,78);
         this._cell.setCount(CloudBuyLotteryManager.Instance.model.templatedIdCount);
         this._cell.setBgVisible(false);
         addToContent(this._cell);
      }
      
      private function buyGoodsCell(param1:Array) : void
      {
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:String = "";
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(param1[_loc6_]) as ItemTemplateInfo;
            _loc3_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc3_,_loc2_);
            _loc4_ = int(CloudBuyLotteryManager.Instance.model.buyGoodsCountArray[_loc6_]);
            _loc5_ += LanguageMgr.GetTranslation("cloudBuyLotteryFrame.buyGoodsTip",_loc3_.Name,_loc4_);
            if(_loc6_ != 0 && _loc6_ % 4 == 0)
            {
               _loc5_ += "\n";
            }
            _loc6_++;
         }
         this._buyGoodsSprite = ComponentFactory.Instance.creatComponentByStylename("cloudBuyLotteryFrame.tipData");
         this._buyGoodsSprite.tipData = _loc5_.substring(0,_loc5_.length - 1);
         this._buyGoodsSprite.buttonMode = true;
         var _loc7_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.goods");
         this._buyGoodsSprite.addChild(_loc7_);
         addToContent(this._buyGoodsSprite);
      }
      
      private function __updateTimes(param1:TimerEvent) : void
      {
         this.timesNum();
      }
      
      private function timesNum() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(CloudBuyLotteryManager.Instance.model.isGame)
         {
            this.timeArray = CloudBuyLotteryManager.Instance.refreshTimePlayTxt().split(":");
            _loc1_ = CloudBuyLotteryManager.Instance.returnTen(this.timeArray[0]);
            _loc2_ = CloudBuyLotteryManager.Instance.returnABit(this.timeArray[0]);
            _loc3_ = CloudBuyLotteryManager.Instance.returnTen(this.timeArray[1]);
            _loc4_ = CloudBuyLotteryManager.Instance.returnABit(this.timeArray[1]);
            _loc5_ = CloudBuyLotteryManager.Instance.returnTen(this.timeArray[2]);
            _loc6_ = CloudBuyLotteryManager.Instance.returnABit(this.timeArray[2]);
            this.showTimes.hourTen.gotoAndStop(_loc1_);
            this.showTimes.hourBit.gotoAndStop(_loc2_);
            this.showTimes.minutesTen.gotoAndStop(_loc3_);
            this.showTimes.minutesBit.gotoAndStop(_loc4_);
            this.showTimes.secondsTen.gotoAndStop(_loc5_);
            this.showTimes.secondsBit.gotoAndStop(_loc6_);
         }
         else
         {
            this._luckNumTxt.text = "0";
            this._chanceTxt.text = "0/0";
            this.showTimes.hourTen.gotoAndStop(0);
            this.showTimes.hourBit.gotoAndStop(0);
            this.showTimes.minutesTen.gotoAndStop(0);
            this.showTimes.minutesBit.gotoAndStop(0);
            this.showTimes.secondsTen.gotoAndStop(0);
            this.showTimes.secondsBit.gotoAndStop(0);
            if(this._timer != null)
            {
               this._timer.stop();
            }
         }
      }
      
      protected function __onHelpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("CloudBuyLotteryFrame.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function get expBar() : ExpBar
      {
         return this._expBar;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.__updateTimes);
            this._timer = null;
         }
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._expBar))
         {
            ObjectUtils.disposeObject(this._expBar);
         }
         this._expBar = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this.luckLooteryFrame))
         {
            ObjectUtils.disposeObject(this.luckLooteryFrame);
         }
         this.luckLooteryFrame = null;
         if(Boolean(this.winningLogFrame))
         {
            ObjectUtils.disposeObject(this.winningLogFrame);
         }
         this.winningLogFrame = null;
         this._bg = null;
         this.showTimes = null;
      }
   }
}

