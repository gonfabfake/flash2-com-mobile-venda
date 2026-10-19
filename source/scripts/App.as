package
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.QueueLoader;
   import com.pickgliss.utils.StringUtils;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import morn.core.managers.AssetManager;
   import morn.core.managers.DialogManager;
   import morn.core.managers.DragManager;
   import morn.core.managers.LangManager;
   import morn.core.managers.LogManager;
   import morn.core.managers.RenderManager;
   import morn.core.managers.TimerManager;
   import morn.editor.Builder;
   
   public class App
   {
      
      public static var stage:Stage;
      
      private static var _loadUICall:Function;
      
      public static var asset:AssetManager = new AssetManager();
      
      public static var timer:TimerManager = new TimerManager();
      
      public static var render:RenderManager = new RenderManager();
      
      public static var dialog:DialogManager = new DialogManager();
      
      public static var log:LogManager = new LogManager();
      
      public static var drag:DragManager = new DragManager();
      
      public static var lang:LangManager = new LangManager();
      
      public function App()
      {
         super();
      }
      
      public static function init(param1:Stage, param2:ApplicationDomain = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         stage = param1;
         stage.frameRate = Config.GAME_FPS;
         stage.scaleMode = "exactFit";
         stage.align = "TL";
         stage.stageFocusRect = false;
         stage.tabChildren = false;
         asset.setDomain(param2);
         _loc3_ = stage.loaderInfo.parameters;
         if(_loc3_ != null)
         {
            for(_loc4_ in _loc3_)
            {
               if(Config[_loc4_] != null)
               {
                  Config[_loc4_] = _loc3_[_loc4_];
               }
            }
         }
         stage.addChild(dialog);
         stage.addChild(log);
         stage.doubleClickEnabled = true;
      }
      
      public static function loadUI(param1:String, param2:Function = null) : void
      {
         XML.ignoreWhitespace = true;
         _loadUICall = param2;
         var _loc3_:BaseLoader = LoadResourceManager.Instance.createLoader(param1,3);
         _loc3_.addEventListener("complete",__onLoadUIComplete);
         _loc3_.addEventListener("loadError",__onLoadUIError);
         LoadResourceManager.Instance.startLoad(_loc3_);
      }
      
      public static function loadAssets(param1:Array, param2:Function) : void
      {
         var i:int;
         var complete:Function = null;
         var onLoadComplete:* = undefined;
         var queryLoader:QueueLoader = null;
         var url:String = null;
         var suffix:String = null;
         var base:BaseLoader = null;
         var urls:Array = param1;
         complete = param2;
         onLoadComplete = function(param1:Event):void
         {
            queryLoader.removeEventListener("complete",onLoadComplete);
            queryLoader.dispose();
            if(complete != null)
            {
               complete();
            }
         };
         XML.ignoreWhitespace = true;
         queryLoader = new QueueLoader();
         i = 0;
         while(i < urls.length)
         {
            url = urls[i];
            suffix = StringUtils.getSuffixStr(url);
            if(suffix == "ui")
            {
               base = LoadResourceManager.Instance.createLoader(url,8);
               base.addEventListener("complete",__onLoadUIComplete);
               base.addEventListener("loadError",__onLoadUIError);
            }
            else if(suffix == "swf")
            {
               base = LoadResourceManager.Instance.createLoader(url,4);
            }
            else if(suffix == "xml")
            {
               base = LoadResourceManager.Instance.createLoader(url,2);
               base.addEventListener("complete",__onLoadXMLComplete);
               base.addEventListener("loadError",__onLoadXMLError);
            }
            queryLoader.addLoader(base);
            i++;
         }
         queryLoader.addEventListener("complete",onLoadComplete);
         queryLoader.start();
      }
      
      private static function __onLoadUIComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",__onLoadUIComplete);
         param1.loader.removeEventListener("loadError",__onLoadUIError);
         if(_loadUICall != null)
         {
            _loadUICall();
         }
         _loadUICall = null;
      }
      
      private static function __onLoadUIError(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",__onLoadUIComplete);
         param1.loader.removeEventListener("loadError",__onLoadUIError);
         _loadUICall = null;
      }
      
      private static function __onLoadXMLComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",__onLoadXMLComplete);
         param1.loader.removeEventListener("loadError",__onLoadXMLError);
         Builder.callBack(param1.loader.content);
      }
      
      private static function __onLoadXMLError(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",__onLoadXMLComplete);
         param1.loader.removeEventListener("loadError",__onLoadXMLError);
      }
      
      public static function getResPath(param1:String) : String
      {
         return /^http:\/\//g.test(param1) ? param1 : Config.resPath + param1;
      }
   }
}

