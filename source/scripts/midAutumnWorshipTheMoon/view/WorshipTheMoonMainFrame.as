package midAutumnWorshipTheMoon.view
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.utils.ItemCellEffectMngr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonAwardsBoxInfo;
   import midAutumnWorshipTheMoon.model.WorshipTheMoonModel;
   import shop.view.ShopItemCell;
   
   public class WorshipTheMoonMainFrame extends Frame implements Disposeable
   {
      
      private var _model:WorshipTheMoonModel;
      
      private var _bg:Bitmap;
      
      private var _animationWorshipTheMoon:MovieClip;
      
      private var _listShiningMoonList:Vector.<DisplayObject>;
      
      private var _buyOnceBtn:SimpleBitmapButton;
      
      private var _buyTenTimesBtn:SimpleBitmapButton;
      
      private var _timesRemainTitle:Bitmap;
      
      private var _timesRemainTxt:FilterFrameText;
      
      private var _listAwardsMaybeGain:Vector.<BagCell>;
      
      private var _coolShiningFor200TimesItem:MovieClip;
      
      private var _awardsAfter200times:ShopItemCell;
      
      private var _gained200:Bitmap;
      
      private var _tipClickToGain200:Bitmap;
      
      private var _timesUsed:FilterFrameText;
      
      private var _ruleDetails:FilterFrameText;
      
      private var _panel:ScrollPanel;
      
      private var _timesGoingToWorship:int = 0;
      
      public function WorshipTheMoonMainFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         super.init();
         titleText = LanguageMgr.GetTranslation("worshipTheMoon.main.title");
         this._bg = ComponentFactory.Instance.creat("worshipTheMoon.BG");
         addToContent(this._bg);
         this._animationWorshipTheMoon = ComponentFactory.Instance.creat("worshipTheMoon.mc.shining");
         PositionUtils.setPos(this._animationWorshipTheMoon,"worshipTheMoon.pt.animation");
         this._animationWorshipTheMoon.mouseChildren = false;
         this._animationWorshipTheMoon.mouseEnabled = false;
         this._animationWorshipTheMoon.gotoAndStop(this._animationWorshipTheMoon.totalFrames);
         addToContent(this._animationWorshipTheMoon);
         this._listShiningMoonList = new Vector.<DisplayObject>();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            this._listShiningMoonList[_loc1_] = this._animationWorshipTheMoon.getChildByName("mn" + (_loc1_ + 1).toString());
            this._listShiningMoonList[_loc1_].visible = false;
            _loc1_++;
         }
         this._buyOnceBtn = ComponentFactory.Instance.creat("worshipTheMoon.btn.buyOnce");
         addToContent(this._buyOnceBtn);
         this._buyTenTimesBtn = ComponentFactory.Instance.creat("worshipTheMoon.btn.buyTenTimes");
         addToContent(this._buyTenTimesBtn);
         this._timesRemainTitle = ComponentFactory.Instance.creatBitmap("worshipTheMoon.bm.timesRemainTitle");
         addToContent(this._timesRemainTitle);
         this._timesRemainTxt = ComponentFactory.Instance.creat("worshipTheMoon.txt.TimesRemain");
         this._timesRemainTxt.mouseEnabled = false;
         addToContent(this._timesRemainTxt);
         this._listAwardsMaybeGain = new Vector.<BagCell>();
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            this._listAwardsMaybeGain[_loc1_] = new BagCell(0);
            this._listAwardsMaybeGain[_loc1_].x = 624 + _loc1_ % 4 * 50;
            this._listAwardsMaybeGain[_loc1_].y = 80 + int(_loc1_ / 4) * 50;
            addToContent(this._listAwardsMaybeGain[_loc1_]);
            _loc1_++;
         }
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawRect(0,0,60,60);
         _loc2_.graphics.endFill();
         this._awardsAfter200times = new ShopItemCell(_loc2_);
         PositionUtils.setPos(this._awardsAfter200times,"worshipTheMoon.pt.on200");
         this._awardsAfter200times.useHandCursor = true;
         this._awardsAfter200times.buttonMode = true;
         this._awardsAfter200times.cellSize = 60;
         this._awardsAfter200times.setContentSize(60,60);
         addToContent(this._awardsAfter200times);
         this._coolShiningFor200TimesItem = ComponentFactory.Instance.creat("asset.core.icon.coolShining");
         this._coolShiningFor200TimesItem = ItemCellEffectMngr.getEffect(this._awardsAfter200times,ItemCellEffectMngr.EFFECT_RUN_AROUND,ItemCellEffectMngr.SIZE_SHOP_ITEM_CELL);
         this._coolShiningFor200TimesItem.alpha = 0.7;
         addToContent(this._coolShiningFor200TimesItem);
         this._gained200 = ComponentFactory.Instance.creatBitmap("worship.alreadyGet");
         this._tipClickToGain200 = ComponentFactory.Instance.creatBitmap("worshipTheMoon.clickToGain");
         this._timesUsed = ComponentFactory.Instance.creat("worshipTheMoon.txt.TimesUsed");
         this._timesUsed.mouseEnabled = false;
         addToContent(this._timesUsed);
         this._ruleDetails = ComponentFactory.Instance.creat("worshipTheMoon.txt.details");
         this._ruleDetails.mouseEnabled = false;
         this._ruleDetails.text = LanguageMgr.GetTranslation("worshipTheMoon.Details",ServerConfigManager.instance.worshipMoonBeginDate,ServerConfigManager.instance.worshipMoonEndDate);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("worshipTheMoon.scrollpanel");
         this._panel.setView(this._ruleDetails);
         this._panel.invalidateViewport(false);
         addToContent(this._panel);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.onFrameClick);
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._awardsAfter200times.addEventListener(MouseEvent.CLICK,this.on200AwardsBoxClick);
      }
      
      protected function on200AwardsBoxClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._model.canGain200AwardsBox();
         if(_loc2_ == 2)
         {
            WorshipTheMoonManager.getInstance().requireWorship200AwardBox();
         }
      }
      
      protected function onFrameClick(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this._buyOnceBtn:
               SoundManager.instance.play("008");
               this._timesGoingToWorship = 1;
               this.showConfirmFrame(this._timesGoingToWorship);
               break;
            case this._buyTenTimesBtn:
               SoundManager.instance.play("008");
               this._timesGoingToWorship = 10;
               this.showConfirmFrame(this._timesGoingToWorship);
         }
      }
      
      private function getPrice() : int
      {
         return WorshipTheMoonModel.getInstance().getNeedMoney(this._timesGoingToWorship);
      }
      
      public function showConfirmFrame(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:int = WorshipTheMoonModel.getInstance().getNeedMoneyTimes(param1);
         var _loc4_:Boolean = PlayerManager.Instance.Self.Money < WorshipTheMoonModel.getInstance().getNeedMoney(_loc3_);
         var _loc5_:Boolean = PlayerManager.Instance.Self.BandMoney < WorshipTheMoonModel.getInstance().getNeedMoney(_loc3_);
         var _loc6_:Boolean = WorshipTheMoonModel.getInstance().getIsOnceBtnUseBindMoney();
         var _loc7_:Boolean = WorshipTheMoonModel.getInstance().getIsTensBtnUseBindMoney();
         if(param1 == 1)
         {
            if(_loc6_)
            {
               WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            }
            else if(!_loc6_ && _loc4_)
            {
               WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            }
         }
         else if(_loc7_)
         {
            WorshipTheMoonModel.getInstance().tensBtnShowTipsAgain();
         }
         else if(!_loc7_ && _loc4_)
         {
            WorshipTheMoonModel.getInstance().tensBtnShowTipsAgain();
         }
         if(param1 == 1)
         {
            _loc2_ = WorshipTheMoonModel.getInstance().getIsOnceBtnShowBuyTipThisLogin();
         }
         else
         {
            _loc2_ = WorshipTheMoonModel.getInstance().getIsTensBtnShowBuyTipThisLogin();
         }
         if(_loc3_ <= 0 || !_loc2_)
         {
            this.disableBtns();
            WorshipTheMoonManager.getInstance().requireWorshipTheMoon(param1);
            return;
         }
         var _loc8_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("worshipTheMoon.thisIsCostMoney",this.getPrice(),String(param1)),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,false,2);
         _loc8_.moveEnable = false;
         _loc8_.addEventListener(FrameEvent.RESPONSE,this.comfirmHandler,false,0,true);
      }
      
      private function comfirmHandler(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         var _loc4_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc4_.removeEventListener(FrameEvent.RESPONSE,this.comfirmHandler);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = this.getPrice();
            if(_loc4_.isBand && PlayerManager.Instance.Self.BandMoney < _loc2_)
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("sevenDouble.game.useSkillNoEnoughReConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.BLCAK_BLOCKGOUND);
               _loc3_.moveEnable = false;
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.reConfirmHandler,false,0,true);
               return;
            }
            if(!_loc4_.isBand && PlayerManager.Instance.Self.Money < _loc2_)
            {
               if(this._timesGoingToWorship == 1)
               {
                  WorshipTheMoonModel.getInstance().onceBtnNotShowBuyTipsAgainThisLogin(true);
               }
               else
               {
                  WorshipTheMoonModel.getInstance().tensBtnNotShowBuyTipsAgainThisLogin(true);
               }
               LeavePageManager.showFillFrame();
               return;
            }
            if(this._timesGoingToWorship == 1)
            {
               WorshipTheMoonModel.getInstance().updateIsOnceBtnUseBindMoney(_loc4_.isBand);
            }
            else
            {
               WorshipTheMoonModel.getInstance().updateIsTensBtnUseBindMoney(_loc4_.isBand);
            }
            WorshipTheMoonManager.getInstance().requireWorshipTheMoon(this._timesGoingToWorship);
            this._timesGoingToWorship = 0;
         }
      }
      
      private function reConfirmHandler(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         if(this._timesGoingToWorship == 1)
         {
            WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            WorshipTheMoonModel.getInstance().updateIsOnceBtnUseBindMoney(false);
         }
         else
         {
            WorshipTheMoonModel.getInstance().onceBtnShowTipsAgain();
            WorshipTheMoonModel.getInstance().updateIsTensBtnUseBindMoney(false);
         }
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.reConfirmHandler);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc2_ = this.getPrice();
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            WorshipTheMoonManager.getInstance().requireWorshipTheMoon(this._timesGoingToWorship);
            this._timesGoingToWorship = 0;
         }
      }
      
      public function updateTimesRemains() : void
      {
         if(Boolean(this._timesRemainTxt))
         {
            this._timesRemainTxt.text = this._model.getTimesRemain().toString();
         }
      }
      
      public function updateUsedTimes() : void
      {
         if(Boolean(this._timesUsed))
         {
            this._timesUsed.text = this._model.getUsedTimes().toString();
         }
      }
      
      public function updateAwardItemsCanGainList() : void
      {
         var _loc1_:Vector.<int> = this._model.getItemsCanGainsIDList();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._listAwardsMaybeGain[_loc3_].info = ItemManager.Instance.getTemplateById(_loc1_[_loc3_]);
            _loc3_++;
         }
      }
      
      public function update200TimesGains() : void
      {
         if(this._awardsAfter200times == null)
         {
            return;
         }
         this._awardsAfter200times.info = ItemManager.Instance.getTemplateById(this._model.get200TimesGainsID());
         var _loc1_:int = this._model.canGain200AwardsBox();
         switch(_loc1_)
         {
            case 1:
               this._awardsAfter200times.filters = [];
               this._coolShiningFor200TimesItem.play();
               this._coolShiningFor200TimesItem.visible = true;
               this._tipClickToGain200.parent && this._awardsAfter200times.removeChild(this._tipClickToGain200);
               this._gained200.parent && this._awardsAfter200times.removeChild(this._gained200);
               break;
            case 2:
               this._awardsAfter200times.filters = [];
               this._coolShiningFor200TimesItem.play();
               this._coolShiningFor200TimesItem.visible = true;
               this._awardsAfter200times.addChild(this._tipClickToGain200);
               this._gained200.parent && this._awardsAfter200times.removeChild(this._gained200);
         }
      }
      
      public function playTenTimesAnimation() : void
      {
         this.disableBtns();
         if(this._animationWorshipTheMoon == null)
         {
            return;
         }
         this._animationWorshipTheMoon.addEventListener("show_result",this.timeToLightAll);
         this._animationWorshipTheMoon.gotoAndPlay(1);
      }
      
      protected function timeToLightAll(param1:Event) : void
      {
         var len:int;
         var i:int;
         var e:Event = param1;
         var onComplete:Function = null;
         var temp:DisplayObject = null;
         onComplete = function(param1:DisplayObject):void
         {
            param1.visible = false;
         };
         this._animationWorshipTheMoon.removeEventListener("show_result",this.timeToLightAll);
         len = int(this._listShiningMoonList.length);
         i = 0;
         while(i < len)
         {
            this._listShiningMoonList[i].alpha = 0;
            this._listShiningMoonList[i].visible = true;
            temp = this._listShiningMoonList[i];
            TweenMax.to(this._listShiningMoonList[i],0.5,{
               "alpha":1,
               "yoyo":true,
               "repeat":3,
               "onComplete":onComplete,
               "onCompleteParams":[temp]
            });
            i++;
         }
         setTimeout(this.showGainsAwardsAndresetBtns,3100);
      }
      
      public function playOnceAnimation() : void
      {
         this.disableBtns();
         if(this._animationWorshipTheMoon == null)
         {
            return;
         }
         this._animationWorshipTheMoon.addEventListener("show_result",this.timeToLightTheMoon);
         this._animationWorshipTheMoon.gotoAndPlay(1);
      }
      
      protected function timeToLightTheMoon(param1:Event) : void
      {
         var len:int;
         var i:int;
         var moonType:int = 0;
         var e:Event = param1;
         moonType = 0;
         var onComplete:Function = null;
         onComplete = function():void
         {
            _listShiningMoonList[moonType].visible = false;
            showNotification();
            resetBtns();
         };
         this._animationWorshipTheMoon.removeEventListener("show_result",this.timeToLightTheMoon);
         len = int(this._listShiningMoonList.length);
         moonType = this._model.getCurrentMoonType() - 1;
         i = 0;
         while(i < len)
         {
            this._listShiningMoonList[i].visible = false;
            i++;
         }
         this._listShiningMoonList[moonType].alpha = 0;
         this._listShiningMoonList[moonType].visible = true;
         TweenMax.to(this._listShiningMoonList[moonType],0.5,{
            "alpha":1,
            "yoyo":true,
            "repeat":3,
            "onComplete":onComplete
         });
      }
      
      private function disableBtns() : void
      {
         if(_closeButton == null)
         {
            return;
         }
         escEnable = false;
         _closeButton.enable = false;
         _closeButton.mouseEnabled = false;
         _closeButton.mouseChildren = false;
         this._buyOnceBtn.enable = false;
         this._buyOnceBtn.mouseEnabled = false;
         this._buyOnceBtn.mouseChildren = false;
         this._buyTenTimesBtn.enable = false;
         this._buyTenTimesBtn.mouseEnabled = false;
         this._buyTenTimesBtn.mouseChildren = false;
      }
      
      private function showGainsAwardsAndresetBtns() : void
      {
         this.showGainsAwards();
         this.resetBtns();
      }
      
      private function resetBtns() : void
      {
         escEnable = true;
         if(_closeButton != null)
         {
            _closeButton.enable = true;
            _closeButton.mouseChildren = true;
            _closeButton.mouseEnabled = true;
         }
         if(this._buyOnceBtn != null)
         {
            this._buyOnceBtn.enable = true;
            this._buyOnceBtn.mouseEnabled = true;
            this._buyOnceBtn.mouseChildren = true;
         }
         if(this._buyTenTimesBtn != null)
         {
            this._buyTenTimesBtn.enable = true;
            this._buyTenTimesBtn.mouseEnabled = true;
            this._buyTenTimesBtn.mouseChildren = true;
         }
      }
      
      private function showNotification() : void
      {
         var _loc1_:ItemTemplateInfo = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Vector.<WorshipTheMoonAwardsBoxInfo> = WorshipTheMoonModel.getInstance().getAwardsGainedBoxInfoList();
         var _loc5_:ItemManager = ItemManager.Instance;
         var _loc6_:int = int(_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = WorshipTheMoonAwardsBoxInfo.getMoonName(_loc4_[_loc7_].moonType);
            _loc3_ = WorshipTheMoonAwardsBoxInfo.getCakeName(_loc4_[_loc7_].moonType);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("worshipTheMoon.notification",_loc2_,_loc3_),0,true,3);
            _loc7_++;
         }
      }
      
      private function showGainsAwards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Vector.<WorshipTheMoonAwardsBoxInfo> = WorshipTheMoonModel.getInstance().getAwardsGainedBoxInfoList();
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:ItemManager = ItemManager.Instance;
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc3_[_loc1_] = {
               "info":_loc6_.getTemplateById(_loc4_[_loc1_].id),
               "count":1
            };
            _loc1_++;
         }
         var _loc7_:Array = new Array();
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc2_ = 0;
            while(true)
            {
               if(_loc2_ >= _loc7_.length)
               {
                  _loc7_.push(_loc3_[_loc1_]);
                  break;
               }
               if(_loc3_[_loc1_].info.TemplateID == _loc7_[_loc2_].info.TemplateID)
               {
                  ++_loc7_[_loc2_].count;
                  break;
               }
               _loc2_++;
            }
            _loc1_++;
         }
         BagAndInfoManager.Instance.showPreviewFrame(LanguageMgr.GetTranslation("worshipTheMoon.preview.title"),_loc7_);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this._awardsAfter200times != null && this._awardsAfter200times.removeEventListener(MouseEvent.CLICK,this.on200AwardsBoxClick);
         this.removeEventListener(MouseEvent.CLICK,this.onFrameClick);
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._animationWorshipTheMoon.removeEventListener("show_result",this.timeToLightAll);
         if(this._bg != null)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         this._listShiningMoonList.length = 0;
         this._listShiningMoonList = null;
         if(this._animationWorshipTheMoon != null)
         {
            this._animationWorshipTheMoon.gotoAndStop(1);
            _loc1_ = this._animationWorshipTheMoon.numChildren;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if(this._animationWorshipTheMoon.getChildAt(_loc2_) is MovieClip)
               {
                  (this._animationWorshipTheMoon.getChildAt(_loc2_) as MovieClip).stop();
               }
               _loc2_++;
            }
            ObjectUtils.disposeObject(this._animationWorshipTheMoon);
            this._animationWorshipTheMoon = null;
         }
         if(this._listAwardsMaybeGain != null)
         {
            this._listAwardsMaybeGain.length = 0;
            this._listAwardsMaybeGain = null;
         }
         if(this._buyOnceBtn != null)
         {
            ObjectUtils.disposeObject(this._buyOnceBtn);
            this._buyOnceBtn = null;
         }
         if(this._buyTenTimesBtn != null)
         {
            ObjectUtils.disposeObject(this._buyTenTimesBtn);
            this._buyTenTimesBtn = null;
         }
         if(this._timesRemainTitle != null)
         {
            ObjectUtils.disposeObject(this._timesRemainTitle);
            this._timesRemainTitle = null;
         }
         if(this._timesRemainTxt != null)
         {
            ObjectUtils.disposeObject(this._timesRemainTxt);
            this._timesRemainTxt = null;
         }
         if(this._listAwardsMaybeGain != null)
         {
            this._listAwardsMaybeGain.length = 0;
            this._listAwardsMaybeGain = null;
         }
         if(this._awardsAfter200times != null)
         {
            ObjectUtils.disposeObject(this._awardsAfter200times);
            this._awardsAfter200times = null;
         }
         if(this._coolShiningFor200TimesItem != null)
         {
            this._coolShiningFor200TimesItem.stop();
            ObjectUtils.disposeObject(this._coolShiningFor200TimesItem);
            this._coolShiningFor200TimesItem = null;
         }
         if(this._gained200 != null)
         {
            ObjectUtils.disposeObject(this._gained200);
            this._gained200 = null;
         }
         if(this._panel != null)
         {
            ObjectUtils.disposeObject(this._panel);
            this._panel = null;
         }
         if(this._timesUsed != null)
         {
            ObjectUtils.disposeObject(this._timesUsed);
            this._timesUsed = null;
         }
         if(this._ruleDetails != null)
         {
            ObjectUtils.disposeObject(this._ruleDetails);
            this._ruleDetails = null;
         }
         if(this._tipClickToGain200 != null)
         {
            ObjectUtils.disposeObject(this._tipClickToGain200);
            this._tipClickToGain200 = null;
         }
         if(_closeButton != null)
         {
            ObjectUtils.disposeObject(_closeButton);
            _closeButton = null;
         }
         super.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         SoundManager.instance.play("008");
         WorshipTheMoonManager.getInstance().disposeMainFrame();
      }
      
      public function set model(param1:WorshipTheMoonModel) : void
      {
         this._model = param1;
      }
   }
}

