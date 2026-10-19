package ddt.mobile
{
   import ddt.manager.GameManager;
   import flash.external.ExternalInterface;
   import game.actions.SelfPlayerWalkAction;
   import game.model.LocalPlayer;
   import game.objects.GameLocalPlayer;
   import game.view.map.MapView;
   import org.aswing.KeyboardManager;
   import room.model.WeaponInfo;

   /**
    * MobileInputBridge — ponte de comando entre a camada HTML (painel tátil) e
    * o jogo, via `ExternalInterface`.
    *
    * ══════════════════════════════════════════════════════════════════════════
    *  PRÉ-REQUISITO OBRIGATÓRIO (alteração de 1 linha em 2 pontos do core)
    * ══════════════════════════════════════════════════════════════════════════
    * O jogo trata movimento pelos handlers PRIVADOS de GameLocalPlayer:
    *
    *    game/objects/GameLocalPlayer.as:205  private function __turnLeft()
    *    game/objects/GameLocalPlayer.as:221  private function __turnRight()
    *
    * Eles aplicam as regras do jogo (inverter `info.direction`, respeitar
    * `_isShooting`, `isAttacking`, `_keyDownTime` e `MAX_MOVE_TIME`, e só então
    * dispara `act(new SelfPlayerWalkAction(this))`).
    *
    * NÃO os reimplementamos aqui — duplicar regra de jogo é exatamente o que
    * esta camada existe para evitar. Em vez disso, publique-os:
    *
    *    // game/objects/GameLocalPlayer.as
    *    private function __turnLeft() : void     ->   public function turnLeft() : void
    *    private function __turnRight() : void    ->   public function turnRight() : void
    *    // (mantenha os corpos __turnLeft/__turnRight intactos e chame-os)
    *
    * Assim, desktop e mobile passam a chamar EXATAMENTE o mesmo código.
    *
    * ══════════════════════════════════════════════════════════════════════════
    *  INSTALAÇÃO
    * ══════════════════════════════════════════════════════════════════════════
    * Em ddt/DDT.as, dentro de setup(), logo após a linha 321
    * (`KeyboardManager.getInstance().init(StageReferance.stage);`), acrescente:
    *
    *    if(ExternalInterface.available) MobileInputBridge.install();
    *
    * ══════════════════════════════════════════════════════════════════════════
    *  CONTRATO COM A CAMADA JS (assets/mobile/js/adapters/external-interface-adapter.js)
    * ══════════════════════════════════════════════════════════════════════════
    *    ddtMoveLeft()            → andar para a esquerda (contínuo enquanto segurar)
    *    ddtMoveRight()           → andar para a direita  (contínuo enquanto segurar)
    *    ddtAngleUp()             → +1 grau  (mesmo incremento de WeaponInfo.ROTATITON_SPEED)
    *    ddtAngleDown()           → −1 grau
    *    ddtReleaseAngle()        → fim do ajuste contínuo
    *    ddtBeginShoot()          → beginShoot(): trava o turno e inicia o carregamento
    *    ddtReleaseShoot()        → sendShootAction(force): dispara
    *    ddtGetState()            → {angulo, forca, direcao, podeAndar, podeAtirar}
    */
   public class MobileInputBridge
   {

      private static const THROTTLE_MS:int = 100;   // ArrowView.ANGLE_NEXTCHANGE_TIME (ArrowView.as:52)

      private static var _angleTimer:int = 0;
      private static var _angleDir:int = 0;
      private static var _installed:Boolean = false;

      public function MobileInputBridge()
      {
         super();
      }

      /** Registra todos os callbacks no host. Idempotente. */
      public static function install() : void
      {
         if(_installed || !ExternalInterface.available) return;
         _installed = true;
         ExternalInterface.addCallback("ddtMoveLeft", moveLeft);
         ExternalInterface.addCallback("ddtMoveRight", moveRight);
         ExternalInterface.addCallback("ddtAngleUp", angleUp);
         ExternalInterface.addCallback("ddtAngleDown", angleDown);
         ExternalInterface.addCallback("ddtReleaseAngle", releaseAngle);
         ExternalInterface.addCallback("ddtBeginShoot", beginShoot);
         ExternalInterface.addCallback("ddtReleaseShoot", releaseShoot);
         ExternalInterface.addCallback("ddtGetState", getState);
         // sinaliza à camada JS que existe uma bridge melhor que o teclado
         ExternalInterface.call("ddtBridgeReady");
      }

      /* ── movimento ───────────────────────────────────────────────────── */

      public static function moveLeft() : void
      {
         var view:GameLocalPlayer = playerView();
         if(view == null) return;
         // passa pelo MESMO caminho do teclado (GameLocalPlayer.as:205)
         view.turnLeft();
      }

      public static function moveRight() : void
      {
         var view:GameLocalPlayer = playerView();
         if(view == null) return;
         view.turnRight();
      }

      /* ── ângulo ──────────────────────────────────────────────────────── */

      public static function angleUp() : void
      {
         stepAngle(WeaponInfo.ROTATITON_SPEED);
      }

      public static function angleDown() : void
      {
         stepAngle(-WeaponInfo.ROTATITON_SPEED);
      }

      public static function releaseAngle() : void
      {
         _angleDir = 0;
      }

      /**
       * Ajuste contínuo: chamado a cada ENTER_FRAME enquanto o dedo está na
       * tela. Replica o `ArrowView.__enterFrame` (ArrowView.as:382-398),
       * incluindo o throttle de 100 ms.
       */
      public static function stepAngle(param1:Number) : void
      {
         var now:int = getTimer();
         if(now - _angleTimer < THROTTLE_MS) return;
         _angleTimer = now;

         var lp:LocalPlayer = selfPlayer();
         if(lp == null) return;
         // LocalPlayer.manuallySetGunAngle já aplica o clamp em
         // armMinAngle/armMaxAngle (LocalPlayer.as:200-234)
         lp.manuallySetGunAngle(lp.gunAngle + param1 * lp.reverse);
      }

      /* ── força / disparo ─────────────────────────────────────────────── */

      /**
       * Inicia o carregamento da força. `Player.beginShoot()` (Player.as:258)
       * é o que trava o turno; a barra é desenhada pelo EnergyView, que
       * usamos para ler o valor real em `getState()`.
       */
      public static function beginShoot() : void
      {
         var lp:LocalPlayer = selfPlayer();
         if(lp == null) return;
         if(!lp.isAttacking || !lp.isLiving) return;
         lp.beginShoot();
         lp.setCenter(lp.x, lp.y - 150, true);
      }

      /** Dispara com a força atual (ou com a informada pelo painel). */
      public static function releaseShoot(param1:Number = NaN) : void
      {
         var lp:LocalPlayer = selfPlayer();
         if(lp == null) return;
         if(!isNaN(param1)) lp.force = param1;
         lp.sendShootAction(lp.force);
      }

      /* ── estado autoritativo (substitui a previsão da barra) ─────────── */

      public static function getState() : Object
      {
         var lp:LocalPlayer = selfPlayer();
         if(lp == null) return null;
         return {
            angulo: lp.gunAngle,
            forca: lp.force,
            direcao: directionOf(lp),
            podeAndar: lp.isAttacking && lp.isLiving,
            podeAtirar: lp.isAttacking && lp.isLiving
         };
      }

      /* ── auxiliares ──────────────────────────────────────────────────── */

      private static function selfPlayer() : LocalPlayer
      {
         try
         {
            var info:* = GameManager.Instance.Current;
            return info == null ? null : (info.selfGamePlayer as LocalPlayer);
         }
         catch(err:Error)
         {
            return null;
         }
      }

      /**
       * Localiza a instância visual do jogador local (`GameLocalPlayer`),
       * criada em GameViewBase.as:582-583. Sem ela não há como chamar os
       * handlers de movimento.
       */
      private static function playerView() : GameLocalPlayer
      {
         try
         {
            var map:MapView = MapView.Instance;
            if(map == null) return null;
            var current:* = map.currentPlayer;
            return current as GameLocalPlayer;
         }
         catch(err:Error)
         {
            return null;
         }
      }

      private static function directionOf(lp:LocalPlayer) : int
      {
         try { return lp.info.direction; } catch(err:Error) { return 1; }
      }
   }
}