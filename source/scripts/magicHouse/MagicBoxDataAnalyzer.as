package magicHouse
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import magicHouse.magicBox.MagicBoxItemInfo;
   
   public class MagicBoxDataAnalyzer extends DataAnalyzer
   {
      
      public var list:Vector.<MagicBoxItemInfo> = new Vector.<MagicBoxItemInfo>();
      
      public function MagicBoxDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         _loc4_ = new XML(param1);
         if(_loc4_.@value == "true")
         {
            _loc2_ = _loc4_..Item;
            for each(_loc5_ in _loc2_)
            {
               _loc3_ = new MagicBoxItemInfo();
               ObjectUtils.copyPorpertiesByXML(_loc3_,_loc5_);
               this.list.push(_loc3_);
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc4_.@message;
            onAnalyzeComplete();
         }
      }
   }
}

