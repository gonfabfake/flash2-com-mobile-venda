package bagAndInfo
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.MainToolBar;
   import ddt.view.tips.OneLineTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import giftSystem.GiftController;
   import giftSystem.view.GiftView;
   import homeTemple.HomeTempleManager;
   import pet.date.PetInfo;
   import petsBag.view.item.AddPetItem;
   import pvePowerBuff.PvePowerBuffEvent;
   import pvePowerBuff.PvePowerBuffManager;
   import road7th.comm.PackageIn;
   import totem.TotemManager;
   import totem.view.TotemMainView;
   import trainer.view.NewHandContainer;
   
   public class BagAndGiftFrame extends Frame
   {
      
      public static const BAGANDINFO:int = 0;
      
      public static const GIFTVIEW:int = 1;
      
      public static const CARDVIEW:int = 2;
      
      public static const TEXPVIEW:int = 3;
      
      public static const EFFORT:int = 4;
      
      public static const PETVIEW:int = 5;
      
      public static const TOTEMVIEW:int = 6;
      
      public static const AVATARCOLLECTIONVIEW:int = 7;
      
      public static const PVEPOWERBUFF_VIEW:int = 11;
      
      private static const TEXP_OPEN_LEVEL:int = 13;
      
      private static const GIFT_OPEN_LEVEL:int = 16;
      
      private static const TOTEM_OPEN_LEVEL:int = 20;
      
      private static const PET_OPEN_LEVEL:int = 25;
      
      private static const AVATAR_COLLECTION_OPEN_LEVEL:int = 10;
      
      private static var _firstOpenCard:Boolean = true;
      
      private var _infoFrame:BagAndInfoFrame;
      
      private var _giftView:GiftView;
      
      private var _totemView:TotemMainView;
      
      private var _BG:Scale9CornerImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _texpBtn:SelectedButton;
      
      private var _texpBtnTip:OneLineTip;
      
      private var _texpBtnSprite:Sprite;
      
      private var _texpBtnShine:IEffect;
      
      private var _giftBtn:SelectedButton;
      
      private var _giftBtnShine:IEffect;
      
      private var _giftBtnTip:OneLineTip;
      
      private var _giftBtnSprite:Sprite;
      
      private var _totemBtn:SelectedButton;
      
      private var _totemBtnSprite:Sprite;
      
      private var _totemBtnShine:IEffect;
      
      private var _totemBtnTip:OneLineTip;
      
      private var _bagType:int = 0;
      
      private var _frame:BaseAlerFrame;
      
      private var _pvePowerBuffBtn:SelectedButton;
      
      private var _pvePowerBuffBtnSprite:Sprite;
      
      private var _pvePowerBuffBtnShine:IEffect;
      
      private var _pvePowerBuffBtnTip:OneLineTip;
      
      private var _pvePowerBuffMainView:Sprite;
      
      private var _godTempleBtn:SelectedButton;
      
      private var _godTempleBtnSprite:Sprite;
      
      private var _godTempleBtnShine:IEffect;
      
      private var _godTempleBtnTip:OneLineTip;
      
      private var _avatarCollBtn:SelectedButton;
      
      private var _avatarCollBtnSprite:Sprite;
      
      private var _avatarCollBtnShine:IEffect;
      
      private var _avatarCollBtnTip:OneLineTip;
      
      public function BagAndGiftFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this.titleText = LanguageMgr.GetTranslation("tank.view.common.BellowStripViewII.bag");
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn");
         this._texpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.texpBtn");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.giftBtn");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("bagAndInfoFrame.bg");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._giftBtn);
         addToContent(this._texpBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._giftBtn);
         this._btnGroup.addSelectItem(this._texpBtn);
         this._btnGroup.selectIndex = 0;
         this.GiftbtnEnable();
         this.texpBtnEnable();
         this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemBtn");
         this.addToContent(this._totemBtn);
         this._btnGroup.addSelectItem(this._totemBtn);
         this.totemBtnEnable();
         this._avatarCollBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.avatarCollBtn1");
         this.addToContent(this._avatarCollBtn);
         this._btnGroup.addSelectItem(this._avatarCollBtn);
         this.avatarCollBtnEnable();
         this._pvePowerBuffBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.pvepowerbuffBtn");
         this.addToContent(this._pvePowerBuffBtn);
         this._btnGroup.addSelectItem(this._pvePowerBuffBtn);
         this.pvePowerBuffEnable();
         this._godTempleBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.godTempleBtn");
         this.addToContent(this._godTempleBtn);
         this._btnGroup.addSelectItem(this._godTempleBtn);
         this.godTempleBtnEnable();
      }
      
      public function get btnGroup() : SelectedButtonGroup
      {
         return this._btnGroup;
      }
      
      private function godTempleBtnEnable() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 35 && PathManager.GodTempleEnable)
         {
            this._godTempleBtn.enable = true;
            ObjectUtils.disposeObject(this._godTempleBtnSprite);
            this._godTempleBtnSprite = null;
         }
         else
         {
            this._godTempleBtn.enable = false;
            if(this._godTempleBtnSprite == null)
            {
               this._godTempleBtnSprite = new Sprite();
               this._godTempleBtnSprite.graphics.beginFill(0,0);
               this._godTempleBtnSprite.graphics.drawRect(0,0,this._godTempleBtn.displayWidth - 12,this._godTempleBtn.displayHeight);
               this._godTempleBtnSprite.graphics.endFill();
               this._godTempleBtnSprite.x = this._godTempleBtn.x + 17;
               this._godTempleBtnSprite.y = this._godTempleBtn.y + 3;
               addToContent(this._godTempleBtnSprite);
               this._godTempleBtnTip = new OneLineTip();
               this._godTempleBtnTip.tipData = !PathManager.GodTempleEnable ? LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Templo") : LanguageMgr.GetTranslation("ddt.godTemple.openGodTempleBtn.text",35);
               this._godTempleBtnTip.visible = false;
               this._godTempleBtnSprite.addEventListener("rollOver",this.__godTempleOverHandler);
               this._godTempleBtnSprite.addEventListener("rollOut",this.__godTempleOutHandler);
            }
         }
      }
      
      private function __godTempleOverHandler(param1:MouseEvent) : void
      {
         this._godTempleBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._godTempleBtnTip,2);
         var _loc2_:Point = this._godTempleBtn.localToGlobal(new Point(0,0));
         this._godTempleBtnTip.x = _loc2_.x;
         this._godTempleBtnTip.y = _loc2_.y + this._godTempleBtn.height;
      }
      
      private function __godTempleOutHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._godTempleBtnTip))
         {
            this._godTempleBtnTip.visible = false;
         }
      }
      
      private function avatarCollBtnEnable() : void
      {
         var _loc1_:* = null;
         if(PlayerManager.Instance.Self.Grade >= 10 && PathManager.AvatarCollEnable)
         {
            this._avatarCollBtn.enable = true;
            if(Boolean(this._avatarCollBtnSprite))
            {
               ObjectUtils.disposeObject(this._avatarCollBtnSprite);
               this._avatarCollBtnSprite = null;
            }
         }
         else
         {
            this._avatarCollBtn.enable = false;
            if(!this._avatarCollBtnSprite)
            {
               this._avatarCollBtnSprite = new Sprite();
               this._avatarCollBtnSprite.addEventListener("mouseOver",this.__avatarCollBtnOverHandler);
               this._avatarCollBtnSprite.addEventListener("mouseOut",this.__avatarCollBtnOutHandler);
               this._avatarCollBtnSprite.graphics.beginFill(0,0);
               this._avatarCollBtnSprite.graphics.drawRect(0,0,this._avatarCollBtn.displayWidth - 12,this._avatarCollBtn.displayHeight);
               this._avatarCollBtnSprite.graphics.endFill();
               this._avatarCollBtnSprite.x = this._avatarCollBtn.x + 17;
               this._avatarCollBtnSprite.y = this._avatarCollBtn.y + 3;
               addToContent(this._avatarCollBtnSprite);
               this._avatarCollBtnTip = new OneLineTip();
               this._avatarCollBtnTip.tipData = !PathManager.AvatarCollEnable ? LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Fugura") : LanguageMgr.GetTranslation("ddt.avatarCollSystem.openAvatarCollBtn.text",10);
               this._avatarCollBtnTip.visible = false;
            }
         }
      }
      
      private function __avatarCollBtnOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         this._avatarCollBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._avatarCollBtnTip,2);
         _loc2_ = this._avatarCollBtn.localToGlobal(new Point(0,0));
         this._avatarCollBtnTip.x = _loc2_.x - 12;
         this._avatarCollBtnTip.y = _loc2_.y + this._avatarCollBtn.height;
      }
      
      private function __avatarCollBtnOutHandler(param1:MouseEvent) : void
      {
         this._avatarCollBtnTip.visible = false;
      }
      
      private function GiftbtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= 16 || GiftController.Instance.inChurch == true)
         {
            this._giftBtn.enable = true;
            if(Boolean(this._giftBtnSprite))
            {
               ObjectUtils.disposeObject(this._giftBtnSprite);
            }
            this._giftBtnSprite = null;
            if(SharedManager.Instance.giftFirstShow)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._giftBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._giftBtn,_loc1_);
               this._giftBtnShine.play();
            }
         }
         else
         {
            this._giftBtn.enable = false;
            if(this._giftBtnSprite == null)
            {
               this._giftBtnSprite = new Sprite();
               this._giftBtnSprite.graphics.beginFill(0,0);
               this._giftBtnSprite.graphics.drawRect(0,0,this._giftBtn.width,this._giftBtn.height);
               this._giftBtnSprite.graphics.endFill();
               this._giftBtnSprite.x = this._giftBtn.x;
               this._giftBtnSprite.y = this._giftBtn.y;
               addToContent(this._giftBtnSprite);
               this._giftBtnTip = new OneLineTip();
               this._giftBtnTip.tipData = LanguageMgr.GetTranslation("ddt.giftSystem.openGiftBtn.text");
               this._giftBtnTip.visible = false;
               this._giftBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._giftBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
         }
      }
      
      private function texpBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            this._texpBtn.enable = true;
            if(Boolean(this._texpBtnSprite))
            {
               ObjectUtils.disposeObject(this._texpBtnSprite);
               this._texpBtnSprite = null;
            }
            if(SharedManager.Instance.texpSystemShow && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._texpBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._texpBtn,_loc1_);
               this._texpBtnShine.play();
            }
         }
         else
         {
            this._texpBtn.enable = false;
            if(!this._texpBtnSprite)
            {
               this._texpBtnSprite = new Sprite();
               this._texpBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__texpBtnOverHandler);
               this._texpBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__texpBtnOutHandler);
               this._texpBtnSprite.graphics.beginFill(0,0);
               this._texpBtnSprite.graphics.drawRect(0,0,this._texpBtn.width,this._texpBtn.height);
               this._texpBtnSprite.graphics.endFill();
               this._texpBtnSprite.x = this._texpBtn.x;
               this._texpBtnSprite.y = this._texpBtn.y;
               addToContent(this._texpBtnSprite);
               this._texpBtnTip = new OneLineTip();
               this._texpBtnTip.tipData = LanguageMgr.GetTranslation("ddt.texpSystem.openTexpBtn.text");
               this._texpBtnTip.visible = false;
            }
         }
      }
      
      private function totemBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= TOTEM_OPEN_LEVEL && PathManager.TotemEnable)
         {
            this._totemBtn.enable = true;
            if(Boolean(this._totemBtnSprite))
            {
               ObjectUtils.disposeObject(this._totemBtnSprite);
               this._totemBtnSprite = null;
            }
         }
         else
         {
            this._totemBtn.enable = false;
            if(!this._totemBtnSprite)
            {
               this._totemBtnSprite = new Sprite();
               this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__totemBtnOverHandler);
               this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__totemBtnOutHandler);
               this._totemBtnSprite.graphics.beginFill(0,0);
               this._totemBtnSprite.graphics.drawRect(0,0,this._totemBtn.displayWidth,this._totemBtn.displayHeight);
               this._totemBtnSprite.graphics.endFill();
               this._totemBtnSprite.x = this._totemBtn.x - 1;
               this._totemBtnSprite.y = this._totemBtn.y + 3;
               addToContent(this._totemBtnSprite);
               this._totemBtnTip = new OneLineTip();
               this._totemBtnTip.tipData = LanguageMgr.GetTranslation("ddt.totemSystem.openTotemBtn.text",TOTEM_OPEN_LEVEL);
               this._totemBtnTip.visible = false;
            }
         }
      }
      
      private function __totemBtnOverHandler(param1:MouseEvent) : void
      {
         this._totemBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._totemBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._totemBtn.localToGlobal(new Point(0,0));
         this._totemBtnTip.x = _loc2_.x - 9;
         this._totemBtnTip.y = _loc2_.y + this._totemBtn.height;
      }
      
      private function __totemBtnOutHandler(param1:MouseEvent) : void
      {
         this._totemBtnTip.visible = false;
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._texpBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         if(Boolean(this._totemBtn))
         {
            this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this._pvePowerBuffBtn))
         {
            this._pvePowerBuffBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this._godTempleBtn))
         {
            this._godTempleBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this._avatarCollBtn))
         {
            this._avatarCollBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_PET,this.__addPet);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               SoundManager.instance.play("008");
               (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               (param1.currentTarget as BaseAlerFrame).dispose();
               SocketManager.Instance.out.sendClearStoreBag();
         }
      }
      
      public function __addPet(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:AddPetItem = null;
         var _loc3_:FilterFrameText = null;
         var _loc4_:AlertInfo = null;
         var _loc5_:PackageIn = param1.pkg;
         var _loc6_:int = _loc5_.readInt();
         var _loc7_:Boolean = _loc5_.readBoolean();
         var _loc8_:PetInfo = new PetInfo();
         _loc8_.TemplateID = _loc6_;
         PetInfoManager.fillPetInfo(_loc8_);
         if(Boolean(_loc8_))
         {
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename("bagandinfo.bagAndInfo.itemOpenUpTxt");
            _loc3_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.bagAndInfo.itemOpenUpTxt");
            this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame2");
            _loc2_ = ComponentFactory.Instance.creat("bagAndInfo.petAddItem",[_loc8_]);
            _loc4_ = new AlertInfo(_loc8_.Name);
            _loc4_.showCancel = false;
            _loc4_.moveEnable = false;
            this._frame.info = _loc4_;
            this._frame.addToContent(_loc3_);
            this._frame.addToContent(_loc2_);
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._infoFrame.clearTexpInfo();
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._giftBtnSprite))
         {
            this._giftBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this._giftBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         }
         if(Boolean(this._texpBtnSprite))
         {
            this._texpBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__texpBtnOverHandler);
            this._texpBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__texpBtnOutHandler);
         }
         if(Boolean(this._totemBtnSprite))
         {
            this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__totemBtnOverHandler);
            this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__totemBtnOutHandler);
         }
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._texpBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         if(Boolean(this._totemBtn))
         {
            this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         if(Boolean(this._avatarCollBtn))
         {
            this._avatarCollBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         }
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_PET,this.__addPet);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      protected function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["Grade"]))
         {
            if(PlayerManager.Instance.Self.Grade == 10)
            {
               this.texpBtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == 16)
            {
               this.GiftbtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == TOTEM_OPEN_LEVEL && PathManager.TotemEnable)
            {
               this.totemBtnEnable();
            }
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         this._giftBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._giftBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._giftBtn.localToGlobal(new Point(0,0));
         this._giftBtnTip.x = _loc2_.x;
         this._giftBtnTip.y = _loc2_.y + this._giftBtn.height;
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         this._giftBtnTip.visible = false;
      }
      
      private function __texpBtnOverHandler(param1:MouseEvent) : void
      {
         this._texpBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._texpBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._texpBtn.localToGlobal(new Point(0,0));
         this._texpBtnTip.x = _loc2_.x;
         this._texpBtnTip.y = _loc2_.y + this._texpBtn.height;
      }
      
      private function __texpBtnOutHandler(param1:MouseEvent) : void
      {
         this._texpBtnTip.visible = false;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         if(Boolean(this._infoFrame))
         {
            this._infoFrame.clearTexpInfo();
         }
         HomeTempleManager.getInstance().removeView();
         switch(this._btnGroup.selectIndex)
         {
            case BAGANDINFO:
               this.showInfoFrame(BAGANDINFO,this._bagType);
               break;
            case GIFTVIEW:
               this.showGiftFrame();
               break;
            case 2:
               this.showInfoFrame(TEXPVIEW);
               break;
            case 3:
               if(!PathManager.TotemEnable)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Totem"));
                  break;
               }
               this.showTotem();
               break;
            case 4:
               if(!PathManager.AvatarCollEnable)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Fugura"));
                  break;
               }
               this.showAvatarCollection();
               break;
            case 5:
               if(!PathManager.PveBuffEnable)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Batismo"));
                  break;
               }
               this.showPvePowerBuff();
               break;
            case 6:
               if(!PathManager.GodTempleEnable)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Templo"));
                  break;
               }
               this.showGodTemple();
         }
      }
      
      private function showGodTemple() : void
      {
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(139))
         {
            if(PlayerManager.Instance.Self.Grade >= 35)
            {
               SocketManager.Instance.out.syncWeakStep(139);
               NewHandContainer.Instance.clearArrowByID(149);
            }
         }
         HomeTempleManager.getInstance().setContainer(_container);
         HomeTempleManager.getInstance().show();
         this.setVisible(10);
      }
      
      private function setVisible(param1:int) : void
      {
         if(Boolean(this._infoFrame))
         {
            this._infoFrame.visible = param1 == BAGANDINFO ? Boolean(true) : Boolean(false);
         }
         if(Boolean(this._giftView))
         {
            this._giftView.visible = param1 == GIFTVIEW ? Boolean(true) : Boolean(false);
         }
         if(Boolean(this._totemView))
         {
            this._totemView.visible = param1 == TOTEMVIEW ? Boolean(true) : Boolean(false);
         }
         AvatarCollectionManager.instance.visible(param1 == 7);
         if(Boolean(this._pvePowerBuffMainView))
         {
            this._pvePowerBuffMainView.visible = param1 == 11;
         }
      }
      
      private function showGiftFrame() : void
      {
         if(Boolean(this._giftBtnShine))
         {
            this._giftBtnShine.stop();
            SharedManager.Instance.giftFirstShow = false;
            SharedManager.Instance.save();
         }
         if(this._giftView == null)
         {
            try
            {
               this._giftView = ComponentFactory.Instance.creatCustomObject("giftView");
               addToContent(this._giftView);
            }
            catch(e:Error)
            {
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GIFT_SYSTEM);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createGift);
               return;
            }
         }
         GiftController.Instance.canActive = true;
         SocketManager.Instance.out.sendUpdateGoodsCount();
         this._giftView.info = PlayerManager.Instance.Self;
         this.setVisible(GIFTVIEW);
      }
      
      private function __createGift(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GIFT_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            this.showGiftFrame();
         }
      }
      
      private function showInfoFrame(param1:int, param2:int = 0) : void
      {
         if(param1 == TEXPVIEW && Boolean(this._texpBtnShine))
         {
            this._texpBtnShine.stop();
            SharedManager.Instance.texpSystemShow = false;
            SharedManager.Instance.save();
         }
         if(this._infoFrame == null)
         {
            this._infoFrame = ComponentFactory.Instance.creatCustomObject("bagAndInfoFrame");
            addToContent(this._infoFrame);
         }
         if(param1 == PETVIEW)
         {
            this._infoFrame.isScreenFood = true;
         }
         else
         {
            this._infoFrame.isScreenFood = false;
         }
         this._infoFrame.switchShow(param1,param2);
         this.setVisible(BAGANDINFO);
      }
      
      private function __getFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            if(PvePowerBuffManager.instance.isInGetBuff == true)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemBusy"));
               return;
            }
            this.dispose();
            if(PlayerManager.Instance.Self.Grade == 3)
            {
               MainToolBar.Instance.tipTask();
            }
         }
      }
      
      public function show(param1:int, param2:String = "", param3:int = 0) : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._bagType = param3;
         this._btnGroup.selectIndex = param1;
         if(GiftController.Instance.inChurch == true)
         {
            this._infoBtn.enable = false;
            this._texpBtn.enable = false;
            this._godTempleBtn.enable = false;
            this._avatarCollBtn.enable = false;
         }
         if(param1 == GIFTVIEW && param2 != "")
         {
            setTimeout(GiftController.Instance.RebackClick,300,param2);
         }
         this.__changeHandler(null);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._giftBtnShine))
         {
            EffectManager.Instance.removeEffect(this._giftBtnShine);
         }
         this._giftBtnShine = null;
         if(Boolean(this._texpBtnShine))
         {
            EffectManager.Instance.removeEffect(this._texpBtnShine);
         }
         this._texpBtnShine = null;
         BagAndInfoManager.Instance.clearReference();
         this.removeEvent();
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
         if(Boolean(this._texpBtnTip))
         {
            ObjectUtils.disposeObject(this._texpBtnTip);
         }
         this._texpBtnTip = null;
         if(Boolean(this._texpBtnSprite))
         {
            ObjectUtils.disposeObject(this._texpBtnSprite);
         }
         this._texpBtnSprite = null;
         if(Boolean(this._giftBtn))
         {
            ObjectUtils.disposeObject(this._giftBtn);
         }
         this._giftBtn = null;
         if(Boolean(this._BG))
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(Boolean(this._totemBtnTip))
         {
            ObjectUtils.disposeObject(this._totemBtnTip);
         }
         if(Boolean(this._totemBtn))
         {
            ObjectUtils.disposeObject(this._totemBtn);
         }
         this._totemBtn = null;
         this._totemBtnTip = null;
         this._totemBtnShine = null;
         if(Boolean(this._giftBtnSprite))
         {
            ObjectUtils.disposeObject(this._giftBtnSprite);
         }
         this._giftBtnSprite = null;
         if(Boolean(this._giftBtnTip))
         {
            ObjectUtils.disposeObject(this._giftBtnTip);
         }
         this._giftBtnTip = null;
         if(Boolean(this._infoFrame))
         {
            this._infoFrame.dispose();
         }
         this._infoFrame = null;
         if(Boolean(this._giftView))
         {
            this._giftView.dispose();
         }
         this._giftView = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this._avatarCollBtn))
         {
            ObjectUtils.disposeObject(this._avatarCollBtn);
         }
         this._avatarCollBtn = null;
         ObjectUtils.disposeObject(this._pvePowerBuffBtn);
         this._pvePowerBuffBtn = null;
         ObjectUtils.disposeObject(this._pvePowerBuffMainView);
         this._pvePowerBuffMainView = null;
         PvePowerBuffManager.instance.disposeView();
         AvatarCollectionManager.instance.closeFrame();
         ObjectUtils.disposeObject(this._godTempleBtn);
         this._godTempleBtn = null;
         super.dispose();
      }
      
      private function showAvatarCollection() : void
      {
         if(Boolean(this._avatarCollBtnShine))
         {
            this._avatarCollBtnShine.stop();
            SocketManager.Instance.out.syncWeakStep(106);
         }
         AvatarCollectionManager.instance.showFrame(_container);
         this.setVisible(7);
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
            this.setVisible(TOTEMVIEW);
         }
      }
      
      private function doShowTotem() : void
      {
         this._totemView = ComponentFactory.Instance.creatCustomObject("totemView");
         addToContent(this._totemView);
         this.setVisible(TOTEMVIEW);
      }
      
      private function pvePowerBuffEnable() : void
      {
         if(PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.pvePowerBuffLevelLimit && PathManager.PveBuffEnable)
         {
            this._pvePowerBuffBtn.enable = true;
            ObjectUtils.disposeObject(this._pvePowerBuffBtnSprite);
            this._pvePowerBuffBtnSprite = null;
         }
         else
         {
            this._pvePowerBuffBtn.enable = false;
            if(this._pvePowerBuffBtnSprite == null)
            {
               this._pvePowerBuffBtnSprite = new Sprite();
               this._pvePowerBuffBtnSprite.graphics.beginFill(0,0);
               this._pvePowerBuffBtnSprite.graphics.drawRect(0,0,this._pvePowerBuffBtn.displayWidth - 12,this._pvePowerBuffBtn.displayHeight);
               this._pvePowerBuffBtnSprite.graphics.endFill();
               this._pvePowerBuffBtnSprite.x = this._pvePowerBuffBtn.x + 17;
               this._pvePowerBuffBtnSprite.y = this._pvePowerBuffBtn.y + 3;
               addToContent(this._pvePowerBuffBtnSprite);
               this._pvePowerBuffBtnTip = new OneLineTip();
               this._pvePowerBuffBtnTip.tipData = !PathManager.PveBuffEnable ? LanguageMgr.GetTranslation("ddt.tank.functionNotOpen","Batismo") : LanguageMgr.GetTranslation("ddt.pvePowerBuff.openPvePowerBuffBtn.text",ServerConfigManager.instance.pvePowerBuffLevelLimit);
               this._pvePowerBuffBtnTip.visible = false;
               this._pvePowerBuffBtnSprite.addEventListener("rollOver",this.__pvePowerBuffOverHandler);
               this._pvePowerBuffBtnSprite.addEventListener("rollOut",this.__pvePowerBuffOutHandler);
            }
         }
      }
      
      private function __pvePowerBuffOverHandler(param1:MouseEvent) : void
      {
         this._pvePowerBuffBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._pvePowerBuffBtnTip,2);
         var _loc2_:Point = this._pvePowerBuffBtn.localToGlobal(new Point(0,0));
         this._pvePowerBuffBtnTip.x = _loc2_.x;
         this._pvePowerBuffBtnTip.y = _loc2_.y + 45;
      }
      
      private function __pvePowerBuffOutHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._pvePowerBuffBtnTip))
         {
            this._pvePowerBuffBtnTip.visible = false;
         }
      }
      
      private function showPvePowerBuff() : void
      {
         if(!this._pvePowerBuffMainView)
         {
            PvePowerBuffManager.instance.addEventListener("pvePowerBuffLoadComplete",this.__doShowPvePowerBuff);
            PvePowerBuffManager.instance.showNewBuff();
         }
         else
         {
            this.setVisible(11);
         }
      }
      
      private function __doShowPvePowerBuff(param1:PvePowerBuffEvent) : void
      {
         PvePowerBuffManager.instance.removeEventListener("pvePowerBuffLoadComplete",this.__doShowPvePowerBuff);
         this._pvePowerBuffMainView = param1.info;
         addToContent(this._pvePowerBuffMainView);
         this.setVisible(11);
      }
   }
}

