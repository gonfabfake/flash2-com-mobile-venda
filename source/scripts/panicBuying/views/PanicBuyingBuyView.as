package panicBuying.views
{
   import baglocked.BaglockedManager;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   import panicBuying.data.PBuyingItemInfo;
   import shop.view.BuySingleGoodsView;
   import shop.view.ShopCartItem;
   import wonderfulActivity.data.GiftChildInfo;
   import wonderfulActivity.data.SendGiftInfo;
   
   public class PanicBuyingBuyView extends BuySingleGoodsView
   {
      
      private var _templateId:int;
      
      private var _info:PBuyingItemInfo;
      
      public function PanicBuyingBuyView(param1:int)
      {
         super(param1);
      }
      
      public function set info(param1:PBuyingItemInfo) : void
      {
         this._info = param1;
      }
      
      override public function set goodsID(param1:int) : void
      {
         var _loc2_:ShopCarItemInfo = null;
         if(Boolean(_shopCartItem))
         {
            _shopCartItem.removeEventListener("conditionchange",__shopCartItemChange);
            _shopCartItem.dispose();
         }
         this._templateId = param1;
         _loc2_ = new ShopCarItemInfo(0,this._templateId);
         _loc2_.APrice1 = this._info.priceType;
         _loc2_.APrice2 = this._info.priceType;
         _loc2_.APrice3 = this._info.priceType;
         _loc2_.BuyType = this._info.buyType;
         _loc2_.AUnit = this._info.unitCount;
         _loc2_.AValue1 = this._info.price;
         _loc2_.BUnit = -1;
         _loc2_.CUnit = -1;
         _shopCartItem = new ShopCartItem();
         PositionUtils.setPos(_shopCartItem,"ddtshop.shopCartItemPos");
         _shopCartItem.closeBtn.visible = false;
         _shopCartItem.setShopItemInfo(_loc2_);
         _shopCartItem.setColor(_loc2_.Color);
         _frame.addToContent(_shopCartItem);
         _shopCartItem.addEventListener("conditionchange",__shopCartItemChange);
         this.updateCommodityPrices();
      }
      
      override protected function updateCommodityPrices() : void
      {
         if(_shopCartItem.shopItemInfo.getCurrentPrice().PriceType == -1)
         {
            if(_isBand)
            {
               _commodityPricesText1.text = "0";
               _commodityPricesText2.text = (_shopCartItem.shopItemInfo.getCurrentPrice().bothMoneyValue * _numberSelecter.currentValue).toString();
            }
            else
            {
               _commodityPricesText1.text = (_shopCartItem.shopItemInfo.getCurrentPrice().bothMoneyValue * _numberSelecter.currentValue).toString();
               _commodityPricesText2.text = "0";
            }
            _shopCartItem.setDianquanType(_isBand);
         }
         else if(_shopCartItem.shopItemInfo.getCurrentPrice().PriceType == -8)
         {
            _commodityPricesText1.text = (_shopCartItem.shopItemInfo.getCurrentPrice().moneyValue * _numberSelecter.currentValue).toString();
            _commodityPricesText2.text = "0";
            _shopCartItem.setDianquanType(false);
         }
         else if(_shopCartItem.shopItemInfo.getCurrentPrice().PriceType == -9)
         {
            _commodityPricesText1.text = "0";
            _commodityPricesText2.text = (_shopCartItem.shopItemInfo.getCurrentPrice().bandDdtMoneyValue * _numberSelecter.currentValue).toString();
            _shopCartItem.setDianquanType(true);
         }
      }
      
      override protected function __purchaseConfirmationBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:Boolean = true;
         if(_type == -1)
         {
            _loc2_ = _shopCartItem.shopItemInfo.getCurrentPrice().bothMoneyValue;
         }
         else if(_type == -8)
         {
            _loc2_ = _shopCartItem.shopItemInfo.getCurrentPrice().moneyValue;
         }
         else if(_type == -9)
         {
            _loc2_ = _shopCartItem.shopItemInfo.getCurrentPrice().bandDdtMoneyValue;
            _loc3_ = false;
         }
         CheckMoneyUtils.instance.checkMoney(_isBand,_loc2_,this.onCheckComplete,null,_loc3_);
      }
      
      override protected function onCheckComplete() : void
      {
         _purchaseConfirmationBtn.enable = false;
         this.buyGift(CheckMoneyUtils.instance.isBind);
         this.dispose();
      }
      
      protected function buyGift(param1:Boolean) : void
      {
         var _loc2_:Vector.<SendGiftInfo> = new Vector.<SendGiftInfo>();
         var _loc3_:SendGiftInfo = new SendGiftInfo();
         _loc3_.activityId = this._info.activityId;
         var _loc4_:Array = [];
         var _loc5_:GiftChildInfo = new GiftChildInfo();
         _loc5_.giftId = this._info.giftbagId + "," + (param1 ? -9 : -8);
         _loc4_.push(_loc5_);
         _loc3_.giftIdArr = _loc4_;
         _loc3_.awardCount = _numberSelecter.currentValue;
         _loc2_.push(_loc3_);
         SocketManager.Instance.out.sendWonderfulActivityGetReward(_loc2_);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

