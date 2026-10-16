package email.view
{
   import auctionHouse.view.AuctionBagEquipListView;
   import auctionHouse.view.AuctionBagListView;
   import bagAndInfo.bag.BagView;
   import bagAndInfo.cell.BagCell;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CellEvent;
   import ddt.manager.SoundManager;
   
   public class EmailBagView extends BagView
   {
      
      public function EmailBagView()
      {
         super();
      }
      
      override protected function initBagList() : void
      {
         _equiplist = new AuctionBagEquipListView(0);
         _proplist = new AuctionBagListView(1);
         _equiplist.x = _proplist.x = 14;
         _equiplist.y = _proplist.y = 54;
         _equiplist.width = _proplist.width = 330;
         _equiplist.height = _proplist.height = 320;
         _proplist.visible = false;
         _lists = [_equiplist,_proplist];
         _currentList = _equiplist;
         addChild(_equiplist);
         addChild(_proplist);
      }
      
      override protected function adjustEvent() : void
      {
      }
      
      override protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               _loc2_.dragStart();
            }
         }
      }
   }
}

