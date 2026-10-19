package game.actions
{
   import flash.events.Event;
   import game.GameManager;
   import game.objects.GamePlayer;
   
   public class WeaponShootAction extends BaseAction
   {
      
      private var _player:GamePlayer;
      
      public function WeaponShootAction(param1:GamePlayer)
      {
         super();
         this._player = param1;
      }
      
      override public function prepare() : void
      {
         if(GameManager.Instance.Current.roomType == 29 || this._player.body == null || this._player.body.dynamicWeapon == null)
         {
            _isFinished = true;
            return;
         }
         this._player.body.dynamicWeapon.addEventListener("complete",this.__onPlayComplete);
         this._player.body.dynamicWeapon.gotoAndPlay("end");
      }
      
      private function __onPlayComplete(param1:Event) : void
      {
         this._player.body.dynamicWeapon.removeEventListener("complete",this.__onPlayComplete);
         this._player.body.dynamicWeapon.stop();
         this._player.body.dynamicWeapon.visible = false;
         _isFinished = true;
      }
      
      override public function execute() : void
      {
      }
   }
}

