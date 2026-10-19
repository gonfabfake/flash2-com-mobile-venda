package flowerGiving.components
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class FlowerSendRewardItem extends Sprite implements Disposeable
   {
      
      private var _itemIndex:int;
      
      private var _back:Bitmap;
      
      private var _backOverBit:Bitmap;
      
      private var _contentTxt:FilterFrameText;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _haveGot:Bitmap;
      
      private var _hBox:HBox;
      
      private var index:int;
      
      public var num:int;
      
      public function FlowerSendRewardItem(param1:int)
      {
         super();
         this.index = param1;
         this._itemIndex = param1 % 2 == 0 ? int(2) : int(1);
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("flowerGiving.accumuGivingItem" + this._itemIndex);
         addChild(this._back);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.contentTxt");
         addChild(this._contentTxt);
         this._contentTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendRewardView.desc");
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.getbtn");
         addChild(this._getBtn);
         this._hBox = ComponentFactory.Instance.creatComponentByStylename("flowerSendView.hBox");
         addChild(this._hBox);
         this._backOverBit = ComponentFactory.Instance.creat("flowerGiving.accumuGivingMouseOver");
         addChild(this._backOverBit);
         this._backOverBit.visible = false;
         this._haveGot = ComponentFactory.Instance.creat("flowerGiving.haveGot");
         addChild(this._haveGot);
         this._haveGot.visible = false;
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         addEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
         this._getBtn.addEventListener(MouseEvent.CLICK,this.__clickHanlder);
      }
      
      protected function __clickHanlder(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGetFlowerReward(2,this.index);
      }
      
      protected function __onOutHandler(param1:MouseEvent) : void
      {
         this._backOverBit.visible = false;
      }
      
      protected function __onOverHanlder(param1:MouseEvent) : void
      {
         this._backOverBit.visible = true;
      }
      
      public function set info(param1:GiftBagInfo) : void
      {
         var _loc2_:GiftRewardInfo = null;
         _loc2_ = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Array = null;
         var _loc5_:BagCell = null;
         this.num = param1.giftConditionArr[0].conditionValue;
         this._contentTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendRewardView.desc",this.num);
         var _loc6_:int = 0;
         while(_loc6_ <= param1.giftRewardArr.length - 1)
         {
            _loc2_ = param1.giftRewardArr[_loc6_];
            _loc3_ = new InventoryItemInfo();
            _loc3_.TemplateID = _loc2_.templateId;
            ItemManager.fill(_loc3_);
            _loc3_.IsBinds = _loc2_.isBind;
            _loc3_.ValidDate = _loc2_.validDate;
            _loc4_ = _loc2_.property.split(",");
            _loc3_._StrengthenLevel = parseInt(_loc4_[0]);
            _loc3_.AttackCompose = parseInt(_loc4_[1]);
            _loc3_.DefendCompose = parseInt(_loc4_[2]);
            _loc3_.AgilityCompose = parseInt(_loc4_[3]);
            _loc3_.LuckCompose = parseInt(_loc4_[4]);
            _loc5_ = new BagCell(0);
            _loc5_.info = _loc3_;
            _loc5_.setCount(_loc2_.count);
            _loc5_.setBgVisible(false);
            this._hBox.addChild(_loc5_);
            _loc6_++;
         }
      }
      
      public function setBtnEnable(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this._getBtn.enable = false;
               this._haveGot.visible = false;
               break;
            case 1:
               this._getBtn.enable = true;
               this._haveGot.visible = false;
               break;
            case 2:
               this._getBtn.enable = false;
               this._haveGot.visible = true;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__onOverHanlder);
         removeEventListener(MouseEvent.ROLL_OUT,this.__onOutHandler);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this.__clickHanlder);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._back))
         {
            ObjectUtils.disposeObject(this._back);
         }
         this._back = null;
         if(Boolean(this._backOverBit))
         {
            ObjectUtils.disposeObject(this._backOverBit);
         }
         this._backOverBit = null;
         if(Boolean(this._contentTxt))
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         if(Boolean(this._getBtn))
         {
            ObjectUtils.disposeObject(this._getBtn);
         }
         this._getBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

