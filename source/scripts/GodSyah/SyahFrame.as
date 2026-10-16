package GodSyah
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   
   public class SyahFrame extends Frame
   {
      
      private var _view:SyahView;
      
      public function SyahFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.GodSyah.tip.tipName");
         this._view = new SyahView();
         this._view.x = -225;
         this._view.y = -3;
         addToContent(this._view);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._view))
         {
            this._view.dispose();
            this._view = null;
         }
         super.dispose();
      }
   }
}

