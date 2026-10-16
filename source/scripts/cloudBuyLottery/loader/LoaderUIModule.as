package cloudBuyLottery.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.view.UIModuleSmallLoading;
   
   public class LoaderUIModule
   {
      
      private static var _instance:LoaderUIModule;
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _type:String;
      
      public function LoaderUIModule(param1:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : LoaderUIModule
      {
         if(LoaderUIModule._instance == null)
         {
            LoaderUIModule._instance = new LoaderUIModule(new PrivateClass());
         }
         return LoaderUIModule._instance;
      }
      
      public function loadUIModule(param1:Function = null, param2:Array = null, param3:String = "") : void
      {
         this._func = param1;
         this._funcParams = param2;
         this._type = param3;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(this._type);
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == this._type)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == this._type)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
