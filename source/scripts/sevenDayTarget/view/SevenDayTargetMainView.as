package sevenDayTarget.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   
   public class SevenDayTargetMainView extends Frame
   {
      
      private var _topBg:Bitmap;
      
      private var _downBg:Bitmap;
      
      private var grayFilter:ColorMatrixFilter;
      
      private var lightFilter:ColorMatrixFilter;
      
      private var dayArray:Array;
      
      private var _rewardList:SimpleTileList;
      
      private var _rewardArray:Array;
      
      private var _finishBnt:BaseButton;
      
      private var _todayQuestInfo:NewTargetQuestionInfo;
      
      private var conditionSp1:SevenDayTargetConditionCell;
      
      private var conditionSp2:SevenDayTargetConditionCell;
      
      private var conditionSp3:SevenDayTargetConditionCell;
      
      private var _helpBnt:BaseButton;
      
      private var _downBack:ScaleBitmapImage;
      
      public function SevenDayTargetMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get todayQuestInfo() : NewTargetQuestionInfo
      {
         return this._todayQuestInfo;
      }
      
      private function initView() : void
      {
         this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[SevenDayTargetManager.Instance.today - 1];
         this._downBack = ComponentFactory.Instance.creatComponentByStylename("newSevenDayAndNewPlayer.scale9cornerImageTree");
         addChild(this._downBack);
         this.createDayClicker();
         this.initDayView();
         this.initTargetView();
         this.initRewardView();
         this.changeDaysText();
         this.addHelpBnt();
      }
      
      private function addHelpBnt() : void
      {
         this._helpBnt = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.helpBnt");
         addToContent(this._helpBnt);
         this._helpBnt.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
      }
      
      protected function __onHelpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SevenDayTargetHelpFrame = ComponentFactory.Instance.creat("sevenDayTarget.helpView");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initDayView() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = null;
         var _loc2_:SevenDayTargetDayButton = null;
         this.grayFilter = ComponentFactory.Instance.model.getSet("grayFilter");
         this.lightFilter = ComponentFactory.Instance.model.getSet("lightFilter");
         this.dayArray = new Array();
         titleText = LanguageMgr.GetTranslation("ddt.sevenDayTarget.title");
         this._topBg = ComponentFactory.Instance.creat("sevenDayTarget.topBg");
         addToContent(this._topBg);
         this._downBg = ComponentFactory.Instance.creat("sevenDayTarget.downBg");
         addToContent(this._downBg);
         _loc1_ = ComponentFactory.Instance.creat("sevenDayTarget.todayMC");
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         var _loc3_:int = SevenDayTargetManager.Instance.today;
         var _loc4_:int = 1;
         while(_loc4_ <= 7)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("sevenDayTarget.view.dayButton" + _loc4_);
            _loc2_.name = "day" + _loc4_;
            addToContent(_loc2_);
            if(_loc4_ == _loc3_)
            {
               PositionUtils.setPos(_loc1_,"sevenDayTarget.todayMCPos" + _loc4_);
            }
            this.dayArray.push(_loc2_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.__dayClick);
            _loc4_++;
         }
         addToContent(_loc1_);
      }
      
      private function initTargetView() : void
      {
         if(Boolean(this.conditionSp1))
         {
            this.conditionSp1.dispose();
            this.conditionSp1 = null;
         }
         if(Boolean(this.conditionSp2))
         {
            this.conditionSp2.dispose();
            this.conditionSp2 = null;
         }
         if(Boolean(this.conditionSp3))
         {
            this.conditionSp3.dispose();
            this.conditionSp3 = null;
         }
         var _loc1_:int = SevenDayTargetManager.Instance.today;
         var _loc2_:Boolean = _loc1_ >= this._todayQuestInfo.Period ? Boolean(true) : Boolean(false);
         this.conditionSp1 = new SevenDayTargetConditionCell(this._todayQuestInfo);
         this.conditionSp1.setView(this._todayQuestInfo.condition1Title,this._todayQuestInfo.condition1Complete,_loc2_);
         PositionUtils.setPos(this.conditionSp1,"sevenDayTarget.view.conditionPos1");
         addToContent(this.conditionSp1);
         this.conditionSp2 = new SevenDayTargetConditionCell(this._todayQuestInfo);
         this.conditionSp2.setView(this._todayQuestInfo.condition2Title,this._todayQuestInfo.condition2Complete,_loc2_);
         PositionUtils.setPos(this.conditionSp2,"sevenDayTarget.view.conditionPos2");
         addToContent(this.conditionSp2);
         this.conditionSp3 = new SevenDayTargetConditionCell(this._todayQuestInfo);
         this.conditionSp3.setView(this._todayQuestInfo.condition3Title,this._todayQuestInfo.condition3Complete,_loc2_);
         PositionUtils.setPos(this.conditionSp3,"sevenDayTarget.view.conditionPos3");
         addToContent(this.conditionSp3);
      }
      
      private function initRewardView() : void
      {
         var _loc1_:SevenDayTargetRewardCell = null;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:ItemTemplateInfo = null;
         if(Boolean(this._rewardList))
         {
            this._rewardList.dispose();
            this._rewardList = null;
         }
         if(Boolean(this._finishBnt))
         {
            this._finishBnt.dispose();
            this._finishBnt = null;
         }
         this._rewardList = ComponentFactory.Instance.creat("sevenDayTarget.simpleTileList.rewardList",[2]);
         addToContent(this._rewardList);
         this._rewardArray = this._todayQuestInfo.rewardList;
         var _loc4_:int = 0;
         while(_loc4_ < this._rewardArray.length)
         {
            _loc1_ = new SevenDayTargetRewardCell();
            _loc2_ = this._rewardArray[_loc4_] as InventoryItemInfo;
            _loc3_ = ItemManager.Instance.getTemplateById(_loc2_.ItemID);
            _loc1_.info = _loc3_;
            _loc1_.itemName = _loc3_.Name;
            _loc1_.itemNum = _loc2_.Count + "";
            if(_loc4_ == 2 || _loc4_ == 3)
            {
               _loc1_.y = 64;
            }
            this._rewardList.addChild(_loc1_);
            _loc4_++;
         }
         this._finishBnt = ComponentFactory.Instance.creat("sevenDayTarget.view.getAwardBtn");
         addToContent(this._finishBnt);
         this._finishBnt.addEventListener(MouseEvent.CLICK,this.__getReward);
         if(this._todayQuestInfo.iscomplete && this._todayQuestInfo.getedReward)
         {
            this._finishBnt.enable = false;
         }
         if(this._todayQuestInfo.iscomplete && !this._todayQuestInfo.getedReward)
         {
            this._finishBnt.enable = true;
         }
         if(!this._todayQuestInfo.iscomplete)
         {
            this._finishBnt.enable = false;
         }
      }
      
      private function __getReward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._finishBnt.enable = false;
         var _loc2_:int = this._todayQuestInfo.questId;
         SocketManager.Instance.out.sevenDayTarget_getReward(_loc2_);
      }
      
      private function createDayClicker() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 1;
         while(_loc2_ < 8)
         {
            _loc1_ = new Sprite();
            _loc1_.buttonMode = true;
            _loc1_.graphics.beginFill(255);
            _loc1_.graphics.drawRect(0,0,90,200);
            _loc1_.graphics.endFill();
            addToContent(_loc1_);
            _loc1_.name = "day" + _loc2_;
            PositionUtils.setPos(_loc1_,"sevenDayTarget.dayClicker" + _loc2_);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__dayClick);
            _loc1_.alpha = 1;
            _loc2_++;
         }
      }
      
      private function __dayClick(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         if(_loc2_.name == "day1")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[0];
         }
         else if(_loc2_.name == "day2")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[1];
         }
         else if(_loc2_.name == "day3")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[2];
         }
         else if(_loc2_.name == "day4")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[3];
         }
         else if(_loc2_.name == "day5")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[4];
         }
         else if(_loc2_.name == "day6")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[5];
         }
         else if(_loc2_.name == "day7")
         {
            this._todayQuestInfo = SevenDayTargetManager.Instance.model.sevenDayQuestionInfoArr[6];
         }
         this.updateTargetView();
         this.updateRewardView();
      }
      
      public function updateTargetView() : void
      {
         this.initTargetView();
      }
      
      public function updateRewardView() : void
      {
         this.initRewardView();
      }
      
      private function changeDaysText() : void
      {
         var _loc1_:SevenDayTargetDayButton = null;
         var _loc2_:int = SevenDayTargetManager.Instance.today;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.dayArray[_loc3_];
            _loc1_.enable = true;
            _loc3_++;
         }
         var _loc4_:int = _loc2_;
         while(_loc4_ < this.dayArray.length)
         {
            _loc1_ = this.dayArray[_loc4_];
            _loc1_.enable = false;
            _loc4_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._finishBnt.removeEventListener(MouseEvent.CLICK,this.__getReward);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SevenDayTargetManager.Instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._topBg))
         {
            this._topBg.bitmapData.dispose();
            this._topBg = null;
         }
         if(Boolean(this._downBack))
         {
            this._downBack.dispose();
            this._downBack = null;
         }
         if(Boolean(this.conditionSp1))
         {
            this.conditionSp1.dispose();
            this.conditionSp1 = null;
         }
         if(Boolean(this.conditionSp2))
         {
            this.conditionSp2.dispose();
            this.conditionSp2 = null;
         }
         if(Boolean(this.conditionSp3))
         {
            this.conditionSp3.dispose();
            this.conditionSp3 = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
   }
}

