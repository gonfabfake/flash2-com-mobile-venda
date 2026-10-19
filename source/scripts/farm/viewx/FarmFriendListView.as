package farm.viewx
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import farm.modelx.FramFriendStateInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import petsBag.PetsBagManager;
   import road7th.data.DictionaryEvent;
   
   public class FarmFriendListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      private var _switchAsset:ScaleFrameImage;
      
      private var isOpen:Boolean = true;
      
      private var _listBG:Scale9CornerImage;
      
      private var _listBound:ScaleBitmapImage;
      
      private var _hBox:HBox;
      
      private var _poultryBtn:SelectedTextButton;
      
      private var _stealBtn:SelectedTextButton;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _tabBitmap:Bitmap;
      
      private var _switchTween:TweenLite;
      
      public function FarmFriendListView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("farm.friendListBg");
         addChild(this._listBG);
         this._listBound = ComponentFactory.Instance.creatComponentByStylename("farm.friendListBound");
         addChild(this._listBound);
         this._switchAsset = ComponentFactory.Instance.creatComponentByStylename("farm.listSwitch");
         this._switchAsset.buttonMode = true;
         if(this.isOpen)
         {
            this._switchAsset.setFrame(1);
         }
         addChild(this._switchAsset);
         this._tabBitmap = ComponentFactory.Instance.creat("asset.farm.selectTab");
         addChild(this._tabBitmap);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("farm.farmFriendListPanel.btnHbox");
         addChild(this._hBox);
         this._stealBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmFriendListPanel.poultrySelectBtn");
         this._stealBtn.text = LanguageMgr.GetTranslation("farm.friendListPanel.stealBtnText");
         this._hBox.addChild(this._stealBtn);
         this._poultryBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmFriendListPanel.poultrySelectBtn");
         this._poultryBtn.text = LanguageMgr.GetTranslation("farm.friendListPanel.poultryText");
         this._hBox.addChild(this._poultryBtn);
         this._selectedButtonGroup = new SelectedButtonGroup();
         this._selectedButtonGroup.addSelectItem(this._stealBtn);
         this._selectedButtonGroup.addSelectItem(this._poultryBtn);
         this._selectedButtonGroup.selectIndex = 0;
         FarmModelController.instance.model.SelectIndex = this._selectedButtonGroup.selectIndex;
         this._hBox.arrange();
         this._list = ComponentFactory.Instance.creat("asset.farm.farmFriendListPanel");
         this._list.vScrollProxy = 1;
         addChild(this._list);
         this._list.list.updateListView();
         this.switchView();
         this.update();
      }
      
      private function initEvent() : void
      {
         this._selectedButtonGroup.addEventListener("change",this.__onBtnGroupChange);
         PlayerManager.Instance.addEventListener("friendListComplete",this.__friendlistHandler);
         FarmModelController.instance.addEventListener("friendInfoReady",this.__infoReady);
         FarmModelController.instance.addEventListener("friendList_updateStolen",this.__updateFriendListStolen);
         this._switchAsset.addEventListener("click",this.__onClick);
         this._switchAsset.addEventListener("mouseOver",this.__overHandler);
         this._switchAsset.addEventListener("mouseOut",this.__outHandler);
         PlayerManager.Instance.friendList.addEventListener("remove",this.__playerRemove);
      }
      
      protected function __onBtnGroupChange(param1:Event) : void
      {
         SoundManager.instance.playButtonSound();
         FarmModelController.instance.model.SelectIndex = this._selectedButtonGroup.selectIndex;
         FarmModelController.instance.updateSetupFriendListLoader();
      }
      
      protected function __playerRemove(param1:DictionaryEvent) : void
      {
         var _loc2_:FriendListPlayer = param1.data as FriendListPlayer;
         FarmModelController.instance.model.friendStateList.remove(_loc2_.ID);
         this.update();
      }
      
      protected function __outHandler(param1:MouseEvent) : void
      {
         this._switchAsset.filters = null;
      }
      
      protected function __overHandler(param1:MouseEvent) : void
      {
         this._switchAsset.filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      protected function __friendlistHandler(param1:Event) : void
      {
         this.update();
      }
      
      protected function __infoReady(param1:FarmEvent) : void
      {
         this.update();
      }
      
      protected function __updateFriendListStolen(param1:FarmEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:FramFriendStateInfo = FarmModelController.instance.model.friendStateListStolenInfo[FarmModelController.instance.model.currentFarmerId];
         for each(_loc3_ in this._list.list.cell)
         {
            if(Boolean(_loc3_.info))
            {
               if(_loc3_.info.id == _loc2_.id)
               {
                  _loc3_.setCellValue(_loc2_);
                  break;
               }
            }
         }
         for each(_loc4_ in (this._list.list.model as VectorListModel).elements)
         {
            if(_loc4_.id == _loc2_.id)
            {
               _loc4_.landStateVec = _loc2_.landStateVec;
               _loc4_.isFeed = _loc2_.isFeed;
               break;
            }
         }
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.switchView();
         if(PetsBagManager.instance.haveTaskOrderByID(366))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(114);
         }
      }
      
      private function switchView() : void
      {
         var _loc1_:int = this.isOpen ? 2 : 1;
         this._switchAsset.setFrame(_loc1_);
         if(this.isOpen)
         {
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":952,
               "ease":Sine.easeInOut
            });
         }
         else
         {
            FarmModelController.instance.updateSetupFriendListLoader();
            this._switchTween = null;
            this._switchTween = TweenLite.to(this,0.5,{
               "x":773,
               "ease":Sine.easeInOut
            });
         }
         this.isOpen = _loc1_ == 1 ? true : false;
      }
      
      private function update() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = null;
         this._list.vectorListModel.clear();
         for each(_loc2_ in FarmModelController.instance.model.friendStateList)
         {
            _loc1_ = _loc2_.playerinfo;
            if(Boolean(_loc1_))
            {
               this._list.vectorListModel.insertElementAt(_loc2_,this.getInsertIndex(_loc1_));
            }
         }
         this._list.list.updateListView();
      }
      
      private function getInsertIndex(param1:PlayerInfo) : int
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = this._list.vectorListModel.elements;
         if(_loc5_.length == 0)
         {
            return 0;
         }
         _loc3_ = _loc5_.length - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = (_loc5_[_loc3_] as FramFriendStateInfo).playerinfo;
            if(!(param1.IsVIP && !_loc2_.IsVIP))
            {
               if(!param1.IsVIP && Boolean(_loc2_.IsVIP))
               {
                  return _loc3_ + 1;
               }
               if(param1.IsVIP == _loc2_.IsVIP)
               {
                  if(param1.Grade <= _loc2_.Grade)
                  {
                     return _loc3_ + 1;
                  }
                  _loc4_ = _loc3_ - 1;
               }
            }
            _loc3_--;
         }
         return _loc4_ < 0 ? 0 : _loc4_;
      }
      
      private function removeEvent() : void
      {
         this._selectedButtonGroup.removeEventListener("change",this.__onBtnGroupChange);
         PlayerManager.Instance.removeEventListener("friendListComplete",this.__friendlistHandler);
         FarmModelController.instance.removeEventListener("friendInfoReady",this.__infoReady);
         FarmModelController.instance.removeEventListener("friendList_updateStolen",this.__updateFriendListStolen);
         this._switchAsset.removeEventListener("click",this.__onClick);
         this._switchAsset.removeEventListener("mouseOver",this.__overHandler);
         this._switchAsset.removeEventListener("mouseOut",this.__outHandler);
         PlayerManager.Instance.friendList.removeEventListener("remove",this.__playerRemove);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._switchTween))
         {
            this._switchTween.kill();
         }
         this._switchTween = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._switchAsset))
         {
            ObjectUtils.disposeObject(this._switchAsset);
         }
         this._switchAsset = null;
         if(Boolean(this._tabBitmap))
         {
            ObjectUtils.disposeObject(this._tabBitmap);
         }
         this._tabBitmap = null;
         if(Boolean(this._selectedButtonGroup))
         {
            ObjectUtils.disposeObject(this._selectedButtonGroup);
         }
         this._selectedButtonGroup = null;
         if(Boolean(this._poultryBtn))
         {
            ObjectUtils.disposeObject(this._poultryBtn);
         }
         this._poultryBtn = null;
         if(Boolean(this._stealBtn))
         {
            ObjectUtils.disposeObject(this._stealBtn);
         }
         this._stealBtn = null;
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         if(Boolean(this._listBG))
         {
            ObjectUtils.disposeObject(this._listBG);
         }
         this._listBG = null;
         if(Boolean(this._listBound))
         {
            ObjectUtils.disposeObject(this._listBound);
         }
         this._listBound = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

