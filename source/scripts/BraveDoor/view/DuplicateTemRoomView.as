package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.event.BraveDoorEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   import room.model.RoomPlayer;
   import room.view.roomView.BaseRoomView;
   
   public class DuplicateTemRoomView extends BaseRoomView
   {
      
      private static const DUPLICATE_ICON_PATH:String = "asset.braveDoor.room.duplicateTitle";
      
      private var _itemList:SimpleTileList;
      
      private var _duplicateName:Bitmap;
      
      private var _startButton:BaseButton;
      
      private var _readyButton:BaseButton;
      
      private var _cancelButton:BaseButton;
      
      private var _exitButton:BaseButton;
      
      private var _inviteButton:BaseButton;
      
      private var _temItemView:DuplicateTemRoomItemView;
      
      private var _control:BraveDoorControl = null;
      
      public function DuplicateTemRoomView(param1:RoomInfo)
      {
         super(param1);
      }
      
      public function set control(param1:BraveDoorControl) : void
      {
         this._control = param1;
      }
      
      override protected function initView() : void
      {
         this._itemList = ComponentFactory.Instance.creat("braveDoor.duplicateRoom.roomItemList",[1]);
         addChild(this._itemList);
         this.updateDuplicateName(_info.mapId);
         this._startButton = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.startBtn");
         addChild(this._startButton);
         this._readyButton = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.readyBtn");
         addChild(this._readyButton);
         this._cancelButton = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.cancelBtn");
         addChild(this._cancelButton);
         this._exitButton = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.exitBtn");
         addChild(this._exitButton);
         this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.inviteBtn");
         addChild(this._inviteButton);
         _playerItems = [];
         this.initPlayerItems();
         this.updateButtons();
      }
      
      private function updateDuplicateName(param1:int) : void
      {
         var _loc2_:String = "asset.braveDoor.room.duplicateTitle" + param1;
         if(this._duplicateName != null)
         {
            ObjectUtils.disposeObject(this._duplicateName);
            this._duplicateName = null;
         }
         this._duplicateName = ComponentFactory.Instance.creatBitmap(_loc2_);
         this._duplicateName.x = 712;
         this._duplicateName.y = 96;
         addChild(this._duplicateName);
      }
      
      override protected function updateButtons() : void
      {
         this.updateTimer();
         if(_info == null || _info.selfRoomPlayer == null)
         {
            return;
         }
         this._startButton.visible = _info.selfRoomPlayer.isHost && !_info.started;
         this._readyButton.visible = !_info.selfRoomPlayer.isHost && !_info.selfRoomPlayer.isReady;
         this._cancelButton.visible = _info.selfRoomPlayer.isHost ? _info.started : Boolean(_info.selfRoomPlayer.isReady);
         this._cancelButton.enable = _info.selfRoomPlayer.isHost || !_info.started;
         this._inviteButton.enable = this._exitButton.enable = !_info.started && !_info.selfRoomPlayer.isReady;
         if(_info.isAllReady())
         {
            this._startButton.addEventListener("click",this.__startClick);
            this._startButton.filters = null;
            this._startButton.enable = true;
         }
         else
         {
            this._startButton.removeEventListener("click",this.__startClick);
            this._startButton.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            this._startButton.enable = false;
         }
         RoomManager.Instance.isPrepare = this._readyButton.visible;
      }
      
      override protected function initPlayerItems() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         if(_info == null || _info.selfRoomPlayer == null)
         {
            return;
         }
         if(Boolean(this._itemList))
         {
            this._itemList.disposeAllChildren();
         }
         var _loc3_:int = int(_info.currentPlayers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = _info.currentPlayers[_loc2_];
            this._temItemView = new DuplicateTemRoomItemView();
            this._temItemView.info = _loc1_;
            this._itemList.addChild(this._temItemView);
            _playerItems[_loc1_.place] = this._temItemView;
            _loc2_++;
         }
      }
      
      override protected function initEvents() : void
      {
         this._inviteButton.addEventListener("click",this.__inviteClick);
         this._startButton.addEventListener("click",this.__startClick);
         this._cancelButton.addEventListener("click",this.__cancelClick);
         this._readyButton.addEventListener("click",this.__prepareClick);
         this._exitButton.addEventListener("click",this.__exitClickHandler);
         _info.addEventListener("roomplaceChanged",this.__updatePlayerItems);
         _info.addEventListener("playerStateChanged",this.__updateState);
         _info.addEventListener("addPlayer",this.__addPlayer);
         _info.addEventListener("removePlayer",this.__removePlayer);
         _info.addEventListener("startedChanged",this.__startHandler);
         _info.addEventListener("mapChanged",this.__onMapChanged);
         GameManager.Instance.addEventListener("StartLoading",this.__onStartLoad);
      }
      
      override protected function __inviteClick(param1:MouseEvent) : void
      {
         super.__inviteClick(param1);
      }
      
      override protected function removeEvents() : void
      {
         this._inviteButton.removeEventListener("click",this.__inviteClick);
         this._startButton.removeEventListener("click",this.__startClick);
         this._cancelButton.removeEventListener("click",this.__cancelClick);
         this._readyButton.removeEventListener("click",this.__prepareClick);
         this._exitButton.removeEventListener("click",this.__exitClickHandler);
         _info.removeEventListener("roomplaceChanged",this.__updatePlayerItems);
         _info.removeEventListener("playerStateChanged",this.__updateState);
         _info.removeEventListener("addPlayer",this.__addPlayer);
         _info.removeEventListener("removePlayer",this.__removePlayer);
         _info.removeEventListener("startedChanged",this.__startHandler);
         _info.removeEventListener("mapChanged",this.__onMapChanged);
         _hostTimer.removeEventListener("timer",__onHostTimer);
         _normalTimer.removeEventListener("timer",__onTimerII);
         GameManager.Instance.removeEventListener("StartLoading",this.__onStartLoad);
      }
      
      protected function __onStartLoad(param1:Event) : void
      {
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState("roomLoading",GameManager.Instance.Current);
      }
      
      protected function __onMapChanged(param1:RoomEvent) : void
      {
         var _loc2_:int = _info.mapId;
         this.updateDuplicateName(_loc2_);
      }
      
      override protected function updateTimer() : void
      {
         if(_info.selfRoomPlayer.isHost && this._startButton.buttonMode == !_info.isAllReady())
         {
            resetHostTimer();
         }
         if(!_info.selfRoomPlayer.isHost && this._readyButton.visible == _info.selfRoomPlayer.isReady)
         {
            resetNormalTimer();
         }
      }
      
      override protected function __updatePlayerItems(param1:RoomEvent) : void
      {
         this.updateButtons();
      }
      
      override protected function __updateState(param1:RoomEvent) : void
      {
         this.updateButtons();
         if(_info.selfRoomPlayer.isHost)
         {
            startHostTimer();
            stopNormalTimer();
            if(!_info.isAllReady() && _info.started)
            {
               GameInSocketOut.sendCancelWait();
               _info.started = false;
               SoundManager.instance.stop("007");
            }
         }
         else
         {
            stopHostTimer();
            startNormalTimer();
         }
      }
      
      override protected function __addPlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         this._temItemView = new DuplicateTemRoomItemView();
         this._temItemView.info = _loc2_;
         if(this._itemList.contains(this._temItemView))
         {
            this._itemList.removeChild(this._temItemView);
         }
         this._itemList.addChildAt(this._temItemView,_loc2_.place);
         this._itemList.refreshChildPos();
         _playerItems[_loc2_.place] = this._temItemView;
         this.updateButtons();
      }
      
      override protected function __removePlayer(param1:RoomEvent) : void
      {
         var _loc2_:RoomPlayer = param1.params[0] as RoomPlayer;
         this._itemList.removeChild(_playerItems[_loc2_.place]);
         _playerItems[_loc2_.place].info = null;
         _playerItems[_loc2_.place] = null;
         _loc2_.dispose();
         this._itemList.refreshChildPos();
         this.updateButtons();
      }
      
      override protected function __startClick(param1:MouseEvent) : void
      {
         if(_info.mapId > 0)
         {
            if(this.levCheck())
            {
               return;
            }
            super.__startClick(param1);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.braveDoor.noSelectDuplicate"));
         }
      }
      
      private function levCheck() : Boolean
      {
         var _loc2_:* = undefined;
         if(_info == null)
         {
            return true;
         }
         var _loc1_:int = MapManager.getBraveDoorDuplicateInfo(_info.mapId).LevelLimits;
         for each(_loc2_ in _info.currentPlayers)
         {
            if(_loc2_.playerInfo.Grade < _loc1_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.braveDoor.startGame.levCheckTip",_loc1_));
               return true;
            }
         }
         return false;
      }
      
      override protected function __prepareClick(param1:MouseEvent) : void
      {
         super.__prepareClick(param1);
      }
      
      override protected function __cancelClick(param1:MouseEvent) : void
      {
         super.__cancelClick(param1);
      }
      
      override protected function __startHandler(param1:RoomEvent) : void
      {
         this.updateButtons();
         if(_info.started)
         {
            stopHostTimer();
            SoundManager.instance.stop("007");
         }
         else if(_info.selfRoomPlayer.isHost && _info.isAllReady())
         {
            startHostTimer();
         }
      }
      
      protected function __exitClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._control == null)
         {
            return;
         }
         if(!_info.selfRoomPlayer.isReady || !_info.started)
         {
            GameInSocketOut.sendGamePlayerExit();
         }
         this._control.dispatchEvent(new BraveDoorEvent("selectedDuplicate",-1));
      }
      
      override protected function kickHandler() : void
      {
         ChatManager.Instance.sysChatRed(LanguageMgr.GetTranslation("tank.room.RoomIIView2.kick"));
         if(this._control != null)
         {
            this._control.switchView(1);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = undefined;
         this.removeEvents();
         if(Boolean(_inviteFrame))
         {
            ObjectUtils.disposeObject(_inviteFrame);
         }
         _inviteFrame = null;
         for each(_loc1_ in _playerItems)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         _playerItems = null;
         if(Boolean(_hostTimer))
         {
            _hostTimer.stop();
         }
         _hostTimer = null;
         if(Boolean(_normalTimer))
         {
            _normalTimer.stop();
         }
         _normalTimer = null;
         if(Boolean(this._itemList))
         {
            this._itemList.disposeAllChildren();
            removeChild(this._itemList);
         }
         this._itemList = null;
         if(Boolean(this._duplicateName))
         {
            ObjectUtils.disposeObject(this._duplicateName);
         }
         this._duplicateName = null;
         if(Boolean(this._startButton))
         {
            ObjectUtils.disposeObject(this._startButton);
         }
         this._startButton = null;
         if(Boolean(this._readyButton))
         {
            ObjectUtils.disposeObject(this._readyButton);
         }
         this._readyButton = null;
         if(Boolean(this._cancelButton))
         {
            ObjectUtils.disposeObject(this._cancelButton);
         }
         this._cancelButton = null;
         if(Boolean(this._exitButton))
         {
            ObjectUtils.disposeObject(this._exitButton);
         }
         this._exitButton = null;
         if(Boolean(this._inviteButton))
         {
            ObjectUtils.disposeObject(this._inviteButton);
         }
         this._inviteButton = null;
         _info = null;
         this._control = null;
         SoundManager.instance.stop("007");
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

