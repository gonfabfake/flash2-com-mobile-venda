package sanXiao.view
{
   import bagAndInfo.bag.RichesButton;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.GridBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.pageSelector.PageSelector;
   import ddt.view.pageSelector.PageSelectorFactory;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import road7th.utils.DateUtils;
   import sanXiao.SanXiaoManager;
   import sanXiao.game.SXGame;
   import sanXiao.game.SanXiaoGameMediator;
   import sanXiao.model.SXRewardItemData;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class SanXiaoViewGame extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _game:SXGame;
      
      private var _mask:Shape;
      
      private var _btnPropCrossBomb:SimpleBitmapButton;
      
      private var _btnPropSquareBomb:SimpleBitmapButton;
      
      private var _btnPropClearColor:SimpleBitmapButton;
      
      private var _btnPropChangeColor:SimpleBitmapButton;
      
      private var _propCursor:ScaleFrameImage;
      
      private var _btnSelectedProp:Bitmap;
      
      private var _cursorOffsetX:Number;
      
      private var _cursorOffsetY:Number;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _stepRemainTxt:FilterFrameText;
      
      private var _crystalTxt:FilterFrameText;
      
      private var _btnBuyStep:SimpleBitmapButton;
      
      private var _iconBoxBagCell:BagCell;
      
      private var _progress:MovieClip;
      
      private var _progressTips:RichesButton;
      
      private var _progressText:FilterFrameText;
      
      private var _timeRemainBmp:Bitmap;
      
      private var _timeRemainText:FilterFrameText;
      
      private var _timeRemainTimer:TimerJuggler;
      
      private var _bagListView:GridBox;
      
      private var _pageSelector:PageSelector;
      
      private var _rewardItemList:Vector.<SXDropOutItem>;
      
      private var _curPage:int;
      
      private var _propBtnListened:Boolean = false;
      
      public function SanXiaoViewGame()
      {
         super();
         this.init();
         this.addEvents();
      }
      
      private function init() : void
      {
         var _loc3_:SXPropTipDataCreater = null;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._bg = ComponentFactory.Instance.creatBitmap("ast.sanxiao.bg.game");
         PositionUtils.setPos(this._bg,"sanxiao.gameBG.pt");
         addChild(this._bg);
         this._game = SanXiaoGameMediator.getInstance().getGameView();
         PositionUtils.setPos(this._game,"sanxiao.game.pt");
         addChild(this._game);
         this._mask = new Shape();
         this._mask.graphics.beginFill(0);
         this._mask.graphics.drawRect(0,0,350,350);
         this._mask.graphics.endFill();
         this._mask.x = this._game.x;
         this._mask.y = this._game.y;
         addChild(this._mask);
         this._game.mask = this._mask;
         _loc3_ = new SXPropTipDataCreater();
         this._btnPropCrossBomb = ComponentFactory.Instance.creat("sanxiao.prop.CrossBomb.btn");
         this._btnPropCrossBomb.tipStyle = "ddt.view.tips.SanXiaoPropTip";
         this._btnPropCrossBomb.tipDirctions = "2";
         this._btnPropCrossBomb.tipGapV = 4;
         this._btnPropCrossBomb.tipData = _loc3_.getTipData(1);
         addChild(this._btnPropCrossBomb);
         this._btnPropSquareBomb = ComponentFactory.Instance.creat("sanxiao.prop.SquareBomb.btn");
         this._btnPropSquareBomb.tipStyle = "ddt.view.tips.SanXiaoPropTip";
         this._btnPropSquareBomb.tipDirctions = "2";
         this._btnPropSquareBomb.tipGapV = 4;
         this._btnPropSquareBomb.tipData = _loc3_.getTipData(2);
         addChild(this._btnPropSquareBomb);
         this._btnPropClearColor = ComponentFactory.Instance.creat("sanxiao.prop.ClearColor.btn");
         this._btnPropClearColor.tipStyle = "ddt.view.tips.SanXiaoPropTip";
         this._btnPropClearColor.tipDirctions = "2";
         this._btnPropClearColor.tipGapV = 4;
         this._btnPropClearColor.tipData = _loc3_.getTipData(3);
         addChild(this._btnPropClearColor);
         this._btnPropChangeColor = ComponentFactory.Instance.creat("sanxiao.prop.ChangeColor.btn");
         this._btnPropChangeColor.tipStyle = "ddt.view.tips.SanXiaoPropTip";
         this._btnPropChangeColor.tipDirctions = "2";
         this._btnPropChangeColor.tipGapV = 4;
         this._btnPropChangeColor.tipData = _loc3_.getTipData(4);
         addChild(this._btnPropChangeColor);
         this._propCursor = ComponentFactory.Instance.creat("sanxiao.propIcon");
         this._propCursor.mouseChildren = this._propCursor.mouseEnabled = false;
         this._cursorOffsetX = -this._propCursor.width * 0.5;
         this._cursorOffsetY = -this._propCursor.height * 0.5;
         this._btnSelectedProp = ComponentFactory.Instance.creat("ast.sanxiao.selected.prop");
         this._scoreTxt = ComponentFactory.Instance.creat("sanxiao.gameTxt");
         PositionUtils.setPos(this._scoreTxt,"sanxiao.score.pt");
         this._scoreTxt.text = "0";
         addChild(this._scoreTxt);
         this._stepRemainTxt = ComponentFactory.Instance.creat("sanxiao.gameTxt");
         PositionUtils.setPos(this._stepRemainTxt,"sanxiao.stepRemain.pt");
         this._stepRemainTxt.text = "0";
         addChild(this._stepRemainTxt);
         this._crystalTxt = ComponentFactory.Instance.creat("sanxiao.gameTxt");
         PositionUtils.setPos(this._crystalTxt,"sanxiao.crystal.pt");
         this._crystalTxt.text = "0";
         addChild(this._crystalTxt);
         this._progress = ComponentFactory.Instance.creat("ast.sanxiao.progress");
         this._progress.gotoAndStop(1);
         PositionUtils.setPos(this._progress,"sanxiao.progress.pt");
         addChild(this._progress);
         this._progressText = ComponentFactory.Instance.creat("sanxiao.ProgressText");
         PositionUtils.setPos(this._progressText,"sanxiao.progressTxt.pt");
         addChild(this._progressText);
         this._progressTips = ComponentFactory.Instance.creat("sanxiao.progressTips");
         this._progressTips.x = this._progress.x;
         this._progressTips.y = this._progress.y;
         this._progressTips.tipData = "0/0";
         addChild(this._progressTips);
         this._iconBoxBagCell = new BagCell(0,null,true);
         PositionUtils.setPos(this._iconBoxBagCell,"sanxiao.nextbagcell.pt");
         addChild(this._iconBoxBagCell);
         this._btnBuyStep = ComponentFactory.Instance.creat("sanxiao.buyStep.btn");
         addChild(this._btnBuyStep);
         this._bagListView = new GridBox();
         this._bagListView.columnNumber = 7;
         this._rewardItemList = new Vector.<SXDropOutItem>();
         _loc1_ = 0;
         while(_loc1_ < 49)
         {
            _loc2_ = new SXDropOutItem(0);
            _loc2_.width = 55;
            _loc2_.height = 55;
            _loc2_.x = int(_loc1_ % 7) * 49 + 386;
            _loc2_.y = int(_loc1_ / 7) * 49 + 19;
            addChild(_loc2_);
            this._rewardItemList.push(_loc2_);
            _loc1_++;
         }
         PositionUtils.setPos(this._bagListView,"sanxiao.bagListView.pt");
         addChild(this._bagListView);
         this._pageSelector = PageSelectorFactory.getInstance().getPageSelector("normal");
         this._pageSelector.itemDataArr = SanXiaoManager.getInstance().dropOutItemList;
         this._pageSelector.itemList = this._rewardItemList;
         PositionUtils.setPos(this._pageSelector,"sanxiao.pageSelectorCount");
         addChild(this._pageSelector);
         this._timeRemainBmp = ComponentFactory.Instance.creatBitmap("ast.sanxiao.timeRemainBmp");
         addChild(this._timeRemainBmp);
         this._timeRemainText = ComponentFactory.Instance.creat("sanxiao.timeRemainText.Txt");
         this._timeRemainText.text = "";
         addChild(this._timeRemainText);
         this._timeRemainTimer = TimerManager.getInstance().addTimerJuggler(10000);
         this._timeRemainTimer.addEventListener("timer",this.__timeRemainHandler);
         this._timeRemainTimer.start();
      }
      
      private function __timeRemainHandler(param1:Event) : void
      {
         if(Boolean(this._timeRemainText))
         {
            this._timeRemainText.text = this.getTimeRemainStr();
         }
      }
      
      private function getTimeRemainStr() : String
      {
         var _loc1_:Number = (SanXiaoManager.getInstance().endTime.time - TimeManager.Instance.Now().time) / 1000;
         var _loc2_:Array = DateUtils.dateTimeRemainArr(_loc1_);
         return LanguageMgr.GetTranslation("tank.timeRemain.msg1",_loc2_[0],_loc2_[1],_loc2_[2]);
      }
      
      private function addEvents() : void
      {
         this._btnBuyStep.addEventListener("click",this.onClick);
         this._propBtnListened || StageReferance.stage.addEventListener("click",this.onPropBtnClick);
         this._propBtnListened = true;
      }
      
      private function removeEvents() : void
      {
         this._btnBuyStep.removeEventListener("click",this.onClick);
         this._propBtnListened && StageReferance.stage.removeEventListener("click",this.onPropBtnClick);
         this._propBtnListened = false;
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(SanXiaoManager.getInstance().dataEnd.time <= TimeManager.Instance.Now().time)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("sanxiao.timesOut"),0,false,1);
            return;
         }
         var _loc2_:SXBuyTimesFrame = ComponentFactory.Instance.creatComponentByStylename("sanxiao.SanxiaoBuyTimesFrame");
         _loc2_.buyFunction = this.onBuy;
         LayerManager.Instance.addToLayer(_loc2_,3,true,1);
      }
      
      protected function onPropBtnClick(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this._btnPropCrossBomb:
               SanXiaoGameMediator.getInstance().curProp = 1;
               this._btnSelectedProp.x = this._btnPropCrossBomb.x;
               this._btnSelectedProp.y = this._btnPropCrossBomb.y;
               addChild(this._btnSelectedProp);
               this._propCursor.setFrame(1);
               this.showPropCursor();
               break;
            case this._btnPropSquareBomb:
               SanXiaoGameMediator.getInstance().curProp = 2;
               this._btnSelectedProp.x = this._btnPropSquareBomb.x;
               this._btnSelectedProp.y = this._btnPropSquareBomb.y;
               addChild(this._btnSelectedProp);
               this._propCursor.setFrame(2);
               this.showPropCursor();
               break;
            case this._btnPropClearColor:
               SanXiaoGameMediator.getInstance().curProp = 3;
               this._btnSelectedProp.x = this._btnPropClearColor.x;
               this._btnSelectedProp.y = this._btnPropClearColor.y;
               addChild(this._btnSelectedProp);
               this._propCursor.setFrame(3);
               this.showPropCursor();
               break;
            case this._btnPropChangeColor:
               SanXiaoGameMediator.getInstance().curProp = 4;
               this._btnSelectedProp.x = this._btnPropChangeColor.x;
               this._btnSelectedProp.y = this._btnPropChangeColor.y;
               addChild(this._btnSelectedProp);
               this._propCursor.setFrame(4);
               this.showPropCursor();
               break;
            default:
               if(this._curPage == 1 || PlayerManager.Instance.Self.BandMoney < 100 && PlayerManager.Instance.Self.Money < 100)
               {
                  SanXiaoGameMediator.getInstance().curProp = 0;
                  this._btnSelectedProp.parent && removeChild(this._btnSelectedProp);
                  this.hidePropCursor();
               }
         }
      }
      
      private function showPropCursor() : void
      {
         StageReferance.stage.addChild(this._propCursor);
         this._propCursor.x = StageReferance.stage.mouseX + this._cursorOffsetX;
         this._propCursor.y = StageReferance.stage.mouseY + this._cursorOffsetY;
         this._propCursor.startDrag(false);
         StageReferance.stage.addEventListener("mouseMove",this.onCursorMove);
         Mouse.hide();
      }
      
      private function hidePropCursor() : void
      {
         this._propCursor.parent && StageReferance.stage.removeChild(this._propCursor);
         this._propCursor.stopDrag();
         StageReferance.stage.removeEventListener("mouseMove",this.onCursorMove);
         Mouse.show();
      }
      
      protected function onCursorMove(param1:MouseEvent) : void
      {
         Mouse.hide();
      }
      
      private function onBuy(param1:Number, param2:Boolean) : void
      {
         var times:Number = NaN;
         times = param1;
         var isBind:Boolean = param2;
         var goBuy:* = function():void
         {
            SanXiaoGameMediator.getInstance().buyTimes(times,CheckMoneyUtils.instance.isBind);
         };
         CheckMoneyUtils.instance.checkMoney(isBind,int(ServerConfigManager.instance.SanXiaoStepPrice()) * times,goBuy);
      }
      
      public function lockProps() : void
      {
         this._btnPropCrossBomb.enable = false;
         this._btnPropSquareBomb.enable = false;
         this._btnPropClearColor.enable = false;
         this._btnPropChangeColor.enable = false;
         this._curPage = 0;
      }
      
      public function unLockProps() : void
      {
         this._btnPropCrossBomb.enable = true;
         this._btnPropSquareBomb.enable = true;
         this._btnPropClearColor.enable = true;
         this._btnPropChangeColor.enable = true;
         this._curPage = 1;
      }
      
      public function updateDropOutItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = SanXiaoManager.getInstance().dropOutItemList;
         var _loc3_:int = SanXiaoManager.getInstance().lengthAddedDropOutItem;
         this._pageSelector.updateItemDataArr = _loc2_;
         _loc1_ = _loc3_ - 1;
         while(_loc1_ >= 0)
         {
            this._pageSelector.updateByIndex(_loc2_.length - 1 - _loc1_);
            _loc1_--;
         }
      }
      
      public function update() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         this._crystalTxt.text = SanXiaoManager.getInstance().crystalNum.toString();
         this._scoreTxt.text = SanXiaoManager.getInstance().score.toString();
         this._stepRemainTxt.text = SanXiaoManager.getInstance().stepRemain.toString();
         var _loc3_:Number = SanXiaoManager.getInstance().nextPriseScoreProgress;
         this._progress.gotoAndStop(int(_loc3_));
         this._progressTips.tipData = SanXiaoManager.getInstance().progressTipsData;
         this._progressText.text = _loc3_.toString() + "%";
         var _loc4_:SXRewardItemData = SanXiaoManager.getInstance().nextRewardSXRewardItemData;
         if(_loc4_ == null)
         {
            _loc1_ = null;
         }
         else
         {
            _loc1_ = ItemManager.Instance.getTemplateById(_loc4_.TempleteID);
         }
         if(_loc1_ != null)
         {
            _loc2_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc2_,_loc1_);
            _loc2_.ValidDate = _loc4_.Valid;
            _loc2_.Count = _loc4_.count;
            _loc2_.IsBinds = _loc4_.isBind;
            _loc2_.Property5 = "1";
            this._iconBoxBagCell.info = _loc2_;
         }
         else
         {
            this._iconBoxBagCell.info = null;
         }
         if(Boolean(this._timeRemainText))
         {
            this._timeRemainText.text = this.getTimeRemainStr();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this.hidePropCursor();
         this._timeRemainTimer.stop();
         this._timeRemainTimer.removeEventListener("timer",this.__timeRemainHandler);
         TimerManager.getInstance().removeJugglerByTimer(this._timeRemainTimer);
         this._timeRemainTimer = null;
         SanXiaoGameMediator.getInstance().killGame();
         this._game.mask = null;
         ObjectUtils.disposeAllChildren(this);
         this._rewardItemList.length = 0;
         this._rewardItemList = null;
         this._btnPropCrossBomb = null;
         this._btnPropSquareBomb = null;
         this._btnPropClearColor = null;
         this._btnPropChangeColor = null;
         this._btnSelectedProp = null;
         this._propCursor = null;
         this._bg = null;
         this._game = null;
         this._mask = null;
         this._scoreTxt = null;
         this._stepRemainTxt = null;
         this._crystalTxt = null;
         this._btnBuyStep = null;
         this._iconBoxBagCell = null;
         this._progress = null;
         this._bagListView = null;
         this._progressTips = null;
         this._progressText = null;
         this._pageSelector = null;
         this._timeRemainText = null;
         this._timeRemainBmp = null;
      }
   }
}

