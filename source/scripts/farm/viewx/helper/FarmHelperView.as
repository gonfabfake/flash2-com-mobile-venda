package farm.viewx.helper
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.HelpFrameUtils;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import farm.modelx.FieldVO;
   import farm.viewx.ConfirmHelperMoneyAlertFrame;
   import farm.viewx.confirmStopHelperFrame;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FarmHelperView extends Frame
   {
      
      private var _titleBg:DisplayObject;
      
      private var _helperFramBg1:ScaleBitmapImage;
      
      private var _helperFramBg2:ScaleBitmapImage;
      
      private var _onekeyStartBtn:TextButton;
      
      private var _onekeyCloseBtn:TextButton;
      
      private var _helperShowText1:FilterFrameText;
      
      private var _helperShowText2:FilterFrameText;
      
      private var _helperShowTime:FilterFrameText;
      
      private var _helperSelSeed:FilterFrameText;
      
      private var _helperSelTime:FilterFrameText;
      
      private var _needSeed:FilterFrameText;
      
      private var _needSeedText:FilterFrameText;
      
      private var _getSeedText:FilterFrameText;
      
      private var _getSeed:FilterFrameText;
      
      private var _getSeedNumOne:int;
      
      private var _getSeedNum:int;
      
      private var _remainTime:FilterFrameText;
      
      private var _helpBtn:TextButton;
      
      private var _farmChoose:ComboBox;
      
      private var _timeChoose:ComboBox;
      
      private var _farmNumChoose:ComboBox;
      
      private var _listArray:Array;
      
      private var _listArrayID:Array;
      
      private var _listSeedNum:Array;
      
      private var _listTimeTextArray:Array;
      
      private var _listTimeArray:Array;
      
      private var _currentTime:int;
      
      private var _currentID:int;
      
      private var _timer:Timer;
      
      private var _timerSeed:Timer;
      
      private var _timeText:FilterFrameText;
      
      private var _timeDiff:int;
      
      private var _autoTime:int;
      
      private var _seedItemInfo:Vector.<ShopItemInfo>;
      
      private var _beginFrame:HelperBeginFrame;
      
      private var _typeString:String;
      
      private var _infoList:Vector.<ShopItemInfo>;
      
      private var _configmPnl:ConfirmHelperMoneyAlertFrame;
      
      private var _stopHelpeCconfigm:confirmStopHelperFrame;
      
      private var _modelType:int;
      
      public function FarmHelperView()
      {
         super();
         this.initView();
         this.addEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         this._listArray = [];
         this._listArrayID = [];
         this._listSeedNum = [];
         this._listTimeTextArray = ["12horas","24horas"];
         this._listTimeArray = new Array(720,1440);
         this._currentTime = 720;
         this._titleBg = ComponentFactory.Instance.creat("assets.farm.farmHelper.title");
         addChild(this._titleBg);
         this._helperFramBg1 = ComponentFactory.Instance.creatComponentByStylename("helperFrame.bg1");
         addToContent(this._helperFramBg1);
         this._onekeyStartBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.onekeyStartBtn");
         this._onekeyStartBtn.text = LanguageMgr.GetTranslation("ddt.farm.StartBtn.text");
         this._onekeyStartBtn.enable = false;
         addToContent(this._onekeyStartBtn);
         this._onekeyCloseBtn = ComponentFactory.Instance.creatComponentByStylename("asset.farm.onekeyCloseBtn");
         this._onekeyCloseBtn.visible = false;
         this._onekeyCloseBtn.text = LanguageMgr.GetTranslation("ddt.farm.CloseBtn.text");
         addToContent(this._onekeyCloseBtn);
         this._helperShowText1 = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTxt1");
         this._helperShowText1.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text1");
         addToContent(this._helperShowText1);
         this._helperShowText2 = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTxt2");
         addToContent(this._helperShowText2);
         this._helperShowTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperShowTime");
         addToContent(this._helperShowTime);
         this._helperSelSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperSelSeed");
         this._helperSelSeed.text = LanguageMgr.GetTranslation("ddt.farm.helperSelSeed.text");
         addToContent(this._helperSelSeed);
         this._helperSelTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperSelTime");
         this._helperSelTime.text = LanguageMgr.GetTranslation("ddt.farm.helperSeltime.text");
         addToContent(this._helperSelTime);
         this._needSeedText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeedText");
         this._needSeedText.text = LanguageMgr.GetTranslation("ddt.farm.helperNeedSeed.text");
         addToContent(this._needSeedText);
         this._needSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeed");
         addToContent(this._needSeed);
         this._getSeedText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeedText");
         this._getSeedText.text = LanguageMgr.GetTranslation("ddt.farm.helperGetSeed.text");
         addToContent(this._getSeedText);
         this._getSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeed");
         addToContent(this._getSeed);
         this._remainTime = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperRemainTime");
         this._remainTime.text = LanguageMgr.GetTranslation("ddt.farm.helperNeedTime.text");
         addToContent(this._remainTime);
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"asset.farm.helpBtn",null,LanguageMgr.GetTranslation("ddt.farm.helper.help.readme"),"assets.farm.helperTxt",404,484) as TextButton;
         this._helpBtn.text = LanguageMgr.GetTranslation("ddt.farm.helpBtn.text");
         this._farmChoose = ComponentFactory.Instance.creatComponentByStylename("asset.farm.farmChoose");
         addToContent(this._farmChoose);
         this._timeChoose = ComponentFactory.Instance.creatComponentByStylename("asset.farm.timeChoose");
         addToContent(this._timeChoose);
         this._infoList = ShopManager.Instance.getValidGoodByType(88);
         this.setComboxContent();
         this._timeText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperTimerText");
         addToContent(this._timeText);
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            this.setBtnEna(false);
            this.setTimes();
            this.setGetSeedCount();
         }
         this.setHelperTime();
         this._seedItemInfo = ShopManager.Instance.getValidSortedGoodsByType(88,1,this._farmChoose.listPanel.vectorListModel.size() + 1);
      }
      
      private function setHelperTime() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(FarmModelController.instance.model.isHelperMay || PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
         {
            if(PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
            {
               _loc1_ = PlayerManager.Instance.Self.VIPExpireDay as Date;
               this._helperShowTime.text = _loc1_.fullYear + "-" + (_loc1_.month + 1) + "-";
               this._helperShowTime.text += _loc1_.date + " " + this.fixZero(_loc1_.hours) + ":" + this.fixZero(_loc1_.minutes);
               this._helperShowText2.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text2");
            }
            else
            {
               _loc2_ = FarmModelController.instance.model.stopTime as Date;
               this._helperShowTime.text = _loc2_.fullYear + "-" + (_loc2_.month + 1) + "-";
               this._helperShowTime.text += _loc2_.date + " " + this.fixZero(_loc2_.hours) + ":" + this.fixZero(_loc2_.minutes);
               this._helperShowText2.text = LanguageMgr.GetTranslation("ddt.farm.helperShow.text2");
            }
         }
         else
         {
            this._helperShowTime.text = "";
            this._helperShowText2.text = "";
         }
      }
      
      private function setComboxContent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         this._farmChoose.beginChanges();
         this._farmChoose.selctedPropName = "text";
         var _loc4_:VectorListModel = this._farmChoose.listPanel.vectorListModel;
         _loc4_.clear();
         _loc1_ = 0;
         for(; _loc1_ < this._infoList.length; _loc1_++)
         {
            if(Boolean(this._infoList[_loc1_]) && Boolean(this._infoList[_loc1_].TemplateInfo.CategoryID == 32) && this._infoList[_loc1_].TemplateInfo.Property7 == "1")
            {
               if(PlayerManager.Instance.Self.VIPLevel < ServerConfigManager.instance.getPrivilegeMinLevel("8") || !PlayerManager.Instance.Self.IsVIP)
               {
                  continue;
               }
            }
            if(PlayerManager.Instance.Self.Grade >= this._infoList[_loc1_].LimitGrade)
            {
               _loc2_ = this._infoList[_loc1_].TemplateInfo.Name;
               _loc3_ = this._infoList[_loc1_].TemplateID;
               this._listArray.push(_loc2_);
               this._listArrayID.push(_loc3_);
               this._listSeedNum.push(int(this._infoList[_loc1_].TemplateInfo.Property2));
               if(PlayerManager.Instance.Self.isFarmHelper && this._infoList[_loc1_].TemplateID == FarmModelController.instance.model.helperArray[1])
               {
                  this._farmChoose.textField.text = this._infoList[_loc1_].TemplateInfo.Name;
               }
            }
         }
         this._farmChoose.listPanel.list.updateListView();
         this._farmChoose.listPanel.list.addEventListener("listItemClick",this.__itemClick);
         this._farmChoose.commitChanges();
         this._timeChoose.beginChanges();
         this._timeChoose.selctedPropName = "text";
         this._timeChoose.textField.text = "12" + LanguageMgr.GetTranslation("hours");
         var _loc5_:VectorListModel = this._timeChoose.listPanel.vectorListModel;
         _loc5_.clear();
         _loc5_.append(this._listTimeTextArray[0]);
         _loc5_.append(this._listTimeTextArray[1]);
         this._timeChoose.listPanel.list.updateListView();
         this._timeChoose.listPanel.list.addEventListener("listItemClick",this.__itemClick2);
         this._timeChoose.commitChanges();
      }
      
      private function setBtnEna(param1:Boolean = true) : void
      {
         if(Boolean(this._onekeyStartBtn))
         {
            if(param1 == true)
            {
               if(this._listArrayID.length > 0)
               {
                  this._onekeyStartBtn.enable = param1;
               }
            }
            else
            {
               this._onekeyStartBtn.visible = param1;
            }
         }
         if(Boolean(this._onekeyCloseBtn))
         {
            this._onekeyCloseBtn.visible = !param1;
         }
         if(Boolean(this._farmChoose))
         {
            this._farmChoose.enable = param1;
            this._farmChoose.filters = param1 == true ? ComponentFactory.Instance.creatFilters("lightFilter") : ComponentFactory.Instance.creatFilters("grayFilter");
         }
         if(Boolean(this._timeChoose))
         {
            this._timeChoose.enable = param1;
            this._timeChoose.filters = param1 == true ? ComponentFactory.Instance.creatFilters("lightFilter") : ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function addEvent() : void
      {
         addEventListener("response",this.__closeFarmHelper);
         this._onekeyStartBtn.addEventListener("click",this.__onekeyStartClick);
         this._onekeyCloseBtn.addEventListener("click",this.__onekeyCloseClick);
         this._farmChoose.button.addEventListener("click",this.__comBoxBtnClick);
         this._timeChoose.button.addEventListener("click",this.__comBoxBtnClick);
         FarmModelController.instance.addEventListener("beginHelper",this.__beginHelper);
         FarmModelController.instance.addEventListener("stopHelper",this.__stopHelper);
         FarmModelController.instance.addEventListener("confirmStopHelper",this.__confirmStopHelper);
         FarmModelController.instance.model.addEventListener("payHepler",this.__showHelperTime);
      }
      
      private function __showHelperTime(param1:FarmEvent) : void
      {
         this.setHelperTime();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      private function __closeFarmHelper(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
         }
      }
      
      private function __beginHelper(param1:FarmEvent) : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper)
         {
            this.setBtnEna(false);
            this.setTimes();
            this.setGetSeedCount();
         }
      }
      
      private function __stopHelper(param1:FarmEvent) : void
      {
         if(!PlayerManager.Instance.Self.isFarmHelper)
         {
            if(Boolean(this._timer))
            {
               this._timer.removeEventListener("timer",this.__timerHandler);
            }
            if(Boolean(this._timerSeed))
            {
               this._timerSeed.removeEventListener("timer",this.__timerSeedHandler);
            }
            this.setBtnEna(true);
         }
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         SoundManager.instance.play("008");
         this._currentID = this._listArrayID[param1.index];
         for each(_loc3_ in this._infoList)
         {
            if(_loc3_.TemplateID == this._currentID)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         this._getSeedNumOne = this._listSeedNum[param1.index];
         this._onekeyStartBtn.enable = true;
         switch(int(_loc2_.APrice1) - -9)
         {
            case 0:
               this._modelType = -9;
               break;
            case 1:
               this._modelType = -8;
               break;
            case 7:
               this._modelType = -2;
               break;
            case 8:
               this._modelType = -1;
               break;
            default:
               this._modelType = -1;
         }
         this._needSeed.text = this.getseedCountByID().toString();
         this._getSeed.text = this._getSeedNum.toString() + "/" + this._getSeedNum.toString();
      }
      
      private function __itemClick2(param1:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentTime = this._listTimeArray[param1.index];
         this._needSeed.text = this.getseedCountByID().toString();
         this._getSeed.text = this._getSeedNum.toString() + "/" + this._getSeedNum.toString();
      }
      
      private function getseedCountByID() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = this.findSeedTimebyID(this._currentID);
         var _loc4_:int = 0;
         var _loc5_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         _loc1_ = 0;
         while(_loc1_ < FarmModelController.instance.model.fieldsInfo.length)
         {
            _loc2_ = (new Date().getTime() - _loc5_[_loc1_].payTime.getTime()) / 3600000;
            if(_loc5_[_loc1_].fieldValidDate > _loc2_ || _loc5_[_loc1_].fieldValidDate == -1)
            {
               _loc4_++;
            }
            _loc1_++;
         }
         var _loc6_:int = _loc4_ * this._currentTime / _loc3_;
         this._getSeedNum = _loc4_ * this._currentTime / _loc3_ * this._getSeedNumOne;
         return _loc6_;
      }
      
      private function findSeedTimebyID(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._seedItemInfo.length)
         {
            if(this._currentID == this._seedItemInfo[_loc2_].TemplateID)
            {
               return int(this._seedItemInfo[_loc2_].TemplateInfo.Property3);
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function __comBoxBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __onekeyStartClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this._farmChoose.textField.text == null)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc5_:SelfInfo = PlayerManager.Instance.Self;
         if(FarmModelController.instance.model.isHelperMay || PlayerManager.Instance.Self.IsVIP && PlayerManager.Instance.Self.VIPLevel >= FarmModelController.instance.model.vipLimitLevel)
         {
            _loc2_ = FarmModelController.instance.model.getSeedCountByID(this._currentID);
            _loc3_ = this.getseedCountByID();
            _loc4_ = 0;
            this._beginFrame = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.beginFrame");
            this._beginFrame.seedID = this._currentID;
            this._beginFrame.seedTime = this._currentTime;
            this._beginFrame.getCount = this._getSeedNum;
            this._beginFrame.modelType = this._modelType;
            this._beginFrame.needCount = _loc3_ > _loc2_ ? int(_loc3_ - _loc2_) : 0;
            this._beginFrame.haveCount = _loc2_ > _loc3_ ? _loc3_ : int(_loc2_);
            this._beginFrame.show();
         }
         else
         {
            this._configmPnl = ComponentFactory.Instance.creatComponentByStylename("farm.confirmHelperMoneyAlertFrame");
            LayerManager.Instance.addToLayer(this._configmPnl,3,true,1);
         }
      }
      
      private function __onekeyCloseClick(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SoundManager.instance.play("008");
         this._stopHelpeCconfigm = ComponentFactory.Instance.creatComponentByStylename("farm.confirmStopHelperFrame");
         LayerManager.Instance.addToLayer(this._stopHelpeCconfigm,3,true,1);
      }
      
      private function __confirmStopHelper(param1:FarmEvent) : void
      {
         var _loc2_:Array = [];
         _loc2_.push(false);
         SocketManager.Instance.out.sendBeginHelper(_loc2_);
         this.dispose();
      }
      
      private function setTimes() : void
      {
         var _loc1_:Date = FarmModelController.instance.model.helperArray[2];
         var _loc2_:int = _loc1_.getTime() / 1000;
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:int = _loc3_.getTime() / 1000;
         this._autoTime = FarmModelController.instance.model.helperArray[3] * 60;
         if(_loc4_ - _loc2_ < 0)
         {
            this._timeDiff = this._autoTime;
         }
         else
         {
            this._timeDiff = this._autoTime - (_loc4_ - _loc2_);
         }
         this._timer = new Timer(1000,int(this._timeDiff));
         this._timer.start();
         this._timerSeed = new Timer(60000);
         this._timerSeed.start();
         if(this._timeText == null)
         {
            this._timeText = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperTimerText");
            addChild(this._timeText);
         }
         if(this._needSeed == null)
         {
            this._needSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperNeedSeed");
            addChild(this._needSeed);
         }
         this._needSeed.text = FarmModelController.instance.model.helperArray[4];
         this._timeChoose.textField.text = FarmModelController.instance.model.helperArray[3] / 60 + LanguageMgr.GetTranslation("hour");
         this._timer.addEventListener("timer",this.__timerHandler);
         this._timerSeed.addEventListener("timer",this.__timerSeedHandler);
      }
      
      private function __timerSeedHandler(param1:TimerEvent) : void
      {
         this.setGetSeedCount();
      }
      
      private function setGetSeedCount() : void
      {
         if(this._getSeed == null)
         {
            this._getSeed = ComponentFactory.Instance.creatComponentByStylename("asset.farm.helperGetSeed");
            addChild(this._getSeed);
         }
         this._getSeed.text = String(int((1 - this._timeDiff / this._autoTime) * FarmModelController.instance.model.helperArray[5])) + "/" + FarmModelController.instance.model.helperArray[5].toString();
      }
      
      private function __timerHandler(param1:TimerEvent) : void
      {
         var _loc2_:* = null;
         this._timeText.text = this.getTimeDiff(this._timeDiff);
         --this._timeDiff;
         if(this._timeDiff == 0)
         {
            _loc2_ = [];
            _loc2_.push(false);
            SocketManager.Instance.out.sendBeginHelper(_loc2_);
            this.dispose();
         }
      }
      
      private function getTimeDiff(param1:int) : String
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         if(param1 >= 0)
         {
            _loc2_ = uint(Math.floor(param1 / 60 / 60));
            param1 %= 3600;
            _loc3_ = uint(Math.floor(param1 / 60));
            param1 %= 60;
            _loc4_ = uint(param1);
         }
         return this.fixZero(_loc2_) + ":" + this.fixZero(_loc3_) + ":" + this.fixZero(_loc4_);
      }
      
      private function fixZero(param1:uint) : String
      {
         return param1 < 10 ? "0" + String(param1) : String(param1);
      }
      
      private function removeEvent() : void
      {
         this._onekeyStartBtn.removeEventListener("click",this.__onekeyStartClick);
         this._onekeyCloseBtn.removeEventListener("click",this.__onekeyCloseClick);
         removeEventListener("response",this.__closeFarmHelper);
         this._farmChoose.listPanel.list.removeEventListener("listItemClick",this.__itemClick);
         this._timeChoose.listPanel.list.removeEventListener("listItemClick",this.__itemClick2);
         FarmModelController.instance.removeEventListener("beginHelper",this.__beginHelper);
         FarmModelController.instance.removeEventListener("stopHelper",this.__stopHelper);
         FarmModelController.instance.removeEventListener("confirmStopHelper",this.__confirmStopHelper);
         FarmModelController.instance.model.removeEventListener("payHepler",this.__showHelperTime);
         if(Boolean(this._timer))
         {
            this._timer.removeEventListener("timer",this.__timerHandler);
         }
      }
      
      private function removeItem() : void
      {
         if(Boolean(this._onekeyStartBtn))
         {
            ObjectUtils.disposeObject(this._onekeyStartBtn);
         }
         this._onekeyStartBtn = null;
         if(Boolean(this._onekeyCloseBtn))
         {
            ObjectUtils.disposeObject(this._onekeyCloseBtn);
         }
         this._onekeyCloseBtn = null;
         if(Boolean(this._helperShowText1))
         {
            ObjectUtils.disposeObject(this._helperShowText1);
         }
         this._helperShowText1 = null;
         if(Boolean(this._helperShowText2))
         {
            ObjectUtils.disposeObject(this._helperShowText2);
         }
         this._helperShowText2 = null;
         if(Boolean(this._helperShowTime))
         {
            ObjectUtils.disposeObject(this._helperShowTime);
         }
         this._helperShowTime = null;
         if(Boolean(this._farmChoose))
         {
            ObjectUtils.disposeObject(this._farmChoose);
         }
         this._farmChoose = null;
         if(Boolean(this._timeChoose))
         {
            ObjectUtils.disposeObject(this._timeChoose);
         }
         this._timeChoose = null;
         if(Boolean(this._farmNumChoose))
         {
            ObjectUtils.disposeObject(this._farmNumChoose);
         }
         this._farmNumChoose = null;
         if(Boolean(this._listArray))
         {
            ObjectUtils.disposeObject(this._listArray);
         }
         this._listArray = null;
         if(Boolean(this._helperSelSeed))
         {
            ObjectUtils.disposeObject(this._helperSelSeed);
         }
         this._helperSelTime = null;
         if(Boolean(this._helperSelTime))
         {
            ObjectUtils.disposeObject(this._helperSelTime);
         }
         this._helperSelTime = null;
         if(Boolean(this._needSeed))
         {
            ObjectUtils.disposeObject(this._needSeed);
         }
         this._needSeed = null;
         if(Boolean(this._needSeedText))
         {
            ObjectUtils.disposeObject(this._needSeedText);
         }
         this._needSeedText = null;
         if(Boolean(this._getSeedText))
         {
            ObjectUtils.disposeObject(this._getSeedText);
         }
         this._getSeedText = null;
         if(Boolean(this._getSeed))
         {
            ObjectUtils.disposeObject(this._getSeed);
         }
         this._getSeed = null;
         if(Boolean(this._remainTime))
         {
            ObjectUtils.disposeObject(this._remainTime);
         }
         this._remainTime = null;
         if(Boolean(this._helperFramBg1))
         {
            ObjectUtils.disposeObject(this._helperFramBg1);
         }
         this._helperFramBg1 = null;
         if(Boolean(this._helperFramBg2))
         {
            ObjectUtils.disposeObject(this._helperFramBg2);
         }
         this._helperFramBg2 = null;
         if(Boolean(this._beginFrame))
         {
            ObjectUtils.disposeObject(this._beginFrame);
         }
         this._beginFrame = null;
         if(Boolean(this._timer))
         {
            ObjectUtils.disposeObject(this._timer);
         }
         this._timer = null;
         if(Boolean(this._timeText))
         {
            ObjectUtils.disposeObject(this._timeText);
         }
         this._timeText = null;
         if(Boolean(this._configmPnl))
         {
            this._configmPnl.dispose();
         }
         this._configmPnl = null;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeItem();
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

