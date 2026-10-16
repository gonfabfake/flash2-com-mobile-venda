package welfareCenter.callBackLotteryDraw.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextLineMetrics;
   
   public class FilterFrameTextMiddleLine extends Sprite implements Disposeable
   {
      
      private var _filterFrameText:FilterFrameText;
      
      private var _lineShape:Shape;
      
      public function FilterFrameTextMiddleLine(param1:FilterFrameText)
      {
         super();
         this._filterFrameText = param1;
         addChild(this._filterFrameText);
         this._lineShape = new Shape();
         addChild(this._lineShape);
      }
      
      public function get filterFrameText() : FilterFrameText
      {
         return this._filterFrameText;
      }
      
      public function drawMiddleLines(param1:Number, param2:uint, param3:Number) : void
      {
         var _loc12_:Graphics = null;
         var _loc13_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc12_ = this._lineShape.graphics;
         _loc12_.clear();
         _loc13_ = this._filterFrameText.numLines;
         if(_loc13_ > 0)
         {
            _loc12_.lineStyle(param1,param2,param3);
            _loc4_ = int(this._filterFrameText.defaultTextFormat.leading);
            _loc5_ = 2;
            _loc6_ = 0;
            while(_loc6_ < _loc13_)
            {
               _loc7_ = this._filterFrameText.getLineMetrics(_loc6_);
               _loc8_ = int(_loc7_.x);
               _loc9_ = int(_loc7_.width);
               _loc10_ = int(_loc7_.height);
               _loc11_ = _loc5_ + (_loc10_ - _loc4_) * 0.5;
               _loc12_.moveTo(_loc8_,_loc11_);
               _loc12_.lineTo(_loc8_ + _loc9_,_loc11_);
               _loc5_ += _loc10_;
               _loc6_++;
            }
         }
      }
      
      public function drawMiddleLine(param1:Number, param2:uint, param3:Number, param4:int, param5:int) : void
      {
         var _loc6_:Graphics = null;
         var _loc11_:TextLineMetrics = null;
         _loc6_ = this._lineShape.graphics;
         _loc6_.clear();
         _loc6_.lineStyle(param1,param2,param3);
         var _loc7_:Rectangle = this._filterFrameText.getCharBoundaries(param4);
         var _loc8_:Rectangle = this._filterFrameText.getCharBoundaries(param5);
         var _loc9_:int = int(this._filterFrameText.defaultTextFormat.leading);
         var _loc10_:int = 2;
         _loc11_ = this._filterFrameText.getLineMetrics(0);
         var _loc12_:int = _loc11_.x;
         var _loc13_:int = _loc11_.width;
         var _loc14_:int = _loc11_.height;
         var _loc15_:int = _loc10_ + (_loc14_ - _loc9_) * 0.5;
         _loc6_.moveTo(_loc7_.x,_loc15_);
         _loc6_.lineTo(_loc8_.right,_loc15_);
      }
      
      public function dispose() : void
      {
         this._filterFrameText.dispose();
         this._filterFrameText = null;
         this._lineShape.graphics.clear();
         this._lineShape = null;
      }
   }
}

