package homeTemple
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import homeTemple.data.HomeTempleData;
   import homeTemple.data.HomeTempleDataAnalyzer;
   import homeTemple.data.HomeTempleModel;
   import homeTemple.event.HomeTempleEvent;
   import homeTemple.view.HomeTempleFrame;
   import road7th.comm.PackageIn;
   
   public class HomeTempleController extends EventDispatcher
   {
      
      private static var _instance:HomeTempleController;
      
      public static var MAXLEVEL:int = 0;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _templeFrame:HomeTempleFrame;
      
      private var _practiceList:Dictionary;
      
      private var _currentInfo:HomeTempleData;
      
      private var _manager:HomeTempleManager;
      
      public function HomeTempleController(param1:IEventDispatcher = null)
      {
         super(param1);
         this._currentInfo = new HomeTempleData();
      }
      
      public static function get Instance() : HomeTempleController
      {
         if(!_instance)
         {
            _instance = new HomeTempleController();
         }
         return _instance;
      }
      
      public function get practiceList() : Dictionary
      {
         return this._practiceList;
      }
      
      public function setup() : void
      {
         this._manager = HomeTempleManager.getInstance();
         this._manager.addEventListener("ht_show",this.onShowEventHandler);
         this._manager.addEventListener("ht_hide",this.onHideEventHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOMETEMPLE_GETLEVEL,this.__onGetTempleLevel);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOMETEMPLE_IMMOLATION,this.__onImmolationResponse);
      }
      
      protected function onHideEventHandler(param1:CEvent) : void
      {
         this.hide();
      }
      
      protected function onShowEventHandler(param1:CEvent) : void
      {
         this.onShow();
      }
      
      protected function __onGetTempleLevel(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._currentInfo.CurrentSelectIndex = _loc2_.readInt();
         this._currentInfo.CurrentLevel = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         this._currentInfo.CurrentExp = _loc3_ - (this._currentInfo.CurrentLevel > 0 ? this._practiceList[this._currentInfo.CurrentLevel].Exp : 0);
         if(this._templeFrame == null)
         {
            this._templeFrame = ComponentFactory.Instance.creatComponentByStylename("home.HomeTempleFrame");
            this._manager.setView(this._templeFrame);
         }
      }
      
      protected function __onImmolationResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._currentInfo.CurrentLevel = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         this._currentInfo.CurrentExp = _loc3_ - (this._currentInfo.CurrentLevel > 0 ? this._practiceList[this._currentInfo.CurrentLevel].Exp : 0);
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         dispatchEvent(new HomeTempleEvent("homeTempleUpdateProperty",[_loc5_,_loc4_]));
         this._templeFrame.resetBlessingPos();
      }
      
      private function showTempleFrame() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._practiceList))
         {
            SocketManager.Instance.out.getHomeTempleLevel();
         }
         else
         {
            _loc1_ = this.getHomeTempleList();
            LoadResourceManager.Instance.startLoad(_loc1_);
         }
      }
      
      public function getExpPercent() : String
      {
         var _loc1_:int = this._currentInfo.CurrentLevel + 1;
         _loc1_ = _loc1_ > MAXLEVEL ? MAXLEVEL : int(_loc1_);
         var _loc2_:Number = this._currentInfo.CurrentExp / (this._practiceList[_loc1_].Exp - this._practiceList[_loc1_ - 1].Exp) * 100;
         return _loc2_.toFixed(2);
      }
      
      public function getPracticeByLevel(param1:int) : HomeTempleModel
      {
         param1 = param1 > MAXLEVEL ? MAXLEVEL : int(param1);
         return this._practiceList[param1];
      }
      
      public function getStarNum() : int
      {
         var _loc1_:int = HomeTempleController.Instance.currentInfo.CurrentLevel;
         var _loc2_:int = 1;
         if(_loc1_ % 10 == 0)
         {
            if(_loc1_ > 0)
            {
               _loc2_ = _loc1_ / 10;
            }
         }
         else
         {
            _loc2_ = _loc1_ / 10 + 1;
         }
         return _loc2_;
      }
      
      public function getStarLevelNum() : int
      {
         var _loc1_:int = HomeTempleController.Instance.currentInfo.CurrentLevel;
         if(_loc1_ > 0)
         {
            _loc1_ %= 10;
            _loc1_ = _loc1_ == 0 ? 10 : _loc1_;
         }
         return _loc1_;
      }
      
      public function getPropertyInfoByIndex(param1:int) : HomeTempleModel
      {
         param1 = param1 == 0 ? 1 : param1;
         return this._practiceList[param1 * 10];
      }
      
      public function getHomeTempleList2() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("HomeTempPracticeList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingHomeTempleListFailure");
         _loc1_.analyzer = new HomeTempleDataAnalyzer(this.getPracticeList2);
         _loc1_.addEventListener("loadError",this.__onLoadError);
         return _loc1_;
      }
      
      private function getPracticeList2(param1:HomeTempleDataAnalyzer) : void
      {
         this._practiceList = param1.list;
      }
      
      private function getHomeTempleList() : BaseLoader
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("HomeTempPracticeList.xml"),5);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingHomeTempleListFailure");
         _loc1_.analyzer = new HomeTempleDataAnalyzer(this.getPracticeList);
         _loc1_.addEventListener("loadError",this.__onLoadError);
         return _loc1_;
      }
      
      private function getPracticeList(param1:HomeTempleDataAnalyzer) : void
      {
         this._practiceList = param1.list;
         this.showTempleFrame();
      }
      
      public function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:String = param1.loader.loadErrorMessage;
         if(Boolean(param1.loader.analyzer))
         {
            if(param1.loader.analyzer.message != null)
            {
               _loc2_ = param1.loader.loadErrorMessage + "\n" + param1.loader.analyzer.message;
            }
         }
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
         _loc3_.addEventListener("response",this.__onAlertResponse);
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener("response",this.__onAlertResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         LeavePageManager.leaveToLoginPath();
      }
      
      public function onShow() : void
      {
         if(loadComplete)
         {
            this.showTempleFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp("homeTemple");
         }
      }
      
      public function hide() : void
      {
         if(this._templeFrame != null)
         {
            ObjectUtils.disposeObject(this._templeFrame);
         }
         this._templeFrame = null;
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "homeTemple")
         {
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.onShow();
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == "homeTemple")
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
      }
      
      public function get currentInfo() : HomeTempleData
      {
         return this._currentInfo;
      }
   }
}

