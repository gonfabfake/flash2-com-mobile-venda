package room.view.chooseMap
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import room.model.RoomInfo;
   import times.utils.timerManager.TimerJuggler;
   import trainer.view.NewHandContainer;
   
   public class DungeonChooseMapFrame extends Frame
   {
      
      private var _view:DungeonChooseMapView;
      
      private var _okBtn:TextButton;
      
      private var _frame:BaseAlerFrame;
      
      private var _timeTimer:TimerJuggler;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _alert:BaseAlerFrame;
      
      private var _selfInfo:SelfInfo;
      
      private var _voucherAlert:BaseAlerFrame;
      
      public function DungeonChooseMapFrame()
      {
         super();
         escEnable = true;
         this._view = ComponentFactory.Instance.creatCustomObject("room.dungeonChooseMapView");
         addToContent(this._view);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("asset.room.dungeonChooseMapButton");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         addToContent(this._okBtn);
         PositionUtils.setPos(this._okBtn,"asset.DungeonRoom.OkbtnPos");
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okClick);
         titleText = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
         addEventListener(FrameEvent.RESPONSE,this.__responeHandler);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __okClick(param1:MouseEvent) : void
      {
         var _loc2_:DungeonInfo = null;
         SoundManager.instance.play("008");
         if(this._view.checkState())
         {
            _loc2_ = MapManager.getDungeonInfo(this._view.selectedMapID);
            if(_loc2_.Type == MapManager.PVE_ACADEMY_MAP)
            {
               GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.ACADEMY_DUNGEON_ROOM,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
            }
            else if(_loc2_.Type == MapManager.PVE_ACTIVITY_MAP)
            {
               GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.ACTIVITY_DUNGEON_ROOM,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
            }
            else
            {
               GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,RoomInfo.DUNGEON_ROOM,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
            }
            RoomManager.Instance.current.roomName = this._view._roomName;
            RoomManager.Instance.current.roomPass = this._view._roomPass;
            RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
            this.dispose();
         }
      }
      
      private function __responeHandler(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         NewHandContainer.Instance.clearArrowByID(-1);
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
         else if(param1.responseCode == 3)
         {
            SoundManager.instance.play("008");
            if(this._view.checkState())
            {
               _loc2_ = MapManager.getDungeonInfo(this._view.selectedMapID);
               if(this._view.selectedMapID == 70020)
               {
                  return;
               }
               if(this._view.select)
               {
                  this.showAlert();
               }
               else
               {
                  if(_loc2_.Type == 6)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,11,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
                  }
                  else if(MapManager.PVE_ADVANCED_MAP.indexOf(_loc2_.ID) != -1)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,4,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
                  }
                  else if(_loc2_.Type == 21 && _loc2_.ID == 70001)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,21,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
                  }
                  else if(_loc2_.Type == 23 || _loc2_.Type == 47 || _loc2_.Type == 48)
                  {
                     if(_loc2_.Type == 47)
                     {
                        _loc3_ = 47;
                     }
                     else if(_loc2_.Type == 48)
                     {
                        _loc3_ = 48;
                     }
                     else
                     {
                        _loc3_ = int(_loc2_.Type);
                     }
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,_loc3_,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
                  }
                  else if(_loc2_.Type == 24)
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,123,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
                  }
                  else
                  {
                     GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,4,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
                  }
                  RoomManager.Instance.current.roomName = this._view._roomName;
                  RoomManager.Instance.current.roomPass = this._view._roomPass;
                  RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
                  this.dispose();
               }
            }
         }
      }
      
      private function showAlert() : void
      {
         if(this._alert == null)
         {
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.openBossTip.text",this.getPrice(),this.getName()),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            this._alert.moveEnable = false;
            this._alert.addEventListener("response",this.__alertResponse);
         }
      }
      
      private function getPrice() : String
      {
         var _loc1_:Array = [];
         var _loc2_:String = "";
         var _loc3_:String = MapManager.getDungeonInfo(this._view.selectedMapID).BossFightNeedMoney;
         if(Boolean(_loc3_))
         {
            _loc1_ = _loc3_.split("|");
         }
         if(Boolean(_loc1_) && _loc1_.length > 0)
         {
            switch(int(this._view.selectedLevel))
            {
               case 0:
                  _loc2_ = _loc1_[0];
                  break;
               case 1:
                  _loc2_ = _loc1_[1];
                  break;
               case 2:
                  _loc2_ = _loc1_[2];
                  break;
               case 3:
                  _loc2_ = _loc1_[3];
                  break;
               case 4:
                  _loc2_ = _loc1_[4];
                  break;
               case 5:
                  _loc2_ = _loc1_[5];
            }
         }
         return _loc2_;
      }
      
      private function getName() : String
      {
         var _loc1_:String = "";
         if(this._view.selectedMapID == 27 || this._view.selectedMapID == 30)
         {
            _loc1_ = ItemManager.Instance.getTemplateById(12578).Name;
         }
         else
         {
            _loc1_ = ItemManager.Instance.getTemplateById(201531).Name;
         }
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okClick);
         removeEventListener(FrameEvent.RESPONSE,this.__responeHandler);
         this._view.dispose();
         this._view = null;
         super.dispose();
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
            case 4:
               this.disposeAlert();
               break;
            case 2:
            case 3:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               this._selfInfo = PlayerManager.Instance.Self;
               _loc2_ = this._selfInfo.getBag(1);
               if(this._view.selectedMapID == 27 || this._view.selectedMapID == 30)
               {
                  _loc3_ = 12578;
               }
               else
               {
                  _loc3_ = 201531;
               }
               _loc4_ = int(_loc2_.getItemCountByTemplateId(_loc3_));
               if(_loc4_ < Number(this.getPrice()))
               {
                  this.showVoucherAlert();
               }
               else
               {
                  this.doOpenBossRoom();
               }
         }
      }
      
      private function doOpenBossRoom() : void
      {
         if(this._view.selectedMapID == 27 || this._view.selectedMapID == 30 || this._view.selectedMapID == 32)
         {
            GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,123,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
         }
         else
         {
            GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID,4,this._view._roomPass,this._view._roomName,1,this._view.selectedLevel);
         }
         RoomManager.Instance.current.roomName = this._view._roomName;
         RoomManager.Instance.current.roomPass = this._view._roomPass;
         RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
         this.dispose();
      }
      
      private function showVoucherAlert() : void
      {
         if(this._voucherAlert == null)
         {
            this._voucherAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("dungeonChooseMapGoods"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
            this._voucherAlert.addEventListener("response",this.__onNoMoneyResponse);
         }
      }
      
      private function disposeAlert() : void
      {
         if(Boolean(this._alert))
         {
            this._alert.removeEventListener("response",this.__alertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert.dispose();
         }
         this._alert = null;
      }
      
      private function disposeVoucherAlert() : void
      {
         this.disposeAlert();
         if(Boolean(this._voucherAlert))
         {
            this._voucherAlert.removeEventListener("response",this.__onNoMoneyResponse);
            this._voucherAlert.disposeChildren = true;
            this._voucherAlert.dispose();
            this._voucherAlert = null;
         }
      }
      
      private function __onNoMoneyResponse(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.play("008");
         this.disposeVoucherAlert();
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            if(this._view.selectedMapID == 27 || this._view.selectedMapID == 30)
            {
               _loc2_.itemID = 12578;
            }
            else
            {
               _loc2_.itemID = 201531;
            }
            LayerManager.Instance.addToLayer(_loc2_,2,true,1);
         }
      }
   }
}

