package Indiana.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class IndianaShopItemsAnalyzer extends DataAnalyzer
   {
      
      public var itemList:Vector.<IndianaShopItemInfo>;
      
      public function IndianaShopItemsAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         XML.ignoreWhitespace = true;
         this.itemList = new Vector.<IndianaShopItemInfo>();
         var _loc4_:XML = new XML(param1);
         var _loc5_:int = _loc4_.item.length();
         var _loc6_:XMLList = _loc4_..Item;
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length())
         {
            _loc2_ = new IndianaShopItemInfo();
            ObjectUtils.copyPorpertiesByXML(_loc2_,_loc6_[_loc3_]);
            this.itemList.push(_loc2_);
            _loc3_++;
         }
         onAnalyzeComplete();
      }
      
      public function get data() : Vector.<IndianaShopItemInfo>
      {
         return this.itemList;
      }
   }
}

