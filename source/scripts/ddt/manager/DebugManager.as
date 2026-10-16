package ddt.manager
{
   import com.pickgliss.toplevel.StageReferance;
   import ddt.data.DebugCommand;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.utils.getDefinitionByName;
   
   public class DebugManager
   {
      
      private static var _ins:DebugManager;
      
      private static const USER:String = "admin";
      
      private static const PWD:String = "ddt";
      
      private var _user:String;
      
      private var _pwd:String;
      
      private var _address:String = "127.0.0.1";
      
      private var _port:String = "5800";
      
      private var _started:Boolean = false;
      
      private var _loadedMonster:Boolean = false;
      
      private var _loader:Loader;
      
      public function DebugManager()
      {
         super();
         if(Capabilities.isDebugger)
         {
            this.loadMonster();
            this.startup("#debug-startup -u admin -p ddt -host 127.0.0.1 -P 5800");
         }
      }
      
      public static function getInstance() : DebugManager
      {
         if(_ins == null)
         {
            _ins = new DebugManager();
         }
         return _ins;
      }
      
      public function get enabled() : Boolean
      {
         return this._started && this._loadedMonster;
      }
      
      public function loadMonster() : void
      {
         if(!this._loadedMonster)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.__monsterComplete);
            this._loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.__progress);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
            this._loader.load(new URLRequest(PathManager.getMonsterPath()),new LoaderContext(false,ApplicationDomain.currentDomain));
         }
      }
      
      private function __progress(param1:ProgressEvent) : void
      {
         var _loc2_:int = param1.bytesLoaded / param1.bytesTotal * 100;
      }
      
      private function __ioError(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
      }
      
      protected function __monsterComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.__monsterComplete);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.__progress);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.__ioError);
         this._loadedMonster = true;
      }
      
      public function startup(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Class = null;
         var _loc6_:String = param1;
         if(!this._started)
         {
            _loc2_ = _loc6_.split(" -");
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_.split(" ");
               switch(_loc4_[0])
               {
                  case "u":
                     this._user = _loc4_[1];
                     break;
                  case "p":
                     this._pwd = _loc4_[1];
                     break;
                  case "host":
                     this._address = _loc4_[1];
                     break;
                  case "P":
                     this._port = _loc4_[1];
               }
            }
            try
            {
               if(this._user != USER || this._pwd != PWD)
               {
                  return;
               }
               _loc5_ = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               if(!_loc5_["initialized"])
               {
                  _loc5_["initialize"](StageReferance.stage);
               }
               _loc5_["startup"](this._address,this._port,this.onDebuggerConnect);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      private function onDebuggerConnect() : void
      {
         this._started = true;
      }
      
      public function shutdown() : void
      {
         var monsterRef:Class = null;
         if(this._started)
         {
            try
            {
               monsterRef = getDefinitionByName("com.demonsters.debugger::MonsterDebugger") as Class;
               monsterRef["shutdown"]();
               ChatManager.Instance.sysChatYellow("Monster Closed.");
               this._started = false;
            }
            catch(e:Error)
            {
               ChatManager.Instance.sysChatYellow(e.toString());
            }
         }
      }
      
      public function handle(param1:String) : void
      {
         var _loc2_:String = null;
         if(!this._started)
         {
            if(param1.split(" ")[0] == "#loadmonster")
            {
               this.loadMonster();
            }
            else if(param1.split(" ")[0] == "#debug-startup" && this._loadedMonster)
            {
               this.startup(param1);
            }
            else if(param1.split(" ")[0] == "#info")
            {
               this.info();
            }
         }
         else if(this._loadedMonster)
         {
            _loc2_ = String(param1.split(" ")[0]).replace("#","");
            switch(_loc2_)
            {
               case DebugCommand.Shutdown:
                  this.shutdown();
            }
         }
      }
      
      private function info() : void
      {
         var _loc1_:String = "info:\n";
         var _loc2_:String = Capabilities.playerType;
         var _loc3_:String = Capabilities.version;
         var _loc4_:Boolean = Capabilities.isDebugger;
         _loc1_ += "PlayerType:" + _loc2_;
         _loc1_ += "\nPlayerVersion:" + _loc3_;
         _loc1_ += "\nisDebugger:" + _loc4_;
         if(_loc2_ == "Desktop")
         {
            _loc1_ += "\ncpuArchitecture:" + Capabilities.cpuArchitecture;
         }
         _loc1_ += "\nhasIME:" + Capabilities.hasIME;
         _loc1_ += "\nlanguage:" + Capabilities.language;
         _loc1_ += "\nos:" + Capabilities.os;
         _loc1_ += "\nscreenResolutionX:" + Capabilities.screenResolutionX;
         _loc1_ += "\nscreenResolutionY:" + Capabilities.screenResolutionY;
         ChatManager.Instance.sysChatYellow(_loc1_);
      }
   }
}

