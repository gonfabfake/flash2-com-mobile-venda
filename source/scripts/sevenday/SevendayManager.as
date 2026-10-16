package sevenday
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.GameSocketOut;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import sevenday.view.SevendayMainFrame;
   
   public class SevendayManager extends EventDispatcher
   {
      
      private static var _instance:SevendayManager;
      
      public static const QUEST_LIST_1:Array = [3201,3202,3203,3204,3205,3206,3207];
      
      public static const QUEST_LIST_2:Array = [3208,3209,3210,3211,3212,3213,3214];
      
      private var _sevendaysocket:GameSocketOut;
      
      private var _time:Date;
      
      private var _day:int;
      
      private var _hour:int;
      
      private var _autoOpenViewState:int = 2;
      
      private var _frame:SevendayMainFrame;
      
      public function SevendayManager(param1:inner)
      {
         super(null);
      }
      
      public static function get instance() : SevendayManager
      {
         if(_instance == null)
         {
            _instance = new SevendayManager(new inner());
         }
         return _instance;
      }
      
      public function show() : void
      {
         this._autoOpenViewState = 0;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.SEVEN_DAY);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.SEVEN_DAY)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function showFrame(param1:UIModuleEvent) : void
      {
         if(this._frame == null && param1.module == UIModuleTypes.SEVEN_DAY)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("seventdyas.frame");
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._frame.show();
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         }
      }
      
      private function __onFrameClose(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this.hideFrame();
         }
      }
      
      public function hideFrame() : void
      {
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
      }
      
      public function isNotAllAchieved(param1:int = 0) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Array = [];
         _loc4_ = SevendayManager.QUEST_LIST_1.concat(SevendayManager.QUEST_LIST_2);
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc3_ = TaskManager.instance.getQuestByID(_loc4_[_loc2_]);
            if((Boolean(_loc3_.data) || Boolean(_loc3_.isAchieved) && Boolean(!_loc3_.isAvailable)) && param1 != _loc4_[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function updateTime() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Date = PlayerManager.Instance.Self.createPlayerDate;
         var _loc4_:Number = _loc2_.time - _loc3_.time;
         this._day = _loc4_ / 86400000;
         this._hour = 24 - _loc4_ % 86400000 / (86400000 / 24);
      }
      
      public function get isSevenday() : Boolean
      {
         return this._day < 7;
      }
      
      public function get day() : int
      {
         return this._day;
      }
      
      public function get hour() : int
      {
         return this._hour;
      }
      
      public function checkAutoShow() : void
      {
         if(ServerConfigManager.instance.sevenDayIsOpen && SevendayManager.instance.isSevenday && PlayerManager.Instance.Self.Grade >= 11)
         {
            this.show();
         }
      }
      
      public function checkIcon() : void
      {
         if(!ServerConfigManager.instance.sevenDayIsOpen)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDAY,false);
            return;
         }
         this.updateTime();
         var _loc1_:Boolean = this.isNotAllAchieved();
         if(this.isSevenday && _loc1_)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDAY,true);
            if(this._autoOpenViewState == 2 && PlayerManager.Instance.Self.Grade <= 11)
            {
               this._autoOpenViewState = 0;
               this.show();
            }
         }
         else
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.SEVENDAY,false);
         }
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
