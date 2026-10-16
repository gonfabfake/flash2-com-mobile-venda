package foodActivity.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import foodActivity.FoodActivityControl;
   import foodActivity.FoodActivityManager;
   import store.HelpFrame;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class FoodActivityFrame extends Frame
   {
      
      private static var MONEY:int = 100;
      
      private var _bg:Bitmap;
      
      private var _countBg:Bitmap;
      
      private var _boxArr:Vector.<FoodActivityBox>;
      
      private var _boxNumTxtArr:Vector.<FilterFrameText>;
      
      private var _sp:Sprite;
      
      private var _progress:Bitmap;
      
      private var _btnBg:ScaleBitmapImage;
      
      private var _simpleBtn:SimpleBitmapButton;
      
      private var _payBtn:SimpleBitmapButton;
      
      private var _ripeTxt:FilterFrameText;
      
      private var _countTxt:FilterFrameText;
      
      private var _boxMc:MovieClip;
      
      private var _getAwardBtn:MovieClip;
      
      private var _defaultLength:int = 11;
      
      private var _defaultRipeNum:int = 60;
      
      private var _giftState:int;
      
      private var _data:GmActivityInfo;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var frame:int;
      
      public function FoodActivityFrame()
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
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:* = undefined;
         var _loc10_:* = null;
         var _loc11_:* = null;
         this._bg = ComponentFactory.Instance.creat("foodActivity.bg");
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("foodActivity.helpBtn");
         addToContent(this._helpBtn);
         this._progress = ComponentFactory.Instance.creat("foodActivity.progress");
         addToContent(this._progress);
         this._sp = new Sprite();
         this._sp.x = this._progress.x;
         this._sp.y = this._progress.y;
         this._sp.graphics.beginFill(16777215,0);
         this._sp.graphics.drawRect(0,0,this._progress.width,this._progress.height);
         this._sp.graphics.endFill();
         this._progress.cacheAsBitmap = true;
         this._progress.mask = this._sp;
         addToContent(this._sp);
         this._boxArr = new Vector.<FoodActivityBox>();
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new FoodActivityBox();
            _loc2_.play(1);
            _loc2_.x = 237 + 93 * (_loc1_ - 1);
            _loc2_.y = 110;
            addToContent(_loc2_);
            this._boxArr.push(_loc2_);
            _loc1_++;
         }
         this._boxNumTxtArr = new Vector.<FilterFrameText>();
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("foodActivity.boxNumTxt");
            _loc4_.x = 151 + 93 * _loc3_;
            _loc4_.y = 152;
            addToContent(_loc4_);
            this._boxNumTxtArr.push(_loc4_);
            _loc3_++;
         }
         this._ripeTxt = ComponentFactory.Instance.creatComponentByStylename("foodActivity.ripeTxt");
         addToContent(this._ripeTxt);
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("foodActivity.countTxt");
         addToContent(this._countTxt);
         this._countBg = ComponentFactory.Instance.creat("foodActivity.countBg");
         addToContent(this._countBg);
         this._boxMc = ComponentFactory.Instance.creat("foodActivity.box.mc");
         this._boxMc.x = 334;
         this._boxMc.y = 194;
         this._boxMc.gotoAndStop(1);
         addToContent(this._boxMc);
         this._getAwardBtn = ComponentFactory.Instance.creat("foodActivity.getAward.btn");
         this._getAwardBtn.visible = false;
         this._getAwardBtn.x = 326;
         this._getAwardBtn.y = 205;
         addToContent(this._getAwardBtn);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("foodActivity.buttonBackBg");
         addToContent(this._btnBg);
         this._simpleBtn = ComponentFactory.Instance.creatComponentByStylename("foodActivity.simpleBtn");
         addToContent(this._simpleBtn);
         this._payBtn = ComponentFactory.Instance.creatComponentByStylename("foodActivity.payBtn");
         addToContent(this._payBtn);
         this._data = FoodActivityManager.Instance.info;
         if(!this._data)
         {
            return;
         }
         _loc5_ = 0;
         while(_loc5_ < this._boxArr.length)
         {
            if(!this._boxArr[_loc5_].tipData)
            {
               _loc6_ = "";
               _loc7_ = 0;
               while(_loc7_ < this._data.giftbagArray[_loc5_].giftRewardArr.length)
               {
                  _loc8_ = this._data.giftbagArray[_loc5_].giftRewardArr[_loc7_];
                  _loc9_ = this._data.giftbagArray[_loc5_].giftConditionArr;
                  _loc10_ = ItemManager.Instance.getTemplateById(_loc8_.templateId).Name;
                  _loc6_ += _loc10_ + "x" + _loc8_.count + (_loc7_ == this._data.giftbagArray[_loc5_].giftRewardArr.length - 1 ? "" : "、\n");
                  _loc7_++;
               }
               _loc11_ = {};
               _loc11_.content = LanguageMgr.GetTranslation("foodActivity.boxTipTxt",_loc9_[0].conditionValue,_loc9_[1].conditionValue);
               _loc11_.awards = _loc6_;
               this._boxArr[_loc5_].tipStyle = "foodActivity.view.FoodActivityTip";
               this._boxArr[_loc5_].tipDirctions = "2,1";
               this._boxArr[_loc5_].tipData = _loc11_;
            }
            _loc5_++;
         }
         this.updateProgress();
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
         this._simpleBtn.addEventListener("click",this.__simpleHandler);
         this._payBtn.addEventListener("click",this.__payHandler);
         this._boxMc.addEventListener("click",this.__getAwardHandler);
         this._helpBtn.addEventListener("click",this.__helpHandler);
      }
      
      protected function __helpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("foodActivity.frame.HelpPrompt" + this._data.activityChildType);
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("foodActivity.frame.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(_loc3_,3,true,1);
      }
      
      public function updateProgress() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc4_ in this._boxArr)
         {
            _loc4_.play(1);
         }
         this._giftState = 0;
         _loc5_ = [];
         _loc1_ = 0;
         while(_loc1_ < this._data.giftbagArray.length)
         {
            _loc5_.push(this._data.giftbagArray[_loc1_].giftConditionArr[0].conditionValue);
            _loc1_++;
         }
         var _loc6_:int = int(_loc5_[4]);
         var _loc7_:int = FoodActivityManager.Instance.ripeNum + this._defaultRipeNum;
         if(_loc7_ == this._defaultRipeNum)
         {
            this._sp.width = this._defaultLength;
         }
         else if(_loc7_ < _loc6_)
         {
            _loc2_ = 1;
            while(_loc2_ < _loc5_.length)
            {
               if(_loc7_ < _loc5_[_loc2_])
               {
                  this._giftState = 1 << _loc2_ - 1;
                  this._boxArr[_loc2_ - 1].play(2);
                  this._sp.width = this._defaultLength + int(93 * ((_loc7_ - _loc5_[_loc2_ - 1]) / (_loc5_[_loc2_] - _loc5_[_loc2_ - 1]) + _loc2_ - 1));
                  break;
               }
               _loc2_++;
            }
         }
         else
         {
            this._giftState = 16;
            this._boxArr[this._boxArr.length - 1].play(2);
            this._sp.width = this._progress.width;
         }
         this._boxMc.mouseEnabled = this._boxMc.mouseChildren = this._boxMc.buttonMode = this._getAwardBtn.visible = this._giftState != 0;
         this._boxNumTxtArr[0].text = (_loc5_[0] - 1).toString();
         _loc3_ = 1;
         while(_loc3_ < this._boxNumTxtArr.length - 1)
         {
            this._boxNumTxtArr[_loc3_].text = _loc5_[_loc3_];
            _loc3_++;
         }
         this._boxNumTxtArr[4].text = "" + _loc6_;
         this._ripeTxt.text = "" + (FoodActivityManager.Instance.ripeNum + this._defaultRipeNum);
         this._countTxt.text = "" + FoodActivityManager.Instance.cookingCount;
      }
      
      protected function __simpleHandler(param1:MouseEvent) : void
      {
         if(!this.click())
         {
            return;
         }
         SocketManager.Instance.out.cooking(1);
      }
      
      protected function __payHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(!this.click())
         {
            return;
         }
         var _loc3_:String = LanguageMgr.GetTranslation("foodActivity.perfectCookingTxt",MONEY);
         _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc3_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,1,null,"SimpleAlert",30,true);
         _loc2_.moveEnable = false;
         _loc2_.addEventListener("response",this.__confirm);
      }
      
      protected function __confirm(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.playButtonSound();
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               _loc3_.removeEventListener("response",this.__confirm);
               ObjectUtils.disposeObject(_loc3_);
               return;
            }
            if(PlayerManager.Instance.Self.Money >= MONEY)
            {
               FoodActivityManager.Instance.ripeNum = this._defaultRipeNum;
               SocketManager.Instance.out.cooking(2);
            }
            else
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,2);
               _loc2_.addEventListener("response",this._response);
               ObjectUtils.disposeObject(_loc3_);
            }
         }
         _loc3_.removeEventListener("response",this.__confirm);
      }
      
      protected function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener("response",this._response);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function click() : Boolean
      {
         SoundManager.instance.playButtonSound();
         if(FoodActivityManager.Instance.cookingCount <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("foodActivity.noCookingCount"));
            return false;
         }
         if(this._giftState != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("foodActivity.canNotCooking"));
            return false;
         }
         return true;
      }
      
      public function updateBoxMc() : void
      {
         this._simpleBtn.enable = this._payBtn.enable = this._getAwardBtn.visible = false;
         this._boxMc.gotoAndStop(2);
         this._boxMc.y = 223;
         this._boxMc.addEventListener("enterFrame",this.__enterHandler);
      }
      
      public function failRewardUpdate() : void
      {
         this._boxMc.mouseEnabled = this._boxMc.mouseChildren = this._boxMc.buttonMode = true;
      }
      
      protected function __getAwardHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._boxMc.mouseEnabled = this._boxMc.mouseChildren = this._boxMc.buttonMode = false;
         SocketManager.Instance.out.cookingGetAward(this._giftState);
      }
      
      protected function __enterHandler(param1:Event) : void
      {
         ++this.frame;
         if(this.frame >= 120)
         {
            this.frame = 0;
            this._simpleBtn.enable = this._payBtn.enable = true;
            this._boxMc.removeEventListener("enterFrame",this.__enterHandler);
            this._boxMc.gotoAndStop(1);
            this._boxMc.y = 194;
            this.updateProgress();
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            FoodActivityControl.Instance.disposeFrame();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
         this._simpleBtn.removeEventListener("click",this.__simpleHandler);
         this._payBtn.removeEventListener("click",this.__payHandler);
         this._boxMc.removeEventListener("click",this.__getAwardHandler);
         this._helpBtn.removeEventListener("click",this.__helpHandler);
      }
      
      override public function dispose() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.removeEvent();
         for each(_loc1_ in this._boxArr)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         this._boxArr = null;
         for each(_loc2_ in this._boxNumTxtArr)
         {
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
         this._boxNumTxtArr = null;
         this._boxMc.removeEventListener("enterFrame",this.__enterHandler);
         this._boxMc.parent.removeChild(this._boxMc);
         this._boxMc = null;
         this._getAwardBtn.parent.removeChild(this._getAwardBtn);
         this._getAwardBtn = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._progress);
         this._progress = null;
         ObjectUtils.disposeObject(this._countBg);
         this._countBg = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._simpleBtn);
         this._simpleBtn = null;
         ObjectUtils.disposeObject(this._payBtn);
         this._payBtn = null;
         ObjectUtils.disposeObject(this._ripeTxt);
         this._ripeTxt = null;
         ObjectUtils.disposeObject(this._countTxt);
         this._countTxt = null;
         this._sp.graphics.clear();
         ObjectUtils.disposeObject(this._sp);
         this._sp = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         super.dispose();
      }
   }
}

