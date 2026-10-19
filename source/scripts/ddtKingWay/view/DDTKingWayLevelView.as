package ddtKingWay.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import ddt.events.TaskEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddtKingWay.DDTKingWayManager;
   import ddtKingWay.analyzer.DDTKingWayData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DDTKingWayLevelView extends Sprite implements Disposeable
   {
      
      private const COUNT:int = 4;
      
      private var _remainingTimeTextBg:FilterFrameText;
      
      private var _remainingTimeText1:FilterFrameText;
      
      private var _remainingTimeText2:FilterFrameText;
      
      private var _timeUnitText:FilterFrameText;
      
      private var _itemList:Vector.<DDTKingWayLevelTargetItem>;
      
      private var _cellList:Vector.<DDTKingWayRewardCell>;
      
      private var _hBox:HBox;
      
      private var _getRewardBtn:BaseButton;
      
      private var _remainingTime:String;
      
      private var _taskInfo:QuestInfo;
      
      private var _info:DDTKingWayData;
      
      private var _timeUnit:int;
      
      private var _isGardeRange:Boolean;
      
      public function DDTKingWayLevelView()
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         super();
         this._remainingTimeText1 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.remainingTimeText1");
         this._remainingTimeText2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.remainingTimeText2");
         this._remainingTimeTextBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.remainingTimeTextBg");
         this._timeUnitText = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.remainingTimeUnitText");
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.Hbox");
         this._getRewardBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtKingWay.getAwardBtn");
         addChild(this._remainingTimeText1);
         addChild(this._remainingTimeText2);
         addChild(this._remainingTimeTextBg);
         addChild(this._timeUnitText);
         addChild(this._hBox);
         addChild(this._getRewardBtn);
         this._cellList = new Vector.<DDTKingWayRewardCell>();
         this._itemList = new Vector.<DDTKingWayLevelTargetItem>(4);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new DDTKingWayLevelTargetItem(_loc1_);
            PositionUtils.setPos(_loc2_,"asset.ddtKingWay.itemPos" + _loc1_);
            this._itemList[_loc1_] = _loc2_;
            addChild(this._itemList[_loc1_]);
            _loc1_++;
         }
         this._getRewardBtn.addEventListener("click",this.__onGetRewardClick);
         TaskManager.addEventListener("changed",this.__onQuestChange);
      }
      
      public function updataView(param1:DDTKingWayData, param2:Boolean = true) : void
      {
         this._info = param1;
         this._taskInfo = TaskManager.instance.getQuestByID(this._info.QuestID);
         this._isGardeRange = param2;
         if(this._isGardeRange)
         {
            if(Boolean(this._taskInfo.data) && Boolean(!(this._taskInfo.isAchieved && !this._taskInfo.isAvailable)) && !this.timeOut(this._taskInfo,this._info))
            {
               this._remainingTimeText1.visible = true;
               this._remainingTimeText2.visible = false;
               this._remainingTimeText1.text = String(this._remainingTime);
               this._remainingTimeTextBg.text = LanguageMgr.GetTranslation("ddtKingWay.remainingTime");
            }
            else
            {
               this._remainingTimeText1.visible = false;
               this._remainingTimeText2.visible = true;
               this._remainingTimeTextBg.text = "";
               if(this._taskInfo.data == null || this._taskInfo.isAchieved && !this._taskInfo.isAvailable)
               {
                  this._remainingTimeText2.text = LanguageMgr.GetTranslation("storeFine.forge.state1");
               }
               else
               {
                  this._remainingTimeText2.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               }
            }
         }
         else
         {
            this._remainingTimeText1.visible = false;
            this._remainingTimeText2.visible = true;
            this._remainingTimeTextBg.text = "";
            this._remainingTimeText2.text = LanguageMgr.GetTranslation("ddtKingWay.nextRemainingTime");
         }
         this.updataItem();
         this.updateRewardShow();
         this.updataTimeUnit();
      }
      
      private function updataTimeUnit() : void
      {
         if(this._isGardeRange)
         {
            if(this._timeUnit == 3)
            {
               this._timeUnitText.text = LanguageMgr.GetTranslation("wonderfulActivityManager.d");
            }
            else if(this._timeUnit == 2 || this._timeUnit == 1)
            {
               this._timeUnitText.text = LanguageMgr.GetTranslation("wonderfulActivityManager.h");
            }
            else if(this._timeUnit == 0)
            {
               this._timeUnitText.text = "";
            }
         }
         else
         {
            this._timeUnitText.text = "";
         }
      }
      
      private function updataItem(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            this._itemList[_loc2_].updataStutas(this._taskInfo,this.timeOut(this._taskInfo,this._info),this._isGardeRange);
            _loc2_++;
         }
      }
      
      public function timeOut(param1:QuestInfo, param2:DDTKingWayData) : Boolean
      {
         var _loc3_:Date = TimeManager.Instance.Now();
         if(param1.data != null || param1.isAchieved && !param1.isAvailable)
         {
            this._remainingTime = this.getTimeDiff(_loc3_,param1,param2);
            if(this._remainingTime == "0")
            {
               return true;
            }
            return false;
         }
         this.updateTime(0);
         return true;
      }
      
      public function getTimeDiff(param1:Date, param2:QuestInfo, param3:DDTKingWayData) : String
      {
         var _loc8_:Number = NaN;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         _loc8_ = Math.round((param2.data.AddTiemsDate.getTime() + param3.Validay * 60 * 60 * 24 * 1000 - param1.getTime()) / 1000);
         if(_loc8_ >= 0)
         {
            _loc4_ = uint(Math.floor(_loc8_ / 60 / 60 / 24));
            _loc8_ %= 86400;
            _loc5_ = uint(Math.floor(_loc8_ / 60 / 60));
            _loc8_ %= 3600;
            _loc6_ = uint(Math.floor(_loc8_ / 60));
            _loc7_ = uint(_loc8_ % 60);
            if(param2.data == null || param2.isAchieved && !param2.isAvailable)
            {
               this.updateTime(0);
               return "0";
            }
            if(_loc4_ > 0)
            {
               this.updateTime(3);
               return String(_loc4_);
            }
            if(_loc5_ > 0)
            {
               this.updateTime(2);
               return this.fixZero(_loc5_);
            }
            this.updateTime(1);
            return "1";
         }
         this.updateTime(0);
         return "0";
      }
      
      private function fixZero(param1:uint) : String
      {
         return param1 < 10 ? String(param1) : String(param1);
      }
      
      private function updateTime(param1:int) : void
      {
         this._timeUnit = param1;
      }
      
      private function updateRewardShow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:Array = this._taskInfo.itemRewards;
         var _loc4_:int = _loc3_.length > this._cellList.length ? int(_loc3_.length) : int(uint(this._cellList.length));
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            if(_loc1_ < _loc3_.length)
            {
               _loc2_ = ItemManager.fillByID(_loc3_[_loc1_].itemID);
               _loc2_.IsBinds = _loc3_[_loc1_].isBind;
               _loc2_.ValidDate = _loc3_[_loc1_].ValidateTime;
               _loc2_.StrengthenLevel = _loc3_[_loc1_].StrengthenLevel;
               _loc2_.AttackCompose = _loc3_[_loc1_].AttackCompose;
               _loc2_.DefendCompose = _loc3_[_loc1_].DefendCompose;
               _loc2_.AgilityCompose = _loc3_[_loc1_].AgilityCompose;
               _loc2_.LuckCompose = _loc3_[_loc1_].LuckCompose;
               if(_loc1_ == this._cellList.length)
               {
                  this._cellList.push(new DDTKingWayRewardCell());
                  this._hBox.addChild(this._cellList[_loc1_]);
               }
               this._cellList[_loc1_].info = _loc2_;
               this._cellList[_loc1_].setCount(_loc3_[_loc1_].count);
               this._cellList[_loc1_].visible = true;
               if((this._taskInfo.data == null || this._taskInfo.isAchieved && !this._taskInfo.isAvailable) && this._isGardeRange)
               {
                  this._cellList[_loc1_].showitem = true;
               }
               else
               {
                  this._cellList[_loc1_].showitem = false;
               }
            }
            else
            {
               this._cellList[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this._hBox.arrange();
         if(this._taskInfo.data == null || this.timeOut(this._taskInfo,this._info) || !this._taskInfo.isCompleted || this._taskInfo.isAchieved && !this._taskInfo.isAvailable)
         {
            this._getRewardBtn.enable = false;
         }
         else
         {
            this._getRewardBtn.enable = true;
         }
      }
      
      protected function __onGetRewardClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.playButtonSound();
         if(!this._taskInfo)
         {
            return;
         }
         var _loc3_:QuestInfo = this._taskInfo;
         if(_loc3_.RewardMoney != 0 && _loc3_.RewardMoney + PlayerManager.Instance.Self.Money > ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel))
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.BindBid.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),true,true,true,1);
            _loc2_.addEventListener("response",this.__onResponse);
         }
         else
         {
            SocketManager.Instance.out.sendQuestFinish(this._taskInfo.QuestID,TaskManager.itemAwardSelected);
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         param1.currentTarget.removeEventListener("response",this.__onResponse);
         if(param1.responseCode == 3)
         {
            _loc2_ = this._taskInfo;
            SocketManager.Instance.out.sendQuestFinish(this._taskInfo.QuestID,TaskManager.itemAwardSelected);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      protected function __onQuestChange(param1:TaskEvent) : void
      {
         if(param1.info.Id == this._info.QuestID)
         {
            this.updataView(this._info);
            DDTKingWayManager.instance.checkIcon();
         }
      }
      
      public function dispose() : void
      {
         TaskManager.removeEventListener("changed",this.__onQuestChange);
         this._getRewardBtn.removeEventListener("click",this.__onGetRewardClick);
         ObjectUtils.disposeObject(this._remainingTimeText1);
         this._remainingTimeText1 = null;
         ObjectUtils.disposeObject(this._remainingTimeText2);
         this._remainingTimeText2 = null;
         ObjectUtils.disposeObject(this._remainingTimeTextBg);
         this._remainingTimeTextBg = null;
         ObjectUtils.disposeObject(this._timeUnitText);
         this._timeUnitText = null;
         while(Boolean(this._itemList.length))
         {
            ObjectUtils.disposeObject(this._itemList.pop());
         }
         this._itemList = null;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         this._cellList.splice(0,this._cellList.length);
         this._cellList = null;
         ObjectUtils.disposeObject(this._getRewardBtn);
         this._getRewardBtn = null;
      }
   }
}

