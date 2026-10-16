package BraveDoor.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class BraveDoorDropList extends Sprite implements Disposeable
   {
      
      protected var _scrollPanel:ScrollPanel;
      
      protected var _list:SimpleTileList;
      
      protected var _cells:Array;
      
      protected var _scrollPanelRect:Rectangle;
      
      protected var _columnNum:int = 5;
      
      protected var _listHSpace:int = 4;
      
      protected var _listVSpace:int = 5;
      
      public function BraveDoorDropList()
      {
         super();
         this._cells = [];
         this.initView();
      }
      
      protected function initView() : void
      {
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateMapRoom.dropListPanel");
         this._scrollPanel.vScrollProxy = 0;
         this._scrollPanel.hScrollProxy = 2;
         addChild(this._scrollPanel);
         this._scrollPanel.visible = false;
         this._scrollPanelRect = ComponentFactory.Instance.creatCustomObject("braveDoor.duplicateMapView.dropList.scrollPanelRect");
         this._list = new SimpleTileList(this._columnNum);
         this._list.hSpace = this._listHSpace;
         this._list.vSpace = this._listVSpace;
      }
      
      public function set info(param1:Array) : void
      {
         var _loc6_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         while(this._cells.length > 0)
         {
            _loc2_ = this._cells.shift();
            _loc2_.dispose();
         }
         if(param1.length > 0)
         {
            if(!this._scrollPanel.visible)
            {
               this._scrollPanel.visible = true;
            }
            _loc3_ = ComponentFactory.Instance.creatCustomObject("braveDoor.duplicateMapView.dropList.scrollPanelRect");
            for each(_loc6_ in param1)
            {
               _loc4_ = ItemManager.Instance.getTemplateById(_loc6_);
               _loc5_ = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.braveDoor.dropCellBgAsset"),_loc4_);
               this._list.addChild(_loc5_);
               this._cells.push(_loc5_);
            }
            this._scrollPanel.setView(this._list);
            this._scrollPanel.height = this._scrollPanelRect.width;
            this._scrollPanel.invalidateViewport();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         this._scrollPanelRect = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         while(this._cells.length > 0)
         {
            _loc1_ = this._cells.shift();
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cells = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

