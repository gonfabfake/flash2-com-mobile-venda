package farm.viewx.helper
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import farm.modelx.FieldVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class HelperList extends Sprite implements Disposeable
   {
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _helperListBG:MovieClip;
      
      private var _helperListVLine:MutipleImage;
      
      private var _fieldIndex:BaseButton;
      
      private var _seedID:BaseButton;
      
      private var _fertilizerID:BaseButton;
      
      private var _isAuto:BaseButton;
      
      private var _fieldIndexText:FilterFrameText;
      
      private var _seedIDText:FilterFrameText;
      
      private var _fertilizerIDText:FilterFrameText;
      
      private var _isAutoText:FilterFrameText;
      
      private var _seedInfos:Dictionary;
      
      private var _fertilizerInfos:Dictionary;
      
      private var _helperItemList:Array;
      
      private var _currentSelectHelperItem:HelperItem;
      
      public function HelperList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._helperListBG = ClassUtils.CreatInstance("assets.farm.helperPanelBg");
         this._helperListVLine = ComponentFactory.Instance.creatComponentByStylename("farm.helperListVLine");
         this._fieldIndex = ComponentFactory.Instance.creatComponentByStylename("helperList.fieldIndex");
         this._seedID = ComponentFactory.Instance.creatComponentByStylename("helperList.seedID");
         this._fertilizerID = ComponentFactory.Instance.creatComponentByStylename("helperList.fertilizerID");
         this._isAuto = ComponentFactory.Instance.creatComponentByStylename("helperList.isAuto");
         this._fieldIndexText = ComponentFactory.Instance.creatComponentByStylename("helperList.fieldIndexText");
         this._seedIDText = ComponentFactory.Instance.creatComponentByStylename("helperList.seedIDText");
         this._fertilizerIDText = ComponentFactory.Instance.creatComponentByStylename("helperList.fertilizerIDText");
         this._isAutoText = ComponentFactory.Instance.creatComponentByStylename("helperList.isAutoText");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperList.listVbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperList.listScrollPanel");
         this._scrollPanel.setView(this._vbox);
         addChild(this._helperListBG);
         addChild(this._helperListVLine);
         addChild(this._fieldIndex);
         addChild(this._seedID);
         addChild(this._fertilizerID);
         addChild(this._isAuto);
         addChild(this._fieldIndexText);
         addChild(this._seedIDText);
         addChild(this._fertilizerIDText);
         addChild(this._isAutoText);
         addChild(this._vbox);
         addChild(this._scrollPanel);
         this._fieldIndexText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.fieldIndexText");
         this._seedIDText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.seedIDText");
         this._fertilizerIDText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.fertilizerIDText");
         this._isAutoText.text = LanguageMgr.GetTranslation("ddt.farm.helperList.isAutoText");
         this.setTip(this._fieldIndex,this._fieldIndexText.text);
         this.setTip(this._seedID,this._seedIDText.text);
         this.setTip(this._fertilizerID,this._fertilizerIDText.text);
         this.setTip(this._isAuto,this._isAutoText.text);
         this.setListData();
      }
      
      private function setTip(param1:BaseButton, param2:String) : void
      {
         param1.tipStyle = "ddt.view.tips.OneLineTip";
         param1.tipDirctions = "0";
         param1.tipData = param2;
      }
      
      public function get helperItemList() : Array
      {
         return this._helperItemList;
      }
      
      private function findNumState(param1:int, param2:int) : int
      {
         var _loc9_:* = undefined;
         var _loc10_:InventoryItemInfo = null;
         var _loc11_:InventoryItemInfo = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         for each(_loc9_ in this._helperItemList)
         {
            _loc3_ = _loc9_.getSetViewItemData;
            if(!_loc3_)
            {
               _loc3_ = _loc9_.getItemData;
            }
            _loc4_ = int(_loc3_.currentSeedText);
            if(param1 > 0 && _loc4_ == param1)
            {
               _loc7_ += int(_loc3_.currentSeedNum);
            }
            _loc5_ = int(_loc3_.currentFertilizerText);
            if(param2 > 0 && _loc5_ == param2)
            {
               _loc8_ += int(_loc3_.currentFertilizerNum);
            }
         }
         _loc10_ = FarmModelController.instance.model.findItemInfo(32,param1);
         if((Boolean(_loc10_)) && _loc7_ > _loc10_.Count)
         {
            _loc6_ = 1;
         }
         _loc11_ = FarmModelController.instance.model.findItemInfo(33,param2);
         if((Boolean(_loc11_)) && _loc8_ > _loc11_.Count)
         {
            _loc6_ = 2;
         }
         return _loc6_;
      }
      
      private function setListData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         this._vbox.disposeAllChildren();
         this._helperItemList = [];
         var _loc8_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         var _loc9_:int = _loc8_ ? int(_loc8_.length) : 0;
         _loc1_ = 0;
         while(_loc1_ < _loc9_)
         {
            _loc2_ = new HelperItem();
            _loc2_.addEventListener("click",this.__onItemClickHandler);
            _loc2_.findNumState = this.findNumState;
            _loc2_.index = _loc1_;
            _loc3_ = null;
            _loc3_ = _loc8_[_loc1_];
            if(Boolean(_loc3_.isDig))
            {
               _loc2_.initView(1);
               _loc2_.setCellValue(_loc3_);
               this._helperItemList.push(_loc2_);
               this._vbox.addChild(_loc2_);
            }
            _loc1_++;
         }
         this._scrollPanel.invalidateViewport();
         this._seedInfos = new Dictionary();
         this._fertilizerInfos = new Dictionary();
         var _loc10_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(88);
         var _loc11_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(89);
         _loc4_ = 0;
         while(_loc4_ < _loc10_.length)
         {
            _loc5_ = _loc10_[_loc4_];
            this._seedInfos[_loc5_.TemplateInfo.Name] = _loc5_.TemplateInfo.TemplateID;
            _loc4_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc11_.length)
         {
            _loc7_ = _loc11_[_loc6_];
            this._fertilizerInfos[_loc7_.TemplateInfo.Name] = _loc7_.TemplateInfo.TemplateID;
            _loc6_++;
         }
      }
      
      public function onKeyStart() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in this._helperItemList)
         {
            if(Boolean(_loc2_.onKeyStart()))
            {
               _loc1_.push(_loc2_.getItemData);
            }
         }
         if(_loc1_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.onKeyStartFail"));
         }
         else
         {
            FarmModelController.instance.farmHelperSetSwitch(_loc1_,true);
         }
      }
      
      public function onKeyStop() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in this._helperItemList)
         {
            if(Boolean(_loc2_.onKeyStop()))
            {
               _loc1_.push(_loc2_.getItemData);
            }
         }
         if(_loc1_.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helperItem.onKeyStopFail"));
         }
         else
         {
            FarmModelController.instance.farmHelperSetSwitch(_loc1_,false);
         }
      }
      
      private function __onItemClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:HelperItem = HelperItem(param1.currentTarget);
         _loc2_.isSelelct(true);
         if(Boolean(this._currentSelectHelperItem) && this._currentSelectHelperItem != _loc2_)
         {
            this._currentSelectHelperItem.isSelelct(false);
         }
         this._currentSelectHelperItem = _loc2_;
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener("helperSwitchField",this.__helperSwitchHandler);
         FarmModelController.instance.addEventListener("helperkeyfield",this.__helperKeyHandler);
      }
      
      private function __helperSwitchHandler(param1:FarmEvent) : void
      {
         var _loc2_:FieldVO = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.isAutoId);
         if(_loc2_.isDig)
         {
            HelperItem(this.getHelperItem(_loc2_.fieldID)).setCellValue(_loc2_);
         }
         FarmModelController.instance.model.dispatchEvent(new FarmEvent("updateHelperIsAuto"));
      }
      
      private function __helperKeyHandler(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         _loc2_ = 0;
         while(_loc2_ < FarmModelController.instance.model.batchFieldIDArray.length)
         {
            _loc3_ = FarmModelController.instance.model.getfieldInfoById(FarmModelController.instance.model.batchFieldIDArray[_loc2_]);
            if(Boolean(_loc3_.isDig))
            {
               HelperItem(this.getHelperItem(_loc3_.fieldID)).setCellValue(_loc3_);
            }
            _loc2_++;
         }
         FarmModelController.instance.model.dispatchEvent(new FarmEvent("updateHelperIsAuto"));
      }
      
      public function getHelperItem(param1:int) : HelperItem
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._helperItemList)
         {
            if(_loc2_.currentFieldID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         FarmModelController.instance.removeEventListener("helperSwitchField",this.__helperSwitchHandler);
         FarmModelController.instance.removeEventListener("helperkeyfield",this.__helperKeyHandler);
         if(Boolean(this._helperItemList))
         {
            for each(_loc1_ in this._helperItemList)
            {
               _loc1_.removeEventListener("click",this.__onItemClickHandler);
               _loc1_.dispose();
            }
            this._helperItemList = null;
         }
         if(Boolean(this._vbox))
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._helperListBG))
         {
            ObjectUtils.disposeObject(this._helperListBG);
         }
         this._helperListBG = null;
         if(Boolean(this._scrollPanel))
         {
            ObjectUtils.disposeObject(this._scrollPanel);
         }
         this._scrollPanel = null;
         if(Boolean(this._fieldIndex))
         {
            ObjectUtils.disposeObject(this._fieldIndex);
         }
         this._fieldIndex = null;
         if(Boolean(this._seedID))
         {
            ObjectUtils.disposeObject(this._seedID);
         }
         this._seedID = null;
         if(Boolean(this._fertilizerID))
         {
            ObjectUtils.disposeObject(this._fertilizerID);
         }
         this._fertilizerID = null;
         if(Boolean(this._isAuto))
         {
            ObjectUtils.disposeObject(this._isAuto);
         }
         this._isAuto = null;
         if(Boolean(this._fieldIndexText))
         {
            ObjectUtils.disposeObject(this._fieldIndexText);
         }
         this._fieldIndexText = null;
         if(Boolean(this._seedIDText))
         {
            ObjectUtils.disposeObject(this._seedIDText);
         }
         this._seedIDText = null;
         if(Boolean(this._fertilizerIDText))
         {
            ObjectUtils.disposeObject(this._fertilizerIDText);
         }
         this._fertilizerIDText = null;
         if(Boolean(this._isAutoText))
         {
            ObjectUtils.disposeObject(this._isAutoText);
         }
         this._isAutoText = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

