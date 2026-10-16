package vip.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.FriendDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import road7th.utils.StringHelper;
   import vip.VipController;
   
   public class GiveOthersOpenedView extends GiveYourselfOpenView implements Disposeable
   {
      
      public var isBand:Boolean;
      
      private var _nametxt:FilterFrameText;
      
      private var _repeatNametxt:FilterFrameText;
      
      private var _friendName:FriendDropListTarget;
      
      private var _amountOfMoneyTxt:FilterFrameText;
      
      private var _amountOfMoney:FilterFrameText;
      
      private var _moneyIcon:Image;
      
      private var _dropList:DropList;
      
      private var _repeatName:TextInput;
      
      private var _friendListBtn:TextButton;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _list:VBox;
      
      private var _itemArray:Array;
      
      private var _listBG:Scale9CornerImage;
      
      private var _inputBG:Scale9CornerImage;
      
      private var _listScrollPanel:ScrollPanel;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      public function GiveOthersOpenedView(param1:Boolean, param2:int)
      {
         super(param2);
         this.init();
         this.isBand = param1;
      }
      
      private function init() : void
      {
         _isSelf = false;
         this._nametxt = ComponentFactory.Instance.creatComponentByStylename("vip.name");
         this._nametxt.text = LanguageMgr.GetTranslation("ddt.vip.nametxt");
         addChild(this._nametxt);
         this._repeatNametxt = ComponentFactory.Instance.creatComponentByStylename("vip.repeatName");
         this._repeatNametxt.text = LanguageMgr.GetTranslation("ddt.vip.repeatNametxt");
         addChild(this._repeatNametxt);
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("asset.vip.friendNameBG");
         addChild(this._inputBG);
         this._friendName = ComponentFactory.Instance.creat("GiveOthersOpenedView.friendName");
         addChild(this._friendName);
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.DropList");
         this._dropList.targetDisplay = this._friendName;
         this._dropList.x = this._inputBG.x;
         this._dropList.y = this._inputBG.y + this._inputBG.height;
         this._repeatName = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.repeatName");
         addChild(this._repeatName);
         this._friendListBtn = ComponentFactory.Instance.creatComponentByStylename("GiveYourselfOpenView.friendList");
         this._friendListBtn.text = LanguageMgr.GetTranslation("ddt.vip.friendListBtn");
         addChild(this._friendListBtn);
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         this._listBG = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.searchListBG");
         addChild(this._listBG);
         this._listBG.visible = false;
         this._list = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.searchList");
         addChild(this._list);
         this._itemArray = [];
         this._amountOfMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.amountOfMoneyTxt");
         this._amountOfMoneyTxt.text = LanguageMgr.GetTranslation("ddt.vip.amountOfMoneyTxt");
         addChild(this._amountOfMoneyTxt);
         this._amountOfMoney = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.amountOfMoney");
         this._amountOfMoney.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("ddt.vip.amountOfMoneyUnit");
         addChild(this._amountOfMoney);
         this._moneyIcon = ComponentFactory.Instance.creatComponentByStylename("GiveOthersOpenedView.MoneyIcon");
         addChild(this._moneyIcon);
         _vipPrivilegeTxt.visible = false;
         showOpenOrRenewal();
         rewardBtnCanUse();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._friendName.addEventListener("textInput",this.__textInputHandler);
         this._friendName.addEventListener("change",this.__textChange);
         this._repeatName.addEventListener("textInput",this.__repeattextInputHandler);
         this._friendListBtn.addEventListener("click",this.__friendListView);
         StageReferance.stage.addEventListener("click",this.__listAction);
         this._friendName.addEventListener("focusIn",this.__textChange);
         this._dropList.addEventListener("selected",this.__seletected);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__propertyChangedHandler);
      }
      
      protected function __propertyChangedHandler(param1:Event) : void
      {
         this._amountOfMoney.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("ddt.vip.amountOfMoneyUnit");
      }
      
      private function removeEvent() : void
      {
         this._friendName.removeEventListener("textInput",this.__textInputHandler);
         this._friendName.removeEventListener("change",this.__textChange);
         this._repeatName.removeEventListener("textInput",this.__repeattextInputHandler);
         this._friendListBtn.removeEventListener("click",this.__friendListView);
         StageReferance.stage.removeEventListener("click",this.__listAction);
         this._friendName.removeEventListener("focusIn",this.__textChange);
         this._dropList.removeEventListener("selected",this.__seletected);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__propertyChangedHandler);
      }
      
      private function __seletected(param1:Event) : void
      {
         this._repeatName.text = this._friendName.text;
      }
      
      private function __listAction(param1:MouseEvent) : void
      {
         if(param1.target is FriendDropListTarget)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      private function __textChange(param1:Event) : void
      {
         if(this._friendName.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_loc2_),this._friendName.text);
      }
      
      private function filterSearch(param1:Array, param2:String) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].NickName.indexOf(param2) != -1)
            {
               _loc4_.push(param1[_loc3_]);
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      private function filterRepeatInArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ == 0)
            {
               _loc4_.push(param1[_loc2_]);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               if(_loc4_[_loc3_].NickName == param1[_loc2_].NickName)
               {
                  break;
               }
               if(_loc3_ == _loc4_.length - 1)
               {
                  _loc4_.push(param1[_loc2_]);
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      private function __textInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._friendName,14);
      }
      
      private function __repeattextInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._repeatName.textField,14);
      }
      
      override protected function __openVip(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < payNum)
         {
            this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2);
            this._moneyConfirm.moveEnable = false;
            this._moneyConfirm.addEventListener("response",this.__moneyConfirmHandler);
            return;
         }
         if(this._friendName.text == "" || this._repeatName.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.finish"));
            return;
         }
         if(this._friendName.text != this._repeatName.text)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.vip.vipView.checkName"));
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.vip.vipView.confirmforOther",this._friendName.text,time,payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,1);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener("response",this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener("response",this.__moneyConfirmHandler);
         switch(param1.responseCode - 2)
         {
            case 0:
            case 1:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(Boolean(this._moneyConfirm.parent))
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener("response",this.__confirm);
         switch(param1.responseCode - 2)
         {
            case 0:
            case 1:
               sendVip();
               this._friendName.text = "";
               this._repeatName.text = "";
               upPayMoneyText();
         }
         this._confirmFrame.dispose();
         if(Boolean(this._confirmFrame.parent))
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      override protected function send() : void
      {
         VipController.instance.sendOpenVip(this._friendName.text,days,false);
      }
      
      private function selectName(param1:String, param2:int = 0) : void
      {
         this._friendName.text = param1;
         this._repeatName.text = param1;
         this._friendList.setVisible = false;
      }
      
      private function __friendListView(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._friendListBtn.localToGlobal(new Point(0,0));
         this._friendList.x = _loc2_.x;
         this._friendList.y = _loc2_.y + this._friendListBtn.height;
         this._friendList.setVisible = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._dropList))
         {
            ObjectUtils.disposeObject(this._dropList);
         }
         this._dropList = null;
         if(Boolean(this._repeatNametxt))
         {
            ObjectUtils.disposeObject(this._repeatNametxt);
         }
         this._repeatNametxt = null;
         if(Boolean(this._friendName))
         {
            ObjectUtils.disposeObject(this._friendName);
         }
         this._friendName = null;
         if(Boolean(this._repeatName))
         {
            ObjectUtils.disposeObject(this._repeatName);
         }
         this._repeatName = null;
         if(Boolean(this._friendListBtn))
         {
            ObjectUtils.disposeObject(this._friendListBtn);
         }
         this._friendListBtn = null;
         if(Boolean(this._friendList))
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(Boolean(this._moneyConfirm))
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
         if(Boolean(this._inputBG))
         {
            ObjectUtils.disposeObject(this._inputBG);
         }
         this._inputBG = null;
         if(Boolean(this._listBG))
         {
            ObjectUtils.disposeObject(this._listBG);
         }
         this._listBG = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         ObjectUtils.disposeObject(this._nametxt);
         this._nametxt = null;
         ObjectUtils.disposeObject(this._amountOfMoneyTxt);
         this._amountOfMoneyTxt = null;
         ObjectUtils.disposeObject(this._amountOfMoney);
         this._amountOfMoney = null;
         ObjectUtils.disposeObject(this._moneyIcon);
         this._moneyIcon = null;
         ObjectUtils.disposeObject(this._listScrollPanel);
         this._listScrollPanel = null;
      }
   }
}

