package panicBuying
{
   import ddt.CoreManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.TimeManager;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import panicBuying.event.PanicBuyingEvent;
   import road7th.utils.DateUtils;
   import shop.ShopEvent;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class PanicBuyingManager extends CoreManager
   {
      
      private static var _instance:PanicBuyingManager;
      
      private var requestArr:Array;
      
      public var levelId:String;
      
      private var _vipId:String;
      
      public var indivId:String;
      
      public var entireId:String;
      
      public var newEntireId:String;
      
      public var showIconFlag:int;
      
      public function PanicBuyingManager()
      {
         super();
         this.requestArr = [];
      }
      
      public static function get instance() : PanicBuyingManager
      {
         if(!_instance)
         {
            _instance = new PanicBuyingManager();
         }
         return _instance;
      }
      
      public function get vipId() : String
      {
         return this._vipId;
      }
      
      public function set vipId(param1:String) : void
      {
         this._vipId = param1;
      }
      
      public function setup() : void
      {
      }
      
      protected function __discountChange(param1:ShopEvent) : void
      {
         if(ShopManager.Instance.isHasDisCountGoods(1))
         {
            this.showIconFlag |= 1;
         }
         else
         {
            this.showIconFlag |= 0;
         }
         if(this.showIconFlag > 0)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
         }
      }
      
      public function checkOpen() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:Date = TimeManager.Instance.Now();
         var _loc2_:Dictionary = WonderfulActivityManager.Instance.activityData;
         this.showIconFlag = 0;
         this.levelId = "";
         this.vipId = "";
         this.indivId = "";
         this.entireId = "";
         this.newEntireId = "";
         for each(_loc3_ in _loc2_)
         {
            if(!(_loc3_.activityType == 19 && (_loc3_.activityChildType == 1 || _loc3_.activityChildType == 2 || _loc3_.activityChildType == 3 || _loc3_.activityChildType == 4 || _loc3_.activityChildType == 5)))
            {
               continue;
            }
            if(_loc1_.time < Date.parse(_loc3_.beginTime))
            {
               if(this.requestArr.indexOf(_loc3_.beginTime) < 0)
               {
                  this.requestArr.push(_loc3_.beginTime);
               }
            }
            if(_loc1_.time < Date.parse(_loc3_.endShowTime))
            {
               if(this.requestArr.indexOf(_loc3_.endShowTime) < 0)
               {
                  this.requestArr.push(_loc3_.endShowTime);
               }
            }
            if(!(_loc1_.time >= Date.parse(_loc3_.beginTime) && _loc1_.time <= Date.parse(_loc3_.endTime)))
            {
               continue;
            }
            switch(int(_loc3_.activityChildType) - 1)
            {
               case 0:
                  this.showIconFlag |= 2;
                  this.levelId = _loc3_.activityId;
                  break;
               case 1:
                  this.showIconFlag |= 4;
                  this.vipId = _loc3_.activityId;
                  break;
               case 2:
                  this.showIconFlag |= 8;
                  this.indivId = _loc3_.activityId;
                  break;
               case 3:
                  this.showIconFlag |= 1;
                  this.entireId = _loc3_.activityId;
                  break;
               case 4:
                  this.showIconFlag |= 16;
                  this.newEntireId = _loc3_.activityId;
            }
         }
         if(this.requestArr.length > 0)
         {
            WonderfulActivityManager.Instance.addTimerFun("panicBuyingRequest",this.reCheck);
         }
         else
         {
            WonderfulActivityManager.Instance.delTimerFun("panicBuyingRequest");
         }
         if(this.showIconFlag > 0)
         {
            this.showEnterIcon();
         }
         else
         {
            this.hideEnterIcon();
         }
      }
      
      public function reCheck() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:Number = NaN;
         var _loc4_:Date = TimeManager.Instance.Now();
         _loc1_ = 0;
         while(_loc1_ <= this.requestArr.length - 1)
         {
            _loc2_ = DateUtils.getDateByStr(this.requestArr[_loc1_]);
            _loc3_ = Math.round((_loc2_.getTime() - _loc4_.getTime()) / 1000);
            if(_loc3_ <= 0)
            {
               this.requestArr.splice(_loc1_,1);
               this.checkOpen();
               SocketManager.Instance.out.requestWonderfulActInit(2);
            }
            _loc1_++;
         }
      }
      
      private function showEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("panicBuying",true);
      }
      
      private function hideEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler("panicBuying",false);
      }
      
      public function updateView() : void
      {
         dispatchEvent(new PanicBuyingEvent("updateView"));
      }
      
      override protected function start() : void
      {
         dispatchEvent(new PanicBuyingEvent("panicBuyingOpenView"));
      }
   }
}

