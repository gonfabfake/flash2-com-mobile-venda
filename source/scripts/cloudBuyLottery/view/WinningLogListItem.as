package cloudBuyLottery.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import shop.view.ShopItemCell;
   
   public class WinningLogListItem extends Sprite implements Disposeable
   {
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:WinningLogItemInfo;
      
      private var _itemID:int;
      
      private var _bg:Bitmap;
      
      private var _cellImg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _txt:FilterFrameText;
      
      public function WinningLogListItem()
      {
         super();
      }
      
      public function initView(param1:String, param2:int = 0) : void
      {
         if(++param2 % 2 == 0)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.cellBg");
            addChild(this._bg);
         }
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("WinningLogListItem.nameTxt");
         this._nameTxt.text = param1;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("WinningLogListItem.txt");
         this._txt.text = LanguageMgr.GetTranslation("WinningLogListItem.txt.LG");
         this._cellImg = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.goodsCell");
         this._itemCell = this.creatItemCell();
         this._itemCell.buttonMode = true;
         this._itemCell.cellSize = 46;
         PositionUtils.setPos(this._itemCell,"WinningLogListItem.cellPos");
         addChild(this._cellImg);
         addChild(this._itemCell);
         addChild(this._nameTxt);
         addChild(this._txt);
      }
      
      protected function creatItemCell() : ShopItemCell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,46,46);
         _loc1_.graphics.endFill();
         return CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
      }
      
      public function set shopItemInfo(param1:WinningLogItemInfo) : void
      {
         var _loc2_:InventoryItemInfo = null;
         if(Boolean(this._shopItemInfo))
         {
            this._shopItemInfo.removeEventListener(Event.CHANGE,this.__updateShopItem);
         }
         this._shopItemInfo = param1;
         if(Boolean(this._shopItemInfo))
         {
            _loc2_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc2_,this._shopItemInfo.TemplateInfo);
            _loc2_.ValidDate = this._shopItemInfo.validate;
            _loc2_.StrengthenLevel = this._shopItemInfo.property[0];
            _loc2_.AttackCompose = this._shopItemInfo.property[1];
            _loc2_.DefendCompose = this._shopItemInfo.property[2];
            _loc2_.LuckCompose = this._shopItemInfo.property[3];
            _loc2_.AgilityCompose = this._shopItemInfo.property[4];
            _loc2_.IsBinds = this._shopItemInfo.property[5] == 1;
            this._itemID = this._shopItemInfo.TemplateID;
            this._itemCell.info = _loc2_;
            this._itemCell.buttonMode = true;
            this._shopItemInfo.addEventListener(Event.CHANGE,this.__updateShopItem);
         }
         else
         {
            this._itemCell.info = null;
            this._itemCell.buttonMode = false;
         }
      }
      
      private function __updateShopItem(param1:Event) : void
      {
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
      }
      
      public function get itemID() : int
      {
         return this._itemID;
      }
      
      public function set itemID(param1:int) : void
      {
         this._itemID = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         this._shopItemInfo = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

