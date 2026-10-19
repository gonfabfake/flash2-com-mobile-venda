package godsRoads.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import godsRoads.data.GodsRoadsMissionInfo;
   import godsRoads.manager.GodsRoadsManager;
   
   public class GodsRoadsDataAnalyzer extends DataAnalyzer
   {
      
      public var dataList:Vector.<GodsRoadsMissionInfo> = new Vector.<GodsRoadsMissionInfo>();
      
      public function GodsRoadsDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:GodsRoadsMissionInfo = null;
         var _loc5_:XMLList = null;
         var _loc6_:XML = new XML(param1);
         GodsRoadsManager.instance.XMLData = _loc6_;
         if(_loc6_.@value == "true")
         {
            _loc2_ = _loc6_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@QuestType != 1)
               {
                  _loc4_ = new GodsRoadsMissionInfo();
                  _loc5_ = _loc2_[_loc3_]..Item_Condiction;
                  _loc4_.questId = _loc2_[_loc3_].@ID;
                  _loc4_.Title = _loc2_[_loc3_].@Title;
                  _loc4_.Detail = _loc2_[_loc3_].@Detail;
                  _loc4_.Objective = _loc2_[_loc3_].@Objective;
                  _loc4_.NeedMinLevel = _loc2_[_loc3_].@NeedMinLevel;
                  _loc4_.NeedMaxLevel = _loc2_[_loc3_].@NeedMaxLevel;
                  _loc4_.Period = _loc2_[_loc3_].@Period;
                  _loc4_.conditiontId = _loc5_[0].@CondictionID;
                  _loc4_.conditiontTitle = _loc5_[0].@CondictionTitle;
                  _loc4_.conditionType = _loc5_[0].@CondictionType;
                  _loc4_.Para1 = _loc5_[0].@Para1;
                  _loc4_.Para2 = _loc5_[0].@Para2;
                  _loc4_.IndexType = _loc5_[0].@IndexType;
                  this.dataList.push(_loc4_);
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
      }
   }
}

