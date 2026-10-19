package groupPurchase
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import groupPurchase.data.GroupPurchaseAwardAnalyzer;
   import groupPurchase.view.GroupPurchaseMainView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   
   public class GroupPurchaseManager extends EventDispatcher
   {
      
      private static var _instance:GroupPurchaseManager;
      
      public static const REFRESH_DATA:String = "GROUP_PURCHASE_REFRESH_DATA";
      
      public static const REFRESH_RANK_DATA:String = "GROUP_PURCHASE_REFRESH_RANK_DATA";
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _awardInfoList:Object;
      
      private var _isOpen:Boolean = false;
      
      private var _curTotalNum:int;
      
      private var _curMyNum:int;
      
      private var _itemId:int;
      
      private var _price:int;
      
      private var _isUseMoney:Boolean;
      
      private var _isUseBandMoney:Boolean;
      
      private var _endTime:Date;
      
      private var _discountList:Array;
      
      private var _miniNeedNum:int;
      
      private var _rankList:Array;
      
      public function GroupPurchaseManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : GroupPurchaseManager
      {
         if(_instance == null)
         {
            _instance = new GroupPurchaseManager();
         }
         return _instance;
      }
      
      public function get awardInfoList() : Object
      {
         return this._awardInfoList;
      }
      
      public function get itemId() : int
      {
         return this._itemId;
      }
      
      public function get price() : int
      {
         return this._price;
      }
      
      public function get isUseMoney() : Boolean
      {
         return this._isUseMoney;
      }
      
      public function get isUseBandMoney() : Boolean
      {
         return this._isUseBandMoney;
      }
      
      public function get endTime() : Date
      {
         return this._endTime;
      }
      
      public function get miniNeedNum() : int
      {
         return this._miniNeedNum;
      }
      
      public function get rankList() : Array
      {
         return this._rankList;
      }
      
      public function get viewData() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = [];
         var _loc6_:int = int(this._discountList.length);
         var _loc7_:int = _loc6_ - 1;
         while(_loc7_ >= 0)
         {
            if(this._curTotalNum >= this._discountList[_loc7_][0])
            {
               _loc1_ = _loc7_;
               break;
            }
            _loc7_--;
         }
         var _loc8_:int = int(this._discountList[_loc1_][1]);
         if(_loc1_ == this._discountList.length - 1)
         {
            _loc2_ = -1;
            _loc3_ = -1;
         }
         else
         {
            _loc2_ = int(this._discountList[_loc1_ + 1][1]);
            _loc3_ = int(this._discountList[_loc1_ + 1][0]);
         }
         var _loc9_:int = this._curMyNum * this._price * _loc8_ / 100;
         if(_loc2_ == -1)
         {
            _loc4_ = this._curMyNum * this._price * _loc8_ / 100;
         }
         else
         {
            _loc4_ = this._curMyNum * this._price * _loc2_ / 100;
         }
         _loc5_.push(_loc8_);
         _loc5_.push(_loc2_);
         _loc5_.push(_loc3_);
         _loc5_.push(this._curTotalNum);
         _loc5_.push(this._curMyNum);
         _loc5_.push(_loc9_);
         _loc5_.push(_loc4_);
         return _loc5_;
      }
      
      public function awardAnalyComplete(param1:GroupPurchaseAwardAnalyzer) : void
      {
         this._awardInfoList = param1.awardList;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GROUP_PURCHASE,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case GroupPurchasePackageType.START_OR_END:
               this.openOrClose(_loc2_);
               break;
            case GroupPurchasePackageType.REFRESH_DATA:
               this.refreshPurchaseData(_loc2_);
               break;
            case GroupPurchasePackageType.REFRESH_RANK_DATA:
               this.refreshRankData(_loc2_);
         }
      }
      
      private function refreshRankData(param1:PackageIn) : void
      {
         var _loc2_:Object = null;
         this._rankList = [];
         var _loc3_:int = param1.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = {};
            _loc2_["rank"] = _loc4_ + 1;
            _loc2_["name"] = param1.readUTF();
            _loc2_["num"] = param1.readInt();
            this._rankList.push(_loc2_);
            _loc4_++;
         }
         dispatchEvent(new Event(REFRESH_RANK_DATA));
      }
      
      private function refreshPurchaseData(param1:PackageIn) : void
      {
         this._curMyNum = param1.readInt();
         this._curTotalNum = param1.readInt();
         dispatchEvent(new Event(REFRESH_DATA));
      }
      
      private function openOrClose(param1:PackageIn) : void
      {
         var _loc2_:BaseLoader = null;
         this._isOpen = param1.readBoolean();
         if(this._isOpen)
         {
            this._itemId = param1.readInt();
            this._price = param1.readInt();
            this._isUseMoney = param1.readBoolean();
            this._isUseBandMoney = param1.readBoolean();
            this._endTime = param1.readDate();
            this.analyDiscountInfo(param1.readUTF());
            this._miniNeedNum = param1.readInt();
            _loc2_ = StartupResourceLoader.Instance.createGroupPurchaseAwardInfoLoader();
            _loc2_.addEventListener(LoaderEvent.COMPLETE,this.loadAwardInfoComplete);
            LoadResourceManager.Instance.startLoad(_loc2_);
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.GROUPPURCHASE,false);
         }
      }
      
      private function analyDiscountInfo(param1:String) : void
      {
         var _loc2_:Array = param1.split("|");
         this._discountList = [];
         this._discountList.push([0,0]);
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._discountList.push(_loc2_[_loc4_].split(","));
            _loc4_++;
         }
      }
      
      private function loadAwardInfoComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.loader as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.loadAwardInfoComplete);
         if(this._isOpen)
         {
            this.showIcon();
         }
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.GROUPPURCHASE,true);
      }
      
      public function showFrame() : void
      {
         SoundManager.instance.play("008");
         var _loc1_:GroupPurchaseMainView = new GroupPurchaseMainView();
         _loc1_.init();
         HallIconManager.instance.showCommonFrame(_loc1_,"wonderfulActivityManager.btnTxt9");
         _loc1_.x = 18;
         _loc1_.y = 106;
      }
      
      public function loadResModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GROUP_PURCHASE);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GROUP_PURCHASE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GROUP_PURCHASE)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
   }
}

