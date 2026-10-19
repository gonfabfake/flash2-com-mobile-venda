package Indiana
{
   import Indiana.analyzer.IndianaGoodsItemAnalyzer;
   import Indiana.analyzer.IndianaGoodsItemInfo;
   import Indiana.analyzer.IndianaShopItemInfo;
   import Indiana.analyzer.IndianaShopItemsAnalyzer;
   import Indiana.event.IndianaEvent;
   import Indiana.model.HistoryIndianaData;
   import Indiana.model.IndianaData;
   import Indiana.model.IndianaModel;
   import Indiana.model.IndianaShowData;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hall.IHallStateView;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import times.utils.timerManager.TimerJuggler;
   
   public class IndianaDataManager extends EventDispatcher
   {
      
      private static var _instance:IndianaDataManager;
      
      private var _model:IndianaModel;
      
      public var currentShowData:IndianaShowData;
      
      private var indianaDic:Vector.<IndianaData>;
      
      private var historyIndiana:Vector.<HistoryIndianaData>;
      
      private var beginCode:int;
      
      public var totleCount:int;
      
      private var joinCount:int;
      
      private var currentShopInfo:IndianaShopItemInfo;
      
      private var view:*;
      
      public var _showBtn:Boolean = false;
      
      private var _shopItems:Vector.<IndianaShowData>;
      
      private var _hall:IHallStateView;
      
      private var _icon:IndianaIcon;
      
      public var updataRecode:Boolean = false;
      
      private var _timer:TimerJuggler;
      
      public function IndianaDataManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this._model = new IndianaModel();
         this.indianaDic = new Vector.<IndianaData>();
         this.historyIndiana = new Vector.<HistoryIndianaData>();
         this._shopItems = new Vector.<IndianaShowData>();
      }
      
      public static function get instance() : IndianaDataManager
      {
         if(!_instance)
         {
            _instance = new IndianaDataManager();
         }
         return _instance;
      }
      
      public function get model() : IndianaModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INDIANA_ENTER_GAME,this.__enterGameHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INDIANA_CURRENT_INDIANA_INFO,this.__currentIndianaInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INDIANA_HISTORY_INDIANA_INFO,this.__historyIndianaInfoHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.INDIANA_JOIN_HISTORY,this.__joinIndianaInfoHandler);
      }
      
      public function __handlerMgr(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = int(param1.pkg.readByte());
         switch(_loc2_)
         {
            case IndianaEPackageType.ENTER_GAME:
               this.__enterGameHandler(param1);
               break;
            case IndianaEPackageType.CURRENT_INDIANA_INFO:
               this.__currentIndianaInfoHandler(param1);
               break;
            case IndianaEPackageType.HISTORY_INDIANA_INFO:
               this.__historyIndianaInfoHandler(param1);
               break;
            case IndianaEPackageType.JOIN_HISTORY:
               this.__joinIndianaInfoHandler(param1);
         }
      }
      
      public function __joinIndianaInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         this.currentShowData.state = param1.pkg.readInt();
         this.totleCount = param1.pkg.readInt();
         this.currentShowData.buyNumber = this.totleCount;
         this.beginCode = param1.pkg.readInt();
         this.joinCount = param1.pkg.readInt();
         this.currentShowData.humanFullTime = param1.pkg.readDate();
         this.currentShowData.joinCount = param1.pkg.readInt();
         this.currentShowData.luckCode = param1.pkg.readLong();
         this.currentShowData.annTime = param1.pkg.readDate();
         this.currentShowData.useId = param1.pkg.readInt();
         this.currentShowData.nickName = param1.pkg.readUTF();
         this.currentShowData.buyTimes = param1.pkg.readInt();
         this.currentShowData.areaId = param1.pkg.readInt();
         this.currentShowData.areaName = param1.pkg.readUTF();
         this.currentShowData.joinTime = param1.pkg.readDate();
         if(this.currentShowData.state != 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("Indiana.buy.hasfull"));
         }
         if(Boolean(this.view))
         {
            this.view.upData();
         }
      }
      
      private function __historyIndianaInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc5_ = int(this.historyIndiana.length);
         if(_loc5_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               this.historyIndiana[_loc3_] = null;
               _loc3_++;
            }
            this.historyIndiana.length = 0;
         }
         _loc5_ = param1.pkg.extend2;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = new HistoryIndianaData();
            _loc2_.per_Id = param1.pkg.readInt();
            _loc2_.per_name = param1.pkg.readUTF();
            _loc2_.goodsId = param1.pkg.readInt();
            _loc2_.goodsName = param1.pkg.readUTF();
            _loc2_.campaign = param1.pkg.readUTF();
            _loc2_.winningCode = param1.pkg.readLong();
            _loc2_.AnnTime = param1.pkg.readDate();
            _loc2_.useId = param1.pkg.readInt();
            _loc2_.nickName = param1.pkg.readUTF();
            _loc2_.joinCount = param1.pkg.readInt();
            _loc2_.areaId = param1.pkg.readInt();
            _loc2_.areaName = param1.pkg.readUTF();
            this.historyIndiana.push(_loc2_);
            _loc4_++;
         }
         this.historyIndiana.reverse();
         dispatchEvent(new IndianaEvent("historyiteminfo"));
      }
      
      public function get HistoryIndianaInfo() : Vector.<HistoryIndianaData>
      {
         return this.historyIndiana;
      }
      
      private function __currentIndianaInfoHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = int(this.indianaDic.length);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            this.indianaDic[_loc2_] = null;
            _loc2_++;
         }
         this.indianaDic.length = 0;
         _loc5_ = param1.pkg.readInt();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = new IndianaData();
            _loc3_.per_Id = param1.pkg.readInt();
            _loc3_.per_name = param1.pkg.readUTF();
            _loc3_.joinCount = param1.pkg.readInt();
            _loc3_.joinTime = param1.pkg.readUTF();
            _loc3_.useId = param1.pkg.readInt();
            _loc3_.nickName = param1.pkg.readUTF();
            _loc3_.areaId = param1.pkg.readInt();
            _loc3_.areaName = param1.pkg.readUTF();
            this.indianaDic.push(_loc3_);
            _loc4_++;
         }
         dispatchEvent(new IndianaEvent("recodeiteminfo"));
      }
      
      public function get currentIndianInfo() : Vector.<IndianaData>
      {
         return this.indianaDic;
      }
      
      private function __enterGameHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = param1.pkg.readInt();
         if(_loc4_ == 0)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = param1.pkg.readInt();
            this.currentShowData = this.getIndianaShowDataByPerId(_loc2_);
            if(this.currentShowData == null)
            {
               this.currentShowData = new IndianaShowData();
               this._shopItems.push(this.currentShowData);
            }
            this.currentShowData.per_id = _loc2_;
            this.currentShowData.state = param1.pkg.readInt();
            this.totleCount = this.currentShowData.buyNumber = param1.pkg.readInt();
            this.currentShowData.joinCount = param1.pkg.readInt();
            this.currentShowData.fulltime = param1.pkg.readDate();
            this.currentShowData.luckCode = param1.pkg.readLong();
            this.currentShowData.annTime = param1.pkg.readDate();
            this.currentShowData.useId = param1.pkg.readInt();
            this.currentShowData.nickName = param1.pkg.readUTF();
            this.currentShowData.buyTimes = param1.pkg.readInt();
            this.currentShowData.areaId = param1.pkg.readInt();
            this.currentShowData.areaName = param1.pkg.readUTF();
            this.currentShowData.joinTime = param1.pkg.readDate();
            this.currentShowData.humanFullTime = param1.pkg.readDate();
            _loc3_++;
         }
         if(_loc4_ > 1)
         {
            this.sortShowData();
            this.currentShowData = this._shopItems[0];
         }
         if(this.view == null)
         {
            SocketManager.Instance.out.sendUpdateSysDate();
            this.view = ComponentFactory.Instance.creatComponentByStylename("indianaMainView.Frame");
            this.view.show();
         }
         this.view.upData();
      }
      
      private function sortShowData() : void
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:int = int(this._shopItems.length);
         var _loc7_:Vector.<IndianaShowData> = this._shopItems;
         this._shopItems = new Vector.<IndianaShowData>();
         var _loc8_:Vector.<IndianaShowData> = new Vector.<IndianaShowData>();
         var _loc9_:Vector.<IndianaShowData> = new Vector.<IndianaShowData>();
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_)
         {
            if(_loc7_[_loc10_].state == IndianaModel.INDIANA_DOING)
            {
               _loc8_.push(_loc7_[_loc10_]);
            }
            else
            {
               _loc9_.push(_loc7_[_loc10_]);
            }
            _loc10_++;
         }
         _loc10_ = 0;
         _loc6_ = int(_loc8_.length);
         while(_loc10_ < _loc6_)
         {
            _loc4_ = _loc10_;
            while(_loc4_ < _loc6_)
            {
               _loc1_ = this._model.getShopItemByid(_loc8_[_loc10_].per_id);
               _loc2_ = this._model.getShopItemByid(_loc8_[_loc4_].per_id);
               if(_loc1_.Order > _loc2_.Order)
               {
                  _loc3_ = _loc8_[_loc10_];
                  _loc8_[_loc10_] = _loc8_[_loc4_];
                  _loc8_[_loc4_] = _loc3_;
               }
               _loc4_++;
            }
            _loc10_++;
         }
         _loc10_ = 0;
         _loc6_ = int(_loc9_.length);
         while(_loc10_ < _loc6_)
         {
            _loc5_ = _loc10_;
            while(_loc5_ < _loc6_)
            {
               _loc1_ = this._model.getShopItemByid(_loc9_[_loc10_].per_id);
               _loc2_ = this._model.getShopItemByid(_loc9_[_loc5_].per_id);
               if(_loc1_.Order > _loc2_.Order)
               {
                  _loc3_ = _loc9_[_loc10_];
                  _loc9_[_loc10_] = _loc9_[_loc5_];
                  _loc9_[_loc5_] = _loc3_;
               }
               _loc5_++;
            }
            _loc10_++;
         }
         _loc6_ = int(_loc8_.length);
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            this._shopItems.push(_loc8_[_loc10_]);
            _loc10_++;
         }
         _loc6_ = int(_loc9_.length);
         _loc10_ = 0;
         while(_loc10_ < _loc6_)
         {
            this._shopItems.push(_loc9_[_loc10_]);
            _loc10_++;
         }
      }
      
      private function sortState(param1:IndianaShowData, param2:IndianaShowData) : int
      {
         if(param1.state < param2.state)
         {
            return -1;
         }
         if(param1.state > param2.state)
         {
            return 1;
         }
         return 0;
      }
      
      private function getIndianaShowDataByPerId(param1:int) : IndianaShowData
      {
         var _loc2_:int = 0;
         var _loc3_:int = int(this._shopItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._shopItems[_loc2_].per_id == param1)
            {
               return this._shopItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function disposeView() : void
      {
         if(Boolean(this.view))
         {
            this.view.dispose();
            this.view = null;
         }
      }
      
      public function goodsItemAnalyzer(param1:IndianaGoodsItemAnalyzer) : void
      {
         this._model.Items = param1.data;
      }
      
      public function shopItemAnalyzer(param1:IndianaShopItemsAnalyzer) : void
      {
         this._model.ShopItems = param1.data;
      }
      
      public function tickTime() : void
      {
         var _loc1_:int = this._model.getActivateState();
         if(_loc1_ > 0)
         {
            if(this._showBtn == false && _loc1_ == IndianaModel.INDIANA_START)
            {
               this._showBtn = true;
            }
            if(this._showBtn && _loc1_ == IndianaModel.INDIANA_END)
            {
               this._showBtn = false;
               this.disposeTimer();
            }
         }
         else if(this._showBtn)
         {
            this._showBtn = false;
            this.disposeTimer();
         }
         this.checkIcon();
      }
      
      public function checkIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.INDIANA,this._showBtn);
      }
      
      private function disposeTimer() : void
      {
         if(this._timer)
         {
         }
      }
      
      private function __completeHander(param1:Event) : void
      {
         if(this._showBtn)
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      public function getTemplatesByShopId(param1:int) : ItemTemplateInfo
      {
         var _loc2_:* = null;
         var _loc3_:IndianaGoodsItemInfo = this.getIndianaGoodsItemInfoByshopId(param1);
         if(Boolean(_loc3_))
         {
            _loc2_ = ItemManager.Instance.getTemplateById(_loc3_.GoodsID);
         }
         return _loc2_;
      }
      
      public function getIndianaGoodsItemInfoByshopId(param1:int) : IndianaGoodsItemInfo
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = int(this._model.Items.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this._model.Items[_loc3_].Id)
            {
               return this._model.Items[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get getCurrentShopItem() : IndianaShopItemInfo
      {
         if(Boolean(this.currentShowData))
         {
            this.currentShopInfo = this._model.getShopItemByid(this.currentShowData.per_id);
         }
         return this.currentShopInfo;
      }
      
      public function get leftShopItem() : IndianaShowData
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(Boolean(this.currentShowData))
         {
            _loc1_ = this._shopItems.indexOf(this.currentShowData);
            if(_loc1_ > 0)
            {
               _loc1_--;
               _loc2_ = this._shopItems[_loc1_];
            }
            else
            {
               _loc2_ = this._shopItems[this._shopItems.length - 1];
            }
            return _loc2_;
         }
         return null;
      }
      
      public function get rightShopItem() : IndianaShowData
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(Boolean(this.currentShowData))
         {
            _loc1_ = this._shopItems.indexOf(this.currentShowData);
            if(_loc1_ < this._shopItems.length - 1)
            {
               _loc1_++;
               _loc2_ = this._shopItems[_loc1_];
            }
            else
            {
               _loc2_ = this._shopItems[0];
            }
            return _loc2_;
         }
         return null;
      }
      
      public function getShopItem() : Array
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = int(this._shopItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc1_ = this._model.getShopItemByid(this._shopItems[_loc2_].per_id);
            if((Boolean(_loc1_)) && _loc1_.Putaway == 1)
            {
               _loc3_.push(_loc1_);
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.onComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ONEYUAN_OF_INDIANA);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ONEYUAN_OF_INDIANA)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function onComplete(param1:UIModuleEvent) : void
      {
         if(this.model.ShopItems.length > 0 && param1.module == UIModuleTypes.ONEYUAN_OF_INDIANA)
         {
            SocketManager.Instance.out.sendUpdateSysDate();
            SocketManager.Instance.out.sendIndianaEnterGame(0);
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.onComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         }
      }
   }
}

