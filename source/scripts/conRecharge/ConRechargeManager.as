package conRecharge
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import conRecharge.view.ConRechargeFrame;
   import ddt.CoreManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.StateManager;
   import flash.events.IEventDispatcher;
   import hallIcon.HallIconManager;
   
   public class ConRechargeManager extends CoreManager
   {
      
      private static var _instance:ConRechargeManager;
      
      public var isOpen:Boolean;
      
      private var _frame:ConRechargeFrame;
      
      private var _giftbagArray:Array;
      
      public var dayGiftbagArray:Array;
      
      public var longGiftbagArray:Array;
      
      public var beginTime:String;
      
      public var endTime:String;
      
      public var actId:String;
      
      public function ConRechargeManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : ConRechargeManager
      {
         if(!_instance)
         {
            _instance = new ConRechargeManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
      }
      
      public function loadResource() : void
      {
         if(StateManager.currentStateType == "main")
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFrame);
            UIModuleLoader.Instance.addUIModuleImp("conRecharge");
         }
      }
      
      private function createFrame(param1:UIModuleEvent) : void
      {
         if(param1.module == "conRecharge")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.createFrame);
            ConRechargeManager.instance.show();
         }
      }
      
      override protected function onLoaded() : void
      {
         this._frame = ComponentFactory.Instance.creatCustomObject("conRecharge.ConRechargeFrame");
         this._frame.titleText = LanguageMgr.GetTranslation("ddt.conRecharge.title");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      public function showIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("conRecharge",this.isOpen);
      }
      
      public function set giftbagArray(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         this._giftbagArray = param1;
         this.dayGiftbagArray = [];
         this.longGiftbagArray = [];
         _loc3_ = 0;
         while(_loc3_ < this._giftbagArray.length)
         {
            _loc4_ = this._giftbagArray[_loc3_];
            if(_loc4_.giftConditionArr[0].conditionIndex == 1)
            {
               this.dayGiftbagArray.push(_loc4_);
            }
            else
            {
               _loc2_ = [];
               _loc5_ = 0;
               while(true)
               {
                  if(_loc5_ >= this.longGiftbagArray.length)
                  {
                     _loc2_.push(_loc4_);
                     this.longGiftbagArray.push(_loc2_);
                     break;
                  }
                  if(_loc4_.giftConditionArr[0].conditionValue == this.longGiftbagArray[_loc5_][0].giftConditionArr[0].conditionValue)
                  {
                     this.longGiftbagArray[_loc5_].push(_loc4_);
                     break;
                  }
                  _loc5_++;
               }
            }
            _loc3_++;
         }
      }
   }
}

