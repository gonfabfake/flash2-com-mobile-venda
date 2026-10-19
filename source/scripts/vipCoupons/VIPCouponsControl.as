package vipCoupons
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.data.UIModuleTypes;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import vip.VipController;
   import vipCoupons.view.VIPCouponsFrame;
   
   public class VIPCouponsControl extends EventDispatcher
   {
      
      private static var _instance:VIPCouponsControl;
      
      private var _frame:VIPCouponsFrame;
      
      private var _baseAlerFrame:BaseAlerFrame;
      
      private var _bagType:int;
      
      private var _place:int;
      
      private var _useType:int;
      
      public function VIPCouponsControl(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : VIPCouponsControl
      {
         if(_instance == null)
         {
            _instance = new VIPCouponsControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         VIPCouponsManager.instance.addEventListener("vipCouponesOpenView",this.__openViewHandler);
         VIPCouponsManager.instance.addEventListener("useVipCoupons",this.__useVipCouponsHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CARD_USE,this.__tasteVipCouponsHandler);
      }
      
      private function __openViewHandler(param1:CEvent) : void
      {
         this._bagType = param1.data[0];
         this._place = param1.data[1];
         this._useType = param1.data[2];
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.openFrame);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.VIP_COUPONS);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.VIP_COUPONS)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function openFrame(param1:UIModuleEvent) : void
      {
         var _loc2_:VIPCouponsFrame = null;
         if(param1.module == UIModuleTypes.VIP_COUPONS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.openFrame);
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("vipCoupons.mainFrame",[this._bagType,this._place,this._useType]);
            LayerManager.Instance.addToLayer(_loc2_,3,true,1,true);
         }
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
         }
      }
      
      private function getItemCount(param1:int) : int
      {
         return PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(param1);
      }
      
      private function __useVipCouponsHandler(param1:CEvent) : void
      {
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener("response",this.__frameEvent);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         this._bagType = param1.data[0];
         this._place = param1.data[1];
         this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("game.vipCoupons.useVipCouponsMgs"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2);
         this._baseAlerFrame.addEventListener("response",this.__frameEvent);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         var _loc2_:* = null;
         SoundManager.instance.play("008");
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener("response",this.__frameEvent);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         if(param1.responseCode == 3)
         {
            _loc2_ = ItemManager.fillByID(12569);
            SocketManager.Instance.out.sendUseCard(this._bagType,this._place,[_loc2_.TemplateID],_loc2_.PayType);
         }
      }
      
      private function __tasteVipCouponsHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PackageIn = null;
         var _loc2_:* = null;
         this._useType = (_loc3_ = param1.pkg).readInt();
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:Date = TimeManager.Instance.Now();
         if(this._useType == 0)
         {
            PlayerManager.Instance.Self.vipDiscount = _loc4_;
            PlayerManager.Instance.Self.vipDiscountValidity = _loc5_;
            _loc2_ = LanguageMgr.GetTranslation("game.vipCoupons.tasteVipCouponsMgs",10 - _loc4_);
         }
         if(this._useType == 1)
         {
            PlayerManager.Instance.Self.ddtkingDiscount = _loc4_;
            PlayerManager.Instance.Self.ddtkingDiscountValidity = _loc5_;
            _loc2_ = LanguageMgr.GetTranslation("tank.ddtkingCoupons.tasteCouponsMgs",_loc4_);
         }
         this._baseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2);
         this._baseAlerFrame.addEventListener("response",this.__tasteVipHandler);
      }
      
      private function __tasteVipHandler(param1:FrameEvent) : void
      {
         if(Boolean(this._baseAlerFrame))
         {
            this._baseAlerFrame.removeEventListener("response",this.__tasteVipHandler);
            this._baseAlerFrame.dispose();
            this._baseAlerFrame = null;
         }
         if(param1.responseCode == 3)
         {
            if(this._useType == 0)
            {
               VipController.instance.show();
            }
            if(this._useType == 1)
            {
            }
         }
      }
      
      public function dispose() : void
      {
      }
   }
}

