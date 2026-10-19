package Indiana
{
   import Indiana.analyzer.IndianaGoodsItemInfo;
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.item.AttributeItem;
   import Indiana.item.IndianaSkillItem;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetSkillManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class IndianaDetaileView extends Sprite implements Disposeable
   {
      
      private var _itemName:FilterFrameText;
      
      private var _itemNameValue:AttributeItem;
      
      private var _dis:FilterFrameText;
      
      private var _disValue:AttributeItem;
      
      private var _attribute:FilterFrameText;
      
      private var _info:IndianaShopItemInfo;
      
      private var _itemInfo:IndianaGoodsItemInfo;
      
      private var _vbox:VBox;
      
      private var _scoller:ScrollPanel;
      
      private var _contain:Sprite;
      
      private var _petskillContain:Sprite;
      
      private var _validityTxt:FilterFrameText;
      
      private var _validityValue:AttributeItem;
      
      private var _bangState:FilterFrameText;
      
      private var _bangvalu:AttributeItem;
      
      private var _attributeX:int;
      
      public function IndianaDetaileView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._contain = new Sprite();
         this._petskillContain = new Sprite();
         PositionUtils.setPos(this._petskillContain,"indiana.detail.skill.pos");
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("indiana.detailtitle.Txt");
         this._itemName.text = LanguageMgr.GetTranslation("Indiana.shop.item.type");
         this._dis = ComponentFactory.Instance.creatComponentByStylename("indiana.detailtitle.Txt");
         this._dis.text = LanguageMgr.GetTranslation("consortion.consortionMailFrame.explainText");
         this._attribute = ComponentFactory.Instance.creatComponentByStylename("indiana.detailtitle.Txt");
         this._validityTxt = ComponentFactory.Instance.creatComponentByStylename("indiana.detailtitle.Txt");
         this._validityTxt.text = LanguageMgr.GetTranslation("Indiana.validity.details");
         this._bangState = ComponentFactory.Instance.creatComponentByStylename("indiana.detailtitle.Txt");
         this._bangState.text = LanguageMgr.GetTranslation("Indiana.bandState");
         this._scoller = ComponentFactory.Instance.creatComponentByStylename("indiana.scroll.detailpanel");
         this._itemNameValue = new AttributeItem();
         this._disValue = new AttributeItem();
         this._disValue.setWidth(180);
         this._validityValue = new AttributeItem();
         this._bangvalu = new AttributeItem();
         PositionUtils.setPos(this._itemName,"itemName.pos");
         PositionUtils.setPos(this._itemNameValue,"itemNameValue.pos");
         PositionUtils.setPos(this._dis,"itemDis.pos");
         PositionUtils.setPos(this._disValue,"itemDisValue.pos");
         PositionUtils.setPos(this._attribute,"itemattribute.pos");
         PositionUtils.setPos(this._validityTxt,"validitytitle.pos");
         PositionUtils.setPos(this._bangState,"bandtile.pos");
         PositionUtils.setPos(this._validityValue,"validityvalue.pos");
         PositionUtils.setPos(this._bangvalu,"bandvalue.pos");
         this._attributeX = this._attribute.x;
         this._vbox = new VBox();
         this._vbox.spacing = 2;
         this._vbox.x = 166;
         this._vbox.y = 120;
         addChild(this._scoller);
         this._contain.addChild(this._itemName);
         this._contain.addChild(this._itemNameValue);
         this._contain.addChild(this._dis);
         this._contain.addChild(this._disValue);
         this._contain.addChild(this._attribute);
         this._contain.addChild(this._validityValue);
         this._contain.addChild(this._bangvalu);
         this._contain.addChild(this._vbox);
         this._contain.addChild(this._petskillContain);
         this._scoller.setView(this._contain);
         this._contain.addChild(this._validityTxt);
         this._contain.addChild(this._bangState);
      }
      
      public function setInfo(param1:IndianaShopItemInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         this._info = param1;
         if(Boolean(this._info))
         {
            this._itemInfo = IndianaDataManager.instance.getIndianaGoodsItemInfoByshopId(this._info.ShopId);
            this._itemNameValue.setDis(this.getType(this._itemInfo.GoodType));
            if(this._itemInfo.GoodType == 2)
            {
               this._attribute.text = LanguageMgr.GetTranslation("ddt.pets.petSkill") + ":";
               this._attribute.x = 105;
            }
            else
            {
               this._attribute.text = LanguageMgr.GetTranslation("beadProp") + ":";
               this._attribute.x = this._attributeX;
            }
            if(this._itemInfo.GoodType == 3)
            {
               this._attribute.visible = false;
            }
            else
            {
               this._attribute.visible = true;
            }
            _loc2_ = this._itemInfo.Desc == "" ? LanguageMgr.GetTranslation("ddt.fram.helperItem.Text") : this._itemInfo.Desc;
            this._disValue.setDis(_loc2_);
            if(this._disValue.textField.textWidth > 180)
            {
               this._disValue.setWidth(this._disValue.textField.textWidth + 10);
            }
            else
            {
               this._disValue.setWidth(180);
            }
            if(this._info.Validity == 0)
            {
               _loc2_ = LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.forever");
            }
            else
            {
               _loc2_ = this._info.Validity.toString();
            }
            this._validityValue.setDis(_loc2_);
            if(this._info.IsBind == 1)
            {
               _loc2_ = LanguageMgr.GetTranslation("Indiana.banding");
            }
            else
            {
               _loc2_ = LanguageMgr.GetTranslation("Indiana.notBanding");
            }
            this._bangvalu.setDis(_loc2_);
            _loc3_ = ItemManager.Instance.getTemplateById(this._itemInfo.GoodsID);
            this.setAttribute(_loc3_);
         }
      }
      
      private function clearContain() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(Boolean(this._vbox))
         {
            this._vbox.clearAllChild();
         }
         if(Boolean(this._petskillContain))
         {
            _loc1_ = this._petskillContain.numChildren;
            while(this._petskillContain.numChildren > 0)
            {
               _loc2_ = this._petskillContain.removeChildAt(0);
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
            }
         }
      }
      
      private function setAttribute(param1:ItemTemplateInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(Boolean(param1))
         {
            this.clearContain();
            if(this._itemInfo.GoodType == 2)
            {
               this.setPetSkill();
            }
            else if(this._itemInfo.GoodType == 7)
            {
               this.setHorse();
            }
            else
            {
               if(this._itemInfo.GoodType == 1 && param1.Property7 != "")
               {
                  _loc2_ = new AttributeItem();
                  _loc3_ = LanguageMgr.GetTranslation("damage") + ":" + param1.Property7;
                  _loc2_.setDis(_loc3_);
                  this._vbox.addChild(_loc2_);
               }
               if(param1.Attack > 0)
               {
                  _loc2_ = new AttributeItem();
                  _loc3_ = LanguageMgr.GetTranslation("activationPotential.propertyDescTxt1") + ":" + param1.Attack;
                  _loc2_.setDis(_loc3_);
                  this._vbox.addChild(_loc2_);
               }
               if(param1.Defence > 0)
               {
                  _loc2_ = new AttributeItem();
                  _loc3_ = LanguageMgr.GetTranslation("activationPotential.propertyDescTxt2") + ":" + param1.Defence;
                  _loc2_.setDis(_loc3_);
                  this._vbox.addChild(_loc2_);
               }
               if(param1.Agility > 0)
               {
                  _loc2_ = new AttributeItem();
                  _loc3_ = LanguageMgr.GetTranslation("activationPotential.propertyDescTxt3") + ":" + param1.Agility;
                  _loc2_.setDis(_loc3_);
                  this._vbox.addChild(_loc2_);
               }
               if(param1.Luck > 0)
               {
                  _loc2_ = new AttributeItem();
                  _loc3_ = LanguageMgr.GetTranslation("activationPotential.propertyDescTxt4") + ":" + param1.Luck;
                  _loc2_.setDis(_loc3_);
                  this._vbox.addChild(_loc2_);
               }
               _loc2_ = new AttributeItem();
               _loc2_.visible = false;
               this._vbox.addChild(_loc2_);
            }
         }
         this._scoller.displayObjectViewport.invalidateView();
      }
      
      private function setHorse() : void
      {
      }
      
      private function setPetSkill() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = int(this._itemInfo.Remark.split("|")[0]);
         var _loc6_:Array = this._itemInfo.Remark.split("|")[1].split(",");
         var _loc7_:int = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc1_ = PetSkillManager.getSkillByID(_loc6_[_loc2_]);
            _loc3_ = new IndianaSkillItem(_loc1_,_loc2_,false);
            _loc3_.scaleX = _loc3_.scaleY = 0.7;
            _loc3_.isLock = false;
            _loc3_.x = 63 * (_loc2_ % 4);
            _loc3_.y = 63 * int(_loc2_ / 4);
            this._petskillContain.addChild(_loc3_);
            _loc2_++;
         }
         if(_loc7_ > 0)
         {
            _loc4_ = new AttributeItem();
            _loc4_.visible = false;
            _loc4_.y = 63 * Math.ceil(_loc7_ / 4);
            this._petskillContain.addChild(_loc4_);
         }
      }
      
      private function addBottomItem(param1:DisplayObject) : void
      {
      }
      
      private function getType(param1:int) : String
      {
         var _loc2_:* = null;
         switch(int(param1) - 1)
         {
            case 0:
               _loc2_ = LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon");
               break;
            case 1:
               _loc2_ = LanguageMgr.GetTranslation("Indiana.detaile.pet");
               break;
            case 2:
               _loc2_ = LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Prop");
               break;
            case 3:
               _loc2_ = LanguageMgr.GetTranslation("tank.data.EquipType.wing");
               break;
            case 4:
               _loc2_ = LanguageMgr.GetTranslation("playerDress.sort1");
               break;
            case 5:
               _loc2_ = LanguageMgr.GetTranslation("tank.data.EquipType.offhand");
               break;
            case 6:
               _loc2_ = LanguageMgr.GetTranslation("tank.menu.mounts");
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._itemName = null;
         this._itemNameValue = null;
         this._dis = null;
         this._disValue = null;
         this._attribute = null;
         this._info = null;
         this._itemInfo = null;
         this._vbox = null;
      }
   }
}

