package godsRoads.data
{
   public class GodsRoadsStepVo
   {
      
      public var isGetAwards:Boolean;
      
      public var missionsNum:int;
      
      public var missionVos:Array = [];
      
      public var awadsNum:int;
      
      public var awards:Array = [];
      
      public var currentStep:int = 0;
      
      public function GodsRoadsStepVo()
      {
         super();
      }
      
      public function getFinishPerNum() : int
      {
         var _loc1_:GodsRoadsMissionVo = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.missionVos.length)
         {
            _loc1_ = this.missionVos[_loc4_] as GodsRoadsMissionVo;
            if(_loc1_.isFinished)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return int(_loc3_ / this.missionVos.length * 100);
      }
      
      public function getFinishPerString() : String
      {
         var _loc1_:GodsRoadsMissionVo = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.missionVos.length)
         {
            _loc1_ = this.missionVos[_loc4_] as GodsRoadsMissionVo;
            if(_loc1_.isFinished)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_ + "/" + this.missionVos.length;
      }
   }
}

