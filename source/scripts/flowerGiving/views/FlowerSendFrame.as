package flowerGiving.views
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.components.FlowerSendFrameItem;
   import flowerGiving.components.FlowerSendFrameNameInput;
   import flowerGiving.data.FlowerSendRecordInfo;
   import flowerGiving.events.FlowerGivingEvent;
   import flowerGiving.events.FlowerSendRecordEvent;
   import road7th.comm.PackageIn;
   import road7th.utils.StringHelper;
   import shop.manager.ShopBuyManager;
   
   public class FlowerSendFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _sendBtnBg:ScaleBitmapImage;
      
      private var _leftBit:Bitmap;
      
      private var _rightBit:Bitmap;
      
      private var _sendRecordBtn:SimpleBitmapButton;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _numTxt:FilterFrameText;
      
      private var _otherNumTxt:FilterFrameText;
      
      private var _otherSelectBtn:SelectedCheckButton;
      
      private var _selectBtnGroup:SelectedButtonGroup;
      
      private var _sendBtn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _sendToOtherTxt:FilterFrameText;
      
      private var _itemArr:Array;
      
      private var _sendRecordFrame:Frame;
      
      private var _dataArr:Array;
      
      private var _myFlowerBagCell:BagCell;
      
      private var _maxNum:int;
      
      private var _nameInput:FlowerSendFrameNameInput;
      
      private var _dropList:DropList;
      
      public function FlowerSendFrame()
      {
         super();
         this.initView();
         this.initViewWithData();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._itemArr = new Array();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.FlowerSendFrame.scale9ImageBg");
         addToContent(this._bg);
         this._leftBit = ComponentFactory.Instance.creat("flowerGiving.flowerSendFrame.sendLeft");
         addToContent(this._leftBit);
         this._selectBtnGroup = new SelectedButtonGroup();
         this._otherSelectBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.selectedBtn");
         addToContent(this._otherSelectBtn);
         PositionUtils.setPos(this._otherSelectBtn,"flowerGiving.flowerSendFrame.oselectBtnPos");
         this._selectBtnGroup.addSelectItem(this._otherSelectBtn);
         this._rightBit = ComponentFactory.Instance.creat("flowerGiving.flowerSendFrame.sendRight");
         addToContent(this._rightBit);
         this._sendRecordBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendRecordBtn");
         addToContent(this._sendRecordBtn);
         this._numTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.numTxt");
         this._numTxt.restrict = "0-9";
         addToContent(this._numTxt);
         this._numTxt.text = "1";
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.maxBtn");
         addToContent(this._maxBtn);
         this._otherNumTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt2");
         addToContent(this._otherNumTxt);
         PositionUtils.setPos(this._otherNumTxt,"flowerGiving.flowerSendFrame.otherNumPos");
         this._otherNumTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.otherNumTxt");
         this._sendBtnBg = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendBtnBackBg");
         addToContent(this._sendBtnBg);
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendBtn");
         addToContent(this._sendBtn);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.buyBtn");
         addToContent(this._buyBtn);
         this._nameInput = ComponentFactory.Instance.creatCustomObject("flowerGiving.FlowerSendFrame.nameInput");
         PositionUtils.setPos(this._nameInput,"flowerGiving.flowerSendFrame.searchTxtPos");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x - 63;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         addToContent(this._nameInput);
         this._sendToOtherTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendToOtherTxt");
         addToContent(this._sendToOtherTxt);
         this._sendToOtherTxt.maxChars = 35;
         this._sendToOtherTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.sendToOther");
      }
      
      private function initViewWithData() : void
      {
         var _loc1_:FlowerSendFrameItem = null;
         this._dataArr = FlowerGivingManager.instance.getDataByRewardMark(5);
         var _loc2_:int = 0;
         while(_loc2_ < this._dataArr.length)
         {
            _loc1_ = new FlowerSendFrameItem(this._dataArr[_loc2_]);
            PositionUtils.setPos(_loc1_,"flowerGiving.flowerSendFrame.itemPos" + (_loc2_ + 1));
            addToContent(_loc1_);
            this._selectBtnGroup.addSelectItem(_loc1_.selectBtn);
            this._itemArr.push(_loc1_);
            _loc2_++;
         }
         this._selectBtnGroup.selectIndex = 0;
         var _loc3_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this._maxNum = _loc3_.getItemCountByTemplateId(FlowerGivingManager.instance.flowerTempleteId);
         this._myFlowerBagCell = this.createBagCell(FlowerGivingManager.instance.flowerTempleteId);
         this._myFlowerBagCell.setCount(this._maxNum);
         addToContent(this._myFlowerBagCell);
         PositionUtils.setPos(this._myFlowerBagCell,"flowerGiving.flowerSendFrame.myFlowerBagCell");
      }
      
      private function createBagCell(param1:int) : BagCell
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         _loc2_ = ItemManager.fill(_loc2_);
         _loc2_.IsBinds = true;
         var _loc3_:BagCell = new BagCell(0);
         _loc3_.info = _loc2_;
         _loc3_.setBgVisible(false);
         return _loc3_;
      }
      
      protected function __onReceiverChange(param1:Event) : void
      {
         if(this._nameInput.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_loc2_),this._nameInput.text);
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
      
      protected function __hideDropList(param1:Event) : void
      {
         if(param1.target is FilterFrameText && param1.target != this._numTxt && param1.target != this._sendToOtherTxt)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._responseHandle);
         this._sendRecordBtn.removeEventListener(MouseEvent.CLICK,this.__recordHandler);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__maxHandler);
         this._numTxt.removeEventListener(Event.CHANGE,this.__inputHandler);
         this._selectBtnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._sendBtn.removeEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._nameInput.removeEventListener(Event.CHANGE,this.__onReceiverChange);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyHandler);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__hideDropList);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GIVE_FLOWER,this.__giveHandler);
         SocketManager.Instance.removeEventListener(FlowerGivingEvent.GET_RECORD,this.__getRecordHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__flowerBuyHandler);
         FlowerGivingManager.instance.removeEventListener(FlowerSendRecordEvent.HUIKUI_FLOWER,this._huiKuiHandler);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._responseHandle);
         this._sendRecordBtn.addEventListener(MouseEvent.CLICK,this.__recordHandler);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__maxHandler);
         this._numTxt.addEventListener(Event.CHANGE,this.__inputHandler);
         this._selectBtnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._sendBtn.addEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._nameInput.addEventListener(Event.CHANGE,this.__onReceiverChange);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__hideDropList);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.__buyHandler);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GIVE_FLOWER,this.__giveHandler);
         SocketManager.Instance.addEventListener(FlowerGivingEvent.GET_RECORD,this.__getRecordHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.__flowerBuyHandler);
         FlowerGivingManager.instance.addEventListener(FlowerSendRecordEvent.HUIKUI_FLOWER,this._huiKuiHandler);
      }
      
      protected function _huiKuiHandler(param1:FlowerSendRecordEvent) : void
      {
         this._nameInput.text = param1.nickName;
         if(Boolean(this._sendRecordFrame))
         {
            this._sendRecordFrame.dispose();
         }
      }
      
      protected function __flowerBuyHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         _loc2_.position = SocketManager.PACKAGE_CONTENT_START_INDEX;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         this.updateFlowerNum();
      }
      
      protected function __buyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:ShopItemInfo = ShopManager.Instance.getMoneyShopItemByTemplateID(FlowerGivingManager.instance.flowerTempleteId);
         ShopBuyManager.Instance.buy(_loc2_.GoodsID,_loc2_.isDiscount,_loc2_.getItemPrice(1).PriceType);
      }
      
      protected function __getRecordHandler(param1:FlowerGivingEvent) : void
      {
         var _loc2_:FlowerSendRecordInfo = null;
         var _loc3_:Array = new Array();
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:int = _loc4_.readInt();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new FlowerSendRecordInfo();
            _loc2_.date = _loc4_.readUTF();
            _loc2_.selfId = _loc4_.readInt();
            _loc2_.playerId = _loc4_.readInt();
            _loc2_.nickName = _loc4_.readUTF();
            _loc2_.flag = _loc4_.readBoolean();
            _loc2_.num = _loc4_.readInt();
            _loc3_.push(_loc2_);
            _loc6_++;
         }
         this._sendRecordFrame = ComponentFactory.Instance.creatCustomObject("flowerGiving.FlowerSendRecordFrame",[_loc3_]);
         this._sendRecordFrame.titleText = LanguageMgr.GetTranslation("flowerGiving.flowerSendRecordFrame.title");
         LayerManager.Instance.addToLayer(this._sendRecordFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      protected function __giveHandler(param1:FlowerGivingEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         this.updateFlowerNum();
      }
      
      private function updateFlowerNum() : void
      {
         var _loc1_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this._maxNum = _loc1_.getItemCountByTemplateId(FlowerGivingManager.instance.flowerTempleteId);
         this._myFlowerBagCell.setCount(this._maxNum);
      }
      
      protected function __sendHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:String = this._nameInput.text;
         if(_loc3_ == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.nameInputTxt"));
            return;
         }
         if(this._selectBtnGroup.selectIndex != 0)
         {
            _loc2_ = int(this._dataArr[this._selectBtnGroup.selectIndex - 1].giftConditionArr[0].conditionValue);
         }
         else
         {
            _loc2_ = int(this._numTxt.text);
         }
         if(_loc2_ > this._maxNum)
         {
            this.__buyHandler(null);
            return;
         }
         var _loc4_:String = this._sendToOtherTxt.text;
         _loc4_ = StringHelper.trim(_loc4_);
         _loc4_ = FilterWordManager.filterWrod(_loc4_);
         _loc4_ = StringHelper.rePlaceHtmlTextField(_loc4_);
         SocketManager.Instance.out.sendFlower(_loc3_,_loc2_,_loc4_);
      }
      
      protected function __changeHandler(param1:Event) : void
      {
         var _loc2_:FlowerSendFrameItem = null;
         SoundManager.instance.play("008");
         for each(_loc2_ in this._itemArr)
         {
            _loc2_.updateShine();
         }
      }
      
      protected function __inputHandler(param1:Event) : void
      {
         if(int(this._numTxt.text) < 1)
         {
            this._numTxt.text = "1";
         }
         else if(int(this._numTxt.text) > this._maxNum)
         {
            this._numTxt.text = "" + this._maxNum;
         }
      }
      
      protected function __maxHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._maxNum = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).getItemCountByTemplateId(FlowerGivingManager.instance.flowerTempleteId);
         this._numTxt.text = this._maxNum > 0 ? "" + this._maxNum : "1";
      }
      
      protected function __recordHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendFlowerRecord();
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:FlowerSendFrameItem = null;
         this._sendRecordFrame = null;
         this.removeEvent();
         for each(_loc1_ in this._itemArr)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._itemArr = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._sendBtnBg))
         {
            ObjectUtils.disposeObject(this._sendBtnBg);
         }
         this._sendBtnBg = null;
         if(Boolean(this._leftBit))
         {
            ObjectUtils.disposeObject(this._leftBit);
         }
         this._leftBit = null;
         if(Boolean(this._rightBit))
         {
            ObjectUtils.disposeObject(this._rightBit);
         }
         this._rightBit = null;
         if(Boolean(this._sendRecordBtn))
         {
            ObjectUtils.disposeObject(this._sendRecordBtn);
         }
         this._sendRecordBtn = null;
         if(Boolean(this._numTxt))
         {
            ObjectUtils.disposeObject(this._numTxt);
         }
         this._numTxt = null;
         if(Boolean(this._otherNumTxt))
         {
            ObjectUtils.disposeObject(this._otherNumTxt);
         }
         this._otherNumTxt = null;
         if(Boolean(this._maxBtn))
         {
            ObjectUtils.disposeObject(this._maxBtn);
         }
         this._maxBtn = null;
         if(Boolean(this._otherSelectBtn))
         {
            ObjectUtils.disposeObject(this._otherSelectBtn);
         }
         this._otherSelectBtn = null;
         if(Boolean(this._selectBtnGroup))
         {
            ObjectUtils.disposeObject(this._selectBtnGroup);
         }
         this._selectBtnGroup = null;
         if(Boolean(this._sendBtn))
         {
            ObjectUtils.disposeObject(this._sendBtn);
         }
         this._sendBtn = null;
         if(Boolean(this._buyBtn))
         {
            ObjectUtils.disposeObject(this._buyBtn);
         }
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._dropList);
         this._dropList = null;
         this._nameInput = null;
         if(Boolean(this._sendToOtherTxt))
         {
            ObjectUtils.disposeObject(this._sendToOtherTxt);
         }
         this._sendToOtherTxt = null;
         if(Boolean(this._myFlowerBagCell))
         {
            ObjectUtils.disposeObject(this._myFlowerBagCell);
         }
         this._myFlowerBagCell = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

