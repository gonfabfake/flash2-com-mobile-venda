package vipCoupons
{
   import ddt.CoreManager;
   import ddt.events.CEvent;
   import flash.events.IEventDispatcher;
   
   public class VIPCouponsManager extends CoreManager
   {
      
      private static var _instance:VIPCouponsManager;
      
      public static const OPENVIEW:String = "vipCouponesOpenView";
      
      public static const USE_VIPCOUPONS:String = "useVipCoupons";
      
      private var _curCoupons:int = 0;
      
      private var _place:int;
      
      private var _bagType:int;
      
      private var _useType:int;
      
      private var _vipDiscountUseDate:Date = null;
      
      private var _vipDiscountValidity:Date = null;
      
      public function VIPCouponsManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : VIPCouponsManager
      {
         if(_instance == null)
         {
            _instance = new VIPCouponsManager();
         }
         return _instance;
      }
      
      override protected function start() : void
      {
         dispatchEvent(new CEvent("vipCouponesOpenView",[this._bagType,this._place,this._useType]));
      }
      
      public function get curCoupons() : int
      {
         return this._curCoupons;
      }
      
      public function set curCoupons(param1:int) : void
      {
         this._curCoupons = param1;
      }
      
      public function useVipCoupons(param1:int, param2:int) : void
      {
         this._bagType = param1;
         this._place = param2;
         dispatchEvent(new CEvent("useVipCoupons",[this._bagType,this._place]));
      }
      
      public function openShow(param1:int, param2:int, param3:int = 0) : void
      {
         this._bagType = param1;
         this._place = param2;
         this._useType = param3;
         show();
      }
   }
}

