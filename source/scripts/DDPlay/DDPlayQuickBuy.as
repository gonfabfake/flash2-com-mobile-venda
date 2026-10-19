package DDPlay
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.caddyII.bead.QuickBuyItem;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DDPlayQuickBuy extends BaseAlerFrame
   {
      
      public static const DDPLAY_COIN_NUMBER:int = 0;
      
      public static const CADDY_NUMBER:int = 1;
      
      private var _list:HBox;
      
      private var _cellItems:Vector.<QuickBuyItem>;
      
      private var _shopItemInfoList:Vector.<ShopItemInfo>;
      
      private var _money:int;
      
      private var _gift:int;
      
      private var _clickNumber:int;
      
      private var _cellId:Array = [EquipType.DDPLAY_COIN];
      
      private var _selectedItem:QuickBuyItem;
      
      private var _font2:FilterFrameText;
      
      public function DDPlayQuickBuy()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("DDPlay.quickBox");
         PositionUtils.setPos(this._list,"DDPlay.quickBuy.listPos");
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("asset.medicineQuickBugText1");
         this._font2 = ComponentFactory.Instance.creatComponentByStylename("asset.medicineQuickBugText2");
         var _loc2_:Image = ComponentFactory.Instance.creat("asset.medicineQuickBugTextBg");
         _loc1_.text = LanguageMgr.GetTranslation("tank.ddPlay.quickBuy.totalPay");
         this._font2.text = LanguageMgr.GetTranslation("money");
         PositionUtils.setPos(_loc1_,"DDPlay.quickBuy.font1Pos");
         PositionUtils.setPos(this._font2,"DDPlay.quickBuy.font2Pos");
         PositionUtils.setPos(_loc2_,"DDPlay.quickBuy.moneybgPos");
         addToContent(_loc2_);
         addToContent(_loc1_);
         addToContent(this._font2);
         this.creatCell();
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         var _loc1_:QuickBuyItem = null;
         removeEventListener(FrameEvent.RESPONSE,this._response);
         for each(_loc1_ in this._cellItems)
         {
            _loc1_.removeEventListener(Event.CHANGE,this._numberChange);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc1_.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            _loc1_.removeEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
         }
      }
      
      private function creatCell() : void
      {
         var _loc1_:QuickBuyItem = null;
         this._cellItems = new Vector.<QuickBuyItem>();
         this._shopItemInfoList = new Vector.<ShopItemInfo>();
         this._list.beginChanges();
         var _loc2_:int = 0;
         while(_loc2_ < this._cellId.length)
         {
            _loc1_ = new QuickBuyItem();
            _loc1_.itemID = this._cellId[_loc2_];
            _loc1_.addEventListener(Event.CHANGE,this._numberChange);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__itemClick);
            _loc1_.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
            _loc1_.addEventListener(NumberSelecter.NUMBER_ENTER,this._numberEnter);
            this._list.addChild(_loc1_);
            this._cellItems.push(_loc1_);
            _loc2_++;
         }
         this._list.commitChanges();
         this._shopItemInfoList.push(ShopManager.Instance.getMoneyShopItemByTemplateID(this._cellId[DDPLAY_COIN_NUMBER]));
         this._shopItemInfoList.push(ShopManager.Instance.getGiftShopItemByTemplateID(this._cellId[CADDY_NUMBER]));
         this._cellItems[0].selectNumber.maximum = 50;
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:QuickBuyItem = param1.currentTarget as QuickBuyItem;
         this.selectedItem = _loc2_;
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(this.money > 0 || this.gift > 0)
            {
               this.buy();
               ObjectUtils.disposeObject(this);
            }
            else
            {
               this._showTip();
            }
         }
         else
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      private function _numberChange(param1:Event) : void
      {
         this.money = this._cellItems[DDPLAY_COIN_NUMBER].count * this._shopItemInfoList[DDPLAY_COIN_NUMBER].getItemPrice(1).moneyValue;
         var _loc2_:QuickBuyItem = param1.currentTarget as QuickBuyItem;
         this.selectedItem = _loc2_;
      }
      
      private function _numberClose(param1:Event) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function _numberEnter(param1:Event) : void
      {
         if(this.money > 0 || this.gift > 0)
         {
            this.buy();
            ObjectUtils.disposeObject(this);
         }
         else
         {
            this._showTip();
         }
      }
      
      private function buy() : void
      {
         var _loc1_:BaseAlerFrame = null;
         var _loc2_:int = 0;
         if(this.money > 0 && !this._shopItemInfoList[DDPLAY_COIN_NUMBER].isValid || this.gift > 0 && !this._shopItemInfoList[CADDY_NUMBER].isValid)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.caddy.quickDate"));
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.money)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc1_.moveEnable = false;
            _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseI);
            return;
         }
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:int = 0;
         while(_loc9_ < this._cellItems.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this._cellItems[_loc9_].count)
            {
               _loc3_.push(this._shopItemInfoList[_loc9_].GoodsID);
               _loc4_.push(1);
               _loc5_.push("");
               _loc6_.push(false);
               _loc7_.push("");
               _loc8_.push(-1);
               _loc2_++;
            }
            _loc9_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc3_,_loc4_,_loc5_,_loc8_,_loc6_,_loc7_,0);
      }
      
      private function _responseI(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._responseI);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.target);
      }
      
      private function _showTip() : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bead.quickNoBuy"));
      }
      
      public function set money(param1:int) : void
      {
         this._money = param1;
         this._font2.text = param1 + LanguageMgr.GetTranslation("money");
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function set gift(param1:int) : void
      {
         this._gift = param1;
      }
      
      public function get gift() : int
      {
         return this._gift;
      }
      
      public function set clickNumber(param1:int) : void
      {
         this._clickNumber = param1;
         this._cellItems[this._clickNumber].count = 1;
         this._cellItems[this._clickNumber].setFocus();
      }
      
      public function show(param1:int) : void
      {
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
         _loc2_.data = this._list;
         _loc2_.submitLabel = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
         _loc2_.showCancel = false;
         _loc2_.moveEnable = false;
         info = _loc2_;
         addToContent(this._list);
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.clickNumber = param1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:QuickBuyItem = null;
         this.removeEvents();
         for each(_loc1_ in this._cellItems)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._cellItems = null;
         this._cellId = null;
         this._shopItemInfoList = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get selectedItem() : QuickBuyItem
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(param1:QuickBuyItem) : void
      {
         var _loc2_:QuickBuyItem = this._selectedItem;
         this._selectedItem = param1;
         this._selectedItem.selected = true;
         if(Boolean(_loc2_) && this._selectedItem != _loc2_)
         {
            _loc2_.selected = false;
         }
      }
   }
}

