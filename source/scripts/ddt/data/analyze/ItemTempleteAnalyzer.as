package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import road7th.data.DictionaryData;
   
   public class ItemTempleteAnalyzer extends DataAnalyzer
   {
      
      public var list:DictionaryData = new DictionaryData();
      
      private var _xml:XML;
      
      private var _xmllist:XMLList;
      
      public function ItemTempleteAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         this._xml = new XML(param1);
         this.list = new DictionaryData();
         if(this._xml.@value == "true")
         {
            this._xmllist = this._xml.ItemTemplate..Item;
            _loc3_ = this._xml.ItemTemplate..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc2_ = new ItemTemplateInfo();
               ObjectUtils.copyPorpertiesByXML(_loc2_,this._xmllist[_loc4_]);
               this.list.add(_loc2_.TemplateID,_loc2_);
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

