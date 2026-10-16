package magicHouse.magicBox
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class MagicBoxFusionItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _name:FilterFrameText;
      
      private var _shine:Bitmap;
      
      private var _cell:BagCell;
      
      private var _info:MagicBoxItemInfo;
      
      public function MagicBoxFusionItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.itemselected.bg");
         addChild(this._bg);
         this._name = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.itemnameTxt");
         addChild(this._name);
         this._shine = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.itemselected.shine");
         this._shine.visible = false;
         addChild(this._shine);
      }
      
      public function setItemData(param1:MagicBoxItemInfo) : void
      {
         this._info = param1;
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._info.ItemID);
         this._cell = new BagCell(0,_loc2_,true,ComponentFactory.Instance.creatBitmap("magichouse.magicbox.itemselectedcell.bg"));
         addChild(this._cell);
         this._cell.width = this._cell.height = 52;
         PositionUtils.setPos(this._cell,"magicbox.fusionview.itemcellPos");
         this._cell.PicPos = new Point(2,2);
         this._name.text = _loc2_.Name;
      }
      
      public function setItemShine(param1:Boolean) : void
      {
         this._shine.visible = param1;
      }
      
      public function get info() : MagicBoxItemInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._shine))
         {
            ObjectUtils.disposeObject(this._shine);
         }
         this._shine = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
      }
   }
}

