package pyramid.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import pyramid.data.PyramidSystemItemsInfo;
   
   public class PyramidSystemItemsDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array;
      
      public function PyramidSystemItemsDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:PyramidSystemItemsInfo = null;
         var _loc5_:Array = null;
         var _loc6_:XML = new XML(param1);
         this.dataList = [];
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@ActivityType == "8")
               {
                  _loc4_ = new PyramidSystemItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  _loc5_ = this.dataList[_loc4_.Quality - 1];
                  if(!_loc5_)
                  {
                     _loc5_ = [];
                  }
                  _loc5_.push(_loc4_);
                  this.dataList[_loc4_.Quality - 1] = _loc5_;
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc6_.@message;
            onAnalyzeError();
         }
      }
   }
}

