package sevenDayTarget.dataAnalyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   
   public class SevenDayTargetDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Array;
      
      public function SevenDayTargetDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:NewTargetQuestionInfo = null;
         var _loc5_:XMLList = null;
         var _loc6_:int = 0;
         var _loc7_:XML = new XML(param1);
         this.dataList = new Array();
         if(_loc7_.@value == "true")
         {
            _loc2_ = _loc7_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new NewTargetQuestionInfo();
               _loc4_.questId = _loc2_[_loc3_].@ID;
               _loc4_.Period = _loc2_[_loc3_].@Period;
               _loc5_ = _loc2_[_loc3_]..Item_Condiction;
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length())
               {
                  _loc4_.linkId = _loc5_[_loc6_].@IndexType;
                  if(_loc5_[_loc6_].@CondictionID == "1")
                  {
                     _loc4_.condition1Title = _loc5_[_loc6_].@CondictionTitle;
                     _loc4_.condition1Para = _loc5_[_loc6_].@Para2;
                  }
                  else if(_loc5_[_loc6_].@CondictionID == "2")
                  {
                     _loc4_.condition2Title = _loc5_[_loc6_].@CondictionTitle;
                     _loc4_.condition2Para = _loc5_[_loc6_].@Para2;
                  }
                  else if(_loc5_[_loc6_].@CondictionID == "3")
                  {
                     _loc4_.condition3Title = _loc5_[_loc6_].@CondictionTitle;
                     _loc4_.condition3Para = _loc5_[_loc6_].@Para2;
                  }
                  _loc6_++;
               }
               this.dataList.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
      }
   }
}

