package league.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.BattleGroudManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import league.LeagueControl;
   import shop.view.ShopItemCell;
   
   public class LeagueShopCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _moneyIcon:Bitmap;
      
      private var _nameTxt:FilterFrameText;
      
      private var _needMoneyTxt:FilterFrameText;
      
      private var _cannotBuyTipTxt:FilterFrameText;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _itemCell:ShopItemCell;
      
      private var _shopItemInfo:ShopItemInfo;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _buyOver:FilterFrameText;
      
      public function LeagueShopCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.leagueShopCell.bg");
         this._moneyIcon = ComponentFactory.Instance.creatBitmap("asset.leagueShopCell.moneyIcon");
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.buyBtn");
         this._buyBtn.visible = false;
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.nameTxt");
         this._needMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.needMoneyTxt");
         this._cannotBuyTipTxt = ComponentFactory.Instance.creatComponentByStylename("leagueShopCell.cannotBuyTipTxt");
         this._cannotBuyTipTxt.visible = false;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,70,70);
         _loc1_.graphics.endFill();
         this._itemCell = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this._itemCell.cellSize = 60;
         PositionUtils.setPos(this._itemCell,"leagueShopCell.itemCell.pos");
         addChild(this._bg);
         addChild(this._moneyIcon);
         addChild(this._buyBtn);
         addChild(this._nameTxt);
         addChild(this._needMoneyTxt);
         addChild(this._cannotBuyTipTxt);
         addChild(this._itemCell);
         this._buyOver = ComponentFactory.Instance.creatComponentByStylename("leagueShopView.buyOver");
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
         var _loc2_:String = this._shopItemInfo.TemplateInfo.Name;
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.league.buyConfirmTipTxt",this._shopItemInfo.AValue1,_loc2_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirmBuy,false,0,true);
      }
      
      private function __confirmBuy(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener("response",this.__confirmBuy);
         this._confirmFrame = null;
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            _loc2_ = [this._shopItemInfo.GoodsID];
            _loc3_ = [1];
            _loc4_ = [""];
            _loc5_ = [""];
            _loc6_ = [""];
            _loc7_ = [this._shopItemInfo.isDiscount];
            SocketManager.Instance.out.sendBuyGoods(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,null,0,_loc7_);
         }
      }
      
      public function refreshShow(param1:ShopItemInfo) : void
      {
         var _loc2_:* = null;
         this._shopItemInfo = param1;
         this._itemCell.info = this._shopItemInfo.TemplateInfo;
         this._itemCell.tipInfo = this._shopItemInfo;
         this._nameTxt.text = this._itemCell.info.Name;
         this._needMoneyTxt.text = this._shopItemInfo.AValue1.toString();
         this._buyOver.visible = false;
         if(LeagueControl.instance.militaryRank == -1)
         {
            return;
         }
         if(this._shopItemInfo.LimitGrade > LeagueControl.instance.militaryRank)
         {
            this._buyBtn.visible = false;
            this._cannotBuyTipTxt.visible = true;
            _loc2_ = BattleGroudManager.Instance.getBattleDataByLevel(this._shopItemInfo.LimitGrade);
            this._cannotBuyTipTxt.text = LanguageMgr.GetTranslation("ddt.league.cannotBuyTipTxt",_loc2_.Name);
            this._cannotBuyTipTxt.text = LanguageMgr.GetTranslation("ddt.league.cannotBuyTipTxt","cannotBuyTipTxt");
            this._itemCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
         }
         else
         {
            this._buyBtn.visible = true;
            this._cannotBuyTipTxt.visible = false;
            this._itemCell.filters = null;
            if(ShopManager.Instance.getShopItemByGoodsID(this._shopItemInfo.GoodsID).personalBuyCnt == 0)
            {
               this._buyBtn.enable = this._buyBtn.visible = false;
               this._buyOver.visible = true;
            }
            else
            {
               this._buyBtn.enable = this._buyBtn.visible = true;
               this._buyOver.visible = false;
            }
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._moneyIcon = null;
         this._buyBtn = null;
         this._nameTxt = null;
         this._needMoneyTxt = null;
         this._cannotBuyTipTxt = null;
         if(Boolean(this._confirmFrame))
         {
            this._confirmFrame.removeEventListener("response",this.__confirmBuy);
            ObjectUtils.disposeObject(this._confirmFrame);
         }
         this._confirmFrame = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

