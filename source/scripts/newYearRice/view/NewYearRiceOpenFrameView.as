package newYearRice.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.BossBoxManager;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import invite.InviteFrame;
   import newYearRice.NewYearRiceManager;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   
   public class NewYearRiceOpenFrameView extends Frame
   {
      
      private var _main:MovieClip;
      
      private var _openBtn:BaseButton;
      
      private var _inviteBtn:BaseButton;
      
      private var _playerItems:Vector.<PlayerCell>;
      
      private var _startInvite:Boolean = false;
      
      private var _inviteFrame:InviteFrame;
      
      private var _bg:Bitmap;
      
      private var _playerID:int;
      
      private var _isRoomPlayer:Boolean;
      
      private var _nameID:int;
      
      private var _alert1:BaseAlerFrame;
      
      private var _roomPlayerID:int;
      
      public function NewYearRiceOpenFrameView()
      {
         super();
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:PlayerCell = null;
         _loc1_ = null;
         InviteManager.Instance.enabled = false;
         if(RoomManager.Instance.current != null)
         {
            RoomManager.Instance.current = null;
         }
         BossBoxManager.instance.deleteBoxButton();
         NewYearRiceManager.instance.model.openFrameView = this;
         this._main = ClassUtils.CreatInstance("asset.newYearRice.view") as MovieClip;
         this._main.gotoAndStop(2);
         PositionUtils.setPos(this._main,"asset.newYearRice.view.pos");
         addToContent(this._main);
         this._openBtn = ComponentFactory.Instance.creat("NewYearRiceOpenFrameView.openBtn");
         addToContent(this._openBtn);
         this._inviteBtn = ComponentFactory.Instance.creat("NewYearRiceOpenFrameView.inviteBtn");
         addToContent(this._inviteBtn);
         this._playerItems = new Vector.<PlayerCell>();
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            _loc1_ = ComponentFactory.Instance.creatCustomObject("NewYearRiceOpenFrameView.playerCell." + _loc2_);
            _loc1_.mouseEnabled = true;
            addToContent(_loc1_);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__cellClick);
            this._playerItems.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function __cellClick(param1:MouseEvent) : void
      {
         var _loc2_:PlayerCell = param1.currentTarget as PlayerCell;
         if(_loc2_.info != null && _loc2_.info.ID != this._roomPlayerID && this._roomPlayerID > 0)
         {
            this._nameID = _loc2_.info.ID;
            this._alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("NewYearRiceOpenFrameView.view.QuitPlayer",_loc2_.nikeName),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,1);
            this._alert1.addEventListener(FrameEvent.RESPONSE,this.__quitPlayer);
         }
      }
      
      private function __quitPlayer(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__quitPlayer);
         _loc2_.disposeChildren = true;
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendQuitNewYearRiceRoom(this._nameID);
         }
      }
      
      public function roomPlayerItem(param1:int) : void
      {
         this._roomPlayerID = param1;
         this._playerItems[0].setNickName(param1,"right");
      }
      
      public function updatePlayerItem(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._playerItems[_loc2_].removePlayerCell();
            if(this._playerItems[_loc2_].info == null)
            {
               this._playerItems[_loc2_].setNickName(param1[_loc2_].ID,_loc2_ <= 2 ? "right" : "left",param1[_loc2_].Style,param1[_loc2_].NikeName,param1[_loc2_].Sex);
            }
            _loc2_++;
         }
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._openBtn.addEventListener(MouseEvent.CLICK,this.__openBtnHandler);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.EXITYEARFOODROOM,this.__exitYearFoodRoom);
         NewYearRiceManager.instance.addEventListener(NewYearRiceManager.UPDATEVIEW,this.__updateView);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODCREATEFOOD,this.__quitYearFoodRoom);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._openBtn.removeEventListener(MouseEvent.CLICK,this.__openBtnHandler);
         NewYearRiceManager.instance.removeEventListener(CrazyTankSocketEvent.EXITYEARFOODROOM,this.__exitYearFoodRoom);
         NewYearRiceManager.instance.removeEventListener(NewYearRiceManager.UPDATEVIEW,this.__updateView);
         NewYearRiceManager.instance.addEventListener(CrazyTankSocketEvent.YEARFOODCREATEFOOD,this.__quitYearFoodRoom);
      }
      
      private function __quitYearFoodRoom(param1:CrazyTankSocketEvent) : void
      {
         this.dispose();
      }
      
      private function __updateView(param1:Event) : void
      {
         var _loc2_:Array = NewYearRiceManager.instance.model.playersArray;
         var _loc3_:int = 1;
         while(_loc3_ < _loc2_.length)
         {
            this._playerItems[_loc3_].removePlayerCell();
            if(this._playerItems[_loc3_].info == null)
            {
               this._playerItems[_loc3_].setNickName(_loc2_[_loc3_].ID,_loc3_ <= 2 ? "right" : "left",_loc2_[_loc3_].Style,_loc2_[_loc3_].NikeName,_loc2_[_loc3_].Sex);
            }
            _loc3_++;
         }
      }
      
      public function setBtnEnter() : void
      {
         this._openBtn.enable = this._openBtn.mouseChildren = this._openBtn.mouseEnabled = false;
         this._inviteBtn.enable = this._inviteBtn.mouseChildren = this._inviteBtn.mouseEnabled = false;
      }
      
      private function __exitYearFoodRoom(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         this._isRoomPlayer = _loc3_.readBoolean();
         this._playerID = _loc3_.readInt();
         if(this._isRoomPlayer)
         {
            if(Boolean(this._inviteFrame))
            {
               this._inviteFrame.removeEventListener(Event.COMPLETE,this.__onInviteComplete);
               ObjectUtils.disposeObject(this._inviteFrame);
               this._inviteFrame = null;
            }
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("NewYearRiceOpenFrameView.RoomPlayer.Exit"));
            this.dispose();
         }
         else if(Boolean(this._playerItems) && this._playerItems.length > 1)
         {
            _loc2_ = 1;
            while(_loc2_ < this._playerItems.length)
            {
               if(this._playerItems[_loc2_].playerID == this._playerID)
               {
                  this._playerItems[_loc2_].removePlayerCell();
               }
               _loc2_++;
            }
         }
      }
      
      public function setViewFrame(param1:int) : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(param1 == 1)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.DinnerBG");
         }
         else if(param1 == 2)
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.BanquetBG");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.newYearRice.HanBG");
         }
         this._bg.x = 40;
         this._bg.y = -60;
         addToContent(this._bg);
      }
      
      private function __openBtnHandler(param1:MouseEvent) : void
      {
         this._startInvite = false;
         NewYearRiceManager.instance.model.yearFoodInfo = 0;
         SocketManager.Instance.out.sendNewYearRiceOpen(NewYearRiceManager.instance.model.playerNum);
      }
      
      private function __inviteBtnHandler(param1:MouseEvent) : void
      {
         if(this._inviteFrame != null)
         {
            SoundManager.instance.play("008");
            this.__onInviteComplete(null);
         }
         else
         {
            this.startInvite();
         }
      }
      
      protected function startInvite() : void
      {
         if(!this._startInvite && this._inviteFrame == null)
         {
            this._startInvite = true;
            this.loadInviteRes();
         }
      }
      
      private function loadInviteRes() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTINVITE);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onInviteResComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDTINVITE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
            if(this._startInvite && this._inviteFrame == null)
            {
               this._inviteFrame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtInviteFrame");
               LayerManager.Instance.addToLayer(this._inviteFrame,LayerManager.GAME_TOP_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
               this._inviteFrame.addEventListener(Event.COMPLETE,this.__onInviteComplete);
               this._startInvite = false;
            }
         }
      }
      
      private function __onInviteComplete(param1:Event) : void
      {
         this._inviteFrame.removeEventListener(Event.COMPLETE,this.__onInviteComplete);
         ObjectUtils.disposeObject(this._inviteFrame);
         this._inviteFrame = null;
      }
      
      private function __onInviteResError(param1:UIModuleEvent) : void
      {
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onInviteResComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR,this.__onInviteResError);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendExitYearFoodRoom();
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         InviteManager.Instance.enabled = true;
         NewYearRiceManager.instance.model.openFrameView = null;
         NewYearRiceManager.instance.model.playerNum = 0;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
         if(Boolean(this._alert1))
         {
            ObjectUtils.disposeObject(this._alert1);
            this._alert1 = null;
         }
         if(Boolean(this._inviteFrame))
         {
            ObjectUtils.disposeObject(this._inviteFrame);
            this._inviteFrame = null;
         }
      }
   }
}

