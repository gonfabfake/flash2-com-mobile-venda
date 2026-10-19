package ddt.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CheckWeaponManager
   {
      
      private static var _instance:CheckWeaponManager;
      
      private var _alert:BaseAlerFrame;
      
      private var _skipCheck:Boolean;
      
      private var _funcObject:Object;
      
      private var _func:Function;
      
      private var _funcArgs:Array;
      
      public function CheckWeaponManager()
      {
         super();
      }
      
      public static function get instance() : CheckWeaponManager
      {
         if(!_instance)
         {
            _instance = new CheckWeaponManager();
         }
         return _instance;
      }
      
      public function setFunction(param1:Object, param2:Function = null, param3:Array = null) : void
      {
         this._funcObject = param1;
         this._func = param2;
         this._funcArgs = param3;
      }
      
      public function isNoWeapon() : Boolean
      {
         if(!this._skipCheck && PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
         {
            return true;
         }
         return false;
      }
      
      public function isNoWeaponFragment() : Boolean
      {
         if(!this._skipCheck && PlayerManager.Instance.Self.Bag.getItemAt(20) == null)
         {
            return true;
         }
         return false;
      }
      
      public function showFragmentAlert() : void
      {
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.battleRoom.noWeaponFragment"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true);
         this._alert.addEventListener("response",this.onWeaponFragmentResponse);
      }
      
      private function onWeaponFragmentResponse(param1:FrameEvent) : void
      {
         this._alert.removeEventListener("response",this.onWeaponFragmentResponse);
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            this._funcArgs.push(true);
         }
         else
         {
            this._funcArgs.push(false);
         }
         this.callBack();
      }
      
      public function showGoShopAlert() : void
      {
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.ToShopConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2);
         this._alert.addEventListener("response",this.__confirmToShopResponse);
      }
      
      private function __confirmToShopResponse(param1:FrameEvent) : void
      {
         this._alert.removeEventListener("response",this.__confirmToShopResponse);
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            StateManager.setState("shop");
         }
      }
      
      public function showAlert() : void
      {
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true);
         this._alert.addEventListener("response",this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            this._skipCheck = true;
            this.callBack();
         }
         this._alert.removeEventListener("response",this.onFrameResponse);
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
      }
      
      private function callBack() : void
      {
         if(this._funcObject != null && this._func != null)
         {
            this._func.apply(this._funcObject,this._funcArgs);
         }
         this._funcObject = null;
         this._func = null;
         this._funcArgs = null;
         this._skipCheck = false;
      }
   }
}

