package vipIntegralShop
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.VipIntegralShopManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import vipIntegralShop.data.VipIntegralShopDataAnalyzer;
   import vipIntegralShop.data.VipIntegralShopInfo;
   import vipIntegralShop.view.VipIntegralShopView;
   
   public class VipIntegralShopController extends EventDispatcher
   {
      
      private static var _instance:VipIntegralShopController;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _integralShopView:VipIntegralShopView;
      
      private var _goodsInfoList:Vector.<VipIntegralShopInfo>;
      
      private var _limitDic:Dictionary;
      
      public function VipIntegralShopController()
      {
         super();
      }
      
      public static function get instance() : VipIntegralShopController
      {
         if(!_instance)
         {
            _instance = new VipIntegralShopController();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         VipIntegralShopManager.Instance.addEventListener("vipintgralOpenView",this.__onOpenView);
      }
      
      protected function __onUpdateShopView(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = param1.pkg;
         var _loc4_:int = _loc3_.readInt();
         if(_loc4_ > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               this.limitDic[_loc3_.readInt()] = _loc3_.readInt();
               _loc2_++;
            }
         }
         this._integralShopView.refreshView();
      }
      
      private function __onOpenView(param1:Event) : void
      {
         this.initData();
      }
      
      private function initData() : void
      {
         this._limitDic = new Dictionary();
         var _loc1_:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solveRequestPath("VipStoreList.xml"),5);
         _loc1_.analyzer = new VipIntegralShopDataAnalyzer(this.getGoodsInfoList);
         _loc1_.addEventListener("complete",this.__onComplete);
         LoadResourceManager.Instance.startLoad(_loc1_);
      }
      
      protected function __onComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener("complete",this.__onComplete);
         this.show();
      }
      
      private function getGoodsInfoList(param1:VipIntegralShopDataAnalyzer) : void
      {
         this._goodsInfoList = param1.shopInfoVec;
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showIntegralShopFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIPINTEGRAL_SHOP);
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIPINTEGRAL_SHOP)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function hide() : void
      {
         if(this._integralShopView != null)
         {
            this._integralShopView.dispose();
         }
         this._integralShopView = null;
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.VIPINTEGRALSHOP_UPDATE,this.__onUpdateShopView);
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIPINTEGRAL_SHOP)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function showIntegralShopFrame() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIPINTEGRALSHOP_UPDATE,this.__onUpdateShopView);
         this._integralShopView = ComponentFactory.Instance.creatComponentByStylename("vipIntegralshop.vipIntegralShopView");
         LayerManager.Instance.addToLayer(this._integralShopView,3,true,2);
      }
      
      public function get goodsInfoList() : Vector.<VipIntegralShopInfo>
      {
         return this._goodsInfoList;
      }
      
      public function get limitDic() : Dictionary
      {
         return this._limitDic;
      }
   }
}

