package petsBag
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.manager.TaskManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import petsBag.model.PetBagModel;
   import petsBag.view.PetsView;
   import trainer.view.NewHandContainer;
   
   public class PetsBagManager extends EventDispatcher
   {
      
      private static var _instance:PetsBagManager;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private var _petView:PetsView;
      
      public var petModel:PetBagModel;
      
      public function PetsBagManager()
      {
         super();
      }
      
      public static function get instance() : PetsBagManager
      {
         if(!_instance)
         {
            _instance = new PetsBagManager();
         }
         return _instance;
      }
      
      public function show() : void
      {
         this.petModel = new PetBagModel();
         if(loadComplete)
         {
            this.showPetBagFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.PETS_BAG);
         }
      }
      
      private function showPetBagFrame() : void
      {
         PlayerInfoViewControl.isOpenFromBag = true;
         this._petView = ComponentFactory.Instance.creatComponentByStylename("petsBag.PetsView");
         this._petView.show();
      }
      
      private function __complainShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.PETS_BAG)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      protected function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__progressShow);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__complainShow);
      }
      
      public function hide() : void
      {
         if(this._petView != null)
         {
            this._petView.dispose();
         }
         this._petView = null;
      }
      
      public function isShow() : Boolean
      {
         if(Boolean(this._petView))
         {
            return true;
         }
         return false;
      }
      
      public function clearCurrentPetFarmGuildeArrow(param1:int) : void
      {
         NewHandContainer.Instance.clearArrowByID(param1);
      }
      
      public function haveTaskOrderByID(param1:int) : Boolean
      {
         return TaskManager.instance.isAvailable(TaskManager.getQuestByID(param1));
      }
      
      public function finishTask() : void
      {
         this.petModel.preShowArrowID = 0;
         this.petModel.nextShowArrowID = 0;
      }
      
      public function showPetFarmGuildArrow(param1:int, param2:int, param3:String, param4:String = "", param5:String = "", param6:* = null, param7:int = 0) : void
      {
         if(this.petModel.isLoadPetTrainer)
         {
            if(this.petModel.preShowArrowID != 0)
            {
               if(param1 != this.petModel.nextShowArrowID)
               {
                  return;
               }
            }
            this.setAvailableArrow(param1);
            if(param1 != 94)
            {
            }
         }
         else
         {
            this.petModel.CurrentPetFarmGuildeArrow = {};
            this.petModel.CurrentPetFarmGuildeArrow.id = param1;
            this.petModel.CurrentPetFarmGuildeArrow.rotation = param2;
            this.petModel.CurrentPetFarmGuildeArrow.arrowPos = param3;
            this.petModel.CurrentPetFarmGuildeArrow.tip = param4;
            this.petModel.CurrentPetFarmGuildeArrow.tipPos = param5;
            this.petModel.CurrentPetFarmGuildeArrow.con = param6;
            this.loadPetsGuildeUI(this.showLoadedArrow);
         }
      }
      
      private function showLoadedArrow(param1:Object) : void
      {
         if(param1.id != 94 && param1.id != 119 && param1.id != 100)
         {
            NewHandContainer.Instance.showArrow(param1.id,param1.rotation,param1.arrowPos,param1.tip,param1.tipPos,param1.con,0,true);
         }
      }
      
      private function setAvailableArrow(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         loop0:
         for each(_loc2_ in this.petModel.petGuilde)
         {
            var _loc6_:int = 0;
            var _loc7_:* = _loc2_;
            do
            {
               for each(_loc3_ in _loc7_)
               {
               }
               continue loop0;
            }
            while(_loc3_.arrowID != param1);
            _loc3_.isFinish = true;
            this.petModel.nextShowArrowID = _loc3_.NextArrowID;
            this.petModel.preShowArrowID = _loc3_.PreArrowID;
            return true;
         }
         return false;
      }
      
      private function loadPetsGuildeUI(param1:Function) : void
      {
         var __Finish:Function = null;
         var callBack:Function = param1;
         __Finish = function(param1:UIModuleEvent):void
         {
            if(param1.module == "farmPetTrainerUI")
            {
               UIModuleLoader.Instance.removeEventListener("uiModuleComplete",__Finish);
               petModel.isLoadPetTrainer = true;
               if(Boolean(petModel.CurrentPetFarmGuildeArrow))
               {
                  callBack(petModel.CurrentPetFarmGuildeArrow);
               }
            }
         };
         UIModuleLoader.Instance.addUIModuleImp("farmPetTrainerUI");
         UIModuleLoader.Instance.addEventListener("uiModuleComplete",__Finish);
      }
   }
}

