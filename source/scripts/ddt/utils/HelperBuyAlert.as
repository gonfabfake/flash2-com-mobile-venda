package ddt.utils
{
   public class HelperBuyAlert
   {
      
      private static var instance:HelperBuyAlert;
      
      public function HelperBuyAlert(param1:inner)
      {
         super();
      }
      
      public static function getInstance() : HelperBuyAlert
      {
         if(!instance)
         {
            instance = new HelperBuyAlert(new inner());
         }
         return instance;
      }
      
      public function alert(param1:String, param2:ConfirmAlertData, param3:String = null, param4:Function = null, param5:Function = null, param6:Function = null, param7:int = 1, param8:int = 0) : ConfirmAlertHelper
      {
         var _loc10_:ConfirmAlertHelper = null;
         var _loc9_:* = null;
         if(param3 == null)
         {
            _loc9_ = "SimpleAlert";
         }
         else
         {
            _loc9_ = param3;
         }
         _loc10_ = new ConfirmAlertHelper(param2);
         _loc10_.onConfirm = param5;
         _loc10_.onCheckOut = param4;
         _loc10_.onCancel = param6;
         _loc10_.alert("Aviso：",param1,"O K","Cancelar",false,true,false,2,null,_loc9_,30,true,param7,param8);
         return _loc10_;
      }
   }
}

class inner
{
   
   public function inner()
   {
      super();
   }
}
