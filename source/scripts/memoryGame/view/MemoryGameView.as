package memoryGame.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import memoryGame.MemoryGameManager;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class MemoryGameView extends Sprite implements Disposeable
   {
      
      private const MAX_CELL:int = 16;
      
      private var _bg:Bitmap;
      
      private var _openCountText:FilterFrameText;
      
      private var _dayText:FilterFrameText;
      
      private var _timeRemainTimer:TimerJuggler;
      
      private var _scoreText:FilterFrameText;
      
      private var _cellList:DictionaryData;
      
      private var _cellContainer:Sprite;
      
      private var _rewardList:DictionaryData;
      
      private var _rewardContainer:Sprite;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _resetBtn:SimpleBitmapButton;
      
      private var _frame:MemoryGameFrame;
      
      private var _infoList:Vector.<MemoryGameInfo>;
      
      private var _closeList:Array;
      
      public function MemoryGameView(param1:MemoryGameFrame)
      {
         super();
         this.init();
         this.initCell();
         this.initReward();
         this.initEvent();
         this._frame = param1;
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.memoryGame.view.bg");
         addChild(this._bg);
         this._cellContainer = new Sprite();
         PositionUtils.setPos(this._cellContainer,"memoryGame.cellContainerPos");
         addChild(this._cellContainer);
         this._rewardContainer = new Sprite();
         PositionUtils.setPos(this._rewardContainer,"memoryGame.rewardContainerPos");
         addChild(this._rewardContainer);
         this._openCountText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.openCountText");
         addChild(this._openCountText);
         this._dayText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.dayText");
         this._dayText.text = this.getTimeRemainStr();
         addChild(this._dayText);
         this._timeRemainTimer = TimerManager.getInstance().addTimerJuggler(10000);
         this._timeRemainTimer.addEventListener("timer",this.__timeRemainHandler);
         this._timeRemainTimer.start();
         this._scoreText = ComponentFactory.Instance.creatComponentByStylename("memoryGame.scoreText");
         addChild(this._scoreText);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("memoryGame.buyBtn");
         addChild(this._buyBtn);
         this._resetBtn = ComponentFactory.Instance.creatComponentByStylename("memoryGame.resetBtn");
         addChild(this._resetBtn);
         this._infoList = new Vector.<MemoryGameInfo>();
      }
      
      private function __timeRemainHandler(param1:Event) : void
      {
         if(Boolean(this._dayText))
         {
            this._dayText.text = this.getTimeRemainStr();
         }
      }
      
      private function getTimeRemainStr() : String
      {
         var _loc1_:Number = (MemoryGameManager.instance.endDate.time - TimeManager.Instance.Now().time) / 1000;
         var _loc2_:Array = DateUtils.dateTimeRemainArr(_loc1_);
         return LanguageMgr.GetTranslation("tank.timeRemain.msg1",_loc2_[0],_loc2_[1],_loc2_[2]);
      }
      
      private function initCell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._cellList = new DictionaryData();
         _loc1_ = 0;
         while(_loc1_ < 16)
         {
            _loc2_ = new MemoryGameCell(_loc1_ + 1);
            this._cellContainer.addChild(_loc2_);
            _loc2_.x = _loc1_ % 4 * 96;
            _loc2_.y = int(_loc1_ / 4) * 96;
            this._cellList.add(_loc1_ + 1,_loc2_);
            _loc1_++;
         }
      }
      
      private function initReward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._rewardList = new DictionaryData();
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = new MemoryGameRewardCell();
            _loc2_.x = _loc1_ % 4 * 74;
            _loc2_.y = int(_loc1_ / 4) * 80;
            this._rewardContainer.addChild(_loc2_);
            this._rewardList.add(_loc1_,_loc2_);
            _loc1_++;
         }
      }
      
      private function __onGameInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         MemoryGameManager.instance.count = param1.pkg.readInt();
         MemoryGameManager.instance.score = param1.pkg.readInt();
         if(Boolean(this._frame))
         {
            this._frame.shopViewUpdate();
         }
         this.updateText();
         var _loc4_:int = param1.pkg.readInt();
         this._infoList.splice(0,this._infoList.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = new MemoryGameInfo();
            _loc3_.TemplateID = param1.pkg.readInt();
            _loc3_.count = param1.pkg.readInt();
            _loc3_.place1 = param1.pkg.readInt();
            _loc3_.place2 = param1.pkg.readInt();
            _loc3_.isGet = param1.pkg.readBoolean();
            _loc3_.show1 = param1.pkg.readBoolean();
            _loc3_.show2 = param1.pkg.readBoolean();
            this._infoList.push(_loc3_);
            _loc2_++;
         }
         var _loc5_:Boolean = param1.pkg.readBoolean();
         MemoryGameManager.instance.getRewardList.clear();
         _loc4_ = param1.pkg.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            MemoryGameManager.instance.getRewardList.add(param1.pkg.readInt(),true);
            _loc2_++;
         }
         this.update(_loc5_);
         if(!_loc5_)
         {
            this.gameReset();
         }
      }
      
      private function update(param1:Boolean) : void
      {
         var _loc6_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in this._cellList)
         {
            _loc6_.closeDefault();
         }
         _loc2_ = 0;
         while(_loc2_ < this._infoList.length)
         {
            _loc3_ = this._rewardList[_loc2_] as MemoryGameRewardCell;
            _loc4_ = this._infoList[_loc2_].TemplateID;
            _loc5_ = this._infoList[_loc2_].count;
            _loc3_.info = ItemManager.Instance.getTemplateById(_loc4_);
            _loc3_.setCount(_loc5_);
            _loc3_.isGain = this._infoList[_loc2_].isGet;
            if(param1)
            {
               _loc3_.playAction();
            }
            if(this._infoList[_loc2_].isGet)
            {
               this._cellList[this._infoList[_loc2_].place1].openDefault(_loc4_,_loc5_);
               this._cellList[this._infoList[_loc2_].place2].openDefault(_loc4_,_loc5_);
            }
            else
            {
               if(this._infoList[_loc2_].show1)
               {
                  this._cellList[this._infoList[_loc2_].place1].openDefault(_loc4_,_loc5_);
               }
               if(this._infoList[_loc2_].show2)
               {
                  this._cellList[this._infoList[_loc2_].place2].openDefault(_loc4_,_loc5_);
               }
            }
            _loc2_++;
         }
      }
      
      private function __onGameTurnover(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:* = null;
         this._closeList = [];
         MemoryGameManager.instance.count = param1.pkg.readInt();
         MemoryGameManager.instance.score = param1.pkg.readInt();
         this.updateText();
         var _loc9_:int = param1.pkg.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc9_)
         {
            _loc3_ = param1.pkg.readInt();
            _loc4_ = param1.pkg.readInt();
            _loc5_ = param1.pkg.readInt();
            _loc6_ = param1.pkg.readBoolean();
            _loc7_ = param1.pkg.readBoolean();
            _loc8_ = this._cellList[_loc5_] as MemoryGameCell;
            _loc8_.open(_loc3_,_loc4_);
            if(_loc7_ && _loc2_ == 0)
            {
               this.rewardIsGet(_loc3_,_loc4_);
               this.gameReset();
            }
            else if(!_loc6_)
            {
               this._closeList.push(_loc8_);
            }
            _loc2_++;
         }
         if(this._closeList.length >= 2)
         {
            MemoryGameManager.instance.turning = true;
            addEventListener("enterFrame",this.__onEnter);
         }
      }
      
      private function __onEnter(param1:Event) : void
      {
         if(MemoryGameManager.instance.playOpenAllComplete())
         {
            removeEventListener("enterFrame",this.__onEnter);
            this.closeAction();
         }
      }
      
      private function closeAction() : void
      {
         var timeout:int = 0;
         if(Boolean(this._closeList.length))
         {
            timeout = int(setTimeout(function():void
            {
               var _loc1_:* = 0;
               _loc1_ = 0;
               while(_loc1_ < _closeList.length)
               {
                  _closeList[_loc1_].close();
                  _loc1_++;
               }
               MemoryGameManager.instance.turning = false;
               _closeList.splice(0,_closeList.length);
               clearTimeout(timeout);
            },1000));
         }
      }
      
      public function gameReset() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:BaseAlerFrame = null;
         for each(_loc1_ in this._rewardList)
         {
            if(!_loc1_.isGain)
            {
               return;
            }
         }
         _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("memoryGame.gameover"),LanguageMgr.GetTranslation("ok"),"",false,true,true,2,null,"SimpleAlert",60,false);
         _loc2_.addEventListener("response",this.onResponse);
      }
      
      private function onResponse(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         if(MemoryGameManager.instance.playActionAllComplete() && !MemoryGameManager.instance.turning)
         {
            _loc2_ = param1.currentTarget as BaseAlerFrame;
            _loc2_.removeEventListener("response",this.onResponse);
            SocketManager.Instance.out.sendMemoryGameReset(true,true);
            _loc2_.dispose();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.notClose"));
         }
      }
      
      private function rewardIsGet(param1:int, param2:int) : void
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in this._rewardList)
         {
            if(_loc3_.info.TemplateID == param1 && _loc3_.getCount() == param2)
            {
               _loc3_.isGain = true;
            }
         }
      }
      
      private function __onResetClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!MemoryGameManager.instance.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.activityTips"));
            return;
         }
         if(MemoryGameManager.instance.playActionAllComplete() && !MemoryGameManager.instance.turning)
         {
            _loc2_ = ServerConfigManager.instance.memoryGameResetMoney();
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("memoryGame.resetTips",_loc2_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2,null,"SimpleAlert",60,false,1);
            _loc3_.addEventListener("response",this.onResetConfirmResponse);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.notClose"));
         }
      }
      
      private function onResetConfirmResponse(param1:FrameEvent) : void
      {
         var e:FrameEvent = param1;
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener("response",this.onResetConfirmResponse);
         if(e.responseCode == 2 || e.responseCode == 3)
         {
            CheckMoneyUtils.instance.checkMoney(frame.isBand,ServerConfigManager.instance.memoryGameResetMoney(),function():void
            {
               SocketManager.Instance.out.sendMemoryGameReset(CheckMoneyUtils.instance.isBind);
            });
         }
         frame.dispose();
      }
      
      private function __onBuyClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!MemoryGameManager.instance.isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("memoryGame.activityTips"));
            return;
         }
         var _loc2_:MemoryGameBuyView = ComponentFactory.Instance.creatComponentByStylename("memroyGame.MemoryGameBuyView");
         _loc2_.show();
      }
      
      private function __onGameBuy(param1:CrazyTankSocketEvent) : void
      {
         MemoryGameManager.instance.count = param1.pkg.readInt();
         this.updateText();
      }
      
      private function updateText() : void
      {
         this._openCountText.text = MemoryGameManager.instance.count.toString();
         this._scoreText.text = MemoryGameManager.instance.score.toString();
      }
      
      private function initEvent() : void
      {
         this._buyBtn.addEventListener("click",this.__onBuyClick);
         this._resetBtn.addEventListener("click",this.__onResetClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MEMORYGAME_INFO,this.__onGameInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MEMORYGAME_TURNOVER,this.__onGameTurnover);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MEMORYGAME_BUY,this.__onGameBuy);
      }
      
      private function removeEvent() : void
      {
         this._buyBtn.removeEventListener("click",this.__onBuyClick);
         this._resetBtn.removeEventListener("click",this.__onResetClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MEMORYGAME_INFO,this.__onGameInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MEMORYGAME_TURNOVER,this.__onGameTurnover);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MEMORYGAME_BUY,this.__onGameBuy);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._timeRemainTimer.stop();
         this._timeRemainTimer.removeEventListener("timer",this.__timeRemainHandler);
         TimerManager.getInstance().removeJugglerByTimer(this._timeRemainTimer);
         this._timeRemainTimer = null;
         ObjectUtils.disposeAllChildren(this._cellContainer);
         ObjectUtils.disposeAllChildren(this._rewardContainer);
         this._cellList.clear();
         this._rewardList.clear();
         ObjectUtils.disposeAllChildren(this);
         this._infoList.splice(0,this._infoList.length);
         this._infoList = null;
         this._bg = null;
         this._cellContainer = null;
         this._rewardContainer = null;
         this._cellList = null;
         this._rewardList = null;
         this._frame = null;
      }
   }
}

class MemoryGameInfo
{
   
   public var TemplateID:int;
   
   public var count:int;
   
   public var place1:int;
   
   public var place2:int;
   
   public var isGet:Boolean;
   
   public var show1:Boolean;
   
   public var show2:Boolean;
   
   public function MemoryGameInfo()
   {
      super();
   }
}
