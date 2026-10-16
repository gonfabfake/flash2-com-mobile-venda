package sanXiao.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.pageSelector.IPageItem;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sanXiao.SanXiaoManager;
   import sanXiao.model.SXStoreItemData;
   
   public class SXStoreItem extends Sprite implements Disposeable, IPageItem
   {
      
      private var _bg:Bitmap;
      
      private var _bagCell:BagCell;
      
      private var _titleTxt:FilterFrameText;
      
      private var _priceIcon:Bitmap;
      
      private var _priceText:FilterFrameText;
      
      private var _exchangeBtn:SimpleBitmapButton;
      
      private var _data:SXStoreItemData;
      
      public function SXStoreItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("ast.sanxiao.storeBG");
         addChild(this._bg);
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,66,66);
         _loc1_.graphics.endFill();
         this._bagCell = new BagCell(0,null,true,_loc1_);
         this._bagCell.width = 66;
         this._bagCell.height = 66;
         this._bagCell.tbxCount.scaleX = 1 / this._bagCell.scaleX;
         this._bagCell.tbxCount.scaleY = 1 / this._bagCell.scaleY;
         PositionUtils.setPos(this._bagCell.tbxCount,"sanxiao.itemCount");
         PositionUtils.setPos(this._bagCell,"sanxiao.storeItemBagCell.pt");
         addChild(this._bagCell);
         this._titleTxt = ComponentFactory.Instance.creat("sanxiao.storeItemTitle14.Txt");
         PositionUtils.setPos(this._titleTxt,"sanxiao.storeItemTitle.pt");
         addChild(this._titleTxt);
         this._priceIcon = ComponentFactory.Instance.creatBitmap("ast.sanxiao.crystal");
         PositionUtils.setPos(this._priceIcon,"sanxiao.storeItemIcon.pt");
         addChild(this._priceIcon);
         this._priceText = ComponentFactory.Instance.creat("sanxiao.storeItemPrice.Txt");
         PositionUtils.setPos(this._priceText,"sanxiao.storeItemPrice.pt");
         addChild(this._priceText);
         this._exchangeBtn = ComponentFactory.Instance.creat("sanxiao.exchange.btn");
         addChild(this._exchangeBtn);
         this._exchangeBtn.addEventListener("click",this.onExchangeClick);
      }
      
      protected function onExchangeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._data == null)
         {
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(SanXiaoManager.getInstance().crystalNum < int(this._priceText.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("sanxiao.crystalNotEnough"),0,true,1);
            return;
         }
         var _loc2_:SXShopBuyView = ComponentFactory.Instance.creatComponentByStylename("sanxiao.QuickBuyAlert");
         _loc2_.setData(this._data.TempleteID,this._data.TempleteID,this._data.price);
         _loc2_.setID(this._data.id);
         _loc2_.setBuyNum(this._data.remain);
         LayerManager.Instance.addToLayer(_loc2_,2,true,1);
      }
      
      public function updateItem(param1:Object = null) : void
      {
         if(param1 == null)
         {
            this._bagCell.info = null;
            this._priceText.text = "";
            this._titleTxt.text = "";
            this._priceIcon.visible = false;
            this._exchangeBtn.visible = false;
            return;
         }
         this._data = param1 as SXStoreItemData;
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc2_,ItemManager.Instance.getTemplateById(this._data.TempleteID));
         _loc2_.ValidDate = this._data.Valid;
         _loc2_.IsBinds = this._data.isBind;
         _loc2_.Count = this._data.count;
         _loc2_.Property5 = "1";
         this._bagCell.info = _loc2_;
         if(Boolean(this._bagCell.info))
         {
            this._titleTxt.text = this._bagCell.info.Name + "(" + this._data.remain + "/" + this._data.total + ")";
         }
         this._bagCell.setCount(_loc2_.Count);
         this._priceText.text = this._data.price.toString();
         this._exchangeBtn.enable = this._data.remain >= 1;
         this._priceIcon.visible = true;
         this._exchangeBtn.visible = true;
      }
      
      public function getID() : int
      {
         return this._bagCell.info ? this._bagCell.info.TemplateID : 0;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._exchangeBtn))
         {
            this._exchangeBtn.addEventListener("click",this.onExchangeClick);
         }
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._bagCell = null;
         this._titleTxt = null;
         this._priceIcon = null;
         this._priceText = null;
         this._exchangeBtn = null;
      }
   }
}

