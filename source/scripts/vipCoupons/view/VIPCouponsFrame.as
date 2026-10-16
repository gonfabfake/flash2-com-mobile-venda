package vipCoupons.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.utils.StringHelper;
   
   public class VIPCouponsFrame extends Frame
   {
      
      private var _contenBg:MutipleImage;
      
      private var _sendBtn:SimpleBitmapButton;
      
      private var _nameInput:VIPCouponsNameInput;
      
      private var _dropList:DropList;
      
      private var _sendToOtherTxt:FilterFrameText;
      
      private var _vipCell:BagCell;
      
      private var _bagType:int;
      
      private var _place:int;
      
      private var _useType:int;
      
      private var _itemID:int;
      
      public function VIPCouponsFrame(param1:int, param2:int, param3:int)
      {
         super();
         this._bagType = param1;
         this._place = param2;
         this._useType = param3;
         this._itemID = this._useType == 0 ? 12568 : 12783;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._contenBg = ComponentFactory.Instance.creatComponentByStylename("vipCoupons.mainPageBg");
         addToContent(this._contenBg);
         this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("vipCoupons.sendBtn");
         addToContent(this._sendBtn);
         this._nameInput = ComponentFactory.Instance.creatCustomObject("vipCoupons.sendNameInput.friendList");
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
         this._dropList.targetDisplay = this._nameInput;
         this._dropList.x = this._nameInput.x - 29;
         this._dropList.y = this._nameInput.y + this._nameInput.height;
         addToContent(this._nameInput);
         this._sendToOtherTxt = ComponentFactory.Instance.creatComponentByStylename("vipCoupons.sendToOtherTxt");
         addToContent(this._sendToOtherTxt);
         this._sendToOtherTxt.maxChars = 100;
         if(this._useType == 0)
         {
            this._sendToOtherTxt.text = LanguageMgr.GetTranslation("game.vipCoupons.vipSendFrame.sendToOther");
            titleText = LanguageMgr.GetTranslation("game.vipCoupons.sendVip.titleTxt");
         }
         else
         {
            this._sendToOtherTxt.text = LanguageMgr.GetTranslation("tank.ddtkingCoupons.sendToOther");
            titleText = LanguageMgr.GetTranslation("tank.ddtkingCoupons.send.titleTxt");
         }
         this._vipCell = this.createBagCell(this._itemID);
         this._vipCell.x = 46;
         this._vipCell.y = 379;
         this._vipCell.setCount(this.getItemCount(this._itemID));
         addToContent(this._vipCell);
      }
      
      private function getItemCount(param1:int) : int
      {
         return PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(param1);
      }
      
      private function createBagCell(param1:int) : BagCell
      {
         var _loc3_:BagCell = null;
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         _loc2_ = ItemManager.fill(_loc2_);
         _loc2_.IsBinds = true;
         _loc3_ = new BagCell(0);
         _loc3_.info = _loc2_;
         _loc3_.setBgVisible(false);
         return _loc3_;
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._nameInput))
         {
            this._nameInput.addEventListener("change",this.__onReceiverChange);
         }
         addEventListener("response",this._responseHandle);
         StageReferance.stage.addEventListener("click",this.__hideDropList);
         this._sendBtn.addEventListener("click",this.__sendHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._nameInput))
         {
            this._nameInput.removeEventListener("change",this.__onReceiverChange);
         }
         removeEventListener("response",this._responseHandle);
         StageReferance.stage.removeEventListener("click",this.__hideDropList);
         this._sendBtn.removeEventListener("click",this.__sendHandler);
      }
      
      protected function __sendHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:String = this._nameInput.text;
         if(_loc2_ == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.nameInputTxt"));
            return;
         }
         var _loc3_:int = 0;
         _loc3_ = this.getItemCount(this._itemID);
         if(_loc3_ <= 0)
         {
            if(this._useType == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.vipCoupons.sendVip.vipCouponsCount"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.ddtkingCoupons.sendCouponsCount"));
            }
            return;
         }
         var _loc4_:String = this._sendToOtherTxt.text;
         _loc4_ = StringHelper.trim(_loc4_);
         _loc4_ = FilterWordManager.filterWrod(_loc4_);
         _loc4_ = StringHelper.rePlaceHtmlTextField(_loc4_);
         SocketManager.Instance.out.sendVipCoupons(this._bagType,this._place,1,_loc4_,_loc2_);
         this.dispose();
      }
      
      protected function __hideDropList(param1:Event) : void
      {
         if(param1.target is FilterFrameText && param1.target != this._sendToOtherTxt)
         {
            return;
         }
         if(Boolean(this._dropList) && Boolean(this._dropList.parent))
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
         }
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
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._contenBg))
         {
            ObjectUtils.disposeObject(this._contenBg);
         }
         this._contenBg = null;
         if(Boolean(this._sendBtn))
         {
            ObjectUtils.disposeObject(this._sendBtn);
         }
         this._sendBtn = null;
         if(Boolean(this._vipCell))
         {
            ObjectUtils.disposeObject(this._vipCell);
         }
         this._vipCell = null;
         if(Boolean(this._sendToOtherTxt))
         {
            ObjectUtils.disposeObject(this._sendToOtherTxt);
         }
         this._sendToOtherTxt = null;
         if(Boolean(this._nameInput))
         {
            ObjectUtils.disposeObject(this._nameInput);
         }
         this._nameInput = null;
         if(Boolean(this._dropList))
         {
            this._dropList.removeChildren();
         }
         this._dropList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

