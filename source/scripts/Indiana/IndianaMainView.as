package Indiana
{
   import Indiana.analyzer.IndianaGoodsItemInfo;
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.item.GradientBitmapText;
   import Indiana.item.IndianaShowBuyCodeView;
   import Indiana.item.IndianaTitleCellView;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PkgEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import ddt.view.character.BaseWingLayer;
   import ddt.view.character.ILayer;
   import ddt.view.character.LayerFactory;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import pet.date.PetInfo;
   import petsBag.view.item.PetBigItem;
   import road.game.resource.ActionMovie;
   import road.game.resource.ActionMovieEvent;
   
   public class IndianaMainView extends Frame
   {
      
      private var _frameBg:Bitmap;
      
      private var _iconCon:Sprite;
      
      private var _itemName:GradientBitmapText;
      
      private var _helpBtn:BaseButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _itemDetails:SelectedButton;
      
      private var _itemRecode:SelectedButton;
      
      private var _itemHis:SelectedButton;
      
      private var _leftPageBtn:BaseButton;
      
      private var _rightPageBtn:BaseButton;
      
      private var _titleView:IndianaTitleCellView;
      
      private var _infoLogic:IndianaMainInfoLogic;
      
      private var _detaileView:IndianaDetaileView;
      
      private var _currentView:DisplayObject;
      
      private var _itemDis:GradientBitmapText;
      
      private var _itemValue:FilterFrameText;
      
      private var _itemDisII:FilterFrameText;
      
      private var _recodeView:IndianaRecodePanel;
      
      private var _historyView:HistoryofIndianaPanel;
      
      private var _info:Array;
      
      private var _petMovie:ActionMovie;
      
      private var _petItem:PetBigItem;
      
      private var _wing:MovieClip;
      
      private var _icon:Bitmap;
      
      private var _currentInfo:IndianaShopItemInfo;
      
      private var _buyCodeView:IndianaShowBuyCodeView;
      
      private var _loader:BitmapLoader;
      
      private var ACTIONS:Array = ["standA","walkA","walkB","hunger"];
      
      private var layer:ILayer;
      
      private var _lastTime:uint = 0;
      
      private var isFirst:Boolean = true;
      
      private var _currentPerodId:int;
      
      public function IndianaMainView()
      {
         super();
         this.initView();
         this.initEvent();
         InviteManager.Instance.enabled = false;
      }
      
      private function initView() : void
      {
         this._iconCon = new Sprite();
         this._iconCon.x = 169;
         this._iconCon.y = 208;
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"indiana.helpbtn",null,LanguageMgr.GetTranslation("Indiana.resoult.helpDis"),"assete.indiana.readMe",464,580);
         this._itemDis = new GradientBitmapText();
         this._itemDis.FilterTxtStyle = "indiana.gradient.Txt";
         this._itemDis.BitMapStyle = "asset.gradient.bg";
         PositionUtils.setPos(this._itemDis,"indiana.itemNameDis.pos");
         this._itemDisII = ComponentFactory.Instance.creatComponentByStylename("indiana.itemDis.Txt");
         this._itemValue = ComponentFactory.Instance.creatComponentByStylename("indiana.itemValue.Txt");
         this._itemName = new GradientBitmapText();
         this._itemName.FilterTxtStyle = "indiana.gradient.Txt";
         this._itemName.BitMapStyle = "asset.gradient.bg";
         PositionUtils.setPos(this._itemName,"indiana.itemNameDisII.pos");
         this._itemDetails = ComponentFactory.Instance.creatComponentByStylename("indiana.details.selectBtn");
         this._itemRecode = ComponentFactory.Instance.creatComponentByStylename("indiana.recode.selectBtn");
         this._itemHis = ComponentFactory.Instance.creatComponentByStylename("indiana.history.selectBtn");
         this._leftPageBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.leftpagebtn");
         this._rightPageBtn = ComponentFactory.Instance.creatComponentByStylename("indiana.rigthpagebtn");
         this._info = IndianaDataManager.instance.getShopItem();
         this._titleView = new IndianaTitleCellView();
         this._titleView.setInfos(this._info);
         PositionUtils.setPos(this._titleView,"itemTitleView.pos");
         this._infoLogic = new IndianaMainInfoLogic();
         PositionUtils.setPos(this._infoLogic,"infologic.pos");
         this._currentInfo = IndianaDataManager.instance.getCurrentShopItem;
         addToContent(this._iconCon);
         addToContent(this._helpBtn);
         addToContent(this._itemName);
         addToContent(this._itemDetails);
         addToContent(this._itemRecode);
         addToContent(this._itemHis);
         addToContent(this._leftPageBtn);
         addToContent(this._rightPageBtn);
         addToContent(this._titleView);
         addToContent(this._infoLogic);
         addToContent(this._itemValue);
         addToContent(this._itemDis);
         addToContent(this._itemDisII);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._itemDetails);
         this._btnGroup.addSelectItem(this._itemRecode);
         this._btnGroup.addSelectItem(this._itemHis);
         this._btnGroup.addEventListener("change",this.__changeHandler);
         this._btnGroup.selectIndex = 0;
      }
      
      private function clearIcon() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._petItem))
         {
            if(Boolean(this._petItem.parent))
            {
               this._petItem.parent.removeChild(this._petItem);
            }
            ObjectUtils.disposeObject(this._petItem);
            this._petItem = null;
         }
         if(Boolean(this.layer))
         {
            ObjectUtils.disposeObject(this.layer);
            this.layer = null;
         }
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(Boolean(this._iconCon))
         {
            while(this._iconCon.numChildren > 0)
            {
               _loc1_ = this._iconCon.removeChildAt(0);
               ObjectUtils.disposeObject(_loc1_);
               _loc1_ = null;
            }
         }
      }
      
      private function setIcon(param1:IndianaShopItemInfo) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:IndianaGoodsItemInfo = IndianaDataManager.instance.getIndianaGoodsItemInfoByshopId(param1.ShopId);
         this.clearIcon();
         if(_loc8_.GoodType == 2)
         {
            _loc3_ = int(_loc8_.Remark.split("|")[0]);
            _loc4_ = ItemManager.Instance.getTemplateById(_loc8_.GoodsID);
            _loc5_ = PetInfoManager.getPetByTemplateID(_loc3_);
            if(Boolean(_loc5_))
            {
               _loc6_ = new PetInfo();
               ObjectUtils.copyProperties(_loc6_,_loc5_);
               if(this._petItem == null)
               {
                  this._petItem = new PetBigItem();
                  PositionUtils.setPos(this._petItem,"indiana.petMv.pos");
                  this._iconCon.addChild(this._petItem);
               }
               this._petItem.info = _loc6_;
            }
         }
         else if(_loc8_.GoodType == 4)
         {
            if(Boolean(this._wing))
            {
               if(Boolean(this._wing.parent))
               {
                  this._wing.parent.removeChild(this._wing);
               }
               this._wing = null;
            }
            _loc2_ = IndianaDataManager.instance.getTemplatesByShopId(param1.ShopId);
            this.layer = LayerFactory.instance.createLayer(_loc2_,PlayerManager.Instance.Self.Sex,"","show");
            this.layer.load(this.__wingOnComplete);
         }
         else
         {
            _loc7_ = PathManager.solvePath(_loc8_.ResourcePath) + ".png";
            this._loader = LoadResourceManager.Instance.createLoader(_loc7_,0);
            this._loader.addEventListener("complete",this.__bitmapOnComplete);
            LoadResourceManager.Instance.startLoad(this._loader);
         }
      }
      
      private function setTitleInfo(param1:IndianaShopItemInfo) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         _loc3_ = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(Boolean(param1))
         {
            _loc2_ = IndianaDataManager.instance.getTemplatesByShopId(param1.ShopId);
            _loc3_ = IndianaDataManager.instance.getIndianaGoodsItemInfoByshopId(param1.ShopId);
            _loc5_ = _loc3_.Publicity;
            _loc4_ = _loc3_.Name + "," + _loc5_;
            _loc4_ = _loc4_.length > 13 ? _loc4_.substr(0,13) : _loc4_;
            this._itemDis.setText(_loc4_);
            this._itemDisII.text = LanguageMgr.GetTranslation("Indiana.main.perNum",param1.PeriodName);
            this._itemDisII.x = this._itemDis.x + this._itemDis.textWidth + 10;
            this._itemValue.text = LanguageMgr.GetTranslation("Indiana.item.value",_loc3_.Cost);
            this._itemName.setText(LanguageMgr.GetTranslation("Indiana.item.order",param1.Order));
            this._titleView.updateCurrentCell(param1.PeriodId);
            this.setIcon(param1);
         }
      }
      
      private function __bitmapOnComplete(param1:LoaderEvent) : void
      {
         this._icon = param1.loader.content as Bitmap;
         this._icon.x = -51;
         this._icon.y = -74;
         this._iconCon.addChild(this._icon);
         this.clearLoader();
      }
      
      private function __wingOnComplete(param1:BaseWingLayer) : void
      {
         this.clearIcon();
         this._wing = param1.getContent() as MovieClip;
         this._wing.x = -20;
         this._wing.y = -61;
         this._iconCon.addChild(this._wing);
      }
      
      private function __onComplete(param1:LoaderEvent) : void
      {
         var _loc2_:* = null;
         this._loader.removeEventListener("complete",this.__onComplete);
         if(ModuleLoader.hasDefinition("pet.asset.game." + this._info.GameAssetUrl))
         {
            _loc2_ = ModuleLoader.getDefinition("pet.asset.game." + this._info.GameAssetUrl) as Class;
            this._petMovie = new _loc2_();
            this._petMovie.mute();
            this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
            this._petMovie.addEventListener("actionEnd",this.doNextAction);
            addChild(this._petMovie);
         }
      }
      
      private function doNextAction(param1:ActionMovieEvent) : void
      {
         if(Boolean(this._petMovie))
         {
            if(getTimer() - this._lastTime > 40)
            {
               this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
            }
            this._lastTime = getTimer();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      public function upData() : void
      {
         if(Boolean(this._infoLogic))
         {
            this._infoLogic.upDate();
            this.__changeHandler(null);
            this.setTitleInfo(IndianaDataManager.instance.getCurrentShopItem);
         }
      }
      
      private function initEvent() : void
      {
         this._leftPageBtn.addEventListener("click",this.__leftClickHandler);
         this._rightPageBtn.addEventListener("click",this.__rightClickHandler);
         SocketManager.Instance.addEventListener(PkgEvent.format(385,IndianaEPackageType.CHECK_CODE),this.__checkCodeHandler);
      }
      
      private function __checkCodeHandler(param1:PkgEvent) : void
      {
         var _loc7_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc7_ = param1.pkg.readInt();
         if(_loc7_ > 0)
         {
            _loc2_ = [];
            _loc3_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc4_ = param1.pkg.readInt();
               _loc5_ = param1.pkg.readInt();
               _loc2_.push(_loc4_ + "|" + _loc5_);
               _loc6_++;
            }
            if(Boolean(this._buyCodeView))
            {
               ObjectUtils.disposeObject(this._buyCodeView);
               this._buyCodeView = null;
            }
            this._buyCodeView = new IndianaShowBuyCodeView(_loc2_);
            PositionUtils.setPos(this._buyCodeView,"indiana.buy.view.pos");
            addChild(this._buyCodeView);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("Indiana.message.nocode"));
         }
      }
      
      private function __leftClickHandler(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendUpdateSysDate();
         var _loc2_:int = this._titleView.leftCell.Info.PeriodId;
         SocketManager.Instance.out.sendIndianaEnterGame(_loc2_);
      }
      
      private function __rightClickHandler(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendUpdateSysDate();
         var _loc2_:int = this._titleView.rightCell.Info.PeriodId;
         SocketManager.Instance.out.sendIndianaEnterGame(_loc2_);
      }
      
      private function __changeHandler(param1:Event) : void
      {
         this._currentInfo = IndianaDataManager.instance.getCurrentShopItem;
         IndianaDataManager.instance.updataRecode = false;
         switch(int(this._btnGroup.selectIndex))
         {
            case 0:
               if(Boolean(this._currentView) && this._currentView != this._detaileView)
               {
                  this._currentView.visible = false;
               }
               if(this._detaileView == null)
               {
                  this._detaileView = new IndianaDetaileView();
                  addToContent(this._detaileView);
               }
               this._detaileView.setInfo(IndianaDataManager.instance.getCurrentShopItem);
               this._currentView = this._detaileView;
               this._detaileView.visible = true;
               break;
            case 1:
               IndianaDataManager.instance.updataRecode = true;
               if(this._currentPerodId != this._currentInfo.PeriodId)
               {
                  this._currentPerodId = this._currentInfo.PeriodId;
                  SocketManager.Instance.out.sendIndianaCurrentData(this._currentInfo.PeriodId);
               }
               if(Boolean(this._currentView) && this._currentView != this._recodeView)
               {
                  this._currentView.visible = false;
               }
               if(this._recodeView == null)
               {
                  this._recodeView = new IndianaRecodePanel();
                  addToContent(this._recodeView);
               }
               this._recodeView.visible = true;
               this._currentView = this._recodeView;
               break;
            case 2:
               if(this.isFirst)
               {
                  SocketManager.Instance.out.sendIndianaHistoryData();
                  this.isFirst = false;
               }
               if(Boolean(this._currentView) && this._currentView != this._historyView)
               {
                  this._currentView.visible = false;
               }
               if(this._historyView == null)
               {
                  this._historyView = new HistoryofIndianaPanel();
                  addToContent(this._historyView);
               }
               this._historyView.visible = true;
               this._currentView = this._historyView;
         }
      }
      
      private function clearLoader() : void
      {
         if(Boolean(this._loader))
         {
            this._loader.removeEventListener("complete",this.__bitmapOnComplete);
         }
         this._loader = null;
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.removeEventListener("change",this.__changeHandler);
         }
         if(Boolean(this._leftPageBtn))
         {
            this._leftPageBtn.removeEventListener("click",this.__leftClickHandler);
         }
         if(Boolean(this._rightPageBtn))
         {
            this._rightPageBtn.removeEventListener("click",this.__rightClickHandler);
         }
         SocketManager.Instance.removeEventListener(PkgEvent.format(385,IndianaEPackageType.CHECK_CODE),this.__checkCodeHandler);
      }
      
      override protected function onResponse(param1:int) : void
      {
         SoundManager.instance.play("008");
         IndianaDataManager.instance.disposeView();
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.clearLoader();
         InviteManager.Instance.enabled = true;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         if(Boolean(this._currentView))
         {
            ObjectUtils.disposeObject(this._currentView);
            this._currentView = null;
         }
         if(Boolean(this._detaileView))
         {
            ObjectUtils.disposeObject(this._detaileView);
            this._detaileView = null;
         }
         if(Boolean(this._leftPageBtn))
         {
            ObjectUtils.disposeObject(this._leftPageBtn);
            this._leftPageBtn = null;
         }
         if(Boolean(this._rightPageBtn))
         {
            ObjectUtils.disposeObject(this._rightPageBtn);
            this._rightPageBtn = null;
         }
         if(Boolean(this._titleView))
         {
            ObjectUtils.disposeObject(this._titleView);
            this._titleView = null;
         }
         if(Boolean(this._infoLogic))
         {
            ObjectUtils.disposeObject(this._infoLogic);
            this._infoLogic = null;
         }
         if(Boolean(this._itemValue))
         {
            ObjectUtils.disposeObject(this._itemValue);
            if(Boolean(this._itemValue))
            {
               ObjectUtils.disposeObject(this._itemValue);
               this._itemValue = null;
            }
         }
         this._itemDis = null;
         this._itemDisII = null;
         if(Boolean(this._btnGroup))
         {
            this._btnGroup.dispose();
            this._btnGroup = null;
         }
         if(Boolean(this._itemDetails))
         {
            ObjectUtils.disposeObject(this._itemDetails);
            this._itemDetails = null;
         }
         if(Boolean(this._itemRecode))
         {
            ObjectUtils.disposeObject(this._itemRecode);
            this._itemRecode = null;
         }
         if(Boolean(this._itemHis))
         {
            ObjectUtils.disposeObject(this._itemHis);
            this._itemHis = null;
         }
         if(Boolean(this._iconCon))
         {
            ObjectUtils.disposeObject(this._iconCon);
            this._iconCon = null;
         }
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
         }
         if(Boolean(this._itemName))
         {
            ObjectUtils.disposeObject(this._itemName);
            this._itemName = null;
         }
         if(Boolean(this._buyCodeView))
         {
            ObjectUtils.disposeObject(this._buyCodeView);
            this._buyCodeView = null;
         }
         super.dispose();
      }
   }
}

