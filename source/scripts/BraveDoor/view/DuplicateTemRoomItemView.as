package BraveDoor.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.RoomEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.IMController;
   import room.RoomManager;
   import room.events.RoomPlayerEvent;
   import room.model.RoomPlayer;
   
   public class DuplicateTemRoomItemView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _levelIcon:LevelIcon;
      
      private var _addFriendBtn:SimpleBitmapButton;
      
      private var _kickOutBtn:SimpleBitmapButton;
      
      private var _playerInfoBtn:SimpleBitmapButton;
      
      private var _fightTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _readyIcon:Bitmap;
      
      private var _hostIcon:Bitmap;
      
      private var _info:RoomPlayer;
      
      private var _place:int;
      
      public function DuplicateTemRoomItemView(param1:int = 0)
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.braveDoor.room.playerListBg");
         addChild(this._bg);
         this._fightTxt = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.fightText");
         addChild(this._fightTxt);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.nameText");
         addChild(this._nameTxt);
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("braveDoor.duplicateTemItem.playerItem.LevelIcon");
         addChild(this._levelIcon);
         this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.addFriendButton");
         this._addFriendBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.addFriend");
         this._kickOutBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.kickOutButton");
         this._kickOutBtn.tipData = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.exitRoom");
         this._playerInfoBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.duplicateTeamRoom.playerInfoButton");
         this._playerInfoBtn.tipData = "Xem thông tin";
         addChild(this._addFriendBtn);
         addChild(this._kickOutBtn);
         addChild(this._playerInfoBtn);
      }
      
      public function set info(param1:RoomPlayer) : void
      {
         if(Boolean(this._info))
         {
            this._info.removeEventListener("readyChange",this.__infoStateChange);
            this._info.removeEventListener("isHostChange",this.__infoStateChange);
            this._info = null;
         }
         this._info = param1;
         if(Boolean(this._info))
         {
            this._info.addEventListener("readyChange",this.__infoStateChange);
            this._info.addEventListener("isHostChange",this.__infoStateChange);
         }
         this.updateView();
      }
      
      public function get info() : RoomPlayer
      {
         return this._info;
      }
      
      private function updateView() : void
      {
         var _loc1_:* = null;
         if(this._info != null)
         {
            _loc1_ = this._info.playerInfo;
            if(this._levelIcon != null)
            {
               this._levelIcon.setInfo(_loc1_.Grade,_loc1_.Repute,_loc1_.WinCount,_loc1_.TotalCount,_loc1_.FightPower,_loc1_.Offer,true,false);
            }
            this._fightTxt.text = _loc1_.FightPower.toString();
            this._nameTxt.text = _loc1_.NickName;
         }
         this.updateButtons();
         this.updatePlayerState();
      }
      
      private function updateButtons() : void
      {
         if(Boolean(this._info))
         {
            this._addFriendBtn.visible = this._kickOutBtn.visible = this._playerInfoBtn.visible = true;
            if(this._info.isSelf)
            {
               this._kickOutBtn.enable = false;
            }
            else if(RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
               if(RoomManager.Instance.current.started)
               {
                  this._kickOutBtn.enable = false;
               }
               else
               {
                  this._kickOutBtn.enable = true;
               }
            }
            else
            {
               this._kickOutBtn.enable = false;
            }
         }
      }
      
      private function updatePlayerState() : void
      {
         if(Boolean(this._info))
         {
            if(this._info.isReady)
            {
               if(!this._readyIcon)
               {
                  this._readyIcon = ComponentFactory.Instance.creatBitmap("asset.braveDoor.hadReady");
               }
               addChild(this._readyIcon);
               this._readyIcon.visible = true;
            }
            else if(Boolean(this._readyIcon) && this._readyIcon.visible)
            {
               this._readyIcon.visible = false;
            }
            if(this._info.isHost)
            {
               if(!this._hostIcon)
               {
                  this._hostIcon = ComponentFactory.Instance.creatBitmap("asset.braveDoor.room.homeownersIcon");
               }
               addChild(this._hostIcon);
               this._hostIcon.visible = true;
            }
            else if(Boolean(this._hostIcon) && this._hostIcon.visible)
            {
               this._hostIcon.visible = false;
            }
         }
         else
         {
            if(Boolean(this._hostIcon) && this._hostIcon.visible)
            {
               this._hostIcon.visible = false;
            }
            if(Boolean(this._readyIcon) && this._readyIcon.visible)
            {
               this._readyIcon.visible = false;
            }
         }
      }
      
      private function updateInfoView() : void
      {
         if(this._levelIcon == null)
         {
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.playerItem.LevelIcon");
            addChild(this._levelIcon);
         }
         this._levelIcon.setInfo(this._info.playerInfo.Grade,this._info.playerInfo.Repute,this._info.playerInfo.WinCount,this._info.playerInfo.TotalCount,this._info.playerInfo.FightPower,this._info.playerInfo.Offer,true,false);
      }
      
      private function __infoStateChange(param1:RoomPlayerEvent) : void
      {
         this.updatePlayerState();
         this.updateButtons();
      }
      
      private function __addFriendHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         IMController.Instance.addFriend(this._info.playerInfo.NickName);
      }
      
      private function __kickOutHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         GameInSocketOut.sendGameRoomKick(this.info.place);
      }
      
      private function __startHandler(param1:RoomEvent) : void
      {
         this.updateButtons();
      }
      
      private function __updateButton(param1:RoomPlayerEvent) : void
      {
         this.updateButtons();
      }
      
      private function initEvents() : void
      {
         this._addFriendBtn.addEventListener("click",this.__addFriendHandler);
         this._kickOutBtn.addEventListener("click",this.__kickOutHandler);
         this._playerInfoBtn.addEventListener("click",this.__playerInfoClickHandler);
         RoomManager.Instance.current.addEventListener("startedChanged",this.__startHandler);
         RoomManager.Instance.current.selfRoomPlayer.addEventListener("isHostChange",this.__updateButton);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._info))
         {
            this._info.removeEventListener("readyChange",this.__infoStateChange);
            this._info.removeEventListener("isHostChange",this.__infoStateChange);
            this._playerInfoBtn.removeEventListener("click",this.__playerInfoClickHandler);
            this._addFriendBtn.removeEventListener("click",this.__addFriendHandler);
            this._kickOutBtn.removeEventListener("click",this.__kickOutHandler);
            RoomManager.Instance.current.removeEventListener("startedChanged",this.__startHandler);
            RoomManager.Instance.current.selfRoomPlayer.removeEventListener("isHostChange",this.__updateButton);
         }
      }
      
      private function __playerInfoClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         PlayerInfoViewControl.viewByID(this._info.playerInfo.ID,-1,true);
         PlayerInfoViewControl.isOpenFromBag = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
         }
         if(Boolean(this._hostIcon))
         {
            ObjectUtils.disposeObject(this._hostIcon);
         }
         if(Boolean(this._readyIcon))
         {
            ObjectUtils.disposeObject(this._readyIcon);
         }
         if(Boolean(this._kickOutBtn))
         {
            ObjectUtils.disposeObject(this._kickOutBtn);
         }
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(Boolean(this._fightTxt))
         {
            ObjectUtils.disposeObject(this._fightTxt);
         }
         if(Boolean(this._nameTxt))
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         if(Boolean(this._addFriendBtn))
         {
            ObjectUtils.disposeObject(this._addFriendBtn);
         }
         if(Boolean(this._playerInfoBtn))
         {
            ObjectUtils.disposeObject(this._playerInfoBtn);
         }
         this._levelIcon = null;
         this._hostIcon = null;
         this._readyIcon = null;
         this._kickOutBtn = null;
         this._bg = null;
         this._fightTxt = null;
         this._nameTxt = null;
         this._addFriendBtn = null;
         this._playerInfoBtn = null;
      }
   }
}

