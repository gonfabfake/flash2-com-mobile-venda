package halloween
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import halloween.analyze.HalloweenDataAnalyzer;
   import halloween.analyze.HalloweenRankDataAnalyzer;
   import halloween.data.HalloweenType;
   import halloween.info.HalloweenMainInfo;
   import halloween.info.HalloweenRankInfo;
   import road7th.comm.PackageIn;
   
   public class HalloweenManager extends EventDispatcher
   {
      
      private static var _instance:HalloweenManager = null;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      public var prizeArr:Array = new Array();
      
      public var rankArr:Vector.<HalloweenRankInfo> = new Vector.<HalloweenRankInfo>();
      
      public var mainViewData:HalloweenMainInfo = new HalloweenMainInfo();
      
      private var _frameView:HalloweenView;
      
      public function HalloweenManager()
      {
         super();
      }
      
      public static function get instance() : HalloweenManager
      {
         if(_instance == null)
         {
            _instance = new HalloweenManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      public function templateDataSetup(param1:DataAnalyzer) : void
      {
         if(param1 is HalloweenDataAnalyzer)
         {
            this.prizeArr = HalloweenDataAnalyzer(param1).dataList;
         }
      }
      
      public function rankDataSetup(param1:DataAnalyzer) : void
      {
         if(param1 is HalloweenRankDataAnalyzer)
         {
            this.rankArr = HalloweenRankDataAnalyzer(param1).dataList;
            if(Boolean(this._frameView))
            {
               this._frameView.dataLoad();
            }
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HALLOWEEN,this.openHandler);
      }
      
      public function showHideIcon(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.HALLOWEEN,param1);
         if(this.prizeArr.length <= 0 && param1)
         {
            this.createHalloweenLoader();
         }
      }
      
      private function openHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case HalloweenType.OPEN:
               this.showHideIcon(_loc2_.readBoolean());
               break;
            case HalloweenType.ENTER:
               this.mainViewData.mycard = _loc2_.readInt();
               this.mainViewData.myrank = _loc2_.readInt();
               this.mainViewData.refreshTime = _loc2_.readDate();
               this.show();
         }
      }
      
      private function show() : void
      {
         if(loadComplete)
         {
            this.showFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.HALLOWEEN);
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.HALLOWEEN)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.HALLOWEEN)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.showFrame();
         }
      }
      
      public function hide() : void
      {
         if(this._frameView != null)
         {
            this._frameView.dispose();
         }
         this._frameView = null;
      }
      
      private function showFrame() : void
      {
         if(this._frameView == null)
         {
            this._frameView = ComponentFactory.Instance.creatComponentByStylename("asset.halloween.HalloweenView");
            this._frameView.show();
         }
         this._frameView.mainViewDataload();
         this._loadXml("ActivityHalloweenRank.ashx?ran=" + Math.random(),BaseLoader.REQUEST_LOADER);
      }
      
      private function _loadXml(param1:String, param2:int, param3:String = "") : void
      {
         var _loc4_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath(param1),param2);
         _loc4_.loadErrorMessage = param3;
         _loc4_.analyzer = new HalloweenRankDataAnalyzer(this.rankDataSetup);
         LoadResourceManager.Instance.startLoad(_loc4_);
      }
      
      private function createHalloweenLoader() : void
      {
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("ActivityHalloweenItems.xml"),BaseLoader.COMPRESS_TEXT_LOADER);
         _loc1_.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.halloweenPrizeInfoFail");
         _loc1_.analyzer = new HalloweenDataAnalyzer(HalloweenManager.instance.templateDataSetup);
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
   }
}

