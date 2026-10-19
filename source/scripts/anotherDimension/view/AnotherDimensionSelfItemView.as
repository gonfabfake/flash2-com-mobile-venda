package anotherDimension.view
{
   import anotherDimension.model.AnotherDimensionResourceInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
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
   
   public class AnotherDimensionSelfItemView extends Sprite implements Disposeable
   {
      
      private static var HeadWidth:int = 120;
      
      private static var HeadHeight:int = 103;
      
      private var _resourceLevel:int = 0;
      
      private var _resourcePlayerInfo:PlayerInfo;
      
      private var _resourceLevelBg:MovieClip;
      
      private var _headLoader:SceneCharacterLoaderHead;
      
      private var _headBitmap:Bitmap;
      
      private var _daojishiTxt:FilterFrameText;
      
      private var _daojishiBg:Bitmap;
      
      private var _anotherDimensionInfo:AnotherDimensionResourceInfo;
      
      private var _anotherDimensionOthertip:AnotherDimensionOtherTip;
      
      private var _tipSprite:Sprite;
      
      private var _timer:Timer;
      
      private var hourTime:Number = 3600000;
      
      private var minuteTime:Number = 60000;
      
      public function AnotherDimensionSelfItemView(param1:AnotherDimensionResourceInfo)
      {
         super();
         this._anotherDimensionInfo = param1;
         this.initView();
         this.loadHead();
         this.initEvent();
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
         this._resourceLevelBg.gotoAndStop(this._resourceLevel);
         this._daojishiBg = ComponentFactory.Instance.creat("anotherDimension.daojishiBg");
         this._daojishiTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.daojishiTxt");
         this._anotherDimensionOthertip = new AnotherDimensionOtherTip(this._anotherDimensionInfo);
         this._anotherDimensionOthertip.visible = false;
         this._anotherDimensionOthertip.refreshView(this._anotherDimensionInfo);
         this._anotherDimensionOthertip.setSelfTipStyle(this._anotherDimensionInfo);
         PositionUtils.setPos(this._anotherDimensionOthertip,"anotherDimension.anotherDimensionOtherItemView.anotherDimensionOthertipPos");
         addChild(this._anotherDimensionOthertip);
         this._tipSprite = new Sprite();
         this._tipSprite.graphics.beginFill(16711680,0);
         this._tipSprite.graphics.drawRect(27,27,88,75);
         this._tipSprite.graphics.endFill();
         addChild(this._tipSprite);
      }
      
      public function loadHead() : void
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
            addChild(this._daojishiBg);
            addChild(this._daojishiTxt);
            addChild(this._anotherDimensionOthertip);
            addChild(this._tipSprite);
            this.setDaojishi();
         }
      }
      
      private function setDaojishi() : void
      {
         var _loc8_:int = 0;
         var _loc1_:Date = this._anotherDimensionInfo.haveResourceTime;
         var _loc2_:int = this._anotherDimensionInfo.haveResourceLast;
         var _loc3_:Date = TimeManager.Instance.Now();
         var _loc4_:Number = _loc1_.getTime();
         var _loc5_:Number = _loc2_ * this.minuteTime;
         var _loc6_:Number = _loc3_.getTime();
         var _loc7_:Number = _loc4_ + _loc5_ - _loc6_;
         _loc8_ = Math.floor(_loc7_ / this.minuteTime);
         if(_loc8_ <= 1)
         {
            _loc8_ = 1;
         }
         var _loc9_:String = _loc8_ + "phút";
         this._daojishiTxt.text = _loc9_;
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
         this._anotherDimensionOthertip.setSelfTipStyle(this._anotherDimensionInfo);
         this.setDaojishi();
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

