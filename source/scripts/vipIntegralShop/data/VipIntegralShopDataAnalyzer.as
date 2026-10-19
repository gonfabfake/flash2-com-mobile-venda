package vipIntegralShop.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class VipIntegralShopDataAnalyzer extends DataAnalyzer
   {
      
      private var _shopInfoVec:Vector.<VipIntegralShopInfo>;
      
      public function VipIntegralShopDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this._shopInfoVec = new Vector.<VipIntegralShopInfo>();
         var _loc4_:XML = new XML(param1);
         var _loc5_:int = _loc4_.Item.length();
         var _loc6_:XMLList = _loc4_.Item;
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = new VipIntegralShopInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc6_[_loc2_]);
            this._shopInfoVec.push(_loc3_);
            _loc2_++;
         }
         onAnalyzeComplete();
      }
      
      public function get shopInfoVec() : Vector.<VipIntegralShopInfo>
      {
         return this._shopInfoVec;
      }
   }
}

