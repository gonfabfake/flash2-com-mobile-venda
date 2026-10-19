package gypsyShop.ui
{
   import AvatarCollection.AvatarCollectionManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyItemData;
   import shop.view.ShopItemCell;
   
   public class GypsyItemCell extends Sprite implements Disposeable
   {
      
      private var _id:int;
      
      private var _bg:Bitmap;
      
      private var _bagCell:ShopItemCell;
      
      private var _nameTxt:FilterFrameText;
      
      private var _priceTxt:FilterFrameText;
      
      private var _priceUnitIcon:ScaleFrameImage;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _collectText:FilterFrameText;
      
      private var _collectQualityText:FilterFrameText;
      
      private var _clctActivatedText:FilterFrameText;
      
      public function GypsyItemCell()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("gypsy.frame.cell.bg");
         addChild(this._bg);
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,60,60);
         _loc1_.graphics.endFill();
         this._bagCell = new ShopItemCell(_loc1_);
         PositionUtils.setPos(this._bagCell,{
            "x":4,
            "y":4
         });
         this._bagCell.cellSize = 60;
         addChild(this._bagCell);
         this._nameTxt = ComponentFactory.Instance.creat("gypsy.textfield.itemname");
         this._nameTxt.text = "";
         addChild(this._nameTxt);
         this._priceTxt = ComponentFactory.Instance.creat("gypsy.textfield.price");
         this._priceTxt.text = "";
         addChild(this._priceTxt);
         this._priceUnitIcon = ComponentFactory.Instance.creat("gypsy.closeBtn.unit.icon");
         this._priceUnitIcon.setFrame(2);
         addChild(this._priceUnitIcon);
         this._collectText = UICreatShortcut.creatTextAndAdd("gypsy.textfield.collect",LanguageMgr.GetTranslation("ddt.gypsy.collect"),this);
         this._collectText.visible = false;
         this._clctActivatedText = UICreatShortcut.creatTextAndAdd("gypsy.textfield.collectActivate",LanguageMgr.GetTranslation("ddt.gypsy.activated"),this);
         this._clctActivatedText.visible = false;
         this._collectQualityText = UICreatShortcut.creatTextAndAdd("gypsy.textfield.collectQuality",LanguageMgr.GetTranslation("ddt.gypsy.collectQuality"),this);
         this._collectQualityText.visible = false;
         this._buyBtn = ComponentFactory.Instance.creat("gypsy.BuyBtn");
         this._buyBtn.enable = true;
         addChild(this._buyBtn);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         GypsyShopManager.getInstance().itemBuyBtnClicked(this.id);
      }
      
      public function clear() : void
      {
         this._id = -1;
         this._bagCell.info = null;
         this._nameTxt.text = "";
         this._priceTxt.text = "";
         this._buyBtn.enable = false;
      }
      
      public function updateCell(param1:GypsyItemData) : void
      {
         var _loc2_:String = null;
         this._id = param1.id;
         this._bagCell.info = ItemManager.Instance.getTemplateById(param1.infoID);
         if(this._bagCell.info != null)
         {
            _loc2_ = this._bagCell.info.Name;
            if(AvatarCollectionManager.instance.isCollectionGoodsByTemplateID(param1.infoID))
            {
               if(GypsyShopManager.getInstance().isAvatarActivated(param1.infoID))
               {
                  this._clctActivatedText.text = LanguageMgr.GetTranslation("ddt.gypsy.activated");
                  this._clctActivatedText.setFrame(1);
               }
               else
               {
                  this._clctActivatedText.text = LanguageMgr.GetTranslation("ddt.gypsy.notActivate");
                  this._clctActivatedText.setFrame(2);
               }
               this._clctActivatedText.visible = true;
               this._collectText.visible = true;
               this._collectQualityText.visible = false;
            }
            else
            {
               if(param1.quality > 0 && !AvatarCollectionManager.instance.isCollectionGoodsByTemplateID(param1.infoID))
               {
                  this._collectQualityText.visible = true;
                  this._collectText.visible = false;
               }
               else
               {
                  this._collectText.visible = false;
                  this._collectQualityText.visible = false;
               }
               this._clctActivatedText.visible = false;
            }
            if(_loc2_.length > 16)
            {
               _loc2_ = _loc2_.substr(0,15) + "...";
            }
            this._nameTxt.text = _loc2_;
         }
         this._priceUnitIcon.setFrame(param1.unit);
         this._priceTxt.text = param1.price.toString();
         this._buyBtn.enable = param1.canBuy == 0 ? Boolean(false) : Boolean(true);
      }
      
      public function updateBuyButtonState(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               this._buyBtn.enable = false;
               break;
            default:
               this._buyBtn.enable = true;
         }
      }
      
      public function dispose() : void
      {
         this._id = -1;
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         ObjectUtils.disposeAllChildren(this);
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}

