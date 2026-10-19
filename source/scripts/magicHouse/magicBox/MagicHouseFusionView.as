package magicHouse.magicBox
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.InviteManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseModel;
   
   public class MagicHouseFusionView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _itemsContentBg:Bitmap;
      
      private var _fusionCellContentBg:Bitmap;
      
      private var _materialContentBg:Bitmap;
      
      private var _selfMoney:FilterFrameText;
      
      private var _selfElite:FilterFrameText;
      
      private var _itemCounts:FilterFrameText;
      
      private var _inputNumBg:Bitmap;
      
      private var _inputNumTxt:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var _curNum:int;
      
      private var _maxNum:int;
      
      private var _needElite:FilterFrameText;
      
      private var _eliteCounts:FilterFrameText;
      
      private var _needMoney:FilterFrameText;
      
      private var _moneyCounts:FilterFrameText;
      
      private var _fusionCheckBtn:SelectedCheckButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _fusionBtn:SimpleBitmapButton;
      
      private var _helpFrame:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _itemContents:VBox;
      
      private var _itemPanel:ScrollPanel;
      
      private var _itemInfoArr:Array;
      
      private var _itemArr:Array;
      
      private var _currentItem:MagicBoxFusionItem;
      
      private var _currentItemCell:BagCell;
      
      private var _materialArr:Array;
      
      private var _materialCountTxt1:FilterFrameText;
      
      private var _materialCountTxt2:FilterFrameText;
      
      private var _materialCountTxt3:FilterFrameText;
      
      private var _materialCountTxt4:FilterFrameText;
      
      private var _propBag:BagInfo = PlayerManager.Instance.Self.getBag(1);
      
      private var _isComposeEnable:Boolean = false;
      
      private var _fusionMc:MovieClip;
      
      private var _mashArea:MagicBoxMashArea;
      
      public function MagicHouseFusionView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         this._bg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.view.bg");
         PositionUtils.setPos(this._bg,"magicHouse.magicbox.fusionviewbgPos");
         addChild(this._bg);
         this._itemsContentBg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.itemcontent.bg");
         addChild(this._itemsContentBg);
         this._fusionCellContentBg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.fusioncellcontent.bg");
         addChild(this._fusionCellContentBg);
         this._materialContentBg = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.materialcontent.bg");
         addChild(this._materialContentBg);
         _loc1_ = 1;
         while(_loc1_ < 5)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.materialcellcontent.bg");
            PositionUtils.setPos(_loc2_,"magicbox.fusionview.materialcontentPos" + _loc1_);
            addChild(_loc2_);
            _loc1_++;
         }
         this._selfMoney = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.selfmoneyTxt");
         addChild(this._selfMoney);
         this._selfMoney.text = PlayerManager.Instance.Self.Gold.toString();
         this._selfElite = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.selfeliteTxt");
         addChild(this._selfElite);
         this._selfElite.text = PlayerManager.Instance.Self.essence + "";
         this._itemCounts = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.itemcountsTxt");
         this._itemCounts.text = LanguageMgr.GetTranslation("magichouse.magicboxView.fusionItemCounts");
         addChild(this._itemCounts);
         this._inputNumBg = ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.fusionitem.inputBg");
         this._inputNumTxt = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionview.inputTxt");
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionview.maxBtn");
         addChild(this._inputNumBg);
         addChild(this._inputNumTxt);
         addChild(this._maxBtn);
         this._needElite = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.needeliteTxt");
         this._needElite.text = LanguageMgr.GetTranslation("magichouse.magicboxView.fusionNeedElite");
         addChild(this._needElite);
         this._eliteCounts = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.eliteTxt");
         addChild(this._eliteCounts);
         this._needMoney = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.needmoneyTxt");
         this._needMoney.text = LanguageMgr.GetTranslation("magichouse.magicboxView.fusionNeedMoney");
         addChild(this._needMoney);
         this._moneyCounts = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.moneyTxt");
         addChild(this._moneyCounts);
         this._fusionCheckBtn = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionCheckBtn");
         this._fusionCheckBtn.text = LanguageMgr.GetTranslation("magichouse.magicboxView.fusionCheckBtnTxt");
         addChild(this._fusionCheckBtn);
         this._fusionBtn = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusion.fusionBtn");
         addChild(this._fusionBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("magicHouse.collectionMainView.helpBtn");
         PositionUtils.setPos(this._helpBtn,"magicHouse.magicbox.helpbtnPos");
         addChild(this._helpBtn);
         this._itemInfoArr = MagicHouseModel.instance.itemFusionEnableList;
         this._itemArr = [];
         this._itemContents = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionview.leftitem.Vbox");
         this._itemPanel = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionview.leftitemList");
         this._itemPanel.setView(this._itemContents);
         addChild(this._itemPanel);
         _loc3_ = 0;
         while(_loc3_ < this._itemInfoArr.length)
         {
            _loc4_ = new MagicBoxFusionItem();
            this._itemContents.addChild(_loc4_);
            _loc4_.setItemData(this._itemInfoArr[_loc3_]);
            _loc4_.buttonMode = true;
            _loc4_.addEventListener("click",this.__itemClickHandler);
            this._itemArr.push(_loc4_);
            if(_loc3_ == 0)
            {
               this._currentItem = _loc4_;
               _loc4_.setItemShine(true);
            }
            _loc3_++;
         }
         this._itemPanel.invalidateViewport();
         this._materialCountTxt1 = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.materialCountTxt1");
         this._materialCountTxt2 = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.materialCountTxt2");
         this._materialCountTxt3 = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.materialCountTxt3");
         this._materialCountTxt4 = ComponentFactory.Instance.creatComponentByStylename("magicbox.fusionView.materialCountTxt4");
         addChild(this._materialCountTxt1);
         addChild(this._materialCountTxt2);
         addChild(this._materialCountTxt3);
         addChild(this._materialCountTxt4);
         this._changeRightView();
      }
      
      private function __itemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._itemArr)
         {
            _loc2_.setItemShine(false);
         }
         this._currentItem = param1.currentTarget as MagicBoxFusionItem;
         this._currentItem.setItemShine(true);
         this._changeRightView();
      }
      
      private function _changeRightView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:* = null;
         var _loc12_:* = null;
         var _loc13_:int = 0;
         var _loc14_:int = -1;
         var _loc15_:int = -1;
         var _loc16_:int = -1;
         var _loc17_:int = -1;
         var _loc18_:int = -1;
         var _loc19_:int = -1;
         this._curNum = 0;
         this._maxNum = 9999;
         var _loc20_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._currentItem.info.ItemID);
         if(Boolean(this._currentItemCell))
         {
            this._currentItemCell.dispose();
         }
         this._currentItemCell = new BagCell(0,_loc20_,true,ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.fusionitemcell.bg"));
         addChild(this._currentItemCell);
         this._currentItemCell.width = this._currentItemCell.height = 70;
         PositionUtils.setPos(this._currentItemCell,"magicbox.fusionview.fusionItemCellPos");
         if(!this._materialArr)
         {
            this._materialArr = [];
         }
         _loc1_ = 0;
         while(_loc1_ < this._materialArr.length)
         {
            removeChild(this._materialArr[0]);
            this._materialArr.shift();
         }
         this._materialCountTxt1.text = this._materialCountTxt2.text = this._materialCountTxt3.text = this._materialCountTxt4.text = "";
         if(this._currentItem.info.Item1 > 0)
         {
            _loc2_ = ItemManager.Instance.getTemplateById(this._currentItem.info.Item1);
            _loc3_ = new BagCell(0,_loc2_,true,ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.fusionitemcell.bg"));
            PositionUtils.setPos(_loc3_,"magicbox.fusionview.materialcell1Pos");
            _loc3_.width = _loc3_.height = 70;
            addChild(_loc3_);
            _loc4_ = this._propBag.getItemCountByTemplateId(this._currentItem.info.Item1);
            _loc14_ = _loc4_ / this._currentItem.info.Item1Count;
            this._materialArr.push(_loc3_);
            this._materialCountTxt1.text = _loc4_ + "/" + this._currentItem.info.Item1Count;
            removeChild(this._materialCountTxt1);
            addChildAt(this._materialCountTxt1,getChildIndex(_loc3_) + 1);
            if(this._currentItem.info.Item2 > 0)
            {
               _loc5_ = ItemManager.Instance.getTemplateById(this._currentItem.info.Item2);
               _loc6_ = new BagCell(0,_loc5_,true,ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.fusionitemcell.bg"));
               PositionUtils.setPos(_loc6_,"magicbox.fusionview.materialcell2Pos");
               _loc6_.width = _loc6_.height = 70;
               addChild(_loc6_);
               _loc7_ = this._propBag.getItemCountByTemplateId(this._currentItem.info.Item2);
               _loc15_ = _loc7_ / this._currentItem.info.Item2Count;
               this._materialArr.push(_loc6_);
               this._materialCountTxt2.text = _loc7_ + "/" + this._currentItem.info.Item2Count;
               removeChild(this._materialCountTxt2);
               addChildAt(this._materialCountTxt2,getChildIndex(_loc6_) + 1);
               if(this._currentItem.info.Item3 > 0)
               {
                  _loc8_ = ItemManager.Instance.getTemplateById(this._currentItem.info.Item3);
                  _loc9_ = new BagCell(0,_loc8_,true,ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.fusionitemcell.bg"));
                  PositionUtils.setPos(_loc9_,"magicbox.fusionview.materialcell3Pos");
                  _loc9_.width = _loc9_.height = 70;
                  addChild(_loc9_);
                  _loc10_ = this._propBag.getItemCountByTemplateId(this._currentItem.info.Item3);
                  _loc16_ = _loc10_ / this._currentItem.info.Item3Count;
                  this._materialArr.push(_loc9_);
                  this._materialCountTxt3.text = _loc10_ + "/" + this._currentItem.info.Item3Count;
                  removeChild(this._materialCountTxt3);
                  addChildAt(this._materialCountTxt3,getChildIndex(_loc9_) + 1);
                  if(this._currentItem.info.Item4 > 0)
                  {
                     _loc11_ = ItemManager.Instance.getTemplateById(this._currentItem.info.Item4);
                     _loc12_ = new BagCell(0,_loc11_,true,ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.fusionitemcell.bg"));
                     PositionUtils.setPos(_loc12_,"magicbox.fusionview.materialcell4Pos");
                     _loc12_.width = _loc12_.height = 70;
                     addChild(_loc12_);
                     _loc13_ = this._propBag.getItemCountByTemplateId(this._currentItem.info.Item4);
                     _loc17_ = _loc13_ / this._currentItem.info.Item4Count;
                     this._materialArr.push(_loc12_);
                     this._materialCountTxt4.text = _loc13_ + "/" + this._currentItem.info.Item4Count;
                     removeChild(this._materialCountTxt4);
                     addChildAt(this._materialCountTxt4,getChildIndex(_loc12_) + 1);
                  }
               }
            }
         }
         _loc18_ = PlayerManager.Instance.Self.Gold / this._currentItem.info.NeedGold;
         _loc19_ = PlayerManager.Instance.Self.essence / this._currentItem.info.NeedKey;
         if(_loc14_ != -1)
         {
            this._maxNum = _loc14_;
         }
         else
         {
            this._maxNum = _loc18_ > _loc19_ ? _loc19_ : int(_loc18_);
         }
         if(_loc15_ != -1 && _loc15_ < this._maxNum)
         {
            this._maxNum = _loc15_;
         }
         if(_loc16_ != -1 && _loc16_ < this._maxNum)
         {
            this._maxNum = _loc16_;
         }
         if(_loc17_ != -1 && _loc17_ < this._maxNum)
         {
            this._maxNum = _loc17_;
         }
         this._curNum = this._maxNum > 0 ? 1 : 0;
         this._inputNumTxt.text = this._curNum.toString();
         this._eliteCounts.text = this._currentItem.info.NeedKey.toString();
         this._moneyCounts.text = this._currentItem.info.NeedGold.toString();
      }
      
      private function initEvent() : void
      {
         MagicHouseManager.instance.addEventListener("magichouse_updata",this.__messageUpdate);
         MagicHouseManager.instance.addEventListener("magicbox_fusion_complete",this.__fusionComplete);
         this._fusionBtn.addEventListener("click",this.__fusionClickHandler);
         this._fusionCheckBtn.addEventListener("select",this.__fusionCheckHandler);
         this._maxBtn.addEventListener("click",this.__maxHandler);
         this._inputNumTxt.addEventListener("change",this.__inputTextChangeHandler);
         this._helpBtn.addEventListener("click",this.__helpClick);
         PlayerManager.Instance.Self.PropBag.addEventListener("update",this.__updateBag);
      }
      
      private function removeEvent() : void
      {
         MagicHouseManager.instance.removeEventListener("magichouse_updata",this.__messageUpdate);
         MagicHouseManager.instance.removeEventListener("magicbox_fusion_complete",this.__fusionComplete);
         this._fusionBtn.removeEventListener("click",this.__fusionClickHandler);
         this._fusionCheckBtn.removeEventListener("select",this.__fusionCheckHandler);
         this._maxBtn.removeEventListener("click",this.__maxHandler);
         this._inputNumTxt.removeEventListener("change",this.__inputTextChangeHandler);
         this._helpBtn.removeEventListener("click",this.__helpClick);
         PlayerManager.Instance.Self.PropBag.removeEventListener("update",this.__updateBag);
      }
      
      private function __messageUpdate(param1:Event) : void
      {
         this._selfElite.text = PlayerManager.Instance.Self.essence + "";
         this._selfMoney.text = PlayerManager.Instance.Self.Gold.toString();
      }
      
      private function __fusionComplete(param1:Event) : void
      {
         this._mashArea = new MagicBoxMashArea();
         LayerManager.Instance.addToLayer(this._mashArea,2);
         PositionUtils.setPos(this._mashArea,"magicbox.mashAreaPos");
         this._mashArea.addEventListener("click",this.__mashAreaClickHandler);
         InviteManager.Instance.enabled = false;
         this._changeRightView();
         this._fusionMc = ComponentFactory.Instance.creat("magicbox.fusionComplete.mc");
         addChild(this._fusionMc);
         this._fusionMc.gotoAndPlay(1);
         this._fusionMc.addEventListener("COMPLETE_FUSION",this.__fusionMcComplete);
      }
      
      private function __fusionMcComplete(param1:Event) : void
      {
         this._mashArea.removeEventListener("click",this.__mashAreaClickHandler);
         if(Boolean(this._mashArea.parent))
         {
            this._mashArea.parent.removeChild(this._mashArea);
            this._mashArea = null;
         }
         InviteManager.Instance.enabled = true;
         this._fusionMc.removeEventListener("COMPLETE_FUSION",this.__fusionMcComplete);
         if(Boolean(this._fusionMc))
         {
            ObjectUtils.disposeObject(this._fusionMc);
            this._fusionMc = null;
         }
      }
      
      private function __mashAreaClickHandler(param1:MouseEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.magicboxView.inFusion"));
      }
      
      private function __fusionClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._canFusion())
         {
            SocketManager.Instance.out.magicboxFusion(this._currentItem.info.ID,this._curNum,this._isComposeEnable);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.magicboxView.fusionFail"));
         }
      }
      
      private function _canFusion() : Boolean
      {
         var _loc1_:int = this._currentItem.info.Item1Count;
         var _loc2_:int = this._currentItem.info.Item2Count;
         var _loc3_:int = this._currentItem.info.Item3Count;
         var _loc4_:int = this._currentItem.info.Item4Count;
         var _loc5_:int = _loc1_ > 0 ? this._propBag.getItemCountByTemplateId(this._currentItem.info.Item1) : int(_loc1_ - 1);
         var _loc6_:int = _loc2_ > 0 ? this._propBag.getItemCountByTemplateId(this._currentItem.info.Item2) : int(_loc2_ - 1);
         var _loc7_:int = _loc3_ > 0 ? this._propBag.getItemCountByTemplateId(this._currentItem.info.Item3) : int(_loc3_ - 1);
         var _loc8_:int = _loc4_ > 0 ? this._propBag.getItemCountByTemplateId(this._currentItem.info.Item4) : int(_loc4_ - 1);
         var _loc9_:Number = PlayerManager.Instance.Self.essence;
         var _loc10_:int = this._currentItem.info.NeedKey;
         var _loc11_:Number = PlayerManager.Instance.Self.Gold;
         var _loc12_:int = this._currentItem.info.NeedGold;
         if(_loc9_ >= _loc10_ * this._curNum && _loc11_ >= _loc12_ * this._curNum && this._curNum > 0)
         {
            return true;
         }
         return false;
      }
      
      private function __fusionCheckHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._isComposeEnable = this._fusionCheckBtn.selected;
      }
      
      private function __maxHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._inputNumTxt.text = this._maxNum.toString();
         this._curNum = this._maxNum;
      }
      
      private function __inputTextChangeHandler(param1:Event) : void
      {
         var _loc2_:int = int(this._inputNumTxt.text);
         if(_loc2_ < 1)
         {
            this._inputNumTxt.text = "0";
         }
         if(_loc2_ > this._maxNum)
         {
            this._inputNumTxt.text = this._maxNum.toString();
         }
         this._curNum = int(this._inputNumTxt.text);
      }
      
      private function __helpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._helpFrame)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("cardSystem.help.main");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("magichouse.magicboxView.fusiontxt");
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
      
      private function __updateBag(param1:BagEvent) : void
      {
         this._changeRightView();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._itemsContentBg))
         {
            ObjectUtils.disposeObject(this._itemsContentBg);
         }
         this._itemsContentBg = null;
         if(Boolean(this._fusionCellContentBg))
         {
            ObjectUtils.disposeObject(this._fusionCellContentBg);
         }
         this._fusionCellContentBg = null;
         if(Boolean(this._materialContentBg))
         {
            ObjectUtils.disposeObject(this._materialContentBg);
         }
         this._materialContentBg = null;
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
         }
         this._helpBtn = null;
         if(Boolean(this._selfMoney))
         {
            ObjectUtils.disposeObject(this._selfMoney);
         }
         this._selfMoney = null;
         if(Boolean(this._selfElite))
         {
            ObjectUtils.disposeObject(this._selfElite);
         }
         this._selfElite = null;
         if(Boolean(this._itemCounts))
         {
            ObjectUtils.disposeObject(this._itemCounts);
         }
         this._itemCounts = null;
         if(Boolean(this._needElite))
         {
            ObjectUtils.disposeObject(this._needElite);
         }
         this._needElite = null;
         if(Boolean(this._eliteCounts))
         {
            ObjectUtils.disposeObject(this._eliteCounts);
         }
         this._eliteCounts = null;
         if(Boolean(this._needMoney))
         {
            ObjectUtils.disposeObject(this._needMoney);
         }
         this._needMoney = null;
         if(Boolean(this._moneyCounts))
         {
            ObjectUtils.disposeObject(this._moneyCounts);
         }
         this._moneyCounts = null;
         if(Boolean(this._fusionBtn))
         {
            ObjectUtils.disposeObject(this._fusionBtn);
         }
         this._fusionBtn = null;
         if(Boolean(this._itemPanel))
         {
            ObjectUtils.disposeObject(this._itemPanel);
         }
         this._itemPanel = null;
         if(Boolean(this._fusionCheckBtn))
         {
            ObjectUtils.disposeObject(this._fusionCheckBtn);
         }
         this._fusionCheckBtn = null;
         if(Boolean(this._inputNumBg))
         {
            ObjectUtils.disposeObject(this._inputNumBg);
         }
         this._inputNumBg = null;
         if(Boolean(this._inputNumTxt))
         {
            ObjectUtils.disposeObject(this._inputNumTxt);
         }
         this._inputNumTxt = null;
         if(Boolean(this._maxBtn))
         {
            ObjectUtils.disposeObject(this._maxBtn);
         }
         this._maxBtn = null;
         if(Boolean(this._fusionMc))
         {
            ObjectUtils.disposeObject(this._fusionMc);
         }
         this._fusionMc = null;
         if(Boolean(this._mashArea))
         {
            ObjectUtils.disposeObject(this._mashArea);
         }
         this._mashArea = null;
      }
   }
}

