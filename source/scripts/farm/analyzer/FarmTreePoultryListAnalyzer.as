package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.FarmModelController;
   import farm.modelx.FarmPoultryInfo;
   import flash.utils.Dictionary;
   
   public class FarmTreePoultryListAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function FarmTreePoultryListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:XML = new XML(param1);
         var _loc5_:XMLList = _loc4_..item;
         FarmModelController.MAXLEVEL = _loc5_.length() - 1;
         for each(_loc6_ in _loc5_)
         {
            _loc3_ = new FarmPoultryInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc6_);
            _loc2_ = int(_loc6_.@Level);
            this.list[_loc2_] = _loc3_;
         }
         onAnalyzeComplete();
      }
   }
}

