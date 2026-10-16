package entertainmentMode.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class EntertainmentAlertFrame extends BaseAlerFrame
   {
      
      private var _refreshSelBtn:SelectedCheckButton;
      
      private var _content:FilterFrameText;
      
      public function EntertainmentAlertFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         this.info = _loc1_;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._refreshSelBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.custom.refreshSkill");
         addToContent(this._refreshSelBtn);
         this._refreshSelBtn.text = LanguageMgr.GetTranslation("ddt.farms.refreshPetsNOAlert");
         this._content = ComponentFactory.Instance.creatComponentByStylename("asset.game.entertainment.alertFrame.content");
         addToContent(this._content);
         this._content.text = LanguageMgr.GetTranslation("ddt.entertainmentMode.notEnoughtBandMoney");
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__framePesponse);
         this._refreshSelBtn.addEventListener("select",this.__noAlertTip);
      }
      
      private function __noAlertTip(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.isRefreshSkill = this._refreshSelBtn.selected;
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener("response",this.__framePesponse);
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
               break;
            case 2:
            case 3:
               return;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__framePesponse);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._refreshSelBtn))
         {
            ObjectUtils.disposeObject(this._refreshSelBtn);
            this._refreshSelBtn = null;
         }
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         super.dispose();
      }
   }
}

