package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.data.BraveDoorListModel;
   import BraveDoor.event.BraveDoorEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class DuplicateListView extends Sprite implements Disposeable
   {
      
      private var _control:BraveDoorControl;
      
      private var _data:BraveDoorListModel;
      
      private var _roomView:DuplicateRoomView = null;
      
      private var _temView:DuplicateTemRoomView;
      
      private var _chatBtn:BaseButton;
      
      private var _roomInfo:RoomInfo;
      
      public function DuplicateListView()
      {
         super();
      }
      
      public function initView(param1:BraveDoorControl, param2:BraveDoorListModel) : void
      {
         this._chatBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.chatButton");
         this._chatBtn.tipData = LanguageMgr.GetTranslation("tank.game.ToolStripView.chat");
         this._control = param1;
         this._data = param2;
         this.switchRoomView();
         addChildAt(this._chatBtn,1);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._control))
         {
            this._control.addEventListener("switchRoomView",this.__switchRoom_Handler);
         }
         this._chatBtn.addEventListener("click",this.__chatClick);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._control))
         {
            this._control.removeEventListener("switchRoomView",this.__switchRoom_Handler);
         }
         this._chatBtn.removeEventListener("click",this.__chatClick);
      }
      
      private function __chatClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LayerManager.Instance.addToLayer(ChatManager.Instance.view,3);
      }
      
      private function __switchRoom_Handler(param1:BraveDoorEvent) : void
      {
         var _loc2_:int = int(param1.data);
         switch(int(_loc2_) - 1)
         {
            case 0:
               this.switchRoomView();
               break;
            case 1:
               this.switchTemView();
         }
      }
      
      private function switchRoomView() : void
      {
         this.disposeTemView();
         if(this._roomView == null)
         {
            this._roomView = new DuplicateRoomView(this._data);
            this._roomView.control = this._control;
            addChildAt(this._roomView,0);
         }
         if(!this._roomView.visible)
         {
            this._roomView.visible = true;
         }
         this._roomView.update();
      }
      
      private function switchTemView() : void
      {
         this.disposeRoomView();
         this._roomInfo = RoomManager.Instance.current;
         if(this._temView == null)
         {
            this._temView = new DuplicateTemRoomView(this._roomInfo);
            this._temView.control = this._control;
            addChildAt(this._temView,0);
         }
         if(!this._temView.visible)
         {
            this._temView.visible = true;
         }
      }
      
      private function disposeTemView() : void
      {
         if(Boolean(this._temView))
         {
            ObjectUtils.disposeObject(this._temView);
            this._temView = null;
         }
      }
      
      private function disposeRoomView() : void
      {
         if(Boolean(this._roomView))
         {
            ObjectUtils.disposeObject(this._roomView);
         }
         this._roomView = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeRoomView();
         this.disposeTemView();
         this._control = null;
         this._data = null;
         if(Boolean(this._chatBtn))
         {
            ObjectUtils.disposeObject(this._chatBtn);
         }
         this._chatBtn = null;
      }
   }
}

