package com.demonsters.debugger
{
   import flash.events.TimerEvent;
   import flash.sampler.DeleteObjectSample;
   import flash.sampler.Sample;
   import flash.sampler.StackFrame;
   import flash.sampler.clearSamples;
   import flash.sampler.getSampleCount;
   import flash.sampler.getSamples;
   import flash.sampler.pauseSampling;
   import flash.sampler.startSampling;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   internal class MonsterDebuggerSampler
   {
      
      private static var timer:Timer;
      
      private static var time:Number;
      
      private static var methods:Dictionary;
      
      private static var stacks:Dictionary;
      
      public function MonsterDebuggerSampler()
      {
         super();
      }
      
      internal static function initialize() : void
      {
      }
      
      private static function analyseSamples(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Sample = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         pauseSampling();
         if(MonsterDebugger.enabled && MonsterDebuggerConnection.connected)
         {
            _loc2_ = 0;
            if(getSampleCount() < 5000)
            {
               while(_loc2_ < getSampleCount())
               {
                  _loc3_ = 0;
                  for each(_loc4_ in getSamples())
                  {
                     _loc5_ = _loc4_.time - time;
                     if(time > 0 && _loc5_ > 0 && _loc3_ >= _loc2_ && !isInternalSample(_loc4_))
                     {
                        _loc6_ = getStackTrace(_loc4_.stack);
                        _loc7_ = int(_loc6_.length);
                        if(_loc7_ > 0)
                        {
                           _loc8_ = 0;
                           while(_loc8_ < _loc7_)
                           {
                              _loc9_ = _loc6_[_loc8_];
                              if(_loc9_ in methods)
                              {
                                 ++methods[_loc9_].count;
                                 methods[_loc9_].time += _loc5_;
                              }
                              else
                              {
                                 methods[_loc9_] = {
                                    "count":1,
                                    "time":_loc5_
                                 };
                              }
                              _loc8_++;
                           }
                        }
                     }
                     time = _loc4_.time;
                     _loc3_++;
                  }
                  _loc2_ = _loc3_;
               }
            }
            clearSamples();
            startSampling();
         }
      }
      
      private static function isInternalSample(param1:Sample) : Boolean
      {
         var _loc2_:String = null;
         if(param1.stack == null)
         {
            return true;
         }
         if(param1 is DeleteObjectSample)
         {
            return true;
         }
         var _loc3_:int = int(param1.stack.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(param1.stack[_loc4_] != null)
            {
               _loc2_ = StackFrame(param1.stack[_loc4_]).name;
               if(_loc2_.indexOf("MonsterDebugger") == 0)
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      private static function getStackTrace(param1:Array) : Array
      {
         var _loc2_:String = null;
         var _loc3_:Array = [];
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1[_loc5_] != null)
            {
               _loc2_ = StackFrame(param1[_loc5_]).name;
               if(!(_loc2_ == null || _loc2_ == "" || _loc2_.charAt(0) == "[" || _loc2_.indexOf("global") == 0 || _loc2_.indexOf("http://") != -1 || _loc2_.indexOf("builtin.as$0:MethodClosure") != -1 || _loc2_.indexOf("<anonymous>") != -1))
               {
                  _loc2_ = _loc2_.split("::").join(".");
                  _loc2_ = _loc2_.split("$/").join("::");
                  _loc2_ = _loc2_.split("/").join(".");
                  _loc2_ += "()";
                  _loc3_[_loc3_.length] = _loc2_;
               }
            }
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

