package groupPurchase.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import groupPurchase.GroupPurchaseManager;
   
   public class GroupPurchaseShopCell extends Sprite implements Disposeable
   {
      
      private var _itemCell:BagCell;
      
      private var _buyTipSprite:Sprite;
      
      private var _buyTipBg:Bitmap;
      
      private var _buyTipTxt:FilterFrameText;
      
      private var _shopItemId:int;
      
      public function GroupPurchaseShopCell()
      {
         super();
         this.buttonMode = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,75,75);
         _loc1_.graphics.endFill();
         this._shopItemId = GroupPurchaseManager.instance.itemId;
         this._itemCell = new BagCell(1,ItemManager.Instance.getTemplateById(this._shopItemId),true,_loc1_,false);
         addChild(this._itemCell);
         this._buyTipBg = ComponentFactory.Instance.creatBitmap("asset.groupPurchase.itemBuyTipBg");
         this._buyTipTxt = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.buyTipTxt");
         this._buyTipTxt.text = LanguageMgr.GetTranslation("ddt.groupPurchase.buyTipTxt");
         this._buyTipSprite = new Sprite();
         PositionUtils.setPos(this._buyTipSprite,"groupPurchase.buyTipSpritePos");
         this._buyTipSprite.addChild(this._buyTipBg);
         this._buyTipSprite.addChild(this._buyTipTxt);
         addChild(this._buyTipSprite);
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.overHandler,false,0,true);
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         TweenLite.to(this._buyTipSprite,0.25,{"alpha":1});
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:GroupPurchaseQuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("groupPurchase.QuickFrame");
         _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc2_.itemID = this._shopItemId;
         var _loc3_:Boolean = GroupPurchaseManager.instance.isUseMoney;
         var _loc4_:Boolean = GroupPurchaseManager.instance.isUseBandMoney;
         if(_loc3_ && !_loc4_)
         {
            _loc2_.hideSelectedBand();
         }
         else if(!_loc3_ && _loc4_)
         {
            _loc2_.hideSelected();
         }
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.clickHandler);
         removeEventListener(MouseEvent.MOUSE_OVER,this.overHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         TweenLite.killTweensOf(this._buyTipSprite);
         ObjectUtils.disposeObject(this._itemCell);
         this._itemCell = null;
         ObjectUtils.disposeObject(this._buyTipBg);
         this._buyTipBg = null;
         ObjectUtils.disposeObject(this._buyTipTxt);
         this._buyTipTxt = null;
         ObjectUtils.disposeObject(this._buyTipSprite);
         this._buyTipSprite = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

