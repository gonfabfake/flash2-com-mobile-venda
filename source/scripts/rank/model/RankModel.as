package rank.model
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class RankModel extends EventDispatcher
   {
      
      private var _beginTime:String;
      
      private var _endTime:String;
      
      public var currentInfo:GmActivityInfo;
      
      public function RankModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get beginTime() : String
      {
         return this._beginTime;
      }
      
      public function set beginTime(param1:String) : void
      {
         this._beginTime = param1;
      }
      
      public function get endTime() : String
      {
         return this._endTime;
      }
      
      public function set endTime(param1:String) : void
      {
         this._endTime = param1;
      }
   }
}

