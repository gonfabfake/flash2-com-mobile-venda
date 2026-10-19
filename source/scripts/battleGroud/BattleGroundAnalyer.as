package battleGroud
{
   import battleGroud.data.BatlleData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BattleGroundAnalyer extends DataAnalyzer
   {
      
      public var battleDataList:Array;
      
      public function BattleGroundAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this.battleDataList = [];
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new BatlleData();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.battleDataList.push(_loc4_);
               _loc3_++;
            }
            this.battleDataList.sortOn("Level",16);
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
         onAnalyzeComplete();
      }
   }
}

