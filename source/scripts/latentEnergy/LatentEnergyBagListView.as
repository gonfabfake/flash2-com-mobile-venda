package latentEnergy
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.interfaces.ICell;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class LatentEnergyBagListView extends BagListView
   {
      
      private var _autoExpandV:Boolean;
      
      public function LatentEnergyBagListView(param1:int, param2:int = 7, param3:int = 49, param4:Boolean = false)
      {
         this._autoExpandV = param4;
         super(param1,param2,param3);
         if(param1 == BagInfo.EQUIPBAG)
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         }
         else
         {
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
            LatentEnergyManager.instance.addEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         }
      }
      
      override protected function createCells() : void
      {
         _cells = new Dictionary();
         _cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
         var _loc1_:int = 0;
         while(_loc1_ < _cellNum)
         {
            this.addCell(_loc1_);
            _loc1_++;
         }
      }
      
      private function addCell(param1:int) : void
      {
         var _loc2_:LatentEnergyEquipListCell = this.createBagCell(param1);
         _loc2_.mouseOverEffBoolean = false;
         addChild(_loc2_);
         _loc2_.bagType = _bagType;
         _loc2_.addEventListener(InteractiveEvent.CLICK,__clickHandler);
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,_cellOverEff);
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,_cellOutEff);
         _loc2_.addEventListener(InteractiveEvent.DOUBLE_CLICK,__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(_loc2_);
         _loc2_.addEventListener(CellEvent.LOCK_CHANGED,__cellChanged);
         _cells[_loc2_.place] = _loc2_;
         _cellVec.push(_loc2_);
      }
      
      private function createBagCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true) : LatentEnergyEquipListCell
      {
         var _loc4_:LatentEnergyEquipListCell = new LatentEnergyEquipListCell(param1,param2,param3);
         this.fillTipProp(_loc4_);
         return _loc4_;
      }
      
      private function fillTipProp(param1:ICell) : void
      {
         param1.tipDirctions = "7,6,2,1,5,4,0,3,6";
         param1.tipGapV = 10;
         param1.tipGapH = 10;
         param1.tipStyle = "core.GoodsTip";
      }
      
      private function equipMoveHandler(param1:LatentEnergyEvent) : void
      {
         var _loc2_:InventoryItemInfo = param1.info;
         var _loc3_:int = 0;
         while(_loc3_ < _cellNum)
         {
            if(_cells[_loc3_].info == _loc2_)
            {
               _cells[_loc3_].info = null;
               break;
            }
            _loc3_++;
         }
      }
      
      private function equipMoveHandler2(param1:LatentEnergyEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = param1.info;
         if(param1.moveType == 2)
         {
            for each(_loc2_ in _cells)
            {
               if(_loc2_.info == _loc3_)
               {
                  return;
               }
            }
         }
         var _loc4_:int = 0;
         while(_loc4_ < _cellNum)
         {
            if(!_cells[_loc4_].info)
            {
               _cells[_loc4_].info = _loc3_;
               break;
            }
            _loc4_++;
         }
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(_bagdata == param1)
         {
            return;
         }
         if(_bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,__updateGoods);
         }
         clearDataCells();
         _bagdata = param1;
         if(this.autoExpandV && _cellVec.length < _bagdata.items.length)
         {
            _loc3_ = _bagdata.items.length - _cellVec.length;
            _loc4_ = int(_cellVec.length);
            _loc5_ = 0;
            if(_bagdata.items.length % 7 > 0)
            {
               _loc5_ = 7 - _bagdata.items.length % 7;
            }
            _loc6_ = _loc4_;
            while(_loc6_ < _loc4_ + _loc3_ + _loc5_)
            {
               this.addCell(_loc6_);
               _loc6_++;
            }
            _cellNum = _cellVec.length;
         }
         var _loc7_:int = 0;
         for(_loc2_ in _bagdata.items)
         {
            if(_cells[_loc7_] != null)
            {
               _bagdata.items[_loc2_].isMoveSpace = true;
               _cells[_loc7_].info = _bagdata.items[_loc2_];
            }
            _loc7_++;
         }
         _bagdata.addEventListener(BagEvent.UPDATE,__updateGoods);
      }
      
      public function get autoExpandV() : Boolean
      {
         return this._autoExpandV;
      }
      
      public function set autoExpandV(param1:Boolean) : void
      {
         this._autoExpandV = param1;
      }
      
      override public function dispose() : void
      {
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.EQUIP_MOVE2,this.equipMoveHandler2);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE,this.equipMoveHandler);
         LatentEnergyManager.instance.removeEventListener(LatentEnergyManager.ITEM_MOVE2,this.equipMoveHandler2);
         super.dispose();
      }
   }
}

