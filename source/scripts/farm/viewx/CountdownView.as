package farm.viewx
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import farm.FarmModelController;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CountdownView extends Sprite
   {
      
      private var _fastForward:BaseButton;
      
      private var _fieldID:int;
      
      public function CountdownView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._fastForward = ComponentFactory.Instance.creatComponentByStylename("farm.fastForwardBtn");
         addChild(this._fastForward);
      }
      
      public function setCountdown(param1:int) : void
      {
         this._fieldID = param1;
      }
      
      public function setFastBtnEnable(param1:Boolean) : void
      {
         this._fastForward.visible = param1;
      }
      
      private function initEvent() : void
      {
         this._fastForward.addEventListener("click",this.__fastBtnClick);
      }
      
      protected function __fastBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.visible = false;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.farms.fastForwardInfo",FarmModelController.instance.gropPrice),"",LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",30,true,0);
         _loc2_.addEventListener("response",this.__onResponse);
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         var _loc3_:Boolean = (param1.target as BaseAlerFrame).isBand;
         (param1.target as BaseAlerFrame).removeEventListener("response",this.__onResponse);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.responseCode == 2 || param1.responseCode == 3)
         {
            _loc2_ = FarmModelController.instance.gropPrice;
            SocketManager.Instance.out.fastForwardGrop(_loc3_,false,this._fieldID);
         }
      }
      
      private function remvoeEvent() : void
      {
         this._fastForward.removeEventListener("click",this.__fastBtnClick);
      }
      
      public function dispose() : void
      {
         this.remvoeEvent();
         if(Boolean(this._fastForward))
         {
            this._fastForward.dispose();
            this._fastForward = null;
         }
      }
   }
}

