package angelInvestment
{
   import angelInvestment.view.AngelInvestmentMainView;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   
   public class AngelInvestmentController
   {
      
      private static var _instance:AngelInvestmentController;
      
      private var _frame:AngelInvestmentMainView;
      
      public function AngelInvestmentController(param1:inner)
      {
         super();
      }
      
      public static function get instance() : AngelInvestmentController
      {
         if(_instance == null)
         {
            _instance = new AngelInvestmentController(new inner());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         AngelInvestmentManager.instance.addEventListener("complete",this.__onComplete);
      }
      
      private function __onComplete(param1:Event) : void
      {
         this._frame = ComponentFactory.Instance.creatComponentByStylename("angelInvestment.mainView");
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
         this._frame.show();
      }
      
      private function __onFrameClose(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._frame.dispose();
         }
      }
      
      public function get buyAllDay() : int
      {
         return ServerConfigManager.instance.angelInvestmentDay;
      }
      
      public function get buyAllDiscount() : int
      {
         return ServerConfigManager.instance.angelInvestmentDiscount;
      }
      
      public function get buyAllPrice() : int
      {
         return ServerConfigManager.instance.angelInvestmentAllPrice;
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
