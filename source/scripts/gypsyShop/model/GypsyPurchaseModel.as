package gypsyShop.model
{
   import ddt.manager.PlayerManager;
   
   public class GypsyPurchaseModel
   {
      
      private static var instance:GypsyPurchaseModel;
      
      private var _useBindRmbTicket:Boolean = false;
      
      private var _showAlertHonourRefresh:Boolean = true;
      
      private var _showAlertRmbTicketBuy:Boolean = true;
      
      public function GypsyPurchaseModel(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : GypsyPurchaseModel
      {
         if(!instance)
         {
            instance = new GypsyPurchaseModel(new inner());
         }
         return instance;
      }
      
      public function updateIsUseBindRmbTicket(param1:Boolean) : void
      {
         this._useBindRmbTicket = param1;
      }
      
      public function updateShowAlertHonourRefresh(param1:Boolean) : void
      {
         this._showAlertHonourRefresh = param1;
      }
      
      public function updateShowAlertRmbTicketBuy(param1:Boolean) : void
      {
         this._showAlertRmbTicketBuy = param1;
      }
      
      public function isShowRmbTicketBuyAgain() : Boolean
      {
         return this._showAlertRmbTicketBuy;
      }
      
      public function isShowHonourRefreshAgain() : Boolean
      {
         return this._showAlertHonourRefresh;
      }
      
      public function getUseBind() : Boolean
      {
         return this._useBindRmbTicket;
      }
      
      public function getRmbTicketNeeded(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<GypsyItemData> = GypsyShopModel.getInstance().itemDataList;
         if(_loc3_ == null)
         {
            return 0;
         }
         _loc2_ = int(_loc3_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc3_[_loc4_].id == param1)
            {
               if(_loc3_[_loc4_].unit == 1)
               {
                  return _loc3_[_loc4_].price;
               }
            }
            _loc4_++;
         }
         return 0;
      }
      
      public function getHonourNeeded() : int
      {
         return GypsyShopModel.getInstance().getNeedMoneyTotal();
      }
      
      public function isBindMoneyEnough(param1:int) : Boolean
      {
         if(PlayerManager.Instance.Self.BandMoney < this.getRmbTicketNeeded(param1))
         {
            return false;
         }
         return true;
      }
      
      public function isMoneyEnough(param1:int) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < this.getRmbTicketNeeded(param1))
         {
            return false;
         }
         return true;
      }
      
      public function isHonourEnough() : Boolean
      {
         return PlayerManager.Instance.Self.myHonor >= GypsyPurchaseModel.getInstance().getHonourNeeded();
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
