package signActivity
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.CoreManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.StateManager;
   import hallIcon.HallIconManager;
   import signActivity.model.SignActivityModel;
   import signActivity.view.SignActivityFrame;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class SignActivityMgr extends CoreManager
   {
      
      private static var _instance:SignActivityMgr;
      
      private var _frame:SignActivityFrame;
      
      private var _model:SignActivityModel;
      
      private var _isOpen:Boolean = false;
      
      public function SignActivityMgr()
      {
         super();
      }
      
      public static function get instance() : SignActivityMgr
      {
         if(!_instance)
         {
            _instance = new SignActivityMgr();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new SignActivityModel();
      }
      
      public function get model() : SignActivityModel
      {
         return this._model;
      }
      
      public function loadResource() : void
      {
         if(StateManager.currentStateType == "main")
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFrame);
            UIModuleLoader.Instance.addUIModuleImp("signActivity");
         }
      }
      
      private function createFrame(param1:UIModuleEvent) : void
      {
         var _loc2_:GmActivityInfo = null;
         var _loc3_:int = 0;
         if(param1.module == "signActivity")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFrame);
            _loc2_ = WonderfulActivityManager.Instance.getActivityDataById(SignActivityMgr.instance.model.actId);
            _loc3_ = this.findSignActivityType(_loc2_.giftbagArray);
            this._frame = ComponentFactory.Instance.creatCustomObject("SignActivity.SignActivityFrame",[_loc3_]);
            this._frame.titleText = LanguageMgr.GetTranslation("ddt.SignActivity.title");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
      }
      
      private function findSignActivityType(param1:Array) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as GiftBagInfo;
            if(_loc3_.giftConditionArr[0].conditionIndex == 2)
            {
               _loc4_ = int(_loc3_.giftConditionArr[0].conditionValue);
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("signActivity",this._isOpen);
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
         this.showIcon();
      }
   }
}

