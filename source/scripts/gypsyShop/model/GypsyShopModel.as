package gypsyShop.model
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.GypsyShopEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import gypsyShop.I.IGypsyShopViewModel;
   import gypsyShop.ctrl.GypsyShopManager;
   
   public class GypsyShopModel extends EventDispatcher implements IGypsyShopViewModel
   {
      
      private static var instance:GypsyShopModel;
      
      private var _curRefreshedTimes:int;
      
      private var _itemCount:int;
      
      private var _itemDataList:Vector.<GypsyItemData>;
      
      private var _buyResult:Object;
      
      private var _listRareItemTempleteIDs:Vector.<int>;
      
      public function GypsyShopModel(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : GypsyShopModel
      {
         if(!instance)
         {
            instance = new GypsyShopModel(new inner());
         }
         return instance;
      }
      
      public function requestManualRefreshList() : void
      {
         GameInSocketOut.sendGypsyManualRefreshItemList();
      }
      
      public function requestBuyItem(param1:int) : void
      {
         GameInSocketOut.sendGypsyBuy(param1,GypsyPurchaseModel.getInstance().getUseBind());
      }
      
      public function requestRareList() : void
      {
         GameInSocketOut.sendGypsyRefreshRareList();
      }
      
      public function requestRefreshList() : void
      {
         GameInSocketOut.sendGypsyRefreshItemList();
      }
      
      public function init() : void
      {
         SocketManager.Instance.addEventListener(GypsyShopEvent.GOT_NEW_ITEM_LIST,this.onItemListUpdated);
         SocketManager.Instance.addEventListener(GypsyShopEvent.ON_BUY_RESULT,this.onBuyResult);
         SocketManager.Instance.addEventListener(GypsyShopEvent.ON_RARE_ITEM_UPDATED,this.onRareItemListUpdated);
      }
      
      protected function onRareItemListUpdated(param1:GypsyShopEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = param1.data;
         var _loc4_:int = _loc3_.readInt();
         this._listRareItemTempleteIDs = new Vector.<int>();
         while(Boolean(_loc3_.bytesAvailable))
         {
            _loc2_ = _loc3_.readInt();
            this._listRareItemTempleteIDs.push(_loc2_);
         }
         GypsyShopManager.getInstance().newRareItemsUpdate();
      }
      
      protected function onBuyResult(param1:GypsyShopEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = param1.data;
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:Boolean = _loc3_.readBoolean();
         this._buyResult = null;
         if(_loc5_)
         {
            _loc2_ = _loc3_.readInt();
            this._buyResult = {
               "id":_loc4_,
               "canBuy":_loc2_
            };
            GypsyShopManager.getInstance().updateBuyResult();
         }
      }
      
      protected function onItemListUpdated(param1:GypsyShopEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ByteArray = param1.data;
         this._curRefreshedTimes = _loc9_.readInt();
         this._itemCount = _loc9_.readInt();
         this._itemDataList = new Vector.<GypsyItemData>();
         while(_loc9_.bytesAvailable > 0)
         {
            _loc2_ = _loc9_.readInt();
            _loc3_ = _loc9_.readInt();
            _loc4_ = _loc9_.readInt();
            _loc5_ = _loc9_.readInt();
            _loc6_ = _loc9_.readInt();
            _loc7_ = _loc9_.readInt();
            _loc8_ = _loc9_.readInt();
            this._itemDataList.push(new GypsyItemData(_loc2_,_loc3_,_loc4_,_loc6_,_loc5_,_loc7_,_loc8_));
         }
         GypsyShopManager.getInstance().newItemListUpdate();
      }
      
      public function dispose() : void
      {
         SocketManager.Instance.removeEventListener(GypsyShopEvent.GOT_NEW_ITEM_LIST,this.onItemListUpdated);
         SocketManager.Instance.removeEventListener(GypsyShopEvent.ON_BUY_RESULT,this.onBuyResult);
         SocketManager.Instance.removeEventListener(GypsyShopEvent.ON_RARE_ITEM_UPDATED,this.onRareItemListUpdated);
      }
      
      public function getNeedMoneyTotal() : int
      {
         return this._curRefreshedTimes * this._curRefreshedTimes * 30 + 500;
      }
      
      public function getUpdateTime() : String
      {
         return null;
      }
      
      public function getRareItemsList() : Vector.<InventoryItemInfo>
      {
         return null;
      }
      
      public function getHonour() : int
      {
         return 0;
      }
      
      public function get itemCount() : int
      {
         return this._itemCount;
      }
      
      public function get curRefreshedTimes() : int
      {
         return this._curRefreshedTimes;
      }
      
      public function get itemDataList() : Vector.<GypsyItemData>
      {
         return this._itemDataList;
      }
      
      public function get buyResult() : Object
      {
         return this._buyResult;
      }
      
      public function get listRareItemTempleteIDs() : Vector.<int>
      {
         return this._listRareItemTempleteIDs;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
