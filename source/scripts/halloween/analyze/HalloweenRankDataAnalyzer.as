package halloween.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import halloween.info.HalloweenRankInfo;
   
   public class HalloweenRankDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Vector.<HalloweenRankInfo> = new Vector.<HalloweenRankInfo>();
      
      public function HalloweenRankDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:HalloweenRankInfo = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_.halloweenInfo;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new HalloweenRankInfo();
               _loc4_.name = _loc2_[_loc3_].@nickName;
               _loc4_.rank = _loc2_[_loc3_].@rank;
               _loc4_.num = _loc2_[_loc3_].@useNum;
               _loc4_.isvip = _loc2_[_loc3_].@isVIP != "0" ? Boolean(true) : Boolean(false);
               this.dataList.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
      }
   }
}

