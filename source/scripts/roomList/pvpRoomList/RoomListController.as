package roomList.pvpRoomList
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.constants.CacheConsts;
   import ddt.data.player.FriendListPlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.AcademyManager;
   import ddt.manager.EffortMovieClipManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.PlayerTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StatisticManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.view.MainToolBar;
   import ddt.view.tips.PlayerTip;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import par.ParticleManager;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.LookupEnumerate;
   import roomList.LookupRoomFrame;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   
   public class RoomListController extends BaseStateView
   {
      
      private static var isShowTutorial:Boolean = false;
      
      private var _model:RoomListModel;
      
      private var _container:Sprite;
      
      private var _view:RoomListView;
      
      private var _createRoomView:RoomListCreateRoomView;
      
      private var _findRoom:LookupRoomFrame;
      
      public function RoomListController()
      {
         super();
      }
      
      public static function disorder(param1:Array) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:RoomInfo = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = Math.random() * 10000 % param1.length;
            _loc3_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc2_];
            param1[_loc2_] = _loc3_;
            _loc4_++;
         }
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            if(!(param1[_loc6_] as RoomInfo).isPlaying)
            {
               _loc5_.push(param1[_loc6_]);
            }
            else
            {
               _loc5_.unshift(param1[_loc6_]);
            }
            _loc6_++;
         }
         return _loc5_;
      }
      
      private function init() : void
      {
         this._model = new RoomListModel();
         this._container = new Sprite();
         this._container.graphics.beginFill(0,0);
         this._container.graphics.drawRect(0,0,1000,600);
         this._container.graphics.endFill();
         this._view = new RoomListView(this,this._model);
         this._container.addChild(this._view);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
         this._container.addEventListener(MouseEvent.CLICK,this.__containerClick);
         PlayerTipManager.instance.addEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      private function __addRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RoomInfo = null;
         var _loc4_:Array = [];
         var _loc5_:PackageIn = param1.pkg;
         this._model.roomTotal = _loc5_.readInt();
         var _loc6_:int = _loc5_.readInt();
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = _loc5_.readInt();
            _loc3_ = this._model.getRoomById(_loc2_);
            if(_loc3_ == null)
            {
               _loc3_ = new RoomInfo();
            }
            _loc3_.ID = _loc2_;
            _loc3_.type = _loc5_.readByte();
            _loc3_.timeType = _loc5_.readByte();
            _loc3_.totalPlayer = _loc5_.readByte();
            _loc3_.viewerCnt = _loc5_.readByte();
            _loc3_.maxViewerCnt = _loc5_.readByte();
            _loc3_.placeCount = _loc5_.readByte();
            _loc3_.IsLocked = _loc5_.readBoolean();
            _loc3_.mapId = _loc5_.readInt();
            _loc3_.isPlaying = _loc5_.readBoolean();
            _loc3_.Name = _loc5_.readUTF();
            _loc3_.gameMode = _loc5_.readByte();
            _loc3_.hardLevel = _loc5_.readByte();
            _loc3_.levelLimits = _loc5_.readInt();
            _loc4_.push(_loc3_);
            _loc7_++;
         }
         this.updataRoom(_loc4_);
      }
      
      private function updataRoom(param1:Array) : void
      {
         if(param1.length == 0)
         {
            this._model.updateRoom(param1);
            return;
         }
         if((param1[0] as RoomInfo).type <= 2)
         {
            this._model.updateRoom(param1);
         }
      }
      
      private function __addWaitingPlayer(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PlayerInfo = null;
         var _loc3_:PackageIn = param1.pkg;
         _loc2_ = PlayerManager.Instance.findPlayer(_loc3_.clientId);
         _loc2_.beginChanges();
         _loc2_.Grade = _loc3_.readInt();
         _loc2_.Sex = _loc3_.readBoolean();
         _loc2_.NickName = _loc3_.readUTF();
         _loc2_.typeVIP = _loc3_.readByte();
         _loc2_.VIPLevel = _loc3_.readInt();
         _loc2_.ConsortiaName = _loc3_.readUTF();
         _loc2_.Offer = _loc3_.readInt();
         _loc2_.WinCount = _loc3_.readInt();
         _loc2_.TotalCount = _loc3_.readInt();
         _loc2_.EscapeCount = _loc3_.readInt();
         _loc2_.ConsortiaID = _loc3_.readInt();
         _loc2_.Repute = _loc3_.readInt();
         _loc2_.IsMarried = _loc3_.readBoolean();
         if(_loc2_.IsMarried)
         {
            _loc2_.SpouseID = _loc3_.readInt();
            _loc2_.SpouseName = _loc3_.readUTF();
         }
         _loc2_.LoginName = _loc3_.readUTF();
         _loc2_.FightPower = _loc3_.readInt();
         _loc2_.apprenticeshipState = _loc3_.readInt();
         _loc2_.commitChanges();
         this._model.addWaitingPlayer(_loc2_);
      }
      
      private function __removeWaitingPlayer(param1:CrazyTankSocketEvent) : void
      {
         this._model.removeWaitingPlayer(param1.pkg.clientId);
      }
      
      public function setRoomShowMode(param1:int) : void
      {
         this._model.roomShowMode = param1;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         SoundManager.instance.playMusic("062");
         super.enter(param1,param2);
         ++StatisticManager.loginRoomListNum;
         SocketManager.Instance.out.sendCurrentState(1);
         this.init();
         this.initEvent();
         SocketManager.Instance.out.sendSceneLogin(LookupEnumerate.ROOM_LIST);
         MainToolBar.Instance.show();
         ParticleManager.initPartical(PathManager.FLASHSITE);
         EffortMovieClipManager.Instance.show();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_FIGHT,1200);
         NewHandContainer.Instance.clearArrowByID(1);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CREATE_ROOM_TIP))
         {
            NewHandContainer.Instance.showArrow(ArrowType.CREAT_ROOM,0,"trainer.creatRoomArrowPos","asset.trainer.creatRoomTipAsset","trainer.creatRoomTipPos");
         }
         AcademyManager.Instance.showAlert();
         PlayerManager.Instance.Self.isUpGradeInGame = false;
         PlayerManager.Instance.Self.sendOverTimeListByBody();
      }
      
      private function __modelCompleted(param1:Event) : void
      {
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         this.dispose();
         GameInSocketOut.sendExitScene();
         MainToolBar.Instance.hide();
         PlayerManager.Instance.Self.sendOverTimeListByBody();
         super.leaving(param1);
      }
      
      override public function getView() : DisplayObject
      {
         return this._container;
      }
      
      override public function getType() : String
      {
         return StateType.ROOM_LIST;
      }
      
      public function sendGoIntoRoom(param1:RoomInfo) : void
      {
      }
      
      public function showFindRoom() : void
      {
         if(Boolean(this._findRoom))
         {
            this._findRoom.dispose();
         }
         this._findRoom = null;
         this._findRoom = ComponentFactory.Instance.creat("roomList.RoomList.lookupFrame");
         LayerManager.Instance.addToLayer(this._findRoom,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      protected function __containerClick(param1:MouseEvent) : void
      {
      }
      
      protected function __onChanllengeClick(param1:Event) : void
      {
         if(PlayerTipManager.instance.info.Grade < 12)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.cantBeChallenged"));
            return;
         }
         if(PlayerTipManager.instance.info.playerState.StateID == 0 && param1.target.info is FriendListPlayer)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.friendOffline"));
            return;
         }
         var _loc2_:int = int(Math.random() * RoomListCreateRoomView.PREWORD.length);
         GameInSocketOut.sendCreateRoom(RoomListCreateRoomView.PREWORD[_loc2_],RoomInfo.CHALLENGE_ROOM,2,"");
         RoomManager.Instance.tempInventPlayerID = PlayerTipManager.instance.info.ID;
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
      }
      
      override public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.CREAT_ROOM);
         PlayerTipManager.instance.removeEventListener(PlayerTip.CHALLENGE,this.__onChanllengeClick);
         if(Boolean(this._createRoomView))
         {
            this._createRoomView.dispose();
         }
         if(Boolean(this._findRoom))
         {
            this._findRoom.dispose();
         }
         if(Boolean(this._model))
         {
            this._model.dispose();
         }
         this._createRoomView = null;
         this._view.dispose();
         this._view = null;
         this._model = null;
         this._findRoom = null;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOMLIST_UPDATE,this.__addRoom);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_ADD_USER,this.__addWaitingPlayer);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SCENE_REMOVE_USER,this.__removeWaitingPlayer);
         this._container.removeEventListener(MouseEvent.CLICK,this.__containerClick);
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      public function showCreateView() : void
      {
         if(this._createRoomView != null)
         {
            this._createRoomView.dispose();
         }
         this._createRoomView = null;
         this._createRoomView = ComponentFactory.Instance.creat("roomList.pvpRoomList.RoomListCreateRoomView");
         LayerManager.Instance.addToLayer(this._createRoomView,LayerManager.GAME_DYNAMIC_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

