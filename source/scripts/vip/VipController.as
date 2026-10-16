package vip
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.text.GradientText;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import vip.data.VipModelInfo;
   import vip.view.RechargeAlertTxt;
   import vip.view.VIPHelpFrame;
   import vip.view.VIPRechargeAlertFrame;
   import vip.view.VipFrame;
   import vip.view.VipViewFrame;
   
   public class VipController extends EventDispatcher
   {
      
      private static var _instance:VipController;
      
      public var info:VipModelInfo;
      
      public var isRechargePoped:Boolean;
      
      private var _vipFrame:VipFrame;
      
      private var _vipViewFrame:VipViewFrame;
      
      private var _isShow:Boolean;
      
      private var _helpframe:VIPHelpFrame;
      
      private var _rechargeAlertFrame:VIPRechargeAlertFrame;
      
      private var _rechargeAlertLoad:Boolean = false;
      
      public function VipController()
      {
         super();
      }
      
      public static function get instance() : VipController
      {
         if(!_instance)
         {
            _instance = new VipController();
         }
         return _instance;
      }
      
      public function show() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showVipFrame);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_VIP_VIEW);
      }
      
      private function showVipFrame(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.DDT_VIP_VIEW)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showVipFrame);
            this._vipFrame = ComponentFactory.Instance.creatComponentByStylename("vip.VipFrame");
            this._vipFrame.show();
            LayerManager.Instance.addToLayer(this._vipFrame,3,true,1);
         }
      }
      
      public function showRechargeAlert() : void
      {
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showRechargeAlertFrame);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDT_VIP_VIEW);
      }
      
      private function showRechargeAlertFrame(param1:UIModuleEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1.module == UIModuleTypes.DDT_VIP_VIEW)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showRechargeAlertFrame);
            _loc2_ = null;
            _loc3_ = null;
            if(this._rechargeAlertFrame == null)
            {
               this._rechargeAlertFrame = ComponentFactory.Instance.creatComponentByStylename("vip.vipRechargeAlertFrame");
               _loc2_ = PlayerManager.Instance.Self;
               _loc3_ = new RechargeAlertTxt();
               _loc3_.AlertContent = _loc2_.VIPLevel;
               this._rechargeAlertFrame.content = _loc3_;
               this._rechargeAlertFrame.show();
               this._rechargeAlertFrame.addEventListener("response",this.__responseRechargeAlertHandler);
            }
         }
      }
      
      public function helpframeNull() : void
      {
         if(Boolean(this._helpframe))
         {
            this._helpframe = null;
         }
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         this._helpframe.removeEventListener("response",this.__responseHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case 0:
            case 1:
               this._helpframe.dispose();
         }
      }
      
      protected function __responseRechargeAlertHandler(param1:FrameEvent) : void
      {
         this._rechargeAlertFrame.removeEventListener("response",this.__responseRechargeAlertHandler);
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case 0:
            case 1:
               this._rechargeAlertFrame.dispose();
         }
         if(Boolean(this._rechargeAlertFrame))
         {
            this._rechargeAlertFrame = null;
         }
      }
      
      public function sendOpenVip(param1:String, param2:int, param3:Boolean = true) : void
      {
         SocketManager.Instance.out.sendOpenVip(param1,param2,param3);
      }
      
      public function hide() : void
      {
         if(this._vipFrame != null)
         {
            this._vipFrame.dispose();
         }
         this._vipFrame = null;
      }
      
      public function getVipNameTxt(param1:int = -1, param2:int = 1) : GradientText
      {
         var _loc3_:* = null;
         switch(param2)
         {
            case 0:
               throw new Error("会员类型错误,不能为非会员玩家创建会员字体.");
            case 1:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vipName");
               break;
            case 2:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("vipName");
         }
         if(Boolean(_loc3_))
         {
            if(param1 != -1)
            {
               _loc3_.textField.width = param1;
            }
            else
            {
               _loc3_.textField.autoSize = "left";
            }
            return _loc3_;
         }
         return ComponentFactory.Instance.creatComponentByStylename("vipName");
      }
      
      public function getVIPStrengthenEx(param1:int) : Number
      {
         if(param1 - 1 < 0)
         {
            return 0;
         }
         var _loc2_:Array = ServerConfigManager.instance.VIPStrengthenEx;
         if(Boolean(_loc2_))
         {
            return _loc2_[param1 - 1];
         }
         return 0;
      }
   }
}

