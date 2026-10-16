package anotherDimension
{
   import anotherDimension.controller.AnotherDimensionManager;
   import anotherDimension.view.AnotherDimensionMainView;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class AnotherDimensionControl extends EventDispatcher
   {
      
      private static var _instance:AnotherDimensionControl;
      
      private var _anotherDimensionMainView:AnotherDimensionMainView;
      
      public function AnotherDimensionControl()
      {
         super();
      }
      
      public static function get instance() : AnotherDimensionControl
      {
         if(!_instance)
         {
            _instance = new AnotherDimensionControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         AnotherDimensionManager.Instance.addEventListener("showMainView",this.__showHandler);
         AnotherDimensionManager.Instance.addEventListener("updateResourceData",this.__updateResourceDataHandler);
      }
      
      private function __showHandler(param1:Event) : void
      {
         this.showMainView();
      }
      
      private function __updateResourceDataHandler(param1:Event) : void
      {
         if(Boolean(this._anotherDimensionMainView))
         {
            this._anotherDimensionMainView.setResourceData();
         }
      }
      
      private function showMainView() : void
      {
         this._anotherDimensionMainView = new AnotherDimensionMainView();
         this._anotherDimensionMainView.show();
         PositionUtils.setPos(this._anotherDimensionMainView,"anotherDimension.anotherDimensionMainViewPos");
      }
      
      public function disposeMainView() : void
      {
         ObjectUtils.disposeObject(this._anotherDimensionMainView);
         this._anotherDimensionMainView = null;
      }
   }
}

