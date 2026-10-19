package auctionHouse.view
{
   import bagAndInfo.bag.BagEquipListView;
   import bagAndInfo.cell.BagCell;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class AuctionBagEquipListView extends BagEquipListView
   {
      
      public function AuctionBagEquipListView(param1:int, param2:int = 31, param3:int = 80, param4:int = 7, param5:int = 1)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function setData(param1:BagInfo) : void
      {
         var _loc2_:Boolean = _bagdata == param1;
         var _loc3_:* = null;
         if(!_loc2_ && _bagdata != null)
         {
            _bagdata.removeEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         _bagdata = param1;
         var _loc4_:Array = new Array();
         for(_loc3_ in _bagdata.items)
         {
            if(_cells[_loc3_] != null && _bagdata.items[_loc3_].IsBinds == false)
            {
               _cells[_loc3_].info = _bagdata.items[_loc3_];
               _loc4_.push(_cells[_loc3_]);
            }
         }
         if(!_loc2_)
         {
            _bagdata.addEventListener(BagEvent.UPDATE,this.__updateGoods);
         }
         this._cellsSort(_loc4_);
      }
      
      override protected function __updateGoods(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Dictionary = param1.changedSlots;
         for each(_loc2_ in _loc4_)
         {
            _loc3_ = _bagdata.getItemAt(_loc2_.Place);
            if(Boolean(_loc3_) && _loc3_.IsBinds == false)
            {
               setCellInfo(_loc3_.Place,_loc3_);
            }
            else
            {
               setCellInfo(_loc2_.Place,null);
            }
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function _cellsSort(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:BagCell = null;
         _loc2_ = 0;
         var _loc3_:Number = NaN;
         _loc4_ = NaN;
         _loc5_ = 0;
         _loc6_ = null;
         if(param1.length <= 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = Number(param1[_loc2_].x);
            _loc4_ = Number(param1[_loc2_].y);
            _loc5_ = _cellVec.indexOf(param1[_loc2_]);
            _loc6_ = _cellVec[_loc2_];
            param1[_loc2_].x = _loc6_.x;
            param1[_loc2_].y = _loc6_.y;
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            _cellVec[_loc2_] = param1[_loc2_];
            _cellVec[_loc5_] = _loc6_;
            _loc2_++;
         }
      }
   }
}

