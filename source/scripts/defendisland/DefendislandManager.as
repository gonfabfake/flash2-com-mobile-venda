package defendisland
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperUIModuleLoad;
   import defendisland.model.DefendislandModel;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   import road7th.utils.DateUtils;
   
   public class DefendislandManager extends EventDispatcher
   {
      
      private static var _instance:DefendislandManager;
      
      public static const SHOWMAINVIEW:String = "showMainView";
      
      public static const HIDEMAINVIEW:String = "hideMainView";
      
      public var model:DefendislandModel;
      
      public function DefendislandManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : DefendislandManager
      {
         if(_instance == null)
         {
            _instance = new DefendislandManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         var _loc1_:* = null;
         if(!this.model.isOpen)
         {
            _loc1_ = LanguageMgr.GetTranslation("tank.bible.defendislandNotOpen");
            MessageTipManager.getInstance().show(_loc1_,0,true,1);
            return;
         }
         new HelperUIModuleLoad().loadUIModule(["defendisland"],this.onComplete);
      }
      
      private function onComplete() : void
      {
         dispatchEvent(new Event("showMainView"));
      }
      
      public function setup() : void
      {
         this.model = new DefendislandModel();
         SocketManager.Instance.addEventListener("islandInfo",this._islandInfoHanlder);
      }
      
      public function templateDataSetup(param1:Array) : void
      {
         this.model.itemInfoList = param1;
      }
      
      private function _islandInfoHanlder(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:PackageIn = param1.pkg;
         var _loc5_:int = _loc4_.readInt() - 1;
         switch(_loc5_)
         {
            case 0:
               this.model.remainCountList = [];
               this.model.countList = [];
               _loc2_ = _loc4_.readInt();
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  this.model.remainCountList.push(_loc4_.readInt());
                  this.model.countList.push(_loc4_.readInt());
                  _loc3_++;
               }
               this.show();
               break;
            case 1:
               this.model.isOpen = _loc4_.readBoolean();
               this.model.beginTime = DateUtils.dateFormat(_loc4_.readDate());
               this.model.endTime = DateUtils.dateFormat(_loc4_.readDate());
               this.showIcon();
         }
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("defend_island",this.model.isOpen);
      }
   }
}

