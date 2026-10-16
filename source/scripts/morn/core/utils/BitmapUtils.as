package morn.core.utils
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapUtils
   {
      
      private static var m:Matrix = new Matrix();
      
      private static var newRect:Rectangle = new Rectangle();
      
      private static var clipRect:Rectangle = new Rectangle();
      
      private static var grid:Rectangle = new Rectangle();
      
      private static var destPoint:Point = new Point();
      
      public function BitmapUtils()
      {
         super();
      }
      
      public static function scale9Bmd(param1:BitmapData, param2:Array, param3:int, param4:int) : BitmapData
      {
         var _loc16_:Shape = null;
         var _loc5_:Boolean = false;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = null;
         if(param1.width == param3 && param1.height == param4)
         {
            return param1;
         }
         param3 = param3 > 1 ? param3 : 1;
         param4 = param4 > 1 ? param4 : 1;
         var _loc13_:int = int(param2[0]) + int(param2[2]);
         var _loc14_:int = int(param2[1]) + int(param2[3]);
         var _loc15_:BitmapData = new BitmapData(param3,param4,param1.transparent,0);
         _loc16_ = new Shape();
         var _loc17_:Graphics = _loc16_.graphics;
         if(param3 > _loc13_ && param4 > _loc14_)
         {
            _loc5_ = param2.length > 4 && param2[4] == 1;
            setRect(grid,param2[0],param2[1],param1.width - param2[0] - param2[2],param1.height - param2[1] - param2[3]);
            _loc6_ = [0,grid.top,grid.bottom,param1.height];
            _loc7_ = [0,grid.left,grid.right,param1.width];
            _loc8_ = [0,grid.top,param4 - (param1.height - grid.bottom),param4];
            _loc9_ = [0,grid.left,param3 - (param1.width - grid.right),param3];
            _loc10_ = 0;
            while(_loc10_ < 3)
            {
               _loc11_ = 0;
               while(_loc11_ < 3)
               {
                  setRect(newRect,_loc7_[_loc10_],_loc6_[_loc11_],_loc7_[_loc10_ + 1] - _loc7_[_loc10_],_loc6_[_loc11_ + 1] - _loc6_[_loc11_]);
                  setRect(clipRect,_loc9_[_loc10_],_loc8_[_loc11_],_loc9_[_loc10_ + 1] - _loc9_[_loc10_],_loc8_[_loc11_ + 1] - _loc8_[_loc11_]);
                  m.identity();
                  m.a = clipRect.width / newRect.width;
                  m.d = clipRect.height / newRect.height;
                  m.tx = clipRect.x - newRect.x * m.a;
                  m.ty = clipRect.y - newRect.y * m.d;
                  if(!_loc5_ || _loc10_ != 1 && _loc11_ != 1)
                  {
                     _loc15_.draw(param1,m,null,null,clipRect,true);
                  }
                  else if(newRect.width != 0 && newRect.height != 0)
                  {
                     _loc12_ = new BitmapData(newRect.width,newRect.height,param1.transparent,0);
                     _loc12_.copyPixels(param1,newRect,destPoint);
                     _loc17_.clear();
                     _loc17_.beginBitmapFill(_loc12_);
                     _loc17_.drawRect(0,0,clipRect.width,clipRect.height);
                     _loc17_.endFill();
                     m.identity();
                     m.tx = clipRect.x;
                     m.ty = clipRect.y;
                     _loc15_.draw(_loc16_,m,null,null,clipRect,true);
                     _loc17_.clear();
                     _loc12_.dispose();
                  }
                  _loc11_++;
               }
               _loc10_++;
            }
         }
         else
         {
            m.identity();
            m.scale(param3 / param1.width,param4 / param1.height);
            setRect(grid,0,0,param3,param4);
            _loc15_.draw(param1,m,null,null,grid,true);
         }
         return _loc15_;
      }
      
      public static function setRect(param1:Rectangle, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : Rectangle
      {
         param1.x = param2;
         param1.y = param3;
         param1.width = param4;
         param1.height = param5;
         return param1;
      }
      
      public static function createClips(param1:BitmapData, param2:int, param3:int) : Vector.<BitmapData>
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc7_:Vector.<BitmapData> = new Vector.<BitmapData>();
         var _loc8_:int = Math.max(param1.width / param2,1);
         var _loc9_:int = Math.max(param1.height / param3,1);
         var _loc10_:Point = new Point();
         _loc4_ = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = 0;
            while(_loc5_ < param2)
            {
               _loc6_ = new BitmapData(_loc8_,_loc9_);
               _loc6_.copyPixels(param1,new Rectangle(_loc5_ * _loc8_,_loc4_ * _loc9_,_loc8_,_loc9_),_loc10_);
               _loc7_.push(_loc6_);
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc7_;
      }
   }
}

