package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import farm.view.compose.vo.FoodComposeListTemplateInfo;
   import flash.utils.Dictionary;
   
   public class FoodComposeListAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      private var _listDetail:Vector.<FoodComposeListTemplateInfo>;
      
      public function FoodComposeListAnalyzer(param1:Function)
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
         for each(_loc6_ in _loc5_)
         {
            _loc3_ = new FoodComposeListTemplateInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc6_);
            if(_loc2_ != _loc3_.FoodID)
            {
               _loc2_ = int(_loc3_.FoodID);
               this._listDetail = new Vector.<FoodComposeListTemplateInfo>();
               this._listDetail.push(_loc3_);
            }
            else if(_loc2_ == _loc3_.FoodID)
            {
               this._listDetail.push(_loc3_);
            }
            this.list[_loc2_] = this._listDetail;
         }
         onAnalyzeComplete();
      }
   }
}

