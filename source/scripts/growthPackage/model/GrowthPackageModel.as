package growthPackage.model
{
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import growthPackage.data.GrowthPackageInfo;
   import growthPackage.event.GrowthPackageEvent;
   
   public class GrowthPackageModel extends EventDispatcher
   {
      
      private var _isBuy:int;
      
      private var _buyPrice:Number;
      
      private var _itemInfoList:Array;
      
      private var _isCompleteList:Array = [0,0,0,0,0,0,0,0];
      
      private var _gradeList:Array = new Array(10,20,30,40,45,50,55,60,65);
      
      public function GrowthPackageModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function getInventoryItemInfo(param1:GrowthPackageInfo) : InventoryItemInfo
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         var _loc3_:InventoryItemInfo = new InventoryItemInfo();
         ObjectUtils.copyProperties(_loc3_,_loc2_);
         _loc3_.LuckCompose = param1.TemplateID;
         _loc3_.ValidDate = param1.ValidDate;
         _loc3_.Count = param1.Count;
         _loc3_.IsBinds = param1.IsBind;
         _loc3_.StrengthenLevel = param1.StrengthLevel;
         _loc3_.AttackCompose = param1.AttackCompose;
         _loc3_.DefendCompose = param1.DefendCompose;
         _loc3_.AgilityCompose = param1.AgilityCompose;
         _loc3_.LuckCompose = param1.LuckCompose;
         return _loc3_;
      }
      
      public function dataChange(param1:String, param2:Object = null) : void
      {
         dispatchEvent(new GrowthPackageEvent(param1,param2));
      }
      
      public function get buyPrice() : Number
      {
         return this._buyPrice;
      }
      
      public function set buyPrice(param1:Number) : void
      {
         this._buyPrice = param1;
      }
      
      public function get itemInfoList() : Array
      {
         return this._itemInfoList;
      }
      
      public function set itemInfoList(param1:Array) : void
      {
         this._itemInfoList = param1;
      }
      
      public function get isCompleteList() : Array
      {
         return this._isCompleteList;
      }
      
      public function set isCompleteList(param1:Array) : void
      {
         this._isCompleteList = param1;
         if(!this.isShowIcon)
         {
            this.dataChange(GrowthPackageEvent.ICON_CLOSE);
         }
      }
      
      public function get isShowIcon() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.isBuy) && Boolean(this._isCompleteList))
         {
            _loc2_ = 0;
            while(_loc2_ < this._isCompleteList.length)
            {
               _loc3_ = int(this._isCompleteList[_loc2_]);
               if(_loc3_ == 1)
               {
                  _loc1_++;
               }
               _loc2_++;
            }
            if(_loc1_ > 0 && _loc1_ == this._isCompleteList.length)
            {
               return false;
            }
         }
         return true;
      }
      
      public function get gradeList() : Array
      {
         return this._gradeList;
      }
      
      public function set gradeList(param1:Array) : void
      {
         this._gradeList = param1;
      }
      
      public function get isBuy() : int
      {
         return this._isBuy;
      }
      
      public function set isBuy(param1:int) : void
      {
         this._isBuy = param1;
      }
   }
}

