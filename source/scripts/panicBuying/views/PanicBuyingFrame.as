package panicBuying.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedButtonForArrange;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelpFrameUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import panicBuying.PanicBuyingManager;
   import panicBuying.components.PanicBuyingItem;
   import panicBuying.data.PBuyingItemInfo;
   import road7th.utils.DateUtils;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.event.WonderfulActivityEvent;
   
   public class PanicBuyingFrame extends Frame
   {
      
      private static const NUM:int = 3;
      
      private static const ITEM_COUNT:int = 6;
      
      public static const LEVEL:int = 0;
      
      public static const VIP:int = 1;
      
      public static const ENTIRE:int = 2;
      
      public static const INDIV:int = 3;
      
      public static const NEW_ENTIRE:int = 4;
      
      private var _bg:ScaleBitmapImage;
      
      private var _vipBg:Bitmap;
      
      private var _dateBmp:Bitmap;
      
      private var _dateTxt:FilterFrameText;
      
      private var _remainBmp:Bitmap;
      
      private var _remainTxt:FilterFrameText;
      
      private var _tabGroup:SelectedButtonGroup;
      
      private var _hBox:Sprite;
      
      private var _levelRushBtn:SelectedButtonForArrange;
      
      private var _vipRushBtn:SelectedButtonForArrange;
      
      private var _entireRushBtn:SelectedButtonForArrange;
      
      private var _newEntireRushBtn:SelectedButtonForArrange;
      
      private var _indivRushBtn:SelectedButtonForArrange;
      
      private var _typeArr:Array;
      
      private var _tileList:SimpleTileList;
      
      private var _itemVec:Vector.<PanicBuyingItem>;
      
      private var _firstBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _lastBtn:SimpleBitmapButton;
      
      private var _pageBg:Scale9CornerImage;
      
      private var _pageTxt:FilterFrameText;
      
      private var _btnHelp:BaseButton;
      
      private var _helpSprite:Sprite;
      
      private var _helpScrollPanel:ScrollPanel;
      
      private var _helpTxt:FilterFrameText;
      
      private var _helpTxtWidth:int;
      
      private var _curType:int;
      
      private var _curPage:int;
      
      private var _xmlData:GmActivityInfo;
      
      private var _giftInfoDic:Dictionary;
      
      private var tmpFlag:int;
      
      public function PanicBuyingFrame()
      {
         super();
         this.initView();
         this.addEvents();
         this.initTimer();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         titleText = LanguageMgr.GetTranslation("panicBuying.title");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("panicBuying.bg");
         addToContent(this._bg);
         this._vipBg = ComponentFactory.Instance.creat("panicBuying.vipBg");
         addToContent(this._vipBg);
         this._vipBg.visible = false;
         this._dateBmp = ComponentFactory.Instance.creat("panicBuying.date");
         addToContent(this._dateBmp);
         this._dateTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.dateTxt");
         addToContent(this._dateTxt);
         this._tileList = ComponentFactory.Instance.creat("panicBuying.tileList",[3]);
         addToContent(this._tileList);
         this._itemVec = new Vector.<PanicBuyingItem>();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new PanicBuyingItem();
            this._tileList.addChild(_loc2_);
            this._itemVec.push(_loc2_);
            _loc1_++;
         }
         this._remainBmp = ComponentFactory.Instance.creat("panicBuying.remain");
         addToContent(this._remainBmp);
         this._remainTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.remainTxt");
         addToContent(this._remainTxt);
         this._remainTxt.text = "12小时20分";
         this._firstBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.firstBtn");
         addToContent(this._firstBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.preBtn");
         addToContent(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.nextBtn");
         addToContent(this._nextBtn);
         this._lastBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.lastBtn");
         addToContent(this._lastBtn);
         this._pageBg = ComponentFactory.Instance.creatComponentByStylename("panicBuying.pageBg");
         addToContent(this._pageBg);
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.pageTxt");
         addToContent(this._pageTxt);
         this._pageTxt.text = "1/15";
         this._helpTxt = ComponentFactory.Instance.creatComponentByStylename("panicBuying.helpTxt");
         this._helpTxtWidth = this._helpTxt.width;
         this._helpSprite = new Sprite();
         this._helpScrollPanel = ComponentFactory.Instance.creatComponentByStylename("panicBuying.helpScrollPanel");
         this._helpScrollPanel.setView(this._helpTxt);
         this._helpSprite.addChild(this._helpScrollPanel);
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"core.helpButtonSmall",{
            "x":544,
            "y":-40
         },LanguageMgr.GetTranslation("panicBuying.helpTxt"),this._helpSprite,408,488);
         this._btnHelp.visible = false;
         this.initView2();
      }
      
      private function initView2() : void
      {
         this._hBox = new Sprite();
         this._hBox.x = 5;
         addToContent(this._hBox);
         this._levelRushBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.levelRushBtn");
         this._vipRushBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.vipRushBtn");
         this._entireRushBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.entireRushBtn");
         this._newEntireRushBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.newEntireRushBtn");
         this._indivRushBtn = ComponentFactory.Instance.creatComponentByStylename("panicBuying.indivRushBtn");
         this._tabGroup = new SelectedButtonGroup();
         this._typeArr = [];
         this.tmpFlag = PanicBuyingManager.instance.showIconFlag;
         if(Boolean(this.tmpFlag & 2))
         {
            this._hBox.addChild(this._levelRushBtn);
            this._tabGroup.addSelectItem(this._levelRushBtn);
            this._typeArr.push(0);
         }
         if(Boolean(this.tmpFlag & 4))
         {
            this._hBox.addChild(this._vipRushBtn);
            this._tabGroup.addSelectItem(this._vipRushBtn);
            this._typeArr.push(1);
         }
         if(Boolean(this.tmpFlag & 1))
         {
            this._hBox.addChild(this._entireRushBtn);
            this._tabGroup.addSelectItem(this._entireRushBtn);
            this._typeArr.push(2);
         }
         if(Boolean(this.tmpFlag & 8))
         {
            this._hBox.addChild(this._indivRushBtn);
            this._tabGroup.addSelectItem(this._indivRushBtn);
            this._typeArr.push(3);
         }
         if(Boolean(this.tmpFlag & 0x10))
         {
            this._hBox.addChild(this._newEntireRushBtn);
            this._tabGroup.addSelectItem(this._newEntireRushBtn);
            this._typeArr.push(4);
         }
         this._tabGroup.selectIndex = 0;
         this._curType = this._typeArr[this._tabGroup.selectIndex];
         this._curPage = 1;
         this.update();
         this.refreshTab();
      }
      
      private function refreshTab() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = this._hBox.numChildren;
         _loc1_ = 1;
         while(_loc1_ < _loc2_)
         {
            if((this._hBox.getChildAt(_loc1_ - 1) as SelectedButtonForArrange).selected)
            {
               this._hBox.getChildAt(_loc1_).x = this._hBox.getChildAt(_loc1_ - 1).x + 2 + 132;
            }
            else
            {
               this._hBox.getChildAt(_loc1_).x = this._hBox.getChildAt(_loc1_ - 1).x + 2 + 113;
            }
            _loc1_++;
         }
      }
      
      private function addEvents() : void
      {
         addEventListener("response",this.__responseHandler);
         this._tabGroup.addEventListener("change",this.__changeHandler);
         this._firstBtn.addEventListener("click",this.__firstBtnClick);
         this._preBtn.addEventListener("click",this.__preBtnClick);
         this._nextBtn.addEventListener("click",this.__nextBtnClick);
         this._lastBtn.addEventListener("click",this.__lastBtnClick);
         WonderfulActivityManager.Instance.addEventListener("refresh",this.refreshActivity);
      }
      
      private function initTimer() : void
      {
         this.timerHandler();
         WonderfulActivityManager.Instance.addTimerFun("panicBuying",this.timerHandler);
      }
      
      private function timerHandler() : void
      {
         if(!this._xmlData)
         {
            return;
         }
         var _loc1_:Date = DateUtils.getDateByStr(this._xmlData.endTime);
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:String = this.getTimeDiff(_loc1_,_loc2_);
         if(Boolean(this._remainTxt))
         {
            this._remainTxt.text = _loc3_;
         }
         if(_loc3_ == "0")
         {
            if(Boolean(this._remainTxt))
            {
               this._remainTxt.text = LanguageMgr.GetTranslation("treasureHunting.over");
            }
            WonderfulActivityManager.Instance.delTimerFun("panicBuying");
         }
      }
      
      public function getTimeDiff(param1:Date, param2:Date) : String
      {
         var _loc8_:Number = NaN;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = null;
         _loc8_ = Math.round((param1.getTime() - param2.getTime()) / 1000);
         if(_loc8_ >= 0)
         {
            _loc3_ = uint(Math.floor(_loc8_ / 60 / 60 / 24));
            _loc8_ %= 86400;
            _loc4_ = uint(Math.floor(_loc8_ / 60 / 60));
            _loc8_ %= 3600;
            _loc5_ = uint(Math.floor(_loc8_ / 60));
            _loc6_ = uint(_loc8_ % 60);
            if(_loc3_ > 0)
            {
               return _loc3_ + LanguageMgr.GetTranslation("wonderfulActivityManager.d");
            }
            _loc7_ = "";
            if(_loc4_ > 0)
            {
               _loc7_ += _loc4_ + LanguageMgr.GetTranslation("wonderfulActivityManager.h");
            }
            if(_loc5_ > 0)
            {
               _loc7_ += _loc5_ + LanguageMgr.GetTranslation("wonderfulActivityManager.m");
            }
            if(_loc7_ == "")
            {
               _loc7_ = _loc6_ + LanguageMgr.GetTranslation("wonderfulActivityManager.s");
            }
            return _loc7_;
         }
         return "0";
      }
      
      protected function __lastBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(this._curType == 2)
         {
            _loc2_ = ShopManager.Instance.getDisCountResultPages(1,6);
         }
         else
         {
            _loc2_ = this.getGiftBagTotal();
         }
         this._curPage = _loc2_;
         this.update();
      }
      
      protected function __nextBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(this._curType == 2)
         {
            _loc2_ = ShopManager.Instance.getDisCountResultPages(1,6);
         }
         else
         {
            _loc2_ = this.getGiftBagTotal();
         }
         this._curPage = this._curPage >= _loc2_ ? _loc2_ : int(this._curPage + 1);
         this.update();
      }
      
      protected function __preBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._curPage = this._curPage <= 1 ? 1 : int(Number(this._curPage - 1));
         this.update();
      }
      
      protected function __firstBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._curPage = 1;
         this.update();
      }
      
      protected function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._curType = this._typeArr[this._tabGroup.selectIndex];
         this._curPage = 1;
         this.update();
         this.refreshTab();
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = undefined;
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         this.updateFrameStyle();
         if(this._curType == 2)
         {
            _loc4_ = ShopManager.Instance.getDisCountGoods(1,this._curPage,6);
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               _loc2_ = new PBuyingItemInfo();
               if(_loc1_ <= _loc4_.length - 1)
               {
                  _loc2_.templateId = _loc4_[_loc1_].TemplateID;
                  _loc2_.goodsId = _loc4_[_loc1_].GoodsID;
                  _loc2_.price = _loc4_[_loc1_].AValue1;
                  _loc2_.originalPrice = _loc4_[_loc1_].Position;
                  _loc2_.priceType = _loc4_[_loc1_].APrice1;
                  _loc2_.unitCount = _loc4_[_loc1_].AUnit;
               }
               else
               {
                  _loc2_.templateId = 0;
               }
               this._itemVec[_loc1_].setData(_loc2_,this._curType);
               _loc1_++;
            }
            this._xmlData = WonderfulActivityManager.Instance.activityData[PanicBuyingManager.instance.entireId];
            this.setHelpTxt(this._xmlData.desc);
            _loc3_ = ShopManager.Instance.getDisCountResultPages(1,6);
         }
         else
         {
            switch(int(this._curType))
            {
               case 0:
                  this._xmlData = WonderfulActivityManager.Instance.activityData[PanicBuyingManager.instance.levelId];
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[PanicBuyingManager.instance.levelId].giftInfoDic;
                  break;
               case 1:
                  this._xmlData = WonderfulActivityManager.Instance.activityData[PanicBuyingManager.instance.vipId];
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[PanicBuyingManager.instance.vipId].giftInfoDic;
                  _loc5_ = WonderfulActivityManager.Instance.activityInitData[PanicBuyingManager.instance.vipId].statusArr;
                  break;
               case 3:
                  this._xmlData = WonderfulActivityManager.Instance.activityData[PanicBuyingManager.instance.indivId];
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[PanicBuyingManager.instance.indivId].giftInfoDic;
                  break;
               case 4:
                  this._xmlData = WonderfulActivityManager.Instance.activityData[PanicBuyingManager.instance.newEntireId];
                  this._giftInfoDic = WonderfulActivityManager.Instance.activityInitData[PanicBuyingManager.instance.newEntireId].giftInfoDic;
            }
            _loc6_ = this.getGiftBagInCurPage(this._curPage);
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               _loc2_ = new PBuyingItemInfo();
               if(_loc1_ <= _loc6_.length - 1)
               {
                  _loc2_.templateId = _loc6_[_loc1_].giftRewardArr[0].templateId;
                  _loc2_.activityId = _loc6_[_loc1_].activityId;
                  _loc2_.giftbagId = _loc6_[_loc1_].giftbagId;
                  _loc2_.limitedType = 0;
                  _loc7_ = _loc6_[_loc1_].giftConditionArr;
                  _loc8_ = 0;
                  while(_loc8_ <= _loc7_.length - 1)
                  {
                     if(_loc7_[_loc8_].conditionIndex == 1)
                     {
                        _loc2_.total = _loc7_[_loc8_].conditionValue;
                     }
                     if(_loc7_[_loc8_].conditionIndex == 2)
                     {
                        _loc2_.priceType = _loc7_[_loc8_].conditionValue;
                     }
                     if(_loc7_[_loc8_].conditionIndex == 3)
                     {
                        _loc2_.price = _loc7_[_loc8_].conditionValue;
                     }
                     else if(_loc7_[_loc8_].conditionIndex == 4)
                     {
                        _loc2_.levelLimit = _loc7_[_loc8_].conditionValue;
                     }
                     else if(_loc7_[_loc8_].conditionIndex == 5)
                     {
                        _loc2_.vipLimit = _loc7_[_loc8_].conditionValue;
                     }
                     else if(_loc7_[_loc8_].conditionIndex == 6)
                     {
                        _loc2_.originalPrice = _loc7_[_loc8_].conditionValue;
                     }
                     else if(_loc7_[_loc8_].conditionIndex == 100)
                     {
                        _loc2_.remain = _loc7_[_loc8_].conditionValue;
                        _loc2_.limitedType = 1;
                     }
                     _loc8_++;
                  }
                  if(this._curType == 4)
                  {
                     if(_loc1_ <= _loc6_.length - 1)
                     {
                        if(_loc2_.total == 0)
                        {
                           _loc2_.remain -= this._giftInfoDic[_loc2_.giftbagId].allGiftGetTimes;
                        }
                        else
                        {
                           _loc2_.limitedType = 1;
                           _loc2_.remain = _loc2_.total - this._giftInfoDic[_loc2_.giftbagId].times;
                        }
                     }
                  }
                  else
                  {
                     _loc2_.remain = _loc2_.total - this._giftInfoDic[_loc2_.giftbagId].times;
                  }
                  _loc9_ = _loc6_[_loc1_].giftRewardArr;
                  _loc10_ = 0;
                  while(_loc10_ <= _loc9_.length - 1)
                  {
                     _loc2_.count = _loc9_[_loc10_].count;
                     if(_loc9_[_loc10_].validDate == 0)
                     {
                        _loc2_.buyType = 1;
                        _loc2_.unitCount = _loc9_[_loc10_].count;
                     }
                     else
                     {
                        _loc2_.buyType = 0;
                        _loc2_.unitCount = _loc9_[_loc10_].validDate;
                     }
                     _loc10_++;
                  }
               }
               else
               {
                  _loc2_.templateId = 0;
               }
               this._itemVec[_loc1_].setData(_loc2_,this._curType);
               _loc1_++;
            }
            _loc3_ = this.getGiftBagTotal();
         }
         if(this._curType == 2)
         {
            this._dateBmp.visible = false;
            this._dateTxt.visible = false;
         }
         else
         {
            this._dateBmp.visible = true;
            this._dateTxt.visible = true;
            this._dateTxt.text = this.dateTrim(this._xmlData.beginTime) + "-" + this.dateTrim(this._xmlData.endTime);
            this.setHelpTxt(this._xmlData.desc);
         }
         this._pageTxt.text = this._curPage + "/" + _loc3_;
         this.timerHandler();
      }
      
      private function setHelpTxt(param1:String) : void
      {
         this._helpTxt.autoSize = "none";
         this._helpTxt.width = this._helpTxtWidth;
         this._helpTxt.text = this._xmlData.desc;
         this._helpTxt.autoSize = "left";
         this._helpScrollPanel.invalidateViewport(false);
      }
      
      private function getGiftBagInCurPage(param1:int) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in this._xmlData.giftbagArray)
         {
            if(_loc3_.giftbagOrder >= (param1 - 1) * 6 && _loc3_.giftbagOrder <= param1 * 6 - 1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      private function getGiftBagTotal() : int
      {
         return Math.ceil(this._xmlData.giftbagArray.length / 6);
      }
      
      private function dateTrim(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:Array = param1.split(" ");
         return _loc3_[0].replace(/\//g,".");
      }
      
      private function updateFrameStyle() : void
      {
         switch(int(this._curType))
         {
            case 0:
            case 3:
               this._bg.visible = true;
               this._vipBg.visible = false;
               this._remainBmp.visible = true;
               this._remainTxt.visible = true;
               break;
            case 1:
               this._bg.visible = false;
               this._vipBg.visible = true;
               this._remainBmp.visible = true;
               this._remainTxt.visible = true;
               break;
            case 2:
               this._bg.visible = true;
               this._vipBg.visible = false;
               this._remainBmp.visible = false;
               this._remainTxt.visible = false;
               break;
            case 4:
               this._bg.visible = true;
               this._vipBg.visible = false;
               this._remainBmp.visible = true;
               this._remainTxt.visible = true;
         }
      }
      
      public function refreshActivity(param1:WonderfulActivityEvent = null) : void
      {
         if(PanicBuyingManager.instance.showIconFlag == this.tmpFlag)
         {
            this.update();
            return;
         }
         this.tmpFlag = PanicBuyingManager.instance.showIconFlag;
         if(this.tmpFlag == 0)
         {
            this.dispose();
            return;
         }
         this._tabGroup.removeEventListener("change",this.__changeHandler);
         ObjectUtils.disposeObject(this._tabGroup);
         this._tabGroup = null;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         ObjectUtils.disposeObject(this._levelRushBtn);
         this._levelRushBtn = null;
         ObjectUtils.disposeObject(this._vipRushBtn);
         this._vipRushBtn = null;
         ObjectUtils.disposeObject(this._entireRushBtn);
         this._entireRushBtn = null;
         ObjectUtils.disposeObject(this._newEntireRushBtn);
         this._newEntireRushBtn = null;
         ObjectUtils.disposeObject(this._indivRushBtn);
         this._indivRushBtn = null;
         this.initView2();
         this._tabGroup.addEventListener("change",this.__changeHandler);
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            this.dispose();
         }
      }
      
      private function removeEvents() : void
      {
         removeEventListener("response",this.__responseHandler);
         this._tabGroup.removeEventListener("change",this.__changeHandler);
         this._firstBtn.removeEventListener("click",this.__firstBtnClick);
         this._preBtn.removeEventListener("click",this.__preBtnClick);
         this._nextBtn.removeEventListener("click",this.__nextBtnClick);
         this._lastBtn.removeEventListener("click",this.__lastBtnClick);
         WonderfulActivityManager.Instance.removeEventListener("refresh",this.refreshActivity);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvents();
         WonderfulActivityManager.Instance.delTimerFun("panicBuying");
         _loc1_ = 0;
         while(_loc1_ <= this._itemVec.length - 1)
         {
            ObjectUtils.disposeObject(this._itemVec[_loc1_]);
            this._itemVec[_loc1_] = null;
            _loc1_++;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._vipBg);
         this._vipBg = null;
         ObjectUtils.disposeObject(this._dateBmp);
         this._dateBmp = null;
         ObjectUtils.disposeObject(this._dateTxt);
         this._dateTxt = null;
         ObjectUtils.disposeObject(this._remainBmp);
         this._remainBmp = null;
         ObjectUtils.disposeObject(this._remainTxt);
         this._remainTxt = null;
         ObjectUtils.disposeObject(this._tabGroup);
         this._tabGroup = null;
         ObjectUtils.disposeObject(this._hBox);
         this._hBox = null;
         ObjectUtils.disposeObject(this._levelRushBtn);
         this._levelRushBtn = null;
         ObjectUtils.disposeObject(this._vipRushBtn);
         this._vipRushBtn = null;
         ObjectUtils.disposeObject(this._entireRushBtn);
         this._entireRushBtn = null;
         ObjectUtils.disposeObject(this._newEntireRushBtn);
         this._newEntireRushBtn = null;
         ObjectUtils.disposeObject(this._indivRushBtn);
         this._indivRushBtn = null;
         ObjectUtils.disposeObject(this._tileList);
         this._tileList = null;
         ObjectUtils.disposeObject(this._firstBtn);
         this._firstBtn = null;
         ObjectUtils.disposeObject(this._preBtn);
         this._preBtn = null;
         ObjectUtils.disposeObject(this._nextBtn);
         this._nextBtn = null;
         ObjectUtils.disposeObject(this._lastBtn);
         this._lastBtn = null;
         ObjectUtils.disposeObject(this._pageBg);
         this._pageBg = null;
         ObjectUtils.disposeObject(this._pageTxt);
         this._pageTxt = null;
         ObjectUtils.disposeObject(this._btnHelp);
         this._btnHelp = null;
         ObjectUtils.disposeObject(this._helpTxt);
         this._helpTxt = null;
         ObjectUtils.disposeObject(this._helpScrollPanel);
         this._helpScrollPanel = null;
         ObjectUtils.disposeObject(this._helpSprite);
         this._helpSprite = null;
         super.dispose();
      }
   }
}

