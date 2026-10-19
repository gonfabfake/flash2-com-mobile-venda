package moneyTree.ui
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.common.LevelIcon;
   import ddt.view.common.SexIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import moneyTree.MoneyTreeManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class MoneyTreeSendRedPkgCell extends Sprite implements Disposeable, IListCell
   {
      
      private static const LevelLimit:int = 6;
      
      private static const RoomTypeLimit:int = 2;
      
      public var roomType:int;
      
      private var _data:Object;
      
      private var _levelIcon:LevelIcon;
      
      private var _sexIcon:SexIcon;
      
      private var _masterIcon:ScaleFrameImage;
      
      private var _name:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _BG:Bitmap;
      
      private var _BGII:Bitmap;
      
      private var _isSelected:Boolean;
      
      private var _inviteButton:TextButton;
      
      private var _unInviteButton:TextButton;
      
      private var _stringInvite:String;
      
      private var _stringCancel:String;
      
      private var _titleBG:ScaleFrameImage;
      
      private var _triangle:ScaleFrameImage;
      
      private var _titleText:FilterFrameText;
      
      private var _numText:FilterFrameText;
      
      public function MoneyTreeSendRedPkgCell()
      {
         super();
         this.configUi();
         this.addEvent();
         mouseEnabled = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._titleBG))
         {
            ObjectUtils.disposeObject(this._titleBG);
            this._titleBG = null;
         }
         if(Boolean(this._triangle))
         {
            ObjectUtils.disposeObject(this._triangle);
            this._triangle = null;
         }
         if(Boolean(this._titleText))
         {
            ObjectUtils.disposeObject(this._titleText);
            this._titleText = null;
         }
         if(Boolean(this._numText))
         {
            ObjectUtils.disposeObject(this._numText);
            this._numText = null;
         }
         if(Boolean(this._inviteButton))
         {
            ObjectUtils.disposeObject(this._inviteButton);
            this._inviteButton = null;
         }
         if(Boolean(this._unInviteButton))
         {
            ObjectUtils.disposeObject(this._unInviteButton);
            this._unInviteButton = null;
         }
         if(Boolean(this._sexIcon))
         {
            ObjectUtils.disposeObject(this._sexIcon);
            this._sexIcon = null;
         }
         if(Boolean(this._levelIcon))
         {
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
         }
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
            this._name = null;
         }
         if(Boolean(this._vipName))
         {
            ObjectUtils.disposeObject(this._vipName);
         }
         this._vipName = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function configUi() : void
      {
         this._name = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.playerItemName");
         this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtinvite.cell.LevelIcon");
         this._levelIcon.setSize(1);
         addChild(this._levelIcon);
         this._sexIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtinvite.cell.SexIcon");
         addChild(this._sexIcon);
         this._masterIcon = UICreatShortcut.creatAndAdd("asset.ddtinvite.cell.masterRelationIcon",this);
         this._stringInvite = LanguageMgr.GetTranslation("im.InviteDialogFrame.Choose");
         this._stringCancel = "  cancelar  ";
         this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.inviteBtn");
         addChild(this._inviteButton);
         this._inviteButton.text = this._stringInvite;
         this._inviteButton.backStyle = "core.littleGreen";
         this._inviteButton.x -= 36;
         this._inviteButton.y -= 4;
         this._unInviteButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.uninviteBtn");
         addChild(this._unInviteButton);
         this._unInviteButton.text = this._stringCancel;
         this._unInviteButton.backStyle = "core.bg6921";
         this._unInviteButton.x -= 41;
         this._unInviteButton.y -= 4;
         this._unInviteButton.visible = false;
         this._titleBG = ComponentFactory.Instance.creat("ddtinvite.titleItemBg");
         this._titleBG.setFrame(1);
         addChild(this._titleBG);
         this._triangle = ComponentFactory.Instance.creatComponentByStylename("ddtinvite.triangle");
         this._triangle.setFrame(1);
         addChild(this._triangle);
         this._titleText = ComponentFactory.Instance.creat("IM.item.title");
         PositionUtils.setPos(this._titleText,"ddtinvite.titleTxtPos");
         this._titleText.text = "";
         addChild(this._titleText);
         this._numText = ComponentFactory.Instance.creat("IM.item.title");
         this._numText.text = "";
         this._numText.y = this._titleText.y;
         addChild(this._numText);
      }
      
      private function addEvent() : void
      {
         addEventListener("mouseOver",this.__itemOver);
         addEventListener("mouseOut",this.__itemOut);
         this._inviteButton.addEventListener("click",this.__onInviteClick);
         this._unInviteButton.addEventListener("click",this.__onInviteClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("mouseOver",this.__itemOver);
         removeEventListener("mouseOut",this.__itemOut);
         this._inviteButton.removeEventListener("click",this.__onInviteClick);
         this._unInviteButton.removeEventListener("click",this.__onInviteClick);
      }
      
      public function reset() : void
      {
         this._data && (this._data.invited = false);
         this._inviteButton && (this._inviteButton.visible = true);
         this._unInviteButton && (this._unInviteButton.visible = false);
      }
      
      private function __onInviteClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:RoomInfo = RoomManager.Instance.current;
         if(this._data.invited == true)
         {
            this._data.invited = false;
            this._inviteButton.visible = true;
            this._unInviteButton.visible = false;
            MoneyTreeManager.getInstance().inviteBtnClicked(this._data["ID"],"unInvite");
         }
         else if(!MoneyTreeManager.getInstance().model.isNoMoreRedPkg())
         {
            this._data.invited = true;
            this._inviteButton.visible = false;
            this._unInviteButton.visible = true;
            MoneyTreeManager.getInstance().inviteBtnClicked(this._data["ID"],"invite");
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("moneytree.redpkgNotEnough"),0,true,1);
         }
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1;
         if(this._data.invited == true)
         {
            this._inviteButton.visible = false;
            this._unInviteButton.visible = true;
         }
         else
         {
            this._inviteButton.visible = true;
            this._unInviteButton.visible = false;
         }
         this.update();
      }
      
      private function update() : void
      {
         if(this._data.type == 0)
         {
            this.updateTitle();
         }
         else
         {
            this.updatePlayer();
         }
         if(this._triangle.visible)
         {
            this.updateItemState();
         }
      }
      
      private function updateItemState() : void
      {
         if(Boolean(this._data.titleIsSelected))
         {
            this._triangle.setFrame(2);
            this._titleBG.setFrame(2);
            this._titleBG.alpha = 1;
         }
         else
         {
            this._triangle.setFrame(1);
            this._titleBG.setFrame(1);
            this._titleBG.alpha = 0;
         }
      }
      
      private function __itemOver(param1:MouseEvent) : void
      {
         this._titleBG.alpha = 1;
      }
      
      private function __itemOut(param1:MouseEvent) : void
      {
         if(this._titleBG.visible && !this._data.titleIsSelected)
         {
            this._titleBG.alpha = 0;
         }
      }
      
      private function showTitle(param1:Boolean) : void
      {
         this._name.visible = !param1;
         this._levelIcon.visible = !param1;
         this._sexIcon.visible = !param1;
         this._masterIcon.visible = !param1;
         this._inviteButton.visible = !param1;
         if(Boolean(this._vipName))
         {
            this._vipName.visible = !param1;
         }
         this.buttonMode = param1;
         this._titleBG.visible = param1;
         this._titleBG.alpha = 0;
         this._triangle.visible = param1;
         this._titleText.visible = param1;
         this._numText.visible = param1;
      }
      
      private function updateTitle() : void
      {
         this.showTitle(true);
         this._triangle.setFrame(1);
         this._titleText.text = this._data.titleText;
         this._numText.text = this._data.titleNumText;
         this._numText.x = this._titleText.x + this._titleText.width;
      }
      
      private function updatePlayer() : void
      {
         this.showTitle(false);
         if(!this._data.invited)
         {
            this._inviteButton.enable = true;
            this._inviteButton.filters = null;
            this._unInviteButton.enable = true;
            this._unInviteButton.filters = null;
         }
         this._name.text = this._data.NickName;
         addChild(this._name);
         this._sexIcon.setSex(this._data.Sex);
         this._levelIcon.setInfo(this._data.Grade,this._data.Repute,this._data.WinCount,this._data.TotalCount,this._data.FightPower,this._data.Offer,true,false);
         this._masterIcon.visible = PlayerManager.Instance.Self.isMyApprent(this._data.ID) || PlayerManager.Instance.Self.isMyMaster(this._data.ID);
         this._sexIcon.visible = !this._masterIcon.visible;
         if(PlayerManager.Instance.Self.isMyMaster(this._data.ID))
         {
            if(Boolean(this._data.Sex))
            {
               this._masterIcon.setFrame(1);
            }
            else
            {
               this._masterIcon.setFrame(2);
            }
         }
         else if(Boolean(this._data.Sex))
         {
            this._masterIcon.setFrame(3);
         }
         else
         {
            this._masterIcon.setFrame(4);
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}

