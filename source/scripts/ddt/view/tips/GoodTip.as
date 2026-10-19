package ddt.view.tips
{
   import AvatarCollection.AvatarCollectionManager;
   import GodSyah.SyahManager;
   import GodSyah.SyahTip;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.bag.ring.RingSystemTip;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITip;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PetSkillManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import ddt.utils.StaticFormula;
   import ddt.view.SimpleItem;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import gemstone.GemstoneManager;
   import gemstone.items.GemstonTipItem;
   import gypsyShop.ctrl.GypsyShopManager;
   import latentEnergy.LatentEnergyTipItem;
   import road7th.utils.DateUtils;
   import road7th.utils.StringHelper;
   import store.data.StoreEquipExperience;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.data.EquipGhostData;
   import store.equipGhost.data.GhostPropertyData;
   
   public class GoodTip extends BaseTip implements Disposeable, ITip
   {
      
      public static const BOUND:uint = 1;
      
      public static const UNBOUND:uint = 2;
      
      public static const ITEM_NORMAL_COLOR:uint = 16777215;
      
      public static const ITEM_NECKLACE_COLOR:uint = 16750899;
      
      public static const ITEM_PROPERTIES_COLOR:uint = 16750899;
      
      public static const ITEM_HOLES_COLOR:uint = 16777215;
      
      public static const ITEM_HOLE_RESERVE_COLOR:uint = 16776960;
      
      public static const ITEM_HOLE_GREY_COLOR:uint = 6710886;
      
      public static const ITEM_FIGHT_PROP_CONSUME_COLOR:uint = 14520832;
      
      public static const ITEM_NEED_LEVEL_COLOR:uint = 13421772;
      
      public static const ITEM_NEED_LEVEL_FAILED_COLOR:uint = 16711680;
      
      public static const ITEM_UPGRADE_TYPE_COLOR:uint = 10092339;
      
      public static const ITEM_NEED_SEX_COLOR:uint = 10092339;
      
      public static const ITEM_NEED_SEX_FAILED_COLOR:uint = 16711680;
      
      public static const ITEM_ETERNAL_COLOR:uint = 16776960;
      
      public static const ITEM_PAST_DUE_COLOR:uint = 16711680;
      
      private static const PET_SPECIAL_FOOD:int = 334100;
      
      private var _strengthenLevelImage:MovieImage;
      
      private var _fusionLevelImage:MovieImage;
      
      private var _boundImage:ScaleFrameImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _qualityItem:SimpleItem;
      
      private var _typeItem:SimpleItem;
      
      private var _mainPropertyItem:SimpleItem;
      
      private var _armAngleItem:SimpleItem;
      
      private var _otherHp:SimpleItem;
      
      private var _necklaceItem:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenseTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _needLevelTxt:FilterFrameText;
      
      private var _needSexTxt:FilterFrameText;
      
      private var _holes:Vector.<FilterFrameText> = new Vector.<FilterFrameText>();
      
      private var _upgradeType:FilterFrameText;
      
      private var _descriptionTxt:FilterFrameText;
      
      private var _bindTypeTxt:FilterFrameText;
      
      protected var _remainTimeTxt:FilterFrameText;
      
      private var _goldRemainTimeTxt:FilterFrameText;
      
      private var _fightPropConsumeTxt:FilterFrameText;
      
      private var _boxTimeTxt:FilterFrameText;
      
      protected var _info:ItemTemplateInfo;
      
      private var _bindImageOriginalPos:Point;
      
      private var _maxWidth:int;
      
      private var _minWidth:int = 196;
      
      protected var _isArmed:Boolean;
      
      protected var _displayList:Vector.<DisplayObject>;
      
      protected var _displayIdx:int;
      
      private var _lines:Vector.<Image>;
      
      private var _lineIdx:int;
      
      private var _isReAdd:Boolean;
      
      protected var _remainTimeBg:Bitmap;
      
      private var _gp:FilterFrameText;
      
      private var _maxGP:FilterFrameText;
      
      private var _levelTxt:FilterFrameText;
      
      protected var _laterEquipmentGoodView:LaterEquipmentGoodView;
      
      protected var syahTip:SyahTip;
      
      private var _avatarTxt:FilterFrameText;
      
      private var _addition:RingSystemTip;
      
      private var _ghostSkillDesc:FilterFrameText;
      
      private var _autoGhostWidth:int;
      
      private var _ghostContent:Sprite;
      
      private var _ghostPropertyData:GhostPropertyData;
      
      private var _ghostStartsContainer:GhostStarContainer = null;
      
      public function GoodTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._lines = new Vector.<Image>();
         this._displayList = new Vector.<DisplayObject>();
         _tipbackgound = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._strengthenLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameMc");
         this._fusionLevelImage = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTrinketLevelMc");
         this._boundImage = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.BoundImage");
         this._bindImageOriginalPos = new Point(this._boundImage.x,this._boundImage.y);
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._qualityItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.QualityItem");
         this._typeItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.TypeItem");
         this._mainPropertyItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.MainPropertyItem");
         this._armAngleItem = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.armAngleItem");
         this._otherHp = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.otherHp");
         this._necklaceItem = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._attackTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._defenseTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._agilityTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._luckTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.LimitGradeTxt");
         this._gp = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._maxGP = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._ghostSkillDesc = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.ghostDescTxt");
         this._holes = new Vector.<FilterFrameText>();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._holes.push(ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt"));
            _loc1_++;
         }
         this._needLevelTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._needSexTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._upgradeType = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._descriptionTxt = ComponentFactory.Instance.creatComponentByStylename("core.goodTip.DescriptionTxt");
         this._bindTypeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._remainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemDateTxt");
         this._goldRemainTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipGoldItemDateTxt");
         this._remainTimeBg = ComponentFactory.Instance.creatBitmap("asset.core.tip.restTime");
         this._fightPropConsumeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._boxTimeTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemTxt");
         this._laterEquipmentGoodView = new LaterEquipmentGoodView();
         this._laterEquipmentGoodView.visible = false;
         this._avatarTxt = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTip.avatarItemTxt");
      }
      
      override public function get tipData() : Object
      {
         return _tipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(Boolean(param1) && param1 is GoodTipInfo)
         {
            _tipData = param1 as GoodTipInfo;
            this.showTip(_tipData.itemInfo,_tipData.typeIsSecond);
            if(PathManager.suitEnable)
            {
               this.showSuitTip(_tipData.itemInfo);
            }
            else
            {
               this._laterEquipmentGoodView.visible = false;
            }
            if(SyahManager.Instance.isOpen)
            {
               this.showSyahTip();
            }
            visible = true;
         }
         else
         {
            _tipData = null;
            visible = false;
            this._laterEquipmentGoodView.visible = false;
         }
      }
      
      private function laterEquipment(param1:ItemTemplateInfo) : void
      {
         if(!this._laterEquipmentGoodView)
         {
            this._laterEquipmentGoodView = new LaterEquipmentGoodView();
         }
         this._laterEquipmentGoodView.tipData = param1;
      }
      
      public function showTip(param1:ItemTemplateInfo, param2:Boolean = false) : void
      {
         this._displayIdx = 0;
         this._displayList = new Vector.<DisplayObject>();
         this._lineIdx = 0;
         this._isReAdd = false;
         this._maxWidth = 0;
         this._autoGhostWidth = 0;
         this._info = param1;
         this._ghostPropertyData = this.getGhostPropertyData();
         this.updateView();
      }
      
      public function showSuitTip(param1:ItemTemplateInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:ItemTemplateInfo = _tipData.itemInfo;
         if(_loc3_ is ItemTemplateInfo)
         {
            if(_loc3_.SuitId != 0)
            {
               this._laterEquipmentGoodView.visible = true;
               _loc2_ = localToGlobal(new Point(_tipbackgound.x,_tipbackgound.y));
               if(_loc2_.x + _tipbackgound.width + this._laterEquipmentGoodView.width < 1000)
               {
                  this._laterEquipmentGoodView.x = _width + 5;
               }
               else
               {
                  this._laterEquipmentGoodView.x = -this._laterEquipmentGoodView.width - 5;
               }
               this.laterEquipment(_loc3_);
            }
            else
            {
               this._laterEquipmentGoodView.visible = false;
            }
         }
         else
         {
            this._laterEquipmentGoodView.visible = false;
         }
         this._laterEquipmentGoodView.y = _tipbackgound.height - this._laterEquipmentGoodView.height;
      }
      
      private function updateView() : void
      {
         if(this._info == null)
         {
            return;
         }
         this.clear();
         this._isArmed = false;
         this.createItemName();
         this.createQualityItem();
         this.createCategoryItem();
         this.createMainProperty();
         this.seperateLine();
         this.createAvatarState();
         this.seperateLine();
         this.createNecklaceItem();
         this.createProperties();
         this.creatLevel();
         this.seperateLine();
         this.createHoleItem();
         this.createOperationItem();
         this.seperateLine();
         this.createDescript();
         this.createLatentEnergy();
         this.createBindType();
         this.createRemainTime();
         this.createGoldRemainTime();
         this.createFightPropConsume();
         this.createBoxTimeItem();
         this.createStrenthLevel();
         this.creatGemstone();
         this.addChildren();
         this.createRingAddition();
         this.createGhostSkillitem();
      }
      
      private function createRingAddition() : void
      {
         if(!PathManager.RingSystemEnable)
         {
            return;
         }
         var _loc1_:* = null;
         if(this._info is InventoryItemInfo && EquipType.isWeddingRing(this._info))
         {
            _loc1_ = BagAndInfoManager.Instance.getRingData(InventoryItemInfo(this._info).RingExp);
            if(PlayerManager.Instance.Self.ID == InventoryItemInfo(this._info).UserID)
            {
               _loc1_ = BagAndInfoManager.Instance.getRingData(PlayerManager.Instance.Self.RingExp);
            }
            this._addition = new RingSystemTip();
            this._addition.setAdditiontext([this._info.Attack * _loc1_.Attack,this._info.Defence * _loc1_.Defence,this._info.Agility * _loc1_.Agility,this._info.Luck * _loc1_.Luck]);
            this._addition.x = this._attackTxt.x + 130;
            this._addition.y = this._attackTxt.y + 3;
            addChild(this._addition);
         }
      }
      
      private function createGhostSkillitem() : void
      {
         var _loc1_:* = null;
         if(!this._ghostPropertyData)
         {
            return;
         }
         var _loc2_:PlayerInfo = PlayerInfoViewControl.currentPlayer ? PlayerInfoViewControl.currentPlayer : PlayerManager.Instance.Self;
         var _loc3_:EquipGhostData = _loc2_.getGhostDataByCategoryID(this._info.CategoryID);
         if(Boolean(_loc3_))
         {
            _loc1_ = EquipGhostManager.getInstance().model.getGhostData(this._info.CategoryID == 27 ? 7 : int(this._info.CategoryID),_loc3_.level);
            if(Boolean(_loc1_))
            {
               this._ghostSkillDesc.text = StringHelper.format(PetSkillManager.getSkillByID(_loc1_.skillId).Description);
               this._displayList[this._displayIdx++] = this._ghostSkillDesc;
            }
         }
      }
      
      private function clear() : void
      {
         var _loc1_:DisplayObject = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0) as DisplayObject;
            if(Boolean(_loc1_.parent))
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      private function createLatentEnergy() : void
      {
         var _loc5_:* = undefined;
         if(!PathManager.LatentEnergyEnable)
         {
            return;
         }
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:LatentEnergyTipItem = null;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(_loc1_.isHasLatentEnergy)
            {
               _loc2_ = _loc1_.latentEnergyCurList;
               _loc3_ = 0;
               while(_loc3_ < 4)
               {
                  _loc4_ = new LatentEnergyTipItem();
                  _loc4_.setView(_loc3_,_loc2_[_loc3_]);
                  _loc5_ = this._displayIdx++;
                  this._displayList[_loc5_] = _loc4_;
                  _loc3_++;
               }
            }
         }
      }
      
      override protected function addChildren() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = int(this._displayList.length);
         var _loc3_:Point = new Point(4,4);
         var _loc4_:int = 6;
         var _loc5_:int = this._maxWidth;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc1_ = this._displayList[_loc6_] as DisplayObject;
            if(this._lines.indexOf(_loc1_) < 0 && _loc1_ != this._descriptionTxt && _loc1_ != this._ghostSkillDesc)
            {
               _loc5_ = Math.max(_loc1_.width,_loc5_);
            }
            PositionUtils.setPos(_loc1_,_loc3_);
            addChild(_loc1_);
            _loc3_.y = _loc1_.y + _loc1_.height + _loc4_;
            _loc6_++;
         }
         this._maxWidth = Math.max(this._minWidth,_loc5_);
         if(this._autoGhostWidth > this._maxWidth)
         {
            this._maxWidth = this._autoGhostWidth;
         }
         if(this._descriptionTxt.width != this._maxWidth)
         {
            this._descriptionTxt.width = this._maxWidth;
            this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
            this.addChildren();
            return;
         }
         if(this._ghostSkillDesc.width != this._maxWidth)
         {
            this._ghostSkillDesc.width = this._maxWidth;
            this._ghostSkillDesc.height = this._ghostSkillDesc.textHeight + 10;
            this.addChildren();
            return;
         }
         if(!this._isReAdd)
         {
            _loc6_ = 0;
            while(_loc6_ < this._lines.length)
            {
               this._lines[_loc6_].width = this._maxWidth;
               if(_loc6_ + 1 < this._lines.length && this._lines[_loc6_ + 1].parent != null && Math.abs(this._lines[_loc6_ + 1].y - this._lines[_loc6_].y) <= 10)
               {
                  this._displayList.splice(this._displayList.indexOf(this._lines[_loc6_ + 1]),1);
                  this._lines[_loc6_ + 1].parent.removeChild(this._lines[_loc6_ + 1]);
                  this._isReAdd = true;
               }
               _loc6_++;
            }
            if(this._isReAdd)
            {
               this.addChildren();
               return;
            }
         }
         if(_loc2_ > 0)
         {
            _width = _tipbackgound.width = this._maxWidth + 8;
            _height = _tipbackgound.height = _loc1_.y + _loc1_.height + 8;
         }
         if(Boolean(_tipbackgound))
         {
            addChildAt(_tipbackgound,0);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.x = this._remainTimeTxt.x + 2;
            this._remainTimeBg.y = this._remainTimeTxt.y + 2;
            this._remainTimeBg.parent.addChildAt(this._remainTimeBg,1);
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._goldRemainTimeTxt.x = this._remainTimeTxt.x + 2;
            this._goldRemainTimeTxt.y = this._remainTimeTxt.y + 22;
            this._remainTimeBg.parent.addChildAt(this._goldRemainTimeTxt,1);
         }
         addChild(this._laterEquipmentGoodView);
      }
      
      private function createItemName() : void
      {
         var _loc1_:TextFormat = null;
         this._nameTxt.text = String(this._info.Name);
         var _loc2_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc2_) && _loc2_.StrengthenLevel > 0)
         {
            if(_loc2_.isGold)
            {
               if(_loc2_.StrengthenLevel > PathManager.solveStrengthMax())
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc2_.StrengthenLevel - 12);
               }
               else
               {
                  this._nameTxt.text += LanguageMgr.GetTranslation("wishBead.StrengthenLevel");
               }
            }
            else if(_loc2_.StrengthenLevel <= PathManager.solveStrengthMax())
            {
               this._nameTxt.text += "(+" + (this._info as InventoryItemInfo).StrengthenLevel + ")";
            }
            else if(_loc2_.StrengthenLevel > PathManager.solveStrengthMax())
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("store.view.exalt.goodTips",_loc2_.StrengthenLevel - 12);
            }
         }
         var _loc3_:int = this._nameTxt.text.indexOf("+");
         if(_loc3_ > 0)
         {
            _loc1_ = ComponentFactory.Instance.model.getSet("core.goodTip.ItemNameNumTxtFormat");
            this._nameTxt.setTextFormat(_loc1_,_loc3_,_loc3_ + 1);
         }
         if(Boolean(PlayerInfoViewControl.currentPlayer))
         {
            if(Boolean(_loc2_ && _loc2_.Place == 12 && _loc2_.UserID == PlayerInfoViewControl.currentPlayer.ID) && Boolean(PlayerInfoViewControl.currentPlayer.necklaceLevel > 0) && _loc2_.CategoryID == EquipType.NECKLACE)
            {
               this._nameTxt.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTip",PlayerInfoViewControl.currentPlayer.necklaceLevel);
            }
         }
         this._nameTxt.textColor = QualityType.QUALITY_COLOR[this._info.Quality];
         var _loc4_:* = this._displayIdx++;
         this._displayList[_loc4_] = this._nameTxt;
      }
      
      protected function createQualityItem() : void
      {
         var _loc1_:FilterFrameText = this._qualityItem.foreItems[0] as FilterFrameText;
         _loc1_.text = QualityType.QUALITY_STRING[this.getInfoQuality()];
         _loc1_.textColor = QualityType.QUALITY_COLOR[this.getInfoQuality()];
         if(!EquipType.isBead(this._info))
         {
            this._displayList[this._displayIdx++] = this._qualityItem;
         }
      }
      
      private function getInfoQuality() : int
      {
         return this._info.Quality;
      }
      
      protected function createCategoryItem() : void
      {
         var _loc1_:FilterFrameText = this._typeItem.foreItems[0] as FilterFrameText;
         var _loc2_:Array = EquipType.PARTNAME;
         if(this._info.CategoryID == 31)
         {
            _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.tempHelp");
         }
         else if(this._info.CategoryID == 222222222)
         {
            _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.normal");
         }
         else if(this._info.CategoryID == 80)
         {
            _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.fuzhudaoju");
         }
         else if(this._info.Property1 == "31")
         {
            switch(this._info.Property2)
            {
               case "1":
                  _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.atacckt");
                  break;
               case "2":
                  _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.defent");
                  break;
               case "3":
                  _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.attribute");
            }
         }
         else
         {
            _loc1_.text = EquipType.PARTNAME[this._info.CategoryID] + "";
         }
         if(EquipType.isBead(this._info))
         {
            _loc1_.textColor = 65406;
         }
         if(this._info.CategoryID == 180)
         {
            _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.fuzhudaoju");
         }
         if(this._info.CategoryID == 205)
         {
            _loc1_.text = LanguageMgr.GetTranslation("tank.data.EquipType.fuzhudaoju");
         }
         if(this._info.TemplateID == 20150 || this._info.TemplateID == 201266)
         {
            _loc1_.text = EquipType.PARTNAME[23];
         }
         this._displayList[this._displayIdx++] = this._typeItem;
      }
      
      private function createMainProperty() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = "";
         var _loc8_:int = 0;
         var _loc9_:FilterFrameText = this._mainPropertyItem.foreItems[0] as FilterFrameText;
         var _loc10_:ScaleFrameImage = this._mainPropertyItem.backItem as ScaleFrameImage;
         var _loc11_:InventoryItemInfo = this._info as InventoryItemInfo;
         GhostStarContainer(this._mainPropertyItem.foreItems[1]).visible = false;
         GhostStarContainer(this._armAngleItem.foreItems[1]).visible = false;
         this._autoGhostWidth = 0;
         var _loc12_:uint = 0;
         var _loc13_:PlayerInfo = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self;
         if(EquipType.isArm(this._info))
         {
            _loc1_ = 0;
            if(Boolean(_loc11_) && _loc11_.StrengthenLevel > 0)
            {
               _loc8_ = _loc11_.isGold ? int(_loc11_.StrengthenLevel + 1) : _loc11_.StrengthenLevel;
               _loc1_ = Number(StaticFormula.getHertAddition(int(_loc11_.Property7),_loc8_));
            }
            _loc10_.setFrame(1);
            _loc12_ = _loc1_ + (this._ghostPropertyData ? this._ghostPropertyData.mainProperty : 0);
            _loc7_ = _loc12_ > 0 ? "(+" + _loc12_ + ")" : "";
            _loc9_.text = "   " + this._info.Property7.toString() + _loc7_;
            _loc9_.x = 60;
            FilterFrameText(this._armAngleItem.foreItems[0]).text = " " + this._info.Property5 + "°~" + this._info.Property6 + "°";
            this._displayList[this._displayIdx++] = this._mainPropertyItem;
            this._displayList[this._displayIdx++] = this._armAngleItem;
            if(this._ghostPropertyData != null)
            {
               this._ghostStartsContainer = this._armAngleItem.foreItems[1] as GhostStarContainer;
               this._ghostStartsContainer.x = this._armAngleItem.foreItems[0].width + this._armAngleItem.foreItems[0].x;
               this._ghostStartsContainer.y = this._armAngleItem.foreItems[0].y + 8;
               this._ghostStartsContainer.maxLv = EquipGhostManager.getInstance().model.topLvDic[this._info.CategoryID == 27 ? 7 : this._info.CategoryID];
               this._ghostStartsContainer.level = _loc13_.getGhostDataByCategoryID(this._info.CategoryID).level;
               this._ghostStartsContainer.visible = true;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
         else if(EquipType.isArmShell(this._info))
         {
            FilterFrameText(this._armAngleItem.foreItems[0]).text = " " + this._info.Property5 + "°~" + this._info.Property6 + "°";
            this._displayList[this._displayIdx++] = this._armAngleItem;
         }
         else if(EquipType.isHead(this._info) || EquipType.isCloth(this._info))
         {
            _loc2_ = 0;
            if(Boolean(_loc11_) && _loc11_.StrengthenLevel > 0)
            {
               _loc8_ = _loc11_.isGold ? int(_loc11_.StrengthenLevel + 1) : _loc11_.StrengthenLevel;
               _loc2_ = Number(StaticFormula.getDefenseAddition(int(_loc11_.Property7),_loc8_));
            }
            _loc10_.setFrame(2);
            _loc12_ = _loc2_ + (this._ghostPropertyData != null ? this._ghostPropertyData.mainProperty : 0);
            _loc7_ = _loc12_ > 0 ? "(+" + _loc12_ + ")" : "";
            _loc9_.text = " " + this._info.Property7.toString() + _loc7_;
            _loc9_.x = 60;
            this._displayList[this._displayIdx++] = this._mainPropertyItem;
            if(Boolean(_loc11_) && _loc11_.isGold)
            {
               FilterFrameText(this._otherHp.foreItems[0]).text = _loc11_.Boold.toString();
               this._displayList[this._displayIdx++] = this._otherHp;
            }
            if(this._ghostPropertyData != null)
            {
               this._ghostStartsContainer = this._mainPropertyItem.foreItems[1] as GhostStarContainer;
               this._ghostStartsContainer.maxLv = EquipGhostManager.getInstance().model.topLvDic[this._info.CategoryID == 27 ? 7 : this._info.CategoryID];
               this._ghostStartsContainer.x = this._mainPropertyItem.foreItems[0].width + this._mainPropertyItem.foreItems[0].x;
               this._ghostStartsContainer.y = this._mainPropertyItem.foreItems[0].y + 8;
               this._ghostStartsContainer.level = _loc13_.getGhostDataByCategoryID(this._info.CategoryID).level;
               this._ghostStartsContainer.visible = true;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
         else if(StaticFormula.isDeputyWeapon(this._info) || this._info.CategoryID == 31)
         {
            _loc3_ = " ";
            if(this._info.Property3 == "32")
            {
               if(Boolean(_loc11_) && _loc11_.StrengthenLevel > 0)
               {
                  _loc8_ = _loc11_.isGold ? int(_loc11_.StrengthenLevel + 1) : _loc11_.StrengthenLevel;
                  _loc7_ = "(+" + StaticFormula.getRecoverHPAddition(int(_loc11_.Property7),_loc8_) + ")";
               }
               _loc10_.setFrame(3);
               _loc3_ = "   ";
               _loc9_.text = " " + this._info.Property7.toString() + _loc7_;
               _loc9_.x = 68;
            }
            else if(this._info.Property3 == "132")
            {
               if(Boolean(_loc11_) && _loc11_.StrengthenLevel > 0)
               {
                  _loc8_ = _loc11_.isGold ? int(_loc11_.StrengthenLevel + 1) : _loc11_.StrengthenLevel;
                  _loc7_ = "(+" + int(StaticFormula.getRecoverHPAddition(int(_loc11_.Property7),_loc8_) / 2) + ")";
               }
               _loc10_.setFrame(5);
               _loc9_.text = " " + int(this._info.Property7) / 2 + _loc7_;
               _loc9_.x = 96;
            }
            else if(this._info.Property3 == "143")
            {
               if(Boolean(_loc11_) && _loc11_.StrengthenLevel > 0)
               {
                  _loc8_ = _loc11_.isGold ? int(_loc11_.StrengthenLevel + 1) : _loc11_.StrengthenLevel;
                  _loc7_ = "(+" + StaticFormula.getDefenseAddition(int(_loc11_.Property7),_loc8_) + ")";
               }
               _loc10_.setFrame(6);
               _loc9_.text = " " + this._info.Property7.toString() + _loc7_;
               PositionUtils.setPos(_loc9_,"goodTip.mainProperty.txtPos");
            }
            else
            {
               if(Boolean(_loc11_) && _loc11_.StrengthenLevel > 0)
               {
                  _loc8_ = _loc11_.isGold ? int(_loc11_.StrengthenLevel + 1) : _loc11_.StrengthenLevel;
                  _loc7_ = "(+" + StaticFormula.getDefenseAddition(int(_loc11_.Property7),_loc8_) + ")";
               }
               _loc10_.setFrame(4);
               _loc9_.text = "         " + this._info.Property7.toString() + _loc7_;
               _loc9_.x = 51;
               _loc3_ = "            ";
            }
            this._displayList[this._displayIdx++] = this._mainPropertyItem;
         }
         if(Boolean(_loc9_))
         {
            _loc4_ = ComponentFactory.Instance.model.getSet("ddt.store.view.exalt.LaterEquipmentViewTextTF");
            _loc5_ = _loc9_.text.indexOf("(");
            _loc6_ = _loc9_.text.indexOf(")") + 1;
            if(_loc5_ != -1 && _loc6_ != 0)
            {
               _loc9_.setTextFormat(_loc4_,_loc5_,_loc6_);
            }
         }
      }
      
      private function createNecklaceItem() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         if(this._info.CategoryID == EquipType.NECKLACE)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.advance") + this._info.Property1 + "%";
            _loc1_ = this._info as InventoryItemInfo;
            if(Boolean(_loc1_ && _loc1_.Place == 12) && Boolean(_loc1_.UserID == PlayerInfoViewControl.currentPlayer.ID) && PlayerInfoViewControl.currentPlayer.necklaceLevel > 0)
            {
               _loc2_ = StoreEquipExperience.getNecklaceStrengthPlus(PlayerInfoViewControl.currentPlayer.necklaceLevel);
               this._necklaceItem.text += LanguageMgr.GetTranslation("bagAndInfo.bag.NecklacePtetrochemicalView.goodTipII",_loc2_);
            }
            this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._necklaceItem;
         }
         else if(this._info.CategoryID == EquipType.HEALSTONE)
         {
            this._necklaceItem.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.life") + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.reply") + this._info.Property2;
            this._necklaceItem.textColor = ITEM_NECKLACE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._necklaceItem;
         }
      }
      
      private function createProperties() : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:* = null;
         var _loc7_:int = 0;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(_loc1_.AttackCompose > 0)
            {
               _loc2_ = "(+" + String(_loc1_.AttackCompose) + ")";
            }
            if(_loc1_.DefendCompose > 0)
            {
               _loc3_ = "(+" + String(_loc1_.DefendCompose) + ")";
            }
            if(_loc1_.AgilityCompose > 0)
            {
               _loc4_ = "(+" + String(_loc1_.AgilityCompose) + ")";
            }
            if(_loc1_.LuckCompose > 0)
            {
               _loc5_ = "(+" + String(_loc1_.LuckCompose) + ")";
            }
         }
         if(this._info.Attack != 0)
         {
            this._attackTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.fire") + ":" + String(this._info.Attack) + _loc2_;
            this._attackTxt.textColor = ITEM_PROPERTIES_COLOR;
            _loc8_ = this._displayIdx++;
            this._displayList[_loc8_] = this._attackTxt;
         }
         if(this._info.Defence != 0)
         {
            this._defenseTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recovery") + ":" + String(this._info.Defence) + _loc3_;
            this._defenseTxt.textColor = ITEM_PROPERTIES_COLOR;
            _loc8_ = this._displayIdx++;
            this._displayList[_loc8_] = this._defenseTxt;
         }
         if(this._info.Agility != 0)
         {
            this._agilityTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.agility") + ":" + String(this._info.Agility) + _loc4_;
            this._agilityTxt.textColor = ITEM_PROPERTIES_COLOR;
            _loc8_ = this._displayIdx++;
            this._displayList[_loc8_] = this._agilityTxt;
         }
         if(this._info.Luck != 0)
         {
            this._luckTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.lucky") + ":" + String(this._info.Luck) + _loc5_;
            this._luckTxt.textColor = ITEM_PROPERTIES_COLOR;
            _loc8_ = this._displayIdx++;
            this._displayList[_loc8_] = this._luckTxt;
         }
         if(this._info.TemplateID == PET_SPECIAL_FOOD)
         {
            this._gp.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.gp") + ":" + InventoryItemInfo(this._info).DefendCompose;
            this._gp.textColor = ITEM_PROPERTIES_COLOR;
            _loc8_ = this._displayIdx++;
            this._displayList[_loc8_] = this._gp;
            this._maxGP.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.maxGP") + ":" + InventoryItemInfo(this._info).AgilityCompose;
            this._maxGP.textColor = ITEM_PROPERTIES_COLOR;
            _loc9_ = this._displayIdx++;
            this._displayList[_loc9_] = this._maxGP;
         }
      }
      
      private function createHoleItem() : void
      {
         var _loc9_:* = undefined;
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:FilterFrameText = null;
         var _loc8_:int = 0;
         if(!StringHelper.isNullOrEmpty(this._info.Hole))
         {
            _loc1_ = [];
            _loc2_ = this._info.Hole.split("|");
            _loc3_ = this._info as InventoryItemInfo;
            if(_loc2_.length > 0 && String(_loc2_[0]) != "" && _loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc2_.length)
               {
                  _loc5_ = String(_loc2_[_loc4_]);
                  _loc6_ = _loc5_.split(",");
                  if(_loc4_ < 4)
                  {
                     if(int(_loc6_[0]) > 0 && int(_loc6_[0]) - _loc3_.StrengthenLevel <= 3 || this.getHole(_loc3_,_loc4_ + 1) >= 0)
                     {
                        _loc8_ = int(_loc6_[0]);
                        _loc7_ = this.createSingleHole(_loc3_,_loc4_,_loc8_,_loc6_[1]);
                        _loc9_ = this._displayIdx++;
                        this._displayList[_loc9_] = _loc7_;
                     }
                  }
                  else if(_loc3_["Hole" + (_loc4_ + 1) + "Level"] >= 1 || _loc3_["Hole" + (_loc4_ + 1)] > 0)
                  {
                     _loc7_ = this.createSingleHole(_loc3_,_loc4_,int.MAX_VALUE,_loc6_[1]);
                     _loc9_ = this._displayIdx++;
                     this._displayList[_loc9_] = _loc7_;
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      private function creatLevel() : void
      {
         var _loc1_:* = undefined;
         if(this._info.CategoryID == 50 || this._info.CategoryID == 51 || this._info.CategoryID == 52)
         {
            this._levelTxt.text = LanguageMgr.GetTranslation("ddt.petEquipLevel",this._info.Property2);
            _loc1_ = this._displayIdx++;
            this._displayList[_loc1_] = this._levelTxt;
         }
      }
      
      private function createSingleHole(param1:InventoryItemInfo, param2:int, param3:int, param4:int) : FilterFrameText
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:int = 0;
         var _loc7_:FilterFrameText = this._holes[param2];
         var _loc8_:int = this.getHole(param1,param2 + 1);
         if(param1.StrengthenLevel >= param3)
         {
            if(_loc8_ <= 0)
            {
               _loc7_.text = this.getHoleType(param4) + ":" + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeenable");
               _loc7_.textColor = ITEM_HOLES_COLOR;
            }
            else
            {
               _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
               if(Boolean(_loc5_))
               {
                  _loc7_.text = _loc5_.Data;
                  _loc7_.textColor = ITEM_HOLE_RESERVE_COLOR;
               }
            }
         }
         else if(param2 >= 4)
         {
            _loc6_ = int(param1["Hole" + (param2 + 1) + "Level"]);
            if(_loc8_ > 0)
            {
               _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
               _loc7_.text = _loc5_.Data + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]);
               if(Math.floor(_loc5_.Level + 1 >> 1) <= _loc6_)
               {
                  _loc7_.textColor = ITEM_HOLE_RESERVE_COLOR;
               }
               else
               {
                  _loc7_.textColor = ITEM_HOLE_GREY_COLOR;
               }
            }
            else
            {
               _loc7_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holeLv",param1["Hole" + (param2 + 1) + "Level"]));
               _loc7_.textColor = ITEM_HOLES_COLOR;
            }
         }
         else if(_loc8_ <= 0)
         {
            _loc7_.text = this.getHoleType(param4) + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
            _loc7_.textColor = ITEM_HOLE_GREY_COLOR;
         }
         else
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc8_);
            if(Boolean(_loc5_))
            {
               _loc7_.text = _loc5_.Data + StringHelper.format(LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.holerequire"),param3.toString());
               _loc7_.textColor = ITEM_HOLE_GREY_COLOR;
            }
         }
         return _loc7_;
      }
      
      public function getHole(param1:InventoryItemInfo, param2:int) : int
      {
         return int(param1["Hole" + param2.toString()]);
      }
      
      private function getHoleType(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.trianglehole");
            case 2:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.recthole");
            case 3:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.ciclehole");
            default:
               return LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.unknowhole");
         }
      }
      
      private function createOperationItem() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:uint = 0;
         if(this._info.NeedLevel > 1)
         {
            if(PlayerManager.Instance.Self.Grade >= this._info.NeedLevel)
            {
               _loc1_ = ITEM_NEED_LEVEL_COLOR;
            }
            else
            {
               _loc1_ = ITEM_NEED_LEVEL_FAILED_COLOR;
            }
            this._needLevelTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.need") + ":" + String(this._info.NeedLevel);
            this._needLevelTxt.textColor = _loc1_;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needLevelTxt;
         }
         if(this._info.NeedSex == 1)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.man");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? uint(ITEM_NEED_SEX_COLOR) : uint(ITEM_NEED_SEX_FAILED_COLOR);
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         else if(this._info.NeedSex == 2)
         {
            this._needSexTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.woman");
            this._needSexTxt.textColor = PlayerManager.Instance.Self.Sex ? uint(ITEM_NEED_SEX_FAILED_COLOR) : uint(ITEM_NEED_SEX_COLOR);
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._needSexTxt;
         }
         var _loc2_:String = "";
         if(this._info.CanStrengthen && this._info.CanCompose)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.may");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanCompose)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.compose");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(this._info.CanStrengthen)
         {
            _loc2_ = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.strong");
            if(EquipType.isRongLing(this._info))
            {
               _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.melting");
            }
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
         else if(EquipType.isRongLing(this._info))
         {
            _loc2_ += LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.canmelting");
            this._upgradeType.text = _loc2_;
            this._upgradeType.textColor = ITEM_UPGRADE_TYPE_COLOR;
            _loc3_ = this._displayIdx++;
            this._displayList[_loc3_] = this._upgradeType;
         }
      }
      
      private function createDescript() : void
      {
         if(this._info.Description == "")
         {
            return;
         }
         this._descriptionTxt.text = this._info.Description;
         this._descriptionTxt.height = this._descriptionTxt.textHeight + 10;
         var _loc1_:* = this._displayIdx++;
         this._displayList[_loc1_] = this._descriptionTxt;
      }
      
      private function ShowBound(param1:InventoryItemInfo) : Boolean
      {
         return param1.CategoryID != 32 && param1.CategoryID != 33 && param1.CategoryID != 36;
      }
      
      private function createBindType() : void
      {
         var _loc2_:* = undefined;
         if(SyahManager.Instance.inView)
         {
            return;
         }
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc1_) && Boolean(this.ShowBound(_loc1_)) && _loc1_.isShowBind)
         {
            if(_loc1_.IsVisleBound == true)
            {
               this._boundImage.setFrame(_loc1_.IsBinds ? int(BOUND) : int(UNBOUND));
               PositionUtils.setPos(this._boundImage,this._bindImageOriginalPos);
               addChild(this._boundImage);
            }
            if(!_loc1_.IsBinds)
            {
               if(_loc1_.BindType == 3)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.bangding");
                  this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc2_ = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 2)
               {
                  this._bindTypeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.zhuangbei");
                  this._bindTypeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc2_ = this._displayIdx++;
                  this._displayList[_loc2_] = this._bindTypeTxt;
               }
               else if(this._info.BindType == 4)
               {
                  if(Boolean(this._boundImage.parent))
                  {
                     this._boundImage.parent.removeChild(this._boundImage);
                  }
               }
            }
         }
         else if(Boolean(this._boundImage.parent))
         {
            this._boundImage.parent.removeChild(this._boundImage);
         }
      }
      
      protected function createRemainTime() : void
      {
         var _loc7_:* = undefined;
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getRemainDate();
            _loc4_ = _loc2_.getColorValidDate();
            _loc5_ = _loc2_.CategoryID == EquipType.ARM ? LanguageMgr.GetTranslation("bag.changeColor.tips.armName") : "";
            if(_loc4_ > 0 && _loc4_ != int.MAX_VALUE)
            {
               if(_loc4_ >= 1)
               {
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + Math.ceil(_loc4_) + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               else
               {
                  _loc6_ = Math.floor(_loc4_ * 24);
                  if(_loc6_ < 1)
                  {
                     _loc6_ = 1;
                  }
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? LanguageMgr.GetTranslation("bag.changeColor.tips.name") + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + _loc6_ + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
            }
            if(_loc3_ == int.MAX_VALUE)
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.use");
               this._remainTimeTxt.textColor = ITEM_ETERNAL_COLOR;
               _loc7_ = this._displayIdx++;
               this._displayList[_loc7_] = this._remainTimeTxt;
            }
            else if(_loc3_ > 0)
            {
               if(_loc3_ > 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + "  " + _loc1_ + "  " + LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.day");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? Number(1) : Number(_loc1_);
                  this._remainTimeTxt.text = (_loc2_.IsUsed ? _loc5_ + LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.less") : LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.time")) + "  " + _loc1_ + "  " + LanguageMgr.GetTranslation("hours");
                  this._remainTimeTxt.textColor = ITEM_NORMAL_COLOR;
                  _loc7_ = this._displayIdx++;
                  this._displayList[_loc7_] = this._remainTimeTxt;
               }
               addChild(this._remainTimeBg);
            }
            else if(!isNaN(_loc3_))
            {
               this._remainTimeTxt.text = LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.over");
               this._remainTimeTxt.textColor = ITEM_PAST_DUE_COLOR;
               _loc7_ = this._displayIdx++;
               this._displayList[_loc7_] = this._remainTimeTxt;
            }
         }
      }
      
      private function createGoldRemainTime() : void
      {
         var _loc6_:* = undefined;
         var _loc1_:Number = NaN;
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(SyahManager.Instance.inView)
         {
            return;
         }
         if(Boolean(this._remainTimeBg.parent))
         {
            this._remainTimeBg.parent.removeChild(this._remainTimeBg);
         }
         if(this._info is InventoryItemInfo)
         {
            _loc2_ = this._info as InventoryItemInfo;
            _loc3_ = _loc2_.getGoldRemainDate();
            _loc4_ = _loc2_.goldValidDate;
            _loc5_ = _loc2_.goldBeginTime;
            if((this._info as InventoryItemInfo).isGold)
            {
               if(_loc3_ >= 1)
               {
                  _loc1_ = Math.ceil(_loc3_);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt2");
               }
               else
               {
                  _loc1_ = Math.floor(_loc3_ * 24);
                  _loc1_ = _loc1_ < 1 ? Number(1) : Number(_loc1_);
                  this._goldRemainTimeTxt.text = LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt1") + _loc1_ + LanguageMgr.GetTranslation("wishBead.GoodsTipPanel.txt3");
               }
               addChild(this._remainTimeBg);
               this._goldRemainTimeTxt.textColor = ITEM_NORMAL_COLOR;
               _loc6_ = this._displayIdx++;
               this._displayList[_loc6_] = this._goldRemainTimeTxt;
            }
         }
      }
      
      private function createFightPropConsume() : void
      {
         var _loc1_:* = undefined;
         if(this._info.CategoryID == EquipType.FRIGHTPROP)
         {
            this._fightPropConsumeTxt.text = " " + LanguageMgr.GetTranslation("tank.view.common.RoomIIPropTip.consume") + this._info.Property4;
            this._fightPropConsumeTxt.textColor = ITEM_FIGHT_PROP_CONSUME_COLOR;
            _loc1_ = this._displayIdx++;
            this._displayList[_loc1_] = this._fightPropConsumeTxt;
         }
      }
      
      private function createBoxTimeItem() : void
      {
         var _loc5_:* = undefined;
         var _loc1_:Date = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(EquipType.isTimeBox(this._info))
         {
            _loc1_ = DateUtils.getDateByStr((this._info as InventoryItemInfo).BeginDate);
            _loc2_ = int(this._info.Property3) * 60 - (TimeManager.Instance.Now().getTime() - _loc1_.getTime()) / 1000;
            if(_loc2_ > 0)
            {
               _loc3_ = _loc2_ / 3600;
               _loc4_ = _loc2_ % 3600 / 60;
               _loc4_ = _loc4_ > 0 ? int(_loc4_) : int(1);
               this._boxTimeTxt.text = LanguageMgr.GetTranslation("ddt.userGuild.boxTip",_loc3_,_loc4_);
               this._boxTimeTxt.textColor = ITEM_NORMAL_COLOR;
               _loc5_ = this._displayIdx++;
               this._displayList[_loc5_] = this._boxTimeTxt;
            }
         }
      }
      
      private function createStrenthLevel() : void
      {
         var _loc1_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(Boolean(_loc1_) && _loc1_.StrengthenLevel > 0)
         {
            if(_loc1_.isGold)
            {
               this._strengthenLevelImage.setFrame(16);
            }
            else
            {
               this._strengthenLevelImage.setFrame(_loc1_.StrengthenLevel);
            }
            addChild(this._strengthenLevelImage);
            if(Boolean(this._boundImage.parent))
            {
               this._boundImage.x = this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth / 2 - this._boundImage.width / 2;
               this._boundImage.y = this._lines[0].y + 4;
            }
            this._maxWidth = Math.max(this._strengthenLevelImage.x + this._strengthenLevelImage.displayWidth,this._maxWidth);
            _width = _tipbackgound.width = this._maxWidth + 8;
            if(Boolean(this._ghostStartsContainer))
            {
               this._ghostStartsContainer.x = this._strengthenLevelImage.x + (this._strengthenLevelImage.displayWidth - this._ghostStartsContainer.width >> 1) - 23;
               this._autoGhostWidth = this._ghostStartsContainer.x + this._ghostStartsContainer.width;
            }
         }
      }
      
      protected function seperateLine() : void
      {
         var _loc1_:Image = null;
         ++this._lineIdx;
         if(this._lines.length < this._lineIdx)
         {
            _loc1_ = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._lines.push(_loc1_);
         }
         var _loc2_:* = this._displayIdx++;
         this._displayList[_loc2_] = this._lines[this._lineIdx - 1];
      }
      
      private function creatGemstone() : void
      {
         var _loc9_:* = undefined;
         if(!PathManager.GemStoneEnable)
         {
            return;
         }
         var _loc1_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:FilterFrameText = null;
         var _loc4_:GemstonTipItem = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         if(this._info is InventoryItemInfo)
         {
            _loc1_ = this._info as InventoryItemInfo;
            if(Boolean(_loc1_.gemstoneList))
            {
               if(_loc1_.gemstoneList.length == 0)
               {
                  return;
               }
               _loc2_ = 0;
               while(_loc2_ < 3)
               {
                  if(_loc1_.gemstoneList[_loc2_].level > 0)
                  {
                     _loc3_ = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxtString");
                     _loc4_ = new GemstonTipItem();
                     _loc9_ = this._displayIdx++;
                     this._displayList[_loc9_] = _loc4_;
                     _loc5_ = _loc1_.gemstoneList[_loc2_].level;
                     if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100001)
                     {
                        _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",_loc5_,GemstoneManager.Instance.redInfoList[_loc5_].attack);
                        _loc7_ = GemstoneManager.Instance.redInfoList[_loc5_].attack;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100002)
                     {
                        _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",_loc5_,GemstoneManager.Instance.bluInfoList[_loc5_].defence);
                        _loc7_ = GemstoneManager.Instance.bluInfoList[_loc5_].defence;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100003)
                     {
                        _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",_loc5_,GemstoneManager.Instance.greInfoList[_loc5_].agility);
                        _loc7_ = GemstoneManager.Instance.greInfoList[_loc5_].agility;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100004)
                     {
                        _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",_loc5_,GemstoneManager.Instance.yelInfoList[_loc5_].luck);
                        _loc7_ = GemstoneManager.Instance.yelInfoList[_loc5_].luck;
                     }
                     else if(_loc1_.gemstoneList[_loc2_].fightSpiritId == 100005)
                     {
                        _loc6_ = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",_loc5_,GemstoneManager.Instance.purpleInfoList[_loc5_].blood);
                        _loc7_ = GemstoneManager.Instance.purpleInfoList[_loc5_].blood;
                     }
                     _loc8_ = new Object();
                     _loc8_.id = _loc1_.gemstoneList[_loc2_].fightSpiritId;
                     _loc8_.str = _loc6_;
                     _loc4_.setInfo(_loc8_);
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      private function showSyahTip() : void
      {
         var _loc1_:Point = null;
         if(Boolean(SyahManager.Instance.getSyahModeByInfo(_tipData.itemInfo)))
         {
            this.syahTip = new SyahTip();
            this.syahTip.setTipInfo(_tipData.itemInfo);
            if(this._laterEquipmentGoodView.visible)
            {
               this.syahTip.setBGWidth(this._laterEquipmentGoodView.getBGWidth());
               this.syahTip.x = this._laterEquipmentGoodView.x;
               this.syahTip.y = this._laterEquipmentGoodView.y - this.syahTip.displayHeight;
               if(this.syahTip.y + this.y < 5)
               {
                  this.syahTip.y = 0;
                  this._laterEquipmentGoodView.y = this.syahTip.displayHeight;
               }
            }
            else
            {
               this.syahTip.setBGWidth(228);
               _loc1_ = localToGlobal(new Point(_tipbackgound.x,_tipbackgound.y));
               if(_loc1_.x + _tipbackgound.width + this.syahTip.displayWidth < StageReferance.stageWidth)
               {
                  this.syahTip.x = _width + 5;
               }
               else
               {
                  this.syahTip.x = -250;
               }
               this.syahTip.y = _tipbackgound.height - this.syahTip.displayHeight;
            }
            addChild(this.syahTip);
         }
      }
      
      private function createAvatarState() : void
      {
         if(!PathManager.AvatarCollEnable)
         {
            return;
         }
         var _loc1_:* = null;
         if(this._info != null)
         {
            if(AvatarCollectionManager.instance.isCollectionGoodsByTemplateID(this._info.TemplateID))
            {
               _loc1_ = LanguageMgr.GetTranslation("ddt.goodsTip.avatarState").split(",");
               if(GypsyShopManager.getInstance().isAvatarActivated(this._info.TemplateID))
               {
                  this._avatarTxt.htmlText = _loc1_[0];
               }
               else
               {
                  this._avatarTxt.htmlText = _loc1_[1];
               }
               this._displayList[this._displayIdx++] = this._avatarTxt;
            }
         }
      }
      
      protected function cantAddPrice() : void
      {
      }
      
      private function getGhostPropertyData() : GhostPropertyData
      {
         var _loc1_:GhostPropertyData = null;
         var _loc2_:InventoryItemInfo = this._info as InventoryItemInfo;
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:PlayerInfo = PlayerInfoViewControl.currentPlayer || PlayerManager.Instance.Self;
         var _loc4_:* = _loc3_.ID != PlayerManager.Instance.Self.ID;
         var _loc5_:Boolean = _loc2_.BagType == 0 && _loc2_.Place <= 30;
         if(Boolean(_loc4_))
         {
            _loc1_ = _loc5_ ? EquipGhostManager.getInstance().getPorpertyData(_loc2_,_loc3_) : null;
         }
         else
         {
            _loc1_ = _loc2_.fromBag && (_loc5_ || EquipGhostManager.getInstance().isEquipGhosting()) ? EquipGhostManager.getInstance().getPorpertyData(_loc2_,_loc3_) : null;
         }
         return _loc1_;
      }
   }
}

