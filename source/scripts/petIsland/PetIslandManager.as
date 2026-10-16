package petIsland
{
   import ddt.CoreManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.Event;
   import hallIcon.HallIconManager;
   import petIsland.event.PetIslandEvent;
   import petIsland.model.PetIslandModel;
   import road7th.comm.PackageIn;
   
   public class PetIslandManager extends CoreManager
   {
      
      private static var _instance:PetIslandManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      public static const SHOWMAINVIEW:String = "showMainView";
      
      public var model:PetIslandModel;
      
      private var type:int;
      
      public function PetIslandManager()
      {
         super();
      }
      
      public static function get instance() : PetIslandManager
      {
         if(!_instance)
         {
            _instance = new PetIslandManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.model = new PetIslandModel();
         SocketManager.Instance.addEventListener("petIslandInit",this.initHandler);
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["petIsland"],this.onLoadedNew);
      }
      
      private function onLoadedNew() : void
      {
         dispatchEvent(new Event("showMainView"));
      }
      
      private function initHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:PackageIn = param1.pkg;
         var _loc6_:int = param1._cmd;
         switch(int(_loc6_) - 186)
         {
            case 0:
               this.model.isOpen = param1.pkg.readBoolean();
               if(this.model.isOpen)
               {
                  this.showEnterIcon();
               }
               else
               {
                  this.hideEnterIcon();
                  if(StateManager.currentStateType == "petIsland")
                  {
                     StateManager.setState("main");
                  }
               }
               break;
            case 1:
               _loc2_ = param1.pkg.readInt();
               this.model.openType = param1.pkg.readInt();
               this.model.playerBlood = param1.pkg.readInt();
               this.model.currentLevel = param1.pkg.readInt();
               this.model.round = param1.pkg.readInt();
               this.model.step = param1.pkg.readInt();
               this.model.playerScore = param1.pkg.readInt();
               this.model.npcBlood = param1.pkg.readInt();
               this.model.npcScore = param1.pkg.readInt();
               this.model.rewardRecord = param1.pkg.readUTF();
               this.model.saveLifeCount = param1.pkg.readInt();
               this.model.saveLife2Count = param1.pkg.readInt();
               if(_loc2_ == 1)
               {
                  show();
               }
               else if(_loc2_ == 2)
               {
                  dispatchEvent(new PetIslandEvent("refresh"));
               }
               break;
            case 2:
               _loc3_ = param1.pkg.readInt();
               if(_loc3_ == 1)
               {
                  this.model.saveLifeCount = param1.pkg.readInt();
               }
               else if(_loc3_ == 2)
               {
                  this.model.saveLife2Count = param1.pkg.readInt();
               }
               dispatchEvent(new PetIslandEvent("saveLifeCount",_loc3_));
               break;
            case 4:
               this.model.rewardRecord = param1.pkg.readUTF();
               break;
            case 5:
               _loc4_ = param1.pkg.readBoolean();
               dispatchEvent(new PetIslandEvent("stepChange",_loc4_));
         }
      }
      
      public function showEnterIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.petDisappearMinLevel)
         {
            HallIconManager.instance.updateSwitchHandler("petIsland",true);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit("petIsland",true,25);
         }
      }
      
      public function hideEnterIcon() : void
      {
         PetIslandManager.instance.model.infoStr = "";
         HallIconManager.instance.updateSwitchHandler("petIsland",false);
         HallIconManager.instance.executeCacheRightIconLevelLimit("petIsland",false);
      }
   }
}

