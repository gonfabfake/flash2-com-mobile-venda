package anotherDimension.view
{
   import anotherDimension.AnotherDimensionControl;
   import anotherDimension.controller.AnotherDimensionManager;
   import anotherDimension.model.AnotherDimensionInfo;
   import anotherDimension.model.AnotherDimensionMsgInfo;
   import anotherDimension.model.AnotherDimensionResourceInfo;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class AnotherDimensionMainView extends Frame
   {
      
      private var _helpBnt:BaseButton;
      
      private var _bg:Bitmap;
      
      private var _searchBnt:BaseButton;
      
      private var _helpBnt2:BaseButton;
      
      private var _closeBnt:BaseButton;
      
      private var _downBg:Bitmap;
      
      private var _canZhanlingTxt:FilterFrameText;
      
      private var _canLueduoTxt:FilterFrameText;
      
      private var _canZhanlingCountTxt:FilterFrameText;
      
      private var _canLueduoCountTxt:FilterFrameText;
      
      private var _shijiankongzhiSelect:SelectedCheckButton;
      
      private var _kongjianzhangwoSelect:SelectedCheckButton;
      
      private var _lueduodashiSelect:SelectedCheckButton;
      
      private var _shijiankongzhiTxt:FilterFrameText;
      
      private var _kongjianzhangwoTxt:FilterFrameText;
      
      private var _lueduodashiTxt:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      private var _itemCell:AnotherDimensionItemCell;
      
      private var _upGradeBnt:BaseButton;
      
      private var _allInSelect:SelectedCheckButton;
      
      private var _progress:AnotherDimensionProgress;
      
      private var _type:int = 1;
      
      private var oneItemExp:int = 10;
      
      private var otherItemArr:Array;
      
      private var selfItemArr:Array;
      
      private var _selectBtn:SelectedCheckButton;
      
      private var alert:BaseAlerFrame;
      
      private var timeLvMax:Boolean = false;
      
      private var spaceLvMax:Boolean = false;
      
      private var lootLvMax:Boolean = false;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function AnotherDimensionMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("anotherDimension.mainBg");
         this._searchBnt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.searchBnt");
         this._helpBnt2 = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.helpBnt");
         this._closeBnt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.closeBnt");
         this._downBg = ComponentFactory.Instance.creat("anotherDimension.zhanling");
         this._canZhanlingTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.canZhanlingTxt");
         this._canLueduoTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.canLueduoTxt");
         this._canZhanlingCountTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.canZhanlingCountTxt");
         this._canLueduoCountTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.canLueduoCountTxt");
         this._canZhanlingTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensioncanZhanlingTxt");
         this._canLueduoTxt.text = LanguageMgr.GetTranslation("anotherDimension.anotherDimensioncanLueduoTxt");
         var _loc1_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.totalOccupyCount;
         var _loc2_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.occupyCount;
         var _loc3_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.totalLootCount;
         var _loc4_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.lootCount;
         this._canZhanlingCountTxt.text = _loc1_ - _loc2_ + "";
         this._canLueduoCountTxt.text = _loc3_ - _loc4_ + "";
         addToContent(this._bg);
         addToContent(this._searchBnt);
         addToContent(this._helpBnt2);
         addToContent(this._closeBnt);
         addToContent(this._downBg);
         addToContent(this._canZhanlingTxt);
         addToContent(this._canLueduoTxt);
         addToContent(this._canZhanlingCountTxt);
         addToContent(this._canLueduoCountTxt);
         this.otherItemArr = [];
         this.selfItemArr = [];
         this.setResourceData();
         this.addSelectionBnt();
         this.addMsgView();
      }
      
      public function setResourceData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         var _loc10_:* = null;
         var _loc11_:Array = AnotherDimensionManager.Instance.resourceList;
         var _loc12_:Array = AnotherDimensionManager.Instance.haveResourceList;
         if(Boolean(this.otherItemArr) && this.otherItemArr.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.otherItemArr.length)
            {
               _loc2_ = this.otherItemArr[_loc1_] as AnotherDimensionOtherItemView;
               _loc2_.dispose();
               _loc2_ = null;
               _loc1_++;
            }
         }
         if(Boolean(this.selfItemArr) && this.selfItemArr.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.selfItemArr.length)
            {
               _loc4_ = this.selfItemArr[_loc3_] as AnotherDimensionSelfItemView;
               _loc4_.dispose();
               _loc4_ = null;
               _loc3_++;
            }
         }
         this.otherItemArr = [];
         this.selfItemArr = [];
         _loc5_ = 0;
         while(_loc5_ < _loc11_.length)
         {
            _loc6_ = _loc11_[_loc5_] as AnotherDimensionResourceInfo;
            _loc7_ = new AnotherDimensionOtherItemView(_loc6_);
            PositionUtils.setPos(_loc7_,"anotherDimension.anotherDimension.anotherPos" + _loc6_.resourcePos);
            addToContent(_loc7_);
            this.otherItemArr.push(_loc7_);
            _loc5_++;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc12_.length)
         {
            _loc9_ = _loc12_[_loc8_] as AnotherDimensionResourceInfo;
            _loc10_ = new AnotherDimensionSelfItemView(_loc9_);
            PositionUtils.setPos(_loc10_,"anotherDimension.anotherDimension.selfPos" + (_loc8_ + 1));
            addToContent(_loc10_);
            this.selfItemArr.push(_loc10_);
            _loc8_++;
         }
      }
      
      private function initEvent() : void
      {
         this._closeBnt.addEventListener("click",this._closeClick);
         this._shijiankongzhiSelect.addEventListener("click",this._shijiankongzhiSelectClick);
         this._kongjianzhangwoSelect.addEventListener("click",this._kongjianzhangwoSelectClick);
         this._lueduodashiSelect.addEventListener("click",this._lueduodashiSelectClick);
         this._upGradeBnt.addEventListener("click",this.__upGradeClick);
         this._searchBnt.addEventListener("click",this.__searchClick);
         AnotherDimensionManager.Instance.addEventListener("updateView",this.__updateInfoView);
         AnotherDimensionManager.Instance.addEventListener("addMsg",this.__addMsg);
         this._progress.addEventListener("mcStop",this._showMCOver);
         GameManager.Instance.addEventListener("StartLoading",this.__onStartLoad);
         this._helpBnt2.addEventListener("click",this.openHelpViewHander);
      }
      
      private function openHelpViewHander(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:AnotherDimensionHelpFrame = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.view.helpFrame");
         _loc2_.addEventListener("response",this.frameEvent);
         LayerManager.Instance.addToLayer(_loc2_,2,true,1);
      }
      
      private function frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         param1.currentTarget.dispose();
      }
      
      protected function __onStartLoad(param1:Event) : void
      {
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         StateManager.setState("roomLoading",GameManager.Instance.Current);
         this.dispose();
      }
      
      private function __addMsg(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         if(Boolean(this._vbox) && this._vbox.numChildren > 0)
         {
            this._vbox.removeAllChild();
         }
         var _loc5_:Array = AnotherDimensionManager.Instance.msgArr;
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc4_ = _loc5_[_loc3_] as AnotherDimensionMsgInfo;
            if(_loc4_.userID != _loc4_.ownUserID && _loc4_.restatus == 2)
            {
               _loc2_ = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionTxt.msgTxt2",_loc4_.ownName);
            }
            else if(_loc4_.userID == _loc4_.ownUserID && _loc4_.restatus == 2)
            {
               _loc2_ = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionTxt.msgTxt3",_loc4_.ownName);
            }
            else if(_loc4_.userID == _loc4_.ownUserID && _loc4_.restatus == 3)
            {
               _loc2_ = LanguageMgr.GetTranslation("anotherDimension.anotherDimensionTxt.msgTxt4");
            }
            else
            {
               _loc2_ = "";
            }
            this.addMsg(_loc2_);
            _loc3_++;
         }
      }
      
      private function _showMCOver(param1:Event) : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
         if(this._type == 1)
         {
            this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv;
         }
         else if(this._type == 2)
         {
            this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv;
         }
         else if(this._type == 3)
         {
            this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv;
         }
      }
      
      private function __updateInfoView(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc4_ = 0;
         var _loc5_:int = int(this.getTimeControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[2]);
         if(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv == 0)
         {
            _loc5_ = 0;
         }
         var _loc6_:int = int(this.getSpaceControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv)[2]);
         if(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv == 0)
         {
            _loc6_ = 0;
         }
         var _loc7_:int = int(this.getLooterControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv)[2]);
         if(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv == 0)
         {
            _loc7_ = 0;
         }
         this._shijiankongzhiTxt.text = LanguageMgr.GetTranslation("anotherDimension.shijiankongzhiTxt.txt",_loc5_);
         this._kongjianzhangwoTxt.text = LanguageMgr.GetTranslation("anotherDimension.kongjianzhangwoTxt.txt",_loc6_);
         this._lueduodashiTxt.text = LanguageMgr.GetTranslation("anotherDimension.lueduodashiTxt.txt",_loc7_);
         var _loc8_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.totalOccupyCount;
         var _loc9_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.occupyCount;
         var _loc10_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.totalLootCount;
         var _loc11_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.lootCount;
         this._canZhanlingCountTxt.text = _loc8_ - _loc9_ + "";
         this._canLueduoCountTxt.text = _loc10_ - _loc11_ + "";
         if(this._type == 1)
         {
            _loc2_ = AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlExp;
            _loc3_ = int(this.getTimeControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[1]);
            if(this.timeLvMax)
            {
               this._progress.setProgressTxt("MAX");
            }
            else
            {
               this._progress.setProgressTxt(_loc2_ + "/" + _loc3_);
            }
         }
         else if(this._type == 2)
         {
            _loc2_ = AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlExp;
            _loc3_ = int(this.getSpaceControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv)[1]);
            if(this.spaceLvMax)
            {
               this._progress.setProgressTxt("MAX");
            }
            else
            {
               this._progress.setProgressTxt(_loc2_ + "/" + _loc3_);
            }
         }
         else if(this._type == 3)
         {
            _loc2_ = AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlExp;
            _loc3_ = int(this.getLooterControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv)[1]);
            if(this.lootLvMax)
            {
               this._progress.setProgressTxt("MAX");
            }
            else
            {
               this._progress.setProgressTxt(_loc2_ + "/" + _loc3_);
            }
         }
         if(_loc2_ == 0 && _loc3_ == 0)
         {
            this.mouseEnabled = true;
            this.mouseChildren = true;
            _loc4_ = 1;
            this._progress.setProgress(1);
         }
         else if(_loc2_ == 0 && _loc3_ != 0)
         {
            _loc4_ = 1;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this._progress.playProgress(_loc4_,1);
         }
         else
         {
            _loc4_ = _loc2_ / _loc3_ * 100;
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this._progress.playProgress(_loc4_);
         }
      }
      
      private function __upGradeClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         SoundManager.instance.play("008");
         if(this._allInSelect.selected)
         {
            _loc2_ = ServerConfigManager.instance.getLevelUpItemID();
            _loc3_ = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc2_);
            if(this._type == 1)
            {
               _loc4_ = AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlExp;
               _loc5_ = int(this.getTimeControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[1]);
            }
            else if(this._type == 2)
            {
               _loc4_ = AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlExp;
               _loc5_ = int(this.getSpaceControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv)[1]);
            }
            else if(this._type == 3)
            {
               _loc4_ = AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlExp;
               _loc5_ = int(this.getLooterControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv)[1]);
            }
            _loc6_ = (_loc5_ - _loc4_) / this.oneItemExp;
            if(_loc6_ < _loc3_)
            {
               SocketManager.Instance.out.clickAnotherDimenUpgrade(this._type,_loc6_);
            }
            else
            {
               SocketManager.Instance.out.clickAnotherDimenUpgrade(this._type,_loc3_);
            }
         }
         else
         {
            SocketManager.Instance.out.clickAnotherDimenUpgrade(this._type,1);
         }
      }
      
      private function removeEvent() : void
      {
         this._closeBnt.removeEventListener("click",this._closeClick);
         this._shijiankongzhiSelect.removeEventListener("click",this._shijiankongzhiSelectClick);
         this._kongjianzhangwoSelect.removeEventListener("click",this._kongjianzhangwoSelectClick);
         this._lueduodashiSelect.removeEventListener("click",this._lueduodashiSelectClick);
         this._upGradeBnt.removeEventListener("click",this.__upGradeClick);
         this._searchBnt.removeEventListener("click",this.__searchClick);
         AnotherDimensionManager.Instance.removeEventListener("updateView",this.__updateInfoView);
         AnotherDimensionManager.Instance.removeEventListener("addMsg",this.__addMsg);
         this._progress.removeEventListener("mcStop",this._showMCOver);
         GameManager.Instance.addEventListener("StartLoading",this.__onStartLoad);
      }
      
      private function __searchClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         SoundManager.instance.play("008");
         var _loc4_:AnotherDimensionInfo = AnotherDimensionManager.Instance.anotherDimensionInfo;
         if(Boolean(AnotherDimensionManager.Instance.showBuyCountFram) && Boolean(_loc4_) && _loc4_.refreshCount >= 1)
         {
            _loc2_ = ServerConfigManager.instance.getSearchPrice() * _loc4_.refreshCount;
            _loc3_ = LanguageMgr.GetTranslation("anotherDimension.buyCountDescription",_loc2_);
            this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc3_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
            this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("ddtGame.buyConfirmNo.scb");
            this._selectBtn.text = LanguageMgr.GetTranslation("horseRace.match.notTip");
            this._selectBtn.addEventListener("click",this.__onClickSelectedBtn);
            this.alert.addToContent(this._selectBtn);
            this.alert.moveEnable = false;
            this.alert.addEventListener("response",this.__onRecoverResponse);
            this.alert.height = 200;
            this._selectBtn.x = 63;
            this._selectBtn.y = 67;
         }
         else
         {
            SocketManager.Instance.out.clickAnotherDimenSearch();
         }
      }
      
      private function __onClickSelectedBtn(param1:MouseEvent) : void
      {
         AnotherDimensionManager.Instance.showBuyCountFram = !this._selectBtn.selected;
      }
      
      private function __onRecoverResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.playButtonSound();
         var _loc3_:AnotherDimensionInfo = AnotherDimensionManager.Instance.anotherDimensionInfo;
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            _loc2_ = ServerConfigManager.instance.getSearchPrice() * _loc3_.refreshCount;
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.clickAnotherDimenSearch();
         }
         else if(param1.responseCode == 4 || param1.responseCode == 0 || param1.responseCode == 1)
         {
            AnotherDimensionManager.Instance.showBuyCountFram = true;
         }
         (param1.currentTarget as BaseAlerFrame).removeEventListener("response",this.__onRecoverResponse);
         if(Boolean(this._selectBtn))
         {
            this._selectBtn.removeEventListener("click",this.__onClickSelectedBtn);
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function _closeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AnotherDimensionControl.instance.disposeMainView();
      }
      
      private function _shijiankongzhiSelectClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._shijiankongzhiSelect.selected)
         {
            this._kongjianzhangwoSelect.selected = false;
            this._lueduodashiSelect.selected = false;
            this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv;
            _loc2_ = AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlExp;
            _loc3_ = int(this.getTimeControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[1]);
            _loc4_ = _loc2_ / _loc3_ * 100;
            this._progress.setProgress(_loc4_);
            if(this.timeLvMax)
            {
               this._progress.setProgressTxt("MAX");
            }
            else
            {
               this._progress.setProgressTxt(_loc2_ + "/" + _loc3_);
            }
            this._type = 1;
         }
      }
      
      private function _kongjianzhangwoSelectClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._kongjianzhangwoSelect.selected)
         {
            this._shijiankongzhiSelect.selected = false;
            this._lueduodashiSelect.selected = false;
            this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv;
            _loc2_ = AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlExp;
            _loc3_ = int(this.getSpaceControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv)[1]);
            _loc4_ = _loc2_ / _loc3_ * 100;
            this._progress.setProgress(_loc4_);
            if(this.spaceLvMax)
            {
               this._progress.setProgressTxt("MAX");
            }
            else
            {
               this._progress.setProgressTxt(_loc2_ + "/" + _loc3_);
            }
            this._type = 2;
         }
      }
      
      private function _lueduodashiSelectClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._lueduodashiSelect.selected)
         {
            this._shijiankongzhiSelect.selected = false;
            this._kongjianzhangwoSelect.selected = false;
            this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv;
            _loc2_ = AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlExp;
            _loc3_ = int(this.getLooterControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv)[1]);
            _loc4_ = _loc2_ / _loc3_ * 100;
            this._progress.setProgress(_loc4_);
            if(this.lootLvMax)
            {
               this._progress.setProgressTxt("MAX");
            }
            else
            {
               this._progress.setProgressTxt(_loc2_ + "/" + _loc3_);
            }
            this._type = 3;
         }
      }
      
      private function getTimeControlExpBylv(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getTimeControl();
         if(param1 == _loc2_.length)
         {
            this.timeLvMax = true;
         }
         if(param1 == 0)
         {
            param1 = 1;
         }
         _loc3_ = _loc2_[param1 - 1];
         return _loc3_.split(",");
      }
      
      private function getTimeControlExpBylv_1(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getTimeControl();
         if(param1 == _loc2_.length)
         {
            param1 -= 1;
            this.timeLvMax = true;
         }
         _loc3_ = _loc2_[param1];
         return _loc3_.split(",");
      }
      
      private function getSpaceControlExpBylv(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getSpaceControl();
         if(param1 == _loc2_.length)
         {
            this.spaceLvMax = true;
         }
         if(param1 == 0)
         {
            param1 = 1;
         }
         _loc3_ = _loc2_[param1 - 1];
         return _loc3_.split(",");
      }
      
      private function getSpaceControlExpBylv_1(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getSpaceControl();
         if(param1 == _loc2_.length)
         {
            param1 -= 1;
            this.spaceLvMax = true;
         }
         _loc3_ = _loc2_[param1];
         return _loc3_.split(",");
      }
      
      private function getLooterControlExpBylv(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getLootControl();
         if(param1 == _loc2_.length)
         {
            this.lootLvMax = true;
         }
         if(param1 == 0)
         {
            param1 = 1;
         }
         _loc3_ = _loc2_[param1 - 1];
         return _loc3_.split(",");
      }
      
      private function getLooterControlExpBylv_1(param1:int) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = ServerConfigManager.instance.getLootControl();
         if(param1 == _loc2_.length)
         {
            param1 -= 1;
            this.lootLvMax = true;
         }
         _loc3_ = _loc2_[param1];
         return _loc3_.split(",");
      }
      
      private function addSelectionBnt() : void
      {
         this._shijiankongzhiSelect = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.shijiankongzhiSelectBnt");
         this._kongjianzhangwoSelect = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.kongjianzhangwoSelectBnt");
         this._lueduodashiSelect = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.lueduodashiSelectBnt");
         addToContent(this._shijiankongzhiSelect);
         addToContent(this._kongjianzhangwoSelect);
         addToContent(this._lueduodashiSelect);
         var _loc1_:int = int(this.getTimeControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[2]);
         if(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv == 0)
         {
            _loc1_ = 0;
         }
         var _loc2_:int = int(this.getSpaceControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv)[2]);
         if(AnotherDimensionManager.Instance.anotherDimensionInfo.spaceControlLv == 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:int = int(this.getLooterControlExpBylv(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv)[2]);
         if(AnotherDimensionManager.Instance.anotherDimensionInfo.looterControlLv == 0)
         {
            _loc3_ = 0;
         }
         this._shijiankongzhiTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.shijiankongzhiTxt");
         this._shijiankongzhiTxt.text = LanguageMgr.GetTranslation("anotherDimension.shijiankongzhiTxt.txt",_loc1_);
         this._kongjianzhangwoTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.kongjianzhangwoTxt");
         this._kongjianzhangwoTxt.text = LanguageMgr.GetTranslation("anotherDimension.kongjianzhangwoTxt.txt",_loc2_);
         this._lueduodashiTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.lueduodashiTxt");
         this._lueduodashiTxt.text = LanguageMgr.GetTranslation("anotherDimension.lueduodashiTxt.txt",_loc3_);
         addToContent(this._shijiankongzhiTxt);
         addToContent(this._kongjianzhangwoTxt);
         addToContent(this._lueduodashiTxt);
         this._allInSelect = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.allInCheckBtn");
         this._allInSelect.text = LanguageMgr.GetTranslation("anotherDimension.allInCheckBtnTxt");
         addToContent(this._allInSelect);
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.levelTxt");
         this._levelTxt.text = "LV." + AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv;
         this._shijiankongzhiSelect.selected = true;
         addToContent(this._levelTxt);
         this._progress = new AnotherDimensionProgress();
         PositionUtils.setPos(this._progress,"anotherDimension.progressPos");
         addToContent(this._progress);
         var _loc4_:int = AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlExp;
         var _loc5_:int = int(this.getTimeControlExpBylv_1(AnotherDimensionManager.Instance.anotherDimensionInfo.timeControlLv)[1]);
         this._shijiankongzhiSelectClick(null);
         this._itemCell = new AnotherDimensionItemCell();
         PositionUtils.setPos(this._itemCell,"anotherDimension.itemCellPos");
         addToContent(this._itemCell);
         this._upGradeBnt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.upGradeBnt");
         addToContent(this._upGradeBnt);
      }
      
      private function addMsgView() : void
      {
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.msgBox");
         addToContent(this._vbox);
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.msgBoxScroll");
         addToContent(this._scrollPanel);
         this._scrollPanel.setView(this._vbox);
         this._scrollPanel.invalidateViewport_toTop(true);
         this.__addMsg(null);
      }
      
      public function addMsg(param1:String) : void
      {
         var _loc2_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.msgTxt");
         _loc2_.mouseEnabled = false;
         _loc2_.htmlText = param1;
         this._vbox.addChild(_loc2_);
         this._scrollPanel.invalidateViewport_toTop(true);
      }
      
      private function __helpBntClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
         AnotherDimensionManager.Instance.gameOver = false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

