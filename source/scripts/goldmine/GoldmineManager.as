package goldmine
{
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.CoreManager;
   import ddt.data.UIModuleTypes;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.IEventDispatcher;
   import goldmine.model.GoldmineModel;
   import hall.IHallStateView;
   import hallIcon.HallIconManager;
   import road7th.comm.PackageIn;
   
   public class GoldmineManager extends CoreManager
   {
      
      private static var _instance:GoldmineManager;
      
      public static const SHOW_VIEW:String = "goldmine_showview";
      
      public static const ClOSE_VIEW:String = "goldmine_closeview";
      
      public static const USE_GOLDMINE:String = "goldmine_use";
      
      private var _isOpen:Boolean = false;
      
      private var _icon:BaseButton;
      
      private var _hall:IHallStateView;
      
      private var _dateStart:Date = new Date();
      
      private var _dateEnd:Date = new Date();
      
      private var _model:GoldmineModel;
      
      public function GoldmineManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initEvent();
      }
      
      public static function get Instance() : GoldmineManager
      {
         if(_instance == null)
         {
            _instance = new GoldmineManager();
         }
         return _instance;
      }
      
      public function get dateStart() : Date
      {
         return this._dateStart;
      }
      
      public function get dateEnd() : Date
      {
         return this._dateEnd;
      }
      
      public function get model() : GoldmineModel
      {
         return this._model;
      }
      
      public function setup() : void
      {
         this._model = new GoldmineModel();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GOLDMINE,this.__handler);
      }
      
      private function __handler(param1:CrazyTankSocketEvent) : *
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readByte();
         switch(_loc3_)
         {
            case 1:
               this.__onIsOpen(_loc2_);
               break;
            case 3:
               this.__onInit(_loc2_);
               break;
            case 2:
               this.__onUse(_loc2_);
         }
      }
      
      private function __onIsOpen(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         this._isOpen = _loc2_;
         if(this._isOpen)
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("goldmine.beginTips"));
         }
         else
         {
            ChatManager.Instance.sysChatAmaranth(LanguageMgr.GetTranslation("goldmine.endTips"));
         }
         this.updataEnterIcon(this._isOpen);
         if(!this._isOpen)
         {
            this.dispatchEvent(new CEvent("goldmine_closeview"));
         }
      }
      
      private function __onInit(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._dateStart = param1.readDate();
         this._dateEnd = param1.readDate();
         this._model.usedTimes = param1.readInt();
         this._model.score = param1.readInt();
         this._model.maxTimes = param1.readInt();
         this._model.goldArr = new Array(this._model.maxTimes);
         this._model.goldNeedArr = new Array(this._model.maxTimes);
         _loc2_ = 0;
         while(_loc2_ < this._model.maxTimes)
         {
            this._model.goldArr[_loc2_] = param1.readInt();
            this._model.goldNeedArr[_loc2_] = param1.readInt();
            _loc2_++;
         }
         this._model.mineSmall = param1.readInt();
         this._model.mineMiddle = param1.readInt();
         this._model.mineBig = param1.readInt();
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this._model.maxTimes)
         {
            if(this._model.score >= this._model.goldArr[_loc3_])
            {
               _loc4_++;
            }
            _loc3_++;
         }
         this._model.currentTimes = _loc4_ - this._model.usedTimes;
         if(_loc4_ <= this._model.maxTimes)
         {
            this._model.nextScoreNeed = this._model.goldArr[_loc4_] - this._model.score;
         }
         this.dispatchEvent(new CEvent("goldmine_showview"));
      }
      
      private function __onUse(param1:PackageIn) : void
      {
         var _loc2_:int = param1.readInt();
         var _loc3_:int = -1;
         if(_loc2_ == this._model.mineSmall)
         {
            _loc3_ = 0;
         }
         else if(_loc2_ == this._model.mineMiddle)
         {
            _loc3_ = 2;
         }
         else if(_loc2_ == this._model.mineBig)
         {
            _loc3_ = 1;
         }
         this._model.mineSmall = param1.readInt();
         this._model.mineMiddle = param1.readInt();
         this._model.mineBig = param1.readInt();
         this.dispatchEvent(new CEvent("goldmine_use",[_loc3_,_loc2_]));
      }
      
      public function testUse(param1:int = 8666) : void
      {
         var _loc2_:* = param1;
         var _loc3_:int = -1;
         if(_loc2_ == this._model.mineSmall)
         {
            _loc3_ = 0;
         }
         else if(_loc2_ == this._model.mineMiddle)
         {
            _loc3_ = 2;
         }
         else if(_loc2_ == this._model.mineBig)
         {
            _loc3_ = 1;
         }
         this.dispatchEvent(new CEvent("goldmine_use",[_loc3_,_loc2_]));
      }
      
      public function updataEnterIcon(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler("goldmine",param1);
      }
      
      override protected function start() : void
      {
         new HelperUIModuleLoad().loadUIModule([UIModuleTypes.GOLD_MINE],function():void
         {
            GameInSocketOut.sendGoldmineInfoAttribute();
         });
      }
   }
}

