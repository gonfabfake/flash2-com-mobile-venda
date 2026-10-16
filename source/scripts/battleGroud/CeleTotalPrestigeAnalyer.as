package battleGroud
{
   import battleGroud.data.BattlPrestigeData;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CeleTotalPrestigeAnalyer extends DataAnalyzer
   {
      
      public var battleDataList:Vector.<BattlPrestigeData>;
      
      public function CeleTotalPrestigeAnalyer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this.battleDataList = new Vector.<BattlPrestigeData>();
         var _loc4_:XML = new XML(param1);
         var _loc5_:int = _loc4_.item.length();
         var _loc6_:XMLList = _loc4_..Item;
         _loc2_ = 0;
         while(_loc2_ < _loc6_.length())
         {
            _loc3_ = new BattlPrestigeData();
            _loc3_.Numbers = _loc2_ + 1;
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc6_[_loc2_]);
            this.battleDataList.push(_loc3_);
            _loc2_++;
         }
         onAnalyzeComplete();
      }
   }
}

