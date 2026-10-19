package morn.core.managers
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class RenderManager
   {
      
      private var _methods:Dictionary = new Dictionary();
      
      public function RenderManager()
      {
         super();
      }
      
      private function invalidate() : void
      {
         if(Boolean(App.stage))
         {
            App.stage.addEventListener("enterFrame",this.onValidate);
            App.stage.addEventListener("render",this.onValidate);
            App.stage.invalidate();
         }
      }
      
      private function onValidate(param1:Event) : void
      {
         App.stage.removeEventListener("render",this.onValidate);
         App.stage.removeEventListener("enterFrame",this.onValidate);
         this.renderAll();
         App.stage.dispatchEvent(new Event("renderCompleted"));
      }
      
      public function renderAll() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         for(_loc1_ in this._methods)
         {
            this.exeCallLater(_loc1_ as Function);
         }
         _loc2_ = 0;
         _loc3_ = this._methods;
         var _loc4_:int = 0;
         var _loc5_:* = _loc3_;
         for each(_loc1_ in _loc5_)
         {
            return this.renderAll();
         }
      }
      
      public function callLater(param1:Function, param2:Array = null) : void
      {
         if(this._methods[param1] == null)
         {
            this._methods[param1] = param2 || [];
            this.invalidate();
         }
      }
      
      public function exeCallLater(param1:Function) : void
      {
         var _loc2_:* = null;
         if(this._methods[param1] != null)
         {
            _loc2_ = this._methods[param1];
            delete this._methods[param1];
            _loc2_.splice(0,1);
            param1.apply(null,_loc2_);
         }
      }
      
      public function removeCallLaterByObj(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         for(_loc3_ in this._methods)
         {
            _loc2_ = this._methods[_loc3_];
            if(param1 == _loc2_[0])
            {
               delete this._methods[_loc3_];
            }
         }
      }
      
      public function removeCallLater(param1:Function) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._methods)
         {
            if(_loc2_ == param1)
            {
               delete this._methods[_loc2_];
            }
         }
      }
   }
}

