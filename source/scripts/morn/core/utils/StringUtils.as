package morn.core.utils
{
   import flash.geom.Rectangle;
   
   public class StringUtils
   {
      
      public function StringUtils()
      {
         super();
      }
      
      public static function fillArray(param1:Array, param2:String, param3:Class = null) : Array
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:Array = ObjectUtils.clone(param1);
         if(Boolean(param2))
         {
            _loc4_ = param2.split(",");
            _loc5_ = 0;
            _loc6_ = Math.min(_loc8_.length,_loc4_.length);
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc4_[_loc5_];
               _loc8_[_loc5_] = _loc7_ == "true" ? true : (_loc7_ == "false" ? false : _loc7_);
               if(param3 != null)
               {
                  _loc8_[_loc5_] = param3(_loc7_);
               }
               _loc5_++;
            }
         }
         return _loc8_;
      }
      
      public static function rectToString(param1:Rectangle) : String
      {
         if(Boolean(param1))
         {
            return param1.x + "," + param1.y + "," + param1.width + "," + param1.height;
         }
         return null;
      }
   }
}

