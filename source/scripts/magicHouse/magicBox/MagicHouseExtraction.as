package magicHouse.magicBox
{
   import bagAndInfo.bag.RichesButton;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CellEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import magicHouse.MagicBoxExtractionDragInArea;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseModel;
   import road7th.data.DictionaryData;
   import store.events.StoreDargEvent;
   import store.view.storeBag.StoreBagCell;
   import store.view.storeBag.StoreBagListView;
   import store.view.storeBag.StoreBagbgbmp;
   
   public class MagicHouseExtraction extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _selfEliteCounts:Bitmap;
      
      private var _selfEliteCountsTxt:FilterFrameText;
      
      private var _selfEliteCountsTxt2:FilterFrameText;
      
      private var _cellContentBg:Bitmap;
      
      private var _getCountBg:Bitmap;
      
      private var _getCounts:Bitmap;
      
      private var _getCountsTxt:FilterFrameText;
      
      private var _tempTxt:FilterFrameText;
      
      private var _extractionBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _equipListView:StoreBagListView;
      
      private var _propListView:StoreBagListView;
      
      private var _equipmentTitleText:FilterFrameText;
      
      private var _equipmentTipText:FilterFrameText;
      
      private var _itemTitleText:FilterFrameText;
      
      private var _itemTipText:FilterFrameText;
      
      private var _bitmapBg:StoreBagbgbmp;
      
      private var bagBg:ScaleFrameImage;
      
      private var moneyTxt:FilterFrameText;
      
      private var giftTxt:FilterFrameText;
      
      private var goldTxt:FilterFrameText;
      
      private var _goldButton:RichesButton;
      
      private var _giftButton:RichesButton;
      
      private var _moneyButton:RichesButton;
      
      private var _extractionCell:MagicBoxExtractionCell;
      
      private var _area:MagicBoxExtractionDragInArea;
      
      private var _extractionMc:MovieClip;
      
      private var _numBox:HBox;
      
      private var _mashArea:MagicBoxMashArea;
      
      private var _aler:MagicBoxExtractionSelectedNumAlertFrame;
      
      public function MagicHouseExtraction()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.view.bg");
         PositionUtils.setPos(this._bg,"magicHouse.magicbox.extractionviewbgPos");
         addChild(this._bg);
         this._selfEliteCounts = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.selfelitecounttxt");
         addChild(this._selfEliteCounts);
         this._selfEliteCountsTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.magicbox.selfEliteCountsTxt");
         addChild(this._selfEliteCountsTxt);
         this._selfEliteCountsTxt2 = ComponentFactory.Instance.creatComponentByStylename("magichouse.magicbox.selfEliteCountsTxt");
         addChild(this._selfEliteCountsTxt2);
         this._cellContentBg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.extractioncellcontent.bg");
         addChild(this._cellContentBg);
         this._getCountBg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.getelitebg");
         addChild(this._getCountBg);
         this._getCounts = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.getelitetxt");
         addChild(this._getCounts);
         this._getCountsTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.magicbox.getCountsTxt");
         addChild(this._getCountsTxt);
         this._tempTxt = ComponentFactory.Instance.creatComponentByStylename("magichouse.magicbox.tempTxt");
         this._tempTxt.text = LanguageMgr.GetTranslation("magichouse.magicboxView.extractiontTipTxt");
         addChild(this._tempTxt);
         this._extractionBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.magicbox.extractionBtn");
         addChild(this._extractionBtn);
         this._bitmapBg = new StoreBagbgbmp();
         PositionUtils.setPos(this._bitmapBg,"magicHouse.magicbox.storebagbgPos");
         addChild(this._bitmapBg);
         this.bagBg = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagViewBg2");
         addChild(this.bagBg);
         this._equipListView = ComponentFactory.Instance.creatCustomObject("magicbox.extractionviewEquiplistPos");
         this._equipListView.setup(0,null,21);
         addChild(this._equipListView);
         this._propListView = ComponentFactory.Instance.creatCustomObject("magicbox.extractionviewProplistPos");
         this._propListView.setup(1,null,21);
         addChild(this._propListView);
         this._equipmentTitleText = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.EquipmentTitleText");
         this._equipmentTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.EquipmentTitleText");
         this._equipmentTipText = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.EquipmentTipText");
         this._equipmentTipText.text = LanguageMgr.GetTranslation("magichouse.magicboxView.extractionDoubleClickTxt1");
         this._itemTitleText = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.ItemTitleText");
         this._itemTitleText.text = LanguageMgr.GetTranslation("store.StoreBagView.ItemTitleText");
         this._itemTipText = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.ItemTipText");
         this._itemTipText.text = LanguageMgr.GetTranslation("magichouse.magicboxView.extractionDoubleClickTxt2");
         addChild(this._equipmentTitleText);
         addChild(this._itemTitleText);
         addChild(this._equipmentTipText);
         addChild(this._itemTipText);
         var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.MoneyPanelBg");
         addChild(_loc1_);
         this.moneyTxt = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.TicketText");
         addChild(this.moneyTxt);
         this.giftTxt = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.GiftText");
         addChild(this.giftTxt);
         this.goldTxt = ComponentFactory.Instance.creatComponentByStylename("magicbox.StoreBagView.GoldText");
         addChild(this.goldTxt);
         this._goldButton = ComponentFactory.Instance.creatCustomObject("magicbox.StoreBagView.GoldButton");
         this._goldButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GoldDirections");
         addChild(this._goldButton);
         this._giftButton = ComponentFactory.Instance.creatCustomObject("magicbox.StoreBagView.GiftButton");
         var _loc2_:int = ServerConfigManager.instance.getBindBidLimit(PlayerManager.Instance.Self.Grade,PlayerManager.Instance.Self.VIPLevel);
         this._giftButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.GiftDirections",_loc2_.toString());
         addChild(this._giftButton);
         this._moneyButton = ComponentFactory.Instance.creatCustomObject("magicbox.StoreBagView.MoneyButton");
         this._moneyButton.tipData = LanguageMgr.GetTranslation("tank.view.bagII.MoneyDirections");
         addChild(this._moneyButton);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.helpBtn");
         PositionUtils.setPos(this._helpBtn,"magicHouse.magicbox.helpbtnPos");
         addChild(this._helpBtn);
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
         _loc3_.addChild(_loc4_);
         this._extractionCell = new MagicBoxExtractionCell(_loc3_,1);
         addChild(this._extractionCell);
         PositionUtils.setPos(this._extractionCell,"magicbox.extractionview.extractioncellPos");
         this._extractionCell.setContentSize(72,72);
         this._extractionCell.PicPos = new Point(-3,-3);
         this._numBox = ComponentFactory.Instance.creatComponentByStylename("magicbox.extractionview.numMc.Hbox");
         addChild(this._numBox);
         this._area = new MagicBoxExtractionDragInArea(this._extractionCell);
         this._area.x = 22;
         this._area.y = 54;
         addChildAt(this._area,0);
         this.refreshEquipPropList();
         this.refreshTxtData();
         this._selfEliteCountsTxt2.text = PlayerManager.Instance.Self.essence.toString();
         this._selfEliteCountsTxt.text = PlayerManager.Instance.Self.essence.toString();
      }
      
      private function initEvent() : void
      {
         MagicHouseManager.instance.addEventListener("magichouse_updata",this.__messageUpdate);
         MagicHouseManager.instance.addEventListener("magicbox_extraction_complete",this.__fusionComplete);
         PlayerManager.Instance.Self.StoreBag.addEventListener("update",this.__updateStoreBag);
         PlayerManager.Instance.Self.PropBag.addEventListener("update",this.__updateBag);
         PlayerManager.Instance.Self.Bag.addEventListener("update",this.__updateBag);
         this._extractionBtn.addEventListener("click",this.__extractionBtnHandler);
         this._equipListView.addEventListener("itemclick",this.__cellClick);
         this._propListView.addEventListener("itemclick",this.__cellClick);
         addEventListener("doubleclick",this.__cellDoubleClick);
         addEventListener("startDarg",this.startShine);
         addEventListener("stopDarg",this.stopShine);
         this._extractionCell.addEventListener("change",this.__itemInfoChange);
         this._helpBtn.addEventListener("click",this.__helpClick);
      }
      
      private function removeEvent() : void
      {
         MagicHouseManager.instance.removeEventListener("magichouse_updata",this.__messageUpdate);
         MagicHouseManager.instance.removeEventListener("magicbox_extraction_complete",this.__fusionComplete);
         PlayerManager.Instance.Self.StoreBag.removeEventListener("update",this.__updateStoreBag);
         PlayerManager.Instance.Self.PropBag.removeEventListener("update",this.__updateBag);
         PlayerManager.Instance.Self.Bag.removeEventListener("update",this.__updateBag);
         this._extractionBtn.removeEventListener("click",this.__extractionBtnHandler);
         this._equipListView.removeEventListener("itemclick",this.__cellClick);
         this._propListView.removeEventListener("itemclick",this.__cellClick);
         removeEventListener("doubleclick",this.__cellDoubleClick);
         removeEventListener("startDarg",this.startShine);
         removeEventListener("stopDarg",this.stopShine);
         this._extractionCell.removeEventListener("change",this.__itemInfoChange);
         this._helpBtn.removeEventListener("click",this.__helpClick);
         if(this.hasEventListener("enterFrame"))
         {
            removeEventListener("enterFrame",this.__numberMcProgress);
         }
      }
      
      private function __messageUpdate(param1:Event) : void
      {
         this.refreshTxtData();
      }
      
      private function __fusionComplete(param1:Event) : void
      {
         this._mashArea = new MagicBoxMashArea();
         LayerManager.Instance.addToLayer(this._mashArea,2);
         PositionUtils.setPos(this._mashArea,"magicbox.mashAreaPos");
         this._mashArea.addEventListener("click",this.__mashAreaClickHandler);
         InviteManager.Instance.enabled = false;
         this._extractionMc = ClassUtils.CreatInstance("magichouse.magicboxview.extractionComplete");
         PositionUtils.setPos(this._extractionMc,"magicbox.extractionview.extractionCompleteMcPos");
         addChild(this._extractionMc);
         this._extractionMc.gotoAndPlay(1);
         this._extractionMc.addEventListener("COMPLETE_EXTRACTION",this.__extractionMcComplete);
      }
      
      private function __extractionMcComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this._selfEliteCountsTxt2.visible = false;
         this._extractionMc.removeEventListener("COMPLETE_EXTRACTION",this.__extractionMcComplete);
         if(Boolean(this._extractionMc))
         {
            ObjectUtils.disposeObject(this._extractionMc);
            this._extractionMc = null;
         }
         this._extractionCell.info = null;
         _loc2_ = 0;
         while(_loc2_ < this._selfEliteCountsTxt.text.length)
         {
            _loc3_ = ClassUtils.CreatInstance("magicbox.extractionview.numMc");
            _loc3_.gotoAndPlay(this._selfEliteCountsTxt.text.charAt(_loc2_));
            this._numBox.addChild(_loc3_);
            _loc2_++;
         }
         addEventListener("enterFrame",this.__numberMcProgress);
      }
      
      private function __numberMcProgress(param1:Event) : void
      {
         if((this._numBox.getChildAt(this._numBox.numChildren - 1) as MovieClip).currentFrame >= 23)
         {
            this._selfEliteCountsTxt2.text = this._selfEliteCountsTxt.text;
            this._selfEliteCountsTxt.visible = true;
            this._selfEliteCountsTxt2.visible = true;
            this.refreshTxtData();
            this._numBox.removeAllChild();
            removeEventListener("enterFrame",this.__numberMcProgress);
            this._mashArea.removeEventListener("click",this.__mashAreaClickHandler);
            if(Boolean(this._mashArea.parent))
            {
               this._mashArea.parent.removeChild(this._mashArea);
               this._mashArea = null;
            }
            InviteManager.Instance.enabled = true;
         }
      }
      
      private function __mashAreaClickHandler(param1:MouseEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.magicboxView.inExtraction"));
      }
      
      private function __cellDoubleClick(param1:CellEvent) : void
      {
         param1.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            SoundManager.instance.play("008");
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BagCell = param1.data as StoreBagCell;
         this.dragDrop(_loc2_);
      }
      
      private function __extractionBtnHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(Boolean(this._extractionCell.info))
         {
            SocketManager.Instance.out.magicboxExtraction(this._extractionCell.info.TemplateID,1);
            this._selfEliteCountsTxt.visible = false;
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.magicboxView.extractionNoItem"));
         }
      }
      
      private function __cellClick(param1:CellEvent) : void
      {
         var _loc2_:* = null;
         param1.stopImmediatePropagation();
         var _loc3_:BagCell = param1.data as BagCell;
         if(Boolean(_loc3_))
         {
            _loc2_ = _loc3_.info as InventoryItemInfo;
         }
         if(_loc2_ == null)
         {
            return;
         }
         if(!_loc3_.locked)
         {
            SoundManager.instance.play("008");
            _loc3_.dragStart();
         }
      }
      
      private function startShine(param1:StoreDargEvent) : void
      {
      }
      
      private function stopShine(param1:StoreDargEvent) : void
      {
      }
      
      private function __itemInfoChange(param1:Event) : void
      {
      }
      
      private function _getItemInfoByCellInfo(param1:int = 1) : String
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         if(Boolean(this._extractionCell.info))
         {
            _loc2_ = MagicHouseModel.instance.itemExtrationEnableList;
            for each(_loc3_ in _loc2_)
            {
               if(this._extractionCell.info.TemplateID == _loc3_.ItemID)
               {
                  return (_loc3_.GetKeys * param1).toString();
               }
            }
         }
         return "0";
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("magichouse.magicboxView.extractiontxt");
            this._helpFrame.addEventListener("response",this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("magichouse.magicbox.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener("click",this.__closeHelpFrame);
            this._helpFrame.addToContent(this._bgHelp);
            this._helpFrame.addToContent(this._content);
            this._helpFrame.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,3,true,2);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            this._helpFrame.parent.removeChild(this._helpFrame);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._helpFrame.parent.removeChild(this._helpFrame);
      }
      
      public function refreshEquipPropList() : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:BagInfo = PlayerManager.Instance.Self.getBag(0);
         var _loc4_:BagInfo = PlayerManager.Instance.Self.getBag(1);
         var _loc5_:Array = MagicHouseModel.instance.itemExtrationEnableList;
         var _loc6_:DictionaryData = new DictionaryData();
         var _loc7_:DictionaryData = new DictionaryData();
         for each(_loc8_ in _loc5_)
         {
            _loc1_ = _loc3_.findItemsByTempleteIDNoValidate(_loc8_.ItemID);
            _loc2_ = _loc4_.findItemsByTempleteIDNoValidate(_loc8_.ItemID);
            if(_loc1_.length > 0)
            {
               for each(_loc9_ in _loc1_)
               {
                  _loc6_.add(_loc6_.length,_loc9_);
               }
            }
            if(_loc2_.length > 0)
            {
               for each(_loc10_ in _loc2_)
               {
                  _loc7_.add(_loc7_.length,_loc10_);
               }
            }
         }
         this._equipListView.setData(_loc6_);
         this._propListView.setData(_loc7_);
      }
      
      private function refreshTxtData() : void
      {
         this._selfEliteCountsTxt.text = PlayerManager.Instance.Self.essence.toString();
         this._selfEliteCountsTxt2.text = PlayerManager.Instance.Self.essence.toString();
         this.moneyTxt.text = PlayerManager.Instance.Self.Money.toString();
         this.giftTxt.text = PlayerManager.Instance.Self.BandMoney.toString();
         this.goldTxt.text = PlayerManager.Instance.Self.Gold.toString();
         this._getCountsTxt.text = "0";
      }
      
      private function dragDrop(param1:BagCell) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         if(_loc2_.Count == 1)
         {
            SocketManager.Instance.out.sendMoveGoods(_loc2_.BagType,_loc2_.Place,12,1,1);
         }
         else
         {
            this.showNumAlert(_loc2_,1);
         }
      }
      
      private function showNumAlert(param1:InventoryItemInfo, param2:int) : void
      {
         this._aler = ComponentFactory.Instance.creatComponentByStylename("magicbox.selectNumAlertFrame");
         this._aler.addExeFunction(this.sellFunction,this.notSellFunction);
         this._aler.goodsinfo = param1;
         this._aler.index = param2;
         this._aler.show(param1.Count);
      }
      
      private function sellFunction(param1:int, param2:InventoryItemInfo, param3:int) : void
      {
         SocketManager.Instance.out.sendMoveGoods(param2.BagType,param2.Place,12,param3,param1,true);
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function notSellFunction() : void
      {
         if(Boolean(this._aler))
         {
            this._aler.dispose();
         }
         if(Boolean(this._aler) && Boolean(this._aler.parent))
         {
            removeChild(this._aler);
         }
         this._aler = null;
      }
      
      private function __updateStoreBag(param1:BagEvent) : void
      {
         this._refreshData(param1.changedSlots);
      }
      
      private function __updateBag(param1:BagEvent) : void
      {
         this._refreshData(param1.changedSlots);
      }
      
      private function _refreshData(param1:Dictionary) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = null;
         this._deleteExtractionCell();
         this.refreshEquipPropList();
         for(_loc2_ in param1)
         {
            _loc3_ = PlayerManager.Instance.Self.StoreBag.items[_loc2_];
            this._createExtractionCell(_loc3_);
         }
      }
      
      private function _createExtractionCell(param1:InventoryItemInfo) : void
      {
         this._extractionCell.info = param1;
         if(Boolean(param1))
         {
            this._getCountsTxt.text = this._getItemInfoByCellInfo(param1.Count);
         }
         else
         {
            this._getCountsTxt.text = "0";
         }
      }
      
      private function _deleteExtractionCell() : void
      {
      }
      
      private function __extractionCellClickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         this._extractionCell.dragStart();
      }
      
      private function __extractionCellDoubleClickHandler(param1:InteractiveEvent) : void
      {
         SocketManager.Instance.out.sendClearStoreBag();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._deleteExtractionCell();
         SocketManager.Instance.out.sendClearStoreBag();
         if(Boolean(this._area))
         {
            ObjectUtils.disposeObject(this._area);
         }
         this._area = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._selfEliteCounts))
         {
            ObjectUtils.disposeObject(this._selfEliteCounts);
         }
         this._selfEliteCounts = null;
         if(Boolean(this._selfEliteCountsTxt))
         {
            ObjectUtils.disposeObject(this._selfEliteCountsTxt);
         }
         this._selfEliteCountsTxt = null;
         if(Boolean(this._selfEliteCountsTxt2))
         {
            ObjectUtils.disposeObject(this._selfEliteCountsTxt2);
         }
         this._selfEliteCountsTxt2 = null;
         if(Boolean(this._cellContentBg))
         {
            ObjectUtils.disposeObject(this._cellContentBg);
         }
         this._cellContentBg = null;
         if(Boolean(this._getCountBg))
         {
            ObjectUtils.disposeObject(this._getCountBg);
         }
         this._getCountBg = null;
         if(Boolean(this._getCounts))
         {
            ObjectUtils.disposeObject(this._getCounts);
         }
         this._getCounts = null;
         if(Boolean(this._getCountsTxt))
         {
            ObjectUtils.disposeObject(this._getCountsTxt);
         }
         this._getCountsTxt = null;
         if(Boolean(this._tempTxt))
         {
            ObjectUtils.disposeObject(this._tempTxt);
         }
         this._tempTxt = null;
         if(Boolean(this._extractionBtn))
         {
            ObjectUtils.disposeObject(this._extractionBtn);
         }
         this._extractionBtn = null;
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
         }
         this._helpBtn = null;
         if(Boolean(this._equipListView))
         {
            ObjectUtils.disposeObject(this._equipListView);
         }
         this._equipListView = null;
         if(Boolean(this._propListView))
         {
            ObjectUtils.disposeObject(this._propListView);
         }
         this._propListView = null;
         if(Boolean(this._bitmapBg))
         {
            ObjectUtils.disposeObject(this._bitmapBg);
         }
         this._bitmapBg = null;
         if(Boolean(this.bagBg))
         {
            ObjectUtils.disposeObject(this.bagBg);
         }
         this.bagBg = null;
         if(Boolean(this.moneyTxt))
         {
            ObjectUtils.disposeObject(this.moneyTxt);
         }
         this.moneyTxt = null;
         if(Boolean(this.giftTxt))
         {
            ObjectUtils.disposeObject(this.giftTxt);
         }
         this.giftTxt = null;
         if(Boolean(this.goldTxt))
         {
            ObjectUtils.disposeObject(this.goldTxt);
         }
         this.goldTxt = null;
         if(Boolean(this._equipmentTitleText))
         {
            ObjectUtils.disposeObject(this._equipmentTitleText);
         }
         this._equipmentTitleText = null;
         if(Boolean(this._equipmentTipText))
         {
            ObjectUtils.disposeObject(this._equipmentTipText);
         }
         this._equipmentTipText = null;
         if(Boolean(this._itemTitleText))
         {
            ObjectUtils.disposeObject(this._itemTitleText);
         }
         this._itemTitleText = null;
         if(Boolean(this._itemTipText))
         {
            ObjectUtils.disposeObject(this._itemTipText);
         }
         this._itemTipText = null;
         if(Boolean(this._goldButton))
         {
            ObjectUtils.disposeObject(this._goldButton);
         }
         this._goldButton = null;
         if(Boolean(this._giftButton))
         {
            ObjectUtils.disposeObject(this._giftButton);
         }
         this._giftButton = null;
         if(Boolean(this._moneyButton))
         {
            ObjectUtils.disposeObject(this._moneyButton);
         }
         this._moneyButton = null;
         if(Boolean(this._extractionMc))
         {
            ObjectUtils.disposeObject(this._extractionMc);
         }
         this._extractionMc = null;
         if(Boolean(this._mashArea))
         {
            ObjectUtils.disposeObject(this._mashArea);
         }
         this._mashArea = null;
      }
   }
}

