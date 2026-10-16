package com.demonsters.debugger
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   internal class MonsterDebuggerCore
   {
      
      private static var _monitorTimer:Timer;
      
      private static var _monitorSprite:Sprite;
      
      private static var _monitorTime:Number;
      
      private static var _monitorStart:Number;
      
      private static var _monitorFrames:int;
      
      private static var _highlight:Sprite;
      
      private static var _highlightInfo:TextField;
      
      private static var _highlightTarget:DisplayObject;
      
      private static var _highlightMouse:Boolean;
      
      private static var _highlightUpdate:Boolean;
      
      private static const MONITOR_UPDATE:int = 500;
      
      private static const HIGHLITE_COLOR:uint = 3381759;
      
      private static var _base:Object = null;
      
      private static var _stage:Stage = null;
      
      private static var _plugins:Object = {};
      
      internal static const ID:String = "com.demonsters.debugger.core";
      
      internal static var menus:Array = ["trace","inspect","snapshot","breakpoint","log"];
      
      private static var _enabled:Boolean = false;
      
      public function MonsterDebuggerCore()
      {
         super();
      }
      
      internal static function initialize() : void
      {
         var _loc1_:TextFormat = null;
         _monitorTime = new Date().time;
         _monitorStart = new Date().time;
         _monitorFrames = 0;
         _monitorTimer = new Timer(MONITOR_UPDATE);
         _monitorTimer.addEventListener(TimerEvent.TIMER,monitorTimerCallback,false,0,true);
         _monitorTimer.start();
         if(_base.hasOwnProperty("stage") && _base["stage"] != null && _base["stage"] is Stage)
         {
            _stage = _base["stage"] as Stage;
         }
         _monitorSprite = new Sprite();
         _monitorSprite.addEventListener(Event.ENTER_FRAME,frameHandler,false,0,true);
         _loc1_ = new TextFormat();
         _loc1_.font = "Arial";
         _loc1_.color = 16777215;
         _loc1_.size = 11;
         _loc1_.leftMargin = 5;
         _loc1_.rightMargin = 5;
         _highlightInfo = new TextField();
         _highlightInfo.embedFonts = false;
         _highlightInfo.autoSize = TextFieldAutoSize.LEFT;
         _highlightInfo.mouseWheelEnabled = false;
         _highlightInfo.mouseEnabled = false;
         _highlightInfo.condenseWhite = false;
         _highlightInfo.embedFonts = false;
         _highlightInfo.multiline = false;
         _highlightInfo.selectable = false;
         _highlightInfo.wordWrap = false;
         _highlightInfo.defaultTextFormat = _loc1_;
         _highlightInfo.text = "";
         _highlight = new Sprite();
         _highlightMouse = false;
         _highlightTarget = null;
         _highlightUpdate = false;
      }
      
      internal static function createMenu() : ContextMenu
      {
         var _loc1_:ContextMenuItem = null;
         var _loc2_:ContextMenu = new ContextMenu();
         _loc2_.hideBuiltInItems();
         var _loc3_:int = 0;
         while(_loc3_ < menus.length)
         {
            _loc1_ = new ContextMenuItem(menus[_loc3_]);
            _loc1_.separatorBefore = true;
            _loc2_.customItems.push(_loc1_);
            _loc1_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,__menuSelected);
            _loc3_++;
         }
         return _loc2_;
      }
      
      internal static function __menuSelected(param1:ContextMenuEvent) : void
      {
         var _loc2_:ContextMenuItem = param1.currentTarget as ContextMenuItem;
         switch(_loc2_.caption)
         {
            case "trace":
               return;
            default:
               return;
         }
      }
      
      internal static function get base() : *
      {
         return _base;
      }
      
      internal static function set base(param1:*) : void
      {
         _base = param1;
      }
      
      internal static function hasPlugin(param1:String) : Boolean
      {
         return param1 in _plugins;
      }
      
      internal static function registerPlugin(param1:String, param2:MonsterDebuggerPlugin) : void
      {
         if(param1 in _plugins)
         {
            return;
         }
         _plugins[param1] = param2;
      }
      
      internal static function unregisterPlugin(param1:String) : void
      {
         if(param1 in _plugins)
         {
            _plugins[param1] = null;
         }
      }
      
      internal static function trace(param1:*, param2:*, param3:String = "", param4:String = "", param5:uint = 0, param6:int = 5) : void
      {
         var _loc7_:XML = null;
         var _loc8_:Object = null;
         if(MonsterDebugger.enabled)
         {
            _loc7_ = XML(MonsterDebuggerUtils.parse(param2,"",1,param6,false));
            _loc8_ = {
               "command":MonsterDebuggerConstants.COMMAND_TRACE,
               "memory":MonsterDebuggerUtils.getMemory(),
               "date":new Date(),
               "target":String(param1),
               "reference":MonsterDebuggerUtils.getReferenceID(param1),
               "xml":_loc7_,
               "person":param3,
               "label":param4,
               "color":param5
            };
            send(_loc8_);
         }
      }
      
      internal static function snapshot(param1:*, param2:DisplayObject, param3:String = "", param4:String = "") : void
      {
         var _loc5_:BitmapData = null;
         var _loc6_:ByteArray = null;
         var _loc7_:Object = null;
         if(MonsterDebugger.enabled)
         {
            _loc5_ = MonsterDebuggerUtils.snapshot(param2);
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_.getPixels(new Rectangle(0,0,_loc5_.width,_loc5_.height));
               _loc7_ = {
                  "command":MonsterDebuggerConstants.COMMAND_SNAPSHOT,
                  "memory":MonsterDebuggerUtils.getMemory(),
                  "date":new Date(),
                  "target":String(param1),
                  "reference":MonsterDebuggerUtils.getReferenceID(param1),
                  "bytes":_loc6_,
                  "width":param2.width,
                  "height":param2.height,
                  "person":param3,
                  "label":param4
               };
               send(_loc7_);
            }
         }
      }
      
      internal static function breakpoint(param1:*, param2:String = "breakpoint") : void
      {
         var _loc3_:XML = null;
         var _loc4_:Object = null;
         if(MonsterDebugger.enabled && MonsterDebuggerConnection.connected)
         {
            _loc3_ = MonsterDebuggerUtils.stackTrace();
            _loc4_ = {
               "command":MonsterDebuggerConstants.COMMAND_PAUSE,
               "memory":MonsterDebuggerUtils.getMemory(),
               "date":new Date(),
               "target":String(param1),
               "reference":MonsterDebuggerUtils.getReferenceID(param1),
               "stack":_loc3_,
               "id":param2
            };
            send(_loc4_);
            MonsterDebuggerUtils.pause();
         }
      }
      
      internal static function inspect(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:XML = null;
         if(MonsterDebugger.enabled)
         {
            _base = param1;
            _loc2_ = MonsterDebuggerUtils.getObject(_base,"",0);
            if(_loc2_ != null)
            {
               _loc3_ = XML(MonsterDebuggerUtils.parse(_loc2_,"",1,2,true));
               send({
                  "command":MonsterDebuggerConstants.COMMAND_BASE,
                  "xml":_loc3_
               });
            }
         }
      }
      
      internal static function clear() : void
      {
         if(MonsterDebugger.enabled)
         {
            send({"command":MonsterDebuggerConstants.COMMAND_CLEAR_TRACES});
         }
      }
      
      internal static function sendInformation() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:XML = null;
         var _loc6_:Namespace = null;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:String = Capabilities.playerType;
         var _loc11_:String = Capabilities.version;
         var _loc12_:Boolean = Capabilities.isDebugger;
         var _loc13_:Boolean = false;
         var _loc14_:String = "";
         var _loc15_:String = "";
         try
         {
            _loc1_ = getDefinitionByName("mx.core::UIComponent");
            if(_loc1_ != null)
            {
               _loc13_ = true;
            }
         }
         catch(e1:Error)
         {
         }
         if(_base is DisplayObject && _base.hasOwnProperty("loaderInfo"))
         {
            if(DisplayObject(_base).loaderInfo != null)
            {
               _loc15_ = unescape(DisplayObject(_base).loaderInfo.url);
            }
         }
         if(_base.hasOwnProperty("stage"))
         {
            if(_base["stage"] != null && _base["stage"] is Stage)
            {
               _loc15_ = unescape(Stage(_base["stage"]).loaderInfo.url);
            }
         }
         if(_loc10_ == "ActiveX" || _loc10_ == "PlugIn")
         {
            if(ExternalInterface.available)
            {
               try
               {
                  _loc2_ = ExternalInterface.call("window.location.href.toString");
                  _loc3_ = ExternalInterface.call("window.document.title.toString");
                  if(_loc2_ != null)
                  {
                     _loc15_ = _loc2_;
                  }
                  if(_loc3_ != null)
                  {
                     _loc14_ = _loc3_;
                  }
               }
               catch(e2:Error)
               {
               }
            }
         }
         if(_loc10_ == "Desktop")
         {
            try
            {
               _loc4_ = getDefinitionByName("flash.desktop::NativeApplication");
               if(_loc4_ != null)
               {
                  _loc5_ = _loc4_["nativeApplication"]["applicationDescriptor"];
                  _loc6_ = _loc5_.namespace();
                  _loc7_ = _loc5_._loc6_::filename;
                  _loc8_ = getDefinitionByName("flash.filesystem::File");
                  if(Capabilities.os.toLowerCase().indexOf("windows") != -1)
                  {
                     _loc7_ += ".exe";
                     _loc15_ = _loc8_["applicationDirectory"]["resolvePath"](_loc7_)["nativePath"];
                  }
                  else if(Capabilities.os.toLowerCase().indexOf("mac") != -1)
                  {
                     _loc7_ += ".app";
                     _loc15_ = _loc8_["applicationDirectory"]["resolvePath"](_loc7_)["nativePath"];
                  }
               }
            }
            catch(e3:Error)
            {
            }
         }
         if(_loc14_ == "" && _loc15_ != "")
         {
            _loc9_ = Math.max(_loc15_.lastIndexOf("\\"),_loc15_.lastIndexOf("/"));
            if(_loc9_ != -1)
            {
               _loc14_ = _loc15_.substring(_loc9_ + 1,_loc15_.lastIndexOf("."));
            }
            else
            {
               _loc14_ = _loc15_;
            }
         }
         var _loc16_:Object = {
            "command":MonsterDebuggerConstants.COMMAND_INFO,
            "debuggerVersion":MonsterDebugger.VERSION,
            "playerType":_loc10_,
            "playerVersion":_loc11_,
            "isDebugger":_loc12_,
            "isFlex":_loc13_,
            "fileLocation":_loc15_,
            "fileTitle":_loc14_
         };
         send(_loc16_,true);
         MonsterDebuggerConnection.processQueue();
      }
      
      internal static function handle(param1:MonsterDebuggerData) : void
      {
         if(MonsterDebugger.enabled)
         {
            if(param1.id == null || param1.id == "")
            {
               return;
            }
            if(param1.id == MonsterDebuggerCore.ID)
            {
               handleInternal(param1);
            }
            else if(param1.id in _plugins && _plugins[param1.id] != null)
            {
               MonsterDebuggerPlugin(_plugins[param1.id]).handle(param1);
            }
         }
      }
      
      private static function handleInternal(param1:MonsterDebuggerData) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:XML = null;
         var _loc4_:Function = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:BitmapData = null;
         var _loc7_:ByteArray = null;
         switch(param1.data["command"])
         {
            case MonsterDebuggerConstants.COMMAND_HELLO:
               sendInformation();
               break;
            case MonsterDebuggerConstants.COMMAND_BASE:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,"",0);
               if(_loc2_ != null)
               {
                  _loc3_ = XML(MonsterDebuggerUtils.parse(_loc2_,"",1,2,true));
                  send({
                     "command":MonsterDebuggerConstants.COMMAND_BASE,
                     "xml":_loc3_
                  });
               }
               break;
            case MonsterDebuggerConstants.COMMAND_INSPECT:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc2_ != null)
               {
                  _base = _loc2_;
                  _loc3_ = XML(MonsterDebuggerUtils.parse(_loc2_,"",1,2,true));
                  send({
                     "command":MonsterDebuggerConstants.COMMAND_BASE,
                     "xml":_loc3_
                  });
               }
               break;
            case MonsterDebuggerConstants.COMMAND_GET_OBJECT:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc2_ != null)
               {
                  _loc3_ = XML(MonsterDebuggerUtils.parse(_loc2_,param1.data["target"],1,2,true));
                  send({
                     "command":MonsterDebuggerConstants.COMMAND_GET_OBJECT,
                     "xml":_loc3_
                  });
               }
               break;
            case MonsterDebuggerConstants.COMMAND_GET_PROPERTIES:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc2_ != null)
               {
                  _loc3_ = XML(MonsterDebuggerUtils.parse(_loc2_,param1.data["target"],1,1,false));
                  send({
                     "command":MonsterDebuggerConstants.COMMAND_GET_PROPERTIES,
                     "xml":_loc3_
                  });
               }
               break;
            case MonsterDebuggerConstants.COMMAND_GET_FUNCTIONS:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc2_ != null)
               {
                  _loc3_ = XML(MonsterDebuggerUtils.parseFunctions(_loc2_,param1.data["target"]));
                  send({
                     "command":MonsterDebuggerConstants.COMMAND_GET_FUNCTIONS,
                     "xml":_loc3_
                  });
               }
               break;
            case MonsterDebuggerConstants.COMMAND_SET_PROPERTY:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],1);
               if(_loc2_ != null)
               {
                  try
                  {
                     _loc2_[param1.data["name"]] = param1.data["value"];
                     send({
                        "command":MonsterDebuggerConstants.COMMAND_SET_PROPERTY,
                        "target":param1.data["target"],
                        "value":_loc2_[param1.data["name"]]
                     });
                  }
                  catch(e1:Error)
                  {
                  }
               }
               break;
            case MonsterDebuggerConstants.COMMAND_GET_PREVIEW:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc2_ != null && MonsterDebuggerUtils.isDisplayObject(_loc2_))
               {
                  _loc5_ = _loc2_ as DisplayObject;
                  _loc6_ = MonsterDebuggerUtils.snapshot(_loc5_,new Rectangle(0,0,300,300));
                  if(_loc6_ != null)
                  {
                     _loc7_ = _loc6_.getPixels(new Rectangle(0,0,_loc6_.width,_loc6_.height));
                     send({
                        "command":MonsterDebuggerConstants.COMMAND_GET_PREVIEW,
                        "bytes":_loc7_,
                        "width":_loc6_.width,
                        "height":_loc6_.height
                     });
                  }
               }
               break;
            case MonsterDebuggerConstants.COMMAND_CALL_METHOD:
               _loc4_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc4_ != null && _loc4_ is Function)
               {
                  if(param1.data["returnType"] == MonsterDebuggerConstants.TYPE_VOID)
                  {
                     _loc4_.apply(null,param1.data["arguments"]);
                  }
                  else
                  {
                     try
                     {
                        _loc2_ = _loc4_.apply(null,param1.data["arguments"]);
                        _loc3_ = XML(MonsterDebuggerUtils.parse(_loc2_,"",1,5,false));
                        send({
                           "command":MonsterDebuggerConstants.COMMAND_CALL_METHOD,
                           "id":param1.data["id"],
                           "xml":_loc3_
                        });
                     }
                     catch(e2:Error)
                     {
                     }
                  }
               }
               break;
            case MonsterDebuggerConstants.COMMAND_PAUSE:
               MonsterDebuggerUtils.pause();
               send({"command":MonsterDebuggerConstants.COMMAND_PAUSE});
               break;
            case MonsterDebuggerConstants.COMMAND_RESUME:
               MonsterDebuggerUtils.resume();
               send({"command":MonsterDebuggerConstants.COMMAND_RESUME});
               break;
            case MonsterDebuggerConstants.COMMAND_HIGHLIGHT:
               _loc2_ = MonsterDebuggerUtils.getObject(_base,param1.data["target"],0);
               if(_loc2_ != null && MonsterDebuggerUtils.isDisplayObject(_loc2_))
               {
                  if(DisplayObject(_loc2_).stage != null && DisplayObject(_loc2_).stage is Stage)
                  {
                     _stage = _loc2_["stage"];
                  }
                  if(_stage != null)
                  {
                     highlightClear();
                     send({"command":MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT});
                     _highlight.removeEventListener(MouseEvent.CLICK,highlightClicked);
                     _highlight.mouseEnabled = false;
                     _highlightTarget = DisplayObject(_loc2_);
                     _highlightMouse = false;
                     _highlightUpdate = true;
                  }
               }
               break;
            case MonsterDebuggerConstants.COMMAND_START_HIGHLIGHT:
               highlightClear();
               _highlight.addEventListener(MouseEvent.CLICK,highlightClicked,false,0,true);
               _highlight.mouseEnabled = true;
               _highlightTarget = null;
               _highlightMouse = true;
               _highlightUpdate = true;
               send({"command":MonsterDebuggerConstants.COMMAND_START_HIGHLIGHT});
               break;
            case MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT:
               highlightClear();
               _highlight.removeEventListener(MouseEvent.CLICK,highlightClicked);
               _highlight.mouseEnabled = false;
               _highlightTarget = null;
               _highlightMouse = false;
               _highlightUpdate = false;
               send({"command":MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT});
         }
      }
      
      private static function monitorTimerCallback(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         if(MonsterDebugger.enabled)
         {
            _loc2_ = new Date().time;
            _loc3_ = _loc2_ - _monitorTime;
            _loc4_ = _monitorFrames / _loc3_ * 1000;
            _loc5_ = 0;
            if(_stage == null)
            {
               if(_base.hasOwnProperty("stage") && _base["stage"] != null && _base["stage"] is Stage)
               {
                  _stage = Stage(_base["stage"]);
               }
            }
            if(_stage != null)
            {
               _loc5_ = _stage.frameRate;
            }
            _monitorFrames = 0;
            _monitorTime = _loc2_;
            if(MonsterDebuggerConnection.connected)
            {
               _loc6_ = {
                  "command":MonsterDebuggerConstants.COMMAND_MONITOR,
                  "memory":MonsterDebuggerUtils.getMemory(),
                  "fps":_loc4_,
                  "fpsMovie":_loc5_,
                  "time":_loc2_
               };
               send(_loc6_);
            }
         }
      }
      
      private static function frameHandler(param1:Event) : void
      {
         if(MonsterDebugger.enabled)
         {
            ++_monitorFrames;
            if(_highlightUpdate)
            {
               highlightUpdate();
            }
         }
      }
      
      private static function highlightClicked(param1:MouseEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         highlightClear();
         _highlightTarget = MonsterDebuggerUtils.getObjectUnderPoint(_stage,new Point(_stage.mouseX,_stage.mouseY));
         _highlightMouse = false;
         _highlight.removeEventListener(MouseEvent.CLICK,highlightClicked);
         _highlight.mouseEnabled = false;
         if(_highlightTarget != null)
         {
            inspect(_highlightTarget);
            highlightDraw(false);
         }
         send({"command":MonsterDebuggerConstants.COMMAND_STOP_HIGHLIGHT});
      }
      
      private static function highlightUpdate() : void
      {
         var _loc1_:* = undefined;
         if(!_enabled)
         {
            return;
         }
         highlightClear();
         if(_highlightMouse)
         {
            if(_base.hasOwnProperty("stage") && _base["stage"] != null && _base["stage"] is Stage)
            {
               _stage = _base["stage"] as Stage;
            }
            if(Capabilities.playerType == "Desktop")
            {
               _loc1_ = getDefinitionByName("flash.desktop::NativeApplication");
               if(_loc1_ != null && _loc1_["nativeApplication"]["activeWindow"] != null)
               {
                  _stage = _loc1_["nativeApplication"]["activeWindow"]["stage"];
               }
            }
            if(_stage == null)
            {
               _highlight.removeEventListener(MouseEvent.CLICK,highlightClicked);
               _highlight.mouseEnabled = false;
               _highlightTarget = null;
               _highlightMouse = false;
               _highlightUpdate = false;
               return;
            }
            _highlightTarget = MonsterDebuggerUtils.getObjectUnderPoint(_stage,new Point(_stage.mouseX,_stage.mouseY));
            if(_highlightTarget != null)
            {
               highlightDraw(true);
            }
            return;
         }
         if(_highlightTarget != null)
         {
            if(_highlightTarget.stage == null || _highlightTarget.parent == null)
            {
               _highlight.removeEventListener(MouseEvent.CLICK,highlightClicked);
               _highlight.mouseEnabled = false;
               _highlightTarget = null;
               _highlightMouse = false;
               _highlightUpdate = false;
               return;
            }
            highlightDraw(false);
         }
      }
      
      private static function highlightDraw(param1:Boolean) : void
      {
         if(!_enabled)
         {
            return;
         }
         if(_highlightTarget == null)
         {
            return;
         }
         var _loc2_:Rectangle = _highlightTarget.getBounds(_stage);
         if(_highlightTarget is Stage)
         {
            _loc2_.x = 0;
            _loc2_.y = 0;
            _loc2_.width = _highlightTarget["stageWidth"];
            _loc2_.height = _highlightTarget["stageHeight"];
         }
         else
         {
            _loc2_.x = int(_loc2_.x + 0.5);
            _loc2_.y = int(_loc2_.y + 0.5);
            _loc2_.width = int(_loc2_.width + 0.5);
            _loc2_.height = int(_loc2_.height + 0.5);
         }
         var _loc3_:Rectangle = _loc2_.clone();
         _loc3_.x += 2;
         _loc3_.y += 2;
         _loc3_.width -= 4;
         _loc3_.height -= 4;
         if(_loc3_.width < 0)
         {
            _loc3_.width = 0;
         }
         if(_loc3_.height < 0)
         {
            _loc3_.height = 0;
         }
         _highlight.graphics.clear();
         _highlight.graphics.beginFill(HIGHLITE_COLOR,1);
         _highlight.graphics.drawRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
         _highlight.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         if(param1)
         {
            _highlight.graphics.beginFill(HIGHLITE_COLOR,0.25);
            _highlight.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         }
         if(_highlightTarget.name != null)
         {
            _highlightInfo.text = String(_highlightTarget.name) + " - " + String(MonsterDebuggerDescribeType.get(_highlightTarget).@name);
         }
         else
         {
            _highlightInfo.text = String(MonsterDebuggerDescribeType.get(_highlightTarget).@name);
         }
         var _loc4_:Rectangle = new Rectangle(_loc2_.x,_loc2_.y - (_highlightInfo.textHeight + 3),_highlightInfo.textWidth + 15,_highlightInfo.textHeight + 5);
         if(_loc4_.y < 0)
         {
            _loc4_.y = _loc2_.y + _loc2_.height;
         }
         if(_loc4_.y + _loc4_.height > _stage.stageHeight)
         {
            _loc4_.y = _stage.stageHeight - _loc4_.height;
         }
         if(_loc4_.x < 0)
         {
            _loc4_.x = 0;
         }
         if(_loc4_.x + _loc4_.width > _stage.stageWidth)
         {
            _loc4_.x = _stage.stageWidth - _loc4_.width;
         }
         _highlight.graphics.beginFill(HIGHLITE_COLOR,1);
         _highlight.graphics.drawRect(_loc4_.x,_loc4_.y,_loc4_.width,_loc4_.height);
         _highlight.graphics.endFill();
         _highlightInfo.x = _loc4_.x;
         _highlightInfo.y = _loc4_.y;
         try
         {
            _stage.addChild(_highlight);
            _stage.addChild(_highlightInfo);
         }
         catch(e:Error)
         {
         }
      }
      
      private static function highlightClear() : void
      {
         if(_highlight != null && _highlight.parent != null)
         {
            _highlight.parent.removeChild(_highlight);
            _highlight.graphics.clear();
            _highlight.x = 0;
            _highlight.y = 0;
         }
         if(_highlightInfo != null && _highlightInfo.parent != null)
         {
            _highlightInfo.parent.removeChild(_highlightInfo);
            _highlightInfo.x = 0;
            _highlightInfo.y = 0;
         }
      }
      
      private static function send(param1:Object, param2:Boolean = false) : void
      {
         if(MonsterDebugger.enabled)
         {
            MonsterDebuggerConnection.send(MonsterDebuggerCore.ID,param1,param2);
         }
      }
      
      public static function setEnabled(param1:Boolean) : void
      {
         _enabled = param1;
         if(_enabled)
         {
            try
            {
               _stage.addChild(_highlight);
               _stage.addChild(_highlightInfo);
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            if(Boolean(_highlight.parent))
            {
               _highlight.parent.removeChild(_highlight);
            }
            if(Boolean(_highlightInfo.parent))
            {
               _highlightInfo.parent.removeChild(_highlightInfo);
            }
         }
      }
   }
}

