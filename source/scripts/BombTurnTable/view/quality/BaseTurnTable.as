package BombTurnTable.view.quality
{
   import BombTurnTable.TurnTableHandlerControl;
   import BombTurnTable.data.BombTurnTableInfo;
   import BombTurnTable.event.TurnTableEvent;
   import BombTurnTable.view.LotteryPointer;
   import BombTurnTable.view.TurnTableGoodCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import road7th.data.DictionaryData;
   
   public class BaseTurnTable extends Sprite implements Disposeable
   {
      
      protected var _curLevel:int;
      
      private var _turnTableHandlerCon:TurnTableHandlerControl;
      
      protected var _bgBorder:Bitmap;
      
      protected var _bg:Bitmap;
      
      protected var _lotteryBtn:LotteryPointer;
      
      protected var _explanationTxt:FilterFrameText;
      
      protected var _lotteryTicket:FilterFrameText;
      
      protected var _turnTableCon:Sprite;
      
      protected var _goodsItem:DictionaryData;
      
      protected var _goodsData:BombTurnTableInfo;
      
      protected var _goodsPoint:Array = [new Point(38,-167),new Point(145,-91),new Point(167,37),new Point(94,143),new Point(-38,167),new Point(-145,91),new Point(-167,-37),new Point(-110,-143)];
      
      protected var _goodsRotation:Array = [22,67,112,157,-158,-113,-68,-23];
      
      protected var _specialGoodsID:Array = [-1,-2];
      
      protected var _selectEffPoint:Array = [new Point(0.9,-212),new Point(152,-150),new Point(216,4.4),new Point(147.5,156.6),new Point(-7,217),new Point(-154.8,150),new Point(-215,-1.65),new Point(-149,-150)];
      
      protected var _selectEffRotation:Array = [22,67,113,158,-157,-112,-67,-23];
      
      protected var _selectMc:MovieClip;
      
      protected var _curStatus:int = 1;
      
      private var _temCell:TurnTableGoodCell;
      
      private var intervalId:uint;
      
      private var delay:Number = 1000;
      
      public function BaseTurnTable(param1:int)
      {
         this._curStatus = param1;
         super();
         this._goodsItem = new DictionaryData();
         this._turnTableHandlerCon = new TurnTableHandlerControl(this.lotteryComplate_Handler);
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._turnTableCon = new Sprite();
         this._turnTableCon.rotation += 22.5;
         this._turnTableCon.x = 280;
         this._turnTableCon.y = 283;
         this._selectMc = ComponentFactory.Instance.creat("asset.bombTurnTable.selectMc");
         this._selectMc.x = this._selectEffPoint[0].x;
         this._selectMc.y = this._selectEffPoint[0].y;
         this._selectMc.rotation = this._selectEffRotation[0];
         addChild(this._selectMc);
         this._selectMc.visible = false;
         this._bg = ComponentFactory.Instance.creatBitmap(this.bgResource);
         this._bg.x = -this._bg.width >> 1;
         this._bg.y = -this._bg.height >> 1;
         this._bg.smoothing = true;
         this._turnTableCon.addChild(this._bg);
         this._turnTableCon.addChild(this._selectMc);
         addChild(this._turnTableCon);
         this._bgBorder = ComponentFactory.Instance.creatBitmap(this.bgBorResource);
         addChild(this._bgBorder);
         this._lotteryBtn = new LotteryPointer(this.quality,this._curStatus);
         addChild(this._lotteryBtn);
         PositionUtils.setPos(this._lotteryBtn,"bombTurnTable.lotteryBtn.postion");
         this._explanationTxt = ComponentFactory.Instance.creatComponentByStylename("bombTurnTable.explanation.textStyle");
         this._explanationTxt.text = ServerConfigManager.instance.getNeedUseLotteryKicket(this.quality).toString();
         addChild(this._explanationTxt);
         this._lotteryTicket = ComponentFactory.Instance.creatComponentByStylename("bombTurnTable.lotteryTicket.textStyle");
         addChild(this._lotteryTicket);
         this.updateLayout();
      }
      
      protected function updateLayout() : void
      {
      }
      
      protected function initEvent() : void
      {
         if(Boolean(this._lotteryBtn))
         {
            this._lotteryBtn.addEventListener("ClickLottery",this.clickLottery_Handler);
         }
      }
      
      public function get lotteryBtn() : LotteryPointer
      {
         return this._lotteryBtn;
      }
      
      protected function clickLottery_Handler(param1:TurnTableEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.dispatchEvent(new TurnTableEvent("ClickLottery",param1.data));
      }
      
      public function updateAwardGood(param1:BombTurnTableInfo) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = null;
         var _loc3_:int = 0;
         this._goodsData = param1;
         if(this._turnTableCon == null || this._goodsData == null)
         {
            return;
         }
         var _loc4_:int = int(this._goodsData.goodsInfo.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this._goodsData.goodsInfo[_loc3_];
            this._temCell = new TurnTableGoodCell(_loc2_,this.quality);
            this._temCell.x = this._goodsPoint[_loc2_.place - 1].x;
            this._temCell.y = this._goodsPoint[_loc2_.place - 1].y;
            this._temCell.rotation = this._goodsRotation[_loc2_.place - 1];
            if(_loc2_.templateId > 0)
            {
               this._temCell.filters = _loc2_.isReceive == 1 ? null : ComponentFactory.Instance.creatFilters("grayFilter");
            }
            this._turnTableCon.addChild(this._temCell);
            this._goodsItem[_loc2_.place] = this._temCell;
            _loc3_++;
         }
      }
      
      public function updateLotteryTicket(param1:int) : void
      {
         this._lotteryTicket.text = param1.toString();
      }
      
      protected function lotteryComplate_Handler(param1:int) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = null;
         var _loc3_:* = null;
         if(Boolean(this._goodsItem) && this._goodsItem.hasKey(param1))
         {
            _loc2_ = this._goodsItem[param1] as TurnTableGoodCell;
            this._selectMc.rotation = this._selectEffRotation[param1 - 1];
            this._selectMc.x = this._selectEffPoint[param1 - 1].x;
            this._selectMc.y = this._selectEffPoint[param1 - 1].y;
            this._selectMc.visible = true;
            this._selectMc.gotoAndStop(0);
            this._selectMc.play();
            if(_loc2_.info.templateId > 0)
            {
               _loc3_ = LanguageMgr.GetTranslation("ddt.bombTurnTable.winningGoodMsg",_loc2_.getGoodName());
            }
            else if(_loc2_.info.templateId == -1)
            {
               _loc3_ = LanguageMgr.GetTranslation("ddt.bombTurnTable.turnTable.updrageMsg");
            }
            else if(_loc2_.info.templateId == -2)
            {
               _loc3_ = LanguageMgr.GetTranslation("ddt.bombTurnTable.turnTable.dedrageMsg");
            }
            MessageTipManager.getInstance().show(_loc3_);
            this.intervalId = setTimeout(this.myDelayedFunction,this.delay);
         }
      }
      
      public function myDelayedFunction() : void
      {
         clearTimeout(this.intervalId);
         this.dispatchEvent(new TurnTableEvent("lotteryComplate",null));
      }
      
      public function startLottery(param1:int) : void
      {
         if(Boolean(this._turnTableHandlerCon) && Boolean(this._goodsItem) && this._goodsItem.hasKey(param1))
         {
            this._turnTableHandlerCon.setData(this,param1);
            this._turnTableHandlerCon.startLottery();
         }
      }
      
      public function get turnTable() : Sprite
      {
         return this._turnTableCon;
      }
      
      protected function get bgBorResource() : String
      {
         return "asset.bombTurnTable.white";
      }
      
      protected function get bgResource() : String
      {
         return "asset.bombTurnTable.whiteBg";
      }
      
      public function get quality() : int
      {
         return 0;
      }
      
      public function get level() : int
      {
         return this._goodsData.level;
      }
      
      public function clear() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         if(Boolean(this._turnTableCon))
         {
            _loc1_ = this._turnTableCon.numChildren;
            if(_loc1_ > 2)
            {
               this._turnTableCon.removeChildren(2,_loc1_ - 1);
            }
         }
         if(Boolean(this._goodsItem))
         {
            for each(_loc2_ in this._goodsItem)
            {
               ObjectUtils.disposeObject(_loc2_);
            }
            this._goodsItem.clear();
         }
      }
      
      public function dispose() : void
      {
         this.clear();
         this._goodsItem = null;
         this._temCell = null;
         this._goodsData = null;
         if(Boolean(this._lotteryBtn))
         {
            this._lotteryBtn.removeEventListener("ClickLottery",this.clickLottery_Handler);
            ObjectUtils.disposeObject(this._lotteryBtn);
            this._lotteryBtn = null;
         }
         if(Boolean(this._bgBorder))
         {
            ObjectUtils.disposeObject(this._bgBorder);
         }
         this._bgBorder = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(Boolean(this._selectMc))
         {
            ObjectUtils.disposeObject(this._selectMc);
            this._selectMc = null;
         }
         if(Boolean(this._lotteryTicket))
         {
            ObjectUtils.disposeObject(this._lotteryTicket);
         }
         this._lotteryTicket = null;
         if(Boolean(this._explanationTxt))
         {
            ObjectUtils.disposeObject(this._explanationTxt);
         }
         this._explanationTxt = null;
         if(Boolean(this._turnTableCon))
         {
            this._turnTableCon.removeChildren();
            ObjectUtils.disposeObject(this._turnTableCon);
         }
         this._turnTableCon = null;
         if(Boolean(this._turnTableHandlerCon))
         {
            this._turnTableHandlerCon.stop();
         }
         this._turnTableHandlerCon = null;
      }
   }
}

