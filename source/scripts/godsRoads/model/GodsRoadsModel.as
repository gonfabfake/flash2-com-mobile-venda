package godsRoads.model
{
   import flash.events.EventDispatcher;
   import godsRoads.data.GodsRoadsMissionInfo;
   import godsRoads.data.GodsRoadsVo;
   
   public class GodsRoadsModel extends EventDispatcher
   {
      
      private var vo:GodsRoadsVo;
      
      private var _questionTemple:Vector.<GodsRoadsMissionInfo>;
      
      public function GodsRoadsModel()
      {
         super();
      }
      
      public function getMissionInfoById(param1:int) : GodsRoadsMissionInfo
      {
         var _loc2_:GodsRoadsMissionInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._questionTemple.length)
         {
            if(param1 == this._questionTemple[_loc3_].questId)
            {
               _loc2_ = this._questionTemple[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function set godsRoadsData(param1:GodsRoadsVo) : void
      {
         this.vo = param1;
      }
      
      public function get godsRoadsData() : GodsRoadsVo
      {
         return this.vo;
      }
      
      public function set missionInfo(param1:Vector.<GodsRoadsMissionInfo>) : void
      {
         this._questionTemple = param1;
      }
      
      public function get missionInfo() : Vector.<GodsRoadsMissionInfo>
      {
         return this._questionTemple;
      }
   }
}

