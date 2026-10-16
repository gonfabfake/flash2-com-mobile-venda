package homeTemple.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import homeTemple.HomeTempleController;
   import homeTemple.data.HomeTempleData;
   import homeTemple.event.HomeTempleEvent;
   
   public class HomeImmolationProgressBar extends Component
   {
      
      protected var _thuck:Bitmap;
      
      protected var _progressLabel:FilterFrameText;
      
      protected var _currentFrame:int;
      
      private var _strengthenLevel:int;
      
      private var _strengthenExp:int;
      
      private var _progressBarMask:Sprite;
      
      private var _scaleValue:Number;
      
      private var _taskFrames:Dictionary;
      
      private var _total:int = 50;
      
      private var _max:Number = 0;
      
      private var _upgradeMovie:MovieClip;
      
      public function HomeImmolationProgressBar()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._thuck = ComponentFactory.Instance.creatBitmap("asset.home.ColorStrip");
         addChild(this._thuck);
         this.initMask();
         this._progressLabel = ComponentFactory.Instance.creatComponentByStylename("home.temple.level.progressText");
         addChild(this._progressLabel);
         this._scaleValue = this._thuck.width / this._total;
         this.resetProgress();
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
               param1.stopImmediatePropagation();
            }
         }
      }
      
      private function initMask() : void
      {
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(0,0,this._thuck.width,this._thuck.height);
         this._progressBarMask.graphics.endFill();
         this._thuck.cacheAsBitmap = true;
         this._thuck.mask = this._progressBarMask;
         addChild(this._progressBarMask);
      }
      
      public function initProgress() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:HomeTempleData = HomeTempleController.Instance.currentInfo;
         this._currentFrame = 0;
         this._strengthenExp = _loc3_.CurrentExp;
         this._strengthenLevel = _loc3_.CurrentLevel;
         this._max = HomeTempleController.Instance.getPracticeByLevel(this._strengthenLevel + 1).Exp - HomeTempleController.Instance.getPracticeByLevel(this._strengthenLevel).Exp;
         if(this._max > 0 && this._strengthenExp < this._max)
         {
            _loc1_ = this._strengthenExp / this._max;
            _loc2_ = Math.floor(_loc1_ * this._total);
            if(_loc2_ < 1 && _loc1_ > 0)
            {
               _loc2_ = 1;
            }
            this._currentFrame = _loc2_;
         }
         this.setMask(this._currentFrame);
         this.setExpPercent();
         this._taskFrames = new Dictionary();
         if(this.hasEventListener("enterFrame"))
         {
            this.removeEventListener("enterFrame",this.__startFrame);
         }
      }
      
      public function setProgress() : void
      {
         var _loc1_:HomeTempleData = HomeTempleController.Instance.currentInfo;
         if(this._strengthenLevel != _loc1_.CurrentLevel)
         {
            this._taskFrames[0] = this._total;
            this._strengthenLevel = _loc1_.CurrentLevel;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("home.temple.upgradeText",HomeTempleController.Instance.getStarNum(),HomeTempleController.Instance.getStarLevelNum()));
            if(this._strengthenLevel % 10 == 1)
            {
               HomeTempleController.Instance.dispatchEvent(new HomeTempleEvent("homeTempleUpdateBlessingState"));
            }
            this.playerUpgradeAnimation();
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("home.temple.upgradeExpNumberText",_loc1_.CurrentExp - this._strengthenExp),0,true);
         }
         this._strengthenExp = _loc1_.CurrentExp;
         this._max = HomeTempleController.Instance.getPracticeByLevel(this._strengthenLevel + 1).Exp - HomeTempleController.Instance.getPracticeByLevel(this._strengthenLevel).Exp;
         var _loc2_:Number = this._strengthenExp / this._max;
         var _loc3_:int = Math.floor(_loc2_ * this._total);
         if(_loc3_ < 1 && _loc2_ > 0)
         {
            _loc3_ = 1;
         }
         if(this._currentFrame == _loc3_)
         {
            if(Boolean(this._taskFrames[0]) && int(this._taskFrames[0]) != 0)
            {
               this._taskFrames[1] = _loc3_;
               this.startProgress();
            }
         }
         else
         {
            this._taskFrames[1] = _loc3_;
            this.startProgress();
         }
         this.setExpPercent();
      }
      
      private function playerUpgradeAnimation() : void
      {
         if(!this._upgradeMovie)
         {
            this._upgradeMovie = ComponentFactory.Instance.creat("home.temple.upgrade.animation");
            PositionUtils.setPos(this._upgradeMovie,"home.temple.upgradeAnimationPos");
            addChild(this._upgradeMovie);
         }
         this._upgradeMovie.gotoAndPlay(1);
      }
      
      private function setMask(param1:Number) : void
      {
         var _loc2_:Number = param1 * this._scaleValue;
         if(isNaN(_loc2_) || _loc2_ == 0)
         {
            this._progressBarMask.width = 0;
         }
         else
         {
            if(_loc2_ >= this._thuck.width)
            {
               _loc2_ %= this._thuck.width;
            }
            this._progressBarMask.width = _loc2_;
         }
      }
      
      private function setExpPercent() : void
      {
         var _loc1_:String = HomeTempleController.Instance.getExpPercent();
         if(_loc1_ == "")
         {
            _loc1_ = "0";
         }
         this._progressLabel.text = _loc1_ + "%";
         if(this._strengthenLevel >= HomeTempleController.MAXLEVEL)
         {
            this._progressLabel.text = "0%";
            tipData = "0/0";
         }
         else
         {
            if(isNaN(this._strengthenExp))
            {
               this._strengthenExp = 0;
            }
            if(isNaN(this._max))
            {
               this._max = 0;
            }
            tipData = this._strengthenExp + "/" + this._max;
         }
      }
      
      public function resetProgress() : void
      {
         tipData = "0/0";
         this._progressLabel.text = "0%";
         this._strengthenExp = 0;
         this._currentFrame = 0;
         this._strengthenLevel = -1;
         this.setMask(0);
         this._taskFrames = new Dictionary();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._thuck);
         this._thuck = null;
         ObjectUtils.disposeObject(this._progressLabel);
         this._progressLabel = null;
         ObjectUtils.disposeObject(this._progressBarMask);
         this._progressBarMask = null;
         if(this.hasEventListener("enterFrame"))
         {
            this.removeEventListener("enterFrame",this.__startFrame);
         }
         super.dispose();
      }
   }
}

