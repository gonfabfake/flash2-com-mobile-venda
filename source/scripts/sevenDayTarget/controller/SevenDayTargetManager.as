package sevenDayTarget.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.data.UIModuleTypes;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.socket.SevenDayTargetPackageType;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import godsRoads.manager.GodsRoadsManager;
   import road7th.comm.PackageIn;
   import sevenDayTarget.dataAnalyzer.SevenDayTargetDataAnalyzer;
   import sevenDayTarget.model.NewTargetQuestionInfo;
   import sevenDayTarget.model.SevenDayTargetModel;
   import sevenDayTarget.view.SevenDayTargetMainView;
   
   public class SevenDayTargetManager extends EventDispatcher
   {
      
      private static var _instance:SevenDayTargetManager;
      
      public static var loadComplete:Boolean = false;
      
      private var _model:SevenDayTargetModel;
      
      private var _isShowIcon:Boolean;
      
      private var _sevenDayTargetView:SevenDayTargetMainView;
      
      public var today:int = 1;
      
      public var questionTemple:Array;
      
      public var isHallAct:Boolean = false;
      
      public function SevenDayTargetManager()
      {
         super();
      }
      
      public static function get Instance() : SevenDayTargetManager
      {
         if(_instance == null)
         {
            _instance = new SevenDayTargetManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new SevenDayTargetModel();
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SEVENDAYTARGET_GODSROADS,this.pkgHandler);
         GodsRoadsManager.instance.addEventListener("XMLdata_Complete",this._dataReciver);
      }
      
      private function _dataReciver(param1:Event) : void
      {
         var _loc2_:XML = GodsRoadsManager.instance.XMLData;
         var _loc3_:SevenDayTargetDataAnalyzer = new SevenDayTargetDataAnalyzer(SevenDayTargetManager.Instance.templateDataSetup);
         _loc3_.analyze(_loc2_);
      }
      
      public function get isShowIcon() : Boolean
      {
         return this._isShowIcon;
      }
      
      public function hide() : void
      {
         if(this._sevenDayTargetView != null)
         {
            this._sevenDayTargetView.dispose();
         }
         this._sevenDayTargetView = null;
      }
      
      public function onClickSevenDayTargetIcon() : void
      {
         var _loc1_:Timer = null;
         SoundManager.instance.play("008");
         if(Boolean(this.questionTemple))
         {
            SocketManager.Instance.out.sevenDayTarget_enter(this.isHallAct);
         }
         else
         {
            _loc1_ = new Timer(1000);
            _loc1_.addEventListener(TimerEvent.TIMER,this.__delayLoading);
            _loc1_.start();
         }
      }
      
      private function __delayLoading(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.currentTarget as Timer;
         if(Boolean(this.questionTemple))
         {
            SocketManager.Instance.out.sevenDayTarget_enter(this.isHallAct);
            _loc2_.stop();
            _loc2_.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__delayLoading);
            _loc2_ = null;
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
            loadComplete = true;
            this.showSevenDayTargetMainView();
         }
      }
      
      public function showSevenDayTargetMainView() : void
      {
         NewSevenDayAndNewPlayerManager.Instance.sevenDayMainViewPreOk = true;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openSevenDayMainView"));
      }
      
      public function templateDataSetup(param1:DataAnalyzer) : void
      {
         if(param1 is SevenDayTargetDataAnalyzer)
         {
            this.questionTemple = SevenDayTargetDataAnalyzer(param1).dataList;
         }
      }
      
      public function getQuestionInfoFromTemple(param1:NewTargetQuestionInfo) : NewTargetQuestionInfo
      {
         var _loc2_:NewTargetQuestionInfo = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.questionTemple.length)
         {
            _loc2_ = this.questionTemple[_loc3_];
            if(_loc2_.questId == param1.questId)
            {
               param1.condition1Title = _loc2_.condition1Title;
               param1.condition2Title = _loc2_.condition2Title;
               param1.condition3Title = _loc2_.condition3Title;
               param1.linkId = _loc2_.linkId;
               param1.condition1Para = _loc2_.condition1Para;
               param1.condition2Para = _loc2_.condition2Para;
               param1.condition3Para = _loc2_.condition3Para;
               param1.Period = _loc2_.Period;
            }
            _loc3_++;
         }
         return param1;
      }
      
      private function openOrclose(param1:PackageIn) : void
      {
         this._isShowIcon = param1.readBoolean();
         NewSevenDayAndNewPlayerManager.Instance.sevenDayOpen = this._isShowIcon;
         NewSevenDayAndNewPlayerManager.Instance.dispatchEvent(new Event("openUpdate"));
      }
      
      private function enterView(param1:PackageIn) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:NewTargetQuestionInfo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:InventoryItemInfo = null;
         var _loc14_:int = param1.readInt();
         this.today = param1.readInt();
         var _loc15_:Array = [];
         var _loc16_:int = 0;
         while(_loc16_ < _loc14_)
         {
            _loc2_ = param1.readBoolean();
            _loc3_ = param1.readInt();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new NewTargetQuestionInfo();
               _loc5_.questId = param1.readInt();
               _loc5_ = this.getQuestionInfoFromTemple(_loc5_);
               _loc5_.iscomplete = param1.readBoolean();
               _loc6_ = param1.readInt();
               if(_loc6_ >= _loc5_.condition1Para)
               {
                  _loc5_.condition1Complete = true;
               }
               _loc7_ = param1.readInt();
               if(_loc7_ >= _loc5_.condition2Para)
               {
                  _loc5_.condition2Complete = true;
               }
               _loc8_ = param1.readInt();
               if(_loc8_ >= _loc5_.condition3Para)
               {
                  _loc5_.condition3Complete = true;
               }
               _loc5_.condition4 = param1.readInt();
               _loc5_.getedReward = param1.readBoolean();
               _loc9_ = param1.readInt();
               _loc10_ = [];
               _loc11_ = 0;
               while(_loc11_ < _loc9_)
               {
                  _loc12_ = param1.readInt();
                  _loc13_ = new InventoryItemInfo();
                  _loc13_.ItemID = _loc12_;
                  param1.readInt();
                  _loc13_.Count = param1.readInt();
                  _loc10_.push(_loc13_);
                  param1.readInt();
                  param1.readInt();
                  param1.readInt();
                  param1.readInt();
                  param1.readInt();
                  param1.readBoolean();
                  _loc11_++;
               }
               _loc5_.rewardList = _loc10_;
               _loc15_.push(_loc5_);
               _loc4_++;
            }
            param1.readInt();
            this._model.sevenDayQuestionInfoArr = _loc15_;
            _loc16_++;
         }
         if(loadComplete)
         {
            this.showSevenDayTargetMainView();
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
      
      private function pkgHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = param1._cmd;
         switch(_loc3_)
         {
            case SevenDayTargetPackageType.SEVENDAYTARGET_OPEN_CLOSE:
               this.openOrclose(_loc2_);
               break;
            case SevenDayTargetPackageType.SEVENDAYTARGET_ENTER:
               this.enterView(_loc2_);
               break;
            case SevenDayTargetPackageType.SEVENDAYTARGET_GET_REWARD:
               this.updateView(_loc2_);
         }
      }
      
      private function updateView(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = param1.readBoolean();
         if(_loc5_)
         {
            _loc2_ = param1.readInt();
            _loc3_ = param1.readInt();
            _loc4_ = param1.readBoolean();
            this.updateQuestionInfoArr(_loc2_,_loc5_,_loc4_);
         }
      }
      
      private function updateQuestionInfoArr(param1:int, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:NewTargetQuestionInfo = null;
         var _loc5_:int = 0;
         while(_loc5_ < this._model.sevenDayQuestionInfoArr.length)
         {
            _loc4_ = this._model.sevenDayQuestionInfoArr[_loc5_];
            if(_loc4_.questId == param1)
            {
               _loc4_.getedReward = param2;
               _loc4_.iscomplete = param3;
            }
            _loc5_++;
         }
      }
      
      public function get model() : SevenDayTargetModel
      {
         return this._model;
      }
   }
}

