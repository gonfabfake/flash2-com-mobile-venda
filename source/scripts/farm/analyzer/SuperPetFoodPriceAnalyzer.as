package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.modelx.SuperPetFoodPriceInfo;
   
   public class SuperPetFoodPriceAnalyzer extends DataAnalyzer
   {
      
      public static const Path:String = "PetExpItemPrice.xml";
      
      public var list:Vector.<SuperPetFoodPriceInfo>;
      
      public function SuperPetFoodPriceAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc6_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:XML = new XML(param1);
         var _loc5_:XMLList = _loc4_..Item;
         this.list = new Vector.<SuperPetFoodPriceInfo>();
         for each(_loc6_ in _loc5_)
         {
            _loc3_ = new SuperPetFoodPriceInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc6_);
            this.list.push(_loc3_);
         }
         onAnalyzeComplete();
      }
   }
}

