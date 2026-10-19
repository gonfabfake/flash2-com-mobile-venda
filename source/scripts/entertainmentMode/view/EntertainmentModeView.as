package entertainmentMode.view
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import entertainmentMode.EntertainmentModeManager;
   import entertainmentMode.model.EntertainmentModel;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   import room.RoomManager;
   import room.model.RoomInfo;
   import roomList.pvpRoomList.RoomListBGView;
   import shop.view.ShopItemCell;
   
   public class EntertainmentModeView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _joinBtn:SimpleBitmapButton;
      
      private var _createBtn:SimpleBitmapButton;
      
      private var _enterBtn:SimpleBitmapButton;
      
      private var _helpBtn:BaseButton;
      
      private var _searchBg:Image;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _searchTxt:SimpleDropListTarget;
      
      private var _itemList:SimpleTileList;
      
      private var _itemArray:Array;
      
      private var _scoreTxt:FilterFrameText;
      
      private var _timeTitleTxt:FilterFrameText;
      
      private var _timeTxt:FilterFrameText;
      
      private var _isPermissionEnter:Boolean;
      
      private var _box:Sprite = new Sprite();
      
      private var list:ScrollPanel;
      
      private var pkBtn:MovieClip;
      
      public function EntertainmentModeView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         this._itemArray = [];
         titleText = LanguageMgr.GetTranslation("ddt.entertainmentMode.title");
         if(PathManager.pkEnable)
         {
            this._bg = ComponentFactory.Instance.creat("asset.Entertainment.mode.bg2");
         }
         else
         {
            this._bg = ComponentFactory.Instance.creat("asset.Entertainment.mode.bg");
         }
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("entertainment.HelpBtn");
         addToContent(this._helpBtn);
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.joinBtn");
         this._joinBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.joinBattleQuickly");
         this._createBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.createBtn");
         this._createBtn.tipData = LanguageMgr.GetTranslation("tank.roomlist.RoomListIIRoomBtnPanel.createRoom");
         this._enterBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.enterBtn");
         addToContent(this._joinBtn);
         addToContent(this._createBtn);
         addToContent(this._enterBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.nextBtn");
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.preBtn");
         addToContent(this._nextBtn);
         addToContent(this._preBtn);
         this._searchBg = ComponentFactory.Instance.creatComponentByStylename("asset.entertainment.searchBg");
         addToContent(this._searchBg);
         this._itemList = ComponentFactory.Instance.creat("asset.entertainment.ItemList",[2]);
         addToContent(this._itemList);
         this._searchTxt = ComponentFactory.Instance.creat("asset.entertainment.searchtxt");
         addToContent(this._searchTxt);
         this._searchTxt.restrict = "0-9";
         this._scoreTxt = ComponentFactory.Instance.creat("asset.entertainment.score");
         addToContent(this._scoreTxt);
         this._timeTitleTxt = ComponentFactory.Instance.creat("asset.entertainment.time.title");
         addToContent(this._timeTitleTxt);
         this._timeTitleTxt.text = LanguageMgr.GetTranslation("ddt.entertainmentMode.TimeFieldTitle");
         this._timeTxt = ComponentFactory.Instance.creat("asset.entertainment.time");
         addToContent(this._timeTxt);
         this._timeTxt.text = EntertainmentModeManager.instance.openTime;
         this.list = ComponentFactory.Instance.creat("asset.entertainment.panel");
         addToContent(this.list);
         this.list.hScrollProxy = 2;
         this.list.vScrollProxy = 0;
         _loc1_ = 0;
         while(_loc1_ < ServerConfigManager.instance.entertainmentScore().length)
         {
            if(_loc1_ % 2 == 0)
            {
               _loc2_ = ComponentFactory.Instance.creat("asset.Entertainment.mode.dark");
            }
            else
            {
               _loc2_ = ComponentFactory.Instance.creat("asset.Entertainment.mode.light");
            }
            this._box.addChild(_loc2_);
            _loc3_ = ComponentFactory.Instance.creat("asset.entertainment.list.score");
            this._box.addChild(_loc3_);
            _loc3_.text = String(ServerConfigManager.instance.entertainmentScore()[_loc1_].split("|")[0]);
            _loc3_.y = _loc1_ * _loc2_.height + 9;
            _loc2_.y = _loc1_ * _loc2_.height;
            _loc4_ = this.creatItemCell();
            _loc4_.buttonMode = true;
            _loc4_.cellSize = 39;
            _loc5_ = ItemManager.Instance.getTemplateById(ServerConfigManager.instance.entertainmentScore()[_loc1_].split("|")[1]);
            _loc4_.info = _loc5_;
            _loc4_.x = 126;
            _loc4_.y = _loc1_ * _loc2_.height - 7;
            this._box.addChild(_loc4_);
            _loc1_++;
         }
         this.list.setView(this._box);
         if(PathManager.pkEnable)
         {
            this.list.height = 303;
            this.pkBtn = ComponentFactory.Instance.creat("asset.Entertainment.mode.pkBtn");
            addToContent(this.pkBtn);
            PositionUtils.setPos(this.pkBtn,"asset.Entertainment.pkBtn.Pos");
         }
         this.list.invalidateViewport();
         this._isPermissionEnter = true;
         SocketManager.Instance.out.sendEntertainment();
      }
      
      private function creatItemCell() : ShopItemCell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,23,23);
         _loc1_.graphics.endFill();
         return CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
      }
      
      private function initEvent() : void
      {
         this._preBtn.addEventListener("click",this.__updateClick);
         this._nextBtn.addEventListener("click",this.__updateClick);
         addEventListener("response",this.__frameEventHandler);
         this._searchTxt.addEventListener("mouseDown",this._clickName);
         this._searchTxt.addEventListener("addedToStage",this.setFocus);
         this._joinBtn.addEventListener("click",this.__joinBtnHandler);
         this._createBtn.addEventListener("click",this.__createBtnHandler);
         this._enterBtn.addEventListener("click",this.__enterBtnHandler);
         EntertainmentModel.instance.addEventListener("roomlistchange",this.__roomListChanger);
         EntertainmentModel.instance.addEventListener("scoreChange",this.__scoreChanger);
         SocketManager.Instance.addEventListener("gameRoomListUpdate",this.__onEnter);
         this._helpBtn.addEventListener("click",this.helpBtnClickHandler);
         if(Boolean(this.pkBtn))
         {
            this.pkBtn.addEventListener("click",this.__pkBtnHandler);
         }
         this._scoreTxt.text = EntertainmentModel.instance.score.toString();
         this.updateRoomList();
      }
      
      private function helpBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:EntertainmentInfoFrame = ComponentFactory.Instance.creatCustomObject("entertainment.infoFrame");
         LayerManager.Instance.addToLayer(_loc2_,2,true,2);
      }
      
      private function __pkBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],42,3);
      }
      
      private function __onEnter(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:Array = [];
         var _loc6_:PackageIn = param1.pkg;
         EntertainmentModel.instance.roomTotal = _loc6_.readInt();
         var _loc7_:int = _loc6_.readInt();
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc3_ = _loc6_.readInt();
            _loc4_ = new RoomInfo();
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
            _loc5_.push(_loc4_);
            _loc2_++;
         }
         EntertainmentModel.instance.updateRoom(_loc5_);
      }
      
      private function __scoreChanger(param1:Event) : void
      {
         this._scoreTxt.text = EntertainmentModel.instance.score.toString();
      }
      
      private function __gameStart(param1:CrazyTankSocketEvent) : void
      {
      }
      
      private function __enterBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchTxt.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIFindRoomPanel.id"));
            return;
         }
         SocketManager.Instance.out.sendGameLogin(8,-1,int(this._searchTxt.text));
      }
      
      private function __createBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int(Math.random() * RoomListBGView.PREWORD.length)],41,3);
      }
      
      private function __joinBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._isPermissionEnter)
         {
            return;
         }
         SocketManager.Instance.out.sendGameLogin(8,41);
         this._isPermissionEnter = false;
      }
      
      private function __updateClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.sendSift();
      }
      
      private function sendSift() : void
      {
         SocketManager.Instance.out.sendSceneLogin(8);
      }
      
      private function __roomListChanger(param1:Event) : void
      {
         this.updateRoomList();
      }
      
      private function updateRoomList() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = null;
         this.cleanItem();
         for each(_loc2_ in EntertainmentModel.instance.roomList)
         {
            _loc1_ = new EntertainmentListItem(_loc2_);
            _loc1_.addEventListener("click",this.__itemClick,false,0,true);
            this._itemList.addChild(_loc1_);
            this._itemArray.push(_loc1_);
         }
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         if(!this._isPermissionEnter)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:EntertainmentListItem = param1.currentTarget as EntertainmentListItem;
         SocketManager.Instance.out.sendGameLogin(8,-1,_loc2_.info.ID);
         this._isPermissionEnter = false;
      }
      
      private function _clickName(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._searchTxt.text == LanguageMgr.GetTranslation("ddt.entertainmentMode.input.roomNumber"))
         {
            this._searchTxt.text = "";
         }
      }
      
      private function setFocus(param1:Event) : void
      {
         this._searchTxt.text = LanguageMgr.GetTranslation("ddt.entertainmentMode.input.roomNumber");
         this._searchTxt.setFocus();
         this._searchTxt.setCursor(this._searchTxt.text.length);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               EntertainmentModeManager.instance.hide();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,2);
      }
      
      private function removeEvent() : void
      {
         this._preBtn.removeEventListener("click",this.__updateClick);
         this._nextBtn.removeEventListener("click",this.__updateClick);
         removeEventListener("response",this.__frameEventHandler);
         this._searchTxt.removeEventListener("mouseDown",this._clickName);
         this._searchTxt.removeEventListener("addedToStage",this.setFocus);
         this._joinBtn.removeEventListener("click",this.__joinBtnHandler);
         this._createBtn.removeEventListener("click",this.__createBtnHandler);
         this._enterBtn.removeEventListener("click",this.__enterBtnHandler);
         EntertainmentModel.instance.removeEventListener("roomlistchange",this.__roomListChanger);
         EntertainmentModel.instance.removeEventListener("scoreChange",this.__scoreChanger);
         SocketManager.Instance.removeEventListener("gameRoomListUpdate",this.__onEnter);
         this._helpBtn.removeEventListener("click",this.helpBtnClickHandler);
         if(Boolean(this.pkBtn))
         {
            this.pkBtn.removeEventListener("click",this.__pkBtnHandler);
         }
      }
      
      private function cleanItem() : void
      {
         var _loc1_:int = 0;
         this._isPermissionEnter = true;
         _loc1_ = 0;
         while(_loc1_ < this._itemArray.length)
         {
            this._itemArray[_loc1_].removeEventListener("click",this.__itemClick);
            this._itemArray[_loc1_].dispose();
            _loc1_++;
         }
         this._itemList.disposeAllChildren();
         this._itemArray = [];
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         RoomManager.Instance.isEnterTainmentRoom = false;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._searchBg);
         this._searchBg = null;
         ObjectUtils.disposeObject(this._searchTxt);
         this._searchTxt = null;
         ObjectUtils.disposeObject(this._scoreTxt);
         this._scoreTxt = null;
         ObjectUtils.disposeObject(this._timeTxt);
         this._timeTxt = null;
         ObjectUtils.disposeObject(this._timeTitleTxt);
         this._timeTitleTxt = null;
         ObjectUtils.disposeObject(this._box);
         this._box = null;
         if(Boolean(this.pkBtn))
         {
            ObjectUtils.disposeObject(this.pkBtn);
            this.pkBtn = null;
         }
         if(Boolean(this.list))
         {
            ObjectUtils.disposeObject(this.list);
            this.list = null;
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
            this._helpBtn = null;
         }
         if(Boolean(this._joinBtn))
         {
            this._joinBtn.dispose();
            this._joinBtn = null;
         }
         if(Boolean(this._createBtn))
         {
            this._createBtn.dispose();
            this._createBtn = null;
         }
         if(Boolean(this._enterBtn))
         {
            this._enterBtn.dispose();
            this._enterBtn = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._preBtn))
         {
            this._preBtn.dispose();
            this._preBtn = null;
         }
         this._itemList.dispose();
         this._itemList = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

