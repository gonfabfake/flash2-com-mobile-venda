package foodActivity
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.manager.LanguageMgr;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import foodActivity.event.FoodActivityEvent;
   import foodActivity.view.FoodActivityFrame;
   import road7th.comm.PackageIn;
   
   public class FoodActivityControl
   {
      
      private static var _instance:FoodActivityControl;
      
      private var _frame:FoodActivityFrame;
      
      public function FoodActivityControl()
      {
         super();
      }
      
      public static function get Instance() : FoodActivityControl
      {
         if(_instance == null)
         {
            _instance = new FoodActivityControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         FoodActivityManager.Instance.addEventListener(FoodActivityEvent.FOOD_OPENVIEW,this.__onOpenView);
         FoodActivityManager.Instance.addEventListener(FoodActivityEvent.FOOD_UPDATEVIEW,this.__onUpdateView);
         FoodActivityManager.Instance.addEventListener(FoodActivityEvent.FOOD_CLOSEVIEW,this.__onCloseView);
         FoodActivityManager.Instance.addEventListener(FoodActivityEvent.FOOD_REWARD,this.__onGetReward);
      }
      
      protected function __onGetReward(param1:FoodActivityEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         FoodActivityManager.Instance.ripeNum = _loc2_.readInt();
         if(_loc3_)
         {
            if(Boolean(this._frame))
            {
               this._frame.updateBoxMc();
               if(FoodActivityManager.Instance.info.activityChildType == 0)
               {
                  if(FoodActivityManager.Instance.cookingCount == 0)
                  {
                     FoodActivityManager.Instance.startTime();
                  }
                  else
                  {
                     FoodActivityManager.Instance.endTime();
                  }
               }
            }
         }
         else if(Boolean(this._frame))
         {
            this._frame.failRewardUpdate();
         }
      }
      
      protected function __onCloseView(param1:FoodActivityEvent) : void
      {
         this.disposeFrame();
      }
      
      private function __onUpdateView(param1:FoodActivityEvent) : void
      {
         if(Boolean(this._frame))
         {
            this._frame.updateProgress();
         }
      }
      
      public function disposeFrame() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.dispose();
         }
         this._frame = null;
      }
      
      protected function __onOpenView(param1:FoodActivityEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener("close",this._loadingCloseHandle);
         UIModuleLoader.Instance.addEventListener("uiModuleComplete",this._loaderCompleteHandle);
         UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this._loaderProgressHandle);
         UIModuleLoader.Instance.addEventListener("uiModuleError",this._loaderErrorHandle);
         UIModuleLoader.Instance.addUIModuleImp("foodactivity");
      }
      
      protected function _loaderCompleteHandle(param1:UIModuleEvent) : void
      {
         if(param1.module == "foodactivity")
         {
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this._loaderCompleteHandle);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this._loaderProgressHandle);
            UIModuleLoader.Instance.removeEventListener("uiModuleError",this._loaderErrorHandle);
            UIModuleSmallLoading.Instance.removeEventListener("close",this._loadingCloseHandle);
            UIModuleSmallLoading.Instance.hide();
            this._frame = ComponentFactory.Instance.creatCustomObject("foodActivity.frame");
            this._frame.titleText = LanguageMgr.GetTranslation("foodActivity.frame.title");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
      }
      
      protected function _loaderErrorHandle(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener("uiModuleError",this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener("close",this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
      
      protected function _loaderProgressHandle(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      protected function _loadingCloseHandle(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this._loaderCompleteHandle);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this._loaderProgressHandle);
         UIModuleLoader.Instance.removeEventListener("uiModuleError",this._loaderErrorHandle);
         UIModuleSmallLoading.Instance.removeEventListener("close",this._loadingCloseHandle);
         UIModuleSmallLoading.Instance.hide();
      }
   }
}

