package Indiana.model
{
   import Indiana.analyzer.IndianaGoodsItemInfo;
   import Indiana.analyzer.IndianaShopItemInfo;
   import ddt.manager.TimeManager;
   import road7th.utils.DateUtils;
   
   public class IndianaModel
   {
      
      public static var INDIANA_COUNTDOWN:int = 1;
      
      public static var INDIANA_SHOWING:int = 2;
      
      public static var INDIANA_DOING:int = 0;
      
      public static var INDIANA_START:int = 5;
      
      public static var INDIANA_END:int = 6;
      
      private var _items:Vector.<IndianaGoodsItemInfo>;
      
      private var _shopItems:Vector.<IndianaShopItemInfo>;
      
      private var _startTime:Date;
      
      private var _endTime:Date;
      
      public function IndianaModel()
      {
         super();
      }
      
      public function set Items(param1:Vector.<IndianaGoodsItemInfo>) : void
      {
         this._items = param1;
      }
      
      public function get Items() : Vector.<IndianaGoodsItemInfo>
      {
         return this._items;
      }
      
      public function set ShopItems(param1:Vector.<IndianaShopItemInfo>) : void
      {
         this._shopItems = param1;
         this.calculationStartTime();
         this.calculationEndTime();
      }
      
      public function calculationIsNeedCheck() : Boolean
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         if(this._endTime == null && this._startTime == null)
         {
            return false;
         }
         if(_loc1_.getTime() - this._endTime.getTime() > 0)
         {
            return false;
         }
         return true;
      }
      
      public function get ShopItems() : Vector.<IndianaShopItemInfo>
      {
         return this._shopItems;
      }
      
      public function getShopItemByid(param1:int) : IndianaShopItemInfo
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._shopItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._shopItems[_loc2_].PeriodId == param1)
            {
               return this._shopItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      private function calculationEndTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(Boolean(this._shopItems) && this._shopItems.length > 0)
         {
            _loc1_ = int(this._shopItems.length);
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               if(this._shopItems[_loc4_].Putaway == 1)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = DateUtils.decodeDated(this._shopItems[_loc4_].EndShowTime);
                  }
                  else
                  {
                     _loc3_ = DateUtils.decodeDated(this._shopItems[_loc4_].EndShowTime);
                     if(_loc2_.valueOf() - _loc3_.valueOf() < 0)
                     {
                        _loc2_ = _loc3_;
                     }
                  }
               }
               _loc4_++;
            }
            this._endTime = _loc2_;
         }
      }
      
      private function calculationStartTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(Boolean(this._shopItems) && this._shopItems.length > 0)
         {
            _loc1_ = int(this._shopItems.length);
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               if(this._shopItems[_loc4_].Putaway == 1)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = DateUtils.decodeDated(this._shopItems[_loc4_].StartTime);
                  }
                  else
                  {
                     _loc3_ = DateUtils.decodeDated(this._shopItems[_loc4_].StartTime);
                     if(_loc2_.valueOf() - _loc3_.valueOf() > 0)
                     {
                        _loc2_ = _loc3_;
                     }
                  }
               }
               _loc4_++;
            }
            this._startTime = _loc2_;
         }
      }
      
      public function getActivateState() : int
      {
         var _loc1_:Date = TimeManager.Instance.Now();
         if(Boolean(this._endTime) && _loc1_.getTime() - this._endTime.getTime() >= 0)
         {
            return INDIANA_END;
         }
         if(Boolean(this._startTime) && _loc1_.getTime() - this._startTime.getTime() >= 0)
         {
            return INDIANA_START;
         }
         return -1;
      }
   }
}

