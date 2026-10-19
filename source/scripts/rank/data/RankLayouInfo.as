package rank.data
{
   import flash.geom.Point;
   
   public class RankLayouInfo
   {
      
      public var TitleHLinePoint:Vector.<Point>;
      
      public var InfoTextWidth:Array;
      
      public var TitleTextPoint:Vector.<Point>;
      
      public var TitleTextString:Array;
      
      public function RankLayouInfo()
      {
         super();
         this.TitleHLinePoint = new Vector.<Point>();
         this.TitleTextPoint = new Vector.<Point>();
      }
      
      public function set infoTextWidth(param1:String) : void
      {
         this.InfoTextWidth = param1.split("|");
      }
      
      public function set titleHLinePt(param1:String) : void
      {
         this.TitleHLinePoint = this.parseValue(param1);
      }
      
      public function set titleTextPt(param1:String) : void
      {
         this.TitleTextPoint = this.parseValue(param1);
      }
      
      private function parseValue(param1:String) : Vector.<Point>
      {
         var _loc5_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:Vector.<Point> = new Vector.<Point>();
         var _loc4_:Array = param1.split("|");
         for each(_loc5_ in _loc4_)
         {
            _loc2_ = new Point(_loc5_.split(",")[0],_loc5_.split(",")[1]);
            _loc3_.push(_loc2_);
         }
         return _loc3_;
      }
   }
}

