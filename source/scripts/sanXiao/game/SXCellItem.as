package sanXiao.game
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import sanXiao.model.Pos;
   
   public class SXCellItem extends Sprite implements Disposeable
   {
      
      public static const IMMEDIATELY:String = "immediately";
      
      public static const TWEEN:String = "tween";
      
      public static const BACK:String = "back";
      
      public static var cellWidth:Number = 50;
      
      public static var cellHeight:Number = 49;
      
      public static var stepDistance:Number = 3;
      
      private var _curPos:Pos;
      
      protected var _tagPos:Pos;
      
      private var _tagY:Number = 0;
      
      private var _tagX:Number = 0;
      
      private var _icon:ScaleFrameImage;
      
      private var _boomEffect:MovieClip;
      
      private var _testText:FilterFrameText;
      
      private var _lightBorder:Bitmap;
      
      private var _columnDirection:Boolean;
      
      private var _rowDrection:Boolean;
      
      private var _step:Number = 17;
      
      private var _callBack:Function;
      
      public function SXCellItem()
      {
         super();
         this._tagPos = new Pos();
         this._curPos = new Pos();
         this._icon = ComponentFactory.Instance.creat("sanxiao.cell.icons");
         addChild(this._icon);
         this._boomEffect = ComponentFactory.Instance.creat("ast.sanxiao.effects.boom");
         this._boomEffect.x = cellWidth * 0.5;
         this._boomEffect.y = cellHeight * 0.5;
         this._boomEffect.gotoAndStop(this._boomEffect.totalFrames);
         this._boomEffect.mouseChildren = this._boomEffect.mouseEnabled = false;
         this.mouseChildren = false;
         this._testText = ComponentFactory.Instance.creat("sanxiao.test.Txt");
         this._testText.scaleX = 0.6;
         this._testText.scaleY = 0.6;
         addChild(this._testText);
         this._lightBorder = ComponentFactory.Instance.creatBitmap("ast.sanxiao.lightBorder");
         this._lightBorder.x = -6;
         this._lightBorder.y = -6;
      }
      
      public function get curPos() : Pos
      {
         return this._curPos;
      }
      
      public function set curPos(param1:Pos) : void
      {
         this._curPos.column = param1.column;
         this._curPos.row = param1.row;
         x = this._curPos.column * cellWidth;
         y = this._curPos.row * cellHeight;
      }
      
      public function get tagPos() : Pos
      {
         return this._tagPos;
      }
      
      public function set tagPos(param1:Pos) : void
      {
         this._tagPos.column = param1.column;
         this._tagPos.row = param1.row;
         this._tagX = this._tagPos.column * cellWidth;
         this._tagY = this._tagPos.row * cellHeight;
      }
      
      public function set type(param1:int) : void
      {
         this._icon.setFrame(param1 == 0 ? 6 : param1);
      }
      
      public function get type() : int
      {
         return this._icon.getFrame % 6;
      }
      
      public function boom() : void
      {
         addChild(this._boomEffect);
         this._boomEffect.addEventListener("effect_end",this.onEffectEnd);
         this._boomEffect.gotoAndPlay(1);
         this.type = 0;
      }
      
      public function killBoom() : void
      {
         if(this._boomEffect == null || this._boomEffect.parent == null)
         {
            return;
         }
         removeChild(this._boomEffect);
         this._boomEffect.hasEventListener("effect_end") && this._boomEffect.removeEventListener("effect_end",this.onEffectEnd);
      }
      
      protected function onEffectEnd(param1:Event) : void
      {
         this._boomEffect.removeEventListener("effect_end",this.onEffectEnd);
         this._boomEffect.parent && removeChild(this._boomEffect);
      }
      
      public function moveTo(param1:Pos, param2:String = "tween", param3:Function = null) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this._callBack = param3;
         this.selected = false;
         switch(param2)
         {
            case "tween":
               this.tagPos = param1;
               _loc5_ = Math.abs(this.tagPos.column - this.curPos.column);
               _loc6_ = Math.abs(this.tagPos.row - this.curPos.row);
               if(_loc5_ > _loc6_)
               {
                  _loc4_ = _loc5_ * 0.3;
                  this._columnDirection = this.tagPos.column < this.curPos.column;
                  SanXiaoGameMediator.getInstance().addTween(this,this.TweenX);
               }
               else
               {
                  _loc4_ = _loc6_ * 0.3;
                  this._rowDrection = this.tagPos.row < this.curPos.row;
                  SanXiaoGameMediator.getInstance().addTween(this,this.TweenY);
               }
               break;
            case "immediately":
               this.curPos.column = param1.column;
               this.curPos.row = param1.row;
               this.x = this.curPos.column * cellWidth;
               this.y = this.curPos.row * cellHeight;
               this._callBack && this._callBack();
               this._callBack = null;
         }
      }
      
      private function TweenY() : void
      {
         if(this._rowDrection)
         {
            y -= this._step;
            if(y <= this._tagY)
            {
               y = this._tagY;
               SanXiaoGameMediator.getInstance().removeTween(this);
               this.onTweenComplete();
            }
         }
         else
         {
            y += this._step;
            if(y >= this._tagY)
            {
               y = this._tagY;
               SanXiaoGameMediator.getInstance().removeTween(this);
               this.onTweenComplete();
            }
         }
      }
      
      private function TweenX() : void
      {
         if(this._columnDirection)
         {
            x -= this._step;
            if(x <= this._tagX)
            {
               x = this._tagX;
               SanXiaoGameMediator.getInstance().removeTween(this);
               this.onTweenComplete();
            }
         }
         else
         {
            x += this._step;
            if(x >= this._tagX)
            {
               x = this._tagX;
               SanXiaoGameMediator.getInstance().removeTween(this);
               this.onTweenComplete();
            }
         }
      }
      
      private function onTweenComplete() : void
      {
         this.curPos.row = this.tagPos.row;
         this.curPos.column = this.tagPos.column;
         this._callBack && this._callBack();
         this._callBack = null;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1)
         {
            addChild(this._lightBorder);
         }
         else
         {
            this._lightBorder.parent && removeChild(this._lightBorder);
         }
      }
      
      public function dispose() : void
      {
         if(this._boomEffect != null)
         {
            this._boomEffect.removeEventListener("effect_end",this.onEffectEnd);
            ObjectUtils.disposeObject(this._boomEffect);
            this._boomEffect = null;
         }
         if(this._icon != null)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(this._lightBorder != null)
         {
            ObjectUtils.disposeObject(this._lightBorder);
            this._lightBorder = null;
         }
      }
   }
}

