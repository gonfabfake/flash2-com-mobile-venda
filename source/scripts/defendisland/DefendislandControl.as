package defendisland
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import defendisland.view.DefendislandFrame;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class DefendislandControl extends EventDispatcher
   {
      
      private static var _instance:DefendislandControl;
      
      public var _frame:DefendislandFrame;
      
      public function DefendislandControl(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : DefendislandControl
      {
         if(!_instance)
         {
            _instance = new DefendislandControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         DefendislandManager.instance.addEventListener("showMainView",this.__showHandler);
         DefendislandManager.instance.addEventListener("hideMainView",this.__hideHandler);
      }
      
      private function __showHandler(param1:Event) : void
      {
         if(!this._frame)
         {
            this._frame = ComponentFactory.Instance.creatCustomObject("ddt.defendisland.defendislandFrame");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
         else
         {
            this._frame.setData();
         }
      }
      
      public function __hideHandler(param1:Event) : void
      {
         if(this._frame != null)
         {
            this._frame.dispose();
         }
         this._frame = null;
      }
   }
}

