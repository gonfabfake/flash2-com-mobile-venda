package toyMachine.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.ComponentEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.HelperDataModuleLoad;
   import ddt.utils.PositionUtils;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.LookTrophy;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import road7th.comm.PackageIn;
   import trainer.view.NewHandContainer;
   
   public class ToyMachineItem extends Sprite implements Disposeable
   {
      
      private static var GrappleSilvelOne:int = ServerConfigManager.instance.getToyMachinePrice()[0];
      
      private static var GrappleSilvelTen:int = ServerConfigManager.instance.getToyMachinePrice()[1];
      
      private static var GrappleGoldOne:int = ServerConfigManager.instance.getToyMachinePrice()[2];
      
      private static var GrappleGoldTen:int = ServerConfigManager.instance.getToyMachinePrice()[3];
      
      private static var FreeCount:int = 10;
      
      private var _index:int;
      
      private var _rewardBtn:BaseButton;
      
      private var _machineBg:ScaleFrameImage;
      
      private var _tipsInfo:ScaleFrameImage;
      
      private var _grappleOneBtn:BaseButton;
      
      private var _grappleTenBtn:BaseButton;
      
      private var _countDown:FilterFrameText;
      
      private var _showPrize:LookTrophy;
      
      private var _grappleMovie:MovieClip;
      
      private var _timeSprite:Sprite;
      
      private var _freeCountBg:Image;
      
      private var _freeCountText:FilterFrameText;
      
      private var _freeCount:int = 0;
      
      private var _freeTime:Date;
      
      private var _freeTimeNum:Number;
      
      private var _time:Timer;
      
      private var _money:int;
      
      private var _rewardInfo:Array;
      
      private var _tenFlag:Boolean = false;
      
      private var _bigEgg:MovieClip;
      
      private var _smallEgg:MovieClip;
      
      private var _randIndex:int;
      
      private var _yinX1Text:FilterFrameText;
      
      private var _yinX10Text:FilterFrameText;
      
      private var _jinX1Text:FilterFrameText;
      
      private var _jinX10Text:FilterFrameText;
      
      public function ToyMachineItem(param1:int)
      {
         super();
         this._index = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._rewardBtn = ComponentFactory.Instance.creatComponentByStylename("toyMachine.rewardBtn" + this._index);
         addChild(this._rewardBtn);
         this._machineBg = ComponentFactory.Instance.creatComponentByStylename("toyMachine.machineBg");
         this._machineBg.setFrame(this._index);
         addChild(this._machineBg);
         this._grappleOneBtn = ComponentFactory.Instance.creatComponentByStylename("toyMachine.grappleOneBtn");
         addChild(this._grappleOneBtn);
         this._grappleTenBtn = ComponentFactory.Instance.creatComponentByStylename("toyMachine.grappleTenBtn");
         addChild(this._grappleTenBtn);
         this._tipsInfo = ComponentFactory.Instance.creatComponentByStylename("toyMachine.tipsInfo");
         this._tipsInfo.setFrame(this._index);
         addChild(this._tipsInfo);
         this._freeCountBg = ComponentFactory.Instance.creatComponentByStylename("toyMachine.freeCountBg");
         addChild(this._freeCountBg);
         this._freeCountText = ComponentFactory.Instance.creatComponentByStylename("toyMachine.freeNum");
         this._freeCountBg.addChild(this._freeCountText);
         if(this._index == 1)
         {
            this._yinX1Text = ComponentFactory.Instance.creatComponentByStylename("toyMachine.yinX1Text");
            this._yinX1Text.text = ServerConfigManager.instance.getToyMachinePrice()[0] + LanguageMgr.GetTranslation("moneySimple");
            addChild(this._yinX1Text);
            this._yinX10Text = ComponentFactory.Instance.creatComponentByStylename("toyMachine.yinX10Text");
            this._yinX10Text.text = ServerConfigManager.instance.getToyMachinePrice()[1] + LanguageMgr.GetTranslation("moneySimple");
            addChild(this._yinX10Text);
         }
         else
         {
            this._jinX1Text = ComponentFactory.Instance.creatComponentByStylename("toyMachine.jinX1Text");
            this._jinX1Text.text = ServerConfigManager.instance.getToyMachinePrice()[2] + LanguageMgr.GetTranslation("moneySimple");
            addChild(this._jinX1Text);
            this._jinX10Text = ComponentFactory.Instance.creatComponentByStylename("toyMachine.jinX10Text");
            this._jinX10Text.text = ServerConfigManager.instance.getToyMachinePrice()[3] + LanguageMgr.GetTranslation("moneySimple");
            addChild(this._jinX10Text);
         }
         this._timeSprite = new Sprite();
         addChild(this._timeSprite);
         var _loc1_:Bitmap = ComponentFactory.Instance.creat("asset.toyMachine.countdownBg");
         this._timeSprite.addChild(_loc1_);
         this._countDown = ComponentFactory.Instance.creatComponentByStylename("toyMachine.countDown");
         this._timeSprite.addChild(this._countDown);
         PositionUtils.setPos(this._timeSprite,"toyMachine.countDownPos");
      }
      
      private function initEvent() : void
      {
         this._rewardBtn.addEventListener("click",this.__onRewardClick);
         this._grappleOneBtn.addEventListener("click",this.__onGrappleOneClick);
         this._grappleTenBtn.addEventListener("click",this.__onGrappleTenClick);
      }
      
      public function setItemInfo(param1:Date, param2:int = 0) : void
      {
         this._freeCount = param2;
         this._freeTime = param1;
         this.updateInfo();
      }
      
      private function updateInfo() : void
      {
         if(this._index == 1)
         {
            this._freeTimeNum = (this._freeTime.time - TimeManager.Instance.Now().time) / 1000 + 600;
            if(this._freeTimeNum > 0)
            {
               if(this._freeCount == 10)
               {
                  this._freeTimeNum = 0;
               }
               this.beginCountDown(this._freeCount != 10);
            }
            else
            {
               this.beginCountDown(false);
            }
         }
         else if(this._index == 2)
         {
            this._freeTimeNum = (this._freeTime.time - TimeManager.Instance.Now().time) / 1000 + 252000;
            if(this._freeTimeNum > 0)
            {
               this._freeCount = 0;
               this.beginCountDown(true);
            }
            else
            {
               this._freeCount = 1;
               this.beginCountDown(false);
            }
         }
         this._freeCountText.text = this._freeCount.toString();
      }
      
      private function beginCountDown(param1:Boolean) : void
      {
         this._timeSprite.visible = param1;
         if(param1)
         {
            this._freeCountBg.setFrame(4);
            this._countDown.text = this.transSecond(this._freeTimeNum);
            if(this._time == null)
            {
               this._time = new Timer(1000);
               this._time.addEventListener("timer",this.__onUpdateCountDown);
            }
            this._time.start();
         }
         else
         {
            this._freeCountBg.setFrame(1);
            if(this._time != null)
            {
               this._time.stop();
               this._time.reset();
            }
         }
      }
      
      protected function __onUpdateCountDown(param1:TimerEvent) : void
      {
         --this._freeTimeNum;
         if(this._freeTimeNum >= 0)
         {
            this._countDown.text = this.transSecond(this._freeTimeNum);
         }
         else
         {
            this._time.stop();
            this._time.reset();
            this.updateInfo();
         }
      }
      
      private function transSecond(param1:Number) : String
      {
         var _loc2_:int = param1 / 3600;
         param1 -= _loc2_ * 3600;
         return String("0" + Math.floor(_loc2_)).substr(-2) + ":" + String("0" + Math.floor(param1 / 60)).substr(-2) + ":" + String("0" + Math.floor(param1 % 60)).substr(-2);
      }
      
      protected function __onGrappleOneClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.playButtonSound();
         this._randIndex = Math.random() * 5;
         this._tenFlag = false;
         if(this._freeTimeNum <= 0 && this._freeCount > 0)
         {
            SocketManager.Instance.out.sendToyMachineReward(this._index,1,false,false);
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this._index == 1 && PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11570) > 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("toyMachine.silver.useTicketText"));
               SocketManager.Instance.out.sendToyMachineReward(this._index,1,false,false);
            }
            else
            {
               this._money = this._index == 1 ? GrappleSilvelOne : int(GrappleGoldOne);
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.game.GameView.gypsyRMBTicketConfirm",this._money),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2,null,"SimpleAlert",60,false,1);
               _loc2_.addEventListener("response",this.__alertAllBack);
            }
         }
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(135))
         {
            if(PlayerManager.Instance.Self.Grade >= 25)
            {
               NewHandContainer.Instance.clearArrowByID(146);
               SocketManager.Instance.out.syncWeakStep(135);
            }
         }
      }
      
      protected function __onGrappleTenClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._randIndex = 4;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._tenFlag = true;
         this._money = this._index == 1 ? GrappleSilvelTen : int(GrappleGoldTen);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.game.GameView.gypsyRMBTicketConfirm",this._money),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2,null,"SimpleAlert",60,false,1);
         _loc2_.addEventListener("response",this.__alertAllBack);
      }
      
      private function __alertAllBack(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__alertAllBack);
         SoundManager.instance.playButtonSound();
         switch(int(param1.responseCode) - 2)
         {
            case 0:
            case 1:
               CheckMoneyUtils.instance.checkMoney(false,this._money,this.sendGetReward);
         }
         _loc2_.dispose();
      }
      
      private function sendGetReward() : void
      {
         SocketManager.Instance.out.sendToyMachineReward(this._index,this._tenFlag ? 10 : 1,true,CheckMoneyUtils.instance.isBind);
      }
      
      public function getReward(param1:PackageIn) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = param1.readByte();
         this._rewardInfo = [];
         while(Boolean(param1.bytesAvailable))
         {
            _loc2_ = new InventoryItemInfo();
            _loc2_.TemplateID = param1.readInt();
            _loc2_ = ItemManager.fill(_loc2_);
            _loc2_.Count = param1.readInt();
            _loc2_.IsBinds = param1.readBoolean();
            _loc2_.ValidDate = param1.readInt();
            _loc2_.StrengthenLevel = param1.readInt();
            _loc2_.AttackCompose = param1.readInt();
            _loc2_.DefendCompose = param1.readInt();
            _loc2_.AgilityCompose = param1.readInt();
            _loc2_.LuckCompose = param1.readInt();
            this._rewardInfo.push(_loc2_);
         }
         this.grappleMovie();
      }
      
      private function grappleMovie() : void
      {
         if(this._index == 1)
         {
            this._grappleMovie = ComponentFactory.Instance.creat("asset.toyMachine.silvelGrapple");
         }
         else if(this._index == 2)
         {
            this._grappleMovie = ComponentFactory.Instance.creat("asset.toyMachine.goldGrapple");
         }
         this._grappleMovie.y = 32;
         addChild(this._grappleMovie);
         this._grappleMovie.addEventListener("enterFrame",this.__onMovieFrame);
      }
      
      protected function __onMovieFrame(param1:Event) : void
      {
         if(this._grappleMovie.currentFrame == 41)
         {
            this._smallEgg = ComponentFactory.Instance.creat("asset.toyMachine.smallEggs" + this._randIndex);
            this._smallEgg.x = 153;
            this._smallEgg.y = 65;
            this._grappleMovie.addChild(this._smallEgg);
         }
         if(this._grappleMovie.currentFrame == 81)
         {
            if(Boolean(this._smallEgg))
            {
               this._grappleMovie.removeChild(this._smallEgg);
            }
            this._smallEgg = null;
            this._bigEgg = ComponentFactory.Instance.creat("asset.toyMachine.bigEggs" + this._randIndex);
            this._bigEgg.x = 79;
            this._bigEgg.y = 85;
            this._grappleMovie.addChild(this._bigEgg);
         }
         if(this._grappleMovie.currentFrame == this._grappleMovie.totalFrames)
         {
            this._grappleMovie.removeEventListener("enterFrame",this.__onMovieFrame);
            this._grappleMovie.stop();
            this._bigEgg["closeBtn"].addEventListener("click",this.__onCloseGrappleMovie);
            this.addRewardToMovie();
         }
      }
      
      private function addRewardToMovie() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = int(this._rewardInfo.length);
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            _loc3_ = Math.random() * _loc5_;
            _loc2_ = this._rewardInfo[_loc3_];
            this._rewardInfo[_loc3_] = this._rewardInfo[_loc1_];
            this._rewardInfo[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._rewardInfo.length)
         {
            _loc4_ = new BagCell(0,this._rewardInfo[_loc1_]);
            _loc4_.x = _loc1_ * _loc4_.width + 15;
            if(_loc1_ > 4)
            {
               _loc4_.x = (_loc1_ - 5) * _loc4_.width + 15;
               _loc4_.y = _loc4_.height + 5;
            }
            this._bigEgg["rewardSprite"].addChild(_loc4_);
            _loc1_++;
         }
         SocketManager.Instance.out.getToyMachineInfo();
      }
      
      private function __onCloseGrappleMovie(param1:MouseEvent) : void
      {
         if(Boolean(this._bigEgg) && Boolean(this._bigEgg["closeBtn"]))
         {
            this._bigEgg["closeBtn"].removeEventListener("click",this.__onCloseGrappleMovie);
         }
         if(this._grappleMovie != null)
         {
            this._grappleMovie.stop();
            removeChild(this._grappleMovie);
            ObjectUtils.disposeObject(this._grappleMovie);
            this._grappleMovie = null;
         }
      }
      
      protected function __onRewardClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         new HelperDataModuleLoad().loadDataModule([StartupResourceLoader.Instance.createCaddyAwardsLoader],this.lookTrophy);
      }
      
      private function lookTrophy() : void
      {
         this._showPrize = ComponentFactory.Instance.creatCustomObject("toyMachine.LookTrophy");
         this._showPrize.show(CaddyModel.instance.getCaddyTrophy(this._index == 1 ? 1222010 : 1222110));
         this._showPrize.addEventListener("dispose",this.onshowPrizeDispose);
      }
      
      private function onshowPrizeDispose(param1:ComponentEvent) : void
      {
         this._showPrize.removeEventListener("dispose",this.onshowPrizeDispose);
         ObjectUtils.disposeObject(this._showPrize);
         this._showPrize = null;
      }
      
      private function removeEvent() : void
      {
         this._rewardBtn.removeEventListener("click",this.__onRewardClick);
         this._grappleOneBtn.removeEventListener("click",this.__onGrappleOneClick);
         this._grappleTenBtn.removeEventListener("click",this.__onGrappleTenClick);
         if(Boolean(this._grappleMovie))
         {
            this._grappleMovie.removeEventListener("enterFrame",this.__onMovieFrame);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.__onCloseGrappleMovie(null);
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.disposeObject(this._rewardBtn);
         this._rewardBtn = null;
         ObjectUtils.disposeObject(this._machineBg);
         this._machineBg = null;
         ObjectUtils.disposeObject(this._grappleOneBtn);
         this._grappleOneBtn = null;
         ObjectUtils.disposeObject(this._grappleTenBtn);
         this._grappleTenBtn = null;
         ObjectUtils.disposeObject(this._countDown);
         this._countDown = null;
         ObjectUtils.disposeObject(this._tipsInfo);
         this._tipsInfo = null;
         ObjectUtils.disposeObject(this._smallEgg);
         this._smallEgg = null;
         ObjectUtils.disposeObject(this._bigEgg);
         this._bigEgg = null;
         if(this._time != null)
         {
            this._time.stop();
            this._time.reset();
            this._time.removeEventListener("timer",this.__onUpdateCountDown);
            this._time = null;
         }
      }
   }
}

