package panicBuying.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.Price;
   import ddt.data.goods.ShopCarItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import panicBuying.data.PBuyingItemInfo;
   import panicBuying.views.PanicBuyingBuyView;
   import panicBuying.views.PanicBuyingCell;
   import shop.manager.ShopBuyManager;
   import shop.manager.ShopGiftsManager;
   
   public class PanicBuyingItem extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _title:FilterFrameText;
      
      private var _countTxt:FilterFrameText;
      
      private var _bagCell:PanicBuyingCell;
      
      private var _originalPrice:FilterFrameText;
      
      private var _delLine:Shape;
      
      private var _price:FilterFrameText;
      
      private var _payType:ScaleFrameImage;
      
      private var _entireRemainTxt:FilterFrameText;
      
      private var _giveBtn:SimpleBitmapButton;
      
      private var _askForBtn:SimpleBitmapButton;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _tipSprite:Component;
      
      private var _vip:Bitmap;
      
      private var _tag:Bitmap;
      
      private var _levelTxt:FilterFrameText;
      
      private var _type:int;
      
      private var _templateId:int;
      
      private var _info:PBuyingItemInfo;
      
      public function PanicBuyingItem()
      {
         super();
         this.initView();
         this.addEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("panicBuying.itemBg");
         addChild(this._bg);
         this._title = ComponentFactory.Instance.creatComponentByStylename("panicBuying.itemTitle");
         addChild(this._title);
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.countTxt");
         addChild(this._countTxt);
         this._originalPrice = ComponentFactory.Instance.creatComponentByStylename("panicBuying.originalPrice");
         addChild(this._originalPrice);
         this._delLine = DeleteLineUtil.newDeleteLine(this._originalPrice);
         addChild(this._delLine);
         this._price = ComponentFactory.Instance.creatComponentByStylename("panicBuying.price");
         addChild(this._price);
         this._payType = ComponentFactory.Instance.creatComponentByStylename("ddtshop.GoodPayTypeLabel");
         addChild(this._payType);
         this._payType.setFrame(2);
         PositionUtils.setPos(this._payType,"panicBuying.payTypePos");
         this._giveBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.giveBtn");
         addChild(this._giveBtn);
         this._askForBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.askForBtn");
         addChild(this._askForBtn);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.buyBtn");
         addChild(this._buyBtn);
         this._entireRemainTxt = ComponentFactory.Instance.creat("entire.remainTxt");
         addChild(this._entireRemainTxt);
         this._tipSprite = new Component();
         this._tipSprite.graphics.beginFill(0,0);
         this._tipSprite.graphics.drawRect(0,0,this._buyBtn.width,this._buyBtn.height);
         this._tipSprite.graphics.endFill();
         this._tipSprite.width = this._buyBtn.width;
         this._tipSprite.height = this._buyBtn.height;
         this._tipSprite.x = this._buyBtn.x;
         this._tipSprite.y = this._buyBtn.y;
         this._tipSprite.tipStyle = "ddt.view.tips.OneLineTip";
         this._tipSprite.tipDirctions = "3";
         this._tipSprite.visible = false;
         addChild(this._tipSprite);
      }
      
      private function addEvents() : void
      {
         this._buyBtn.addEventListener("click",this.__buyBtnClick);
         this._askForBtn.addEventListener("click",this.__askForBtnClick);
         this._giveBtn.addEventListener("click",this.__giveBtnClick);
      }
      
      protected function __giveBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ShopGiftsManager.Instance.buy(this._info.goodsId,true,2);
      }
      
      protected function __askForBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ShopBuyManager.Instance.buy(this._info.goodsId,2,3);
      }
      
      protected function __buyBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Boolean = false;
         SoundManager.instance.play("008");
         Price.ONLYMONEY = this._info.priceType == -8 ? true : false;
         switch(int(this._type) - 2)
         {
            case 0:
               ShopBuyManager.Instance.buy(this._info.goodsId,2,this._info.priceType);
               break;
            default:
               _loc2_ = new PanicBuyingBuyView(this._info.priceType);
               LayerManager.Instance.addToLayer(_loc2_,3,true,1);
               _loc2_.info = this._info;
               _loc2_.goodsID = this._templateId;
               if(this._info.remain > 0)
               {
                  _loc2_.numberSelecter.valueLimit = "1," + this._info.remain;
               }
               _loc2_.numberSelecter.validate();
         }
      }
      
      public function setData(param1:PBuyingItemInfo, param2:int) : void
      {
         var _loc5_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:* = null;
         ObjectUtils.disposeObject(this._vip);
         this._vip = null;
         ObjectUtils.disposeObject(this._tag);
         this._tag = null;
         ObjectUtils.disposeObject(this._levelTxt);
         this._levelTxt = null;
         ObjectUtils.disposeObject(this._bagCell);
         this._bagCell = null;
         _loc5_ = param1.templateId != 0;
         this._entireRemainTxt.visible = false;
         this._title.visible = this._countTxt.visible = this._originalPrice.visible = this._delLine.visible = this._price.visible = this._giveBtn.visible = this._askForBtn.visible = this._buyBtn.visible = this._payType.visible = _loc5_;
         if(!_loc5_)
         {
            return;
         }
         this._templateId = param1.templateId;
         this._info = param1;
         this._payType.setFrame(this._info.priceType == -8 ? 2 : int(Number(this._info.priceType == -9 ? 1 : 2)));
         this._price.text = this._info.price.toString();
         this._originalPrice.text = LanguageMgr.GetTranslation("panicBuying.originalPrice",this._info.originalPrice);
         DeleteLineUtil.setDeleteLine(this._delLine,this._originalPrice);
         this._originalPrice.visible = this._delLine.visible = this._info.originalPrice > 0;
         var _loc6_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._templateId);
         this._title.text = _loc6_.Name;
         this._bagCell = new PanicBuyingCell(0,_loc6_,param1.buyType,param1.unitCount);
         addChild(this._bagCell);
         this._bagCell.setContentSize(65,65);
         this._bagCell.setBgVisible(false);
         PositionUtils.setPos(this._bagCell,"panicBuying.bagCellPos");
         if(param2 == 2)
         {
            _loc3_ = ShopManager.Instance.getShopItemByGoodsID(this._info.goodsId);
            if(!_loc3_)
            {
               _loc3_ = ShopManager.Instance.getGoodsByTemplateID(this._info.goodsId);
            }
            if(_loc3_.buyTypeToString == "Um/A")
            {
               this._bagCell.setCount(_loc3_.AUnit);
            }
            else
            {
               this._bagCell.setCount(1);
            }
         }
         else
         {
            _loc4_ = new ShopCarItemInfo(0,this._templateId);
            _loc4_.APrice1 = this._info.priceType;
            _loc4_.APrice2 = this._info.priceType;
            _loc4_.APrice3 = this._info.priceType;
            _loc4_.BuyType = this._info.buyType;
            _loc4_.AUnit = this._info.unitCount;
            _loc4_.AValue1 = this._info.price;
            _loc4_.BUnit = -1;
            _loc4_.CUnit = -1;
            if(_loc4_.buyTypeToString == "Um/A")
            {
               this._bagCell.setCount(this._info.unitCount);
            }
            else
            {
               this._bagCell.setCount(param1.count);
            }
         }
         if(param2 == 2)
         {
            this._type = 2;
            this._giveBtn.visible = false;
            this._askForBtn.visible = false;
            this._countTxt.visible = false;
         }
         else if(param2 == 4)
         {
            this._type = 4;
            this._entireRemainTxt.visible = true;
            this._giveBtn.visible = false;
            this._askForBtn.visible = false;
            this._countTxt.visible = false;
         }
         else
         {
            this._giveBtn.visible = false;
            this._askForBtn.visible = false;
            this._countTxt.text = this._info.remain + "/" + this._info.total;
            this._countTxt.visible = this._info.total > 0;
            if(this._info.levelLimit != 0)
            {
               this._type = 0;
               this.createTag();
            }
            else if(this._info.vipLimit != 0)
            {
               this._type = 1;
               this.createTag();
            }
            else
            {
               this._type = 3;
            }
         }
         this.checkBtnEnable();
      }
      
      private function checkBtnEnable() : void
      {
         switch(int(this._type))
         {
            case 0:
               if((this._info.total == 0 || this._info.remain > 0) && PlayerManager.Instance.Self.Grade >= this._info.levelLimit)
               {
                  this._buyBtn.enable = true;
                  this._tipSprite.visible = false;
               }
               else
               {
                  this._buyBtn.enable = false;
                  this._tipSprite.visible = true;
                  this._tipSprite.tipData = PlayerManager.Instance.Self.Grade >= this._info.levelLimit ? LanguageMgr.GetTranslation("panicBuying.timesLimit") : LanguageMgr.GetTranslation("panicBuying.levelLimit",this._info.levelLimit);
               }
               break;
            case 1:
               if((this._info.total == 0 || this._info.remain > 0) && PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= this._info.vipLimit)
               {
                  this._buyBtn.enable = true;
                  this._tipSprite.visible = false;
               }
               else
               {
                  this._buyBtn.enable = false;
                  this._tipSprite.visible = true;
                  this._tipSprite.tipData = PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= this._info.vipLimit ? LanguageMgr.GetTranslation("panicBuying.timesLimit") : LanguageMgr.GetTranslation("panicBuying.vipLvlLimit",this._info.vipLimit);
               }
               break;
            case 2:
               this._buyBtn.enable = true;
               this._tipSprite.visible = false;
               break;
            case 3:
               if(this._info.total == 0 || this._info.remain > 0)
               {
                  this._buyBtn.enable = true;
                  this._tipSprite.visible = false;
                  break;
               }
               this._buyBtn.enable = false;
               this._tipSprite.visible = true;
               this._tipSprite.tipData = LanguageMgr.GetTranslation("panicBuying.timesLimit");
               break;
            case 4:
               if(this._info.limitedType == 0)
               {
                  this._buyBtn.enable = true;
                  this._entireRemainTxt.text = LanguageMgr.GetTranslation("panicBuying.enitreBuyNoLimited");
               }
               else if(this._info.limitedType == 1)
               {
                  if(this._info.remain > 0)
                  {
                     this._buyBtn.enable = true;
                  }
                  else
                  {
                     this._buyBtn.enable = false;
                  }
                  this._entireRemainTxt.text = LanguageMgr.GetTranslation("panicBuying.entireBuyRemain",Math.max(0,this._info.remain));
               }
               this._tipSprite.visible = false;
               this._countTxt.visible = false;
         }
         if(this._type == 4)
         {
            this._originalPrice.y = 36;
            this._price.y = 56;
            this._delLine.y = 37;
            this._payType.y = 53;
            addChild(this._entireRemainTxt);
         }
         else
         {
            this._originalPrice.y = 40;
            this._price.y = 67;
            this._delLine.y = 40;
            this._payType.y = 65;
            this._entireRemainTxt.parent && removeChild(this._entireRemainTxt);
         }
      }
      
      private function createTag() : void
      {
         switch(int(this._type))
         {
            case 0:
               if(this._info.levelLimit >= 1 && this._info.levelLimit <= 19)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.greenTag");
                  this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.levelTxt1");
               }
               else if(this._info.levelLimit >= 20 && this._info.levelLimit <= 39)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.orangeTag");
                  this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.levelTxt2");
               }
               else if(this._info.levelLimit >= 40 && this._info.levelLimit <= 59)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.rosyTag");
                  this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.levelTxt3");
               }
               else if(this._info.levelLimit >= 60 && this._info.levelLimit <= 70)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.redTag");
                  this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.levelTxt4");
               }
               addChild(this._tag);
               addChild(this._levelTxt);
               this._levelTxt.text = LanguageMgr.GetTranslation("panicBuying.levelTxt",this._info.levelLimit);
               break;
            case 1:
               if(this._info.vipLimit >= 1 && this._info.vipLimit <= 3)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.greenTag");
               }
               else if(this._info.vipLimit >= 4 && this._info.vipLimit <= 6)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.orangeTag");
               }
               else if(this._info.vipLimit >= 7 && this._info.vipLimit <= 9)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.rosyTag");
               }
               else if(this._info.vipLimit >= 10 && this._info.vipLimit <= 12)
               {
                  this._tag = ComponentFactory.Instance.creat("panicBuying.redTag");
               }
               if(Boolean(this._tag))
               {
                  addChild(this._tag);
               }
               if(this._info.vipLimit >= 1 && this._info.vipLimit <= 12)
               {
                  this._vip = ComponentFactory.Instance.creat("panicBuying.vip" + this._info.vipLimit);
                  PositionUtils.setPos(this._vip,"panicBuying.vipPos");
                  addChild(this._vip);
               }
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         ObjectUtils.disposeObject(this._bagCell);
         this._bagCell = null;
         ObjectUtils.disposeObject(this._originalPrice);
         this._originalPrice = null;
         ObjectUtils.disposeObject(this._delLine);
         this._delLine = null;
         ObjectUtils.disposeObject(this._price);
         this._price = null;
         ObjectUtils.disposeObject(this._payType);
         this._payType = null;
         ObjectUtils.disposeObject(this._giveBtn);
         this._giveBtn = null;
         ObjectUtils.disposeObject(this._askForBtn);
         this._askForBtn = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._tipSprite);
         this._tipSprite = null;
         ObjectUtils.disposeObject(this._vip);
         this._vip = null;
         ObjectUtils.disposeObject(this._tag);
         this._tag = null;
         ObjectUtils.disposeObject(this._levelTxt);
         this._levelTxt = null;
         if(this._entireRemainTxt != null)
         {
            ObjectUtils.disposeObject(this._entireRemainTxt);
            this._entireRemainTxt = null;
         }
      }
      
      private function removeEvents() : void
      {
         this._buyBtn.removeEventListener("click",this.__buyBtnClick);
         this._askForBtn.removeEventListener("click",this.__askForBtnClick);
         this._giveBtn.removeEventListener("click",this.__giveBtnClick);
      }
   }
}

