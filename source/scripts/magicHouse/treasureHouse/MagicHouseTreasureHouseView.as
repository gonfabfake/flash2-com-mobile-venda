package magicHouse.treasureHouse
{
   import bagAndInfo.bag.BagView;
   import bagAndInfo.bag.CellMenu;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseModel;
   
   public class MagicHouseTreasureHouseView extends BagView
   {
      
      private var _bagListBg:MutipleImage;
      
      private var _bagTipBitmap:Bitmap;
      
      private var _treasureBagListView:MagicHouseTreasureBagListView;
      
      private var _changeToConsortion:SimpleBitmapButton;
      
      public function MagicHouseTreasureHouseView()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bagListBg = ComponentFactory.Instance.creatComponentByStylename("magicHouse.treasureHouseView.bagList.bg");
         this._bagTipBitmap = ComponentFactory.Instance.creatBitmap("magichouse.treasure.bagtip");
         this._changeToConsortion = ComponentFactory.Instance.creatComponentByStylename("magicHouse.treasureView.stateChangeBtn");
         addChild(this._bagListBg);
         setChildIndex(this._bagListBg,0);
         addChild(this._bagTipBitmap);
         addChild(this._changeToConsortion);
         this.setInit();
         this.setData(PlayerManager.Instance.Self);
      }
      
      private function setInit() : void
      {
         enableUpdateLockState = false;
         _sortBagBtn.visible = false;
         _settedLockBtn.visible = false;
         _settingLockBtn.visible = false;
         _trieveBtn.visible = false;
         _cardBtn.visible = false;
      }
      
      public function setData(param1:SelfInfo) : void
      {
         _equiplist.setData(param1.Bag);
         _proplist.setData(param1.PropBag);
         this._treasureBagListView.setData(param1.MagicHouseBag);
      }
      
      override protected function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               if(_loc3_.getRemainDate() <= 0 && !EquipType.isProp(_loc3_) || EquipType.isPackage(_loc3_) || _loc3_.getRemainDate() <= 0 && _loc3_.TemplateID == 10200 || EquipType.canBeUsed(_loc3_))
               {
                  _loc4_ = localToGlobal(new Point(_loc2_.x,_loc2_.y));
                  CellMenu.instance.show(_loc2_,_loc4_.x + 35,_loc4_.y + 77);
               }
               else
               {
                  if(this.checkDressSaved(_loc3_))
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
                     return;
                  }
                  _loc2_.dragStart();
               }
            }
         }
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         this._treasureBagListView.addEventListener("itemclick",this.__bankCellClick);
         this._treasureBagListView.addEventListener("doubleclick",this.__bankCellDoubleClick);
         addEventListener("addedToStage",this.__addToStageHandler);
         _proplist.addEventListener("doubleclick",this.__cellDoubleClick);
         _equiplist.addEventListener("change",this.__listChange);
         _proplist.addEventListener("change",this.__listChange);
         this._changeToConsortion.addEventListener("click",this.__jumpToConsortion);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__upMagicHouseStroeLevel);
         MagicHouseManager.instance.addEventListener("magichouse_updata",this.__messageUpdate);
      }
      
      override protected function removeEvents() : void
      {
         this._treasureBagListView.removeEventListener("itemclick",this.__bankCellClick);
         this._treasureBagListView.removeEventListener("doubleclick",this.__bankCellDoubleClick);
         removeEventListener("addedToStage",this.__addToStageHandler);
         _proplist.removeEventListener("doubleclick",this.__cellDoubleClick);
         _equiplist.removeEventListener("change",this.__listChange);
         _proplist.removeEventListener("change",this.__listChange);
         this._changeToConsortion.removeEventListener("click",this.__jumpToConsortion);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__upMagicHouseStroeLevel);
         MagicHouseManager.instance.removeEventListener("magichouse_updata",this.__messageUpdate);
         super.removeEvents();
      }
      
      override protected function initBackGround() : void
      {
         super.initBackGround();
         this._treasureBagListView = new MagicHouseTreasureBagListView(51,MagicHouseModel.instance.depotCount);
         PositionUtils.setPos(this._treasureBagListView,"magicHouse.TreasureBag.Pos");
         addChild(this._treasureBagListView);
      }
      
      override protected function __listChange(param1:Event) : void
      {
         if(param1.currentTarget == _equiplist)
         {
            setBagType(0);
         }
         else
         {
            setBagType(1);
         }
      }
      
      private function __jumpToConsortion(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __messageUpdate(param1:Event) : void
      {
         this._treasureBagListView.addDepot(MagicHouseModel.instance.depotCount);
      }
      
      private function __upMagicHouseStroeLevel(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["StoreLevel"]))
         {
            this.__addToStageHandler(null);
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._treasureBagListView.addDepot(MagicHouseModel.instance.depotCount);
      }
      
      override protected function __cellDoubleClick(param1:CellEvent) : void
      {
         var _loc3_:BagCell = null;
         SoundManager.instance.play("008");
         var _loc2_:int = this._treasureBagListView.checkMagicHouseStoreCell();
         if(_loc2_ == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.treasureView.bagFull"));
            return;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         param1.stopImmediatePropagation();
         _loc3_ = param1.data as BagCell;
         var _loc4_:InventoryItemInfo = _loc3_.info as InventoryItemInfo;
         if(this.checkDressSaved(_loc4_))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("playerDress.cannotStore"));
            return;
         }
         var _loc5_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
         var _loc6_:int = PlayerManager.Instance.Self.Sex ? 1 : 2;
         if(!_loc3_.locked)
         {
            SocketManager.Instance.out.sendMoveGoods(_loc4_.BagType,_loc4_.Place,51,-1);
         }
      }
      
      override protected function __sortBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BagInfo = PlayerManager.Instance.Self.getBag(51);
         PlayerManager.Instance.Self.PropBag.sortBag(51,_loc2_,0,100,true);
         if(_bagType != 21)
         {
            PlayerManager.Instance.Self.PropBag.sortBag(_bagType,PlayerManager.Instance.Self.getBag(_bagType),0,48,true);
         }
         else
         {
            PlayerManager.Instance.Self.PropBag.sortBag(_bagType,PlayerManager.Instance.Self.getBag(_bagType),32,178,true);
         }
      }
      
      private function __bankCellClick(param1:CellEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(!_sellBtn.isActive)
         {
            param1.stopImmediatePropagation();
            _loc2_ = param1.data as BagCell;
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.info as InventoryItemInfo;
            }
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc2_.locked)
            {
               SoundManager.instance.play("008");
               _loc2_.dragStart();
            }
         }
      }
      
      private function __bankCellDoubleClick(param1:CellEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BagCell = param1.data as BagCell;
         var _loc3_:InventoryItemInfo = _loc2_.itemInfo;
         SocketManager.Instance.out.sendMoveGoods(_loc3_.BagType,_loc3_.Place,this.getItemBagType(_loc3_),-1,_loc3_.Count);
      }
      
      private function getItemBagType(param1:InventoryItemInfo) : int
      {
         if(EquipType.isBelongToPropBag(param1))
         {
            return 1;
         }
         return 0;
      }
      
      private function checkDressSaved(param1:InventoryItemInfo) : Boolean
      {
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._bagListBg))
         {
            ObjectUtils.disposeObject(this._bagListBg);
         }
         this._bagListBg = null;
         if(Boolean(this._changeToConsortion))
         {
            ObjectUtils.disposeObject(this._changeToConsortion);
         }
         this._changeToConsortion = null;
         if(Boolean(this._bagTipBitmap))
         {
            ObjectUtils.disposeObject(this._bagTipBitmap);
         }
         this._bagTipBitmap = null;
         if(Boolean(this._treasureBagListView))
         {
            ObjectUtils.disposeObject(this._treasureBagListView);
         }
         this._treasureBagListView = null;
      }
   }
}

