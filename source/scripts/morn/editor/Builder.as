package morn.editor
{
   public class Builder
   {
      
      public static var isEditor:Boolean = false;
      
      public function Builder()
      {
         super();
      }
      
      public static function init() : void
      {
         App.stage = Sys.stage;
         App.asset = new BuilderResManager();
         isEditor = true;
      }
      
      public static function callBack(param1:Object) : void
      {
         if(Boolean(param1))
         {
            if(param1 != null)
            {
               setLang(String(param1));
            }
         }
      }
      
      private static function setLang(param1:String) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:Object = {};
         if(Boolean(param1))
         {
            _loc2_ = new XML(param1);
            for each(_loc4_ in _loc2_.item)
            {
               App.lang.add(_loc4_.@key,String(_loc4_.@value));
            }
         }
      }
   }
}

