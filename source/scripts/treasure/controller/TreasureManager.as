package treasure.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.view.UIModuleSmallLoading;
   import farm.FarmModelController;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import treasure.data.TreasureTempInfo;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureManager extends EventDispatcher
   {
      
      private static var _instance:TreasureManager = null;
      
      private var _UILoadComplete:Boolean = false;
      
      public function TreasureManager()
      {
         super();
         this.initEvent();
      }
      
      public static function get instance() : TreasureManager
      {
         if(_instance == null)
         {
            _instance = new TreasureManager();
         }
         return _instance;
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener("enterTreasure",this.__onEnterTreasure);
         SocketManager.Instance.addEventListener("beRepairFriendFarmSend",this.__farmBeRepairHandler);
         SocketManager.Instance.addEventListener("stratGameTreasure",this.__stratGameHandler);
         SocketManager.Instance.addEventListener("endTreasure",this.__endGameHandler);
         SocketManager.Instance.addEventListener("dig",this.__digHandler);
      }
      
      private function __digHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = param1.pkg.readInt();
         var _loc4_:int = param1.pkg.readInt();
         var _loc5_:int = param1.pkg.readInt();
         PlayerManager.Instance.Self.treasure = param1.pkg.readInt();
         var _loc6_:int = param1.pkg.readInt();
         PlayerManager.Instance.Self.treasureAdd = _loc6_ > 0 ? _loc6_ : 0;
         _loc2_ = 0;
         while(_loc2_ < TreasureModel.instance.itemList.length)
         {
            if(TreasureModel.instance.itemList[_loc2_].TemplateID == _loc3_ && TreasureModel.instance.itemList[_loc2_].Count == _loc5_)
            {
               TreasureModel.instance.itemList[_loc2_].pos = _loc4_;
               this.sortList();
               dispatchEvent(new TreasureEvents("dig",{"pos":_loc4_}));
               return;
            }
            _loc2_++;
         }
      }
      
      private function __endGameHandler(param1:CrazyTankSocketEvent) : void
      {
         TreasureModel.instance.isEndTreasure = param1.pkg.readBoolean();
         dispatchEvent(new TreasureEvents("endGame"));
      }
      
      private function __stratGameHandler(param1:CrazyTankSocketEvent) : void
      {
         TreasureModel.instance.isBeginTreasure = param1.pkg.readBoolean();
         dispatchEvent(new TreasureEvents("beginGame"));
      }
      
      private function __farmBeRepairHandler(param1:CrazyTankSocketEvent) : void
      {
         TreasureModel.instance.friendHelpTimes = param1.pkg.readInt();
         if(TreasureModel.instance.friendHelpTimes == PathManager.treasureHelpTimes)
         {
            PlayerManager.Instance.Self.treasureAdd = 1;
         }
         dispatchEvent(new TreasureEvents("beRepairFriendFarmSend"));
      }
      
      private function __onEnterTreasure(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         TreasureModel.instance.logoinDays = param1.pkg.readInt();
         PlayerManager.Instance.Self.treasure = param1.pkg.readInt();
         var _loc9_:int = param1.pkg.readInt();
         PlayerManager.Instance.Self.treasureAdd = _loc9_ > 0 ? _loc9_ : 0;
         TreasureModel.instance.friendHelpTimes = param1.pkg.readInt();
         TreasureModel.instance.isEndTreasure = param1.pkg.readBoolean();
         TreasureModel.instance.isBeginTreasure = param1.pkg.readBoolean();
         TreasureModel.instance.itemList = new Vector.<TreasureTempInfo>();
         _loc2_ = param1.pkg.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = new ItemTemplateInfo();
            _loc5_.TemplateID = param1.pkg.readInt();
            _loc5_ = ItemManager.Instance.getTemplateById(_loc5_.TemplateID);
            _loc6_ = new TreasureTempInfo();
            ObjectUtils.copyProperties(_loc6_,_loc5_);
            _loc6_.ValidDate = param1.pkg.readInt();
            _loc6_.Count = param1.pkg.readInt();
            _loc6_.pos = 0;
            _loc6_.IsBinds = true;
            _loc6_.BindType = 1;
            if(TreasureModel.instance.itemList.length == 0)
            {
               _loc4_ = 0;
            }
            else
            {
               _loc4_ = Math.floor((TreasureModel.instance.itemList.length + 1) * Math.random());
            }
            TreasureModel.instance.itemList.splice(_loc4_,0,_loc6_);
            _loc3_++;
         }
         _loc2_ = param1.pkg.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc7_ = new ItemTemplateInfo();
            _loc7_.TemplateID = param1.pkg.readInt();
            _loc7_ = ItemManager.Instance.getTemplateById(_loc7_.TemplateID);
            _loc8_ = new TreasureTempInfo();
            ObjectUtils.copyProperties(_loc8_,_loc7_);
            _loc8_.pos = param1.pkg.readInt();
            _loc8_.ValidDate = param1.pkg.readInt();
            _loc8_.Count = param1.pkg.readInt();
            _loc8_.IsBinds = true;
            _loc8_.BindType = 1;
            TreasureModel.instance.itemList.push(_loc8_);
            _loc3_++;
         }
         this.sortList();
         if(this._UILoadComplete)
         {
            this.creatView();
         }
         else
         {
            this.loadUIModule();
         }
      }
      
      private function sortList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < TreasureModel.instance.itemList.length)
         {
            if(TreasureModel.instance.itemList[_loc1_].pos != 0)
            {
               _loc6_.push({"pos":TreasureModel.instance.itemList[_loc1_].pos});
            }
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < TreasureModel.instance.itemList.length - 1)
         {
            _loc3_ = _loc2_ + 1;
            while(_loc3_ < TreasureModel.instance.itemList.length)
            {
               if(TreasureModel.instance.itemList[_loc2_].pos > TreasureModel.instance.itemList[_loc3_].pos)
               {
                  _loc4_ = TreasureModel.instance.itemList[_loc2_];
                  TreasureModel.instance.itemList[_loc2_] = TreasureModel.instance.itemList[_loc3_];
                  TreasureModel.instance.itemList[_loc3_] = _loc4_;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         var _loc7_:Vector.<TreasureTempInfo> = TreasureModel.instance.itemList.splice(TreasureModel.instance.itemList.length - _loc6_.length,_loc6_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc7_.length)
         {
            TreasureModel.instance.itemList.splice(_loc7_[_loc5_].pos - 1,0,_loc7_[_loc5_]);
            _loc5_++;
         }
      }
      
      private function creatView() : void
      {
         if(StateManager.currentStateType != "treasure")
         {
            StateManager.setState("treasure");
         }
         else
         {
            FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
         }
      }
      
      private function loadUIModule() : void
      {
         if(!this._UILoadComplete)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__onUIModuleComplete);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__onProgress);
            UIModuleLoader.Instance.addUIModuleImp("treasure");
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__onProgress);
      }
      
      protected function __onUIModuleComplete(param1:UIModuleEvent) : void
      {
         this._UILoadComplete = true;
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__onUIModuleComplete);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__onProgress);
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleSmallLoading.Instance.hide();
         this.creatView();
      }
      
      protected function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      public function show() : void
      {
         SocketManager.Instance.out.enterTreasure();
      }
   }
}

