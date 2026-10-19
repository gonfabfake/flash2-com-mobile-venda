package ddtKingWay
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.data.quest.QuestInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.TaskEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import ddtKingWay.analyzer.DDTKingWayData;
   import ddtKingWay.analyzer.DDTKingWayDataAnalyzer;
   import hallIcon.HallIconManager;
   import road7th.data.DictionaryData;
   
   public class DDTKingWayManager
   {
      
      private static var _instance:DDTKingWayManager;
      
      public static const QUEST_LIST:Array = [3301,3302,3303,3304,3305];
      
      private var _model:DictionaryData;
      
      private var _frame:Frame;
      
      public function DDTKingWayManager(param1:inner)
      {
         super();
      }
      
      public static function get instance() : DDTKingWayManager
      {
         if(_instance == null)
         {
            _instance = new DDTKingWayManager(new inner());
         }
         return _instance;
      }
      
      public function checkIcon() : void
      {
         if(!ServerConfigManager.instance.ddtKingWayIsOpen)
         {
            HallIconManager.instance.updateSwitchHandler("ddtKingWay",false);
            return;
         }
         if(PlayerManager.Instance.Self.Grade >= 30)
         {
            if(this.isShowIcon)
            {
               HallIconManager.instance.updateSwitchHandler("ddtKingWay",true);
            }
            else
            {
               HallIconManager.instance.updateSwitchHandler("ddtKingWay",false);
            }
         }
         else
         {
            HallIconManager.instance.executeCacheRightIconLevelLimit("ddtKingWay",true,30);
         }
      }
      
      public function setup() : void
      {
         TaskManager.addEventListener("changed",this.__onQuestChange);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.ddtKingWayIconShow);
      }
      
      protected function ddtKingWayIconShow(param1:PlayerPropertyEvent) : void
      {
         if(Boolean(param1.changedProperties["Grade"]))
         {
            if(PlayerManager.Instance.Self.Grade >= 30)
            {
               this.checkIcon();
            }
         }
      }
      
      protected function __onQuestChange(param1:TaskEvent) : void
      {
         if(!this.isShowIcon && Boolean(QUEST_LIST.indexOf(param1.info.Id)))
         {
            this.checkIcon();
         }
      }
      
      public function analyzer(param1:DDTKingWayDataAnalyzer) : void
      {
         this._model = param1.data;
      }
      
      public function get model() : DictionaryData
      {
         return this._model;
      }
      
      private function getAllComplete() : Boolean
      {
         var _loc2_:* = undefined;
         var _loc1_:* = null;
         for each(_loc2_ in this._model)
         {
            _loc1_ = TaskManager.instance.getQuestByID(_loc2_.QuestID);
            if(_loc1_.data != null && !(_loc1_.isAchieved && !_loc1_.isAvailable) && this.checkOut(_loc1_,_loc2_))
            {
               return false;
            }
         }
         return true;
      }
      
      public function get isShowIcon() : Boolean
      {
         if(PlayerManager.Instance.Self.Grade >= 30 && PlayerManager.Instance.Self.Grade < 70 || PlayerManager.Instance.Self.Grade == 70 && !this.getAllComplete())
         {
            if(this.getIndexComplete(this.getPageIndexByGrade(PlayerManager.Instance.Self.Grade)))
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function getIndexComplete(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:* = null;
         _loc2_ = 0;
         while(_loc2_ <= param1)
         {
            _loc3_ = this.model[QUEST_LIST[_loc2_]];
            _loc4_ = TaskManager.instance.getQuestByID(_loc3_.QuestID);
            if(Boolean(_loc4_ && _loc4_.data != null) && Boolean(!(_loc4_.isAchieved && !_loc4_.isAvailable)) && this.checkOut(_loc4_,_loc3_))
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function checkOut(param1:QuestInfo, param2:DDTKingWayData) : Boolean
      {
         if(TimeManager.Instance.NowTime() > param1.data.AddTiemsDate.getTime() + param2.Validay * 86400000)
         {
            return false;
         }
         return true;
      }
      
      public function getPageIndexByGrade(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         _loc2_ = 0;
         while(_loc2_ < QUEST_LIST.length)
         {
            _loc3_ = this._model[QUEST_LIST[_loc2_]];
            if(_loc3_.AddRule > param1)
            {
               break;
            }
            _loc2_++;
         }
         return _loc2_ - 1;
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_KING_WAY);
      }
      
      private function showFrame(param1:UIModuleEvent) : void
      {
         if(this._frame == null && param1.module == UIModuleTypes.DDT_KING_WAY)
         {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("ddtKingWay.DDTKingWayMainView");
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            LayerManager.Instance.addToLayer(this._frame,3,false,1);
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
            this.closeFrame();
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.LEVELFUND)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      public function closeFrame() : void
      {
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
         }
         this._frame = null;
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
