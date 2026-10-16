package magicHouse.magicCollection
{
   import bagAndInfo.cell.CellFactory;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import magicHouse.MagicHouseModel;
   import magicHouse.MagicHouseTipFrame;
   import shop.view.ShopItemCell;
   
   public class MagicHouseItemCell extends Sprite implements Disposeable
   {
      
      private var _type:int;
      
      private var _pos:int;
      
      private var _isOpen:Boolean = false;
      
      private var _info:ItemTemplateInfo;
      
      private var _cell:ShopItemCell;
      
      private var _openBtn:SimpleBitmapButton;
      
      private var _openEnable:Boolean;
      
      private var _frame:MagicHouseTipFrame;
      
      private var _alphaCell:Sprite;
      
      private var _itemContent:Component;
      
      public function MagicHouseItemCell()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._cell = this.createItemCell();
         addChild(this._cell);
         this._cell.x = -4;
         this._cell.y = -3;
         this._itemContent = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.itemTipContent");
         this._alphaCell = ComponentFactory.Instance.creat("magichouse.collectionItem.alphaCell");
         this._itemContent.addChild(this._alphaCell);
         this._itemContent.x = this._cell.x;
         this._itemContent.y = this._cell.y;
         this._alphaCell.width = 72;
         this._alphaCell.height = 72;
         addChild(this._itemContent);
         this._openBtn = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionView.itemCell.btn");
         addChild(this._openBtn);
      }
      
      private function initEvent() : void
      {
         this._openBtn.addEventListener("click",this.__openItem);
      }
      
      private function removeEvent() : void
      {
         this._openBtn.removeEventListener("click",this.__openItem);
      }
      
      private function __openItem(param1:MouseEvent) : void
      {
         if(this._openEnable)
         {
            if(!this._frame)
            {
               this._frame = ComponentFactory.Instance.creatComponentByStylename("magichouse.tipFrame");
               this._frame.titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
               this._frame.setTipText(LanguageMgr.GetTranslation("magichouse.collectionView.activateWeaponTip"));
               LayerManager.Instance.addToLayer(this._frame,3,true,1);
               this._frame.okBtn.addEventListener("click",this.__okBtnHandler);
               this._frame.cancelBtn.addEventListener("click",this.__cancelBtnHandler);
               this._frame.addEventListener("response",this.__confirmResponse);
            }
         }
      }
      
      private function __okBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener("response",this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
         this._openEnable = false;
         SocketManager.Instance.out.openMagicLib(this._type,this._pos);
      }
      
      private function __cancelBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener("response",this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener("response",this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            this._openEnable = false;
            SocketManager.Instance.out.openMagicLib(this._type,this._pos);
         }
      }
      
      public function setFilter() : void
      {
         var _loc1_:Boolean = Boolean(MagicHouseModel.instance.equipOpenList[(this._type - 1) * 3 + this._pos]);
         if(_loc1_)
         {
            if(Boolean(this._cell.getContent()))
            {
               this._cell.getContent().filters = [];
            }
         }
         else
         {
            this._cell.getContent().filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
         this._openBtn.visible = _loc1_;
         this._openEnable = _loc1_;
      }
      
      public function setOpened(param1:Boolean) : void
      {
         this._isOpen = param1;
         this._openBtn.visible = !param1;
      }
      
      public function set cellInfo(param1:ItemTemplateInfo) : void
      {
         this._info = param1;
         this._cell.info = param1;
         var _loc2_:Object = {};
         _loc2_.titleName = this._info.Name;
         _loc2_.type = EquipType.PARTNAME[this._info.CategoryID];
         _loc2_.activate = this._isOpen;
         _loc2_.datail = LanguageMgr.GetTranslation("magichouse.collectionItem.itemTip.activateDetail");
         _loc2_.placed = LanguageMgr.GetTranslation("avatarCollection.itemTip.placeTxt") + " " + LanguageMgr.GetTranslation("tank.view.movement.MovementLeftView.action");
         this._itemContent.tipData = _loc2_;
      }
      
      public function setTypeAndPos(param1:int, param2:int) : void
      {
         this._type = param1;
         this._pos = param2;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      private function createItemCell() : ShopItemCell
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,42,42);
         _loc1_.graphics.endFill();
         return CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._cell))
         {
            this._cell.dispose();
         }
         this._cell = null;
         if(Boolean(this._openBtn))
         {
            this._openBtn.dispose();
         }
         this._openBtn = null;
      }
   }
}

