package petIsland.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.greensock.easing.Elastic;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import petIsland.PetIslandManager;
   import petIsland.event.PetIslandEvent;
   
   public class PetIslandView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _returnBtn:PetIslandReturnBar;
      
      private var _mask:Shape;
      
      private var _contain:Sprite = new Sprite();
      
      private var numberArr:Array = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]];
      
      private var pList:Array = [];
      
      private var points:int = 0;
      
      private var nowPoints:int = 0;
      
      private var flyFlash:MovieClip;
      
      private var _buyBtn:BaseButton;
      
      private var _buySkillTwoBtn:BaseButton;
      
      private var _helpBtn:BaseButton;
      
      private var _playerMathContain:Sprite = new Sprite();
      
      private var _npcMathContain:Sprite = new Sprite();
      
      private var _roundMc:Sprite = new Sprite();
      
      private var _beginBtn:BaseButton;
      
      private var _playerScore:Bitmap;
      
      private var _npcScore:Bitmap;
      
      private var _begin:Bitmap;
      
      private var _continue:Bitmap;
      
      private var _roundTxt:FilterFrameText;
      
      private var _playerBloodTxt:FilterFrameText;
      
      private var _npcBloodTxt:FilterFrameText;
      
      private var _bloodContain:Sprite = new Sprite();
      
      private var _info:FilterFrameText;
      
      private var _currentStep:int;
      
      private var _playerBlood:Bitmap;
      
      private var playerMask:Sprite;
      
      private var _npcBlood:Bitmap;
      
      private var npcMask:Sprite;
      
      private var prizeView:PetIslandPrizeView;
      
      private var bloodFlash:MovieClip;
      
      private var success:MovieClip;
      
      private var fail:MovieClip;
      
      private var beginFlash:MovieClip;
      
      private var npcHead:MovieClip;
      
      private var playerHead:Sprite = new Sprite();
      
      private var blackBg:Sprite = new Sprite();
      
      private var stopPlayBlackBg:Sprite = new Sprite();
      
      private var _headLoader:SceneCharacterLoaderHead;
      
      private var _headBitmap:Bitmap;
      
      private var _skillTimesTxt:FilterFrameText;
      
      private var _skillTimesTxt1:FilterFrameText;
      
      private var _redBall:Bitmap;
      
      private var _redBallTwo:Bitmap;
      
      private var tweenFlag:Boolean = true;
      
      private var _helpframe:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var gameOver:Boolean = false;
      
      private var alert:BaseAlerFrame;
      
      private var alart1:BaseAlerFrame;
      
      private var useSkillType:int;
      
      private var canClickNum:int = 0;
      
      private var canClick:Boolean = true;
      
      private var isMove:Boolean = false;
      
      private var saveDestroyArr:Array = [];
      
      private var useSkillScore:int = 0;
      
      public function PetIslandView()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
         this.loadHead();
      }
      
      private function loadHead() : void
      {
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         this._headLoader = new SceneCharacterLoaderHead(PlayerManager.Instance.Self);
         this._headLoader.load(this.headLoaderCallBack);
      }
      
      private function headLoaderCallBack(param1:SceneCharacterLoaderHead, param2:Boolean = true) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(Boolean(param1))
         {
            if(!this._headBitmap)
            {
               this._headBitmap = new Bitmap();
            }
            _loc3_ = new Rectangle(0,0,120,103);
            _loc4_ = new BitmapData(120,103,true,0);
            _loc4_.copyPixels(param1.getContent()[0] as BitmapData,_loc3_,new Point(0,0));
            this._headBitmap.bitmapData = _loc4_;
            param1.dispose();
            this._headBitmap.rotationY = 180;
            this._headBitmap.x = 137;
            this._headBitmap.y = 80;
            this.playerHead.addChild(this._headBitmap);
         }
      }
      
      private function initData() : void
      {
         this.setPlayerScore();
         this.setNpcScore();
         this.setBegin();
      }
      
      private function setBegin() : void
      {
         switch(int(PetIslandManager.instance.model.openType))
         {
            case 0:
               this._begin.visible = true;
               this.beginFlash.visible = true;
               this.beginFlash.play();
               this.stopPlayBlackBg.visible = true;
               this._continue.visible = false;
               this._roundMc.visible = false;
               this.canClick = false;
               break;
            case 1:
               this._begin.visible = false;
               this.beginFlash.visible = false;
               this.beginFlash.stop();
               this.stopPlayBlackBg.visible = false;
               this._continue.visible = false;
               this._roundMc.visible = true;
               this.canClick = true;
               this.setStep();
               break;
            case 2:
               this._begin.visible = false;
               this.beginFlash.visible = true;
               this.beginFlash.play();
               this._continue.visible = true;
               this.stopPlayBlackBg.visible = true;
               this._roundMc.visible = false;
               this.canClick = false;
         }
      }
      
      private function setSaveLifeCount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         while(this._bloodContain.numChildren > 0)
         {
            this._bloodContain.removeChildAt(0);
         }
         _loc1_ = 0;
         while(_loc1_ < PetIslandManager.instance.model.saveLifeCount)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.petIsland.blood");
            _loc2_.x = 125 + _loc2_.width * _loc1_;
            _loc2_.y = 90;
            this._bloodContain.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function setStep() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this._currentStep = PetIslandManager.instance.model.step;
         while(this._roundMc.numChildren > 0)
         {
            this._roundMc.removeChildAt(0);
         }
         if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearPlaySoncount.length)
         {
            _loc1_ = "";
         }
         else
         {
            _loc1_ = String(parseInt(ServerConfigManager.instance.petDisappearPlaySoncount[PetIslandManager.instance.model.currentLevel - 1]) - PetIslandManager.instance.model.step);
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = ComponentFactory.Instance.creat("asset.petIsland.bigMathMc");
            _loc3_.gotoAndStop(1 + parseInt(_loc1_.substr(_loc2_,1)));
            if(_loc1_.length > 1)
            {
               _loc3_.x = 35 * _loc2_ - 18;
            }
            this._roundMc.addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function setPlayerScore() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         while(this._playerMathContain.numChildren > 0)
         {
            this._playerMathContain.removeChildAt(0);
         }
         var _loc3_:String = String(PetIslandManager.instance.model.playerScore);
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc2_ = ComponentFactory.Instance.creat("asset.petIsland.mathMc");
            _loc2_.gotoAndStop(1 + parseInt(_loc3_.substr(_loc1_,1)));
            _loc2_.x = 18 * _loc1_;
            this._playerMathContain.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function setNpcScore() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         while(this._npcMathContain.numChildren > 0)
         {
            this._npcMathContain.removeChildAt(0);
         }
         var _loc3_:String = String(PetIslandManager.instance.model.npcScore);
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc2_ = ComponentFactory.Instance.creat("asset.petIsland.mathMc");
            _loc2_.gotoAndStop(1 + parseInt(_loc3_.substr(_loc1_,1)));
            _loc2_.x = 18 * _loc1_;
            this._npcMathContain.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function initView() : void
      {
         var _loc1_:* = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.petIsland.bg");
         addChild(this._bg);
         this._mask = new Shape();
         this._mask.graphics.beginFill(255);
         this._mask.graphics.drawRect(317,222,375,375);
         addChild(this._mask);
         this._contain.mask = this._mask;
         PositionUtils.setPos(this._contain,"asset.petIsland.mask.position");
         this.pList = PetIslandManager.instance.model.pList;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.pList.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this.numberArr.length)
            {
               _loc3_ = 0;
               while(_loc3_ < this.numberArr[_loc2_].length)
               {
                  _loc1_ = this.pList[_loc2_][_loc3_] as PetIslandCell;
                  this._contain.addChild(_loc1_);
                  _loc1_.x = _loc3_ * 70;
                  _loc1_.y = _loc2_ * 70;
                  _loc3_++;
               }
               _loc2_++;
            }
         }
         else
         {
            this.refresh();
         }
         this.flyFlash = ComponentFactory.Instance.creat("asset.petIsland.flyFlash");
         this.flyFlash.visible = false;
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("asset.petIsland.buyBtn");
         this._buyBtn.tipData = LanguageMgr.GetTranslation("ddt.petIsland.useSkillTip");
         this._buySkillTwoBtn = ComponentFactory.Instance.creatComponentByStylename("asset.petIsland.buySkillTwoBtn");
         this._buySkillTwoBtn.tipData = LanguageMgr.GetTranslation("ddt.petIsland.useCrossSkillTip");
         if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearMaxLevel)
         {
         }
         this._redBall = ComponentFactory.Instance.creatBitmap("asset.petIsland.redBall");
         this._redBallTwo = ComponentFactory.Instance.creatBitmap("asset.petIsland.redBall");
         PositionUtils.setPos(this._redBallTwo,"asset.petIsland.redBallTwo");
         this._skillTimesTxt = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.skillTimesTxt");
         this._skillTimesTxt.text = String(ServerConfigManager.instance.petDisappearSkillMaxTimes - PetIslandManager.instance.model.saveLifeCount);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("asset.petIsland.helpBtn");
         this._skillTimesTxt1 = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.skillTimesTxt");
         this._skillTimesTxt1.text = String(ServerConfigManager.instance.petDisappearSkillTwoMaxTimes - PetIslandManager.instance.model.saveLife2Count);
         PositionUtils.setPos(this._skillTimesTxt1,"petIsland.view.skillTwoTimesTxt.position");
         PositionUtils.setPos(this._playerMathContain,"asset.petIsland.playerScore.position");
         PositionUtils.setPos(this._npcMathContain,"asset.petIsland.npcScore.position");
         PositionUtils.setPos(this._roundMc,"asset.petIsland.round.position");
         this._beginBtn = ComponentFactory.Instance.creatComponentByStylename("asset.petIsland.beginBgBtn");
         this._begin = ComponentFactory.Instance.creatBitmap("asset.petIsland.begin");
         this._continue = ComponentFactory.Instance.creatBitmap("asset.petIsland.continue");
         this.beginFlash = ComponentFactory.Instance.creat("asset.petIsland.beginFlash");
         this.beginFlash.x = 227;
         this.beginFlash.y = 128;
         this.beginFlash.mouseEnabled = this.beginFlash.mouseChildren = false;
         this._roundTxt = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.roundTxt");
         this._playerScore = ComponentFactory.Instance.creatBitmap("asset.petIsland.score");
         this._npcScore = ComponentFactory.Instance.creatBitmap("asset.petIsland.score");
         PositionUtils.setPos(this._playerScore,"asset.petIsland.playerScore.position1");
         PositionUtils.setPos(this._npcScore,"asset.petIsland.npcScore.position1");
         this._playerBlood = ComponentFactory.Instance.creatBitmap("asset.petIsland.playerBlood");
         this.playerMask = new Sprite();
         this.playerMask.graphics.beginFill(16777215,1);
         this.playerMask.graphics.drawRect(0,0,this._playerBlood.width,this._playerBlood.height);
         this.playerMask.graphics.endFill();
         this.playerMask.x = this._playerBlood.x;
         this.playerMask.y = this._playerBlood.y;
         this._playerBlood.mask = this.playerMask;
         this._playerBloodTxt = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.playerBloodTxt");
         this._npcBlood = ComponentFactory.Instance.creatBitmap("asset.petIsland.npcBlood");
         this.npcMask = new Sprite();
         this.npcMask.graphics.beginFill(16777215,1);
         this.npcMask.graphics.drawRect(0,0,this._npcBlood.width,this._npcBlood.height);
         this.npcMask.graphics.endFill();
         this.npcMask.x = this._npcBlood.x;
         this.npcMask.y = this._npcBlood.y;
         this._npcBlood.mask = this.npcMask;
         this._npcBloodTxt = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.npcBloodTxt");
         this.npcHead = ComponentFactory.Instance.creat("asset.petIsland.npcHead");
         this.npcHead.x = 870;
         this.npcHead.y = 78;
         this.npcHead.gotoAndStop(PetIslandManager.instance.model.currentLevel);
         this.prizeView = new PetIslandPrizeView();
         this.prizeView.setPrizeView();
         this.bloodFlash = ComponentFactory.Instance.creat("asset.petIsland.bloodFlash");
         this.success = ComponentFactory.Instance.creat("asset.petIsland.success");
         this.success.x = 65;
         this.success.y = 107;
         this.success.scaleX = this.success.scaleY = 0.6;
         this.fail = ComponentFactory.Instance.creat("asset.petIsland.fail");
         this.fail.x = 415;
         this.fail.y = 260;
         this.blackBg.graphics.beginFill(0,0.6);
         this.blackBg.graphics.drawRect(0,0,1000,600);
         this.blackBg.graphics.endFill();
         this.blackBg.visible = false;
         this.stopPlayBlackBg.graphics.beginFill(0,0.6);
         this.stopPlayBlackBg.graphics.drawRect(320,230,360,360);
         this.stopPlayBlackBg.graphics.endFill();
         this.stopPlayBlackBg.visible = false;
         this._info = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.infoTxt");
         this._info.htmlText = PetIslandManager.instance.model.infoStr;
         if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearMaxLevel)
         {
            this.npcMask.width = Math.floor(PetIslandManager.instance.model.npcBlood / ServerConfigManager.instance.petDisappearNPCBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1] * this._npcBlood.width * 100) / 100;
            this.playerMask.width = Math.floor(PetIslandManager.instance.model.playerBlood / ServerConfigManager.instance.petDisappearPlayerBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1] * this._playerBlood.width * 100) / 100;
            this._npcBloodTxt.text = PetIslandManager.instance.model.npcBlood + "/" + ServerConfigManager.instance.petDisappearNPCBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1];
            this._playerBloodTxt.text = PetIslandManager.instance.model.playerBlood + "/" + ServerConfigManager.instance.petDisappearPlayerBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1];
            this._roundTxt.text = LanguageMgr.GetTranslation("ddt.petIsland.roundTxt",PetIslandManager.instance.model.round,ServerConfigManager.instance.petDisappearPlaycount[ServerConfigManager.instance.petDisappearMaxLevel - 1]);
         }
         else
         {
            this.npcMask.width = Math.floor(PetIslandManager.instance.model.npcBlood / ServerConfigManager.instance.petDisappearNPCBlood[PetIslandManager.instance.model.currentLevel - 1] * this._npcBlood.width * 100) / 100;
            this.playerMask.width = Math.floor(PetIslandManager.instance.model.playerBlood / ServerConfigManager.instance.petDisappearPlayerBlood[PetIslandManager.instance.model.currentLevel - 1] * this._playerBlood.width * 100) / 100;
            this._npcBloodTxt.text = PetIslandManager.instance.model.npcBlood + "/" + ServerConfigManager.instance.petDisappearNPCBlood[PetIslandManager.instance.model.currentLevel - 1];
            this._playerBloodTxt.text = PetIslandManager.instance.model.playerBlood + "/" + ServerConfigManager.instance.petDisappearPlayerBlood[PetIslandManager.instance.model.currentLevel - 1];
            this._roundTxt.text = LanguageMgr.GetTranslation("ddt.petIsland.roundTxt",PetIslandManager.instance.model.round,ServerConfigManager.instance.petDisappearPlaycount[PetIslandManager.instance.model.currentLevel - 1]);
         }
         this.npcMask.x = this._npcBlood.x + this._npcBlood.width - this.npcMask.width;
         this._returnBtn = new PetIslandReturnBar();
         PositionUtils.setPos(this._returnBtn,"asset.petIsland.returnBtnPos");
         addChild(this._contain);
         addChild(this._returnBtn);
         addChild(this.flyFlash);
         addChild(this._playerMathContain);
         addChild(this._npcMathContain);
         addChild(this._beginBtn);
         addChild(this._begin);
         addChild(this._roundMc);
         addChild(this._continue);
         addChild(this._roundTxt);
         addChild(this._playerScore);
         addChild(this._npcScore);
         addChild(this._bloodContain);
         addChild(this._playerBlood);
         addChild(this.playerMask);
         addChild(this._npcBlood);
         addChild(this.npcMask);
         addChild(this.prizeView);
         addChild(this._npcBloodTxt);
         addChild(this.bloodFlash);
         addChild(this.npcHead);
         addChild(this.playerHead);
         addChild(this._playerBloodTxt);
         addChild(this._info);
         addChild(this.beginFlash);
         addChild(this._buyBtn);
         addChild(this._buySkillTwoBtn);
         addChild(this._redBall);
         addChild(this._redBallTwo);
         addChild(this._skillTimesTxt);
         addChild(this._skillTimesTxt1);
         addChild(this._helpBtn);
         addChild(this.stopPlayBlackBg);
         addChild(this.blackBg);
         addChild(this.success);
         addChild(this.fail);
      }
      
      private function stepChangeHandler(param1:PetIslandEvent) : void
      {
         if(Boolean(param1.resultData))
         {
            ++this.canClickNum;
            if(this.canClickNum == 2)
            {
               this.canClick = true;
               this.canClickNum = 0;
            }
         }
         else
         {
            PetIslandManager.instance.dispatchEvent(new PetIslandEvent("return_petIsLand"));
         }
      }
      
      private function refresh(param1:PetIslandEvent = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:* = null;
         if(param1 != null)
         {
            PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.continue") + "\n" + PetIslandManager.instance.model.infoStr;
            this._info.htmlText = PetIslandManager.instance.model.infoStr;
         }
         while(this._contain.numChildren > 0)
         {
            this._contain.removeChildAt(0);
         }
         this.pList = PetIslandManager.instance.model.pList = [];
         _loc2_ = 0;
         while(_loc2_ < this.numberArr.length)
         {
            _loc3_ = [];
            _loc4_ = 0;
            while(_loc4_ < this.numberArr[_loc2_].length)
            {
               do
               {
                  _loc5_ = this.randomInt(4);
                  this.numberArr[_loc2_][_loc4_] = _loc5_;
                  _loc6_ = this.checkArr(_loc2_,_loc4_,this.numberArr);
               }
               while(!_loc6_);
               _loc7_ = new PetIslandCell(_loc5_,_loc2_,_loc4_);
               this._contain.addChild(_loc7_);
               _loc3_.push(_loc7_);
               _loc7_.x = _loc4_ * 70;
               _loc7_.y = _loc2_ * 70;
               _loc4_++;
            }
            this.pList.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         PetIslandManager.instance.addEventListener("return_petIsLand",this.__onReturn);
         PetIslandManager.instance.addEventListener("pet_click",this.__petClickHandler);
         PetIslandManager.instance.addEventListener("destroy",this.__destroyHandler);
         PetIslandManager.instance.model.addEventListener("npcscore",this._npcScoreChange);
         PetIslandManager.instance.model.addEventListener("playerscore",this._playerScoreChange);
         PetIslandManager.instance.model.addEventListener("round",this.__currentRoundChange);
         PetIslandManager.instance.model.addEventListener("rewardRecord",this.__rewardRecordChange);
         PetIslandManager.instance.model.addEventListener("step",this.__stepChange);
         PetIslandManager.instance.model.addEventListener("playerBlood",this.__playerBloodChange);
         PetIslandManager.instance.model.addEventListener("npcBlood",this.__npcBloodChange);
         PetIslandManager.instance.model.addEventListener("openType",this.__opentypeChange);
         PetIslandManager.instance.model.addEventListener("currentLevel",this.__currentLevelChange);
         PetIslandManager.instance.model.addEventListener("useSkill",this.__useSkillChange);
         PetIslandManager.instance.model.addEventListener("useSkillTwo",this.__useSkillTwoChange);
         PetIslandManager.instance.addEventListener("saveLifeCount",this.__saveLifeCountChange);
         PetIslandManager.instance.addEventListener("refresh",this.refresh);
         PetIslandManager.instance.addEventListener("stepChange",this.stepChangeHandler);
         this._beginBtn.addEventListener("click",this.__beginBtnClickHandler);
         this._buyBtn.addEventListener("click",this.__buyBtnClickHandler);
         this._buySkillTwoBtn.addEventListener("click",this.__buySkillTwoBtnClickHandler);
         this._helpBtn.addEventListener("click",this.__helpBtnClickHandler);
         this.success.addEventListener("com",this.completeHandler);
         this.fail.addEventListener("com",this.completeHandler);
      }
      
      private function __helpBtnClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._helpframe)
         {
            this._helpframe = ComponentFactory.Instance.creatComponentByStylename("petIsland.frame.help.main");
            this._helpframe.titleText = LanguageMgr.GetTranslation("zodiac.mainframe.title");
            this._helpframe.addEventListener("response",this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("petIsland.frame.help.bgHelp");
            this._content = ComponentFactory.Instance.creat("petIsland.frame.help.content");
            PositionUtils.setPos(this._content,"asset.petIsland.content.pos");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("petIsland.frame.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener("click",this.__closeHelpFrame);
            this._helpframe.addToContent(this._bgHelp);
            this._helpframe.addToContent(this._content);
            this._helpframe.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpframe,3,true,2);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this._helpframe.parent.removeChild(this._helpframe);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpframe.parent.removeChild(this._helpframe);
      }
      
      private function completeHandler(param1:Event) : void
      {
         this.blackBg.visible = false;
      }
      
      private function __useSkillChange(param1:PetIslandEvent) : void
      {
         this._skillTimesTxt.text = String(ServerConfigManager.instance.petDisappearSkillMaxTimes - PetIslandManager.instance.model.saveLifeCount);
      }
      
      private function __useSkillTwoChange(param1:PetIslandEvent) : void
      {
         this._skillTimesTxt1.text = String(ServerConfigManager.instance.petDisappearSkillTwoMaxTimes - PetIslandManager.instance.model.saveLife2Count);
      }
      
      private function __saveLifeCountChange(param1:PetIslandEvent) : void
      {
         if(param1.resultData == 1)
         {
            this.checkOneTypeAll();
         }
         else if(param1.resultData == 2)
         {
            this.crossDestroy();
         }
      }
      
      private function __currentLevelChange(param1:PetIslandEvent) : void
      {
         if(PetIslandManager.instance.model.currentLevel <= ServerConfigManager.instance.petDisappearMaxLevel)
         {
            PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.gamePass",PetIslandManager.instance.model.currentLevel - 1) + "\n" + LanguageMgr.GetTranslation("ddt.petIsland.attackInfo",param1.resultData) + "\n" + PetIslandManager.instance.model.infoStr;
            this._info.htmlText = PetIslandManager.instance.model.infoStr;
         }
         setTimeout(this.doSuccess,1000);
         this.mouseChildren = this.mouseEnabled = false;
         this.npcHead.gotoAndStop(PetIslandManager.instance.model.currentLevel);
         this.prizeView.setPrizeView();
      }
      
      private function doSuccess() : void
      {
         this.mouseChildren = this.mouseEnabled = true;
         this.success.play();
         this.blackBg.visible = true;
      }
      
      private function __opentypeChange(param1:PetIslandEvent) : void
      {
         if(PetIslandManager.instance.model.openType == 2)
         {
            this.gameOver = true;
            this.fail.play();
            this.blackBg.visible = true;
         }
         this.setBegin();
      }
      
      private function __playerBloodChange(param1:PetIslandEvent) : void
      {
         if(param1.resultData > 0)
         {
            this.bloodFlash.x = 6;
            this.bloodFlash.y = 91;
            this.bloodFlash.rotationY = 0;
            this.bloodFlash.play();
            if(PetIslandManager.instance.model.playerBlood != 0 && PetIslandManager.instance.model.openType != 2)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.nextRound"));
            }
            PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.defenceInfo",param1.resultData) + "\n" + PetIslandManager.instance.model.infoStr;
            this._info.htmlText = PetIslandManager.instance.model.infoStr;
            if(this.gameOver)
            {
               this.gameOver = false;
               PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.gameOver",PetIslandManager.instance.model.currentLevel) + "\n" + PetIslandManager.instance.model.infoStr;
               this._info.htmlText = PetIslandManager.instance.model.infoStr;
            }
         }
         if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearMaxLevel)
         {
            this.playerMask.width = Math.floor(PetIslandManager.instance.model.playerBlood / ServerConfigManager.instance.petDisappearPlayerBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1] * this._playerBlood.width * 100) / 100;
            this._playerBloodTxt.text = PetIslandManager.instance.model.playerBlood + "/" + ServerConfigManager.instance.petDisappearPlayerBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1];
         }
         else
         {
            this.playerMask.width = Math.floor(PetIslandManager.instance.model.playerBlood / ServerConfigManager.instance.petDisappearPlayerBlood[PetIslandManager.instance.model.currentLevel - 1] * this._playerBlood.width * 100) / 100;
            this._playerBloodTxt.text = PetIslandManager.instance.model.playerBlood + "/" + ServerConfigManager.instance.petDisappearPlayerBlood[PetIslandManager.instance.model.currentLevel - 1];
         }
      }
      
      private function __npcBloodChange(param1:PetIslandEvent) : void
      {
         if(param1.resultData > 0)
         {
            this.bloodFlash.x = 992;
            this.bloodFlash.y = 91;
            this.bloodFlash.rotationY = 180;
            this.bloodFlash.play();
            if(PetIslandManager.instance.model.openType != 2)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.nextRound"));
            }
            PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.attackInfo",param1.resultData) + "\n" + PetIslandManager.instance.model.infoStr;
            this._info.htmlText = PetIslandManager.instance.model.infoStr;
            if(this.gameOver)
            {
               this.gameOver = false;
               PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.gameOver",PetIslandManager.instance.model.currentLevel) + "\n" + PetIslandManager.instance.model.infoStr;
               this._info.htmlText = PetIslandManager.instance.model.infoStr;
            }
         }
         if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearMaxLevel)
         {
            this.npcMask.width = Math.floor(PetIslandManager.instance.model.npcBlood / ServerConfigManager.instance.petDisappearNPCBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1] * this._npcBlood.width * 100) / 100;
            this._npcBloodTxt.text = PetIslandManager.instance.model.npcBlood + "/" + ServerConfigManager.instance.petDisappearNPCBlood[ServerConfigManager.instance.petDisappearMaxLevel - 1];
         }
         else
         {
            this.npcMask.width = Math.floor(PetIslandManager.instance.model.npcBlood / ServerConfigManager.instance.petDisappearNPCBlood[PetIslandManager.instance.model.currentLevel - 1] * this._npcBlood.width * 100) / 100;
            this._npcBloodTxt.text = PetIslandManager.instance.model.npcBlood + "/" + ServerConfigManager.instance.petDisappearNPCBlood[PetIslandManager.instance.model.currentLevel - 1];
         }
         this.npcMask.x = this._npcBlood.x + this._npcBlood.width - this.npcMask.width;
      }
      
      private function __rewardRecordChange(param1:PetIslandEvent) : void
      {
         this.prizeView.setPrizeView();
      }
      
      private function __stepChange(param1:PetIslandEvent) : void
      {
         this.setStep();
      }
      
      private function __currentRoundChange(param1:PetIslandEvent) : void
      {
         if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearMaxLevel)
         {
            this._roundTxt.text = LanguageMgr.GetTranslation("ddt.petIsland.roundTxt",PetIslandManager.instance.model.round,ServerConfigManager.instance.petDisappearPlaycount[ServerConfigManager.instance.petDisappearMaxLevel - 1]);
            return;
         }
         this._roundTxt.text = LanguageMgr.GetTranslation("ddt.petIsland.roundTxt",PetIslandManager.instance.model.round,ServerConfigManager.instance.petDisappearPlaycount[PetIslandManager.instance.model.currentLevel - 1]);
      }
      
      private function __beginBtnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.play("008");
         switch(int(PetIslandManager.instance.model.openType))
         {
            case 0:
               if(PetIslandManager.instance.model.currentLevel > ServerConfigManager.instance.petDisappearMaxLevel)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.todayGameIsEnding"));
                  return;
               }
               SocketManager.Instance.out.petIslandInit(3);
               PetIslandManager.instance.model.openType = 1;
               break;
            case 1:
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.gameIsPlaying"));
               break;
            case 2:
               _loc2_ = LanguageMgr.GetTranslation("ddt.petIsland.useMoney",ServerConfigManager.instance.petDisappearRecoverPrice);
               this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
               this.alert.addEventListener("response",this.__onRecoverResponse);
         }
      }
      
      private function __onRecoverResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.alert.removeEventListener("response",this.__onRecoverResponse);
         var _loc2_:int = ServerConfigManager.instance.petDisappearRecoverPrice;
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            this.alert.dispose();
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               this.alart1 = LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.petIslandInit(2);
         }
         this.alert.dispose();
      }
      
      private function __onRecoverResponse1(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.alert.removeEventListener("response",this.__onRecoverResponse1);
         var _loc2_:int = this.useSkillType == 1 ? int(ServerConfigManager.instance.petDisappearSkillMoney[PetIslandManager.instance.model.saveLifeCount]) : int(ServerConfigManager.instance.petDisappearSkillTwoMoney[PetIslandManager.instance.model.saveLife2Count]);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            this.alert.dispose();
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(PlayerManager.Instance.Self.Money < _loc2_)
            {
               this.alart1 = LeavePageManager.showFillFrame();
               return;
            }
            this.canClick = false;
            ++this.canClickNum;
            this.mouseEnabled = this.mouseChildren = false;
            SocketManager.Instance.out.petIslandBuyBlood(this.useSkillType);
         }
         this.alert.dispose();
      }
      
      private function __buySkillTwoBtnClickHandler(param1:MouseEvent) : void
      {
         if(PetIslandManager.instance.model.openType != 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.gameNoBegin"));
            return;
         }
         if(PetIslandManager.instance.model.saveLife2Count >= ServerConfigManager.instance.petDisappearSkillTwoMaxTimes)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.overMaxUse"));
            return;
         }
         this.useSkillType = 2;
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.petIsland.useMoney",ServerConfigManager.instance.petDisappearSkillTwoMoney[PetIslandManager.instance.model.saveLife2Count]);
         this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
         this.alert.addEventListener("response",this.__onRecoverResponse1);
      }
      
      private function __buyBtnClickHandler(param1:MouseEvent) : void
      {
         if(PetIslandManager.instance.model.openType != 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.gameNoBegin"));
            return;
         }
         if(PetIslandManager.instance.model.saveLifeCount >= ServerConfigManager.instance.petDisappearSkillMaxTimes)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.petIsland.overMaxUse"));
            return;
         }
         this.useSkillType = 1;
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.petIsland.useMoney",ServerConfigManager.instance.petDisappearSkillMoney[PetIslandManager.instance.model.saveLifeCount]);
         this.alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
         this.alert.addEventListener("response",this.__onRecoverResponse1);
      }
      
      private function _npcScoreChange(param1:PetIslandEvent) : void
      {
         this.setNpcScore();
      }
      
      private function _playerScoreChange(param1:PetIslandEvent) : void
      {
         this.setPlayerScore();
      }
      
      private function __petClickHandler(param1:PetIslandEvent) : void
      {
         if(!this.canClick)
         {
            return;
         }
         this.canClick = false;
         var _loc2_:PetIslandCell = param1.resultData as PetIslandCell;
         var _loc3_:Array = this.checkRoundShine(_loc2_._row,_loc2_._col);
         this.clearShine();
         if(_loc3_.length > 0)
         {
            this.isMove = true;
            this.mouseEnabled = this.mouseChildren = false;
            this.swap([_loc2_._row,_loc2_._col],_loc3_);
         }
         else
         {
            this.pList[_loc2_._row][_loc2_._col].isShine = true;
            this.canClick = true;
         }
      }
      
      private function clearShine() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.pList.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.pList[_loc1_].length)
            {
               this.pList[_loc1_][_loc2_].isShine = false;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function __onReturn(param1:PetIslandEvent) : void
      {
         SoundManager.instance.play("008");
         StateManager.setState("main");
      }
      
      private function checkOneTypeAll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = [0,0,0,0];
         _loc2_ = 0;
         while(_loc2_ < this.pList.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.pList[_loc2_].length)
            {
               _loc1_ = int(this.pList[_loc2_][_loc3_].type);
               ++_loc4_[_loc1_ - 1];
               _loc3_++;
            }
            _loc2_++;
         }
         var _loc5_:Number = Math.max(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(_loc5_ == _loc4_[_loc2_])
            {
               _loc1_ = _loc2_ + 1;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.pList.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.pList[_loc2_].length)
            {
               if(this.pList[_loc2_][_loc3_].type == _loc1_)
               {
                  this.saveDestroyArr.push({
                     "row":_loc2_,
                     "col":_loc3_,
                     "type":this.pList[_loc2_][_loc3_].type
                  });
               }
               _loc3_++;
            }
            _loc2_++;
         }
         this.checkAndDestroy();
      }
      
      private function crossDestroy(param1:int = 3, param2:int = 3) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.pList.length)
         {
            _loc4_ = 0;
            while(_loc4_ < this.pList[_loc3_].length)
            {
               if(_loc3_ + 1 == param1 || _loc4_ + 1 == param2)
               {
                  if(_loc3_ + 1 == param1 && _loc4_ + 1 == param2)
                  {
                     this.saveDestroyArr.unshift({
                        "row":_loc3_,
                        "col":_loc4_,
                        "type":this.pList[_loc3_][_loc4_].type
                     });
                  }
                  else
                  {
                     this.saveDestroyArr.push({
                        "row":_loc3_,
                        "col":_loc4_,
                        "type":this.pList[_loc3_][_loc4_].type
                     });
                  }
               }
               _loc4_++;
            }
            _loc3_++;
         }
         this.checkAndDestroy();
      }
      
      private function checkAndDestroy() : void
      {
         var _loc3_:Boolean;
         var _loc5_:FilterFrameText;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:* = null;
         var _loc1_:int = 0;
         if(!this.tweenFlag)
         {
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < this.pList.length)
         {
            _loc4_ = 1;
            while(_loc4_ < this.pList[_loc6_].length - 1)
            {
               if(this.pList[_loc6_][_loc4_].type == this.pList[_loc6_][_loc4_ - 1].type && this.pList[_loc6_][_loc4_].type == this.pList[_loc6_][_loc4_ + 1].type)
               {
                  this.saveDestroyArr.push({
                     "row":_loc6_,
                     "col":_loc4_,
                     "type":this.pList[_loc6_][_loc4_].type
                  });
                  this.saveDestroyArr.push({
                     "row":_loc6_,
                     "col":_loc4_ - 1,
                     "type":this.pList[_loc6_][_loc4_ - 1].type
                  });
                  this.saveDestroyArr.push({
                     "row":_loc6_,
                     "col":_loc4_ + 1,
                     "type":this.pList[_loc6_][_loc4_ + 1].type
                  });
                  while(true)
                  {
                     _loc4_++;
                     if(!(_loc4_ < this.pList[_loc6_].length - 1 && this.pList[_loc6_][_loc4_].type == this.pList[_loc6_][_loc4_ + 1].type))
                     {
                        break;
                     }
                     this.saveDestroyArr.push({
                        "row":_loc6_,
                        "col":_loc4_ + 1,
                        "type":this.pList[_loc6_][_loc4_ + 1].type
                     });
                  }
               }
               _loc4_++;
            }
            _loc6_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.pList[0].length)
         {
            _loc6_ = 1;
            while(_loc6_ < this.pList.length - 1)
            {
               if(this.pList[_loc6_][_loc4_].type == this.pList[_loc6_ - 1][_loc4_].type && this.pList[_loc6_][_loc4_].type == this.pList[_loc6_ + 1][_loc4_].type)
               {
                  this.saveDestroyArr.push({
                     "row":_loc6_,
                     "col":_loc4_,
                     "type":this.pList[_loc6_][_loc4_].type
                  });
                  this.saveDestroyArr.push({
                     "row":_loc6_ - 1,
                     "col":_loc4_,
                     "type":this.pList[_loc6_ - 1][_loc4_].type
                  });
                  this.saveDestroyArr.push({
                     "row":_loc6_ + 1,
                     "col":_loc4_,
                     "type":this.pList[_loc6_ + 1][_loc4_].type
                  });
                  while(true)
                  {
                     _loc6_++;
                     if(!(_loc6_ < this.pList.length - 1 && this.pList[_loc6_][_loc4_].type == this.pList[_loc6_ + 1][_loc4_].type))
                     {
                        break;
                     }
                     this.saveDestroyArr.push({
                        "row":_loc6_ + 1,
                        "col":_loc4_,
                        "type":this.pList[_loc6_][_loc4_].type
                     });
                  }
               }
               _loc6_++;
            }
            _loc4_++;
         }
         if(this.saveDestroyArr.length == 0)
         {
            if(this.useSkillType != 0)
            {
               _loc2_ = LanguageMgr.GetTranslation("ddt.petIsland.skill").split("|")[this.useSkillType - 1];
               PetIslandManager.instance.model.infoStr = LanguageMgr.GetTranslation("ddt.petIsland.useSkillInfo",_loc2_,this.useSkillScore) + "\n" + PetIslandManager.instance.model.infoStr;
               this._info.htmlText = PetIslandManager.instance.model.infoStr;
               this.useSkillType = 0;
               this.useSkillScore = 0;
            }
            if(this.isMove)
            {
               SocketManager.Instance.out.petIslandPlay(0,0);
               ++this._currentStep;
            }
            ++this.canClickNum;
            if(this.canClickNum == 2)
            {
               this.canClick = true;
               this.canClickNum = 0;
            }
            this.isMove = false;
            this.mouseEnabled = this.mouseChildren = true;
            if(this._currentStep == ServerConfigManager.instance.petDisappearPlaySoncount[PetIslandManager.instance.model.currentLevel - 1])
            {
               SocketManager.Instance.out.petIslandPlay(1,0,true);
            }
            return;
         }
         this.nowPoints = 0;
         _loc3_ = false;
         _loc1_ = 0;
         while(_loc1_ < this.saveDestroyArr.length)
         {
            if(Boolean(this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col]) && this._contain.contains(this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col]))
            {
               this._contain.setChildIndex(this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col],this._contain.numChildren - 1);
               this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col].destroy();
               ++this.points;
               this.nowPoints += ServerConfigManager.instance.petDisappearAddScore;
               if(!_loc3_)
               {
                  _loc3_ = true;
                  this.flyFlash.visible = true;
                  this.flyFlash.x = this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col].x + this._contain.x + this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col].width / 2 - this.flyFlash.width / 2;
                  this.flyFlash.y = this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col].y + this._contain.y + this.pList[this.saveDestroyArr[_loc1_].row][this.saveDestroyArr[_loc1_].col].height / 2 - this.flyFlash.height / 2;
                  try
                  {
                     TweenLite.to(this.flyFlash,0.6,{
                        "delay":0.4,
                        "x":210,
                        "y":195,
                        "onComplete":this.flyFlashCom
                     });
                  }
                  catch(e:Error)
                  {
                     return;
                  }
               }
            }
            _loc1_++;
         }
         if(this.isMove)
         {
            this.isMove = false;
            SocketManager.Instance.out.petIslandPlay(0,this.nowPoints);
            ++this._currentStep;
         }
         else
         {
            if(this.useSkillType != 0)
            {
               this.useSkillScore += this.nowPoints;
            }
            SocketManager.Instance.out.petIslandPlay(1,this.nowPoints);
         }
         _loc5_ = ComponentFactory.Instance.creatComponentByStylename("petIsland.view.pointsPaopao");
         addChild(_loc5_);
         _loc5_.text = "+" + String(this.nowPoints);
         try
         {
            TweenLite.to(_loc5_,1.8,{
               "y":110,
               "alpha":0,
               "onComplete":this.tweenComplete,
               "onCompleteParams":[_loc5_]
            });
            this.saveDestroyArr = [];
            TweenLite.to(this._contain,0.4,{"onComplete":this.dropBlock});
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function flyFlashCom() : void
      {
         if(Boolean(this.flyFlash))
         {
            this.flyFlash.visible = false;
         }
      }
      
      private function __destroyHandler(param1:PetIslandEvent) : void
      {
         var _loc2_:PetIslandCell = param1.resultData as PetIslandCell;
         this._contain.removeChild(this.pList[_loc2_._row][_loc2_._col]);
         this.pList[_loc2_._row][_loc2_._col] = null;
      }
      
      private function tweenComplete(param1:FilterFrameText) : void
      {
         if(Boolean(param1) && param1.parent.contains(param1))
         {
            param1.parent.removeChild(param1);
            param1 = null;
         }
      }
      
      private function dropBlock() : void
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:Boolean = false;
         var _loc4_:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         if(!this.tweenFlag)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < this.numberArr[0].length)
         {
            _loc6_ = this.numberArr.length - 1;
            while(_loc6_ >= 0)
            {
               if(this.pList[_loc6_][_loc3_] == null && _loc6_ != 0)
               {
                  _loc5_ = false;
                  _loc4_ = _loc6_ - 1;
                  while(_loc4_ >= 0)
                  {
                     if(this.pList[_loc4_][_loc3_] != null)
                     {
                        try
                        {
                           TweenLite.to(this.pList[_loc4_][_loc3_],0.5,{
                              "x":_loc3_ * 70,
                              "y":_loc6_ * 70,
                              "ease":Elastic.easeOut,
                              "easeParams":[10,10]
                           });
                        }
                        catch(e:Error)
                        {
                           return;
                        }
                        this.pList[_loc6_][_loc3_] = this.pList[_loc4_][_loc3_];
                        this.pList[_loc6_][_loc3_]._row = _loc6_;
                        this.pList[_loc6_][_loc3_]._col = _loc3_;
                        this.pList[_loc4_][_loc3_] = null;
                        _loc5_ = true;
                        break;
                     }
                     _loc4_--;
                  }
                  if(!_loc5_)
                  {
                     _loc1_ = new PetIslandCell(this.randomInt(4),_loc6_,_loc3_);
                     this._contain.addChild(_loc1_);
                     _loc1_.x = _loc3_ * 70;
                     _loc1_.y = -70;
                     try
                     {
                        TweenLite.to(_loc1_,0.5,{
                           "x":_loc3_ * 70,
                           "y":_loc6_ * 70,
                           "ease":Elastic.easeOut,
                           "easeParams":[10,10]
                        });
                     }
                     catch(e:Error)
                     {
                        return;
                     }
                     this.pList[_loc6_][_loc3_] = _loc1_;
                     _loc5_ = true;
                  }
               }
               else if(this.pList[_loc6_][_loc3_] == null && _loc6_ == 0)
               {
                  _loc2_ = new PetIslandCell(this.randomInt(4),_loc6_,_loc3_);
                  this._contain.addChild(_loc2_);
                  _loc2_.x = _loc3_ * 70;
                  _loc2_.y = -70;
                  try
                  {
                     TweenLite.to(_loc2_,0.5,{
                        "x":_loc3_ * 70,
                        "y":_loc6_ * 70,
                        "ease":Elastic.easeOut,
                        "easeParams":[10,10]
                     });
                  }
                  catch(e:Error)
                  {
                     return;
                  }
                  this.pList[_loc6_][_loc3_] = _loc2_;
               }
               _loc6_--;
            }
            _loc3_++;
         }
         try
         {
            TweenLite.to(this._contain,0.5,{"onComplete":this.checkAndDestroy});
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function swap(param1:Array, param2:Array) : void
      {
         var _loc4_:PetIslandCell;
         var _loc3_:int;
         var _loc8_:int = int(this.pList[param1[0]][param1[1]].x);
         var _loc5_:int = int(this.pList[param1[0]][param1[1]].y);
         var _loc7_:int = int(this.pList[param2[0]][param2[1]].x);
         var _loc6_:int = int(this.pList[param2[0]][param2[1]].y);
         try
         {
            TweenLite.to(this.pList[param1[0]][param1[1]],0.4,{
               "x":_loc7_,
               "y":_loc6_
            });
            TweenLite.to(this.pList[param2[0]][param2[1]],0.4,{
               "x":_loc8_,
               "y":_loc5_,
               "onComplete":this.checkAndDestroy
            });
         }
         catch(e:Error)
         {
            return;
         }
         this.pList[param1[0]][param1[1]]._row = param2[0];
         this.pList[param1[0]][param1[1]]._col = param2[1];
         this.pList[param2[0]][param2[1]]._row = param1[0];
         this.pList[param2[0]][param2[1]]._col = param1[1];
         _loc4_ = this.pList[param1[0]][param1[1]];
         this.pList[param1[0]][param1[1]] = this.pList[param2[0]][param2[1]];
         this.pList[param2[0]][param2[1]] = _loc4_;
         _loc3_ = int(this.numberArr[param1[0]][param1[1]]);
         this.numberArr[param1[0]][param1[1]] = this.numberArr[param2[0]][param2[1]];
         this.numberArr[param2[0]][param2[1]] = _loc3_;
      }
      
      private function checkRoundShine(param1:int, param2:int) : Array
      {
         if(Boolean(param1 > 0) && Boolean(this.pList[param1 - 1][param2]) && Boolean(this.pList[param1 - 1][param2].isShine))
         {
            return [param1 - 1,param2];
         }
         if(Boolean(param2 > 0) && Boolean(this.pList[param1][param2 - 1]) && Boolean(this.pList[param1][param2 - 1].isShine))
         {
            return [param1,param2 - 1];
         }
         if(Boolean(param1 < this.pList.length - 1) && Boolean(this.pList[param1 + 1][param2]) && Boolean(this.pList[param1 + 1][param2].isShine))
         {
            return [param1 + 1,param2];
         }
         if(Boolean(param2 < this.pList.length - 1) && Boolean(this.pList[param1][param2 + 1]) && Boolean(this.pList[param1][param2 + 1].isShine))
         {
            return [param1,param2 + 1];
         }
         return [];
      }
      
      private function randomInt(param1:int) : int
      {
         return Math.floor(1 + param1 * Math.random());
      }
      
      private function checkArr(param1:int, param2:int, param3:Array) : Boolean
      {
         if(Boolean(param3[param1][param2 - 2]) && Boolean(param3[param1][param2 - 1]))
         {
            if(param3[param1][param2 - 2] == param3[param1][param2] && param3[param1][param2 - 1] == param3[param1][param2])
            {
               return false;
            }
         }
         if(Boolean(param3[param1][param2 - 1]) && Boolean(param3[param1][param2 + 1]))
         {
            if(param3[param1][param2 - 1] == param3[param1][param2] && param3[param1][param2] == param3[param1][param2 + 1])
            {
               return false;
            }
         }
         if(Boolean(param3[param1][param2 + 1]) && Boolean(param3[param1][param2 + 2]))
         {
            if(param3[param1][param2] == param3[param1][param2 + 1] && param3[param1][param2] == param3[param1][param2 + 2])
            {
               return false;
            }
         }
         if(param1 >= 2)
         {
            if(param3[param1 - 2][param2] == param3[param1][param2] && param3[param1 - 1][param2] == param3[param1][param2])
            {
               return false;
            }
         }
         if(param1 <= param3.length - 3)
         {
            if(param3[param1 + 2][param2] == param3[param1][param2] && param3[param1 + 1][param2] == param3[param1][param2])
            {
               return false;
            }
         }
         if(param1 > 0 && param1 < param3.length - 1)
         {
            if(param3[param1 + 1][param2] == param3[param1][param2] && param3[param1 - 1][param2] == param3[param1][param2])
            {
               return false;
            }
         }
         return true;
      }
      
      private function removeEvent() : void
      {
         PetIslandManager.instance.removeEventListener("return_petIsLand",this.__onReturn);
         PetIslandManager.instance.removeEventListener("pet_click",this.__petClickHandler);
         PetIslandManager.instance.removeEventListener("destroy",this.__destroyHandler);
         PetIslandManager.instance.model.removeEventListener("npcscore",this._npcScoreChange);
         PetIslandManager.instance.model.removeEventListener("playerscore",this._playerScoreChange);
         PetIslandManager.instance.model.removeEventListener("round",this.__currentRoundChange);
         PetIslandManager.instance.model.removeEventListener("step",this.__stepChange);
         PetIslandManager.instance.model.removeEventListener("rewardRecord",this.__rewardRecordChange);
         PetIslandManager.instance.model.removeEventListener("playerBlood",this.__playerBloodChange);
         PetIslandManager.instance.model.removeEventListener("npcBlood",this.__npcBloodChange);
         PetIslandManager.instance.model.removeEventListener("openType",this.__opentypeChange);
         PetIslandManager.instance.model.removeEventListener("currentLevel",this.__currentLevelChange);
         PetIslandManager.instance.model.removeEventListener("useSkill",this.__useSkillChange);
         PetIslandManager.instance.model.removeEventListener("useSkillTwo",this.__useSkillTwoChange);
         PetIslandManager.instance.removeEventListener("saveLifeCount",this.__saveLifeCountChange);
         PetIslandManager.instance.removeEventListener("refresh",this.refresh);
         PetIslandManager.instance.removeEventListener("stepChange",this.stepChangeHandler);
         this._beginBtn.removeEventListener("click",this.__beginBtnClickHandler);
         this._buyBtn.removeEventListener("click",this.__buyBtnClickHandler);
         this._buySkillTwoBtn.removeEventListener("click",this.__buySkillTwoBtnClickHandler);
         this._helpBtn.removeEventListener("click",this.__helpBtnClickHandler);
         this.success.removeEventListener("com",this.completeHandler);
         this.fail.removeEventListener("com",this.completeHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.tweenFlag = false;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._returnBtn);
         this._returnBtn = null;
         ObjectUtils.disposeObject(this._contain);
         this._contain = null;
         ObjectUtils.disposeObject(this.flyFlash);
         this.flyFlash = null;
         ObjectUtils.disposeObject(this._buyBtn);
         this._buyBtn = null;
         ObjectUtils.disposeObject(this._buySkillTwoBtn);
         this._buySkillTwoBtn = null;
         ObjectUtils.disposeObject(this._redBall);
         this._redBall = null;
         ObjectUtils.disposeObject(this._redBallTwo);
         this._redBallTwo = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._playerMathContain);
         this._playerMathContain = null;
         ObjectUtils.disposeObject(this._npcMathContain);
         this._npcMathContain = null;
         ObjectUtils.disposeObject(this._beginBtn);
         this._beginBtn = null;
         ObjectUtils.disposeObject(this._begin);
         this._begin = null;
         ObjectUtils.disposeObject(this._continue);
         this._continue = null;
         ObjectUtils.disposeObject(this._playerScore);
         this._playerScore = null;
         ObjectUtils.disposeObject(this._npcScore);
         this._npcScore = null;
         ObjectUtils.disposeObject(this._roundTxt);
         this._roundTxt = null;
         ObjectUtils.disposeObject(this._roundMc);
         this._roundMc = null;
         ObjectUtils.disposeObject(this._bloodContain);
         this._bloodContain = null;
         ObjectUtils.disposeObject(this._info);
         this._info = null;
         ObjectUtils.disposeObject(this._playerBlood);
         this._playerBlood = null;
         ObjectUtils.disposeObject(this.playerMask);
         this.playerMask = null;
         ObjectUtils.disposeObject(this._npcBlood);
         this._playerBlood = null;
         ObjectUtils.disposeObject(this.npcMask);
         this.playerMask = null;
         ObjectUtils.disposeObject(this.prizeView);
         this.prizeView = null;
         ObjectUtils.disposeObject(this._playerBloodTxt);
         this._playerBloodTxt = null;
         ObjectUtils.disposeObject(this._npcBloodTxt);
         this._npcBloodTxt = null;
         ObjectUtils.disposeObject(this.bloodFlash);
         this.bloodFlash = null;
         ObjectUtils.disposeObject(this.success);
         this.success = null;
         ObjectUtils.disposeObject(this.fail);
         this.fail = null;
         ObjectUtils.disposeObject(this.beginFlash);
         this.beginFlash = null;
         ObjectUtils.disposeObject(this.npcHead);
         this.npcHead = null;
         ObjectUtils.disposeObject(this.playerHead);
         this.playerHead = null;
         ObjectUtils.disposeObject(this.blackBg);
         this.blackBg = null;
         ObjectUtils.disposeObject(this.stopPlayBlackBg);
         this.stopPlayBlackBg = null;
         ObjectUtils.disposeObject(this._bgHelp);
         this._bgHelp = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._btnOk);
         this._btnOk = null;
         ObjectUtils.disposeObject(this._helpframe);
         this._helpframe = null;
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         ObjectUtils.disposeObject(this._headBitmap);
         this._headBitmap = null;
         ObjectUtils.disposeObject(this._skillTimesTxt);
         this._skillTimesTxt = null;
         ObjectUtils.disposeObject(this._skillTimesTxt1);
         this._skillTimesTxt1 = null;
         if(Boolean(this.alert))
         {
            this.alert.removeEventListener("response",this.__onRecoverResponse);
            this.alert.removeEventListener("response",this.__onRecoverResponse1);
            ObjectUtils.disposeObject(this.alert);
         }
         ObjectUtils.disposeObject(this.alart1);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

