package sevenday.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
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
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sevenday.SevendayManager;
   
   public class SevendayTaskLeftView extends Sprite implements Disposeable
   {
      
      private var _vBox:VBox;
      
      private var _tastArr:Array;
      
      private var _info:QuestInfo;
      
      private var _hBox:HBox;
      
      private var _giftArr:Vector.<SevendayTaskCell>;
      
      private var _getRewardBtn:SimpleBitmapButton;
      
      public function SevendayTaskLeftView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         this._vBox = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.taskvbox");
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.giftHbox");
         this._giftArr = new Vector.<SevendayTaskCell>();
         this._tastArr = [];
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            this._tastArr[_loc1_] = new SevendayTaskItem();
            this._vBox.addChild(this._tastArr[_loc1_]);
            this._giftArr[_loc1_] = new SevendayTaskCell();
            this._hBox.addChild(this._giftArr[_loc1_]);
            _loc1_++;
         }
         addChild(this._vBox);
         addChild(this._hBox);
         this._getRewardBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.getbtn");
         this._getRewardBtn.addEventListener("click",this._getGift);
         addChild(this._getRewardBtn);
         TaskManager.addEventListener("changed",this.__onQuestChange);
      }
      
      public function update(param1:QuestInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         this._info = param1;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            (this._tastArr[_loc2_] as SevendayTaskItem).update(param1,_loc2_);
            _loc3_ = ItemManager.Instance.getTemplateById(param1.itemRewards[_loc2_].itemID);
            _loc4_ = int(param1.itemRewards[_loc2_].count);
            this._giftArr[_loc2_].update(_loc3_,_loc4_);
            _loc2_++;
         }
         this._vBox.arrange();
         this._hBox.arrange();
         this.updateState();
      }
      
      private function __onQuestChange(param1:TaskEvent) : void
      {
         var _loc2_:Boolean = false;
         if(Boolean(this._info) && param1.info.QuestID == this._info.QuestID)
         {
            this.updateState();
            _loc2_ = SevendayManager.instance.isNotAllAchieved(param1.info.QuestID);
            if(!_loc2_)
            {
               SevendayManager.instance.checkIcon();
            }
         }
      }
      
      private function updateState() : void
      {
         this._getRewardBtn.enable = false;
         if(Boolean(this._info))
         {
            if(this._info.data == null || this._info.isAchieved)
            {
               this.isGetReward(true);
               this._getRewardBtn.enable = false;
            }
            else
            {
               this.isGetReward(false);
               if(this._info.isCompleted)
               {
                  this._getRewardBtn.enable = true;
               }
            }
         }
      }
      
      private function isGetReward(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._giftArr.length)
         {
            this._giftArr[_loc2_].isGet = param1;
            _loc2_++;
         }
      }
      
      private function _getGift(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         SoundManager.instance.playButtonSound();
         if(this._info.RewardMoney != 0)
         {
            _loc2_ = this._info.RewardMoney + PlayerManager.Instance.Self.Money;
            _loc3_ = ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel);
            if(_loc2_ > _loc3_)
            {
               _loc4_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.BindBid.tip"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"),false,false,true,1);
               _loc4_.addEventListener("response",this.__onResponse);
               return;
            }
         }
         this.finishQuest(this._info);
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener("response",this.__onResponse);
         if(param1.responseCode == 3)
         {
            this.finishQuest(this._info);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function finishQuest(param1:QuestInfo) : void
      {
         if(Boolean(param1))
         {
            TaskManager.sendQuestFinish(param1.QuestID);
         }
         SocketManager.Instance.out.getSevendayProgressCount();
      }
      
      public function dispose() : void
      {
         TaskManager.removeEventListener("changed",this.__onQuestChange);
         this._getRewardBtn.removeEventListener("click",this._getGift);
         ObjectUtils.disposeObject(this._getRewardBtn);
         this._getRewardBtn = null;
         this._tastArr.splice(0,this._tastArr.length);
         this._tastArr = null;
         ObjectUtils.disposeObject(this._vBox);
         this._vBox = null;
         while(Boolean(this._giftArr.length))
         {
            ObjectUtils.disposeObject(this._giftArr.pop());
         }
         this._giftArr = null;
      }
   }
}

