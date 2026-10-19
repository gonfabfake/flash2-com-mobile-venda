package com.demonsters.debugger
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   internal class MonsterDebuggerUtils
   {
      
      private static var _references:Dictionary = new Dictionary(true);
      
      private static var _reference:int = 0;
      
      public function MonsterDebuggerUtils()
      {
         super();
      }
      
      public static function snapshot(param1:DisplayObject, param2:Rectangle = null) : BitmapData
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc11_:Number = NaN;
         _loc3_ = NaN;
         _loc4_ = NaN;
         _loc5_ = NaN;
         var _loc6_:Matrix = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Number = NaN;
         var _loc9_:BitmapData = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc10_:Boolean = param1.visible;
         _loc11_ = param1.alpha;
         _loc3_ = param1.rotation;
         _loc4_ = param1.scaleX;
         _loc5_ = param1.scaleY;
         try
         {
            param1.visible = true;
            param1.alpha = 1;
            param1.rotation = 0;
            param1.scaleX = 1;
            param1.scaleY = 1;
         }
         catch(e1:Error)
         {
         }
         var _loc12_:Rectangle = param1.getBounds(param1);
         _loc12_.x = int(_loc12_.x + 0.5);
         _loc12_.y = int(_loc12_.y + 0.5);
         _loc12_.width = int(_loc12_.width + 0.5);
         _loc12_.height = int(_loc12_.height + 0.5);
         if(param1 is Stage)
         {
            _loc12_.x = 0;
            _loc12_.y = 0;
            _loc12_.width = Stage(param1).stageWidth;
            _loc12_.height = Stage(param1).stageHeight;
         }
         var _loc13_:BitmapData = null;
         if(_loc12_.width <= 0 || _loc12_.height <= 0)
         {
            return null;
         }
         _loc13_ = new BitmapData(_loc12_.width,_loc12_.height,false,16777215);
         _loc6_ = new Matrix();
         _loc6_.tx = -_loc12_.x;
         _loc6_.ty = -_loc12_.y;
         _loc13_.draw(param1,_loc6_,null,null,null,false);
         try
         {
            param1.visible = _loc10_;
            param1.alpha = _loc11_;
            param1.rotation = _loc3_;
            param1.scaleX = _loc4_;
            param1.scaleY = _loc5_;
         }
         catch(e2:Error)
         {
         }
         if(param2 != null)
         {
            if(_loc12_.width <= param2.width && _loc12_.height <= param2.height)
            {
               return _loc13_;
            }
            _loc7_ = _loc12_.clone();
            _loc7_.width = param2.width;
            _loc7_.height = param2.width * (_loc12_.height / _loc12_.width);
            if(_loc7_.height > param2.height)
            {
               _loc7_ = _loc12_.clone();
               _loc7_.width = param2.height * (_loc12_.width / _loc12_.height);
               _loc7_.height = param2.height;
            }
            _loc8_ = _loc7_.width / _loc12_.width;
            _loc9_ = new BitmapData(_loc7_.width,_loc7_.height,false,0);
            _loc6_ = new Matrix();
            _loc6_.scale(_loc8_,_loc8_);
            _loc9_.draw(_loc13_,_loc6_,null,null,null,true);
            return _loc9_;
         }
         return _loc13_;
      }
      
      public static function getMemory() : uint
      {
         return System.totalMemory;
      }
      
      public static function pause() : Boolean
      {
         try
         {
            System.pause();
            return true;
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      public static function resume() : Boolean
      {
         try
         {
            System.resume();
            return true;
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      public static function stackTrace() : XML
      {
         var childXML:XML = null;
         var stack:String = null;
         var lines:Array = null;
         var i:int = 0;
         var s:String = null;
         var bracketIndex:int = 0;
         var methodIndex:int = 0;
         var classname:String = null;
         var method:String = null;
         var file:String = null;
         var line:String = null;
         var functionXML:XML = null;
         var rootXML:XML = null;
         childXML = null;
         stack = null;
         lines = null;
         i = 0;
         s = null;
         bracketIndex = 0;
         methodIndex = 0;
         classname = null;
         method = null;
         file = null;
         line = null;
         functionXML = null;
         rootXML = <root/>;
         childXML = <node/>;
         try
         {
            throw new Error();
         }
         catch(e:Error)
         {
            stack = e.getStackTrace();
            if(stack == null || stack == "")
            {
               return <root><error>Stack unavailable</error></root>;
            }
            stack = stack.split("\t").join("");
            lines = stack.split("\n");
            if(lines.length <= 4)
            {
               return <root><error>Stack to short</error></root>;
            }
            lines.shift();
            lines.shift();
            lines.shift();
            lines.shift();
            i = 0;
            if(i >= lines.length)
            {
               rootXML.appendChild(childXML.children());
               return rootXML;
            }
            s = lines[i];
            s = s.substring(3,s.length);
            bracketIndex = s.indexOf("[");
            methodIndex = s.indexOf("/");
            if(bracketIndex == -1)
            {
               bracketIndex = s.length;
            }
            if(methodIndex == -1)
            {
               methodIndex = bracketIndex;
            }
            classname = MonsterDebuggerUtils.parseType(s.substring(0,methodIndex));
            method = "";
            file = "";
            line = "";
            if(methodIndex != s.length && methodIndex != bracketIndex)
            {
               method = s.substring(methodIndex + 1,bracketIndex);
            }
            if(bracketIndex != s.length)
            {
               file = s.substring(bracketIndex + 1,s.lastIndexOf(":"));
               line = s.substring(s.lastIndexOf(":") + 1,s.length - 1);
            }
            functionXML = <node/>;
            functionXML.@classname = classname;
            functionXML.@method = method;
            functionXML.@file = file;
            functionXML.@line = line;
            childXML.appendChild(functionXML);
            return rootXML;
         }
      }
      
      public static function getReferenceID(param1:*) : String
      {
         if(param1 in _references)
         {
            return _references[param1];
         }
         var _loc2_:String = "#" + String(_reference);
         _references[param1] = _loc2_;
         ++_reference;
         return _loc2_;
      }
      
      public static function getReference(param1:String) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         if(param1.charAt(0) != "#")
         {
            return null;
         }
         for(_loc2_ in _references)
         {
            _loc3_ = _references[_loc2_];
            if(_loc3_ == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function getObject(param1:*, param2:String = "", param3:int = 0) : *
      {
         var object:*;
         var splitted:Array;
         var i:int;
         var base:* = param1;
         var target:String = param2;
         var parent:int = param3;
         var index:Number = NaN;
         if(target == null || target == "")
         {
            return base;
         }
         if(target.charAt(0) == "#")
         {
            return getReference(target);
         }
         object = base;
         splitted = target.split(MonsterDebuggerConstants.DELIMITER);
         i = 0;
         while(i < splitted.length - parent)
         {
            if(splitted[i] != "")
            {
               try
               {
                  if(splitted[i] == "children()")
                  {
                     object = object.children();
                  }
                  else if(object is DisplayObjectContainer && splitted[i].indexOf("getChildAt(") == 0)
                  {
                     index = Number(splitted[i].substring(11,splitted[i].indexOf(")",11)));
                     object = DisplayObjectContainer(object).getChildAt(index);
                  }
                  else
                  {
                     object = object[splitted[i]];
                  }
               }
               catch(e:Error)
               {
                  break;
               }
            }
            i++;
         }
         return object;
      }
      
      public static function parse(param1:*, param2:String = "", param3:int = 1, param4:int = 5, param5:Boolean = true) : XML
      {
         var _loc6_:XML = null;
         var _loc7_:int = 0;
         var _loc8_:XML = null;
         var _loc9_:XML = <root/>;
         var _loc10_:XML = <node/>;
         var _loc11_:XML = new XML();
         var _loc12_:String = "";
         var _loc13_:String = "";
         var _loc14_:Boolean = false;
         if(param4 != -1 && param3 > param4)
         {
            return _loc9_;
         }
         if(param1 == null)
         {
            _loc6_ = <node/>;
            _loc6_.@icon = MonsterDebuggerConstants.ICON_WARNING;
            _loc6_.@label = "Null object";
            _loc6_.@name = "Null object";
            _loc6_.@type = MonsterDebuggerConstants.TYPE_WARNING;
            _loc10_.appendChild(_loc6_);
            _loc12_ = "null";
         }
         else
         {
            _loc11_ = MonsterDebuggerDescribeType.get(param1);
            _loc12_ = parseType(_loc11_.@name);
            _loc13_ = parseType(_loc11_.@base);
            _loc14_ = Boolean(_loc11_.@isDynamic);
            if(param1 is Class)
            {
               _loc10_.appendChild(parseClass(param1,param2,_loc11_,param3,param4,param5).children());
            }
            else if(_loc12_ == MonsterDebuggerConstants.TYPE_XML)
            {
               _loc10_.appendChild(parseXML(param1,param2 + "." + "children()",param3,param4).children());
            }
            else if(_loc12_ == MonsterDebuggerConstants.TYPE_XMLLIST)
            {
               _loc6_ = <node/>;
               _loc6_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
               _loc6_.@type = MonsterDebuggerConstants.TYPE_UINT;
               _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
               _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READONLY;
               _loc6_.@target = param2 + "." + "length";
               _loc6_.@label = "length" + " (" + MonsterDebuggerConstants.TYPE_UINT + ") = " + param1.length();
               _loc6_.@name = "length";
               _loc6_.@value = param1.length();
               _loc7_ = 0;
               while(_loc7_ < param1.length())
               {
                  _loc6_.appendChild(parseXML(param1[_loc7_],param2 + "." + String(_loc7_) + ".children()",param3,param4).children());
                  _loc7_++;
               }
               _loc10_.appendChild(_loc6_);
            }
            else if(_loc12_ == MonsterDebuggerConstants.TYPE_STRING || _loc12_ == MonsterDebuggerConstants.TYPE_BOOLEAN || _loc12_ == MonsterDebuggerConstants.TYPE_NUMBER || _loc12_ == MonsterDebuggerConstants.TYPE_INT || _loc12_ == MonsterDebuggerConstants.TYPE_UINT)
            {
               _loc10_.appendChild(parseBasics(param1,param2,_loc12_).children());
            }
            else if(_loc12_ == MonsterDebuggerConstants.TYPE_ARRAY || _loc12_.indexOf(MonsterDebuggerConstants.TYPE_VECTOR) == 0)
            {
               _loc10_.appendChild(parseArray(param1,param2,param3,param4).children());
            }
            else if(_loc12_ == MonsterDebuggerConstants.TYPE_OBJECT)
            {
               _loc10_.appendChild(parseObject(param1,param2,param3,param4,param5).children());
            }
            else
            {
               _loc10_.appendChild(parseClass(param1,param2,_loc11_,param3,param4,param5).children());
            }
         }
         if(param3 == 1)
         {
            _loc8_ = <node/>;
            _loc8_.@icon = MonsterDebuggerConstants.ICON_ROOT;
            _loc8_.@label = "(" + _loc12_ + ")";
            _loc8_.@type = _loc12_;
            _loc8_.@target = param2;
            _loc8_.appendChild(_loc10_.children());
            _loc9_.appendChild(_loc8_);
         }
         else
         {
            _loc9_.appendChild(_loc10_.children());
         }
         return _loc9_;
      }
      
      private static function parseBasics(param1:*, param2:String, param3:String, param4:int = 1, param5:int = 5) : XML
      {
         var _loc6_:XML = <root/>;
         var _loc7_:XML = <node/>;
         var _loc8_:Boolean = false;
         var _loc9_:XML = new XML();
         if(param3 == MonsterDebuggerConstants.TYPE_STRING)
         {
            try
            {
               _loc9_ = new XML(param1);
               _loc8_ = !_loc9_.hasSimpleContent() && _loc9_.children().length() > 0;
            }
            catch(error:TypeError)
            {
            }
         }
         if(!_loc8_)
         {
            _loc7_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
            _loc7_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc7_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
            _loc7_.@label = "(" + param3 + ") = " + printValue(param1,param3);
            _loc7_.@name = "";
            _loc7_.@type = param3;
            _loc7_.@value = printValue(param1,param3);
            _loc7_.@target = param2;
         }
         else
         {
            _loc7_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
            _loc7_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc7_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
            _loc7_.@label = "(" + MonsterDebuggerConstants.TYPE_XML + ")";
            _loc7_.@name = "";
            _loc7_.@type = MonsterDebuggerConstants.TYPE_XML;
            _loc7_.@value = "";
            _loc7_.@target = param2;
            _loc7_.appendChild(parseXML(_loc9_,param2 + "." + "children()",param4,param5).children());
         }
         _loc6_.appendChild(_loc7_);
         return _loc6_;
      }
      
      private static function parseArray(param1:*, param2:String, param3:int = 1, param4:int = 5, param5:Boolean = true) : XML
      {
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:* = undefined;
         var _loc9_:XML = <root/>;
         var _loc10_:String = "";
         var _loc11_:String = "";
         var _loc12_:Boolean = false;
         var _loc13_:XML = new XML();
         var _loc14_:int = 0;
         _loc6_ = <node/>;
         _loc6_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
         _loc6_.@label = "length" + " (" + MonsterDebuggerConstants.TYPE_UINT + ") = " + param1["length"];
         _loc6_.@name = "length";
         _loc6_.@type = MonsterDebuggerConstants.TYPE_UINT;
         _loc6_.@value = param1["length"];
         _loc6_.@target = param2 + "." + "length";
         _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
         _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READONLY;
         var _loc15_:Array = [];
         var _loc16_:Boolean = true;
         for(_loc8_ in param1)
         {
            if(!(_loc8_ is int))
            {
               _loc16_ = false;
            }
            _loc15_.push(_loc8_);
         }
         if(_loc16_)
         {
            _loc15_.sort(Array.NUMERIC);
         }
         else
         {
            _loc15_.sort(Array.CASEINSENSITIVE);
         }
         _loc14_ = 0;
         while(_loc14_ < _loc15_.length)
         {
            _loc10_ = parseType(MonsterDebuggerDescribeType.get(param1[_loc15_[_loc14_]]).@name);
            _loc11_ = param2 + "." + String(_loc15_[_loc14_]);
            if(_loc10_ == MonsterDebuggerConstants.TYPE_STRING || _loc10_ == MonsterDebuggerConstants.TYPE_BOOLEAN || _loc10_ == MonsterDebuggerConstants.TYPE_NUMBER || _loc10_ == MonsterDebuggerConstants.TYPE_INT || _loc10_ == MonsterDebuggerConstants.TYPE_UINT || _loc10_ == MonsterDebuggerConstants.TYPE_FUNCTION)
            {
               _loc12_ = false;
               _loc13_ = new XML();
               if(_loc10_ == MonsterDebuggerConstants.TYPE_STRING)
               {
                  try
                  {
                     _loc13_ = new XML(param1[_loc15_[_loc14_]]);
                     if(!_loc13_.hasSimpleContent() && _loc13_.children().length() > 0)
                     {
                        _loc12_ = true;
                     }
                  }
                  catch(error:TypeError)
                  {
                  }
               }
               if(!_loc12_)
               {
                  _loc7_ = <node/>;
                  _loc7_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                  _loc7_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                  _loc7_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                  _loc7_.@label = "[" + _loc15_[_loc14_] + "] (" + _loc10_ + ") = " + printValue(param1[_loc15_[_loc14_]],_loc10_);
                  _loc7_.@name = "[" + _loc15_[_loc14_] + "]";
                  _loc7_.@type = _loc10_;
                  _loc7_.@value = printValue(param1[_loc15_[_loc14_]],_loc10_);
                  _loc7_.@target = _loc11_;
                  _loc6_.appendChild(_loc7_);
               }
               else
               {
                  _loc7_ = <node/>;
                  _loc7_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                  _loc7_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                  _loc7_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                  _loc7_.@label = "[" + _loc15_[_loc14_] + "] (" + _loc10_ + ")";
                  _loc7_.@name = "[" + _loc15_[_loc14_] + "]";
                  _loc7_.@type = _loc10_;
                  _loc7_.@value = "";
                  _loc7_.@target = _loc11_;
                  _loc7_.appendChild(parseXML(param1[_loc15_[_loc14_]],_loc11_,param3 + 1,param4).children());
                  _loc6_.appendChild(_loc7_);
               }
            }
            else
            {
               _loc7_ = <node/>;
               _loc7_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
               _loc7_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
               _loc7_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               _loc7_.@label = "[" + _loc15_[_loc14_] + "] (" + _loc10_ + ")";
               _loc7_.@name = "[" + _loc15_[_loc14_] + "]";
               _loc7_.@type = _loc10_;
               _loc7_.@value = "";
               _loc7_.@target = _loc11_;
               _loc7_.appendChild(parse(param1[_loc15_[_loc14_]],_loc11_,param3 + 1,param4,param5).children());
               _loc6_.appendChild(_loc7_);
            }
            _loc14_++;
         }
         _loc9_.appendChild(_loc6_);
         return _loc9_;
      }
      
      public static function parseXML(param1:*, param2:String = "", param3:int = 1, param4:int = -1) : XML
      {
         var _loc5_:XML = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:XML = <root/>;
         var _loc9_:int = 0;
         if(param4 != -1 && param3 > param4)
         {
            return _loc8_;
         }
         if(param2.indexOf("@") != -1)
         {
            _loc5_ = <node/>;
            _loc5_.@icon = MonsterDebuggerConstants.ICON_XMLATTRIBUTE;
            _loc5_.@type = MonsterDebuggerConstants.TYPE_XMLATTRIBUTE;
            _loc5_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc5_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
            _loc5_.@label = param1;
            _loc5_.@name = "";
            _loc5_.@value = param1;
            _loc5_.@target = param2;
            _loc8_.appendChild(_loc5_);
         }
         else if(param1.name() == null)
         {
            _loc5_ = <node/>;
            _loc5_.@icon = MonsterDebuggerConstants.ICON_XMLVALUE;
            _loc5_.@type = MonsterDebuggerConstants.TYPE_XMLVALUE;
            _loc5_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc5_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
            _loc5_.@label = "(" + MonsterDebuggerConstants.TYPE_XMLVALUE + ") = " + printValue(param1,MonsterDebuggerConstants.TYPE_XMLVALUE);
            _loc5_.@name = "";
            _loc5_.@value = printValue(param1,MonsterDebuggerConstants.TYPE_XMLVALUE);
            _loc5_.@target = param2;
            _loc8_.appendChild(_loc5_);
         }
         else if(Boolean(param1.hasSimpleContent()))
         {
            _loc5_ = <node/>;
            _loc5_.@icon = MonsterDebuggerConstants.ICON_XMLNODE;
            _loc5_.@type = MonsterDebuggerConstants.TYPE_XMLNODE;
            _loc5_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc5_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
            _loc5_.@label = param1.name() + " (" + MonsterDebuggerConstants.TYPE_XMLNODE + ")";
            _loc5_.@name = param1.name();
            _loc5_.@value = "";
            _loc5_.@target = param2;
            if(param1 != "")
            {
               _loc6_ = <node/>;
               _loc6_.@icon = MonsterDebuggerConstants.ICON_XMLVALUE;
               _loc6_.@type = MonsterDebuggerConstants.TYPE_XMLVALUE;
               _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
               _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               _loc6_.@label = "(" + MonsterDebuggerConstants.TYPE_XMLVALUE + ") = " + printValue(param1,MonsterDebuggerConstants.TYPE_XMLVALUE);
               _loc6_.@name = "";
               _loc6_.@value = printValue(param1,MonsterDebuggerConstants.TYPE_XMLVALUE);
               _loc6_.@target = param2;
               _loc5_.appendChild(_loc6_);
            }
            _loc9_ = 0;
            while(_loc9_ < param1.attributes().length())
            {
               _loc6_ = <node/>;
               _loc6_.@icon = MonsterDebuggerConstants.ICON_XMLATTRIBUTE;
               _loc6_.@type = MonsterDebuggerConstants.TYPE_XMLATTRIBUTE;
               _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
               _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               _loc6_.@label = "@" + param1.attributes()[_loc9_].name() + " (" + MonsterDebuggerConstants.TYPE_XMLATTRIBUTE + ") = " + param1.attributes()[_loc9_];
               _loc6_.@name = "";
               _loc6_.@value = param1.attributes()[_loc9_];
               _loc6_.@target = param2 + "." + "@" + param1.attributes()[_loc9_].name();
               _loc5_.appendChild(_loc6_);
               _loc9_++;
            }
            _loc8_.appendChild(_loc5_);
         }
         else
         {
            _loc5_ = <node/>;
            _loc5_.@icon = MonsterDebuggerConstants.ICON_XMLNODE;
            _loc5_.@type = MonsterDebuggerConstants.TYPE_XMLNODE;
            _loc5_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
            _loc5_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
            _loc5_.@label = param1.name() + " (" + MonsterDebuggerConstants.TYPE_XMLNODE + ")";
            _loc5_.@name = param1.name();
            _loc5_.@value = "";
            _loc5_.@target = param2;
            _loc9_ = 0;
            while(_loc9_ < param1.attributes().length())
            {
               _loc6_ = <node/>;
               _loc6_.@icon = MonsterDebuggerConstants.ICON_XMLATTRIBUTE;
               _loc6_.@type = MonsterDebuggerConstants.TYPE_XMLATTRIBUTE;
               _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
               _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               _loc6_.@label = "@" + param1.attributes()[_loc9_].name() + " (" + MonsterDebuggerConstants.TYPE_XMLATTRIBUTE + ") = " + param1.attributes()[_loc9_];
               _loc6_.@name = "";
               _loc6_.@value = param1.attributes()[_loc9_];
               _loc6_.@target = param2 + "." + "@" + param1.attributes()[_loc9_].name();
               _loc5_.appendChild(_loc6_);
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < param1.children().length())
            {
               _loc7_ = param2 + "." + "children()" + "." + _loc9_;
               _loc5_.appendChild(parseXML(param1.children()[_loc9_],_loc7_,param3 + 1,param4).children());
               _loc9_++;
            }
            _loc8_.appendChild(_loc5_);
         }
         return _loc8_;
      }
      
      private static function parseObject(param1:*, param2:String, param3:int = 1, param4:int = 5, param5:Boolean = true) : XML
      {
         var _loc6_:XML = null;
         var _loc7_:* = undefined;
         var _loc8_:XML = <root/>;
         var _loc9_:XML = <node/>;
         var _loc10_:String = "";
         var _loc11_:String = "";
         var _loc12_:Boolean = false;
         var _loc13_:XML = new XML();
         var _loc14_:int = 0;
         var _loc15_:Array = [];
         var _loc16_:Boolean = true;
         for(_loc7_ in param1)
         {
            if(!(_loc7_ is int))
            {
               _loc16_ = false;
            }
            _loc15_.push(_loc7_);
         }
         if(_loc16_)
         {
            _loc15_.sort(Array.NUMERIC);
         }
         else
         {
            _loc15_.sort(Array.CASEINSENSITIVE);
         }
         _loc14_ = 0;
         while(_loc14_ < _loc15_.length)
         {
            _loc10_ = parseType(MonsterDebuggerDescribeType.get(param1[_loc15_[_loc14_]]).@name);
            _loc11_ = param2 + "." + _loc15_[_loc14_];
            if(_loc10_ == MonsterDebuggerConstants.TYPE_STRING || _loc10_ == MonsterDebuggerConstants.TYPE_BOOLEAN || _loc10_ == MonsterDebuggerConstants.TYPE_NUMBER || _loc10_ == MonsterDebuggerConstants.TYPE_INT || _loc10_ == MonsterDebuggerConstants.TYPE_UINT || _loc10_ == MonsterDebuggerConstants.TYPE_FUNCTION)
            {
               _loc12_ = false;
               _loc13_ = new XML();
               if(_loc10_ == MonsterDebuggerConstants.TYPE_STRING)
               {
                  try
                  {
                     _loc13_ = new XML(param1[_loc15_[_loc14_]]);
                     if(!_loc13_.hasSimpleContent() && _loc13_.children().length() > 0)
                     {
                        _loc12_ = true;
                     }
                  }
                  catch(error:TypeError)
                  {
                  }
               }
               if(!_loc12_)
               {
                  _loc6_ = <node/>;
                  _loc6_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                  _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                  _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                  _loc6_.@label = _loc15_[_loc14_] + " (" + _loc10_ + ") = " + printValue(param1[_loc15_[_loc14_]],_loc10_);
                  _loc6_.@name = _loc15_[_loc14_];
                  _loc6_.@type = _loc10_;
                  _loc6_.@value = printValue(param1[_loc15_[_loc14_]],_loc10_);
                  _loc6_.@target = _loc11_;
                  _loc9_.appendChild(_loc6_);
               }
               else
               {
                  _loc6_ = <node/>;
                  _loc6_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
                  _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
                  _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                  _loc6_.@label = _loc15_[_loc14_] + " (" + _loc10_ + ")";
                  _loc6_.@name = _loc15_[_loc14_];
                  _loc6_.@type = _loc10_;
                  _loc6_.@value = "";
                  _loc6_.@target = _loc11_;
                  _loc6_.appendChild(parseXML(param1[_loc15_[_loc14_]],_loc11_,param3 + 1,param4).children());
                  _loc9_.appendChild(_loc6_);
               }
            }
            else
            {
               _loc6_ = <node/>;
               _loc6_.@icon = MonsterDebuggerConstants.ICON_VARIABLE;
               _loc6_.@access = MonsterDebuggerConstants.ACCESS_VARIABLE;
               _loc6_.@permission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               _loc6_.@label = _loc15_[_loc14_] + " (" + _loc10_ + ")";
               _loc6_.@name = _loc15_[_loc14_];
               _loc6_.@type = _loc10_;
               _loc6_.@value = "";
               _loc6_.@target = _loc11_;
               _loc6_.appendChild(parse(param1[_loc15_[_loc14_]],_loc11_,param3 + 1,param4,param5).children());
               _loc9_.appendChild(_loc6_);
            }
            _loc14_++;
         }
         _loc8_.appendChild(_loc9_.children());
         return _loc8_;
      }
      
      private static function parseClass(param1:*, param2:String, param3:XML, param4:int = 1, param5:int = 5, param6:Boolean = true) : XML
      {
         var object:* = param1;
         var target:String = param2;
         var description:XML = param3;
         var currentDepth:int = param4;
         var maxDepth:int = param5;
         var includeDisplayObjects:Boolean = param6;
         var key:String = null;
         var itemsArrayLength:int = 0;
         var item:* = undefined;
         var itemXML:XML = null;
         var itemAccess:String = null;
         var itemPermission:String = null;
         var itemIcon:String = null;
         var itemType:String = null;
         var itemName:String = null;
         var itemTarget:String = null;
         var isXMLString:XML = null;
         var i:int = 0;
         var prop:* = undefined;
         var displayObject:DisplayObjectContainer = null;
         var displayObjects:Array = null;
         var child:DisplayObject = null;
         var rootXML:XML = <root/>;
         var nodeXML:XML = <node/>;
         var variables:XMLList = description..variable;
         var accessors:XMLList = description..accessor;
         var constants:XMLList = description..constant;
         var isDynamic:Boolean = Boolean(description.@isDynamic);
         var variablesLength:int = variables.length();
         var accessorsLength:int = accessors.length();
         var constantsLength:int = constants.length();
         var childLength:int = 0;
         var keys:Object = {};
         var itemsArray:Array = [];
         var isXML:Boolean = false;
         if(isDynamic)
         {
            for(prop in object)
            {
               key = String(prop);
               if(!keys.hasOwnProperty(key))
               {
                  keys[key] = key;
                  itemName = key;
                  itemType = parseType(getQualifiedClassName(object[key]));
                  itemTarget = target + "." + key;
                  itemAccess = MonsterDebuggerConstants.ACCESS_VARIABLE;
                  itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                  itemIcon = MonsterDebuggerConstants.ICON_VARIABLE;
                  itemsArray[itemsArray.length] = {
                     "name":itemName,
                     "type":itemType,
                     "target":itemTarget,
                     "access":itemAccess,
                     "permission":itemPermission,
                     "icon":itemIcon
                  };
               }
            }
         }
         i = 0;
         while(i < variablesLength)
         {
            key = variables[i].@name;
            if(!keys.hasOwnProperty(key))
            {
               keys[key] = key;
               itemName = key;
               itemType = parseType(variables[i].@type);
               itemTarget = target + "." + key;
               itemAccess = MonsterDebuggerConstants.ACCESS_VARIABLE;
               itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               itemIcon = MonsterDebuggerConstants.ICON_VARIABLE;
               itemsArray[itemsArray.length] = {
                  "name":itemName,
                  "type":itemType,
                  "target":itemTarget,
                  "access":itemAccess,
                  "permission":itemPermission,
                  "icon":itemIcon
               };
            }
            i++;
         }
         i = 0;
         while(i < accessorsLength)
         {
            key = accessors[i].@name;
            if(!keys.hasOwnProperty(key))
            {
               keys[key] = key;
               itemName = key;
               itemType = parseType(accessors[i].@type);
               itemTarget = target + "." + key;
               itemAccess = MonsterDebuggerConstants.ACCESS_ACCESSOR;
               itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
               itemIcon = MonsterDebuggerConstants.ICON_VARIABLE;
               if(accessors[i].@access == MonsterDebuggerConstants.PERMISSION_READONLY)
               {
                  itemPermission = MonsterDebuggerConstants.PERMISSION_READONLY;
                  itemIcon = MonsterDebuggerConstants.ICON_VARIABLE_READONLY;
               }
               if(accessors[i].@access == MonsterDebuggerConstants.PERMISSION_WRITEONLY)
               {
                  itemPermission = MonsterDebuggerConstants.PERMISSION_WRITEONLY;
                  itemIcon = MonsterDebuggerConstants.ICON_VARIABLE_WRITEONLY;
               }
               itemsArray[itemsArray.length] = {
                  "name":itemName,
                  "type":itemType,
                  "target":itemTarget,
                  "access":itemAccess,
                  "permission":itemPermission,
                  "icon":itemIcon
               };
            }
            i++;
         }
         i = 0;
         while(i < constantsLength)
         {
            key = constants[i].@name;
            if(!keys.hasOwnProperty(key))
            {
               keys[key] = key;
               itemName = key;
               itemType = parseType(constants[i].@type);
               itemTarget = target + "." + key;
               itemAccess = MonsterDebuggerConstants.ACCESS_CONSTANT;
               itemPermission = MonsterDebuggerConstants.PERMISSION_READONLY;
               itemIcon = MonsterDebuggerConstants.ICON_VARIABLE_READONLY;
               itemsArray[itemsArray.length] = {
                  "name":itemName,
                  "type":itemType,
                  "target":itemTarget,
                  "access":itemAccess,
                  "permission":itemPermission,
                  "icon":itemIcon
               };
            }
            i++;
         }
         itemsArray.sortOn("name",Array.CASEINSENSITIVE);
         if(includeDisplayObjects && object is DisplayObjectContainer)
         {
            displayObject = DisplayObjectContainer(object);
            displayObjects = [];
            childLength = displayObject.numChildren;
            i = 0;
            while(i < childLength)
            {
               child = displayObject.getChildAt(i);
               if(child != null)
               {
                  itemXML = MonsterDebuggerDescribeType.get(child);
                  itemType = parseType(itemXML.@name);
                  itemName = "DisplayObject";
                  if(child.name != null)
                  {
                     itemName += " - " + child.name;
                  }
                  itemTarget = target + "." + "getChildAt(" + i + ")";
                  itemAccess = MonsterDebuggerConstants.ACCESS_DISPLAY_OBJECT;
                  itemPermission = MonsterDebuggerConstants.PERMISSION_READWRITE;
                  itemIcon = child is DisplayObjectContainer ? MonsterDebuggerConstants.ICON_ROOT : MonsterDebuggerConstants.ICON_DISPLAY_OBJECT;
                  displayObjects[displayObjects.length] = {
                     "name":itemName,
                     "type":itemType,
                     "target":itemTarget,
                     "access":itemAccess,
                     "permission":itemPermission,
                     "icon":itemIcon,
                     "index":i
                  };
               }
               i++;
            }
            displayObjects.sortOn("name",Array.CASEINSENSITIVE);
            itemsArray = displayObjects.concat(itemsArray);
         }
         itemsArrayLength = int(itemsArray.length);
         i = 0;
         while(i < itemsArrayLength)
         {
            itemType = itemsArray[i].type;
            itemName = itemsArray[i].name;
            itemTarget = itemsArray[i].target;
            itemPermission = itemsArray[i].permission;
            itemAccess = itemsArray[i].access;
            itemIcon = itemsArray[i].icon;
            try
            {
               if(itemAccess == MonsterDebuggerConstants.ACCESS_DISPLAY_OBJECT)
               {
                  item = DisplayObjectContainer(object).getChildAt(itemsArray[i].index);
               }
               else
               {
                  item = object[itemName];
               }
            }
            catch(e:Error)
            {
               item = null;
            }
            if(item != null && itemPermission != MonsterDebuggerConstants.PERMISSION_WRITEONLY)
            {
               if(itemType == MonsterDebuggerConstants.TYPE_STRING || itemType == MonsterDebuggerConstants.TYPE_BOOLEAN || itemType == MonsterDebuggerConstants.TYPE_NUMBER || itemType == MonsterDebuggerConstants.TYPE_INT || itemType == MonsterDebuggerConstants.TYPE_UINT || itemType == MonsterDebuggerConstants.TYPE_FUNCTION)
               {
                  isXML = false;
                  isXMLString = new XML();
                  if(itemType == MonsterDebuggerConstants.TYPE_STRING)
                  {
                     try
                     {
                        isXMLString = new XML(item);
                        isXML = !isXMLString.hasSimpleContent() && isXMLString.children().length() > 0;
                     }
                     catch(error:TypeError)
                     {
                     }
                  }
                  if(!isXML)
                  {
                     nodeXML = <node/>;
                     nodeXML.@icon = itemIcon;
                     nodeXML.@label = itemName + " (" + itemType + ") = " + printValue(item,itemType);
                     nodeXML.@name = itemName;
                     nodeXML.@type = itemType;
                     nodeXML.@value = printValue(item,itemType);
                     nodeXML.@target = itemTarget;
                     nodeXML.@access = itemAccess;
                     nodeXML.@permission = itemPermission;
                     rootXML.appendChild(nodeXML);
                  }
                  else
                  {
                     nodeXML = <node/>;
                     nodeXML.@icon = itemIcon;
                     nodeXML.@label = itemName + " (" + itemType + ")";
                     nodeXML.@name = itemName;
                     nodeXML.@type = itemType;
                     nodeXML.@value = "";
                     nodeXML.@target = itemTarget;
                     nodeXML.@access = itemAccess;
                     nodeXML.@permission = itemPermission;
                     nodeXML.appendChild(parseXML(isXMLString,itemTarget + "." + "children()",currentDepth,maxDepth).children());
                     rootXML.appendChild(nodeXML);
                  }
               }
               else
               {
                  nodeXML = <node/>;
                  nodeXML.@icon = itemIcon;
                  nodeXML.@label = itemName + " (" + itemType + ")";
                  nodeXML.@name = itemName;
                  nodeXML.@type = itemType;
                  nodeXML.@target = itemTarget;
                  nodeXML.@access = itemAccess;
                  nodeXML.@permission = itemPermission;
                  if(item != null && itemType != MonsterDebuggerConstants.TYPE_BYTEARRAY)
                  {
                     nodeXML.appendChild(parse(item,itemTarget,currentDepth + 1,maxDepth,includeDisplayObjects).children());
                  }
                  rootXML.appendChild(nodeXML);
               }
            }
            i++;
         }
         return rootXML;
      }
      
      public static function parseFunctions(param1:*, param2:String = "") : XML
      {
         var object:* = param1;
         var target:String = param2;
         var itemXML:XML = null;
         var key:String = null;
         var returnType:String = null;
         var parameters:XMLList = null;
         var parametersLength:int = 0;
         var args:Array = null;
         var argsString:String = null;
         var methodXML:XML = null;
         var parameterXML:XML = null;
         var rootXML:XML = <root/>;
         var description:XML = MonsterDebuggerDescribeType.get(object);
         var type:String = parseType(description.@name);
         var itemType:String = "";
         var itemName:String = "";
         var itemTarget:String = "";
         var keys:Object = {};
         var methods:XMLList = description..method;
         var methodsArr:Array = [];
         var methodsLength:int = methods.length();
         var optional:Boolean = false;
         var i:int = 0;
         var n:int = 0;
         itemXML = <node/>;
         itemXML.@icon = MonsterDebuggerConstants.ICON_DEFAULT;
         itemXML.@label = "(" + type + ")";
         itemXML.@target = target;
         i = 0;
         while(i < methodsLength)
         {
            key = methods[i].@name;
            try
            {
               if(!keys.hasOwnProperty(key))
               {
                  keys[key] = key;
                  methodsArr[methodsArr.length] = {
                     "name":key,
                     "xml":methods[i],
                     "access":MonsterDebuggerConstants.ACCESS_METHOD
                  };
               }
            }
            catch(e:Error)
            {
            }
            i++;
         }
         methodsArr.sortOn("name",Array.CASEINSENSITIVE);
         methodsLength = int(methodsArr.length);
         i = 0;
         while(i < methodsLength)
         {
            itemType = MonsterDebuggerConstants.TYPE_FUNCTION;
            itemName = methodsArr[i].xml.@name;
            itemTarget = target + MonsterDebuggerConstants.DELIMITER + itemName;
            returnType = parseType(methodsArr[i].xml.@returnType);
            parameters = methodsArr[i].xml..parameter;
            parametersLength = parameters.length();
            args = [];
            argsString = "";
            optional = false;
            n = 0;
            while(n < parametersLength)
            {
               if(parameters[n].@optional == "true" && !optional)
               {
                  optional = true;
                  args[args.length] = "[";
               }
               args[args.length] = parseType(parameters[n].@type);
               n++;
            }
            if(optional)
            {
               args[args.length] = "]";
            }
            argsString = args.join(", ");
            argsString = argsString.replace("[, ","[");
            argsString = argsString.replace(", ]","]");
            methodXML = <node/>;
            methodXML.@icon = MonsterDebuggerConstants.ICON_FUNCTION;
            methodXML.@type = MonsterDebuggerConstants.TYPE_FUNCTION;
            methodXML.@access = MonsterDebuggerConstants.ACCESS_METHOD;
            methodXML.@label = itemName + "(" + argsString + "):" + returnType;
            methodXML.@name = itemName;
            methodXML.@target = itemTarget;
            methodXML.@args = argsString;
            methodXML.@returnType = returnType;
            n = 0;
            while(n < parametersLength)
            {
               parameterXML = <node/>;
               parameterXML.@type = parseType(parameters[n].@type);
               parameterXML.@index = parameters[n].@index;
               parameterXML.@optional = parameters[n].@optional;
               methodXML.appendChild(parameterXML);
               n++;
            }
            itemXML.appendChild(methodXML);
            i++;
         }
         rootXML.appendChild(itemXML);
         return rootXML;
      }
      
      public static function parseType(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(param1.indexOf("::") != -1)
         {
            param1 = param1.substring(param1.indexOf("::") + 2,param1.length);
         }
         if(param1.indexOf("::") != -1)
         {
            _loc2_ = param1.substring(0,param1.indexOf("<") + 1);
            _loc3_ = param1.substring(param1.indexOf("::") + 2,param1.length);
            param1 = _loc2_ + _loc3_;
         }
         param1 = param1.replace("()","");
         return param1.replace(MonsterDebuggerConstants.TYPE_METHOD,MonsterDebuggerConstants.TYPE_FUNCTION);
      }
      
      public static function isDisplayObject(param1:*) : Boolean
      {
         return param1 is DisplayObject || param1 is DisplayObjectContainer;
      }
      
      public static function printValue(param1:*, param2:String) : String
      {
         if(param2 == MonsterDebuggerConstants.TYPE_BYTEARRAY)
         {
            return param1["length"] + " bytes";
         }
         if(param1 == null)
         {
            return "null";
         }
         return String(param1);
      }
      
      public static function getObjectUnderPoint(param1:DisplayObjectContainer, param2:Point) : DisplayObject
      {
         var _loc3_:Array = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         if(param1.areInaccessibleObjectsUnderPoint(param2))
         {
            return param1;
         }
         _loc3_ = param1.getObjectsUnderPoint(param2);
         _loc3_.reverse();
         if(_loc3_ == null || _loc3_.length == 0)
         {
            return param1;
         }
         _loc4_ = _loc3_[0];
         _loc3_.length = 0;
         while(true)
         {
            _loc3_[_loc3_.length] = _loc4_;
            if(_loc4_.parent == null)
            {
               break;
            }
            _loc4_ = _loc4_.parent;
         }
         _loc3_.reverse();
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc6_];
            if(!(_loc5_ is DisplayObjectContainer))
            {
               break;
            }
            _loc4_ = _loc5_;
            if(!DisplayObjectContainer(_loc5_).mouseChildren)
            {
               break;
            }
            _loc6_++;
         }
         return _loc4_;
      }
   }
}

