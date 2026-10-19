package moneyTree
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.CoreController;
   import ddt.ICoreCtrller;
   import ddt.events.CEvent;
   import ddt.utils.HelperUIModuleLoad;
   import moneyTree.view.MoneyTreeMainFrame;
   
   public class MoneyTreeController extends CoreController implements ICoreCtrller
   {
      
      private static var instance:MoneyTreeController;
      
      private var _manager:MoneyTreeManager;
      
      private var _frame:MoneyTreeMainFrame;
      
      public function MoneyTreeController()
      {
         super();
      }
      
      public static function getInstance() : MoneyTreeController
      {
         if(!instance)
         {
            instance = new MoneyTreeController();
         }
         return instance;
      }
      
      public function setup() : void
      {
         this._manager = MoneyTreeManager.getInstance();
         var _loc1_:Array = ["mt_show_main_frame","mt_hide_main_frame","mt_update_info","mt_update_remain","mt_reset_friends_list","mt_pick_movie","mt_speedup_suc","mt_set_focus"];
         addEvents(_loc1_,this._manager);
      }
      
      override protected function eventsHandler(param1:CEvent) : void
      {
         switch(param1.type)
         {
            case "mt_show_main_frame":
               this.showMainFrame();
               break;
            case "mt_hide_main_frame":
               this.hideMainFrame();
               break;
            case "mt_update_info":
               this.updateViewByInfo();
               break;
            case "mt_update_remain":
               this.updateRemainNum();
               break;
            case "mt_reset_friends_list":
               this.resetFriendList();
               break;
            case "mt_pick_movie":
               this.onPick(int(param1.data));
               break;
            case "mt_speedup_suc":
               this.onSpeedUpSuc();
               break;
            case "mt_set_focus":
               this.setFocus();
         }
      }
      
      private function onSpeedUpSuc() : void
      {
         this._frame.playFly();
      }
      
      private function onPick(param1:int) : void
      {
         this._frame.pick(param1);
      }
      
      private function resetFriendList() : void
      {
         if(!this._frame || !this._frame.parent)
         {
            return;
         }
         this._frame.resetFriendList();
      }
      
      private function updateRemainNum() : void
      {
         this._frame.updateRemainNum();
      }
      
      private function updateViewByInfo() : void
      {
         if(!this._frame || !this._frame.parent)
         {
            return;
         }
         this._frame.updateRemainNum();
         this._frame.updateFruits();
      }
      
      private function hideMainFrame() : void
      {
         if(this._frame != null)
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
      }
      
      private function showMainFrame() : void
      {
         new HelperUIModuleLoad().loadUIModule(["moneyTree","ddtinvite"],this.onLoaded);
      }
      
      private function onLoaded() : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("moneyTree.mainframe");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
         this._manager.requireUpdateInfo();
      }
      
      private function setFocus() : void
      {
         if(Boolean(this._frame) && Boolean(this._frame.parent))
         {
            StageReferance.stage.focus = this._frame;
         }
      }
      
      public function BecomeMature() : void
      {
         this._frame.updateFruits();
      }
   }
}

