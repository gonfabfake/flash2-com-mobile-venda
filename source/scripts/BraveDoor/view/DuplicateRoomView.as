package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.data.BraveDoorListModel;
   import BraveDoor.event.BraveDoorEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import room.model.RoomInfo;
   import roomList.RoomListEnumerate;
   
   public class DuplicateRoomView extends Sprite implements Disposeable
   {
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _itemList:SimpleTileList;
      
      private var _createRoom:BaseButton;
      
      private var _fastAdd:BaseButton;
      
      private var _control:BraveDoorControl;
      
      private var _data:BraveDoorListModel;
      
      private var _last_creat:uint;
      
      private var _tempRoomData:Array;
      
      public function DuplicateRoomView(param1:BraveDoorListModel)
      {
         this._data = param1;
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set control(param1:BraveDoorControl) : void
      {
         if(Boolean(this._control))
         {
            this._control.removeEventListener("updateSelectDuplicate",this._updateDuplidateHandler);
         }
         this._control = param1;
         if(Boolean(this._control))
         {
            this._control.addEventListener("updateSelectDuplicate",this._updateDuplidateHandler);
         }
      }
      
      protected function initView() : void
      {
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateRoom.nextBtn");
         addChild(this._nextBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateRoom.preBtn");
         addChild(this._preBtn);
         this._createRoom = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateRoom.createRoomBtn");
         addChild(this._createRoom);
         this._fastAdd = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateRoom.fastAddBtn");
         addChild(this._fastAdd);
         this._itemList = ComponentFactory.Instance.creat("braveDoor.duplicateRoom.roomItemList",[1]);
         this._itemList.x = 716;
         this._itemList.y = 99;
         addChild(this._itemList);
         this.updateBtnState(false);
      }
      
      protected function initEvent() : void
      {
         this._data.addEventListener("BraveDoorRoomListUpdate",this.__updateRoom);
         this._createRoom.addEventListener("click",this.__createRoom_Handler);
         this._fastAdd.addEventListener("click",this.__fastAddHandler);
         this._nextBtn.addEventListener("click",this.__pageDownHandler);
         this._preBtn.addEventListener("click",this.__pageDownHandler);
      }
      
      private function removeEvent() : void
      {
         this._data.removeEventListener("BraveDoorRoomListUpdate",this.__updateRoom);
         this._createRoom.removeEventListener("click",this.__createRoom_Handler);
         this._fastAdd.removeEventListener("click",this.__fastAddHandler);
         this._nextBtn.removeEventListener("click",this.__pageDownHandler);
         this._preBtn.removeEventListener("click",this.__pageDownHandler);
         if(Boolean(this._control))
         {
            this._control.removeEventListener("updateSelectDuplicate",this._updateDuplidateHandler);
         }
      }
      
      private function __pageDownHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendUpdateRoomList(7,-2);
      }
      
      private function _updateDuplidateHandler(param1:BraveDoorEvent) : void
      {
         this.__createRoom_Handler(null);
      }
      
      private function __fastAddHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendGameLogin(7,49);
      }
      
      private function __createRoom_Handler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(getTimer() - this._last_creat >= 2000)
         {
            this._last_creat = getTimer();
            GameInSocketOut.sendCreateRoom(RoomListEnumerate.PREWORD[int(Math.random() * RoomListEnumerate.PREWORD.length)],49,3);
         }
      }
      
      private function __updateRoom(param1:Event) : void
      {
         this.upadteRoomItem();
         if(this._itemList != null && this._itemList.numChildren > 0)
         {
            this.updateBtnState(true);
         }
      }
      
      private function updateBtnState(param1:Boolean) : void
      {
         this._nextBtn.enable = this._preBtn.enable = this._fastAdd.enable = param1;
      }
      
      private function upadteRoomItem() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = null;
         this._tempRoomData = this.currentDataList;
         if(this._tempRoomData == null)
         {
            return;
         }
         if(this._itemList.numChildren > 0)
         {
            this._itemList.disposeAllChildren();
         }
         for each(_loc2_ in this._tempRoomData)
         {
            if(Boolean(_loc2_))
            {
               _loc1_ = new DuplicateRoomItemView(_loc2_);
               if(Boolean(_loc2_.isPlaying))
               {
                  _loc1_.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               }
               else
               {
                  _loc1_.filters = null;
               }
               _loc1_.addEventListener("click",this.__itemClick,false,0,true);
               this._itemList.addChild(_loc1_);
            }
         }
      }
      
      public function update() : void
      {
         this.__updateRoom(null);
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DuplicateRoomItemView = param1.currentTarget as DuplicateRoomItemView;
         if(!_loc2_.info.isPlaying)
         {
            this.gotoIntoRoom(_loc2_.info);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.start"));
         }
      }
      
      public function gotoIntoRoom(param1:RoomInfo) : void
      {
         SocketManager.Instance.out.sendGameLogin(7,-1,param1.ID,"");
      }
      
      public function get currentDataList() : Array
      {
         if(this._data != null)
         {
            return this._data.getRoomList().list;
         }
         return null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._nextBtn))
         {
            ObjectUtils.disposeObject(this._nextBtn);
         }
         this._nextBtn = null;
         if(Boolean(this._preBtn))
         {
            ObjectUtils.disposeObject(this._preBtn);
         }
         this._preBtn = null;
         if(Boolean(this._createRoom))
         {
            ObjectUtils.disposeObject(this._createRoom);
         }
         this._createRoom = null;
         if(Boolean(this._fastAdd))
         {
            ObjectUtils.disposeObject(this._fastAdd);
         }
         this._fastAdd = null;
         if(Boolean(this._itemList))
         {
            this._itemList.disposeAllChildren();
            removeChild(this._itemList);
         }
         this._itemList = null;
         this._data = null;
         this._control = null;
      }
   }
}

