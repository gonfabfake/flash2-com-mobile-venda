package groupPurchase.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class GroupPurchaseAwardAnalyzer extends DataAnalyzer
   {
      
      private var _awardList:Object;
      
      public function GroupPurchaseAwardAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:GroupPurchaseAwardInfo = null;
         var _loc5_:XML = new XML(param1);
         this._awardList = {};
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new GroupPurchaseAwardInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._awardList[_loc4_.SortID] = _loc4_;
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get awardList() : Object
      {
         return this._awardList;
      }
   }
}

