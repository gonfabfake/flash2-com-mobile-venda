package flowerGiving.components
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class FlowerSendFrameItem extends Sprite implements Disposeable
   {
      
      private var _selectBtn:SelectedCheckButton;
      
      private var _sendTxt:FilterFrameText;
      
      private var _sendNumTxt:FilterFrameText;
      
      private var _canGetTxt:FilterFrameText;
      
      private var _shineBit:Bitmap;
      
      private var _giftData:GiftBagInfo;
      
      private var _sendBagCell:BagCell;
      
      private var _getIconSp:Sprite;
      
      private var _getIcon:Image;
      
      private var _baseTip:GoodTipInfo;
      
      public function FlowerSendFrameItem(param1:GiftBagInfo)
      {
         this._giftData = param1;
         super();
         this.initView();
         this.initViewWithData();
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         this._selectBtn.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      protected function __clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.updateShine();
      }
      
      private function initView() : void
      {
         this._selectBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.selectedBtn");
         addChild(this._selectBtn);
         this._sendTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt");
         addChild(this._sendTxt);
         PositionUtils.setPos(this._sendTxt,"flowerGiving.flowerSendFrame.sendPos");
         this._sendTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.sendTxt");
         this._sendNumTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt");
         addChild(this._sendNumTxt);
         PositionUtils.setPos(this._sendNumTxt,"flowerGiving.flowerSendFrame.sendNumPos");
         this._canGetTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendFrame.sendTxt");
         addChild(this._canGetTxt);
         PositionUtils.setPos(this._canGetTxt,"flowerGiving.flowerSendFrame.canGetPos");
         this._canGetTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.cenGetTxt");
         this._getIconSp = new Sprite();
         this._getIcon = ComponentFactory.Instance.creatComponentByStylename("flowerSendFrame.rewardIcon");
         this._getIcon.scaleX = this._getIcon.scaleY = 0.58;
         PositionUtils.setPos(this._getIcon,"flowerGiving.flowerSendFrame.getIconPos");
         this._getIconSp.addChild(this._getIcon);
         addChild(this._getIconSp);
         this._shineBit = ComponentFactory.Instance.creat("flowerGiving.flowerSendFrame.mouseOver");
         addChild(this._shineBit);
         this.updateShine();
      }
      
      private function initViewWithData() : void
      {
         var _loc1_:GiftRewardInfo = null;
         var _loc2_:InventoryItemInfo = null;
         this._sendNumTxt.text = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.sendNumTxt",this._giftData.giftConditionArr[0].conditionValue);
         this._sendBagCell = this.createBagCell(FlowerGivingManager.instance.flowerTempleteId);
         addChild(this._sendBagCell);
         this._sendBagCell.setCountNotVisible();
         PositionUtils.setPos(this._sendBagCell,"flowerGiving.flowerSendFrame.sendBagCell");
         this._baseTip = new GoodTipInfo();
         var _loc3_:ItemTemplateInfo = new ItemTemplateInfo();
         _loc3_.Quality = 4;
         _loc3_.CategoryID = 11;
         _loc3_.Name = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.getGiftPackName" + (this._giftData.giftbagOrder + 1));
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < this._giftData.giftRewardArr.length)
         {
            _loc1_ = this._giftData.giftRewardArr[_loc5_];
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = _loc1_.templateId;
            ItemManager.fill(_loc2_);
            if(_loc4_ != "")
            {
               _loc4_ += "、";
            }
            _loc4_ += _loc2_.Name + "x" + _loc1_.count;
            _loc5_++;
         }
         _loc3_.Description = LanguageMgr.GetTranslation("flowerGiving.flowerSendFrame.getGiftPackContent") + _loc4_;
         this._baseTip.itemInfo = _loc3_;
         this._getIcon.tipStyle = "core.GoodsTip";
         this._getIcon.tipDirctions = "1,3";
         this._getIcon.tipData = this._baseTip;
      }
      
      private function createBagCell(param1:int) : BagCell
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         _loc2_ = ItemManager.fill(_loc2_);
         _loc2_.BindType = 4;
         var _loc3_:BagCell = new BagCell(0);
         _loc3_.info = _loc2_;
         _loc3_.setBgVisible(false);
         return _loc3_;
      }
      
      private function removeEvent() : void
      {
         this._selectBtn.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      public function updateShine() : void
      {
         this._shineBit.visible = this._selectBtn.selected;
      }
      
      public function get selectBtn() : SelectedCheckButton
      {
         return this._selectBtn;
      }
      
      public function set selectBtn(param1:SelectedCheckButton) : void
      {
         this._selectBtn = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._getIcon);
         ObjectUtils.disposeAllChildren(this);
         this._getIcon = null;
         this._getIconSp = null;
         this._selectBtn = null;
         this._sendTxt = null;
         this._sendNumTxt = null;
         this._canGetTxt = null;
         this._shineBit = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

