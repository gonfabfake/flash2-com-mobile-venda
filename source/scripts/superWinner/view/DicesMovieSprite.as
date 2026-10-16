package superWinner.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class DicesMovieSprite extends Sprite implements Disposeable
   {
      
      private const DICE_STYLE:Array = [1,0];
      
      private var _dices:MovieClip;
      
      private var _finalDices:MovieClip;
      
      private var _movieDices:MovieClip;
      
      private var _currentDices:Vector.<int>;
      
      public function DicesMovieSprite()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._dices = ComponentFactory.Instance.creat("asset.superWinner.DicesMovie");
         this._finalDices = this._dices["finalDices"];
         this._movieDices = this._dices["movieDices"];
         this.resetDice();
         addChild(this._dices);
      }
      
      public function resetDice() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc1_:MovieClip = null;
         _loc2_ = null;
         _loc3_ = null;
         this.stopMovieDices();
         this._finalDices.visible = false;
         var _loc4_:uint = 1;
         while(_loc4_ <= 6)
         {
            _loc1_ = this._finalDices["dice" + _loc4_];
            _loc2_ = _loc1_["dice0"] as MovieClip;
            _loc3_ = _loc1_["dice1"] as MovieClip;
            _loc2_.visible = true;
            _loc3_.visible = true;
            _loc2_.gotoAndStop(1);
            _loc3_.gotoAndStop(1);
            _loc4_++;
         }
      }
      
      public function playMovie(param1:Vector.<int>) : void
      {
         this.resetDice();
         this._currentDices = param1;
         this._movieDices.addEventListener(Event.ENTER_FRAME,this.onFrame);
         this._movieDices.visible = true;
         this._movieDices.gotoAndPlay(1);
      }
      
      private function onFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame >= 10)
         {
            this.stopMovieDices();
            this.showDices();
         }
      }
      
      private function stopMovieDices() : void
      {
         this._movieDices.gotoAndStop(1);
         this._movieDices.visible = false;
      }
      
      private function showDices() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         this._finalDices.visible = true;
         var _loc4_:uint = 0;
         while(_loc4_ < this._currentDices.length)
         {
            _loc1_ = Math.round(Math.random());
            _loc2_ = this._finalDices["dice" + (_loc4_ + 1)];
            _loc2_["dice" + this.DICE_STYLE[_loc1_]].visible = false;
            _loc3_ = _loc2_["dice" + _loc1_] as MovieClip;
            _loc3_.gotoAndStop(this._currentDices[_loc4_]);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         this._dices.removeEventListener(Event.ENTER_FRAME,this.onFrame);
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

