package battleGroud.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   
   public class BattleWeeklyAwardAnalyzer extends DataAnalyzer
   {
      
      private var _dataList:Array;
      
      public function BattleWeeklyAwardAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      public function get dataList() : Array
      {
         return this._dataList;
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this._dataList = [];
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_.item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new InventoryItemInfo();
               _loc4_.TemplateID = int(_loc2_[_loc3_].@TemplateID);
               ItemManager.fill(_loc4_);
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this._dataList.push(_loc4_);
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
         }
      }
   }
}

