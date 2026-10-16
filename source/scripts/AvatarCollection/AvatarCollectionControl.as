package AvatarCollection
{
   import AvatarCollection.view.AvatarCollectionMainView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.utils.HelperDataModuleLoad;
   import flash.display.Sprite;
   
   public class AvatarCollectionControl
   {
      
      private static var _instance:AvatarCollectionControl;
      
      private var _view:AvatarCollectionMainView;
      
      public function AvatarCollectionControl()
      {
         super();
      }
      
      public static function get instance() : AvatarCollectionControl
      {
         if(!_instance)
         {
            _instance = new AvatarCollectionControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         AvatarCollectionManager.instance.addEventListener("openview",this.__onOpenView);
      }
      
      private function __onOpenView(param1:CEvent) : void
      {
         new HelperDataModuleLoad().loadDataModule([StartupResourceLoader.Instance.createAvatarCollectionItemDataLoader()],this.createFrame,[param1]);
      }
      
      private function createFrame(param1:CEvent) : void
      {
         var _loc2_:* = null;
         if(!this._view)
         {
            _loc2_ = param1.data.parent as Sprite;
            this._view = new AvatarCollectionMainView();
            _loc2_.addChild(this._view);
            AvatarCollectionManager.instance.addEventListener("closeView",this.__onCloseView);
            AvatarCollectionManager.instance.addEventListener("visible",this.__onVisible);
            AvatarCollectionManager.instance.addEventListener("avatar_collection_select_all",this.__onSelectAll);
            AvatarCollectionManager.instance.addEventListener("reset_left",this.__onResetLeft);
         }
      }
      
      protected function __onResetLeft(param1:CEvent) : void
      {
         this._view.reset();
      }
      
      protected function __onSelectAll(param1:CEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = int(this._view.unitList.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = this._view.unitList[_loc2_].list.list.cell;
            for each(_loc5_ in _loc3_)
            {
               _loc5_.select = param1.data;
            }
            _loc2_++;
         }
      }
      
      private function __onVisible(param1:CEvent) : void
      {
         if(Boolean(this._view))
         {
            this._view.visible = param1.data.visible;
         }
      }
      
      private function __onCloseView(param1:CEvent) : void
      {
         AvatarCollectionManager.instance.removeEventListener("closeView",this.__onCloseView);
         AvatarCollectionManager.instance.removeEventListener("visible",this.__onVisible);
         ObjectUtils.disposeObject(this._view);
         this._view = null;
      }
   }
}

