package homeTemple.data
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import homeTemple.HomeTempleController;
   
   public class HomeTempleDataAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary;
      
      private var _xml:XML;
      
      public function HomeTempleDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this._xml = new XML(param1);
         if(this._xml.@value == "true")
         {
            this.list = new Dictionary();
            _loc2_ = this._xml..item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc4_ = new HomeTempleModel();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
               this.list[_loc4_.Level] = _loc4_;
               _loc3_++;
            }
            HomeTempleController.MAXLEVEL = _loc2_.length() - 1;
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
         }
      }
   }
}

