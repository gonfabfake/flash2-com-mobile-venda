package anotherDimension.view
{
   import anotherDimension.model.AnotherDimensionResourceInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class AnotherDimensionOtherItemView extends Sprite implements Disposeable
   {
      
      private static var HeadWidth:int = 120;
      
      private static var HeadHeight:int = 103;
      
      private var _isBossResource:Boolean;
      
      private var _resourceLevel:int = 0;
      
      private var _resourcePlayerInfo:PlayerInfo;
      
      private var _resourceLevelBg:MovieClip;
      
      private var _zhanlingBnt:BaseButton;
      
      private var _lueduoBnt:BaseButton;
      
      private var _zhanlingOverBg:Bitmap;
      
      private var _lueduoOverBg:Bitmap;
      
      private var _anotherDimensionInfo:AnotherDimensionResourceInfo;
      
      private var _anotherDimensionOthertip:AnotherDimensionOtherTip;
      
      private var _tipSprite:Sprite;
      
      private var _timer:Timer;
      
      private var _headLoader:SceneCharacterLoaderHead;
      
      private var _headBitmap:Bitmap;
      
      public function AnotherDimensionOtherItemView(param1:AnotherDimensionResourceInfo)
      {
         super();
         this._anotherDimensionInfo = param1;
         this.initView();
         this.initEvent();
      }
      
      public function get isBossResource() : Boolean
      {
         return this._isBossResource;
      }
      
      public function set isBossResource(param1:Boolean) : void
      {
         this._isBossResource = param1;
         if(this._isBossResource)
         {
            this._zhanlingBnt.visible = true;
            this._lueduoBnt.visible = false;
         }
         else
         {
            this._zhanlingBnt.visible = false;
            this._lueduoBnt.visible = true;
         }
      }
      
      public function get resourceLevel() : int
      {
         return this._resourceLevel;
      }
      
      public function set resourceLevel(param1:int) : void
      {
         this._resourceLevel = param1;
         this._resourceLevelBg.gotoAndStop(this._resourceLevel);
      }
      
      private function initView() : void
      {
         this._resourceLevelBg = ComponentFactory.Instance.creat("anotherDimension.resourceBg");
         this._resourceLevelBg.gotoAndStop(this._anotherDimensionInfo.resourceLevel);
         this._zhanlingBnt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemView.zhanlingBnt");
         this._lueduoBnt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.anotherDimensionOtherItemView.lueduoBnt");
         this._zhanlingBnt.addEventListener("click",this.__clickZhanling);
         this._lueduoBnt.addEventListener("click",this.__clickZhanling);
         this._zhanlingOverBg = ComponentFactory.Instance.creat("anotherDimension.fightOverzhanling");
         this._lueduoOverBg = ComponentFactory.Instance.creat("anotherDimension.fightOver");
         if(this._anotherDimensionInfo.monsterId > 0)
         {
            this.isBossResource = true;
         }
         else
         {
            this.isBossResource = false;
         }
         if(this._anotherDimensionInfo.resourceState == 1 && (Boolean(this._anotherDimensionInfo.resourcePlayerInfo) && Boolean(this._anotherDimensionInfo.resourcePlayerInfo.ID == PlayerManager.Instance.Self.ID)))
         {
            this._zhanlingOverBg.visible = true;
            this._lueduoOverBg.visible = false;
            this._zhanlingBnt.visible = false;
            this._lueduoBnt.visible = false;
         }
         else if(this._anotherDimensionInfo.resourceState == 3 && (Boolean(this._anotherDimensionInfo.resourcePlayerInfo) && Boolean(this._anotherDimensionInfo.resourcePlayerInfo.ID == PlayerManager.Instance.Self.ID)))
         {
            this._zhanlingOverBg.visible = true;
            this._lueduoOverBg.visible = false;
            this._zhanlingBnt.visible = false;
            this._lueduoBnt.visible = false;
         }
         else if(this._anotherDimensionInfo.resourceState == 2)
         {
            this._zhanlingOverBg.visible = false;
            this._lueduoOverBg.visible = true;
            this._zhanlingBnt.visible = false;
            this._lueduoBnt.visible = false;
         }
         else
         {
            this._zhanlingOverBg.visible = false;
            this._lueduoOverBg.visible = false;
            if(this._anotherDimensionInfo.monsterId > 0)
            {
               this.isBossResource = true;
            }
            else
            {
               this.isBossResource = false;
            }
         }
         if(this._anotherDimensionInfo.monsterId > 0)
         {
            addChild(this._resourceLevelBg);
            if(this._anotherDimensionInfo.monsterId == 80001 || this._anotherDimensionInfo.monsterId == 80006 || this._anotherDimensionInfo.monsterId == 80011)
            {
               this._headBitmap = ComponentFactory.Instance.creat("anotherDimension.bossIcon1");
            }
            else if(this._anotherDimensionInfo.monsterId == 80002 || this._anotherDimensionInfo.monsterId == 80007 || this._anotherDimensionInfo.monsterId == 80012)
            {
               this._headBitmap = ComponentFactory.Instance.creat("anotherDimension.bossIcon2");
            }
            else if(this._anotherDimensionInfo.monsterId == 80003 || this._anotherDimensionInfo.monsterId == 80008 || this._anotherDimensionInfo.monsterId == 80013)
            {
               this._headBitmap = ComponentFactory.Instance.creat("anotherDimension.bossIcon3");
            }
            else if(this._anotherDimensionInfo.monsterId == 80004 || this._anotherDimensionInfo.monsterId == 80009 || this._anotherDimensionInfo.monsterId == 80014)
            {
               this._headBitmap = ComponentFactory.Instance.creat("anotherDimension.bossIcon4");
            }
            else if(this._anotherDimensionInfo.monsterId == 80005 || this._anotherDimensionInfo.monsterId == 80010 || this._anotherDimensionInfo.monsterId == 80015)
            {
               this._headBitmap = ComponentFactory.Instance.creat("anotherDimension.bossIcon5");
            }
            if(Boolean(this._headBitmap))
            {
               addChild(this._headBitmap);
            }
            addChild(this._zhanlingBnt);
            addChild(this._lueduoBnt);
            addChild(this._zhanlingOverBg);
            addChild(this._lueduoOverBg);
         }
         else
         {
            this.loadHead();
         }
         this._anotherDimensionOthertip = new AnotherDimensionOtherTip(this._anotherDimensionInfo);
         this._anotherDimensionOthertip.visible = false;
         this._anotherDimensionOthertip.refreshView(this._anotherDimensionInfo);
         PositionUtils.setPos(this._anotherDimensionOthertip,"anotherDimension.anotherDimensionOtherItemView.anotherDimensionOthertipPos");
         addChild(this._anotherDimensionOthertip);
         this._tipSprite = new Sprite();
         this._tipSprite.graphics.beginFill(16711680,0);
         this._tipSprite.graphics.drawRect(27,27,88,75);
         this._tipSprite.graphics.endFill();
         addChild(this._tipSprite);
      }
      
      private function __clickZhanling(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.clickAnotherDimenZhanling(this._anotherDimensionInfo.resourcePos);
      }
      
      public function loadHead() : void
      {
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         this._headLoader = new SceneCharacterLoaderHead(this._anotherDimensionInfo.resourcePlayerInfo);
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
            _loc3_ = new Rectangle(0,0,HeadWidth,HeadHeight);
            _loc4_ = new BitmapData(HeadWidth,HeadHeight,true,0);
            _loc4_.copyPixels(param1.getContent()[0] as BitmapData,_loc3_,new Point(0,0));
            this._headBitmap.bitmapData = _loc4_;
            param1.dispose();
            this._headBitmap.rotationY = 180;
            this._headBitmap.width = 80;
            this._headBitmap.height = 80;
            PositionUtils.setPos(this._headBitmap,"anotherDimension.anotherDimension.headBitmapPos");
            addChild(this._resourceLevelBg);
            addChild(this._headBitmap);
            addChild(this._zhanlingBnt);
            addChild(this._lueduoBnt);
            addChild(this._zhanlingOverBg);
            addChild(this._lueduoOverBg);
            addChild(this._anotherDimensionOthertip);
            addChild(this._tipSprite);
         }
      }
      
      private function initEvent() : void
      {
         this._tipSprite.addEventListener("mouseOver",this.overHandler);
         this._tipSprite.addEventListener("mouseOut",this.outHandler);
         this._timer = new Timer(60000);
         this._timer.addEventListener("timer",this._reflushTip);
         this._timer.start();
      }
      
      private function _reflushTip(param1:TimerEvent) : void
      {
         this._anotherDimensionOthertip.refreshView(this._anotherDimensionInfo);
      }
      
      private function removeEvent() : void
      {
         this._tipSprite.removeEventListener("mouseOver",this.overHandler);
         this._tipSprite.removeEventListener("mouseOut",this.outHandler);
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener("timer",this._reflushTip);
            this._timer = null;
         }
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         this._anotherDimensionOthertip.visible = true;
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         this._anotherDimensionOthertip.visible = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

