package sevenday.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   import sevenday.SevendayManager;
   
   public class SevendayMainFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _titleNew:Bitmap;
      
      private var _dayHBox:HBox;
      
      private var _dayBtnGroup:SelectedButtonGroup;
      
      private var _smalltitle:ScaleFrameImage;
      
      private var _baseBtn:SelectedButton;
      
      private var _superBtn:SelectedButton;
      
      private var _targetBtnGroup:SelectedButtonGroup;
      
      private var _sevendayTaskLeftView:SevendayTaskLeftView;
      
      private var _endTimeText:FilterFrameText;
      
      private var _completeText:FilterFrameText;
      
      private var _upgradeText:FilterFrameText;
      
      private var _targetCompleteText:FilterFrameText;
      
      private var _progress:SevendayTaskProgress;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _contentArr:Array;
      
      public function SevendayMainFrame()
      {
         super();
         this.initview();
         this.initEvent();
         SocketManager.Instance.out.getSevendayProgressCount();
         this._dayBtnGroup.selectIndex = SevendayManager.instance.day;
         this._targetBtnGroup.selectIndex = 0;
      }
      
      private function initview() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = false;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:int = 0;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.sevenday.bg");
         addToContent(this._bg);
         this._titleNew = ComponentFactory.Instance.creatBitmap("asset.sevenday.title");
         addToContent(this._titleNew);
         this._dayHBox = ComponentFactory.Instance.creatComponentByStylename("sevendayHBox");
         addToContent(this._dayHBox);
         this._dayBtnGroup = new SelectedButtonGroup();
         _loc1_ = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.dayBtn" + _loc1_);
            _loc3_ = _loc1_ <= SevendayManager.instance.day;
            _loc2_.enable = _loc3_;
            this._dayBtnGroup.addSelectItem(_loc2_);
            this._dayHBox.addChild(_loc2_);
            _loc1_++;
         }
         this._smalltitle = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.smalltitle");
         addToContent(this._smalltitle);
         this._targetBtnGroup = new SelectedButtonGroup();
         this._baseBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.basebtn");
         this._targetBtnGroup.addSelectItem(this._baseBtn);
         addToContent(this._baseBtn);
         this._superBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.superbtn");
         this._targetBtnGroup.addSelectItem(this._superBtn);
         addToContent(this._superBtn);
         this._sevendayTaskLeftView = new SevendayTaskLeftView();
         addToContent(this._sevendayTaskLeftView);
         this._endTimeText = ComponentFactory.Instance.creatComponentByStylename("sevenday.text1");
         addToContent(this._endTimeText);
         this._completeText = ComponentFactory.Instance.creatComponentByStylename("sevenday.text2");
         this._completeText.htmlText = LanguageMgr.GetTranslation("ddt.sevenday.text2");
         addToContent(this._completeText);
         this._upgradeText = ComponentFactory.Instance.creatComponentByStylename("sevenday.text3");
         this._upgradeText.htmlText = LanguageMgr.GetTranslation("ddt.sevenday.text3");
         addToContent(this._upgradeText);
         this._targetCompleteText = ComponentFactory.Instance.creatComponentByStylename("sevenday.text4");
         this._targetCompleteText.htmlText = LanguageMgr.GetTranslation("ddt.sevenday.text4");
         addToContent(this._targetCompleteText);
         this._progress = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.taskprogress");
         addToContent(this._progress);
         this._contentArr = [];
         var _loc9_:Array = ServerConfigManager.instance.sevendayProgressGift;
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc4_ = String(_loc9_[_loc1_]).split(",");
            _loc5_ = int(_loc4_[0]);
            _loc6_ = ItemManager.Instance.getTemplateById(int(_loc4_[1])).Description;
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename("ddt.sevenday.content" + _loc1_);
            _loc7_.addChild(ComponentFactory.Instance.creatBitmap("asset.sevenday.gift" + (_loc1_ + 1)));
            _loc7_.tipData = LanguageMgr.GetTranslation("tank.sevenday.gift",_loc5_,_loc6_);
            addToContent(_loc7_);
            this._contentArr[_loc1_] = _loc7_;
            _loc1_++;
         }
         if(SevendayManager.instance.day <= 5)
         {
            _loc8_ = 7 - SevendayManager.instance.day - 1;
            this._endTimeText.text = LanguageMgr.GetTranslation("ddt.sevenday.text1",_loc8_);
         }
         else
         {
            this._endTimeText.text = LanguageMgr.GetTranslation("ddt.sevenday.text5",SevendayManager.instance.hour);
         }
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"sevenday.button.helpBtn",null,LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.sevenday.helpText",404,484) as SimpleBitmapButton;
         PositionUtils.setPos(this._helpBtn,"sevenday.helpBtnPos");
         addToContent(this._helpBtn);
      }
      
      private function initEvent() : void
      {
         this._dayBtnGroup.addEventListener("change",this.___onDayBtnChangeHandler);
         this._targetBtnGroup.addEventListener("change",this.__onTargetBtnChangeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVEN_DAY,this.__onGetProgressCount);
      }
      
      private function __onGetProgressCount(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._progress.setProgress(_loc3_,105);
      }
      
      private function __onTargetBtnChangeHandler(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         this.updateView();
      }
      
      private function updateView() : void
      {
         var _loc1_:Array = null;
         _loc1_ = [SevendayManager.QUEST_LIST_1,SevendayManager.QUEST_LIST_2];
         var _loc2_:Array = _loc1_[this._targetBtnGroup.selectIndex];
         var _loc3_:int = int(_loc2_[this._dayBtnGroup.selectIndex]);
         var _loc4_:QuestInfo = TaskManager.instance.getQuestByID(_loc3_);
         this._sevendayTaskLeftView.update(_loc4_);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SEVEN_DAY,this.__onGetProgressCount);
         this._dayBtnGroup.removeEventListener("change",this.___onDayBtnChangeHandler);
         this._targetBtnGroup.removeEventListener("change",this.__onTargetBtnChangeHandler);
      }
      
      private function ___onDayBtnChangeHandler(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         this._smalltitle.setFrame(this._dayBtnGroup.selectIndex + 1);
         if(this._targetBtnGroup.selectIndex == 0)
         {
            this.updateView();
         }
         else
         {
            this._targetBtnGroup.selectIndex = 0;
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
         this.updateView();
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = null;
         this.removeEvent();
         while(Boolean(this._contentArr.length))
         {
            _loc1_ = this._contentArr.pop();
            ObjectUtils.disposeAllChildren(_loc1_);
            ObjectUtils.disposeObject(_loc1_);
         }
         this._contentArr = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleNew);
         this._titleNew = null;
         ObjectUtils.disposeObject(this._dayBtnGroup);
         this._dayBtnGroup = null;
         ObjectUtils.disposeObject(this._dayHBox);
         this._dayHBox = null;
         ObjectUtils.disposeObject(this._smalltitle);
         this._smalltitle = null;
         ObjectUtils.disposeObject(this._targetBtnGroup);
         this._targetBtnGroup = null;
         this._superBtn = null;
         this._baseBtn = null;
         ObjectUtils.disposeObject(this._sevendayTaskLeftView);
         this._sevendayTaskLeftView = null;
         ObjectUtils.disposeObject(this._endTimeText);
         this._endTimeText = null;
         ObjectUtils.disposeObject(this._completeText);
         this._completeText = null;
         ObjectUtils.disposeObject(this._upgradeText);
         this._upgradeText = null;
         ObjectUtils.disposeObject(this._targetCompleteText);
         this._targetCompleteText = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         super.dispose();
      }
   }
}

