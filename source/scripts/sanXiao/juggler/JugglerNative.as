package sanXiao.juggler
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class JugglerNative
   {
      
      private static var _inited:Boolean = false;
      
      private var _movieClipBitmap:Vector.<MovieClipShape>;
      
      private var _timer:Timer;
      
      private var _duration:Number;
      
      public function JugglerNative(param1:int)
      {
         super();
         if(_inited)
         {
            throw "More than one instance of class JugglerNative is not allowed.";
         }
         _inited = true;
         this._movieClipBitmap = new Vector.<MovieClipShape>();
         this._duration = 1000 / param1;
         this._timer = new Timer(this._duration);
      }
      
      public function set duration(param1:int) : void
      {
         this._duration = 1000 / param1;
         this._timer.delay = this._duration;
         this._timer.reset();
         this._timer.start();
      }
      
      public function add(param1:MovieClipShape) : void
      {
         this._movieClipBitmap.push(param1);
      }
      
      public function remove(param1:MovieClipShape) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._movieClipBitmap.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._movieClipBitmap[_loc2_] == param1)
            {
               this._movieClipBitmap.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function removeAll() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._movieClipBitmap)
         {
            _loc1_.parent && _loc1_.parent.removeChild(_loc1_);
            _loc1_.reset();
            _loc1_.dispose();
         }
      }
      
      public function hasAdded(param1:MovieClipShape) : Boolean
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this._movieClipBitmap)
         {
            if(param1 === _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._timer))
         {
            this.stop();
         }
         if(Boolean(this._movieClipBitmap))
         {
            this._movieClipBitmap.length = 0;
            this._movieClipBitmap = null;
         }
      }
      
      public function stop() : void
      {
         this._timer.stop();
         this._timer.removeEventListener("timer",this.onTimer);
         this._timer = null;
      }
      
      public function start() : void
      {
         if(this._timer == null)
         {
            this._timer = new Timer(this._duration);
         }
         this._timer.addEventListener("timer",this.onTimer);
         this._timer.start();
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._movieClipBitmap.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc2_ < this._movieClipBitmap.length && this._movieClipBitmap[_loc2_].advance(this._duration);
            _loc2_++;
         }
      }
   }
}

