package lightRoad.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import lightRoad.info.LightGiftInfo;
   
   public class LightRoadDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array;
      
      public function LightRoadDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:LightGiftInfo = null;
         var _loc5_:XML = new XML(param1);
         this.dataList = [];
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new LightGiftInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.dataList.push(_loc4_);
               _loc3_++;
            }
            this.onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
      
      override protected function onAnalyzeComplete() : void
      {
         super.onAnalyzeComplete();
      }
   }
}

