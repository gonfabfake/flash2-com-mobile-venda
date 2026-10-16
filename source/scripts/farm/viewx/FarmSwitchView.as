package farm.viewx
{
   import ddt.manager.ChatManager;
   import ddt.states.BaseStateView;
   import ddt.view.MainToolBar;
   import farm.FarmModelController;
   import petsBag.PetsBagManager;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   
   public class FarmSwitchView extends BaseStateView
   {
      
      private var _farmMainView:FarmMainView;
      
      public function FarmSwitchView()
      {
         super();
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         super.enter(param1,param2);
         this._farmMainView = new FarmMainView();
         addChild(this._farmMainView);
         MainToolBar.Instance.show();
         ChatManager.Instance.lock = ChatManager.HALL_CHAT_LOCK;
         addChild(ChatManager.Instance.view);
         PetsBagManager.instance.addEventListener("finish",this.__updatePetFarmGuilde);
         FarmModelController.instance.creatSuperPetFoodPriceList();
      }
      
      private function __updatePetFarmGuilde(param1:UpdatePetFarmGuildeEvent) : void
      {
         PetsBagManager.instance.finishTask();
         this.petFarmGuilde();
      }
      
      private function petFarmGuilde() : void
      {
         if(PetsBagManager.instance.haveTaskOrderByID(368))
         {
            PetsBagManager.instance.showPetFarmGuildArrow(94,50,"farmTrainer.openPetBagArrowPos","asset.farmTrainer.clickHere","farmTrainer.openPetBagTipPos",this);
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         PetsBagManager.instance.removeEventListener("finish",this.__updatePetFarmGuilde);
         super.leaving(param1);
         FarmModelController.instance.stopTimer();
         MainToolBar.Instance.hide();
         this.dispose();
      }
      
      override public function getBackType() : String
      {
         return "main";
      }
      
      override public function getType() : String
      {
         return "farm";
      }
      
      override public function refresh() : void
      {
         super.refresh();
      }
      
      override public function dispose() : void
      {
         this._farmMainView.dispose();
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

