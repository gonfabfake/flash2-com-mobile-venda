package magicHouse.treasureHouse
{
   import bagAndInfo.bag.BagListView;
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.CellEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import magicHouse.MagicHouseBuyView;
   import magicHouse.MagicHouseModel;
   import magicHouse.MagicHouseTipFrame;
   
   public class MagicHouseTreasureBagListView extends BagListView
   {
      
      private static var MAX_LINE_NUM:int = 10;
      
      private static const baseDepotCount:int = 10;
      
      private var _depotNum:int;
      
      private var _needMoney:int = 0;
      
      private var _pos:int = 0;
      
      private var _frame:MagicHouseTipFrame;
      
      private var _selfInfo:SelfInfo;
      
      private var IsOK:Boolean;
      
      public function MagicHouseTreasureBagListView(param1:int, param2:int = 0)
      {
         super(param1,MAX_LINE_NUM);
         this._selfInfo = PlayerManager.Instance.Self;
      }
      
      public function addDepot(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:* = null;
         if(param1 == this._depotNum)
         {
            return;
         }
         _loc2_ = this._depotNum;
         while(_loc2_ < param1)
         {
            _loc3_ = _loc2_;
            _loc4_ = _cells[_loc3_] as MagicHouseTreasureCell;
            _loc4_.grayFilters = false;
            _loc4_.isOpen = true;
            _loc2_++;
         }
         this._depotNum = param1;
      }
      
      override protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if((param1.currentTarget as MagicHouseTreasureCell).info != null)
         {
            dispatchEvent(new CellEvent("doubleclick",param1.currentTarget));
         }
      }
      
      override protected function __clickHandler(param1:InteractiveEvent) : void
      {
         var _loc9_:MagicHouseBuyView = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(Boolean(param1.currentTarget.isOpen))
         {
            dispatchEvent(new CellEvent("itemclick",param1.currentTarget,false,false));
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            this._needMoney = 0;
            this._pos = param1.currentTarget.pos;
            _loc2_ = MagicHouseModel.instance.depotCount;
            while(_loc2_ < param1.currentTarget.pos + 1)
            {
               _loc2_++;
               this._needMoney += MagicHouseModel.instance.openDepotNeedMoney + (_loc2_ - 10 - 1) * MagicHouseModel.instance.depotPromoteNeedMoney;
            }
            _loc3_ = this._selfInfo.getBag(1);
            _loc4_ = _loc3_.getItemByTemplateId(29995);
            _loc5_ = int(_loc3_.getItemCountByTemplateId(29995));
            _loc6_ = int(ItemManager.Instance.getTemplateById(29995).Property3);
            _loc7_ = _loc6_ * _loc5_;
            _loc9_ = ComponentFactory.Instance.creatComponentByStylename("magicHouse.MagicHouseBuyViewFrame");
            if(!this._frame)
            {
               this._frame = ComponentFactory.Instance.creatComponentByStylename("magichouse.tipFrame");
               this._frame.titleText = LanguageMgr.GetTranslation("magichouse.treasureView.openDepotTitle");
               if(_loc7_ >= this._needMoney && Boolean(_loc4_))
               {
                  this.IsOK = true;
                  this._frame.setTipHtmlText(LanguageMgr.GetTranslation("magichouse.treasureView.openDepotTitle1",int(this._needMoney / _loc6_),_loc4_.Name,param1.currentTarget.pos + 1 - MagicHouseModel.instance.depotCount));
                  this._frame.item.visible = false;
               }
               else
               {
                  this.IsOK = false;
                  _loc8_ = _loc6_ <= 0 ? 0 : int(this._needMoney / _loc6_);
                  _loc9_.DepotCount = param1.currentTarget.pos + 1 - MagicHouseModel.instance.depotCount;
                  _loc9_.ItemCount = _loc8_;
                  _loc9_.Cost = this._needMoney;
                  _loc9_.BuyPos = this._pos;
                  _loc9_.show();
                  _loc9_.onMoneyChange(null);
               }
               LayerManager.Instance.addToLayer(this._frame,3,true,1);
               this._frame.okBtn.addEventListener("click",this.__okBtnHandler);
               this._frame.cancelBtn.addEventListener("click",this.__cancelBtnHandler);
               this._frame.addEventListener("response",this.__confirmResponse);
            }
            if(!(_loc7_ >= this._needMoney && _loc4_))
            {
               this.disposeFrame();
            }
         }
      }
      
      private function __okBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.IsOK)
         {
            SocketManager.Instance.out.magicOpenDepot(this._pos,false);
         }
         else
         {
            CheckMoneyUtils.instance.checkMoney(this._frame.item.isBind,this._needMoney,this.onCompleteHandler);
         }
         this.disposeFrame();
      }
      
      private function disposeFrame() : void
      {
         this._frame.removeEventListener("response",this.__okBtnHandler);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
      }
      
      protected function onCompleteHandler() : void
      {
         SocketManager.Instance.out.magicOpenDepot(this._pos,CheckMoneyUtils.instance.isBind);
      }
      
      private function __cancelBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._frame.removeEventListener("response",this.__cancelBtnHandler);
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
         this._frame.removeEventListener("response",this.__confirmResponse);
         ObjectUtils.disposeObject(this._frame);
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            this._frame.parent.removeChild(this._frame);
         }
         this._frame = null;
      }
      
      override protected function createCells() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         _cells = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < MAX_LINE_NUM)
         {
            _loc2_ = 0;
            while(_loc2_ < MAX_LINE_NUM)
            {
               _loc3_ = _loc1_ * MAX_LINE_NUM + _loc2_;
               _loc4_ = CellFactory.instance.createTreasureCell(_loc3_) as MagicHouseTreasureCell;
               addChild(_loc4_);
               _loc4_.bagType = _bagType;
               _loc4_.addEventListener("interactive_click",this.__clickHandler);
               _loc4_.addEventListener("interactive_double_click",this.__doubleClickHandler);
               DoubleClickManager.Instance.enableDoubleClick(_loc4_);
               _loc4_.addEventListener("lockChanged",__cellChanged);
               _cells[_loc4_.place] = _loc4_;
               if(this._depotNum <= _loc1_ * MAX_LINE_NUM + _loc2_)
               {
                  _loc4_.grayFilters = true;
                  _loc4_.isOpen = false;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function checkMagicHouseStoreCell() : int
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         _loc1_ = 0;
         while(_loc1_ < this._depotNum)
         {
            _loc2_ = _cells[_loc1_] as MagicHouseTreasureCell;
            if(!_loc2_.info)
            {
               return 1;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public function set depotNum(param1:int) : void
      {
         this._depotNum = param1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in _cells)
         {
            _loc1_.removeEventListener("interactive_click",this.__clickHandler);
            _loc1_.removeEventListener("interactive_double_click",this.__doubleClickHandler);
            _loc1_.removeEventListener("lockChanged",__cellChanged);
         }
         super.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

