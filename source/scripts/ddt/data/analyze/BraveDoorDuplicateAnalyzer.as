package ddt.data.analyze
{
   import BraveDoor.data.BraveDoorDuplicateInfo;
   import BraveDoor.data.DuplicateInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BraveDoorDuplicateAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<BraveDoorDuplicateInfo> = new Vector.<BraveDoorDuplicateInfo>();
      
      private var _maps:XML;
      
      private var _xml:XML;
      
      public function BraveDoorDuplicateAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:XMLList = null;
         var _loc8_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         this._xml = new XML(param1);
         _loc6_ = this._xml..map;
         var _loc7_:int = _loc6_.length();
         for each(_loc8_ in _loc6_)
         {
            _loc3_ = new BraveDoorDuplicateInfo();
            this.initMap(_loc3_,_loc8_);
            _loc2_ = _loc8_..item;
            _loc5_ = 0;
            while(_loc5_ < _loc2_.length())
            {
               _loc4_ = new DuplicateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc5_]);
               _loc3_.addDuplicateInfo(_loc4_);
               _loc5_++;
            }
            this.list[_loc3_.page] = _loc3_;
         }
         onAnalyzeComplete();
      }
      
      protected function initMap(param1:BraveDoorDuplicateInfo, param2:XML) : void
      {
         ObjectUtils.copyPorpertiesByXML(param1,param2);
      }
   }
}

