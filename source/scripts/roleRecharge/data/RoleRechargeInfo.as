package roleRecharge.data
{
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class RoleRechargeInfo
   {
      
      private var _beginIndex:int;
      
      private var _endIndex:int;
      
      private var _giftRewardArr:Vector.<GiftRewardInfo>;
      
      public function RoleRechargeInfo()
      {
         super();
      }
      
      public function get giftRewardArr() : Vector.<GiftRewardInfo>
      {
         return this._giftRewardArr;
      }
      
      public function set giftRewardArr(param1:Vector.<GiftRewardInfo>) : void
      {
         this._giftRewardArr = param1;
      }
      
      public function get beginIndex() : int
      {
         return this._beginIndex;
      }
      
      public function set beginIndex(param1:int) : void
      {
         this._beginIndex = param1;
      }
      
      public function get endIndex() : int
      {
         return this._endIndex;
      }
      
      public function set endIndex(param1:int) : void
      {
         this._endIndex = param1;
      }
   }
}

