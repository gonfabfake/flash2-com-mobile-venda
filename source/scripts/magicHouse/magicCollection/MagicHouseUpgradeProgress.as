package magicHouse.magicCollection
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import magicHouse.MagicHouseModel;
   
   public class MagicHouseUpgradeProgress extends Component
   {
      
      private static const MAXLEVEL:int = 5;
      
      private var _background:Bitmap;
      
      protected var _graphics_thuck:Bitmap;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _star:MovieClip;
      
      private var _progressBarMask:Sprite;
      
      private var _total:int = 50;
      
      private var _scaleValue:Number;
      
      protected var _max:Number = 0;
      
      private var _exp:int;
      
      protected var _currentFrame:int;
      
      private var _taskFrames:Dictionary;
      
      private var _level:int;
      
      public function MagicHouseUpgradeProgress()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("magichouse.upgradeprogress.bg");
         addChild(this._background);
         this._graphics_thuck = ComponentFactory.Instance.creatBitmap("magichouse.upgradeprogress.progress");
         addChild(this._graphics_thuck);
         this.initMask();
         this._star = ClassUtils.CreatInstance("magichouse.upgradeprogress.light");
         this._star.y = this._progressBarMask.y + this._progressBarMask.height / 2;
         addChild(this._star);
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("magichouse.collectionItem.upgradeProgressText");
         addChild(this._progressLabel);
         this._scaleValue = this._graphics_thuck.width / this._total;
         this.resetProgress();
      }
      
      private function initMask() : void
      {
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(7,5,this._graphics_thuck.width,this._graphics_thuck.height);
         this._progressBarMask.graphics.endFill();
         this._graphics_thuck.cacheAsBitmap = true;
         this._graphics_thuck.mask = this._progressBarMask;
         addChild(this._progressBarMask);
      }
      
      private function startProgress() : void
      {
         this.addEventListener("enterFrame",this.__startFrame);
      }
      
      private function __startFrame(param1:Event) : void
      {
         ++this._currentFrame;
         this.setMask(this._currentFrame);
         var _loc2_:int = 0;
         if(this._taskFrames.hasOwnProperty(0))
         {
            _loc2_ = int(this._taskFrames[0]);
         }
         if(_loc2_ == 0 && this._taskFrames.hasOwnProperty(1))
         {
            _loc2_ = int(this._taskFrames[1]);
         }
         if(this._currentFrame >= _loc2_)
         {
            if(_loc2_ >= this._total)
            {
               this._currentFrame = 0;
               this._taskFrames[0] = 0;
            }
            else
            {
               this._taskFrames[1] = 0;
               this.removeEventListener("enterFrame",this.__startFrame);
               this.setStarVisible(false);
               param1.stopImmediatePropagation();
            }
         }
      }
      
      public function resetProgress() : void
      {
         tipData = "0/0";
         this._progressLabel.text = "0%";
         this._exp = 0;
         this._max = 0;
         this._currentFrame = 0;
         this._level = -1;
         this.setMask(0);
         this.setStarVisible(false);
         this._taskFrames = new Dictionary();
      }
      
      public function setMask(param1:Number) : void
      {
         var _loc2_:Number = param1 * this._scaleValue;
         if(isNaN(_loc2_) || _loc2_ == 0)
         {
            this._progressBarMask.width = 0;
         }
         else
         {
            if(_loc2_ >= this._graphics_thuck.width)
            {
               _loc2_ %= this._graphics_thuck.width;
            }
            this._progressBarMask.width = _loc2_;
         }
         this._star.x = this._progressBarMask.x + this._progressBarMask.width;
      }
      
      private function setStarVisible(param1:Boolean) : void
      {
         this._star.visible = param1;
      }
      
      public function getStarVisible() : Boolean
      {
         return this._star.visible;
      }
      
      public function initProgress(param1:int, param2:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         this._currentFrame = 0;
         this._exp = param2;
         this._level = param1;
         if(this._level != 5)
         {
            this._max = MagicHouseModel.instance.levelUpNumber[this._level];
         }
         else
         {
            this._max = 0;
         }
         if(this._max > 0 && this._exp < this._max)
         {
            _loc3_ = this._exp / this._max;
            _loc4_ = Math.floor(_loc3_ * this._total);
            if(_loc4_ < 1 && _loc3_ > 0)
            {
               _loc4_ = 1;
            }
            this._currentFrame = _loc4_;
         }
         this.setMask(this._currentFrame);
         this.setExpPercent();
         this._taskFrames = new Dictionary();
         if(this.hasEventListener("enterFrame"))
         {
            this.removeEventListener("enterFrame",this.__startFrame);
         }
         this.setStarVisible(false);
      }
      
      public function setProgress(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         if(this._level != param1)
         {
            this._taskFrames[0] = this._total;
            this._level = param1;
         }
         this._exp = param2;
         if(this._level != 5)
         {
            this._max = MagicHouseModel.instance.levelUpNumber[this._level];
         }
         else
         {
            this._max = 0;
         }
         var _loc3_:Number = this._exp / this._max;
         _loc4_ = Math.floor(_loc3_ * this._total);
         if(_loc4_ < 1 && _loc3_ > 0)
         {
            _loc4_ = 1;
         }
         if(this._currentFrame == _loc4_)
         {
            if(Boolean(this._taskFrames[0]) && int(this._taskFrames[0]) != 0)
            {
               this.setStarVisible(true);
               this._taskFrames[1] = _loc4_;
               this.startProgress();
            }
         }
         else
         {
            this.setStarVisible(true);
            this._taskFrames[1] = _loc4_;
            this.startProgress();
         }
         this.setExpPercent();
      }
      
      public function setExpPercent() : void
      {
         this._progressLabel.text = this._exp + "/" + this._max;
         if(this._level >= 5)
         {
            tipData = "0/0";
         }
         else
         {
            if(isNaN(this._exp))
            {
               this._exp = 0;
            }
            if(isNaN(this._max))
            {
               this._max = 0;
            }
            tipData = this._exp + "/" + this._max;
         }
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._background))
         {
            ObjectUtils.disposeObject(this._background);
         }
         this._background = null;
         if(Boolean(this._graphics_thuck))
         {
            ObjectUtils.disposeObject(this._graphics_thuck);
         }
         this._graphics_thuck = null;
         if(Boolean(this._progressLabel))
         {
            ObjectUtils.disposeObject(this._progressLabel);
         }
         this._progressLabel = null;
         if(Boolean(this._star))
         {
            ObjectUtils.disposeObject(this._star);
         }
         this._star = null;
         if(Boolean(this._progressBarMask))
         {
            ObjectUtils.disposeObject(this._progressBarMask);
         }
         this._progressBarMask = null;
         if(this.hasEventListener("enterFrame"))
         {
            this.removeEventListener("enterFrame",this.__startFrame);
         }
         super.dispose();
      }
   }
}

