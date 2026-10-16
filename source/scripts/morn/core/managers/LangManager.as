package morn.core.managers
{
   public class LangManager
   {
      
      private var _data:Object = {};
      
      public function LangManager()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      public function add(param1:String, param2:Object) : void
      {
         this._data[param1] = param2;
      }
      
      public function getLang(param1:String, ... rest) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = this._data[param1] || param1;
         if(rest.length > 0)
         {
            _loc3_ = 0;
            _loc4_ = int(rest.length);
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc5_.replace("{" + _loc3_ + "}",rest[_loc3_]);
               _loc3_++;
            }
         }
         return _loc5_;
      }
   }
}

