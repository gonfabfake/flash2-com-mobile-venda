package farm.viewx.poultry
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.PositionUtils;
   import ddt.view.chat.chatBall.ChatBallPlayer;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import road.game.resource.ActionMovie;
   import room.RoomManager;
   import roomList.RoomListEnumerate;
   
   public class FarmPoultry extends Sprite implements Disposeable
   {
      
      private var _poultry:ActionMovie;
      
      private var _poultryName:FilterFrameText;
      
      private var _expSprite:Sprite;
      
      private var _bloodBg:Bitmap;
      
      private var _blood:Bitmap;
      
      private var _wakeFeed:WakeFeedCountDown;
      
      private var _mask:Sprite;
      
      private var _poultryArea:Sprite;
      
      private var _expText:FilterFrameText;
      
      private var _fightBossFlag:Boolean;
      
      private var _sward:MovieClip;
      
      private var _pointArray:Array = [new Point(224,441),new Point(349,533),new Point(465,261)];
      
      private var _pointId:int = 0;
      
      private var _walkTimer:Timer;
      
      private var _offPoint:Point;
      
      private var _moveSpeed:int = 5;
      
      private var _last_creat:uint;
      
      private var _chatBallView:ChatBallPlayer;
      
      public function FarmPoultry()
      {
         super();
      }
      
      public function startLoadPoultry() : void
      {
         this.loadPoultry();
      }
      
      private function initView() : void
      {
         var _loc1_:* = null;
         _loc1_ = ModuleLoader.getDefinition("game.living.Living380") as Class;
         this._poultry = new _loc1_();
         PositionUtils.setPos(this._poultry,"asset.farm.poultry.poultryPos");
         addChild(this._poultry);
         this._poultry.stop();
         this._expSprite = new Sprite();
         PositionUtils.setPos(this._expSprite,"asset.farm.poultry.expPos");
         addChild(this._expSprite);
         this._poultryName = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.name");
         this._expSprite.addChild(this._poultryName);
         this._bloodBg = ComponentFactory.Instance.creat("asset.farm.poultry.bloodBg");
         this._expSprite.addChild(this._bloodBg);
         this._blood = ComponentFactory.Instance.creat("asset.farm.poultry.blood");
         this._expSprite.addChild(this._blood);
         this._expText = ComponentFactory.Instance.creatComponentByStylename("farm.tree.treeExpTxt");
         this._expText.width = this._blood.bitmapData.width;
         PositionUtils.setPos(this._expText,"asset.farm.poultry.expTextPos");
         this._expSprite.addChild(this._expText);
         this._expSprite.visible = false;
         this._wakeFeed = new WakeFeedCountDown();
         this._wakeFeed.visible = false;
         this._sward = ComponentFactory.Instance.creat("asset.farm.overEnemySword");
         addChild(this._sward);
         this._sward.visible = false;
         this.creatMask();
         this.creatTimer();
      }
      
      private function creatChatBall() : void
      {
         this.deleteChatBallView();
         this._chatBallView = new ChatBallPlayer();
         PositionUtils.setPos(this._chatBallView,"asset.farm.poultry.chatBallPos");
         addChild(this._chatBallView);
         this._chatBallView.setText(LanguageMgr.GetTranslation("farm.farmPoultry.chatBallText"));
      }
      
      private function creatTimer() : void
      {
         this._walkTimer = new Timer(2000,1);
         this._walkTimer.addEventListener("timer",this.__onPoultryWalk);
      }
      
      private function creatMask() : void
      {
         this._mask = new Sprite();
         this._mask.graphics.beginFill(0,0);
         this._mask.graphics.drawRect(0,0,this._blood.bitmapData.width,this._blood.bitmapData.height);
         this._mask.graphics.endFill();
         PositionUtils.setPos(this._mask,this._blood);
         this._blood.mask = this._mask;
         this._expSprite.addChild(this._mask);
      }
      
      private function initEvent() : void
      {
         RoomManager.Instance.addEventListener("gameRoomCreate",this.__gameStart);
      }
      
      public function setInfo(param1:int, param2:int, param3:int, param4:Date) : void
      {
         var _loc5_:* = null;
         FarmModelController.instance.model.PoultryState = param3;
         this.initPoultryInfo();
         if(param3 == 0)
         {
            this.visible = false;
            PositionUtils.setPos(this,"asset.farm.poultryPos");
         }
         else if(param3 == 1)
         {
            this.visible = true;
            PositionUtils.setPos(this,"asset.farm.poultryPos");
            FarmModelController.instance.dispatchEvent(new FarmEvent("farmPoultry_setCallBtn"));
            this._bloodBg.visible = this._blood.visible = this._expText.visible = this._poultryName.visible = false;
            this._poultry.gotoAndStop("standB");
            this._poultry.scaleX = this._poultry.scaleY = 1;
            if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId || PlayerManager.Instance.Self.SpouseID == FarmModelController.instance.model.currentFarmerId)
            {
               this.setWakeFeedBtnState(1);
               this.creatPoultryArea(1,90,150);
               if(PlayerManager.Instance.Self.SpouseID == FarmModelController.instance.model.currentFarmerId)
               {
                  this._wakeFeed.tipData = LanguageMgr.GetTranslation("farm.poultry.wakefeedTipTxt3");
               }
            }
         }
         else
         {
            this.visible = true;
            FarmModelController.instance.dispatchEvent(new FarmEvent("farmPoultry_setCallBtn"));
            _loc5_ = FarmModelController.instance.model.farmPoultryInfo[param2];
            this._bloodBg.visible = this._blood.visible = this._expText.visible = this._poultryName.visible = true;
            this._walkTimer.start();
            this._poultry.gotoAndPlay("walkA");
            this._poultry.scaleX = this.x < this._pointArray[this._pointId].x ? -0.7 : 0.7;
            this._poultry.scaleY = 0.7;
            this._expText.text = param1 + "/" + _loc5_.MonsterExp;
            this._poultryName.text = _loc5_.MonsterName;
            this.setExp(param1,_loc5_.MonsterExp);
            this.setWakeFeedBtnState(2);
            if(param1 >= _loc5_.MonsterExp)
            {
               this._fightBossFlag = true;
               this._wakeFeed.visible = false;
            }
            else
            {
               this._wakeFeed.setCountDownTime(param4);
            }
            this.creatPoultryArea(2,150,172);
         }
      }
      
      private function initPoultryInfo() : void
      {
         this._fightBossFlag = false;
         this._walkTimer.stop();
         this._walkTimer.reset();
         this.deletePoultryArea();
         removeEventListener("enterFrame",this.__onEnterFrame);
      }
      
      private function setExp(param1:int, param2:int) : void
      {
         this._expText.text = param1 + "/" + param2;
         var _loc3_:int = this._mask.width - (param2 != 0 ? param1 * this._mask.width / param2 : 0);
         this._mask.x = this._blood.x - _loc3_;
      }
      
      private function setWakeFeedBtnState(param1:int) : void
      {
         this._wakeFeed.setFrame(param1);
         PositionUtils.setPos(this._wakeFeed,"farm.poultry.wakefeedBtnPos" + param1);
         this._wakeFeed.tipData = LanguageMgr.GetTranslation("farm.poultry.wakefeedTipTxt" + param1);
      }
      
      protected function __onPoultryWalk(param1:TimerEvent) : void
      {
         this._poultry.scaleX = this.x < this._pointArray[this._pointId].x ? -0.7 : 0.7;
         this._poultry.scaleY = 0.7;
         this._offPoint = new Point(this._pointArray[this._pointId].x - this.x,this._pointArray[this._pointId].y - this.y);
         this._offPoint.normalize(this._moveSpeed);
         addEventListener("enterFrame",this.__onEnterFrame);
         if(this._pointId == 0)
         {
            this.creatChatBall();
         }
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = Point.distance(new Point(this.x,this.y),this._pointArray[this._pointId]);
         if(_loc2_ <= this._moveSpeed)
         {
            removeEventListener("enterFrame",this.__onEnterFrame);
            this._walkTimer.start();
            ++this._pointId;
            if(this._pointId >= this._pointArray.length)
            {
               this._pointId = 0;
            }
            this._offPoint = null;
         }
         else
         {
            this.x += this._offPoint.x;
            this.y += this._offPoint.y;
         }
      }
      
      private function loadPoultry() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solvePath("image/game/living/living380.swf"),4);
         _loc1_.addEventListener("complete",this.__onLoadComplete);
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
      
      protected function __onLoadComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.loader;
         _loc2_.removeEventListener("complete",this.__onLoadComplete);
         this.initView();
         this.initEvent();
         this.dispatchEvent(new Event("complete"));
      }
      
      private function creatPoultryArea(param1:int, param2:int, param3:int) : void
      {
         if(!this._poultryArea)
         {
            this._poultryArea = new Sprite();
         }
         this._poultryArea.graphics.beginFill(0,0);
         this._poultryArea.graphics.drawRect(0,0,param2,param3);
         this._poultryArea.graphics.endFill();
         PositionUtils.setPos(this._poultryArea,"asset.farm.poultryAreaPos" + param1);
         this._poultryArea.addEventListener("mouseOver",this.__onAreaOver);
         this._poultryArea.addEventListener("mouseOut",this.__onAreaOut);
         this._poultryArea.addEventListener("click",this.__onAreaClick);
         this._poultryArea.buttonMode = true;
         this._poultryArea.addChild(this._wakeFeed);
         addChild(this._poultryArea);
      }
      
      protected function __onAreaClick(param1:MouseEvent) : void
      {
         if(this._fightBossFlag)
         {
            if(getTimer() - this._last_creat >= 2000)
            {
               this._last_creat = getTimer();
               if(FarmModelController.instance.model.PoultryState == 3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.farmPoultry.fightTipsTxt"));
               }
               else if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
               {
                  FarmModelController.instance.FightPoultryFlag = true;
                  GameInSocketOut.sendCreateRoom(RoomListEnumerate.PREWORD[1],28,3,"");
               }
            }
         }
      }
      
      protected function __gameStart(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.out.enterUserGuide(70002,28);
      }
      
      protected function __onAreaMove(param1:MouseEvent) : void
      {
         this._sward.x = mouseX;
         this._sward.y = mouseY;
      }
      
      protected function __onAreaOut(param1:MouseEvent) : void
      {
         if(FarmModelController.instance.model.PoultryState == 1)
         {
            this._poultry.gotoAndPlay("standB");
         }
         else
         {
            if(Boolean(this._offPoint))
            {
               addEventListener("enterFrame",this.__onEnterFrame);
            }
            else
            {
               this._walkTimer.start();
            }
            this._poultry.gotoAndStop("walkA");
         }
         this._expSprite.visible = false;
         if(this._fightBossFlag)
         {
            if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
            {
               Mouse.show();
               this._poultryArea.removeEventListener("mouseMove",this.__onAreaMove);
               this._sward.visible = false;
            }
         }
         else
         {
            this._wakeFeed.visible = false;
         }
      }
      
      protected function __onAreaOver(param1:MouseEvent) : void
      {
         if(FarmModelController.instance.model.PoultryState == 1)
         {
            this._poultry.gotoAndPlay("standB");
         }
         else
         {
            if(this._walkTimer.running)
            {
               this._walkTimer.stop();
               this._walkTimer.reset();
            }
            removeEventListener("enterFrame",this.__onEnterFrame);
            this._poultry.gotoAndPlay("walkA");
         }
         this._expSprite.visible = true;
         if(this._fightBossFlag)
         {
            if(PlayerManager.Instance.Self.ID == FarmModelController.instance.model.currentFarmerId)
            {
               this._poultryArea.addEventListener("mouseMove",this.__onAreaMove);
               this._sward.visible = true;
               Mouse.hide();
            }
         }
         else
         {
            this._wakeFeed.visible = true;
         }
      }
      
      private function deletePoultryArea() : void
      {
         if(Boolean(this._poultryArea))
         {
            this._poultryArea.removeEventListener("mouseOver",this.__onAreaOver);
            this._poultryArea.removeEventListener("mouseOut",this.__onAreaOut);
            this._poultryArea.removeEventListener("click",this.__onAreaClick);
            ObjectUtils.removeChildAllChildren(this._poultryArea);
            this._poultryArea.graphics.clear();
            this._poultryArea = null;
         }
      }
      
      private function deleteChatBallView() : void
      {
         if(Boolean(this._chatBallView))
         {
            this._chatBallView.clear();
            if(Boolean(this._chatBallView.parent))
            {
               this._chatBallView.parent.removeChild(this._chatBallView);
            }
            this._chatBallView.dispose();
         }
         this._chatBallView = null;
      }
      
      private function removeEvent() : void
      {
         removeEventListener("enterFrame",this.__onEnterFrame);
         RoomManager.Instance.removeEventListener("gameRoomCreate",this.__gameStart);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._walkTimer))
         {
            this._walkTimer.removeEventListener("timer",this.__onPoultryWalk);
            this._walkTimer.stop();
            this._walkTimer.reset();
            this._walkTimer = null;
         }
         if(Boolean(this._poultry))
         {
            this._poultry.dispose();
            this._poultry = null;
         }
         if(Boolean(this._bloodBg))
         {
            this._bloodBg.bitmapData.dispose();
            this._bloodBg = null;
         }
         if(Boolean(this._blood))
         {
            this._blood.bitmapData.dispose();
            this._blood = null;
         }
         if(Boolean(this._wakeFeed))
         {
            this._wakeFeed.dispose();
            this._wakeFeed = null;
         }
         if(Boolean(this._poultryName))
         {
            this._poultryName.dispose();
            this._poultryName = null;
         }
         if(Boolean(this._expText))
         {
            this._expText.dispose();
            this._expText = null;
         }
         if(Boolean(this._sward))
         {
            ObjectUtils.removeChildAllChildren(this._sward);
            this._sward = null;
         }
         if(Boolean(this._expSprite))
         {
            ObjectUtils.removeChildAllChildren(this._expSprite);
            this._expSprite = null;
         }
         this.deletePoultryArea();
         this.deleteChatBallView();
         if(Boolean(this.parent))
         {
            ObjectUtils.removeChildAllChildren(this);
            this.parent.removeChild(this);
         }
      }
   }
}

