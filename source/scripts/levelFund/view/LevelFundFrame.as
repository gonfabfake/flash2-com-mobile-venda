package levelFund.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   
   public class LevelFundFrame extends Frame
   {
      
      private var _levelFundBg:Bitmap;
      
      private var _levelFundView:LevelFundView;
      
      public function LevelFundFrame()
      {
         super();
         this.escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("levelFund.levelFundFrame.title");
         this._levelFundBg = ComponentFactory.Instance.creatBitmap("levelFund.levelFundFrame.bg");
         this._levelFundView = new LevelFundView();
         PositionUtils.setPos(this._levelFundView,"levelFund.levelFundViewPos");
         addToContent(this._levelFundBg);
         addToContent(this._levelFundView);
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._levelFundBg);
         this._levelFundBg = null;
         super.dispose();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

