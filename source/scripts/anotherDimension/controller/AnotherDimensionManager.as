package anotherDimension.controller
{
   import anotherDimension.model.AnotherDimensionInfo;
   import anotherDimension.model.AnotherDimensionMsgInfo;
   import anotherDimension.model.AnotherDimensionResourceInfo;
   import ddt.CoreManager;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.Event;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class AnotherDimensionManager extends CoreManager
   {
      
      private static var _instance:AnotherDimensionManager;
      
      public static const SHOWMAINVIEW:String = "showMainView";
      
      public static const UPDATEVIEW:String = "updateView";
      
      public static const UPDATE_RESOURCEDATA:String = "updateResourceData";
      
      public static const ADDMSG:String = "addMsg";
      
      public var resourceList:Array;
      
      public var haveResourceList:Array;
      
      public var gameOver:Boolean;
      
      public var isOpen:Boolean = false;
      
      public var anotherDimensionInfo:AnotherDimensionInfo;
      
      public var msgArr:Array;
      
      public var showBuyCountFram:Boolean = true;
      
      private var refreshOnly:int;
      
      public function AnotherDimensionManager()
      {
         super();
      }
      
      public static function get Instance() : AnotherDimensionManager
      {
         if(_instance == null)
         {
            _instance = new AnotherDimensionManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener("anotherDimension",this.pkgHandler);
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule(["anotherDimension"],this.onLoadedNew);
      }
      
      private function onLoadedNew() : void
      {
         dispatchEvent(new Event("showMainView"));
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         switch(int(_loc3_) - 1)
         {
            case 0:
               this.openOrClose(_loc2_);
               break;
            case 1:
               this.updateInfo(_loc2_);
               break;
            case 2:
               this.openMainView(_loc2_);
               break;
            case 3:
               this.updateResource(_loc2_);
               break;
            case 6:
               this.receiveMsg(_loc2_);
         }
      }
      
      private function receiveMsg(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         if(this.msgArr == null)
         {
            this.msgArr = [];
         }
         var _loc8_:Boolean = param1.readBoolean();
         if(_loc8_)
         {
            _loc2_ = param1.readInt();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = new AnotherDimensionMsgInfo();
               _loc4_.userID = param1.readInt();
               _loc4_.ownUserID = param1.readInt();
               _loc4_.ownName = param1.readUTF();
               _loc4_.resPos = param1.readInt();
               _loc4_.restatus = param1.readInt();
               if(this.msgArr.length < 30)
               {
                  this.msgArr.push(_loc4_);
               }
               _loc3_++;
            }
         }
         else
         {
            _loc5_ = param1.readInt();
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = new AnotherDimensionMsgInfo();
               _loc7_.userID = param1.readInt();
               _loc7_.ownUserID = param1.readInt();
               _loc7_.ownName = param1.readUTF();
               _loc7_.resPos = param1.readInt();
               _loc7_.restatus = param1.readInt();
               if(this.msgArr.length < 30)
               {
                  this.msgArr.unshift(_loc7_);
               }
               else
               {
                  this.msgArr.unshift(_loc7_);
                  this.msgArr.pop();
               }
               _loc6_++;
            }
         }
         dispatchEvent(new Event("addMsg"));
      }
      
      private function openMainView(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         this.resourceList = [];
         this.haveResourceList = [];
         this.gameOver = false;
         var _loc8_:int = param1.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc8_)
         {
            _loc3_ = new AnotherDimensionResourceInfo();
            _loc3_.isHave = false;
            _loc3_.resourcePos = param1.readInt();
            _loc3_.monsterId = param1.readInt();
            if(_loc3_.monsterId == 0)
            {
               _loc4_ = new PlayerInfo();
               _loc4_.ID = param1.readInt();
               _loc4_.NickName = param1.readUTF();
               _loc5_ = param1.readInt();
               _loc4_.Sex = _loc5_ == 0 ? false : true;
               _loc4_.Hide = param1.readInt();
               _loc4_.Style = param1.readUTF();
               _loc4_.Colors = param1.readUTF();
               _loc4_.Skin = param1.readUTF();
               _loc4_.Grade = param1.readInt();
               _loc3_.resourcePlayerInfo = _loc4_;
            }
            else
            {
               param1.readInt();
               param1.readUTF();
               param1.readInt();
               param1.readInt();
               param1.readUTF();
               param1.readUTF();
               param1.readUTF();
               param1.readInt();
            }
            param1.readInt();
            _loc3_.resourceLevel = param1.readInt();
            _loc3_.resourceState = param1.readInt();
            _loc3_.haveResourceTime = param1.readDate();
            _loc3_.lastMaxMunites = param1.readInt();
            _loc3_.itemId = param1.readInt();
            _loc3_.itemCountPerHour = param1.readInt();
            this.resourceList.push(_loc3_);
            _loc2_++;
         }
         var _loc9_:int = param1.readInt();
         var _loc10_:int = 3;
         _loc6_ = 0;
         while(_loc6_ < _loc9_)
         {
            _loc7_ = new AnotherDimensionResourceInfo();
            _loc10_++;
            _loc7_.isHave = true;
            _loc7_.resourcePos = _loc10_;
            _loc7_.resourcePlayerInfo = PlayerManager.Instance.Self;
            _loc7_.resourceLevel = param1.readInt();
            _loc7_.haveResourceTime = param1.readDate();
            _loc7_.haveResourceLast = param1.readInt();
            _loc7_.lastMaxMunites = _loc7_.haveResourceLast;
            _loc7_.itemId = param1.readInt();
            _loc7_.itemCountPerHour = param1.readInt();
            this.haveResourceList.push(_loc7_);
            _loc6_++;
         }
         show();
      }
      
      private function updateInfo(param1:PackageIn) : void
      {
         var _loc2_:Boolean = false;
         this.anotherDimensionInfo = new AnotherDimensionInfo();
         this.anotherDimensionInfo.occupyCount = param1.readInt();
         this.anotherDimensionInfo.totalOccupyCount = param1.readInt();
         this.anotherDimensionInfo.lootCount = param1.readInt();
         this.anotherDimensionInfo.totalLootCount = param1.readInt();
         this.anotherDimensionInfo.refreshCount = param1.readInt();
         if(this.anotherDimensionInfo.refreshCount != this.refreshOnly)
         {
            _loc2_ = true;
         }
         this.anotherDimensionInfo.timeControlLv = param1.readInt();
         this.anotherDimensionInfo.timeControlExp = param1.readInt();
         this.anotherDimensionInfo.spaceControlLv = param1.readInt();
         this.anotherDimensionInfo.spaceControlExp = param1.readInt();
         this.anotherDimensionInfo.looterControlLv = param1.readInt();
         this.anotherDimensionInfo.looterControlExp = param1.readInt();
         this.refreshOnly = this.anotherDimensionInfo.refreshCount;
         if(!_loc2_)
         {
            dispatchEvent(new Event("updateView"));
         }
      }
      
      private function openOrClose(param1:PackageIn) : void
      {
         this.isOpen = param1.readBoolean();
         this.checkShowIcon();
      }
      
      private function updateResource(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         this.resourceList = [];
         this.haveResourceList = [];
         var _loc8_:int = param1.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc8_)
         {
            _loc3_ = new AnotherDimensionResourceInfo();
            _loc3_.isHave = false;
            _loc3_.resourcePos = param1.readInt();
            _loc3_.monsterId = param1.readInt();
            if(_loc3_.monsterId == 0)
            {
               _loc4_ = new PlayerInfo();
               _loc4_.ID = param1.readInt();
               _loc4_.NickName = param1.readUTF();
               _loc5_ = param1.readInt();
               _loc4_.Sex = _loc5_ == 0 ? false : true;
               _loc4_.Hide = param1.readInt();
               _loc4_.Style = param1.readUTF();
               _loc4_.Colors = param1.readUTF();
               _loc4_.Skin = param1.readUTF();
               _loc4_.Grade = param1.readInt();
               _loc3_.resourcePlayerInfo = _loc4_;
            }
            else
            {
               param1.readInt();
               param1.readUTF();
               param1.readInt();
               param1.readInt();
               param1.readUTF();
               param1.readUTF();
               param1.readUTF();
               param1.readInt();
            }
            param1.readInt();
            _loc3_.resourceLevel = param1.readInt();
            _loc3_.resourceState = param1.readInt();
            _loc3_.haveResourceTime = param1.readDate();
            _loc3_.lastMaxMunites = param1.readInt();
            _loc3_.itemId = param1.readInt();
            _loc3_.itemCountPerHour = param1.readInt();
            this.resourceList.push(_loc3_);
            _loc2_++;
         }
         var _loc9_:int = param1.readInt();
         var _loc10_:int = 3;
         _loc6_ = 0;
         while(_loc6_ < _loc9_)
         {
            _loc7_ = new AnotherDimensionResourceInfo();
            _loc10_++;
            _loc7_.isHave = true;
            _loc7_.resourcePos = _loc10_;
            _loc7_.resourcePlayerInfo = PlayerManager.Instance.Self;
            _loc7_.resourceLevel = param1.readInt();
            _loc7_.haveResourceTime = param1.readDate();
            _loc7_.haveResourceLast = param1.readInt();
            _loc7_.lastMaxMunites = _loc7_.haveResourceLast;
            _loc7_.itemId = param1.readInt();
            _loc7_.itemCountPerHour = param1.readInt();
            this.haveResourceList.push(_loc7_);
            _loc6_++;
         }
         dispatchEvent(new Event("updateResourceData"));
      }
      
      public function checkShowIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 30)
         {
            HallIconManager.instance.updateSwitchHandler("buried",this.isOpen);
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit("buried",this.isOpen,30);
         }
      }
   }
}

