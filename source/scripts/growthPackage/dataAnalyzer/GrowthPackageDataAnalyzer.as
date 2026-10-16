package growthPackage.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import growthPackage.data.GrowthPackageInfo;
   
   public class GrowthPackageDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array;
      
      public function GrowthPackageDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:GrowthPackageInfo = null;
         var _loc5_:Vector.<GrowthPackageInfo> = null;
         var _loc6_:XML = new XML(param1);
         this.dataList = [];
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@ActivityType == "20")
               {
                  _loc4_ = new GrowthPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  _loc5_ = this.dataList[_loc4_.Quality];
                  if(!_loc5_)
                  {
                     _loc5_ = new Vector.<GrowthPackageInfo>();
                  }
                  _loc5_.push(_loc4_);
                  this.dataList[_loc4_.Quality] = _loc5_;
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

