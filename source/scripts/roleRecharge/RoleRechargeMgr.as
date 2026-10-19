package roleRecharge
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.UIModuleTypes;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.events.EventDispatcher;
   import roleRecharge.data.RoleRechargeInfo;
   import roleRecharge.model.RoleRechargeModel;
   import roleRecharge.view.RoleRechargeFrame;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GiftBagInfo;
   import wonderfulActivity.data.GiftConditionInfo;
   import wonderfulActivity.data.GiftCurInfo;
   import wonderfulActivity.data.GiftRewardInfo;
   
   public class RoleRechargeMgr extends EventDispatcher
   {
      
      private static var _instance:RoleRechargeMgr;
      
      private var _isAutoOpen:Boolean;
      
      private var _frame:RoleRechargeFrame;
      
      private var _model:RoleRechargeModel;
      
      private var _isOpen:Boolean = false;
      
      public function RoleRechargeMgr()
      {
         super();
      }
      
      public static function get instance() : RoleRechargeMgr
      {
         if(!_instance)
         {
            _instance = new RoleRechargeMgr();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._model = new RoleRechargeModel();
      }
      
      public function get model() : RoleRechargeModel
      {
         return this._model;
      }
      
      public function show() : void
      {
         SocketManager.Instance.out.requestWonderfulActInit(2);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.onLoaded);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ROLERECHARGE);
      }
      
      private function onLoaded(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ROLERECHARGE)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.onLoaded);
            this._frame = ComponentFactory.Instance.creatCustomObject("RoleRecharge.RoleRechargeFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("ddt.RoleRecharge.title");
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
         }
      }
      
      public function roleRechargeData(param1:Vector.<GiftRewardInfo>, param2:int) : RoleRechargeInfo
      {
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:RoleRechargeInfo = new RoleRechargeInfo();
         _loc3_ = 0;
         loop0:
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_] as GiftBagInfo;
            _loc5_ = 0;
            while(true)
            {
               if(_loc5_ >= _loc4_.giftConditionArr.length)
               {
                  _loc3_++;
                  continue loop0;
               }
               _loc6_ = _loc4_.giftConditionArr[_loc5_] as GiftConditionInfo;
               if(_loc6_.conditionIndex == 0 && _loc6_.conditionValue == param2)
               {
                  break;
               }
               _loc5_++;
            }
            _loc7_.beginIndex = _loc6_.conditionValue;
            _loc7_.endIndex = _loc6_.remain1;
            _loc7_.giftRewardArr = _loc4_.giftRewardArr.slice();
            return _loc7_;
         }
         return _loc7_;
      }
      
      public function checkAutoOpenView() : void
      {
         var _loc1_:int = 0;
         if(this._isOpen && !this._isAutoOpen && PlayerManager.Instance.Self.Grade > 10 && !this.isGetReward)
         {
            _loc1_ = SharedManager.Instance.roleRechargeOpenDay;
            this._isAutoOpen = true;
            if(TimeManager.Instance.Now().date != _loc1_)
            {
               this.show();
            }
         }
      }
      
      public function get isGetReward() : Boolean
      {
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._isOpen)
         {
            _loc1_ = RoleRechargeMgr.instance.model.actId;
            _loc2_ = WonderfulActivityManager.Instance.getActivityInitDataById(_loc1_).giftInfoDic;
            _loc3_ = WonderfulActivityManager.Instance.getActivityDataById(_loc1_);
            _loc4_ = _loc3_.giftbagArray;
            _loc5_ = 1;
            while(_loc5_ < 4)
            {
               _loc6_ = (_loc2_[_loc4_[_loc5_].giftbagId] as GiftCurInfo).times;
               if(_loc6_ > 0)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return false;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
      }
   }
}

