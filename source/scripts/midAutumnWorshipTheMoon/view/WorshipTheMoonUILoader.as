package midAutumnWorshipTheMoon.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class WorshipTheMoonUILoader
   {
      
      private static var _loadedDic:Dictionary = new Dictionary();
      
      private var _loadProgress:int = 0;
      
      private var _UILoadComplete:Boolean = false;
      
      private var _list:Array;
      
      private var _update:Function;
      
      private var _loadListID:String;
      
      public function WorshipTheMoonUILoader()
      {
         super();
      }
      
      public function loadUIModule(param1:String, param2:Array, param3:Function) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(_loadedDic[param1] != null)
         {
            param3();
            return;
         }
         this._loadListID = param1;
         this._list = param2;
         this._update = param3;
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            _loc4_ = int(param2.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               UIModuleLoader.Instance.addUIModuleImp(param2[_loc5_]);
               _loc5_++;
            }
         }
         else
         {
            this._update();
         }
      }
      
      protected function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      protected function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         this.checkComplete(param1.module);
         if(this._UILoadComplete)
         {
            _loadedDic[this._loadListID] = 1;
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleSmallLoading.Instance.hide();
            this._update();
         }
      }
      
      private function checkComplete(param1:String) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in this._list)
         {
            if(_loc2_ == param1)
            {
               ++this._loadProgress;
               if(this._loadProgress >= this._list.length)
               {
                  this._UILoadComplete = true;
               }
            }
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
   }
}

