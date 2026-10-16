package halloween.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import halloween.info.HalloweenPrizeInfo;
   
   public class HalloweenDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array = new Array();
      
      public function HalloweenDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:HalloweenPrizeInfo = null;
         var _loc7_:XML = new XML(param1);
         if(_loc7_.@value == "true")
         {
            _loc2_ = _loc7_..items;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new Array();
               _loc5_ = 0;
               while(_loc5_ < _loc2_[_loc3_].item.length())
               {
                  _loc6_ = new HalloweenPrizeInfo();
                  _loc6_.templateId = _loc2_[_loc3_].item[_loc5_].@templateId;
                  _loc6_.count = _loc2_[_loc3_].item[_loc5_].@count;
                  _loc6_.validate = _loc2_[_loc3_].item[_loc5_].@validate;
                  _loc6_.strenthLevel = _loc2_[_loc3_].item[_loc5_].@strenthLevel;
                  _loc6_.attack = _loc2_[_loc3_].item[_loc5_].@attack;
                  _loc6_.defend = _loc2_[_loc3_].item[_loc5_].@defend;
                  _loc6_.luck = _loc2_[_loc3_].item[_loc5_].@luck;
                  _loc6_.agility = _loc2_[_loc3_].item[_loc5_].@agility;
                  _loc6_.isBind = _loc2_[_loc3_].item[_loc5_].@isBind;
                  _loc4_.push(_loc6_);
                  _loc5_++;
               }
               this.dataList.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
      }
   }
}

