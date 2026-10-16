package moneyTree.view
{
   import com.greensock.TweenMax;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.MultipleLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import moneyTree.MoneyTreeManager;
   
   public class Fruit extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _tip:MultipleLineTip;
      
      protected var _title:Bitmap;
      
      protected var _normalBmp:Bitmap;
      
      protected var _grownMC:MovieClip;
      
      protected var _pickMC:MovieClip;
      
      protected var _countDown:CountDownBoard;
      
      private var _manager:MoneyTreeManager;
      
      private var _onComplete:Function;
      
      public function Fruit(param1:int)
      {
         super();
         this._index = param1;
         this.useHandCursor = true;
         this.buttonMode = true;
         var _loc2_:ComponentFactory = ComponentFactory.Instance;
         this._normalBmp = _loc2_.creatBitmap("moneyTree.fruit" + param1 + ".normal");
         addChild(this._normalBmp);
         this._grownMC = _loc2_.creat("moneyTree.fruit" + param1 + ".grown");
         this._grownMC.gotoAndStop(1);
         this._pickMC = _loc2_.creat("moneyTree.fruit" + param1 + ".pick");
         this._pickMC.gotoAndStop(1);
         this._countDown = new CountDownBoard(param1,_loc2_.creatBitmap("moneyTree.fruit" + param1 + ".title"));
         this._countDown.x = 53;
         this._countDown.y = 3;
         addChild(this._countDown);
         if(this._index == 1)
         {
            this._countDown.x = 51;
            this._countDown.y = 5;
         }
         else if(this._index == 2)
         {
            this._countDown.x = -116;
            this._countDown.y = 4;
         }
         else if(this._index == 3)
         {
            this._countDown.x = 49;
            this._countDown.y = 24;
         }
         this._tip = new MultipleLineTip();
         this._tip.tipData = LanguageMgr.GetTranslation("moneyTree.fruit.tip").toString().split("|")[param1].toString();
         PositionUtils.setPos(this._tip,"moneyTree.fruit" + param1.toString() + ".Tippos");
         this._tip.visible = false;
         this._tip.bgWidth = 115;
         addChildAt(this._tip,1);
         this.addEventListener("click",this.onClick);
         this.addEventListener("mouseOver",this.__showTip);
         this.addEventListener("mouseOut",this.__hideTip);
         this._manager = MoneyTreeManager.getInstance();
         this._manager.addEventListener("mt_update_timer",this.updateTime);
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      private function __showTip(param1:MouseEvent) : void
      {
         this._tip.visible = true;
      }
      
      private function __hideTip(param1:MouseEvent) : void
      {
         this._tip.visible = false;
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.removeEventListener("click",this.onClick);
         MoneyTreeManager.getInstance().pick(this._index);
         TweenMax.delayedCall(2,this.addListener);
      }
      
      private function addListener() : void
      {
         this.addEventListener("click",this.onClick);
      }
      
      protected function updateTime(param1:CEvent) : void
      {
         if(this._pickMC.hasEventListener("enterFrame"))
         {
            return;
         }
         this._countDown.updateTime(MoneyTreeManager.getInstance().model.getCountDownString(this._index));
      }
      
      public function showGrown() : void
      {
         if(this._pickMC.hasEventListener("enterFrame"))
         {
            this._onComplete = this.showGrown;
            return;
         }
         this._normalBmp.parent && removeChild(this._normalBmp);
         this._pickMC.parent && this._pickMC.stop();
         addChild(this._grownMC);
         this._grownMC.gotoAndPlay(1);
      }
      
      public function showNormal() : void
      {
         if(this._pickMC.hasEventListener("enterFrame"))
         {
            this._onComplete = this.showNormal;
            return;
         }
         this._grownMC.parent && this._grownMC.stop();
         this._pickMC.parent && this._pickMC.stop();
         addChild(this._normalBmp);
      }
      
      public function showPick() : void
      {
         this._pickMC.addEventListener("enterFrame",this.onPickEF);
         this._normalBmp.parent && removeChild(this._normalBmp);
         this._grownMC.parent && this._grownMC.stop();
         addChild(this._pickMC);
         this._pickMC.gotoAndPlay(1);
      }
      
      protected function onPickEF(param1:Event) : void
      {
         if(this._pickMC == null)
         {
            return;
         }
         if(this._pickMC.currentFrame == this._pickMC.totalFrames)
         {
            this._pickMC.removeEventListener("enterFrame",this.onPickEF);
            this._onComplete && this._onComplete();
            this._countDown.updateTime(MoneyTreeManager.getInstance().model.getCountDownString(this._index));
         }
      }
      
      private function showDelay(param1:Function) : void
      {
         this._onComplete = param1;
      }
      
      public function dispose() : void
      {
         TweenMax.killDelayedCallsTo(this);
         this._pickMC.removeEventListener("enterFrame",this.onPickEF);
         this.removeEventListener("click",this.onClick);
         this.removeEventListener("mouseOver",this.__showTip);
         this.removeEventListener("mouseOut",this.__hideTip);
         this._manager.removeEventListener("mt_update_timer",this.updateTime);
         this._manager = null;
         this._countDown.dispose();
         if(this._normalBmp != null)
         {
            ObjectUtils.disposeObject(this._normalBmp);
            this._normalBmp = null;
         }
         if(this._pickMC != null)
         {
            ObjectUtils.disposeObject(this._pickMC);
            this._pickMC = null;
         }
         if(this._grownMC != null)
         {
            ObjectUtils.disposeObject(this._grownMC);
            this._grownMC = null;
         }
         if(this._title != null)
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
      }
   }
}

