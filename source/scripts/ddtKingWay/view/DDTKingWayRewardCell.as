package ddtKingWay.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Sprite;
   
   public class DDTKingWayRewardCell extends Sprite implements Disposeable
   {
      
      private var _item:Image;
      
      private var _cell:BagCell;
      
      public function DDTKingWayRewardCell()
      {
         super();
         this._item = ComponentFactory.Instance.creatComponentByStylename("ddtKingWay.receiveItem");
         this._cell = new BagCell(0);
         addChild(this._cell);
         addChild(this._item);
      }
      
      public function set showitem(param1:Boolean) : void
      {
         this._item.visible = param1;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._cell.info = param1;
      }
      
      public function setCount(param1:*) : void
      {
         this._cell.setCount(param1);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._item);
         ObjectUtils.disposeObject(this._cell);
         this._item = null;
         this._cell = null;
      }
   }
}

