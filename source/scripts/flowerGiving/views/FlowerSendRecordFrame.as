package flowerGiving.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flowerGiving.components.FlowerSendRecordItem;
   
   public class FlowerSendRecordFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _vbox:VBox;
      
      private var _infoArr:Array;
      
      public function FlowerSendRecordFrame(param1:Array)
      {
         this._infoArr = param1;
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:FlowerSendRecordItem = null;
         this._bg = ComponentFactory.Instance.creat("flowerGiving.flowerSendRecordFrame.bg");
         addToContent(this._bg);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.vBox");
         addToContent(this._vbox);
         var _loc2_:int = 0;
         while(_loc2_ < this._infoArr.length)
         {
            _loc1_ = new FlowerSendRecordItem(_loc2_);
            if(Boolean(this._infoArr[_loc2_]))
            {
               _loc1_.setData(this._infoArr[_loc2_]);
            }
            this._vbox.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._responseHandle);
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._responseHandle);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         super.dispose();
      }
   }
}

