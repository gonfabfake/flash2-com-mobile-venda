package condiscount.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import condiscount.data.CondiscountInfo;
   
   public class CondiscountListAnalyzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<CondiscountInfo>;
      
      public function CondiscountListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this.itemList = new Vector.<CondiscountInfo>();
         var _loc4_:XML = new XML(param1);
         var _loc5_:int = _loc4_.Item.length();
         var _loc6_:XMLList = _loc4_..Item;
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length())
         {
            _loc3_ = new CondiscountInfo();
            this.itemList.push(_loc3_);
            _loc2_++;
         }
         onAnalyzeComplete();
      }
   }
}

