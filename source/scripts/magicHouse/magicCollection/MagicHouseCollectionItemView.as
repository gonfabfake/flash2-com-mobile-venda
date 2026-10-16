package magicHouse.magicCollection
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.tips.CallPropTxtTipInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.SelfInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseModel;
   import newTitle.NewTitleManager;
   
   public class MagicHouseCollectionItemView extends Sprite implements Disposeable
   {
      
      private var _self:SelfInfo;
      
      private var _item1:MagicHouseItemCell;
      
      private var _item2:MagicHouseItemCell;
      
      private var _item3:MagicHouseItemCell;
      
      private var _type:int;
      
      private var _addAttributeTxt:FilterFrameText;
      
      private var _attribute1:FilterFrameText;
      
      private var _attribute2:FilterFrameText;
      
      private var _attributeValue1:FilterFrameText;
      
      private var _attributeValue2:FilterFrameText;
      
      private var _nextLevelPromote:FilterFrameText;
      
      private var _nextAttribute1:FilterFrameText;
      
      private var _nextAttribute2:FilterFrameText;
      
      private var _nextValue1:FilterFrameText;
      
      private var _nextValue2:FilterFrameText;
      
      private var _itemLvl:FilterFrameText;
      
      private var _upGradeCellCountText:FilterFrameText;
      
      private var _upGradeCell:BaseCell;
      
      private var _progress:MagicHouseUpgradeProgress;
      
      private var _collectionType:Bitmap;
      
      private var _collectionTypeCon:Component;
      
      private var _upGradeBtn:SimpleBitmapButton;
      
      private var _potionCountSelecterFrame:MagicHouseMagicPotionSelectFrame;
      
      private var _lastStrengthTime:int = 0;
      
      public function MagicHouseCollectionItemView(param1:int)
      {
         super();
         this._type = param1;
         this._self = PlayerManager.Instance.Self;
         this.initView();
         this.initEvent();
      }
      
      private function creatItemCell() : BaseCell
      {
         var _loc1_:BaseCell = null;
         _loc1_ = null;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,30,30);
         _loc2_.graphics.endFill();
         _loc1_ = new BaseCell(_loc2_,null,true,true);
         _loc1_.tipDirctions = "7,6,2,1,5,4,0,3,6";
         _loc1_.tipGapV = 10;
         _loc1_.tipGapH = 10;
         _loc1_.tipStyle = "core.GoodsTip";
         return _loc1_;
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._item1 = new MagicHouseItemCell();
         addChild(this._item1);
         PositionUtils.setPos(this._item1,"magicHouse.collection.itemcell1Pos");
         this._item2 = new MagicHouseItemCell();
         addChild(this._item2);
         PositionUtils.setPos(this._item2,"magicHouse.collection.itemcell2Pos");
         this._item3 = new MagicHouseItemCell();
         addChild(this._item3);
         PositionUtils.setPos(this._item3,"magicHouse.collection.itemcell3Pos");
         this._item1.width = this._item2.width = this._item3.width = 66;
         this._item1.height = this._item2.height = this._item3.height = 66;
         this._addAttributeTxt = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText1");
         addChild(this._addAttributeTxt);
         this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
         PositionUtils.setPos(this._addAttributeTxt,"magicHouse.collection.itemAddAttributeTxtPos");
         this._attribute1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._attribute1);
         PositionUtils.setPos(this._attribute1,"magicHouse.collection.itemAttributeTxtPos1");
         this._attribute2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._attribute2);
         PositionUtils.setPos(this._attribute2,"magicHouse.collection.itemAttributeTxtPos2");
         this._attributeValue1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._attributeValue1);
         PositionUtils.setPos(this._attributeValue1,"magicHouse.collection.itemAttributeValueTxtPos1");
         this._attributeValue2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._attributeValue2);
         PositionUtils.setPos(this._attributeValue2,"magicHouse.collection.itemAttributeValueTxtPos2");
         this._nextLevelPromote = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText1");
         addChild(this._nextLevelPromote);
         PositionUtils.setPos(this._nextLevelPromote,"magicHouse.collection.itemNextLevelTxtPos");
         this._nextLevelPromote.text = LanguageMgr.GetTranslation("magichouse.collectionItem.nextLevelPromote");
         this._nextAttribute1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._nextAttribute1);
         PositionUtils.setPos(this._nextAttribute1,"magicHouse.collection.itemNextLevelAttributeTxtPos1");
         this._nextAttribute2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText2");
         addChild(this._nextAttribute2);
         PositionUtils.setPos(this._nextAttribute2,"magicHouse.collection.itemNextLevelAttributeTxtPos2");
         this._nextValue1 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._nextValue1);
         PositionUtils.setPos(this._nextValue1,"magicHouse.collection.itemNextLevelValueTxtPos1");
         this._nextValue2 = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.filterText3");
         addChild(this._nextValue2);
         PositionUtils.setPos(this._nextValue2,"magicHouse.collection.itemNextLevelValueTxtPos2");
         this._itemLvl = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.itemLvlText");
         addChild(this._itemLvl);
         var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(201489);
         this._upGradeCell = this.creatItemCell();
         this._upGradeCell.width = this._upGradeCell.height = 52;
         this._upGradeCell.info = _loc3_;
         addChild(this._upGradeCell);
         this._upGradeCellCountText = ComponentFactory.Instance.creatComponentByStylename("guildmemberweek.mainFrame.left.giftNumberShowTxt");
         this._upGradeCell.addChild(this._upGradeCellCountText);
         PositionUtils.setPos(this._upGradeCell,"magicHouse.collection.itemUpGradeCellPos");
         this._progress = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItem.upgrade.progress");
         this._progress.tipStyle = "ddt.view.tips.OneLineTip";
         this._progress.tipDirctions = "3,7,6";
         this._progress.tipGapV = 4;
         addChild(this._progress);
         this._collectionType = ComponentFactory.Instance.creatBitmap("magichouse.collection.item" + this._type);
         this._collectionTypeCon = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.titleTipContent");
         if(this._type == 1)
         {
            _loc1_ = 1010;
         }
         else if(this._type == 2)
         {
            _loc1_ = 1011;
         }
         else
         {
            _loc1_ = 1012;
         }
         if(Boolean(NewTitleManager.instance.titleInfo) && Boolean(NewTitleManager.instance.titleInfo[_loc1_]))
         {
            _loc2_ = new CallPropTxtTipInfo();
            _loc2_.Attack = NewTitleManager.instance.titleInfo[_loc1_].Att;
            _loc2_.Defend = NewTitleManager.instance.titleInfo[_loc1_].Def;
            _loc2_.Agility = NewTitleManager.instance.titleInfo[_loc1_].Agi;
            _loc2_.Lucky = NewTitleManager.instance.titleInfo[_loc1_].Luck;
            this._collectionTypeCon.tipData = _loc2_;
         }
         this._collectionTypeCon.addChild(this._collectionType);
         addChild(this._collectionTypeCon);
         this._upGradeBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionItemView.UpGradeBtn");
         addChild(this._upGradeBtn);
         this._setData();
         this._initProgress();
      }
      
      private function _initProgress() : void
      {
         if(this._type == 1)
         {
            this._progress.initProgress(MagicHouseModel.instance.magicJuniorLv,MagicHouseModel.instance.magicJuniorExp);
         }
         else if(this._type == 2)
         {
            this._progress.initProgress(MagicHouseModel.instance.magicMidLv,MagicHouseModel.instance.magicMidExp);
         }
         else
         {
            this._progress.initProgress(MagicHouseModel.instance.magicSeniorLv,MagicHouseModel.instance.magicSeniorExp);
         }
      }
      
      private function _updateProgress() : void
      {
         if(this._type == 1)
         {
            this._progress.setProgress(MagicHouseModel.instance.magicJuniorLv,MagicHouseModel.instance.magicJuniorExp);
         }
         else if(this._type == 2)
         {
            this._progress.setProgress(MagicHouseModel.instance.magicMidLv,MagicHouseModel.instance.magicMidExp);
         }
         else
         {
            this._progress.setProgress(MagicHouseModel.instance.magicSeniorLv,MagicHouseModel.instance.magicSeniorExp);
         }
      }
      
      private function _setCell() : void
      {
         if(this._type == 1)
         {
            this._item1.setTypeAndPos(this._type,0);
            if(MagicHouseModel.instance.activityWeapons[0] != 0)
            {
               this._item1.setOpened(true);
            }
            this._item1.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.juniorWeaponList[0].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[0] == 0)
            {
               this._item1.setFilter();
            }
            this._item2.setTypeAndPos(this._type,1);
            if(MagicHouseModel.instance.activityWeapons[1] != 0)
            {
               this._item2.setOpened(true);
            }
            this._item2.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.juniorWeaponList[1].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[1] == 0)
            {
               this._item2.setFilter();
            }
            this._item3.setTypeAndPos(this._type,2);
            if(MagicHouseModel.instance.activityWeapons[2] != 0)
            {
               this._item3.setOpened(true);
            }
            this._item3.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.juniorWeaponList[2].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[2] == 0)
            {
               this._item3.setFilter();
            }
         }
         else if(this._type == 2)
         {
            this._item1.setTypeAndPos(this._type,0);
            if(MagicHouseModel.instance.activityWeapons[3] != 0)
            {
               this._item1.setOpened(true);
            }
            this._item1.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.midWeaponList[0].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[3] == 0)
            {
               this._item1.setFilter();
            }
            this._item2.setTypeAndPos(this._type,1);
            if(MagicHouseModel.instance.activityWeapons[4] != 0)
            {
               this._item2.setOpened(true);
            }
            this._item2.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.midWeaponList[1].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[4] == 0)
            {
               this._item2.setFilter();
            }
            this._item3.setTypeAndPos(this._type,2);
            if(MagicHouseModel.instance.activityWeapons[5] != 0)
            {
               this._item3.setOpened(true);
            }
            this._item3.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.midWeaponList[2].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[5] == 0)
            {
               this._item3.setFilter();
            }
         }
         else
         {
            this._item1.setTypeAndPos(this._type,0);
            if(MagicHouseModel.instance.activityWeapons[6] != 0)
            {
               this._item1.setOpened(true);
            }
            this._item1.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.seniorWeapinList[0].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[6] == 0)
            {
               this._item1.setFilter();
            }
            this._item2.setTypeAndPos(this._type,1);
            if(MagicHouseModel.instance.activityWeapons[7] != 0)
            {
               this._item2.setOpened(true);
            }
            this._item2.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.seniorWeapinList[1].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[7] == 0)
            {
               this._item2.setFilter();
            }
            this._item3.setTypeAndPos(this._type,2);
            if(MagicHouseModel.instance.activityWeapons[8] != 0)
            {
               this._item3.setOpened(true);
            }
            this._item3.cellInfo = ItemManager.Instance.getTemplateById(MagicHouseModel.instance.seniorWeapinList[2].split(",")[0]);
            if(MagicHouseModel.instance.activityWeapons[8] == 0)
            {
               this._item3.setFilter();
            }
         }
      }
      
      private function _setData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._setCell();
         this.upDatafitCount();
         var _loc5_:Array = MagicHouseModel.instance.activityWeapons;
         var _loc6_:Array = MagicHouseModel.instance.juniorAddAttribute;
         var _loc7_:int = MagicHouseModel.instance.magicJuniorLv;
         var _loc8_:Array = MagicHouseModel.instance.midAddAttribute;
         var _loc9_:int = MagicHouseModel.instance.magicMidLv;
         var _loc10_:Array = MagicHouseModel.instance.seniorAddAttribute;
         var _loc11_:int = MagicHouseModel.instance.magicSeniorLv;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(this._type == 1)
         {
            this._attribute1.text = this._nextAttribute1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDamage");
            this._attribute2.text = this._nextAttribute2.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDefense");
            _loc1_ = MagicHouseModel.instance.magicJuniorLv;
            this._itemLvl.text = "Lv." + _loc1_;
            if(_loc5_[0] != 0 && _loc5_[1] != 0 && _loc5_[2] != 0)
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
               _loc2_ = 0;
               while(_loc2_ <= _loc7_)
               {
                  _loc12_ += int(_loc6_[_loc2_].split(",")[0]);
                  _loc13_ += int(_loc6_[_loc2_].split(",")[1]);
                  _loc2_++;
               }
               if(_loc7_ == _loc6_.length - 1)
               {
                  this._nextValue1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.maxLevel");
                  PositionUtils.setPos(this._nextValue1,"magicHouse.attributeTopTxtPos");
                  this._nextLevelPromote.visible = false;
                  this._nextAttribute1.visible = false;
                  this._nextAttribute2.visible = false;
                  this._nextValue2.visible = false;
               }
               else
               {
                  this._nextValue1.text = _loc6_[_loc7_ + 1].split(",")[0] + "%";
                  this._nextValue2.text = _loc6_[_loc7_ + 1].split(",")[1] + "%";
               }
            }
            else
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.afterActivate");
               _loc12_ = int(_loc6_[0].split(",")[0]);
               _loc13_ = int(_loc6_[0].split(",")[1]);
               this._nextValue1.text = _loc6_[1].split(",")[0] + "%";
               this._nextValue2.text = _loc6_[1].split(",")[1] + "%";
            }
         }
         else if(this._type == 2)
         {
            this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
            this._attribute1.text = this._nextAttribute1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDefense");
            this._attribute2.text = this._nextAttribute2.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addCritDamage");
            _loc1_ = MagicHouseModel.instance.magicMidLv;
            this._itemLvl.text = "Lv." + _loc1_;
            if(_loc5_[3] != 0 && _loc5_[4] != 0 && _loc5_[5] != 0)
            {
               _loc3_ = 0;
               while(_loc3_ <= _loc9_)
               {
                  _loc12_ += int(_loc8_[_loc3_].split(",")[1]);
                  _loc13_ += int(_loc8_[_loc3_].split(",")[2]);
                  _loc3_++;
               }
               if(_loc9_ == _loc8_.length - 1)
               {
                  this._nextValue1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.maxLevel");
                  PositionUtils.setPos(this._nextValue1,"magicHouse.attributeTopTxtPos");
                  this._nextLevelPromote.visible = false;
                  this._nextAttribute1.visible = false;
                  this._nextAttribute2.visible = false;
                  this._nextValue2.visible = false;
               }
               else
               {
                  this._nextValue1.text = _loc8_[_loc9_ + 1].split(",")[1] + "%";
                  this._nextValue2.text = _loc8_[_loc9_ + 1].split(",")[2] + "%";
               }
            }
            else
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.afterActivate");
               _loc12_ = int(_loc8_[0].split(",")[1]);
               _loc13_ = int(_loc8_[0].split(",")[2]);
               this._nextValue1.text = _loc8_[1].split(",")[1] + "%";
               this._nextValue2.text = _loc8_[1].split(",")[2] + "%";
            }
         }
         else
         {
            this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addAttribute" + this._type);
            this._attribute1.text = this._nextAttribute1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addMagicDamage");
            this._attribute2.text = this._nextAttribute2.text = LanguageMgr.GetTranslation("magichouse.collectionItem.addCritDamage");
            _loc1_ = MagicHouseModel.instance.magicSeniorLv;
            this._itemLvl.text = "Lv." + _loc1_;
            if(_loc5_[6] != 0 && _loc5_[7] != 0 && _loc5_[8] != 0)
            {
               _loc4_ = 0;
               while(_loc4_ <= _loc11_)
               {
                  _loc12_ += int(_loc10_[_loc4_].split(",")[0]);
                  _loc13_ += int(_loc10_[_loc4_].split(",")[2]);
                  _loc4_++;
               }
               if(_loc11_ == _loc10_.length - 1)
               {
                  this._nextValue1.text = LanguageMgr.GetTranslation("magichouse.collectionItem.maxLevel");
                  PositionUtils.setPos(this._nextValue1,"magicHouse.attributeTopTxtPos");
                  this._nextLevelPromote.visible = false;
                  this._nextAttribute1.visible = false;
                  this._nextAttribute2.visible = false;
                  this._nextValue2.visible = false;
               }
               else
               {
                  this._nextValue1.text = _loc10_[_loc11_ + 1].split(",")[0] + "%";
                  this._nextValue2.text = _loc10_[_loc11_ + 1].split(",")[2] + "%";
               }
            }
            else
            {
               this._addAttributeTxt.text = LanguageMgr.GetTranslation("magichouse.collectionItem.afterActivate");
               _loc12_ = int(_loc10_[0].split(",")[0]);
               _loc13_ = int(_loc10_[0].split(",")[2]);
               this._nextValue1.text = _loc10_[1].split(",")[0] + "%";
               this._nextValue2.text = _loc10_[1].split(",")[2] + "%";
            }
         }
         this._attributeValue1.text = _loc12_ + "%";
         this._attributeValue2.text = _loc13_ + "%";
         this._upGradeBtn.enable = this._item1.isOpen && this._item2.isOpen && this._item3.isOpen && _loc1_ < 5;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener("buygoods",this.onBuyedGoods);
         this._upGradeBtn.addEventListener("click",this.__upGrade);
         MagicHouseManager.instance.addEventListener("magichouse_updata",this.__messageUpdate);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener("buygoods",this.onBuyedGoods);
         this._upGradeBtn.removeEventListener("click",this.__upGrade);
         MagicHouseManager.instance.removeEventListener("magichouse_updata",this.__messageUpdate);
      }
      
      private function onBuyedGoods(param1:CrazyTankSocketEvent) : void
      {
         this.upDatafitCount();
      }
      
      private function __upGrade(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(201489) > 0)
         {
            this._potionCountSelecterFrame = ComponentFactory.Instance.creatComponentByStylename("magichouse.magicpotion.selecterFrame");
            this._potionCountSelecterFrame.type = this._type;
            LayerManager.Instance.addToLayer(this._potionCountSelecterFrame,3,true,1);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionItem.magicPotionLess"));
         }
      }
      
      private function __messageUpdate(param1:Event) : void
      {
         this._setData();
         this._updateProgress();
      }
      
      public function upDatafitCount() : void
      {
         if(!this._upGradeCell)
         {
            return;
         }
         var _loc1_:BagInfo = this._self.getBag(1);
         var _loc2_:int = _loc1_.getItemCountByTemplateId(201489);
         this._upGradeCellCountText.text = _loc2_.toString();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._item1))
         {
            this._item1.dispose();
         }
         this._item1 = null;
         if(Boolean(this._item2))
         {
            this._item2.dispose();
         }
         this._item2 = null;
         if(Boolean(this._item3))
         {
            this._item3.dispose();
         }
         this._item3 = null;
         if(Boolean(this._addAttributeTxt))
         {
            this._addAttributeTxt.dispose();
         }
         this._addAttributeTxt = null;
         if(Boolean(this._attribute1))
         {
            this._attribute1.dispose();
         }
         this._attribute1 = null;
         if(Boolean(this._attribute2))
         {
            this._attribute2.dispose();
         }
         this._attribute2 = null;
         if(Boolean(this._attributeValue1))
         {
            this._attributeValue1.dispose();
         }
         this._attributeValue1 = null;
         if(Boolean(this._attributeValue2))
         {
            this._attributeValue2.dispose();
         }
         this._attributeValue2 = null;
         if(Boolean(this._nextLevelPromote))
         {
            this._nextLevelPromote.dispose();
         }
         this._nextLevelPromote = null;
         if(Boolean(this._nextAttribute1))
         {
            this._nextAttribute1.dispose();
         }
         this._nextAttribute1 = null;
         if(Boolean(this._nextAttribute2))
         {
            this._nextAttribute2.dispose();
         }
         this._nextAttribute2 = null;
         if(Boolean(this._nextValue1))
         {
            this._nextValue1.dispose();
         }
         this._nextValue1 = null;
         if(Boolean(this._nextValue2))
         {
            this._nextValue2.dispose();
         }
         this._nextValue2 = null;
         if(Boolean(this._itemLvl))
         {
            this._itemLvl.dispose();
         }
         this._itemLvl = null;
         if(Boolean(this._upGradeCell))
         {
            this._upGradeCell.dispose();
         }
         this._upGradeCell = null;
         if(Boolean(this._progress))
         {
            this._progress.dispose();
         }
         this._progress = null;
         if(Boolean(this._collectionType))
         {
            ObjectUtils.disposeObject(this._collectionType);
         }
         this._collectionType = null;
         if(Boolean(this._collectionTypeCon))
         {
            ObjectUtils.disposeObject(this._collectionTypeCon);
         }
         this._collectionTypeCon = null;
         if(Boolean(this._upGradeBtn))
         {
            this._upGradeBtn.dispose();
         }
         this._upGradeBtn = null;
      }
   }
}

