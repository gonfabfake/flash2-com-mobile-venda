package sanXiao.model
{
   import com.pickgliss.loader.DataAnalyzer;
   
   public class SanXiaoStoreItemAnalyzer extends DataAnalyzer
   {
      
      public var list:Array;
      
      public function SanXiaoStoreItemAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:XML = new XML(param1);
         this.list = [];
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new SXStoreItemData();
               _loc4_.count = int(_loc2_[_loc3_].@Count);
               _loc4_.id = int(_loc2_[_loc3_].@ID);
               _loc4_.TempleteID = int(_loc2_[_loc3_].@ItemID);
               _loc4_.price = int(_loc2_[_loc3_].@Price);
               _loc4_.total = int(_loc2_[_loc3_].@LimitCount);
               _loc4_.remain = _loc4_.total;
               _loc4_.isBind = _loc2_[_loc3_].@IsBind == "true" ? true : false;
               _loc4_.Valid = int(_loc2_[_loc3_].@Valid);
               this.list.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

