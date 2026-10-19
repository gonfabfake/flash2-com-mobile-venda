package rank.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import rank.data.RankAwardInfo;
   
   public class RankingListAwardAnalyzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<RankAwardInfo>;
      
      public var lastUpdateTime:String;
      
      public function RankingListAwardAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         XML.ignoreWhitespace = true;
         this.itemList = new Vector.<RankAwardInfo>();
         var _loc4_:XML = new XML(param1);
         var _loc5_:int = _loc4_.Item.length();
         var _loc6_:XMLList = _loc4_..Item;
         this.lastUpdateTime = _loc4_.@lastUpdateTime;
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length())
         {
            _loc3_ = new RankAwardInfo();
            _loc3_.activeParam1 = _loc6_[_loc2_].@ActiveParam1;
            _loc3_.activeParam2 = _loc6_[_loc2_].@ActiveParam2;
            _loc3_.activeType = _loc6_[_loc2_].@ActiveType;
            _loc3_.activeValue = _loc6_[_loc2_].@ActiveValue;
            _loc3_.itemName = _loc6_[_loc2_].@ItemName;
            _loc3_.nickName = _loc6_[_loc2_].@NickName;
            _loc3_.subType = _loc6_[_loc2_].@SubType;
            _loc3_.userID = _loc6_[_loc2_].@UserID;
            _loc3_.rank = _loc6_[_loc2_].@Rank;
            this.itemList.push(_loc3_);
            _loc2_++;
         }
         onAnalyzeComplete();
      }
   }
}

