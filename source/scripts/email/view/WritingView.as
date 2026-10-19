package email.view
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.bag.BagFrame;
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddt.view.FriendDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import email.data.EmailInfo;
   import email.data.EmailState;
   import email.manager.MailManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class WritingView extends Frame implements IAcceptDrag
   {
      
      private var _selectInfo:EmailInfo;
      
      private var isChargeMail:Boolean = false;
      
      private var _hours:uint;
      
      private var _titleIsManMade:Boolean = false;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _writingViewBG:MovieClip;
      
      private var _receiver:FriendDropListTarget;
      
      private var _dropList:DropList;
      
      private var _topic:TextInput;
      
      private var _content:TextArea;
      
      private var _friendsBtn:BaseButton;
      
      private var _sendBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _type:int;
      
      private var contextTopTip:Bitmap;
      
      private var _titleImg:Bitmap;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _currentHourBtn:SelectedButton;
      
      private var _bag:Frame;
      
      private var _diamonds:Array;
      
      private var _payForEmailBG:MovieImage;
      
      private var _houerBtnGroup:SelectedButtonGroup;
      
      private var _oneHouerBtn:SelectedButton;
      
      private var _sixHouerBtn:SelectedButton;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _payForBtn:BaseButton;
      
      private var _moneyInput:TextInput;
      
      private var _hBox:HBox;
      
      private var bagContent:BagFrame;
      
      public function WritingView()
      {
         super();
         this.initView();
         this.addEvent();
         BagAndInfoManager.Instance.hideBagAndInfo();
      }
      
      private function initView() : void
      {
         var _loc4_:* = undefined;
         this.titleText = LanguageMgr.GetTranslation("tank.view.emailII.writingView.titleTxt");
         disposeChildren = true;
         this._writingViewBG = ClassUtils.CreatInstance("asset.email.writeViewBg");
         PositionUtils.setPos(this._writingViewBG,"writingView.BGPos");
         addToContent(this._writingViewBG);
         this.contextTopTip = ComponentFactory.Instance.creatBitmap("asset.email.writingTopTip");
         addToContent(this.contextTopTip);
         PositionUtils.setPos(this.contextTopTip,"writingTopTip.pos");
         this._receiver = ComponentFactory.Instance.creat("email.receiverInput");
         addToContent(this._receiver);
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._receiver;
         this._dropList.x = this._receiver.x;
         this._dropList.y = this._receiver.y + this._receiver.height;
         this._topic = ComponentFactory.Instance.creat("email.writeTopicInput");
         this._topic.textField.maxChars = 16;
         addToContent(this._topic);
         this._content = ComponentFactory.Instance.creatComponentByStylename("email.writeContent");
         this._content.textField.maxChars = 200;
         addToContent(this._content);
         this._friendsBtn = ComponentFactory.Instance.creat("email.friendsBtn");
         addToContent(this._friendsBtn);
         this._houerBtnGroup = new SelectedButtonGroup();
         this._oneHouerBtn = ComponentFactory.Instance.creat("email.oneHouerBtn");
         this.setTip(this._oneHouerBtn,LanguageMgr.GetTranslation("tank.view.emailII.WritingView.backTime"));
         addToContent(this._oneHouerBtn);
         this._houerBtnGroup.addSelectItem(this._oneHouerBtn);
         this._oneHouerBtn.enable = false;
         this._sixHouerBtn = ComponentFactory.Instance.creat("email.sixHouerBtn");
         this.setTip(this._sixHouerBtn,LanguageMgr.GetTranslation("tank.view.emailII.WritingView.backTime2"));
         addToContent(this._sixHouerBtn);
         this._houerBtnGroup.addSelectItem(this._sixHouerBtn);
         this._checkBox = ComponentFactory.Instance.creat("email.payCheckBtn");
         this._checkBox.enable = false;
         this._payForBtn = ComponentFactory.Instance.creat("email.payForBtn");
         addToContent(this._payForBtn);
         this._payForBtn.enable = false;
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.email.factorage");
         addToContent(_loc1_);
         this._moneyInput = ComponentFactory.Instance.creat("email.moneyInput");
         this._moneyInput.beginChanges();
         this._moneyInput.text = "";
         this._moneyInput.textField.restrict = "0-9";
         this._moneyInput.textField.maxChars = 9;
         this._moneyInput.visible = true;
         this._moneyInput.commitChanges();
         addToContent(this._moneyInput);
         this._sendBtn = ComponentFactory.Instance.creat("email.sendBtn");
         this._sendBtn.text = LanguageMgr.GetTranslation("send");
         addToContent(this._sendBtn);
         this._cancelBtn = ComponentFactory.Instance.creat("email.cancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._cancelBtn);
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.email.diamondTipImg");
         addToContent(_loc2_);
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         this._hBox = ComponentFactory.Instance.creat("emial.writingDiamondHbox");
         addToContent(this._hBox);
         this._diamonds = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < MailManager.Instance.NUM_OF_WRITING_DIAMONDS)
         {
            _loc4_ = new DiamondOfWriting();
            _loc4_.index = _loc3_;
            this._hBox.addChild(_loc4_);
            this._diamonds.push(_loc4_);
            _loc3_++;
         }
         this._hBox.refreshChildPos();
         this._bag = ComponentFactory.Instance.creat("email.emialBagFrame");
         this._bag.titleText = LanguageMgr.GetTranslation("tank.view.emailII.BagFrame.selectBag");
         addToContent(this._bag);
         this.bagContent = ComponentFactory.Instance.creat("email.bagContent");
         this.bagContent.bagView.setBagType(BagView.PROP);
         this._bag.addToContent(this.bagContent);
         this.bagContent.graySortBtn();
         this.bagContent.bagView.trieveBtnEnable = false;
         this.bagContent.bagView.isNeedCard(false);
      }
      
      private function setTip(param1:SelectedButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "0";
         param1.tipData = param2;
         param1.tipGapV = 5;
      }
      
      private function addEvent() : void
      {
         this._receiver.addEventListener(Event.CHANGE,this.__onReceiverChange);
         this._receiver.addEventListener(FocusEvent.FOCUS_IN,this.__onReceiverChange);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._content.textField.addEventListener(Event.CHANGE,this.__sound);
         this._content.textField.addEventListener(TextEvent.TEXT_INPUT,this.__taInput);
         this._friendsBtn.addEventListener(MouseEvent.CLICK,this.__friendListView);
         this._oneHouerBtn.addEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._sixHouerBtn.addEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._checkBox.addEventListener(MouseEvent.CLICK,this.__selectMoneyType);
         this._payForBtn.addEventListener(MouseEvent.CLICK,this.__selectMoneyType);
         this._moneyInput.textField.addEventListener(Event.CHANGE,this.__moneyChange);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__send);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__close);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEND_EMAIL,this.__sendEmailBack);
         addEventListener(KeyboardEvent.KEY_DOWN,this.__StopEnter);
         addEventListener(Event.ADDED_TO_STAGE,this.addToStageListener);
         addEventListener(FrameEvent.RESPONSE,this.__frameClose);
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            this._diamonds[_loc1_].addEventListener(EmailEvent.SHOW_BAGFRAME,this.__showBag);
            this._diamonds[_loc1_].addEventListener(EmailEvent.HIDE_BAGFRAME,this.__hideBag);
            this._diamonds[_loc1_].addEventListener(EmailEvent.DRAGIN_ANNIEX,this.__doDragIn);
            this._diamonds[_loc1_].addEventListener(EmailEvent.DRAGOUT_ANNIEX,this.__doDragOut);
            _loc1_++;
         }
      }
      
      private function __hideDropList(param1:MouseEvent) : void
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
      
      private function __onReceiverChange(param1:Event) : void
      {
         if(this._receiver.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterRepeatInArray(this.filterSearch(_loc2_,this._receiver.text));
      }
      
      private function filterRepeatInArray(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(_loc4_ == 0)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               if(_loc3_[_loc2_].NickName == param1[_loc4_].NickName)
               {
                  break;
               }
               if(_loc2_ == _loc3_.length - 1)
               {
                  _loc3_.push(param1[_loc4_]);
               }
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function filterSearch(param1:Array, param2:String) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].NickName.indexOf(param2) != -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function removeEvent() : void
      {
         this._friendsBtn.removeEventListener(MouseEvent.CLICK,this.__friendListView);
         this._oneHouerBtn.removeEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._sixHouerBtn.removeEventListener(MouseEvent.CLICK,this.__selectHourListener);
         this._checkBox.removeEventListener(MouseEvent.CLICK,this.__selectMoneyType);
         this._payForBtn.removeEventListener(MouseEvent.CLICK,this.__selectMoneyType);
         this._moneyInput.textField.removeEventListener(Event.CHANGE,this.__moneyChange);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__send);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__close);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SEND_EMAIL,this.__sendEmailBack);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__StopEnter);
         removeEventListener(Event.ADDED_TO_STAGE,this.addToStageListener);
         removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            this._diamonds[_loc1_].removeEventListener(EmailEvent.SHOW_BAGFRAME,this.__showBag);
            this._diamonds[_loc1_].removeEventListener(EmailEvent.HIDE_BAGFRAME,this.__hideBag);
            this._diamonds[_loc1_].removeEventListener(EmailEvent.DRAGIN_ANNIEX,this.__doDragIn);
            this._diamonds[_loc1_].removeEventListener(EmailEvent.DRAGOUT_ANNIEX,this.__doDragOut);
            _loc1_++;
         }
      }
      
      public function set selectInfo(param1:EmailInfo) : void
      {
         this._selectInfo = param1;
      }
      
      public function isHasWrite() : Boolean
      {
         if(!StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._receiver.text)))
         {
            return true;
         }
         if(!StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._topic.text)))
         {
            return true;
         }
         if(!StringHelper.isNullOrEmpty(FilterWordManager.filterWrod(this._content.text)))
         {
            return true;
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            if(Boolean(DiamondOfWriting(this._diamonds[_loc1_]).annex))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function selectName(param1:String, param2:int = 0) : void
      {
         this._receiver.text = param1;
         this._friendList.setVisible = false;
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         param1.action = DragEffect.MOVE;
         var _loc3_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(Boolean(_loc3_) && param1.action != DragEffect.SPLIT)
         {
            _loc2_ = 0;
            while(_loc2_ < this._diamonds.length)
            {
               if(this._diamonds[_loc2_].annex == null)
               {
                  this._diamonds[_loc2_].dragDrop(param1);
                  if(Boolean(param1.target))
                  {
                     return;
                  }
               }
               _loc2_++;
            }
            param1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.full"));
         }
      }
      
      public function reset() : void
      {
         this._receiver.text = "";
         this._topic.text = "";
         this._content.text = "";
         this._currentHourBtn = null;
         this._hours = 1;
         this._moneyInput.text = "";
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            DiamondOfWriting(this._diamonds[_loc1_]).annex = null;
            _loc1_++;
         }
         this._payForBtn.enable = false;
         this._checkBox.enable = false;
         this._oneHouerBtn.enable = false;
         this._sixHouerBtn.enable = false;
         this.setDiamondMoneyType();
      }
      
      private function btnSound() : void
      {
         SoundManager.instance.play("043");
      }
      
      private function getFirstDiamond() : DiamondOfWriting
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            if(Boolean(DiamondOfWriting(this._diamonds[_loc1_]).annex))
            {
               return this._diamonds[_loc1_] as DiamondOfWriting;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function closeWin() : void
      {
         if(this.isHasWrite())
         {
            if(this._confirmFrame == null)
            {
               this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.tip"),LanguageMgr.GetTranslation("tank.view.emailII.WritingView.isEdit"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            }
         }
         else if(this._type == 0)
         {
            this.okCancel();
            dispatchEvent(new EmailEvent(EmailEvent.CLOSE_WRITING_FRAME));
         }
      }
      
      public function okCancel() : void
      {
         this.btnSound();
         this.reset();
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            DiamondOfWriting(this._diamonds[_loc1_]).setBagUnlock();
            _loc1_++;
         }
         if(Boolean(this._friendList) && Boolean(this._friendList.parent))
         {
            this._friendList.setVisible = false;
         }
         MailManager.Instance.changeState(EmailState.READ);
      }
      
      private function payEnable(param1:Boolean) : void
      {
         this._payForBtn.enable = param1;
         this._topic.enable = !param1;
         this._checkBox.mouseChildren = this._checkBox.mouseEnabled = this._checkBox.buttonMode = this._checkBox.enable = this._checkBox.selected = param1;
         this._moneyInput.enable = param1;
         this._moneyInput.text = "";
         this.isChargeMail = this._checkBox.selected;
      }
      
      private function atLeastOneDiamond() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            if(Boolean(DiamondOfWriting(this._diamonds[_loc1_]).annex))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function setDiamondMoneyType() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._diamonds.length)
         {
            DiamondOfWriting(this._diamonds[_loc1_]).chargedImg.visible = false;
            DiamondOfWriting(this._diamonds[_loc1_]).centerMC.visible = true;
            if(Boolean(DiamondOfWriting(this._diamonds[_loc1_]).annex) && this.isChargeMail)
            {
               DiamondOfWriting(this._diamonds[_loc1_]).centerMC.visible = false;
               DiamondOfWriting(this._diamonds[_loc1_]).chargedImg.visible = true;
            }
            else if(Boolean(DiamondOfWriting(this._diamonds[_loc1_]).annex) && !this.isChargeMail)
            {
               DiamondOfWriting(this._diamonds[_loc1_]).centerMC.visible = false;
            }
            else
            {
               DiamondOfWriting(this._diamonds[_loc1_]).centerMC.setFrame(1);
            }
            _loc1_++;
         }
         this.switchHourBtnState(this.isChargeMail);
      }
      
      private function switchHourBtnState(param1:Boolean) : void
      {
         this._oneHouerBtn.selected = false;
         this._sixHouerBtn.selected = false;
         this._oneHouerBtn.enable = param1;
         this._sixHouerBtn.enable = param1;
         if(param1)
         {
            this._currentHourBtn = this._oneHouerBtn;
            this._currentHourBtn.selected = true;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleImg);
         this._titleImg = null;
         ObjectUtils.disposeObject(this.contextTopTip);
         this.contextTopTip = null;
         ObjectUtils.disposeObject(this._friendList);
         this._friendList = null;
         ObjectUtils.disposeObject(this._writingViewBG);
         this._writingViewBG = null;
         ObjectUtils.disposeObject(this._receiver);
         this._receiver = null;
         ObjectUtils.disposeObject(this._dropList);
         this._dropList = null;
         ObjectUtils.disposeObject(this._topic);
         this._topic = null;
         ObjectUtils.disposeObject(this._friendsBtn);
         this._friendsBtn = null;
         ObjectUtils.disposeObject(this._sendBtn);
         this._sendBtn = null;
         ObjectUtils.disposeObject(this._cancelBtn);
         this._cancelBtn = null;
         ObjectUtils.disposeObject(this._confirmFrame);
         this._confirmFrame = null;
         ObjectUtils.disposeObject(this._selectInfo);
         this._selectInfo = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this._bag))
         {
            ObjectUtils.disposeObject(this._bag);
         }
         this._bag = null;
         if(Boolean(this.bagContent))
         {
            this.bagContent.dispose();
         }
         this.bagContent = null;
         if(Boolean(this._payForEmailBG))
         {
            ObjectUtils.disposeObject(this._payForEmailBG);
         }
         this._payForEmailBG = null;
         if(Boolean(this._houerBtnGroup))
         {
            ObjectUtils.disposeObject(this._houerBtnGroup);
         }
         this._houerBtnGroup = null;
         if(Boolean(this._oneHouerBtn))
         {
            ObjectUtils.disposeObject(this._oneHouerBtn);
         }
         this._oneHouerBtn = null;
         if(Boolean(this._sixHouerBtn))
         {
            ObjectUtils.disposeObject(this._sixHouerBtn);
         }
         this._sixHouerBtn = null;
         if(Boolean(this._checkBox))
         {
            ObjectUtils.disposeObject(this._checkBox);
         }
         this._checkBox = null;
         if(Boolean(this._payForBtn))
         {
            ObjectUtils.disposeObject(this._payForBtn);
         }
         if(Boolean(this._hBox))
         {
            ObjectUtils.disposeObject(this._hBox);
         }
         this._hBox = null;
         this._diamonds = null;
         this._payForBtn = null;
         super.dispose();
         dispatchEvent(new EmailEvent(EmailEvent.DISPOSED));
      }
      
      private function __selectHourListener(param1:MouseEvent) : void
      {
         this.btnSound();
         if(Boolean(this._currentHourBtn))
         {
            this._currentHourBtn.selected = false;
         }
         this._currentHourBtn = param1.currentTarget as SelectedButton;
         this._currentHourBtn.selected = true;
         if(this._currentHourBtn == this._oneHouerBtn)
         {
            this._hours = 1;
         }
         else
         {
            this._hours = 6;
         }
      }
      
      private function __selectMoneyType(param1:MouseEvent) : void
      {
         if(param1.currentTarget == this._payForBtn)
         {
            this._checkBox.selected = !this._checkBox.selected;
         }
         this.isChargeMail = this._checkBox.selected;
         if(this.isChargeMail)
         {
            this._moneyInput.enable = true;
         }
         else
         {
            this._moneyInput.enable = false;
         }
         this.btnSound();
         this._topic.enable = !this._checkBox.selected;
         this._moneyInput.text = "";
         if(this._checkBox.selected)
         {
            this._moneyInput.setFocus();
            this._checkBox.mouseChildren = this._checkBox.mouseEnabled = this._checkBox.buttonMode = true;
         }
         this.setDiamondMoneyType();
      }
      
      private function __moneyChange(param1:Event) : void
      {
         if(this._moneyInput.text.charAt(0) == "0")
         {
            this._moneyInput.text = "";
         }
         param1.preventDefault();
      }
      
      private function __send(param1:MouseEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:InventoryItemInfo = null;
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:DiamondOfWriting = null;
         this.btnSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(FilterWordManager.IsNullorEmpty(this._receiver.text))
         {
            this._receiver.text = "";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.sender"));
         }
         else if(this._receiver.text == PlayerManager.Instance.Self.NickName)
         {
            this._receiver.text = "";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.NickName"));
         }
         else if(FilterWordManager.IsNullorEmpty(this._topic.text) && !this.getFirstDiamond())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.topic"));
         }
         else if(PlayerManager.Instance.Self.Gold < 100)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc2_.moveEnable = false;
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         }
         else if(this._content.text.length > 200)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.contentLength"));
         }
         else
         {
            if(this.isChargeMail && !Number(this._moneyInput.text))
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.money_txt"));
               return;
            }
            if(this.isChargeMail && !this.atLeastOneDiamond())
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.WritingView.annex"));
               return;
            }
            if(!this.isChargeMail && int(this._moneyInput.text) > PlayerManager.Instance.Self.Money)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            _loc3_ = new Object();
            _loc3_.NickName = this._receiver.text;
            _loc3_.Title = FilterWordManager.filterWrod(this._topic.text);
            _loc3_.Content = FilterWordManager.filterWrod(this._content.text);
            _loc3_.SendedMoney = Number(this._moneyInput.text);
            _loc3_.isPay = this.isChargeMail;
            if(this.isChargeMail)
            {
               _loc3_.hours = this._hours;
               _loc5_ = this.getFirstDiamond();
               _loc3_.Title = _loc5_.annex.Name;
            }
            else
            {
               _loc3_.SendedMoney = 0;
            }
            _loc4_ = [];
            _loc6_ = 0;
            while(_loc6_ < this._diamonds.length)
            {
               if(Boolean(DiamondOfWriting(this._diamonds[_loc6_]).annex))
               {
                  _loc7_ = DiamondOfWriting(this._diamonds[_loc6_]).annex as InventoryItemInfo;
                  _loc4_.push(_loc7_);
                  _loc3_["Annex" + _loc6_] = _loc7_.BagType.toString() + "," + _loc7_.Place.toString();
               }
               _loc6_++;
            }
            MailManager.Instance.sendEmail(_loc3_);
            MailManager.Instance.onSendAnnex(_loc4_);
            this._sendBtn.enable = false;
         }
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         SoundManager.instance.play("008");
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         _loc3_.dispose();
         if(Boolean(_loc3_.parent))
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         _loc3_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc2_.itemID = EquipType.GOLD_BOX;
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __friendListView(param1:MouseEvent) : void
      {
         this.btnSound();
         var _loc2_:Point = this._friendsBtn.localToGlobal(new Point(0,0));
         this._friendList.x = _loc2_.x + this._friendsBtn.width;
         this._friendList.y = _loc2_.y;
         this._friendList.setVisible = true;
      }
      
      private function __taInput(param1:TextEvent) : void
      {
         if(this._content.text.length > 300)
         {
            param1.preventDefault();
         }
      }
      
      private function __sendEmailBack(param1:CrazyTankSocketEvent) : void
      {
         this._sendBtn.enable = true;
      }
      
      private function __StopEnter(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            param1.stopImmediatePropagation();
         }
         else if(param1.keyCode == Keyboard.ESCAPE)
         {
            param1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this.closeWin();
         }
      }
      
      private function addToStageListener(param1:Event) : void
      {
         this.reset();
         this._receiver.text = Boolean(this._selectInfo) ? this._selectInfo.Sender : "";
         this._topic.text = "";
         this._content.text = "";
         if(Boolean(stage))
         {
            stage.focus = this;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this._diamonds.length)
         {
            DiamondOfWriting(this._diamonds[_loc2_]).annex = null;
            _loc2_++;
         }
      }
      
      private function __sound(param1:Event) : void
      {
         this._titleIsManMade = true;
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         this.btnSound();
         this.closeWin();
      }
      
      private function __close(param1:MouseEvent) : void
      {
         this.btnSound();
         this.closeWin();
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this._confirmFrame.dispose();
         this._confirmFrame = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this._type == 0)
            {
               this.okCancel();
            }
            dispatchEvent(new EmailEvent(EmailEvent.CLOSE_WRITING_FRAME));
         }
      }
      
      private function __showBag(param1:EmailEvent) : void
      {
         var _loc2_:DiamondOfWriting = param1.target as DiamondOfWriting;
         if(_loc2_.annex == null || this._bag.parent == null)
         {
            this._bag.visible = true;
         }
      }
      
      private function __hideBag(param1:EmailEvent) : void
      {
         this._bag.visible = false;
      }
      
      private function __doDragIn(param1:EmailEvent) : void
      {
         var _loc2_:DiamondOfWriting = null;
         this._payForBtn.enable = true;
         this._checkBox.mouseChildren = this._checkBox.mouseEnabled = this._checkBox.buttonMode = this._checkBox.enable = true;
         if(this._topic.text == "" || !this._titleIsManMade)
         {
            _loc2_ = this.getFirstDiamond();
            if(Boolean(_loc2_))
            {
               this._topic.text = _loc2_.annex.Name;
               this._titleIsManMade = false;
            }
            else
            {
               this._topic.text = "";
               this._titleIsManMade = false;
            }
         }
         this.setDiamondMoneyType();
      }
      
      private function __doDragOut(param1:EmailEvent) : void
      {
         if(this.atLeastOneDiamond())
         {
            this._payForBtn.enable = true;
            this._checkBox.enable = true;
         }
         else
         {
            this.payEnable(false);
            this._topic.text = "";
         }
         this.setDiamondMoneyType();
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function setName(param1:String) : void
      {
         this._receiver.text = param1;
      }
   }
}

