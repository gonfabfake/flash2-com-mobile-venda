package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterDirection;
   import ddt.view.sceneCharacter.SceneCharacterPlayerBase;
   import ddt.view.scenePathSearcher.PathMapHitTester;
   import ddt.view.scenePathSearcher.SceneScene;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import farm.modelx.FieldVO;
   import farm.player.FarmPlayer;
   import farm.player.vo.PlayerVO;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.viewx.helper.FarmHelperView;
   import farm.viewx.poultry.FarmPoultry;
   import farm.viewx.poultry.FarmTree;
   import farm.viewx.shop.FarmShopView;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import petsBag.PetsBagManager;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import road7th.comm.PackageIn;
   import toyMachine.ToyMachineManager;
   import trainer.view.NewHandContainer;
   import treasure.controller.TreasureManager;
   
   public class FarmMainView extends Sprite implements Disposeable
   {
      
      private var _bgSprite:Sprite;
      
      private var _bg:Bitmap;
      
      private var _water:MovieClip;
      
      private var _water1:MovieClip;
      
      private var _waterwheel:MovieClip;
      
      private var _float:MovieClip;
      
      private var _pastureHouseBtn:MovieClip;
      
      private var _friendListView:FarmFriendListView;
      
      private var _farmHelperBtn:BaseButton;
      
      private var _farmShopBtn:BaseButton;
      
      private var _doSeedBtn:BaseButton;
      
      private var _doMatureBtn:BaseButton;
      
      private var _goHomeBtn:BaseButton;
      
      private var _goTreasureBtn:SimpleButton;
      
      private var _arrangeBtn:BaseButton;
      
      private var _buyExpBtn:SimpleBitmapButton;
      
      private var _farmShovelBtn:FarmKillCropCell;
      
      private var _fireflyMC1:MovieClip;
      
      private var _fireflyMC2:MovieClip;
      
      private var _fireflyMC3:MovieClip;
      
      private var _startHelperMC:MovieClip;
      
      private var _fieldView:FarmFieldsView;
      
      private var _hostNameBmp:Bitmap;
      
      private var _farmName:FilterFrameText;
      
      private var _newPetPao:Bitmap;
      
      private var _newdragon:Bitmap;
      
      private var _newPetText:FilterFrameText;
      
      private var _buyExpText:FilterFrameText;
      
      private var _buyExpEffect:MovieImage;
      
      private var _selfPlayer:FarmPlayer;
      
      private var _friendPlayer:FarmPlayer;
      
      private var _currentLoadingPlayer:FarmPlayer;
      
      private var _lastClick:Number = 0;
      
      private var _clickInterval:Number = 200;
      
      private var _mouseMovie:MovieClip;
      
      private var _sceneScene:SceneScene;
      
      private var _meshLayer:Sprite;
      
      private var _needMoney:int;
      
      private var _farmTree:FarmTree;
      
      private var _farmPoultry:FarmPoultry;
      
      private var _farmBuyExpFrame:FarmBuyExpFrame;
      
      private var _selectedView:ManureOrSeedSelectedView;
      
      private var _farmHelper:FarmHelperView;
      
      private var _farmShop:FarmShopView;
      
      private var _currentFarmHelperFrame:int;
      
      public function FarmMainView()
      {
         super();
         this.init();
         this.initEvent();
         this.__enterFram(null);
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.farm.mainViewBg");
         this._bgSprite = new Sprite();
         this._bgSprite.addChild(this._bg);
         this.addChild(this._bgSprite);
         this._water = ClassUtils.CreatInstance("asset.farm.water");
         PositionUtils.setPos(this._water,"farm.waterPos");
         this._water1 = ClassUtils.CreatInstance("asset.farm.water1");
         PositionUtils.setPos(this._water1,"farm.waterPos1");
         this._waterwheel = ClassUtils.CreatInstance("asset.farm.waterwheel");
         PositionUtils.setPos(this._waterwheel,"farm.waterwheelPos");
         this._float = ClassUtils.CreatInstance("asset.farm.float");
         PositionUtils.setPos(this._float,"farm.floatPos");
         this._fireflyMC1 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC1,"farm.fireflyPos1");
         this._fireflyMC2 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC2,"farm.fireflyPos2");
         this._fireflyMC3 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC3,"farm.fireflyPos3");
         this._water.mouseEnabled = this._water.mouseChildren = this._waterwheel.mouseEnabled = this._waterwheel.mouseChildren = this._float.mouseEnabled = this._float.mouseChildren = this._fireflyMC1.mouseEnabled = this._fireflyMC1.mouseChildren = this._fireflyMC2.mouseEnabled = this._fireflyMC2.mouseChildren = this._fireflyMC3.mouseEnabled = this._fireflyMC3.mouseChildren = this._water1.mouseEnabled = this._water1.mouseChildren = false;
         addChild(this._water);
         addChild(this._water1);
         addChild(this._waterwheel);
         addChild(this._float);
         addChild(this._fireflyMC1);
         addChild(this._fireflyMC2);
         addChild(this._fireflyMC3);
         this._meshLayer = ComponentFactory.Instance.creat("asset.farm.zone") as Sprite;
         this._meshLayer.alpha = 0;
         addChild(this._meshLayer);
         this._fieldView = new FarmFieldsView();
         PositionUtils.setPos(this._fieldView,"farm.fieldsView");
         addChild(this._fieldView);
         this.initToolBtn();
         this._hostNameBmp = ComponentFactory.Instance.creatBitmap("asset.farm.fieldHostName");
         this._hostNameBmp.x = (StageReferance.stageWidth - this._hostNameBmp.width) / 2;
         addChild(this._hostNameBmp);
         this._farmName = ComponentFactory.Instance.creatComponentByStylename("farm.mainView.hostName");
         addChild(this._farmName);
         this._farmName.text = FarmModelController.instance.model.currentFarmerName;
         this.petFarmGuilde();
         this._startHelperMC = ClassUtils.CreatInstance("assets.farm.startHelper.mc") as MovieClip;
         this._startHelperMC.visible = false;
         PositionUtils.setPos(this._startHelperMC,"farm.helper.startHelper.mc.Pos");
         addChild(this._startHelperMC);
         this.checkHelper();
         if(FarmModelController.instance.midAutumnFlag)
         {
            this.addSelfPlayer();
         }
         this._farmTree = new FarmTree();
         PositionUtils.setPos(this._farmTree,"asset.farm.treePos");
         addChild(this._farmTree);
         this._farmPoultry = new FarmPoultry();
         this._farmPoultry.addEventListener("complete",this.__onComplete);
         this._farmPoultry.startLoadPoultry();
         PositionUtils.setPos(this._farmPoultry,"asset.farm.poultryPos");
         addChild(this._farmPoultry);
         this._pastureHouseBtn = ClassUtils.CreatInstance("asset.farm.pastureBtn");
         PositionUtils.setPos(this._pastureHouseBtn,"farm.pasturehousebtnPos");
         addChild(this._pastureHouseBtn);
         this._friendListView = new FarmFriendListView();
         PositionUtils.setPos(this._friendListView,"farm.friendListViewPos");
         addChild(this._friendListView);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(135))
         {
            if(PlayerManager.Instance.Self.Grade >= 25)
            {
               NewHandContainer.Instance.showArrow(146,45,new Point(860,103),"","",this);
            }
         }
      }
      
      protected function __onComplete(param1:Event) : void
      {
         this._farmPoultry.removeEventListener("complete",this.__onComplete);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_POULTYRLEVEL,this.__onGetPoultryLevel);
         SocketManager.Instance.out.getFarmPoultryLevel(FarmModelController.instance.model.currentFarmerId);
      }
      
      protected function __onGetPoultryLevel(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         _loc2_ = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:int = _loc2_.readInt();
         var _loc7_:int = _loc2_.readByte();
         var _loc8_:Date = _loc2_.readDate();
         if(_loc3_ == FarmModelController.instance.model.currentFarmerId)
         {
            this._farmTree.setLevel(_loc4_);
            this._farmPoultry.setInfo(_loc5_,_loc6_,_loc7_,_loc8_);
         }
      }
      
      public function addSelfPlayer() : void
      {
         var _loc1_:* = null;
         var _loc2_:Class = ClassUtils.uiSourceDomain.getDefinition("asset.farm.MouseClickMovie") as Class;
         this._mouseMovie = new _loc2_() as MovieClip;
         this._mouseMovie.mouseChildren = false;
         this._mouseMovie.mouseEnabled = false;
         this._mouseMovie.stop();
         addChild(this._mouseMovie);
         this._sceneScene = new SceneScene();
         this._sceneScene.setHitTester(new PathMapHitTester(this._meshLayer));
         if(!this._selfPlayer)
         {
            _loc1_ = new PlayerVO();
            _loc1_.playerInfo = PlayerManager.Instance.Self;
            this._currentLoadingPlayer = new FarmPlayer(_loc1_,this.addPlayerCallBack);
         }
      }
      
      private function addPlayerCallBack(param1:FarmPlayer, param2:Boolean, param3:int) : void
      {
         if(param3 == 0)
         {
            if(!param1)
            {
               return;
            }
            this._currentLoadingPlayer = null;
            param1.sceneScene = this._sceneScene;
            param1.setSceneCharacterDirectionDefault = param1.sceneCharacterDirection = param1.playerVO.scenePlayerDirection;
            if(!this._selfPlayer && param1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               this._selfPlayer = param1;
               addChild(this._selfPlayer);
               this._selfPlayer.addEventListener("characterActionChange",this.playerActionChange);
            }
            else
            {
               this._friendPlayer = param1;
               addChild(param1);
            }
            param1.playerPoint = new Point(200,300);
            param1.sceneCharacterStateType = "natural";
            addEventListener("enterFrame",this.__updateFrame);
         }
      }
      
      protected function playerActionChange(param1:SceneCharacterEvent) : void
      {
         var _loc2_:String = param1.data.toString();
         if(_loc2_ == "naturalStandFront" || _loc2_ == "naturalStandBack")
         {
            this._mouseMovie.gotoAndStop(1);
         }
      }
      
      protected function __onPlayerClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = null;
         if(Boolean(this._selfPlayer))
         {
            _loc2_ = this.globalToLocal(new Point(param1.stageX,param1.stageY));
            if(getTimer() - this._lastClick > this._clickInterval)
            {
               this._lastClick = getTimer();
               if(!this._sceneScene.hit(_loc2_))
               {
                  this._mouseMovie.x = _loc2_.x;
                  this._mouseMovie.y = _loc2_.y;
                  this._mouseMovie.play();
                  this._selfPlayer.playerVO.walkPath = this._sceneScene.searchPath(this._selfPlayer.playerPoint,_loc2_);
                  this._selfPlayer.playerVO.walkPath.shift();
                  this._selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this._selfPlayer.playerPoint,this._selfPlayer.playerVO.walkPath[0]);
                  this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
               }
            }
         }
      }
      
      protected function __updateFrame(param1:Event) : void
      {
         if(Boolean(this._selfPlayer))
         {
            this._selfPlayer.updatePlayer();
         }
         if(Boolean(this._friendPlayer))
         {
            this._friendPlayer.updatePlayer();
         }
      }
      
      private function dargonPetShow() : void
      {
         this._newPetPao = ComponentFactory.Instance.creatBitmap("assets.farm.newPetPao");
         addChild(this._newPetPao);
         this._newdragon = ComponentFactory.Instance.creatBitmap("assets.farm.newdragon");
         addChild(this._newdragon);
         this._newPetText = ComponentFactory.Instance.creatComponentByStylename("confirmHelperMoneyAlertFrame.newPetComesTxt");
         this._newPetText.htmlText = LanguageMgr.GetTranslation("ddt.farms.newPetsComew");
         addChild(this._newPetText);
      }
      
      private function set newPetShowVisble(param1:Boolean) : void
      {
         this._newPetPao.visible = param1;
         this._newdragon.visible = param1;
         this._newPetText.visible = param1;
      }
      
      private function checkHelper() : void
      {
         if(PlayerManager.Instance.Self.isFarmHelper && PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
         {
            this._fieldView.setFieldByHelper();
            this.setVisibleByAuto(false);
            if(this._farmHelper == null)
            {
               this._farmHelper = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.helper");
               this._farmHelper.show();
            }
         }
      }
      
      private function setVisibleByAuto(param1:Boolean = true) : void
      {
         if(Boolean(this._farmShopBtn))
         {
            this._farmShopBtn.enable = param1;
         }
         if(Boolean(this._doSeedBtn))
         {
            this._doSeedBtn.enable = param1;
         }
         if(Boolean(this._doMatureBtn))
         {
            this._doMatureBtn.enable = param1;
         }
         if(Boolean(this._farmShovelBtn))
         {
            this._farmShovelBtn.setBtnVis(param1);
         }
         if(Boolean(this._startHelperMC))
         {
            this._startHelperMC.visible = !param1;
         }
      }
      
      private function __setVisible(param1:FarmEvent) : void
      {
         this.setVisibleByAuto(false);
      }
      
      private function __setVisibleFal(param1:FarmEvent) : void
      {
         this.setVisibleByAuto(true);
      }
      
      private function petFarmGuilde() : void
      {
         if(PetsBagManager.instance.haveTaskOrderByID(367))
         {
            PetsBagManager.instance.showPetFarmGuildArrow(91,-150,"farmTrainer.openAdoptPetArrowPos","asset.farmTrainer.clickHere","farmTrainer.openAdoptPetTipPos",this);
         }
         if(PetsBagManager.instance.haveTaskOrderByID(369))
         {
            PetsBagManager.instance.showPetFarmGuildArrow(101,-60,"farmTrainer.seedArrowPos","asset.farmTrainer.seed","farmTrainer.seedTipPos",this);
         }
         if(PetsBagManager.instance.haveTaskOrderByID(370))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(119);
            PetsBagManager.instance.showPetFarmGuildArrow(107,-50,"farmTrainer.grainArrowPos","asset.farmTrainer.grain2","farmTrainer.grainFieldTipPos",this);
         }
         if(PetsBagManager.instance.haveTaskOrderByID(366) && SharedManager.Instance.stoneFriend)
         {
            SharedManager.Instance.stoneFriend = false;
            SharedManager.Instance.save();
            PetsBagManager.instance.showPetFarmGuildArrow(114,-150,"farmTrainer.openFriendsArrowPos","asset.farmTrainer.openFriends","farmTrainer.openFriendsTipPos",this);
         }
      }
      
      private function petFarmGuildeClear() : void
      {
         if(PetsBagManager.instance.haveTaskOrderByID(367))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(91);
         }
         if(PetsBagManager.instance.haveTaskOrderByID(369))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(101);
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(101);
         }
         if(PetsBagManager.instance.haveTaskOrderByID(370))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(107);
         }
         if(PetsBagManager.instance.haveTaskOrderByID(366))
         {
            PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(114);
         }
      }
      
      protected function initToolBtn() : void
      {
         this._farmHelperBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperBtn");
         addChild(this._farmHelperBtn);
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
         this._farmShopBtn = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopBtn");
         addChild(this._farmShopBtn);
         this._doSeedBtn = ComponentFactory.Instance.creatComponentByStylename("farm.doSeedBtn");
         addChild(this._doSeedBtn);
         this._doMatureBtn = ComponentFactory.Instance.creatComponentByStylename("farm.doMatureBtn");
         addChild(this._doMatureBtn);
         this._goHomeBtn = ComponentFactory.Instance.creatComponentByStylename("farm.gohomeBtn");
         addChild(this._goHomeBtn);
         if(PathManager.treasureSwitch)
         {
            this._goTreasureBtn = ComponentFactory.Instance.creat("asset.treasure.button");
            addChild(this._goTreasureBtn);
            PositionUtils.setPos(this._goTreasureBtn,"farm.treasure.button.pos");
            this._arrangeBtn = ComponentFactory.Instance.creatComponentByStylename("farm.arrangeBtn");
            addChild(this._arrangeBtn);
            this._arrangeBtn.visible = false;
            this._arrangeBtn.tipStyle = null;
         }
         this._farmShovelBtn = new FarmKillCropCell();
         addChild(this._farmShovelBtn);
         PositionUtils.setPos(this._farmShovelBtn,"farm.farmShovelBtn");
         this._goHomeBtn.visible = false;
         this._farmShovelBtn.visible = true;
      }
      
      private function initEvent() : void
      {
         this._farmHelperBtn.addEventListener("rollOver",this.__farmHelperOver);
         this._farmHelperBtn.addEventListener("rollOut",this.__farmHelperOut);
         this._farmHelperBtn.addEventListener("mouseDown",this.__farmHelperDown);
         this._farmHelperBtn.addEventListener("click",this.__showHelper);
         this._doSeedBtn.addEventListener("mouseOver",this.__doSeedOver);
         this._doSeedBtn.addEventListener("mouseOut",this.__doSeedOut);
         this._doMatureBtn.addEventListener("mouseOver",this.__doMatureOver);
         this._doMatureBtn.addEventListener("mouseOut",this.__doMatureOut);
         this._farmShopBtn.addEventListener("mouseOver",this.__farmShopOver);
         this._farmShopBtn.addEventListener("mouseOut",this.__farmShopOut);
         this._goHomeBtn.addEventListener("mouseOver",this.__goHomeOver);
         this._goHomeBtn.addEventListener("mouseOut",this.__goHomeOut);
         if(Boolean(this._goTreasureBtn))
         {
            this._goTreasureBtn.addEventListener("click",this.__goTreasureBtn);
         }
         this._doSeedBtn.addEventListener("click",this.__onSelectedBtnClick);
         this._doMatureBtn.addEventListener("click",this.__onFastForwardSelectedBtnClick);
         this._farmShopBtn.addEventListener("click",this.__showShop);
         this._pastureHouseBtn.addEventListener("click",this.__pastureHouse);
         this._pastureHouseBtn.addEventListener("mouseOver",this.__pastureOver);
         this._pastureHouseBtn.addEventListener("mouseOut",this.__pastureOut);
         this._goHomeBtn.addEventListener("click",this.__goHomeHandler);
         FarmModelController.instance.addEventListener("fieldsInfoReady",this.__enterFram);
         PetsBagManager.instance.addEventListener("finish",this.__updatePetFarmGuilde);
         this._fieldView.addEventListener("killcropIcon",this.__killcrop_iconShow);
         FarmModelController.instance.addEventListener("beginHelper",this.__setVisible);
         FarmModelController.instance.addEventListener("stopHelper",this.__setVisibleFal);
         FarmModelController.instance.addEventListener("loaderSuperPetFoodPricetList",this.__priectListLoadComplete);
         FarmModelController.instance.addEventListener("updateBuyExpRemainNum",this.__updateNum);
         this._bgSprite.addEventListener("click",this.__onPlayerClick);
         this.addFieldBlockEvent();
      }
      
      private function __goTreasureBtn(param1:MouseEvent) : void
      {
         TreasureManager.instance.show();
      }
      
      private function __arrangeBackHandler(param1:FarmEvent) : void
      {
         this._arrangeBtn.dispatchEvent(new MouseEvent("mouseOut"));
         this._arrangeBtn.removeEventListener("mouseOver",this.__arrangeOver);
         this._arrangeBtn.removeEventListener("mouseOut",this.__arrangeOut);
         this._arrangeBtn.removeEventListener("click",this.__arrangeHandler);
         this._arrangeBtn.filterString = "grayFilter,grayFilter,grayFilter,grayFilter";
         this._arrangeBtn.tipGapH = 100;
         this._arrangeBtn.tipStyle = "ddt.view.tips.OneLineTip";
         if(FarmModelController.instance.model.isArrange)
         {
            this._arrangeBtn.tipData = LanguageMgr.GetTranslation("ddt.farm.arrange.tips");
         }
         else
         {
            this._arrangeBtn.tipData = LanguageMgr.GetTranslation("ddt.farm.arrange2");
         }
      }
      
      private function addFieldBlockEvent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._fieldView.fields.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._fieldView.fields[_loc1_].addEventListener("fieldblockclick",this.__onFieldBlockClick);
            _loc1_++;
         }
      }
      
      protected function __onFieldBlockClick(param1:FarmEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(Boolean(FarmModelController.instance.model.helperArray[0]) || FarmModelController.instance.model.currentFarmerId != PlayerManager.Instance.Self.ID)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this._selectedView == null)
         {
            this._selectedView = new ManureOrSeedSelectedView();
            addChild(this._selectedView);
         }
         var _loc4_:int = int(this._fieldView.fields.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1.currentTarget == this._fieldView.fields[_loc3_])
            {
               _loc2_ = PositionUtils.creatPoint("farm.fieldsView.fieldPos" + _loc3_);
            }
            _loc3_++;
         }
         var _loc5_:Point = PositionUtils.creatPoint("assets.farm.filedbolckRect");
         this._selectedView.x = _loc2_.x + this._fieldView.x;
         if(this._selectedView.x + this._selectedView.width > StageReferance.stageWidth - 90)
         {
            this._selectedView.x = StageReferance.stageWidth - this._selectedView.width - 90;
         }
         this._selectedView.y = _loc2_.y + this._fieldView.y - this._selectedView.height;
         this._selectedView.viewType = 1;
      }
      
      protected function __updateNum(param1:FarmEvent) : void
      {
         if(FarmModelController.instance.model.buyExpRemainNum > 0)
         {
            if(Boolean(this._buyExpText))
            {
               this._buyExpText.text = FarmModelController.instance.model.buyExpRemainNum.toString();
            }
         }
         else
         {
            this._buyExpBtn.visible = false;
            this._buyExpText.visible = false;
            this._buyExpEffect.visible = false;
         }
      }
      
      protected function __priectListLoadComplete(param1:Event) : void
      {
         this._buyExpBtn = UICreatShortcut.creatAndAdd("Farm.FarmMainView.buyExpBtn",this);
         this._buyExpText = UICreatShortcut.creatTextAndAdd("Farm.FarmMainView.buyExpNumText","",this);
         this._buyExpText.text = FarmModelController.instance.model.buyExpRemainNum.toString();
         this._buyExpEffect = UICreatShortcut.creatAndAdd("Farm.FarmMainView.buyExpBtnEffect",this);
         this._buyExpBtn.addEventListener("click",this.__onBuyExpClick);
         if(FarmModelController.instance.model.buyExpRemainNum <= 0)
         {
            this._buyExpBtn.visible = false;
            this._buyExpText.visible = false;
            this._buyExpEffect.visible = false;
         }
         FarmModelController.instance.removeEventListener("loaderSuperPetFoodPricetList",this.__priectListLoadComplete);
      }
      
      protected function __onBuyExpClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this._farmBuyExpFrame = ComponentFactory.Instance.creatComponentByStylename("farm.viewx.farmBuyExpFrame");
         this._farmBuyExpFrame.show();
         this._farmBuyExpFrame.addEventListener("response",this.__BuyExpFrameResponse);
      }
      
      protected function __BuyExpFrameResponse(param1:FrameEvent) : void
      {
         if(param1.responseCode == 1 || param1.responseCode == 0)
         {
            SoundManager.instance.playButtonSound();
            if(Boolean(this._farmBuyExpFrame))
            {
               this._farmBuyExpFrame.removeEventListener("response",this.__BuyExpFrameResponse);
            }
            ObjectUtils.disposeObject(this._farmBuyExpFrame);
            this._farmBuyExpFrame = null;
         }
      }
      
      private function __doSeedOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __doSeedOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __doMatureOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __doMatureOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __farmShopOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __farmShopOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __goHomeOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __goHomeOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __arrangeOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
      }
      
      private function __arrangeOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
      }
      
      private function __arrangeHandler(param1:MouseEvent) : void
      {
         if(!FarmModelController.instance.model.isArrange)
         {
            SoundManager.instance.play("008");
            FarmModelController.instance.arrange();
         }
      }
      
      private function __updatePetFarmGuilde(param1:UpdatePetFarmGuildeEvent) : void
      {
         PetsBagManager.instance.finishTask();
         this.petFarmGuilde();
      }
      
      private function __killcrop_iconShow(param1:SelectComposeItemEvent) : void
      {
         this._farmShovelBtn.dispatchEvent(new MouseEvent("click"));
      }
      
      protected function __pastureOut(param1:MouseEvent) : void
      {
         this._pastureHouseBtn.filters = null;
      }
      
      protected function __pastureOver(param1:MouseEvent) : void
      {
         this._pastureHouseBtn.filters = SceneCharacterPlayerBase.MOUSE_ON_GLOW_FILTER;
      }
      
      private function setFarmPlayerInfo() : void
      {
         if(Boolean(this._friendPlayer))
         {
            this._friendPlayer.dispose();
            this._friendPlayer = null;
         }
         this.deleteSelfPlayer();
         this.addSelfPlayer();
      }
      
      protected function __enterFram(param1:FarmEvent) : void
      {
         var _loc2_:* = null;
         if(FarmModelController.instance.midAutumnFlag)
         {
            this.setFarmPlayerInfo();
         }
         if(Boolean(this._arrangeBtn) && this._arrangeBtn.hasEventListener("click"))
         {
            this._arrangeBtn.removeEventListener("mouseOver",this.__arrangeOver);
            this._arrangeBtn.removeEventListener("mouseOut",this.__arrangeOut);
            this._arrangeBtn.removeEventListener("click",this.__arrangeHandler);
         }
         if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
         {
            if(PlayerManager.Instance.Self.isFarmHelper)
            {
               this.setVisibleByAuto(false);
            }
            else
            {
               this.setVisibleByAuto(true);
            }
         }
         else if(Boolean(this._arrangeBtn) && !FarmModelController.instance.model.isArrange)
         {
            this._arrangeBtn.addEventListener("mouseOver",this.__arrangeOver);
            this._arrangeBtn.addEventListener("mouseOut",this.__arrangeOut);
            this._arrangeBtn.addEventListener("click",this.__arrangeHandler);
         }
         this._farmName.text = FarmModelController.instance.model.currentFarmerName;
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            this.petFarmGuilde();
            this._pastureHouseBtn.buttonMode = this._pastureHouseBtn.mouseEnabled = this._pastureHouseBtn.mouseChildren = true;
            this._farmShopBtn.visible = this._doSeedBtn.visible = this._doMatureBtn.visible = true;
            this._goHomeBtn.visible = false;
            if(Boolean(this._arrangeBtn))
            {
               this._arrangeBtn.visible = false;
               this._arrangeBtn.tipStyle = null;
            }
            this._farmShovelBtn.visible = true;
            this._farmHelperBtn.visible = true;
            if(Boolean(this._goTreasureBtn))
            {
               this._goTreasureBtn.visible = true;
            }
            if(FarmModelController.instance.model.buyExpRemainNum > 0)
            {
               if(Boolean(this._buyExpBtn))
               {
                  this._buyExpBtn.visible = true;
               }
               if(Boolean(this._buyExpText))
               {
                  this._buyExpText.visible = true;
               }
               if(Boolean(this._buyExpEffect))
               {
                  this._buyExpEffect.visible = true;
               }
            }
            if(PlayerManager.Instance.Self.isFarmHelper)
            {
               if(Boolean(this._startHelperMC))
               {
                  this._startHelperMC.visible = true;
               }
            }
         }
         else
         {
            this.petFarmGuildeClear();
            this._pastureHouseBtn.buttonMode = this._pastureHouseBtn.mouseEnabled = this._pastureHouseBtn.mouseChildren = false;
            this._farmShopBtn.visible = this._doSeedBtn.visible = this._doMatureBtn.visible = false;
            this._goHomeBtn.visible = true;
            if(Boolean(this._arrangeBtn))
            {
               this._arrangeBtn.visible = true;
            }
            if(Boolean(this._arrangeBtn))
            {
               if(FarmModelController.instance.model.isArrange)
               {
                  this._arrangeBtn.filterString = "grayFilter,grayFilter,grayFilter,grayFilter";
                  this._arrangeBtn.tipData = LanguageMgr.GetTranslation("ddt.farm.arrange.tips");
                  this._arrangeBtn.tipStyle = "ddt.view.tips.OneLineTip";
                  this._arrangeBtn.tipGapH = 100;
               }
               else
               {
                  this._arrangeBtn.filterString = "null,lightFilter,null,grayFilter";
                  this._arrangeBtn.tipGapH = -222;
                  this._arrangeBtn.tipStyle = null;
               }
            }
            this._farmShovelBtn.visible = false;
            this._farmHelperBtn.visible = false;
            if(Boolean(this._buyExpBtn))
            {
               this._buyExpBtn.visible = false;
            }
            if(Boolean(this._buyExpText))
            {
               this._buyExpText.visible = false;
            }
            if(Boolean(this._buyExpEffect))
            {
               this._buyExpEffect.visible = false;
            }
            if(Boolean(this._startHelperMC))
            {
               this._startHelperMC.visible = false;
            }
            if(Boolean(this._selectedView))
            {
               this._selectedView.visible = false;
            }
            if(Boolean(this._goTreasureBtn))
            {
               this._goTreasureBtn.visible = false;
            }
            if(FarmModelController.instance.midAutumnFlag)
            {
               _loc2_ = new PlayerVO();
               _loc2_.playerInfo = PlayerManager.Instance.findPlayer(FarmModelController.instance.model.currentFarmerId);
               this._currentLoadingPlayer = new FarmPlayer(_loc2_,this.addPlayerCallBack);
               this._currentLoadingPlayer.isChatBall = true;
               this._selfPlayer.playerPoint = new Point(356,430);
               this._selfPlayer.sceneCharacterDirection = SceneCharacterDirection.LB;
            }
         }
      }
      
      private function __goHomeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
         PetsBagManager.instance.clearCurrentPetFarmGuildeArrow(116);
      }
      
      private function __onSelectedBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._selectedView != null)
         {
            this._selectedView.dispose();
            this._selectedView = null;
         }
         this._selectedView = new ManureOrSeedSelectedView();
         addChild(this._selectedView);
         PositionUtils.setPos(this._selectedView,"farm.seedSelectViewPos");
         switch(param1.currentTarget)
         {
            case this._doSeedBtn:
               this._selectedView.viewType = 1;
               break;
            case this._doMatureBtn:
         }
      }
      
      private function __onFastForwardSelectedBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._needMoney = FarmModelController.instance.gropPrice * this.ripeNum();
         if(this._needMoney == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farms.noFastForwardInfo"));
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.farms.fastForwardAllInfo",this._needMoney),"",LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",30,true,0);
         _loc2_.addEventListener("response",this.__onResponse);
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Boolean = (param1.target as BaseAlerFrame).isBand;
         (param1.target as BaseAlerFrame).removeEventListener("response",this.__onResponse);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            CheckMoneyUtils.instance.checkMoney(_loc2_,this._needMoney,this.onCheckComplete);
         }
      }
      
      protected function onCheckComplete() : void
      {
         SocketManager.Instance.out.fastForwardGrop(CheckMoneyUtils.instance.isBind,true,-1);
      }
      
      private function ripeNum() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<FieldVO> = FarmModelController.instance.model.fieldsInfo;
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            if(Boolean(_loc3_[_loc1_]) && Boolean(_loc3_[_loc1_].seedID != 0) && _loc3_[_loc1_].realNeedTime > 0)
            {
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      private function __showHelper(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(Boolean(this._selectedView))
         {
            this._selectedView.visible = false;
         }
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
         this._farmHelper = ComponentFactory.Instance.creatComponentByStylename("farm.farmHelperView.helper");
         this._farmHelper.show();
         this._farmHelper.addEventListener("response",this.__closeHelperView);
      }
      
      private function __closeHelperView(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmHelper.removeEventListener("response",this.__closeHelperView);
         var _loc2_:int = int(param1.responseCode);
         switch(0)
         {
         }
      }
      
      private function __showShop(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmShop = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopView.shop");
         this._farmShop.addEventListener("response",this.__closeFarmShop);
         this._farmShop.show();
      }
      
      private function __closeFarmShop(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmShop.removeEventListener("response",this.__closeFarmShop);
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               ObjectUtils.disposeObject(this._farmShop);
               this._farmShop = null;
         }
      }
      
      private function __pastureHouse(param1:MouseEvent) : void
      {
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            SoundManager.instance.play("008");
            ToyMachineManager.instance.show();
         }
      }
      
      private function __farmHelperOver(param1:MouseEvent) : void
      {
         param1.currentTarget.x -= 15;
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
      }
      
      private function __farmHelperOut(param1:MouseEvent) : void
      {
         param1.currentTarget.x += 15;
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
      }
      
      private function __farmHelperDown(param1:MouseEvent) : void
      {
         MovieClip(this._farmHelperBtn.backgound).gotoAndStop(this._currentFarmHelperFrame);
      }
      
      private function removeEvent() : void
      {
         this._farmPoultry.removeEventListener("complete",this.__onComplete);
         this._farmHelperBtn.removeEventListener("rollOver",this.__farmHelperOver);
         this._farmHelperBtn.removeEventListener("rollOut",this.__farmHelperOut);
         this._farmHelperBtn.removeEventListener("mouseDown",this.__farmHelperDown);
         this._farmHelperBtn.removeEventListener("click",this.__showHelper);
         this._doSeedBtn.removeEventListener("mouseOver",this.__doSeedOver);
         this._doSeedBtn.removeEventListener("mouseOut",this.__doSeedOut);
         this._doMatureBtn.removeEventListener("mouseOver",this.__doMatureOver);
         this._doMatureBtn.removeEventListener("mouseOut",this.__doMatureOut);
         this._farmShopBtn.removeEventListener("mouseOver",this.__farmShopOver);
         this._farmShopBtn.removeEventListener("mouseOut",this.__farmShopOut);
         this._goHomeBtn.removeEventListener("mouseOver",this.__goHomeOver);
         this._goHomeBtn.removeEventListener("mouseOut",this.__goHomeOut);
         this._doSeedBtn.removeEventListener("click",this.__onSelectedBtnClick);
         this._doMatureBtn.removeEventListener("click",this.__onFastForwardSelectedBtnClick);
         this._farmShopBtn.removeEventListener("click",this.__showShop);
         this._pastureHouseBtn.removeEventListener("click",this.__pastureHouse);
         this._pastureHouseBtn.removeEventListener("mouseOver",this.__pastureOver);
         this._pastureHouseBtn.removeEventListener("mouseOut",this.__pastureOut);
         this._goHomeBtn.removeEventListener("click",this.__goHomeHandler);
         if(Boolean(this._buyExpBtn))
         {
            this._buyExpBtn.removeEventListener("click",this.__onBuyExpClick);
         }
         FarmModelController.instance.removeEventListener("fieldsInfoReady",this.__enterFram);
         PetsBagManager.instance.removeEventListener("finish",this.__updatePetFarmGuilde);
         this._fieldView.removeEventListener("killcropIcon",this.__killcrop_iconShow);
         FarmModelController.instance.removeEventListener("beginHelper",this.__setVisible);
         FarmModelController.instance.removeEventListener("stopHelper",this.__setVisibleFal);
         FarmModelController.instance.removeEventListener("loaderSuperPetFoodPricetList",this.__priectListLoadComplete);
         FarmModelController.instance.removeEventListener("updateBuyExpRemainNum",this.__updateNum);
         if(Boolean(this._goTreasureBtn))
         {
            this._goTreasureBtn.removeEventListener("click",this.__goTreasureBtn);
         }
         if(Boolean(this._arrangeBtn) && this._arrangeBtn.hasEventListener("click"))
         {
            this._arrangeBtn.removeEventListener("mouseOver",this.__arrangeOver);
            this._arrangeBtn.removeEventListener("mouseOut",this.__arrangeOut);
            this._arrangeBtn.removeEventListener("click",this.__arrangeHandler);
         }
         this.removeFieldBolckEvent();
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FARM_POULTYRLEVEL,this.__onGetPoultryLevel);
      }
      
      private function removeFieldBolckEvent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this._fieldView.fields.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._fieldView.fields[_loc1_].removeEventListener("fieldblockclick",this.__onFieldBlockClick);
            _loc1_++;
         }
      }
      
      private function deleteSelfPlayer() : void
      {
         if(Boolean(this._selfPlayer))
         {
            this._selfPlayer.removeEventListener("characterActionChange",this.playerActionChange);
            removeEventListener("enterFrame",this.__updateFrame);
            this._selfPlayer.dispose();
            this._selfPlayer = null;
         }
         if(Boolean(this._sceneScene))
         {
            this._sceneScene.dispose();
            this._sceneScene = null;
         }
         ObjectUtils.disposeObject(this._mouseMovie);
         this._mouseMovie = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._water))
         {
            ObjectUtils.disposeObject(this._water);
         }
         this._water = null;
         if(Boolean(this._water1))
         {
            ObjectUtils.disposeObject(this._water1);
         }
         this._water1 = null;
         if(Boolean(this._waterwheel))
         {
            ObjectUtils.disposeObject(this._waterwheel);
         }
         this._waterwheel = null;
         if(Boolean(this._float))
         {
            ObjectUtils.disposeObject(this._float);
         }
         this._float = null;
         if(Boolean(this._pastureHouseBtn))
         {
            ObjectUtils.disposeObject(this._pastureHouseBtn);
         }
         this._pastureHouseBtn = null;
         if(Boolean(this._friendListView))
         {
            ObjectUtils.disposeObject(this._friendListView);
         }
         this._friendListView = null;
         if(Boolean(this._farmHelperBtn))
         {
            ObjectUtils.disposeObject(this._farmHelperBtn);
         }
         this._farmHelperBtn = null;
         if(Boolean(this._farmShopBtn))
         {
            ObjectUtils.disposeObject(this._farmShopBtn);
         }
         this._farmShopBtn = null;
         if(Boolean(this._doSeedBtn))
         {
            ObjectUtils.disposeObject(this._doSeedBtn);
         }
         this._doSeedBtn = null;
         if(Boolean(this._doMatureBtn))
         {
            ObjectUtils.disposeObject(this._doMatureBtn);
         }
         this._doMatureBtn = null;
         if(Boolean(this._goTreasureBtn))
         {
            ObjectUtils.disposeObject(this._goTreasureBtn);
         }
         this._goTreasureBtn = null;
         if(Boolean(this._goHomeBtn))
         {
            ObjectUtils.disposeObject(this._goHomeBtn);
         }
         this._goHomeBtn = null;
         if(Boolean(this._arrangeBtn))
         {
            ObjectUtils.disposeObject(this._arrangeBtn);
         }
         this._arrangeBtn = null;
         if(Boolean(this._fireflyMC1))
         {
            ObjectUtils.disposeObject(this._fireflyMC1);
         }
         this._fireflyMC1 = null;
         if(Boolean(this._fireflyMC2))
         {
            ObjectUtils.disposeObject(this._fireflyMC2);
         }
         this._fireflyMC2 = null;
         if(Boolean(this._fireflyMC3))
         {
            ObjectUtils.disposeObject(this._fireflyMC3);
         }
         this._fireflyMC3 = null;
         if(Boolean(this._fieldView))
         {
            ObjectUtils.disposeObject(this._fieldView);
         }
         this._fieldView = null;
         if(Boolean(this._startHelperMC))
         {
            ObjectUtils.disposeObject(this._startHelperMC);
         }
         this._startHelperMC = null;
         if(Boolean(this._hostNameBmp))
         {
            ObjectUtils.disposeObject(this._hostNameBmp);
         }
         this._hostNameBmp = null;
         if(Boolean(this._farmName))
         {
            ObjectUtils.disposeObject(this._farmName);
         }
         this._farmName = null;
         if(Boolean(this._selectedView))
         {
            ObjectUtils.disposeObject(this._selectedView);
         }
         this._selectedView = null;
         if(Boolean(this._farmShovelBtn))
         {
            this._farmShovelBtn.dispose();
         }
         this._farmShovelBtn = null;
         if(Boolean(this._newPetPao))
         {
            ObjectUtils.disposeObject(this._newPetPao);
         }
         this._newPetPao = null;
         if(Boolean(this._newdragon))
         {
            ObjectUtils.disposeObject(this._newdragon);
         }
         this._newdragon = null;
         if(Boolean(this._newPetText))
         {
            ObjectUtils.disposeObject(this._newPetText);
         }
         this._newPetText = null;
         if(Boolean(this._farmBuyExpFrame))
         {
            this._farmBuyExpFrame.removeEventListener("response",this.__BuyExpFrameResponse);
         }
         ObjectUtils.disposeObject(this._buyExpText);
         this._buyExpText = null;
         ObjectUtils.disposeObject(this._buyExpEffect);
         this._buyExpEffect = null;
         ObjectUtils.disposeObject(this._buyExpBtn);
         this._buyExpBtn = null;
         ObjectUtils.disposeObject(this._farmBuyExpFrame);
         this._farmBuyExpFrame = null;
         if(Boolean(this._bgSprite))
         {
            this._bgSprite.removeEventListener("click",this.__onPlayerClick);
            ObjectUtils.disposeObject(this._bgSprite);
            this._bgSprite = null;
         }
         this.deleteSelfPlayer();
         if(Boolean(this._meshLayer))
         {
            ObjectUtils.disposeObject(this._meshLayer);
         }
         this._meshLayer = null;
         if(Boolean(this._farmTree))
         {
            ObjectUtils.disposeObject(this._farmTree);
         }
         this._farmTree = null;
         if(Boolean(this._farmPoultry))
         {
            ObjectUtils.disposeObject(this._farmPoultry);
         }
         this._farmPoultry = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

