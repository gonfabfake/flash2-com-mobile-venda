package anotherDimension.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class AnotherDimensionProgress extends Sprite implements Disposeable
   {
      
      private var _progressMc:MovieClip;
      
      private var _loop:int;
      
      private var _nextFrameIndex:int;
      
      private var _progressTxt:FilterFrameText;
      
      public function AnotherDimensionProgress()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._progressMc = ComponentFactory.Instance.creat("anotherDimension.progress");
         addChild(this._progressMc);
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("anotherDimension.progress.progressTxt");
         this._progressTxt.text = "0/0";
         addChild(this._progressTxt);
         this._progressMc.stop();
      }
      
      public function setProgressTxt(param1:String) : void
      {
         this._progressTxt.text = param1;
      }
      
      private function initEvent() : void
      {
         addEventListener("enterFrame",this._checkFrame);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("enterFrame",this._checkFrame);
      }
      
      private function _checkFrame(param1:Event) : void
      {
         if(this._nextFrameIndex == this._progressMc.currentFrame)
         {
            if(this._loop > 0)
            {
               --this._loop;
            }
            if(this._loop == 0)
            {
               this._progressMc.stop();
               dispatchEvent(new Event("mcStop"));
               this._loop = 0;
            }
         }
      }
      
      public function setProgress(param1:int) : void
      {
         this._progressMc.gotoAndStop(param1);
      }
      
      public function playProgress(param1:int, param2:int = 0) : void
      {
         if(this._progressMc.currentFrame >= param1 && param2 == 0)
         {
            this._progressMc.stop();
            dispatchEvent(new Event("mcStop"));
            return;
         }
         this._progressMc.play();
         this._nextFrameIndex = param1;
         this._loop = param2;
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

