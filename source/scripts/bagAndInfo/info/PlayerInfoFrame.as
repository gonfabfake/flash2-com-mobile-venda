package bagAndInfo.info
{
   import bagAndInfo.BagAndGiftFrame;
   import cardSystem.view.cardEquip.CardEquipView;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import giftSystem.GiftController;
   import giftSystem.view.GiftInfoView;
   import texpSystem.view.TexpInfoView;
   import totem.TotemManager;
   import totem.view.TotemInfoView;
   
   public class PlayerInfoFrame extends Frame
   {
      
      private var _BG:Scale9CornerImage;
      
      private var _view:PlayerInfoView;
      
      private var _texpView:TexpInfoView;
      
      private var _giftView:GiftInfoView;
      
      private var _cardEquip:CardEquipView;
      
      private var _totemView:TotemInfoView;
      
      private var _info:PlayerInfo;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _texpBtn:SelectedButton;
      
      private var _giftBtn:SelectedButton;
      
      private var _cardBtn:SelectedButton;
      
      private var _totemBtn:SelectedButton;
      
      private var _openTexp:Boolean;
      
      private var _openGift:Boolean;
      
      private var _openCard:Boolean;
      
      public function PlayerInfoFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.escEnable = true;
         this.enterEnable = true;
         this._BG = ComponentFactory.Instance.creatComponentByStylename("PlayerInfoFrame.bg");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn");
         this._texpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.texpBtn");
         this._cardBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.cardBtn");
         PositionUtils.setPos(this._infoBtn,"PlayerInfoFrame.infoBtnPos");
         PositionUtils.setPos(this._texpBtn,"PlayerInfoFrame.texpBtnPos");
         PositionUtils.setPos(this._cardBtn,"PlayerInfoFrame.cardBtnPos");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._texpBtn);
         addToContent(this._cardBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._texpBtn);
         this._btnGroup.addSelectItem(this._cardBtn);
         this._btnGroup.selectIndex = 0;
         if(PathManager.TotemEnable)
         {
            this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemBtn");
            PositionUtils.setPos(this._totemBtn,"PlayerInfoFrame.giftBtnPos");
            addToContent(this._totemBtn);
            this._btnGroup.addSelectItem(this._totemBtn);
         }
         else
         {
            this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.giftBtn");
            PositionUtils.setPos(this._giftBtn,"PlayerInfoFrame.giftBtnPos");
            addToContent(this._giftBtn);
            this._btnGroup.addSelectItem(this._giftBtn);
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         if(Boolean(this._giftBtn))
         {
            this._giftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         this._cardBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._texpBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         if(Boolean(this._totemBtn))
         {
            this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
      }
      
      private function __soundPlayer(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(this._btnGroup.selectIndex)
         {
            case BagAndGiftFrame.BAGANDINFO:
               this.showInfoFrame();
               break;
            case 1:
               this.showTexpFrame();
               break;
            case 2:
               if(!this._openCard)
               {
                  SocketManager.Instance.out.getPlayerCardInfo(this._info.ID);
                  this._openCard = true;
               }
               this.showCardEquip();
               break;
            case 3:
               if(Boolean(this._totemBtn))
               {
                  this.showTotem();
               }
               else
               {
                  if(!this._openGift)
                  {
                     if(this._info.ID != PlayerManager.Instance.Self.ID)
                     {
                        SocketManager.Instance.out.sendPlayerGift(this._info.ID);
                     }
                     this._openGift = true;
                  }
                  this.showGiftFrame();
               }
         }
      }
      
      private function setVisible(param1:int) : void
      {
         this._view.visible = param1 == BagAndGiftFrame.BAGANDINFO || param1 == BagAndGiftFrame.CARDVIEW;
         if(Boolean(this._texpView))
         {
            this._texpView.visible = param1 == BagAndGiftFrame.TEXPVIEW;
         }
         if(Boolean(this._giftView))
         {
            this._giftView.visible = param1 == BagAndGiftFrame.GIFTVIEW;
         }
         if(this._view.visible)
         {
            this._view.switchShowII(param1 == BagAndGiftFrame.CARDVIEW);
         }
         if(Boolean(this._totemView))
         {
            this._totemView.visible = param1 == BagAndGiftFrame.TOTEMVIEW;
         }
      }
      
      private function showCardEquip() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(Boolean(this._info))
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.CARDVIEW);
      }
      
      private function showInfoFrame() : void
      {
         if(this._view == null)
         {
            this._view = ComponentFactory.Instance.creatCustomObject("bag.PersonalInfoView");
            this._view.showSelfOperation = false;
            addToContent(this._view);
         }
         if(Boolean(this._info))
         {
            this._view.info = this._info;
         }
         this.setVisible(BagAndGiftFrame.BAGANDINFO);
      }
      
      private function showTexpFrame() : void
      {
         try
         {
            if(this._texpView == null)
            {
               this._texpView = ComponentFactory.Instance.creatCustomObject("texpSystem.texpInfoView.main");
               addToContent(this._texpView);
            }
            if(Boolean(this._info))
            {
               this._texpView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.TEXPVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.TEXP_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createTexp);
         }
      }
      
      private function showTotem() : void
      {
         if(!PathManager.TotemEnable)
         {
            return;
         }
         if(!this._totemView)
         {
            TotemManager.instance.loadTotemModule(this.doShowTotem);
         }
         else
         {
            this.setVisible(BagAndGiftFrame.TOTEMVIEW);
         }
      }
      
      private function doShowTotem() : void
      {
         this._totemView = new TotemInfoView(this._info);
         addToContent(this._totemView);
         this.setVisible(BagAndGiftFrame.TOTEMVIEW);
      }
      
      private function __createTexp(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TEXP_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createTexp);
            this.showTexpFrame();
         }
      }
      
      private function showGiftFrame() : void
      {
         try
         {
            if(this._giftView == null)
            {
               this._giftView = new GiftInfoView();
               PositionUtils.setPos(this._giftView,"PlayerInfoFrame.giftViewPos");
               addToContent(this._giftView);
            }
            GiftController.Instance.canActive = false;
            if(Boolean(this._info))
            {
               this._giftView.info = this._info;
            }
            this.setVisible(BagAndGiftFrame.GIFTVIEW);
         }
         catch(e:Error)
         {
            UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GIFT_SYSTEM);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createGift);
         }
      }
      
      private function __createGift(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GIFT_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            this.showGiftFrame();
         }
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         this._texpBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         if(Boolean(this._giftBtn))
         {
            this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
         this._cardBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         if(Boolean(this._totemBtn))
         {
            this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlayer);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = 0;
         this.__changeHandler(null);
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         this._info = param1;
         if(Boolean(this._view))
         {
            this._view.info = this._info;
         }
         if(Boolean(this._texpView))
         {
            this._texpView.info = this._info;
         }
         if(Boolean(this._giftView))
         {
            this._giftView.info = this._info;
         }
         if(Boolean(this._giftBtn))
         {
            if(this._info.Grade < 16 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
            {
               this._giftBtn.enable = false;
            }
            else
            {
               this._giftBtn.enable = true;
            }
         }
         if(this._info.Grade < 20 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._cardBtn.enable = false;
         }
         else
         {
            this._cardBtn.enable = true;
         }
         if(this._info.Grade < 10 || StateManager.currentStateType == StateType.FIGHTING && this._info.ZoneID != 0 && this._info.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            this._texpBtn.enable = false;
         }
         else
         {
            this._texpBtn.enable = true;
         }
      }
      
      public function setAchivEnable(param1:Boolean) : void
      {
         this._view.setAchvEnable(param1);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._infoBtn))
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(Boolean(this._texpBtn))
         {
            ObjectUtils.disposeObject(this._texpBtn);
         }
         this._texpBtn = null;
         if(Boolean(this._giftBtn))
         {
            ObjectUtils.disposeObject(this._giftBtn);
         }
         this._giftBtn = null;
         if(Boolean(this._cardBtn))
         {
            ObjectUtils.disposeObject(this._cardBtn);
         }
         this._cardBtn = null;
         if(Boolean(this._btnGroup))
         {
            ObjectUtils.disposeObject(this._btnGroup);
         }
         this._btnGroup = null;
         if(Boolean(this._view))
         {
            this._view.dispose();
         }
         this._view = null;
         if(Boolean(this._texpView))
         {
            this._texpView.dispose();
         }
         this._texpView = null;
         if(Boolean(this._giftView))
         {
            this._giftView.dispose();
         }
         this._giftView = null;
         PlayerInfoViewControl.clearView();
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

