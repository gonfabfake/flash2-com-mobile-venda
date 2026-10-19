package homeTemple.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import homeTemple.HomeTempleController;
   
   public class HomeTempleFrame extends Frame implements Disposeable
   {
      
      private var _btnHelp:BaseButton;
      
      private var _blessing:HomeTempleBlessing;
      
      private var _levelView:HomeTempleLevel;
      
      public function HomeTempleFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__onResponse);
      }
      
      private function initView() : void
      {
         ObjectUtils.disposeObject(_closeButton);
         this._btnHelp = HelpFrameUtils.Instance.simpleHelpButton(this,"coreii.helpBtn","home.temple.helpBtnPos",LanguageMgr.GetTranslation("store.view.HelpButtonText"),"asset.home.temple.helpInfo",408,488);
         this._blessing = new HomeTempleBlessing();
         addToContent(this._blessing);
         this._levelView = new HomeTempleLevel();
         PositionUtils.setPos(this._levelView,"home.temple.blessLevelPos");
         addToContent(this._levelView);
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               HomeTempleController.Instance.hide();
         }
      }
      
      public function resetBlessingPos() : void
      {
         this._blessing.resetBlessingPos();
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__onResponse);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._btnHelp);
         this._btnHelp = null;
         ObjectUtils.disposeObject(this._blessing);
         this._blessing = null;
         ObjectUtils.disposeObject(this._levelView);
         this._levelView = null;
         super.dispose();
      }
   }
}

