package vipIntegralShop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   import vipIntegralShop.VipIntegralShopController;
   import vipIntegralShop.data.VipIntegralShopInfo;
   
   public class VipIntegralShopCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _integral:FilterFrameText;
      
      private var _vipLimit:FilterFrameText;
      
      private var _buyOver:FilterFrameText;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _vipIntegralInfo:VipIntegralShopInfo;
      
      public function VipIntegralShopCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.vipIntegralShopView.bg");
         addChild(this._bg);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.buyBtn");
         addChild(this._buyBtn);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.nameTxt");
         addChild(this._nameTxt);
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.needMoneyTxt");
         addChild(this._needMoneyTxt);
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,70,70);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 60;
         PositionUtils.setPos(this._itemCell,"vipIntegralShopView.itemCell.pos");
         addChild(this._itemCell);
         this._integral = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.integral");
         this._integral.text = LanguageMgr.GetTranslation("ddt.dragonBoat.shopCellMoneyTxt");
         addChild(this._integral);
         this._vipLimit = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.limitInfo");
         addChild(this._vipLimit);
         this._vipLimit.visible = false;
         this._buyOver = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.buyOver");
         this._buyOver.text = LanguageMgr.GetTranslation("vipIntegralShopView.buyShopItem.buyOver");
         addChild(this._buyOver);
         this._buyOver.visible = false;
         this._buyBtn.addEventListener("click",this.buyHandler,false,0,true);
      }
      
      private function buyHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.VipIntegral < this._vipIntegralInfo.Price)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.integral.unenoughIntegralText"),0,true);
            return;
         }
         var _loc2_:VipIntegralShopBuyCell = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.QuickBuyAlert");
         _loc2_.setData(this._vipIntegralInfo.GoodsID,this._vipIntegralInfo.ID,this._vipIntegralInfo.Price);
         _loc2_.setBuyNum(this._vipIntegralInfo.LimitNum);
         LayerManager.Instance.addToLayer(_loc2_,2,true,1);
      }
      
      public function refreshShow(param1:VipIntegralShopInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         this._vipIntegralInfo = param1;
         this._itemCell.info = ItemManager.Instance.getTemplateById(this._vipIntegralInfo.GoodsID);
         this._nameTxt.text = this._itemCell.info.Name;
         this._needMoneyTxt.text = this._vipIntegralInfo.Price.toString();
         if(PlayerManager.Instance.Self.IsVIP)
         {
            _loc2_ = "Vip" + PlayerManager.Instance.Self.VIPLevel + "Quantity";
            if(param1[_loc2_] > 0)
            {
               _loc3_ = 0;
               if(VipIntegralShopController.instance.limitDic[this._vipIntegralInfo.GoodsID] != null)
               {
                  _loc3_ = int(VipIntegralShopController.instance.limitDic[this._vipIntegralInfo.GoodsID]);
               }
               this._vipIntegralInfo.LimitNum = param1[_loc2_] - _loc3_;
               if(this._vipIntegralInfo.LimitNum > 0)
               {
                  this._buyBtn.enable = this._buyBtn.visible = true;
                  this._buyOver.visible = this._vipLimit.visible = false;
               }
               else
               {
                  this._buyOver.visible = true;
                  this._buyBtn.visible = this._vipLimit.visible = false;
               }
            }
            else
            {
               this._buyBtn.visible = this._buyOver.visible = false;
               this._vipLimit.visible = true;
               this._vipLimit.text = LanguageMgr.GetTranslation("vipIntegralShopView.buyShopItem.limitInfo",this.getBuyVipLevel());
            }
         }
         else
         {
            this._buyBtn.visible = true;
            this._buyBtn.enable = false;
         }
      }
      
      private function getBuyVipLevel() : int
      {
         var _loc1_:int = PlayerManager.Instance.Self.VIPLevel + 1;
         while(this._vipIntegralInfo["Vip" + _loc1_ + "Quantity"] == 0)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         if(Boolean(this._buyBtn))
         {
            this._buyBtn.dispose();
            this._buyBtn = null;
         }
         if(Boolean(this._nameTxt))
         {
            this._nameTxt.dispose();
            this._nameTxt = null;
         }
         if(Boolean(this._needMoneyTxt))
         {
            this._needMoneyTxt.dispose();
            this._needMoneyTxt = null;
         }
         if(Boolean(this._integral))
         {
            this._integral.dispose();
            this._integral = null;
         }
         if(Boolean(this._vipLimit))
         {
            this._vipLimit.dispose();
            this._vipLimit = null;
         }
         if(Boolean(this._buyOver))
         {
            this._buyOver.dispose();
            this._buyOver = null;
         }
         if(Boolean(this.parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

