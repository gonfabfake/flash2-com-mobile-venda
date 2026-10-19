package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import farm.modelx.FramFriendStateInfo;
   import farm.modelx.SimpleLandStateInfo;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class FarmFriendListAnalyzer extends DataAnalyzer
   {
      
      public var list:DictionaryData = new DictionaryData();
      
      public function FarmFriendListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:XML = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loc6_ = XML(param1);
         var _loc7_:XMLList = _loc6_.Item;
         for each(_loc8_ in _loc7_)
         {
            _loc2_ = new FramFriendStateInfo();
            _loc2_.id = _loc8_.@UserID;
            _loc2_.isFeed = _loc8_.@isFeed == "true" ? true : false;
            _loc3_ = new Vector.<SimpleLandStateInfo>();
            _loc4_ = _loc8_.Item;
            for each(_loc9_ in _loc4_)
            {
               _loc5_ = new SimpleLandStateInfo();
               _loc5_.seedId = _loc9_.@SeedID;
               _loc5_.AccelerateDate = _loc9_.@AcclerateDate;
               _loc5_.plantTime = DateUtils.decodeDated(_loc9_.@GrowTime);
               _loc5_.isStolen = _loc9_.@IsCanStolen == "true" ? true : false;
               _loc3_.push(_loc5_);
            }
            _loc2_.setLandStateVec = _loc3_;
            this.list.add(_loc2_.id,_loc2_);
         }
         onAnalyzeComplete();
      }
   }
}

