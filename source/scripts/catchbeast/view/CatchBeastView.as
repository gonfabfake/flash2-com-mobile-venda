package catchbeast.view
{
   import baglocked.BaglockedManager;
   import catchbeast.CatchBeastManager;
   import catchbeast.date.CatchBeastInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.GameManager;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   
   public class CatchBeastView extends Frame
   {
      
      private static var AWARD_NUM:int = 5;
      
      private var _progressInfo:Array = [{
         "damage":0,
         "pos":0
      },{
         "damage":5,
         "pos":104
      },{
         "damage":20,
         "pos":187
      },{
         "damage":50,
         "pos":270
      },{
         "damage":100,
         "pos":353
      },{
         "damage":200,
         "pos":436
      }];
      
      private var _bg:Bitmap;
      
      private var _helpBtn:BaseButton;
      
      private var _challengeBtn:BaseButton;
      
      private var _challengeNumText:FilterFrameText;
      
      private var _buyBuffBtn:BaseButton;
      
      private var _buyBuffNumText:FilterFrameText;
      
      private var _beastMovie:MovieImage;
      
      private var _progress:ScaleFrameImage;
      
      private var _progressSense:Sprite;
      
      private var _progressTips:OneLineTip;
      
      private var _damageInfo:FilterFrameText;
      
      private var _progressMask:Sprite;
      
      private var _careInfo:FilterFrameText;
      
      private var _getAwardVec:Vector.<MovieImage>;
      
      private var _info:CatchBeastInfo;
      
      public function CatchBeastView()
      {
         super();
         this._info = new CatchBeastInfo();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initView() : void
      {
         var _loc2_:MovieImage = null;
         var _loc1_:Point = null;
         _loc2_ = null;
         titleText = LanguageMgr.GetTranslation("catchBeast.view.Title");
         this._bg = ComponentFactory.Instance.creat("catchBeast.view.bg");
         addToContent(this._bg);
         this._helpBtn = ComponentFactory.Instance.creat("catchBeast.view.helpBtn");
         addToContent(this._helpBtn);
         this._beastMovie = ComponentFactory.Instance.creat("catchBeast.view.beastMovie");
         addToContent(this._beastMovie);
         this._damageInfo = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.damageText");
         addToContent(this._damageInfo);
         this._progress = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.progressImage");
         addToContent(this._progress);
         this._progressTips = new OneLineTip();
         addToContent(this._progressTips);
         this._progressTips.x = this._progress.x;
         this._progressTips.y = this._progress.y - this._progress.height;
         this._progressTips.visible = false;
         this._challengeBtn = ComponentFactory.Instance.creat("catchBeast.view.challengeBtn");
         this._challengeBtn.tipData = LanguageMgr.GetTranslation("catchBeast.view.challengeTips");
         addToContent(this._challengeBtn);
         this._challengeNumText = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.challengeNum");
         this._challengeBtn.addChild(this._challengeNumText);
         this._buyBuffBtn = ComponentFactory.Instance.creat("catchBeast.view.buyBuffBtn");
         this._buyBuffBtn.tipData = LanguageMgr.GetTranslation("catchBeast.view.buyBuffTips");
         addToContent(this._buyBuffBtn);
         this._buyBuffNumText = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.buyBuffNum");
         this._buyBuffBtn.addChild(this._buyBuffNumText);
         this.createProgressMask();
         this.createProgressSense();
         this._careInfo = ComponentFactory.Instance.creatComponentByStylename("catchBeast.view.careInfoText");
         this._careInfo.text = LanguageMgr.GetTranslation("catchBeast.view.careInfo");
         addToContent(this._careInfo);
         this._getAwardVec = new Vector.<MovieImage>();
         _loc1_ = PositionUtils.creatPoint("catchBeast.view.awardPos");
         var _loc3_:int = 0;
         while(_loc3_ < AWARD_NUM)
         {
            _loc2_ = ComponentFactory.Instance.creat("catchBeast.view.getAwardMovie");
            _loc2_.id = _loc3_;
            _loc2_.x = _loc1_.x + _loc3_ * 83;
            _loc2_.y = _loc1_.y;
            addToContent(_loc2_);
            _loc2_.movie.gotoAndStop(1);
            this._getAwardVec.push(_loc2_);
            _loc3_++;
         }
      }
      
      private function createProgressSense() : void
      {
         this._progressSense = new Sprite();
         this._progressSense.graphics.beginFill(0,0);
         this._progressSense.graphics.drawRect(0,0,this._progress.width,this._progress.height);
         this._progressSense.graphics.endFill();
         this._progressSense.buttonMode = true;
         PositionUtils.setPos(this._progressSense,this._progress);
         addToContent(this._progressSense);
      }
      
      private function createProgressMask() : void
      {
         this._progressMask = new Sprite();
         this._progressMask.graphics.beginFill(16777215);
         this._progressMask.graphics.drawRect(0,0,this._progress.width,this._progress.height);
         this._progressMask.graphics.endFill();
         this._progressMask.x = this._progress.x - this._progress.width;
         this._progressMask.y = this._progress.y;
         addToContent(this._progressMask);
         this._progress.mask = this._progressMask;
      }
      
      private function setProgressLength(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 >= this._progressInfo[5].damage * 1000)
         {
            param1 = this._progressInfo[5].damage * 1000;
         }
         var _loc3_:int = 1;
         while(_loc3_ < this._progressInfo.length)
         {
            if(param1 <= this._progressInfo[_loc3_].damage * 1000)
            {
               _loc2_ = (this._progressInfo[_loc3_].pos - this._progressInfo[_loc3_ - 1].pos) * (param1 - this._progressInfo[_loc3_ - 1].damage * 1000) / ((this._progressInfo[_loc3_].damage - this._progressInfo[_loc3_ - 1].damage) * 1000) + this._progressInfo[_loc3_ - 1].pos;
               break;
            }
            _loc3_++;
         }
         this._progressMask.x += _loc2_;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._challengeBtn.addEventListener(MouseEvent.CLICK,this.__onChallengeClick);
         this._buyBuffBtn.addEventListener(MouseEvent.CLICK,this.__onBuyBuffClick);
         this._progressSense.addEventListener(MouseEvent.MOUSE_OVER,this.__onProgressOver);
         this._progressSense.addEventListener(MouseEvent.MOUSE_OUT,this.__onProgressOut);
         CatchBeastManager.instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_VIEWINFO,this.__onSetViewInfo);
         CatchBeastManager.instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_GETAWARD,this.__onIsGetAward);
         CatchBeastManager.instance.addEventListener(CrazyTankSocketEvent.CATCHBEAST_BUYBUFF,this.__onIsBuyBuff);
         GameManager.Instance.addEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_1 = true;
      }
      
      protected function __onHelpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:DisplayObject = ComponentFactory.Instance.creat("catchBeast.HelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("catchBeast.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("store.view.HelpButtonText");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         StateManager.setState(StateType.ROOM_LOADING,GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      protected function __onSetViewInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         _loc2_ = param1.pkg;
         this._info.ChallengeNum = _loc2_.readInt();
         this._info.BuyBuffNum = _loc2_.readInt();
         this._info.BuffPrice = _loc2_.readInt();
         this._info.DamageNum = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._getAwardVec[_loc4_].tipData = new GoodTipInfo();
            this._getAwardVec[_loc4_].tipData.itemInfo = this.setAwardBoxInfo(_loc2_.readInt());
            InventoryItemInfo(this._getAwardVec[_loc4_].tipData.itemInfo).IsBinds = true;
            this._progressInfo[_loc4_ + 1].damage = _loc2_.readInt() / 10000;
            this._info.BoxState.push(_loc2_.readInt());
            _loc4_++;
         }
         this._challengeBtn.enable = this._info.ChallengeNum <= 0 ? Boolean(false) : Boolean(true);
         this._buyBuffBtn.enable = this._info.BuyBuffNum <= 0 ? Boolean(false) : Boolean(true);
         this._challengeNumText.text = LanguageMgr.GetTranslation("catchBeast.view.challengeNum",this._info.ChallengeNum);
         this._buyBuffNumText.text = LanguageMgr.GetTranslation("catchBeast.view.challengeNum",this._info.BuyBuffNum);
         this._damageInfo.text = LanguageMgr.GetTranslation("catchBeast.view.damageInfo",this._progressInfo[1].damage,this._progressInfo[2].damage,this._progressInfo[3].damage,this._progressInfo[4].damage,this._progressInfo[5].damage);
         this.setProgressTipNum(this._info.DamageNum);
         this.setProgressLength(this._info.DamageNum);
         this.setAwardBoxState();
      }
      
      private function setProgressTipNum(param1:int) : void
      {
         var _loc2_:String = param1.toString() + "/" + (this._progressInfo[this._progressInfo.length - 1].damage * 1000).toString();
         this._progressTips.tipData = LanguageMgr.GetTranslation("catchBeast.view.progressTips",_loc2_);
      }
      
      private function setAwardBoxState() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._info.BoxState.length)
         {
            if(this._info.BoxState[_loc1_] == 2)
            {
               this._getAwardVec[_loc1_].buttonMode = true;
               this._getAwardVec[_loc1_].addEventListener(MouseEvent.CLICK,this.__onGetAward);
            }
            this._getAwardVec[_loc1_].movie.gotoAndStop(this._info.BoxState[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function __onGetAward(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:MovieImage = param1.currentTarget as MovieImage;
         this._getAwardVec[_loc2_.id].removeEventListener(MouseEvent.CLICK,this.__onGetAward);
         SocketManager.Instance.out.sendCatchBeastGetAward(_loc2_.id);
      }
      
      protected function __onIsGetAward(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         if(_loc3_)
         {
            this._getAwardVec[_loc4_].movie.gotoAndStop(3);
            this._getAwardVec[_loc4_].buttonMode = false;
         }
      }
      
      private function setAwardBoxInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         return ItemManager.fill(_loc2_);
      }
      
      protected function __onProgressOver(param1:MouseEvent) : void
      {
         this._progressTips.visible = true;
      }
      
      protected function __onProgressOut(param1:MouseEvent) : void
      {
         this._progressTips.visible = false;
      }
      
      protected function __onBuyBuffClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("catchBeast.view.buyBuffInfoText",this._info.BuffPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertBuyBuff);
      }
      
      protected function __onIsBuyBuff(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         this._buyBuffBtn.enable = _loc3_ <= 0 ? Boolean(false) : Boolean(true);
         this._buyBuffNumText.text = LanguageMgr.GetTranslation("catchBeast.view.challengeNum",_loc3_);
      }
      
      protected function __onChallengeClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.playButtonSound();
         if(this._info.ChallengeNum < 0)
         {
            this._challengeBtn.enable = false;
         }
         else
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("catchBeast.view.challengeInofText"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.NOSELECTBTN);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__alertChallenge);
         }
      }
      
      protected function __alertChallenge(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__alertChallenge);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendCatchBeastChallenge();
         }
         _loc2_.dispose();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendCatchBeastViewInfo();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__onHelpClick);
         this._challengeBtn.removeEventListener(MouseEvent.CLICK,this.__onChallengeClick);
         this._buyBuffBtn.removeEventListener(MouseEvent.CLICK,this.__onBuyBuffClick);
         this._progressSense.removeEventListener(MouseEvent.MOUSE_OVER,this.__onProgressOver);
         this._progressSense.removeEventListener(MouseEvent.MOUSE_OUT,this.__onProgressOut);
         CatchBeastManager.instance.removeEventListener(CrazyTankSocketEvent.CATCHBEAST_VIEWINFO,this.__onSetViewInfo);
         CatchBeastManager.instance.removeEventListener(CrazyTankSocketEvent.CATCHBEAST_GETAWARD,this.__onIsGetAward);
         CatchBeastManager.instance.removeEventListener(CrazyTankSocketEvent.CATCHBEAST_BUYBUFF,this.__onIsBuyBuff);
         GameManager.Instance.removeEventListener(GameManager.START_LOAD,this.__startLoading);
         StateManager.getInGame_Step_8 = true;
      }
      
      protected function __alertBuyBuff(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         var _loc3_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc3_.removeEventListener(FrameEvent.RESPONSE,this.__alertBuyBuff);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  ObjectUtils.disposeObject(param1.currentTarget);
                  return;
               }
               if(_loc3_.isBand)
               {
                  if(!this.checkMoney(true))
                  {
                     _loc3_.dispose();
                     _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("buried.alertInfo.noBindMoney"),"",LanguageMgr.GetTranslation("cancel"),true,false,false,2);
                     _loc2_.addEventListener(FrameEvent.RESPONSE,this.onResponseHander);
                     return;
                  }
               }
               else if(!this.checkMoney(false))
               {
                  _loc3_.dispose();
                  _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
                  _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
                  return;
               }
               SocketManager.Instance.out.sendCatchBeastBuyBuff(_loc3_.isBand);
         }
         _loc3_.dispose();
      }
      
      private function onResponseHander(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.onResponseHander);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(!this.checkMoney(false))
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"),LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
               _loc2_.addEventListener(FrameEvent.RESPONSE,this._response);
               return;
            }
            SocketManager.Instance.out.sendCatchBeastBuyBuff(false);
         }
         param1.currentTarget.dispose();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function checkMoney(param1:Boolean) : Boolean
      {
         if(PlayerManager.Instance.Self.Money < this._info.BuffPrice)
         {
            return false;
         }
         return true;
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               CatchBeastManager.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._helpBtn))
         {
            this._helpBtn.dispose();
            this._helpBtn = null;
         }
         if(Boolean(this._progress))
         {
            this._progress.dispose();
            this._progress = null;
         }
         if(Boolean(this._challengeBtn))
         {
            this._challengeBtn.dispose();
            this._challengeBtn = null;
         }
         if(Boolean(this._challengeNumText))
         {
            this._challengeNumText.dispose();
            this._challengeNumText = null;
         }
         if(Boolean(this._buyBuffNumText))
         {
            this._buyBuffNumText.dispose();
            this._buyBuffNumText = null;
         }
         if(Boolean(this._beastMovie))
         {
            this._beastMovie.dispose();
            this._beastMovie = null;
         }
         if(Boolean(this._damageInfo))
         {
            this._damageInfo.dispose();
            this._damageInfo = null;
         }
         if(Boolean(this._getAwardVec))
         {
            _loc1_ = 0;
            while(_loc1_ < this._getAwardVec.length)
            {
               if(Boolean(this._getAwardVec[_loc1_]))
               {
                  this._getAwardVec[_loc1_].removeEventListener(MouseEvent.CLICK,this.__onGetAward);
                  this._getAwardVec[_loc1_].dispose();
                  this._getAwardVec[_loc1_] = null;
               }
               _loc1_++;
            }
            this._getAwardVec.length = 0;
            this._getAwardVec = null;
         }
         if(Boolean(this._progressTips))
         {
            this._progressTips.dispose();
            this._progressTips = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

