package sanXiao.juggler
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class MovieClipShape extends Shape
   {
      
      private var _pivotX:Number;
      
      private var _pivotY:Number;
      
      private var _xml:XML;
      
      private var _rectangleList:Vector.<Rectangle>;
      
      private var _bmpSheet:BitmapSheet;
      
      private var _fps:Number;
      
      private var _totalTime:Number;
      
      private var _currentTime:Number;
      
      private var _duration:Number;
      
      private var _isPlaying:Boolean;
      
      private var _currentFrame:int;
      
      private var _totalFrames:int;
      
      private var _loop:Boolean;
      
      private var _m:Matrix;
      
      public function MovieClipShape(param1:String, param2:BitmapSheet, param3:Number)
      {
         super();
         this._fps = param3;
         this._duration = 1000 / this._fps;
         this._m = new Matrix();
         this._bmpSheet = param2;
         this._rectangleList = param2.getRegionList(param1);
         this._totalTime = this._duration * this._rectangleList.length;
         this._totalFrames = this._rectangleList.length;
         this._pivotX = 0;
         this._pivotY = 0;
         this._isPlaying = false;
         this._loop = true;
         this._currentFrame = 1;
         this._currentTime = 0;
         this.draw(1);
      }
      
      public function play() : void
      {
         this._isPlaying = true;
      }
      
      public function reset() : void
      {
         this._currentFrame = 1;
         this._currentTime = 0;
         this.draw(1);
         this._isPlaying = false;
      }
      
      public function advance(param1:Number) : void
      {
         if(!this._isPlaying)
         {
            return;
         }
         this._currentTime += param1;
         if(this._currentTime < this._currentFrame * this._duration)
         {
            return;
         }
         ++this._currentFrame;
         if(this._currentFrame > this._totalFrames)
         {
            if(!this._loop)
            {
               this._isPlaying = false;
               dispatchEvent(new Event("complete"));
               return;
            }
            this._currentFrame = 1;
            this._currentTime = 0;
         }
         this.draw(this._currentFrame);
      }
      
      public function dispose() : void
      {
         this._bmpSheet = null;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         this._loop = param1;
      }
      
      private function draw(param1:int) : void
      {
         if(param1 > this._totalFrames || param1 < 1)
         {
            throw "FrameNumber" + param1 + " is out of range, total frames : " + this._totalFrames;
         }
         var _loc2_:Rectangle = this._rectangleList[param1 - 1];
         this.graphics.clear();
         this._m.a = 1;
         this._m.b = 0;
         this._m.c = 0;
         this._m.d = 1;
         this._m.tx = -_loc2_.x - this._pivotX;
         this._m.ty = -_loc2_.y - this._pivotY;
         this.graphics.beginBitmapFill(this._bmpSheet.bitmapData,this._m,false,true);
         this.graphics.drawRect(-this._pivotX,-this._pivotY,_loc2_.width,_loc2_.height);
         this.graphics.endFill();
      }
      
      public function get pivotX() : Number
      {
         return this._pivotX;
      }
      
      public function set pivotX(param1:Number) : void
      {
         this._pivotX = param1;
      }
      
      public function get pivotY() : Number
      {
         return this._pivotY;
      }
      
      public function set pivotY(param1:Number) : void
      {
         this._pivotY = param1;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
   }
}

