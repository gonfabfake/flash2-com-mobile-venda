package BombTurnTable.view
{
   import BombTurnTable.data.BombTurnTableGoodInfo;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TurnTableGoodCell extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _temID:int;
      
      private var _state:int;
      
      private var _quality:int;
      
      private var _bg:Bitmap;
      
      private var _cell:BagCell;
      
      private var _info:BombTurnTableGoodInfo;
      
      protected var _selectMc:MovieClip;
      
      private var _goodCount:FilterFrameText;
      
      private var _icon:Bitmap;
      
      public function TurnTableGoodCell(param1:BombTurnTableGoodInfo, param2:int)
      {
         this._info = param1;
         this._index = param1.place;
         this._temID = param1.templateId;
         this._state = param1.isReceive;
         this._quality = param2;
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         if(this._temID > 0)
         {
            this.createGoodView();
         }
         else
         {
            this.createSpecialGoodView();
         }
      }
      
      protected function createGoodView() : void
      {
         var _loc1_:int = 0;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.bombTurnTable.goodbg.quality" + this._quality);
         addChild(this._bg);
         this._cell = this.createCell();
         addChild(this._cell);
         this._goodCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         this._goodCount.mouseEnabled = false;
         this._goodCount.rotationZ = 0;
         this._goodCount.x = 51;
         this._goodCount.y = 41;
         addChild(this._goodCount);
         if(Boolean(this._cell))
         {
            _loc1_ = this._cell.itemInfo.Count;
            if(_loc1_ > 1)
            {
               this._goodCount.text = _loc1_.toString();
            }
         }
      }
      
      protected function createSpecialGoodView() : void
      {
         if(this._temID == -1)
         {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.bombTurnTable.upgrade");
            this._icon.smoothing = true;
         }
         else if(this._temID == -2)
         {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.bombTurnTable.degrade");
            this._icon.smoothing = true;
         }
         addChild(this._icon);
      }
      
      protected function createCell() : BagCell
      {
         var _loc1_:InventoryItemInfo = new InventoryItemInfo();
         _loc1_.TemplateID = this._temID;
         _loc1_.IsBinds = true;
         _loc1_.Count = this._info.goodCount;
         _loc1_ = ItemManager.fill(_loc1_);
         _loc1_.BindType = 4;
         var _loc2_:BagCell = new BagCell(0,_loc1_,true);
         _loc2_.setBgVisible(false);
         _loc2_.setContentSize(57,57);
         _loc2_.setCountNotVisible();
         return _loc2_;
      }
      
      public function get info() : BombTurnTableGoodInfo
      {
         return this._info;
      }
      
      public function getGoodName() : String
      {
         if(Boolean(this._cell))
         {
            return this._cell.info.Name;
         }
         return "";
      }
      
      public function place() : int
      {
         return this._index;
      }
      
      public function dispose() : void
      {
         this._index = 0;
         this._temID = 0;
         this._state = 0;
         this._quality = 0;
         this._info = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
         }
         this._icon = null;
         if(Boolean(this._cell))
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(Boolean(this._selectMc))
         {
            ObjectUtils.disposeObject(this._selectMc);
         }
         this._selectMc = null;
         if(Boolean(this._goodCount))
         {
            ObjectUtils.disposeObject(this._goodCount);
         }
         this._goodCount = null;
      }
   }
}

