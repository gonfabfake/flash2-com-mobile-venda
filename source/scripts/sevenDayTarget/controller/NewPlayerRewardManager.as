package sevenDayTarget.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.socket.SevenDayTargetPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   import sevenDayTarget.model.NewPlayerRewardInfo;
   import sevenDayTarget.model.NewPlayerRewardModel;
   import sevenDayTarget.view.NewPlayerRewardMainView;
   
   public class NewPlayerRewardManager extends EventDispatcher
   {
      
      private static var _instance:NewPlayerRewardManager;
      
      private var _isShowIcon:Boolean;
      
      private var _model:NewPlayerRewardModel;
      
      public function NewPlayerRewardManager()
      {
         super();
      }
      
      public static function get Instance() : NewPlayerRewardManager
      {
         if(_instance == null)
         {
            _instance = new NewPlayerRewardManager();
         }
         return _instance;
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function setup() : void
      {
         this._model = new NewPlayerRewardModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVENDAYTARGET_NEWPLAYERREWARD,this.pkgHandler);
      }
      
      public function get model() : NewPlayerRewardModel
      {
         return this._model;
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case SevenDayTargetPackageType.NEWPLAYERREWARD_OPEN_CLOSE:
               this.openOrclose(_loc2_);
               break;
            case SevenDayTargetPackageType.NEWPLAYERREWARD_ENTER:
               this.enterView(_loc2_);
               break;
            case SevenDayTargetPackageType.NEWPLAYERREWARD_GET_REWARD:
               this.updateView(_loc2_);
         }
      }
      
      private function updateView(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = param1.readBoolean();
         if(_loc4_)
         {
            _loc2_ = param1.readInt();
            _loc3_ = param1.readBoolean();
            this.updateQuestionInfoArr(_loc2_,_loc4_,_loc3_);
         }
      }
      
      private function updateQuestionInfoArr(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:NewPlayerRewardInfo = null;
         var _loc5_:int = 0;
         while(_loc5_ < this._model.chongzhiInfoArr.length)
         {
            _loc4_ = this._model.chongzhiInfoArr[_loc5_];
            if(_loc4_.questId == param1)
            {
               _loc4_.getRewarded = param2;
               _loc4_.finished = param3;
               return;
            }
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < this._model.xiaofeiInfoArr.length)
         {
            _loc4_ = this._model.xiaofeiInfoArr[_loc6_];
            if(_loc4_.questId == param1)
            {
               _loc4_.getRewarded = param2;
               _loc4_.finished = param3;
               return;
            }
            _loc6_++;
         }
         var _loc7_:int = 0;
         while(_loc7_ < this._model.hunliInfoArr.length)
         {
            _loc4_ = this._model.hunliInfoArr[_loc7_];
            if(_loc4_.questId == param1)
            {
               _loc4_.getRewarded = param2;
               _loc4_.finished = param3;
               return;
            }
            _loc7_++;
         }
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         this._isShowIcon = param1.readBoolean();
         NewSevenDayAndNewPlayerManager.Instance.newPlayerOpen = this._isShowIcon;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openUpdate"));
      }
      
      public function enterView(param1:PackageIn) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:NewPlayerRewardInfo = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:InventoryItemInfo = null;
         var _loc10_:int = 0;
         while(_loc10_ < 3)
         {
            _loc2_ = new Array();
            _loc3_ = param1.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new NewPlayerRewardInfo();
               _loc5_.questId = param1.readInt();
               _loc5_.num = param1.readInt();
               if(_loc10_ == 0)
               {
                  _loc5_.bgType = NewPlayerRewardMainView.CHONGZHI;
               }
               else if(_loc10_ == 1)
               {
                  _loc5_.bgType = NewPlayerRewardMainView.XIAOFEI;
               }
               else if(_loc10_ == 2)
               {
                  _loc5_.bgType = NewPlayerRewardMainView.HUNLI;
               }
               _loc5_.finished = param1.readBoolean();
               _loc5_.getRewarded = param1.readBoolean();
               _loc6_ = param1.readInt();
               _loc7_ = new Array();
               _loc8_ = 0;
               while(_loc8_ < _loc6_)
               {
                  _loc9_ = new InventoryItemInfo();
                  _loc9_.ItemID = param1.readInt();
                  _loc9_.Count = param1.readInt();
                  _loc7_.push(_loc9_);
                  _loc8_++;
               }
               _loc5_.rewardArr = _loc7_;
               _loc2_.push(_loc5_);
               _loc4_++;
            }
            if(_loc10_ == 0)
            {
               this._model.chongzhiInfoArr = _loc2_;
            }
            else if(_loc10_ == 1)
            {
               this._model.xiaofeiInfoArr = _loc2_;
            }
            else if(_loc10_ == 2)
            {
               this._model.hunliInfoArr = _loc2_;
            }
            _loc10_++;
         }
         if(SevenDayTargetManager.loadComplete)
         {
            this.showNewPlayerRewardMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SEVENDAYTARGET);
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.SEVENDAYTARGET)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __completeShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.SEVENDAYTARGET)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            SevenDayTargetManager.loadComplete = true;
            this.showNewPlayerRewardMainView();
         }
      }
      
      private function showNewPlayerRewardMainView() : void
      {
         NewSevenDayAndNewPlayerManager.Instance.newPlayerMainViewPreOk = true;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openSevenDayMainView"));
      }
   }
}

