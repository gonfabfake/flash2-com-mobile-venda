package AvatarCollection.view
{
   import AvatarCollection.data.AvatarCollectionItemVo;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class AvatarCollectionItemCell extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _itemCell:BagCell;
      
      private var _btn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _data:AvatarCollectionItemVo;
      
      public function AvatarCollectionItemCell()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.avatarColl.itemCell.bg");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,74,74);
         _loc1_.graphics.endFill();
         this._itemCell = new BagCell(1,null,true,_loc1_,false);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemCell.btn");
         this._btn.alpha = 0.8;
         this._btn.visible = false;
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("avatarColl.itemCell.buyBtn");
         this._buyBtn.alpha = 0.8;
         this._buyBtn.visible = false;
         addChild(this._bg);
         addChild(this._itemCell);
         addChild(this._btn);
         addChild(this._buyBtn);
      }
      
      private function initEvent() : void
      {
         this._btn.addEventListener("click",this.clickHandler,false,0,true);
         this._buyBtn.addEventListener("click",this.buyClickHandler,false,0,true);
         this.addEventListener("mouseOver",this.overHandler,false,0,true);
         this.addEventListener("mouseOut",this.outHandler,false,0,true);
      }
      
      private function buyClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._data.Type == 2 && PlayerManager.Instance.Self.Bag.getBagFullByIndex(31,127))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.bagFull"));
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("avatarCollection.buyConfirm.tipTxt",this._data.buyPrice,this._data.typeToString),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,2,null,"SimpleAlert",60,false);
         _loc2_.addEventListener("response",this.onBuyConfirmResponse);
      }
      
      private function onBuyConfirmResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.onBuyConfirmResponse);
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            CheckMoneyUtils.instance.checkMoney(_loc2_.isBand,this._data.buyPrice,this.onCheckComplete);
         }
         _loc2_.dispose();
      }
      
      protected function onCheckComplete() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         var _loc1_:Array = [this._data.goodsId];
         var _loc2_:Array = [1];
         var _loc3_:Array = [""];
         var _loc4_:Array = [""];
         var _loc5_:Array = [""];
         var _loc6_:Array = [this._data.isDiscount];
         var _loc7_:Array = [CheckMoneyUtils.instance.isBind];
         SocketManager.Instance.out.sendBuyGoods(_loc1_,_loc2_,_loc3_,_loc5_,_loc4_,null,0,_loc6_,_loc7_);
      }
      
      private function onBuyedGoods(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BUY_GOODS,this.onBuyedGoods);
         param1.pkg.position = 20;
         var _loc2_:int = param1.pkg.readInt();
         if(_loc2_ != 0)
         {
            this.sendActive();
         }
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._data) && Boolean(!this._data.isActivity) && !this._buyBtn.visible)
         {
            this._btn.visible = true;
         }
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         if(Boolean(this._data) && !this._data.isHas)
         {
            this._btn.visible = false;
         }
      }
      
      private function clickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!this._data.isHas)
         {
            if(this._data.Type == 1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.doActive.donnotHas",this._data.typeToString));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.doActive.donnotHas",this._data.typeToString));
            }
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("avatarCollection.activeItem.promptTxt",this._data.needGold),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,1);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener("response",this.__activeConfirm,false,0,true);
      }
      
      private function __activeConfirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__activeConfirm);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            this.sendActive();
         }
      }
      
      private function sendActive() : void
      {
         if(!this.checkGoldEnough())
         {
            this.refreshView(this._data);
            return;
         }
         if(this._data.activateItem == null)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("avatarCollection.bagFullBuy"));
            return;
         }
         SocketManager.Instance.out.sendAvatarCollectionActive(this._data.id,this._data.activateItem.TemplateID,this._data.sex,this._data.Type);
      }
      
      private function checkGoldEnough() : Boolean
      {
         var _loc1_:* = null;
         if(PlayerManager.Instance.Self.Gold < this._data.needGold)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2);
            _loc1_.moveEnable = false;
            _loc1_.addEventListener("response",this._responseV);
            return false;
         }
         return true;
      }
      
      private function _responseV(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         (param1.currentTarget as BaseAlerFrame).removeEventListener("response",this._responseV);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            this.okFastPurchaseGold();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function okFastPurchaseGold() : void
      {
         var _loc1_:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
         _loc1_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc1_.itemID = 11233;
         LayerManager.Instance.addToLayer(_loc1_,2,true,1);
      }
      
      public function refreshView(param1:AvatarCollectionItemVo) : void
      {
         this._data = param1;
         if(!this._data)
         {
            this._itemCell.info = null;
            this._itemCell.tipStyle = null;
            this._itemCell.tipData = null;
            this._btn.visible = false;
            this._buyBtn.visible = false;
            return;
         }
         this._itemCell.info = this._data.itemInfo;
         this._itemCell.tipStyle = "AvatarCollection.view.AvatarCollectionItemTip";
         this._itemCell.tipData = this._data;
         if(this._data.isActivity)
         {
            this._btn.visible = false;
            this._buyBtn.visible = false;
            this._itemCell.lightPic();
         }
         else if(this._data.isHas)
         {
            this._btn.visible = true;
            this._buyBtn.visible = false;
            this._itemCell.lightPic();
         }
         else
         {
            if(this._data.canBuyStatus == 1)
            {
               this._buyBtn.visible = true;
            }
            else
            {
               this._buyBtn.visible = false;
            }
            this._btn.visible = false;
            this._itemCell.grayPic();
         }
      }
      
      private function removeEvent() : void
      {
         this._btn.removeEventListener("click",this.clickHandler);
         this._buyBtn.removeEventListener("click",this.buyClickHandler);
         removeEventListener("mouseOver",this.overHandler);
         removeEventListener("mouseOut",this.outHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._itemCell = null;
         this._btn = null;
         this._data = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

