package BraveDoor
{
   import BraveDoor.data.BraveDoorListModel;
   import BraveDoor.event.BraveDoorEvent;
   import BraveDoor.view.BraveDoorFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.StatisticManager;
   import flash.events.EventDispatcher;
   import flash.utils.setTimeout;
   import road7th.comm.PackageIn;
   import room.model.RoomInfo;
   import roomList.LookupRoomFrame;
   
   public class BraveDoorControl extends EventDispatcher
   {
      
      private static var _instance:BraveDoorControl;
      
      public static const ROOM:int = 1;
      
      public static const TEM:int = 2;
      
      private var _frame:BraveDoorFrame = null;
      
      private var _model:BraveDoorListModel;
      
      private var _findRoom:LookupRoomFrame;
      
      private var _currentRoomType:int = 1;
      
      private var _enterRoomType:int = 0;
      
      private var _isLockSwitchView:Boolean = false;
      
      public function BraveDoorControl()
      {
         super();
      }
      
      public static function get instance() : BraveDoorControl
      {
         if(!_instance)
         {
            _instance = new BraveDoorControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         BraveDoorManager.instance.addEventListener("openBraveDoorView",this.openView_Handler);
      }
      
      public function openView_Handler(param1:CEvent) : void
      {
         this.enter();
      }
      
      public function enter() : void
      {
         this.init();
      }
      
      private function init() : void
      {
         this._model = new BraveDoorListModel();
         StateManager.createStateAsync("braveDoorRoom",this.initBraveDoorView);
      }
      
      private function initBraveDoorView(param1:CEvent) : void
      {
         if(this._frame != null)
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         this._frame = ComponentFactory.Instance.creat("ddt.braveDoor.braveDoorFrame",[this,this._model]);
         if(Boolean(this._frame))
         {
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
            this.initEvents();
            StateManager.currentStateType = "braveDoorRoom";
         }
         SocketManager.Instance.out.sendCurrentState(1);
         ++StatisticManager.loginRoomListNum;
         SocketManager.Instance.out.sendUpdateRoomList(7,3);
         CacheSysManager.unlock("alertInFight");
         CacheSysManager.getInstance().release("alertInFight",1200);
         AcademyManager.Instance.showAlert();
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         PlayerManager.Instance.Self.sendOverTimeListByBody();
         if(this._isLockSwitchView)
         {
            this.switchView(this._enterRoomType);
            this.unLockSwitchView();
         }
      }
      
      private function __updateRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:Array = [];
         var _loc6_:PackageIn = param1.pkg;
         this._model.roomTotal = _loc6_.readInt();
         var _loc7_:int = _loc6_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = _loc6_.readInt();
            _loc4_ = this._model.getRoomById(_loc3_);
            if(_loc4_ == null)
            {
               _loc4_ = new RoomInfo();
            }
            _loc4_.ID = _loc3_;
            _loc4_.type = _loc6_.readUnsignedByte();
            _loc4_.timeType = _loc6_.readByte();
            _loc4_.totalPlayer = _loc6_.readByte();
            _loc4_.viewerCnt = _loc6_.readByte();
            _loc4_.maxViewerCnt = _loc6_.readByte();
            _loc4_.placeCount = _loc6_.readByte();
            _loc4_.IsLocked = _loc6_.readBoolean();
            _loc4_.mapId = _loc6_.readInt();
            _loc4_.isPlaying = _loc6_.readBoolean();
            _loc4_.Name = _loc6_.readUTF();
            _loc4_.gameMode = _loc6_.readByte();
            _loc4_.hardLevel = _loc6_.readByte();
            _loc4_.levelLimits = _loc6_.readInt();
            if(_loc4_.type != 10)
            {
               _loc5_.push(_loc4_);
            }
            _loc2_++;
         }
         this.updateRoomInfo(_loc5_);
      }
      
      private function updateRoomInfo(param1:Array) : void
      {
         this._model.updateRoom(param1);
      }
      
      public function updateRoomMap(param1:int) : void
      {
         var $duplicateId:int = 0;
         $duplicateId = param1;
         this.dispatchEvent(new BraveDoorEvent("updateSelectDuplicate",$duplicateId));
         setTimeout((function():*
         {
            var setRoom:* = undefined;
            return setRoom = function():void
            {
               sendSetRoom($duplicateId);
            };
         })(),200);
      }
      
      private function sendSetRoom(param1:int) : void
      {
         GameInSocketOut.sendGameRoomSetUp(param1,49,"","",1,0,0,false);
      }
      
      protected function initEvents() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.addEventListener("response",this.__responseHandler);
         }
         SocketManager.Instance.addEventListener("gameRoomListUpdate",this.__updateRoom);
         addEventListener("selectedDuplicate",this.setRoomMap);
      }
      
      private function setRoomMap(param1:BraveDoorEvent) : void
      {
         this.updateRoomMap(int(param1.data));
      }
      
      protected function removeEvents() : void
      {
         if(Boolean(this._frame))
         {
            this._frame.removeEventListener("response",this.__responseHandler);
         }
         SocketManager.Instance.removeEventListener("gameRoomListUpdate",this.__updateRoom);
         removeEventListener("selectedDuplicate",this.setRoomMap);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1 && this.currentRoomType == 1)
         {
            SoundManager.instance.playButtonSound();
            if(Boolean(this._frame))
            {
               ObjectUtils.disposeObject(this._frame);
               this._frame = null;
               this.hide();
            }
         }
      }
      
      public function lockSwitchView(param1:int) : void
      {
         this._isLockSwitchView = true;
         this._enterRoomType = param1;
      }
      
      public function unLockSwitchView() : void
      {
         this._isLockSwitchView = false;
         this._enterRoomType = 0;
      }
      
      public function switchView(param1:int) : void
      {
         this._currentRoomType = param1;
         if(Boolean(this._frame))
         {
            this._frame.closeButton.enable = this._currentRoomType == 1;
         }
         this.dispatchEvent(new BraveDoorEvent("switchRoomView",this._currentRoomType));
      }
      
      public function hide() : void
      {
         StateManager.currentStateType = "main";
         this.dispose();
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
      
      public function get currentRoomType() : int
      {
         return this._currentRoomType;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         BraveDoorManager.instance.moduleIsShow = false;
         this._model = null;
      }
   }
}

