package sanXiao
{
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   import sanXiao.model.SXGainedItemDATA;
   import sanXiao.model.SXRewardItemData;
   import sanXiao.model.SXStoreBoughtData;
   import sanXiao.model.SanXiaoScoreRewardAnalyzer;
   import sanXiao.model.SanXiaoStoreItemAnalyzer;
   
   public class SanXiaoManager extends CoreManager
   {
      
      private static var instance:SanXiaoManager;
      
      public static const SHOW_VIEW:String = "sanxiao_show_view";
      
      public static const UPDATE_DATA:String = "sanxiao_update_data";
      
      public static const MAP_STATUS:String = "sanxiao_map_status";
      
      public static const DROP_OUT_ITEM_GAINED:String = "sanxiao_drop_out_item_gained";
      
      private var _score:int;
      
      private var _stepRemain:Number;
      
      public var propCrossBombCount:int;
      
      public var propSquareBombCount:int;
      
      public var propClearColorCount:int;
      
      public var propChangeColorCount:int;
      
      private var _rewardItemList:Array;
      
      private var _crystalNum:Number = 0;
      
      private var _progressTips:String;
      
      private var _dateEnd:Date;
      
      private var _rewardGainedIDList:Array;
      
      private var _storeRemainList:Array;
      
      public var mapInfo:Array;
      
      private var _isOpen:Boolean = false;
      
      private var _discounts:int = 0;
      
      private var _propPriceList:Array;
      
      private var _itemDataList:Array;
      
      private var _scoreRewardList:Array;
      
      private var _lengthAddedDropOutItem:int;
      
      public function SanXiaoManager(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : SanXiaoManager
      {
         if(!instance)
         {
            instance = new SanXiaoManager(new inner());
         }
         return instance;
      }
      
      public function get score() : int
      {
         return this._score;
      }
      
      public function get stepRemain() : Number
      {
         return this._stepRemain;
      }
      
      public function get dropOutItemList() : Array
      {
         return this._rewardItemList;
      }
      
      public function get crystalNum() : Number
      {
         return this._crystalNum;
      }
      
      public function get nextPriseScoreProgress() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = int(this._scoreRewardList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            if((this._scoreRewardList[_loc1_] as SXRewardItemData).point > this._score)
            {
               _loc2_ = _loc1_ > 0 ? Number(this._scoreRewardList[_loc1_ - 1].point) : 0;
               _loc3_ = this._scoreRewardList[_loc1_].point - _loc2_;
               _loc4_ = this._score - _loc2_;
               this._progressTips = this._score.toString() + "/" + (this._scoreRewardList[_loc1_] as SXRewardItemData).point.toString();
               return Math.floor(_loc4_ / _loc3_ * 10000) / 100;
            }
            _loc1_++;
         }
         this._progressTips = this._score.toString() + "/" + (this._scoreRewardList[_loc5_ - 1] as SXRewardItemData).point.toString();
         return 100;
      }
      
      public function get progressTipsData() : String
      {
         if(this._progressTips == null)
         {
            this.nextPriseScoreProgress;
         }
         return this._progressTips;
      }
      
      public function get nextPriseScore() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._scoreRewardList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if((this._scoreRewardList[_loc1_] as SXRewardItemData).point > this._score)
            {
               return this._scoreRewardList[_loc1_].point;
            }
            _loc1_++;
         }
         return -1;
      }
      
      public function get nextRewardSXRewardItemData() : SXRewardItemData
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._scoreRewardList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if((this._scoreRewardList[_loc1_] as SXRewardItemData).point > this._score)
            {
               return this._scoreRewardList[_loc1_];
            }
            _loc1_++;
         }
         return this._scoreRewardList[_loc2_ - 1];
      }
      
      public function get dataEnd() : Date
      {
         return this._dateEnd;
      }
      
      public function get isDiscounts() : Boolean
      {
         return this._discounts > 0;
      }
      
      public function setUp() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_ISOPEN,this.onIsOpen);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_REQUIRE_MAP,this.onRequireMap);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_BUY_TIMES,this.onBuyTimes);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_DATA,this.onGetData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_REWARDS_DATA,this.onGetRewardsData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_STORE_DATA,this.onGetStoreData);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SANXIAO_DROP_OUT_GAINED_ITEM,this.onGainedDropItem);
      }
      
      protected function onBuyTimes(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._stepRemain = _loc2_.readInt();
         dispatchEvent(new CEvent("sanxiao_update_data"));
      }
      
      protected function onGainedDropItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:PackageIn = param1.pkg;
         if(this._rewardItemList == null)
         {
            this._rewardItemList = [];
         }
         this._lengthAddedDropOutItem = _loc4_.readInt();
         _loc2_ = 0;
         while(_loc2_ < this._lengthAddedDropOutItem)
         {
            _loc3_ = new SXGainedItemDATA(_loc4_.readInt(),_loc4_.readInt());
            this._rewardItemList.push(_loc3_);
            _loc2_++;
         }
         dispatchEvent(new CEvent("sanxiao_drop_out_item_gained"));
      }
      
      protected function onGetStoreData(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:PackageIn = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._crystalNum = (_loc5_ = param1.pkg).readInt();
         var _loc6_:int = _loc5_.readInt();
         this._storeRemainList = [];
         _loc2_ = 0;
         while(_loc2_ < _loc6_)
         {
            _loc3_ = _loc5_.readInt();
            _loc4_ = _loc5_.readInt();
            this._storeRemainList.push(new SXStoreBoughtData(_loc3_,_loc4_));
            _loc2_++;
         }
         dispatchEvent(new CEvent("sanxiao_update_data"));
      }
      
      protected function onGetRewardsData(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         this._rewardGainedIDList = [];
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this._rewardGainedIDList.push(_loc3_.readInt());
            _loc2_++;
         }
         dispatchEvent(new CEvent("sanxiao_update_data"));
      }
      
      protected function onGetData(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._score = _loc2_.readInt();
         this._stepRemain = _loc2_.readInt();
         this._crystalNum = _loc2_.readInt();
         this._dateEnd = _loc2_.readDate();
         dispatchEvent(new CEvent("sanxiao_update_data"));
      }
      
      protected function onRequireMap(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this.mapInfo = [];
         while(_loc3_ > 0)
         {
            this.mapInfo.push(_loc2_.readInt());
            this.mapInfo.push(_loc2_.readInt());
            this.mapInfo.push(_loc2_.readInt());
            _loc3_ -= 1;
         }
         dispatchEvent(new CEvent("sanxiao_map_status"));
      }
      
      protected function onIsOpen(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         this._dateEnd = _loc2_.readDate();
         this._discounts = _loc2_.readInt();
         this._discounts = this._discounts >= 100 ? 0 : this._discounts;
         this._isOpen = _loc3_;
         HallIconManager.instance.updateSwitchHandler("sanxiao",this._isOpen);
      }
      
      override protected function start() : void
      {
         this.propPriceData();
         this._rewardItemList = [];
         dispatchEvent(new CEvent("sanxiao_show_view"));
      }
      
      public function getPropPrice(param1:int) : String
      {
         if(this._propPriceList == null)
         {
            return "";
         }
         return this._propPriceList[param1 * 2 - 1];
      }
      
      public function getPropCurPrice(param1:int) : String
      {
         if(this._propPriceList == null)
         {
            return "";
         }
         if(this._discounts == 0)
         {
            return this.getPropPrice(param1);
         }
         return int(this._propPriceList[param1 * 2 - 1] * this._discounts / 100).toString();
      }
      
      public function getPropScore(param1:int) : String
      {
         if(this._propPriceList == null)
         {
            return "";
         }
         return this._propPriceList[param1 * 2 - 2];
      }
      
      public function propPriceData() : Array
      {
         var _loc1_:ServerConfigManager = ServerConfigManager.instance;
         if(!this._propPriceList)
         {
            this._propPriceList = [_loc1_.SanXiaoCrossBombScore(),_loc1_.SanXiaoCrossBombPrice(),_loc1_.SanXiaoSquareBombScore(),_loc1_.SanXiaoSquareBombPrice(),_loc1_.SanXiaoClearColorScore(),_loc1_.SanXiaoClearColorPrice(),_loc1_.SanXiaoChangeColorScore(),_loc1_.SanXiaoChangeColorPrice()];
         }
         return this._propPriceList;
      }
      
      public function get itemDataList() : Array
      {
         var _loc4_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(this._itemDataList == null)
         {
            return [];
         }
         var _loc3_:int = int(this._itemDataList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            for each(_loc4_ in this._storeRemainList)
            {
               _loc2_ = this._itemDataList[_loc1_];
               if(_loc2_.id == _loc4_.id)
               {
                  _loc2_.remain = _loc2_.total - _loc4_.boughtTimes;
               }
            }
            _loc1_++;
         }
         return this._itemDataList;
      }
      
      public function get scoreRewardList() : Array
      {
         var _loc4_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(this._scoreRewardList == null)
         {
            return [];
         }
         var _loc3_:int = int(this._scoreRewardList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            for each(_loc4_ in this._rewardGainedIDList)
            {
               _loc2_ = this._scoreRewardList[_loc1_];
               if(_loc2_.id == _loc4_)
               {
                  _loc2_.gained = true;
               }
            }
            _loc1_++;
         }
         return this._scoreRewardList;
      }
      
      public function get endTime() : Date
      {
         return this._dateEnd;
      }
      
      public function onSXScoreRewardData(param1:SanXiaoScoreRewardAnalyzer) : void
      {
         this._scoreRewardList = param1.list;
      }
      
      public function onSXStoreItemData(param1:SanXiaoStoreItemAnalyzer) : void
      {
         this._itemDataList = param1.list;
      }
      
      public function get lengthAddedDropOutItem() : int
      {
         return this._lengthAddedDropOutItem;
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
