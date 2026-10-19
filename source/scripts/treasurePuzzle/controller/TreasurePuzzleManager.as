package treasurePuzzle.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import road7th.comm.PackageIn;
   import treasurePuzzle.data.TreasurePuzzlePackageType;
   import treasurePuzzle.data.TreasurePuzzlePiceData;
   import treasurePuzzle.data.TreasurePuzzleRewardData;
   import treasurePuzzle.model.TreasurePuzzleModel;
   import treasurePuzzle.view.TreasurePuzzleMainView;
   
   public class TreasurePuzzleManager extends EventDispatcher
   {
      
      private static var _instance:TreasurePuzzleManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _isShowIcon:Boolean;
      
      private var _treasurePuzzleView:TreasurePuzzleMainView;
      
      private var _model:TreasurePuzzleModel;
      
      public var currentPuzzle:int;
      
      public function TreasurePuzzleManager()
      {
         super();
      }
      
      public static function get Instance() : TreasurePuzzleManager
      {
         if(_instance == null)
         {
            _instance = new TreasurePuzzleManager();
         }
         return _instance;
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function setup() : void
      {
         this._model = new TreasurePuzzleModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TREASUREPUZZLE_SYSTEM,this.pkgHandler);
      }
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case TreasurePuzzlePackageType.TREASUREPUZZLE_OPEN_CLOSE:
               this.openOrclose(_loc2_);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_ENTER:
               this.enterView(_loc2_);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_SEE_REWARD:
               this.seeReward(_loc2_);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_GET_REWARD:
               this.getReward(_loc2_);
               break;
            case TreasurePuzzlePackageType.TREASUREPUZZLE_FLUSH:
               this.flushData(_loc2_);
         }
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         this._isShowIcon = param1.readBoolean();
         if(this._isShowIcon)
         {
            this.addEnterIcon();
         }
         else
         {
            this.disposeEnterIcon();
         }
      }
      
      private function enterView(param1:PackageIn) : void
      {
         var _loc2_:TreasurePuzzlePiceData = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = param1.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new TreasurePuzzlePiceData();
            _loc2_.id = param1.readInt();
            _loc2_.hole1Need = param1.readInt();
            _loc2_.hole1Have = param1.readInt();
            _loc2_.hole2Need = param1.readInt();
            _loc2_.hole2Have = param1.readInt();
            _loc2_.hole3Need = param1.readInt();
            _loc2_.hole3Have = param1.readInt();
            _loc2_.hole4Need = param1.readInt();
            _loc2_.hole4Have = param1.readInt();
            _loc2_.hole5Need = param1.readInt();
            _loc2_.hole5Have = param1.readInt();
            _loc2_.hole6Need = param1.readInt();
            _loc2_.hole6Have = param1.readInt();
            _loc2_._canGetReward = param1.readBoolean();
            _loc3_.push(_loc2_);
            _loc5_++;
         }
         this._model.dataArr = _loc3_;
         if(loadComplete)
         {
            this.showTreasurePuzzleMainView();
         }
         else
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.TREASURE_PUZZLE);
         }
      }
      
      private function flushData(param1:PackageIn) : void
      {
         var _loc2_:TreasurePuzzlePiceData = null;
         var _loc3_:Array = new Array();
         var _loc4_:int = param1.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new TreasurePuzzlePiceData();
            _loc2_.id = param1.readInt();
            _loc2_.hole1Need = param1.readInt();
            _loc2_.hole1Have = param1.readInt();
            _loc2_.hole2Need = param1.readInt();
            _loc2_.hole2Have = param1.readInt();
            _loc2_.hole3Need = param1.readInt();
            _loc2_.hole3Have = param1.readInt();
            _loc2_.hole4Need = param1.readInt();
            _loc2_.hole4Have = param1.readInt();
            _loc2_.hole5Need = param1.readInt();
            _loc2_.hole5Have = param1.readInt();
            _loc2_.hole6Need = param1.readInt();
            _loc2_.hole6Have = param1.readInt();
            _loc2_._canGetReward = param1.readBoolean();
            _loc3_.push(_loc2_);
            _loc5_++;
         }
         this._model.dataArr = _loc3_;
         this._treasurePuzzleView.flushRewardBnt();
      }
      
      private function seeReward(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TreasurePuzzlePiceData = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:TreasurePuzzlePiceData = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:TreasurePuzzleRewardData = null;
         var _loc10_:Array = new Array();
         var _loc11_:int = param1.readInt();
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            _loc2_ = param1.readInt();
            _loc4_ = 0;
            while(_loc4_ < this._model.dataArr.length)
            {
               _loc6_ = this._model.dataArr[_loc4_];
               if(_loc2_ == _loc6_.id)
               {
                  _loc3_ = this._model.dataArr[_loc4_];
               }
               _loc4_++;
            }
            _loc5_ = param1.readBoolean();
            if(_loc5_)
            {
               _loc3_.isShiwu = true;
            }
            else
            {
               _loc3_.isShiwu = false;
               _loc3_.rewardNum = param1.readInt();
               _loc7_ = new Array();
               _loc8_ = 0;
               while(_loc8_ < _loc3_.rewardNum)
               {
                  _loc9_ = new TreasurePuzzleRewardData();
                  _loc9_.rewardId = param1.readInt();
                  _loc9_.rewardNum = param1.readInt();
                  _loc7_.push(_loc9_);
                  _loc8_++;
               }
               _loc3_.rewardList = _loc7_;
            }
            _loc12_++;
         }
         this._treasurePuzzleView.showHelpView();
      }
      
      private function getReward(param1:PackageIn) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = param1.readBoolean();
         if(_loc3_)
         {
            _loc2_ = param1.readBoolean();
            if(_loc2_)
            {
               this._treasurePuzzleView.showShiwuInfoView();
            }
         }
      }
      
      public function addEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASUREPUZZLE,true);
      }
      
      private function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.TREASUREPUZZLE,false);
      }
      
      public function onClickTreasurePuzzleIcon() : void
      {
         SocketManager.Instance.out.treasurePuzzle_enter();
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
         if(param1.module == UIModuleTypes.TREASURE_PUZZLE)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function __completeShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.TREASURE_PUZZLE)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__completeShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            this.showTreasurePuzzleMainView();
         }
      }
      
      private function showTreasurePuzzleMainView() : void
      {
         this._treasurePuzzleView = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.TreasurePuzzleFrame");
         this._treasurePuzzleView.show();
      }
      
      public function get model() : TreasurePuzzleModel
      {
         return this._model;
      }
      
      public function hide() : void
      {
         if(this._treasurePuzzleView != null)
         {
            this._treasurePuzzleView.dispose();
         }
         this._treasurePuzzleView = null;
      }
   }
}

