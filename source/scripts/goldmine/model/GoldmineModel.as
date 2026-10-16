package goldmine.model
{
   public class GoldmineModel
   {
      
      public var score:int;
      
      public var maxTimes:int;
      
      public var currentTimes:int;
      
      public var usedTimes:int;
      
      public var mineSmall:int;
      
      public var mineMiddle:int;
      
      public var mineBig:int;
      
      public var nextScoreNeed:int;
      
      public var goldNeed:int;
      
      public var goldArr:Array;
      
      public var goldNeedArr:Array;
      
      public function GoldmineModel()
      {
         super();
      }
      
      public function setValue(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
      {
         this.score = param1;
         this.maxTimes = param2;
         this.currentTimes = param3;
         this.usedTimes = param4;
         this.mineSmall = param5;
         this.mineMiddle = param6;
         this.mineBig = param7;
         this.nextScoreNeed = param8;
         this.goldNeed = param9;
      }
   }
}

