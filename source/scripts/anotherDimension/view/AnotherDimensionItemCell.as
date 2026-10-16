package anotherDimension.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import shop.manager.ShopBuyManager;
   
   public class AnotherDimensionItemCell extends Sprite implements Disposeable
   {
      
      private var _itemCell:BagCell;
      
      private var _buyImage:Bitmap;
      
      private var _itemId:int = 10620;
      
      private var _countVisible:Boolean = true;
      
      public function AnotherDimensionItemCell()
      {
         super();
         this.buttonMode = true;
         this._itemId = ServerConfigManager.instance.getLevelUpItemID();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("anotherDimension.itemBg");
         this._itemCell = new BagCell(1,ItemManager.Instance.getTemplateById(this._itemId),true,_loc1_,false);
         this._itemCell.PicPos = new Point(9,9);
         this._itemCell.setContentSize(53,53);
         addChild(this._itemCell);
         this.updateItemCellCount();
         this._buyImage = ComponentFactory.Instance.creatBitmap("anotherDimension.buyTip");
         addChild(this._buyImage);
         this._buyImage.alpha = 0;
      }
      
      private function updateItemCellCount() : void
      {
         this._itemCell.setCount(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(this._itemId));
         this._itemCell.refreshTbxPos();
      }
      
      private function initEvent() : void
      {
         addEventListener("click",this.clickHandler,false,0,true);
         addEventListener("mouseOver",this.overHandler,false,0,true);
         addEventListener("mouseOut",this.outHandler,false,0,true);
         if(this._countVisible)
         {
            PlayerManager.Instance.Self.PropBag.addEventListener("update",this.itemUpdateHandler);
         }
      }
      
      private function itemUpdateHandler(param1:BagEvent) : void
      {
         this.updateItemCellCount();
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         ShopBuyManager.Instance.buy(this._itemId,1,-1);
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         TweenLite.to(this._buyImage,0.25,{"alpha":1});
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         TweenLite.to(this._buyImage,0.25,{"alpha":0});
      }
      
      private function removeEvent() : void
      {
         removeEventListener("click",this.clickHandler);
         removeEventListener("mouseOver",this.overHandler);
         removeEventListener("mouseOut",this.outHandler);
         PlayerManager.Instance.Self.PropBag.removeEventListener("update",this.itemUpdateHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._itemCell = null;
         this._buyImage = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get itemCell() : BagCell
      {
         return this._itemCell;
      }
   }
}

