package sanXiao.game
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import homeTemple.view.N_BitmapDataNumber;
   import sanXiao.model.Pos;
   import sanXiao.model.SXCellData;
   import sanXiao.model.SXModel;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class SXGame extends Sprite implements Disposeable
   {
      
      private var _model:SXModel;
      
      private var _itemList:Vector.<Vector.<SXCellItem>>;
      
      private var _hits:int;
      
      private var _wordsHitsEffect:MovieClip;
      
      private var _conWordsHitsEffect:MovieClip;
      
      private var _listOfWords:Vector.<Bitmap>;
      
      private var _bmpNum:N_BitmapDataNumber;
      
      private var _hitsTip:Bitmap;
      
      private var _timerCheckDie:TimerJuggler;
      
      private var resetedCount:int = 0;
      
      private var _curProp:int;
      
      private var _selectedA:SXCellItem;
      
      private var _selectedB:SXCellItem;
      
      public var step:int = 0;
      
      private var _movedNum:int;
      
      private var _tipsList:Array;
      
      private var _boomLength:int;
      
      private var tween:TweenLite;
      
      private var tweenMax:TweenMax;
      
      public function SXGame()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.buttonMode = true;
         this.useHandCursor = true;
         this._model = SanXiaoGameMediator.getInstance().model;
         this._itemList = new Vector.<Vector.<SXCellItem>>();
         var _loc4_:Number = this._model.ROW_COUNT;
         var _loc5_:Number = this._model.COLUMN_COUNT;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            this._itemList[_loc1_] = new Vector.<SXCellItem>();
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               this._itemList[_loc1_][_loc2_] = new SXCellItem();
               _loc2_++;
            }
            _loc1_++;
         }
         this._tipsList = [];
         this._wordsHitsEffect = ComponentFactory.Instance.creat("ast.sanxiao.wrodsMovie");
         this._wordsHitsEffect.mouseChildren = false;
         this._wordsHitsEffect.mouseEnabled = false;
         this._wordsHitsEffect.addEventListener("tips_end",this.onTipsEnd);
         this._wordsHitsEffect.x = 115;
         this._wordsHitsEffect.y = 180;
         this._wordsHitsEffect.gotoAndStop(this._wordsHitsEffect.totalFrames);
         addChild(this._wordsHitsEffect);
         this._conWordsHitsEffect = this._wordsHitsEffect.getChildByName("con") as MovieClip;
         this._listOfWords = new Vector.<Bitmap>();
         _loc3_ = 0;
         while(_loc3_ < 6)
         {
            this._listOfWords[_loc3_] = ComponentFactory.Instance.creatBitmap("ast.sanxiao.word" + _loc3_.toString());
            _loc3_++;
         }
         this._listOfWords[_loc3_] = ComponentFactory.Instance.creatBitmap("ast.sanxiao.dieMap");
         this._listOfWords[_loc3_].x = -100;
         this._bmpNum = new N_BitmapDataNumber();
         this._bmpNum.rect = new Rectangle(0,0,170,43);
         this._bmpNum.gap = -1;
         var _loc6_:Vector.<BitmapData> = new Vector.<BitmapData>();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc6_.push(ComponentFactory.Instance.creatBitmapData("ast.sanxiao.n" + _loc1_.toString()));
            _loc1_++;
         }
         this._bmpNum.numList = _loc6_;
         this._bmpNum.dot = ComponentFactory.Instance.creatBitmapData("ast.sanxiao.hits");
         this._hitsTip = new Bitmap(this._bmpNum.getNumber("0"));
         this._timerCheckDie = TimerManager.getInstance().addTimerJuggler(5000);
         this._timerCheckDie.addEventListener("timer",this.onTimerCheckDieFunc);
         StageReferance.stage.addEventListener("click",this.onClick);
      }
      
      protected function onTimerCheckDieFunc(param1:Event) : void
      {
         var _loc2_:Boolean = this._model.isDieMap();
         if(_loc2_)
         {
            this._tipsList.unshift(this._listOfWords[this._listOfWords.length - 1]);
            this.playNextTips();
            SanXiaoGameMediator.getInstance().createNewMap();
         }
         this._timerCheckDie.stop();
      }
      
      internal function resetGame() : void
      {
         var _loc3_:Vector.<Vector.<SXCellData>> = null;
         var _loc4_:Number = NaN;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.tweenMax && this.tweenMax.kill();
         _loc3_ = this._model.map();
         _loc4_ = this._model.ROW_COUNT;
         var _loc5_:Number = this._model.COLUMN_COUNT;
         this.resetedCount = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc5_)
            {
               this._itemList[_loc1_][_loc2_].mouseEnabled = false;
               this._itemList[_loc1_][_loc2_].killBoom();
               this._itemList[_loc1_][_loc2_].type = _loc3_[_loc1_][_loc2_].type;
               this._itemList[_loc1_][_loc2_].curPos = new Pos(_loc1_ - _loc4_,_loc2_);
               this._itemList[_loc1_][_loc2_].moveTo(new Pos(_loc1_,_loc2_),"tween",this.onResetComplete);
               addChildAt(this._itemList[_loc1_][_loc2_],0);
               _loc2_++;
            }
            _loc1_++;
         }
         this._timerCheckDie.reset();
         this._timerCheckDie.start();
      }
      
      private function onResetComplete() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.resetedCount += 1;
         if(this.resetedCount == this._model.ROW_COUNT * this._model.COLUMN_COUNT)
         {
            _loc1_ = 0;
            while(_loc1_ < this._model.ROW_COUNT)
            {
               _loc2_ = 0;
               while(_loc2_ < this._model.COLUMN_COUNT)
               {
                  this._itemList[_loc1_][_loc2_].mouseEnabled = true;
                  _loc2_++;
               }
               _loc1_++;
            }
         }
         SanXiaoGameMediator.getInstance().stopAnimation();
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Boolean = false;
         if(param1.target is SXCellItem)
         {
            if(SanXiaoGameMediator.getInstance().stepRemain <= 0)
            {
               return;
            }
            _loc2_ = param1.target as SXCellItem;
            switch(int(this.step))
            {
               case 0:
                  this._curProp = this._model.curProp;
                  switch(int(this._curProp))
                  {
                     case 0:
                        this._selectedA = _loc2_;
                        this._selectedA.selected = true;
                        this.step = 1;
                        break;
                     default:
                        this.step = 2;
                        SanXiaoGameMediator.getInstance().checkProp(_loc2_.curPos);
                  }
                  break;
               case 1:
                  this.step = 2;
                  this._selectedB = _loc2_;
                  this._selectedB.selected = true;
                  _loc3_ = this._model.cellTypeExchange(this._selectedA.curPos,this._selectedA.type,this._selectedB.curPos,this._selectedB.type);
                  if(_loc3_)
                  {
                     SanXiaoGameMediator.getInstance().startAnimation();
                     this._movedNum = 0;
                     this._selectedA.moveTo(this._selectedB.curPos,"tween",this.afterExchange);
                     this._selectedB.moveTo(this._selectedA.curPos,"tween",this.afterExchange);
                  }
                  else
                  {
                     this.resetStep();
                  }
            }
         }
         else
         {
            this.resetStep();
         }
      }
      
      internal function checkProp(param1:Pos) : void
      {
         switch(int(this._curProp) - 1)
         {
            case 0:
               SanXiaoGameMediator.getInstance().startAnimation();
               this.usePropCrossBomb(param1);
               break;
            case 1:
               SanXiaoGameMediator.getInstance().startAnimation();
               this.usePropSquareBomb(param1);
               break;
            case 2:
               SanXiaoGameMediator.getInstance().startAnimation();
               this.usePropClearColor(param1);
               break;
            case 3:
               SanXiaoGameMediator.getInstance().startAnimation();
               this.usePropChangeColor(param1);
         }
      }
      
      private function afterExchange() : void
      {
         this._movedNum += 1;
         if(this._movedNum < 2)
         {
            return;
         }
         this._hits = 0;
         this.checkBoom();
      }
      
      private function checkBoom() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:Vector.<SXCellData> = this._model.canBoomCellsList([this._selectedA,this._selectedB]);
         if(_loc6_.length > 0)
         {
            SanXiaoGameMediator.getInstance().sendBoomList(this._selectedA,this._selectedB,_loc6_);
            _loc1_ = this._selectedA.curPos.row;
            _loc2_ = this._selectedA.curPos.column;
            _loc3_ = this._selectedB.curPos.row;
            _loc4_ = this._selectedB.curPos.column;
            _loc5_ = this._itemList[_loc1_][_loc2_];
            this._itemList[_loc1_][_loc2_] = this._itemList[_loc3_][_loc4_];
            this._itemList[_loc3_][_loc4_] = _loc5_;
            this.boomHitsTips();
            this.boom(_loc6_);
         }
         else
         {
            this._model.cellTypeExchange(this._selectedA.curPos,this._selectedA.type,this._selectedB.curPos,this._selectedB.type);
            this._hits = 0;
            this._selectedA.moveTo(this._selectedB.curPos,"tween",this.resetStep);
            this._selectedB.moveTo(this._selectedA.curPos,"tween",this.resetStep);
            SanXiaoGameMediator.getInstance().stopAnimation();
         }
      }
      
      private function playNextTips() : void
      {
         var _loc1_:* = null;
         if(this._tipsList.length > 0 && this._wordsHitsEffect.currentFrame == this._wordsHitsEffect.totalFrames)
         {
            _loc1_ = this._tipsList.pop() as Bitmap;
            if(this._conWordsHitsEffect.numChildren > 0)
            {
               this._conWordsHitsEffect.removeChildAt(0);
            }
            this._conWordsHitsEffect.addChild(_loc1_);
            this._wordsHitsEffect.gotoAndPlay(1);
         }
      }
      
      protected function onTipsEnd(param1:Event) : void
      {
         this.playNextTips();
      }
      
      private function boomHitsTips() : void
      {
         if(this._hits > 1)
         {
            this._hitsTip.bitmapData = this._bmpNum.getNumber((this._hits - 1).toString() + ".");
            this._tipsList.unshift(this._hitsTip);
            this.playNextTips();
         }
      }
      
      private function boomPraiseWordsTip() : void
      {
         switch(int(this._hits) - 1)
         {
            case 0:
            case 1:
               break;
            case 2:
            case 3:
               this._tipsList.unshift(this._listOfWords[2]);
               break;
            case 4:
            case 5:
            case 6:
               this._tipsList.unshift(this._listOfWords[3]);
               break;
            case 7:
            case 8:
            case 9:
               this._tipsList.unshift(this._listOfWords[4]);
               break;
            default:
               this._tipsList.unshift(this._listOfWords[5]);
         }
         this.playNextTips();
      }
      
      private function resetStep() : void
      {
         this._selectedA && (this._selectedA.selected = false);
         this._selectedA = null;
         this._selectedB && (this._selectedB.selected = false);
         this._selectedB = null;
         this.step = 0;
      }
      
      private function boom(param1:Vector.<SXCellData>) : void
      {
         var v:*;
         var $boomList:Vector.<SXCellData> = null;
         var boomedList:Vector.<SXCellItem> = null;
         var movedList:Array = null;
         $boomList = param1;
         var onBoom:* = function():void
         {
            var j:int;
            var fillList:Vector.<SXCellData>;
            var rowDic:Dictionary;
            var c:int;
            var k:int;
            var checkHits:* = undefined;
            var falled:int = 0;
            var lenFall:int = 0;
            var emptyCellNum:int = 0;
            var i:int = 0;
            var _loc2_:* = undefined;
            var _loc3_:* = undefined;
            var onFall:* = function():void
            {
               falled += 1;
               if(falled == lenFall)
               {
                  tween = TweenLite.delayedCall(0.3,checkHits);
               }
            };
            checkHits = function():void
            {
               var _loc1_:Vector.<SXCellData> = _model.canBoomCellsList(movedList);
               if(_loc1_.length > 0)
               {
                  SanXiaoGameMediator.getInstance().sendBoomList(null,null,_loc1_);
                  boom(_loc1_);
               }
               else
               {
                  SanXiaoGameMediator.getInstance().stopAnimation();
                  boomPraiseWordsTip();
                  this.mask = null;
                  resetStep();
                  SanXiaoGameMediator.getInstance().sendHitsEnd();
               }
            };
            if(_model == null)
            {
               return;
            }
            j = 0;
            while(j < _model.COLUMN_COUNT)
            {
               emptyCellNum = 0;
               i = _model.ROW_COUNT - 1;
               while(i >= 0)
               {
                  if(_itemList[i][j].type == 0)
                  {
                     emptyCellNum += 1;
                  }
                  else if(emptyCellNum > 0)
                  {
                     movedList.push(_itemList[i][j]);
                     _itemList[i][j].moveTo(new Pos(i + emptyCellNum,j));
                     _itemList[i + emptyCellNum][j] = _itemList[i][j];
                  }
                  i--;
               }
               j++;
            }
            fillList = _model.boomAndFall($boomList);
            rowDic = new Dictionary();
            c = 0;
            while(c < _model.COLUMN_COUNT)
            {
               rowDic[c] = 0;
               c++;
            }
            falled = 0;
            lenFall = int(fillList.length);
            k = 0;
            while(k < lenFall)
            {
               _loc2_ = fillList[k].column;
               _loc3_ = rowDic[_loc2_] - 1;
               rowDic[_loc2_] = _loc3_;
               boomedList[k].moveTo(new Pos(rowDic[fillList[k].column],fillList[k].column),"immediately");
               boomedList[k].killBoom();
               boomedList[k].type = fillList[k].type;
               boomedList[k].moveTo(new Pos(fillList[k].row,fillList[k].column),"tween",onFall);
               _itemList[fillList[k].row][fillList[k].column] = boomedList[k];
               movedList.push(boomedList[k]);
               k++;
            }
            SanXiaoGameMediator.getInstance().sendFillList(_model.mapDataArray());
            rowDic = null;
         };
         this._timerCheckDie.reset();
         this._timerCheckDie.start();
         this._hits += 1;
         this.boomHitsTips();
         boomedList = new Vector.<SXCellItem>();
         movedList = [];
         this._boomLength = $boomList.length;
         v = null;
         for each(v in $boomList)
         {
            boomedList.push(this._itemList[v.row][v.column]);
            this._itemList[v.row][v.column].boom();
         }
         this.tweenMax = TweenMax.delayedCall(1,onBoom);
      }
      
      private function usePropCrossBomb(param1:Pos) : void
      {
         var _loc2_:Vector.<SXCellData> = this._model.cellPropCrossBomb(param1);
         SanXiaoGameMediator.getInstance().sendUseCrossBomb();
         SanXiaoGameMediator.getInstance().sendBoomList(null,null,_loc2_);
         this._hits = 0;
         this.boom(_loc2_);
      }
      
      private function usePropSquareBomb(param1:Pos) : void
      {
         var _loc2_:Vector.<SXCellData> = this._model.cellPropSquareBomb(param1);
         SanXiaoGameMediator.getInstance().sendUseSquareBomb();
         SanXiaoGameMediator.getInstance().sendBoomList(null,null,_loc2_);
         this._hits = 0;
         this.boom(_loc2_);
      }
      
      private function usePropClearColor(param1:Pos) : void
      {
         var _loc2_:Vector.<SXCellData> = this._model.cellPropClearColor(param1);
         SanXiaoGameMediator.getInstance().sendUseClearColor();
         SanXiaoGameMediator.getInstance().sendBoomList(null,null,_loc2_);
         this._hits = 0;
         this.boom(_loc2_);
      }
      
      private function usePropChangeColor(param1:Pos) : void
      {
         var _loc2_:int = this._itemList[param1.row][param1.column].type;
         var _loc3_:Vector.<SXCellData> = this._model.cellPropChangeColor(param1);
         SanXiaoGameMediator.getInstance().sendUseChangeColor(_loc2_,_loc3_[0].type);
         this.changeColor(_loc3_);
         TweenLite.delayedCall(0.5,this.checkBoomChangeColor,[_loc3_]);
      }
      
      private function changeColor(param1:Vector.<SXCellData>) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in param1)
         {
            this._itemList[_loc2_.row][_loc2_.column].type = _loc2_.type;
         }
      }
      
      private function checkBoomChangeColor(param1:Vector.<SXCellData>) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         this._hits = 0;
         var _loc4_:Array = [];
         var _loc5_:int = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = param1[_loc3_];
            _loc4_.push(this._itemList[_loc2_.row][_loc2_.column]);
            _loc3_++;
         }
         var _loc6_:Vector.<SXCellData> = this._model.canBoomCellsList(_loc4_);
         if(_loc6_.length > 0)
         {
            SanXiaoGameMediator.getInstance().sendBoomList(null,null,_loc6_);
            this.boom(_loc6_);
         }
         else
         {
            SanXiaoGameMediator.getInstance().stopAnimation();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         StageReferance.stage.removeEventListener("click",this.onClick);
         TweenLite.killDelayedCallsTo(this.tween);
         TweenMax.killDelayedCallsTo(this.tweenMax);
         if(this._itemList != null)
         {
            _loc1_ = this._model.ROW_COUNT;
            _loc2_ = this._model.COLUMN_COUNT;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  TweenMax.killTweensOf(this._itemList[_loc3_][_loc4_]);
                  ObjectUtils.disposeObject(this._itemList[_loc3_][_loc4_]);
                  _loc4_++;
               }
               this._itemList[_loc3_].length = 0;
               _loc3_++;
            }
            this._itemList.length = 0;
            this._itemList = null;
         }
         this._timerCheckDie.stop();
         TimerManager.getInstance().removeJugglerByTimer(this._timerCheckDie);
         this._timerCheckDie = null;
         this._model = null;
         this.mask = null;
         if(Boolean(this._conWordsHitsEffect))
         {
            this._conWordsHitsEffect.stop();
            ObjectUtils.disposeObject(this._conWordsHitsEffect);
            this._conWordsHitsEffect = null;
         }
         if(Boolean(this._wordsHitsEffect))
         {
            this._wordsHitsEffect.stop();
            this._wordsHitsEffect.removeEventListener("tips_end",this.onTipsEnd);
            ObjectUtils.disposeObject(this._wordsHitsEffect);
            this._wordsHitsEffect = null;
         }
         this._tipsList.length = 0;
         this._tipsList = null;
         this._hitsTip = null;
         this._bmpNum = null;
      }
   }
}

