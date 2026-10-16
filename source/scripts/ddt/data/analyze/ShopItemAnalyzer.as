package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import road7th.data.DictionaryData;
   
   public class ShopItemAnalyzer extends DataAnalyzer
   {
      
      public var shopinfolist:DictionaryData;
      
      private var _xml:XML;
      
      public function ShopItemAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         this._xml = new XML(param1);
         this.shopinfolist = new DictionaryData();
         if(this._xml.@value == "true")
         {
            _loc3_ = this._xml.Store..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc2_ = new ShopItemInfo(int(_loc3_[_loc4_].@ID),int(_loc3_[_loc4_].@TemplateID));
               ObjectUtils.copyPorpertiesByXML(_loc2_,_loc3_[_loc4_]);
               this.shopinfolist.add(_loc2_.GoodsID,_loc2_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

