package angelInvestment
{
   import angelInvestment.data.AngelInvestmentDataAnalyzer;
   import angelInvestment.data.AngelInvestmentModel;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.UIModuleLoader;
   import ddt.loader.StartupResourceLoader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import hallIcon.HallIconManager;
   
   public class AngelInvestmentManager extends EventDispatcher
   {
      
      private static var _instance:AngelInvestmentManager;
      
      private var _model:AngelInvestmentModel;
      
      public function AngelInvestmentManager(param1:inner)
      {
         super(null);
         this._model = new AngelInvestmentModel();
      }
      
      public static function get instance() : AngelInvestmentManager
      {
         if(_instance == null)
         {
            _instance = new AngelInvestmentManager(new inner());
         }
         return _instance;
      }
      
      public function initHall(param1:Boolean) : void
      {
         HallIconManager.instance.updateSwitchHandler("angelInvestment",param1);
      }
      
      public function onClickIcon() : void
      {
         var _loc1_:BaseLoader = StartupResourceLoader.Instance.createAngelInvestmentLoader();
         LoadResourceManager.Instance.startLoad(_loc1_);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
         UIModuleLoader.Instance.addUIModuleImp("angelInvestment");
      }
      
      private function showFrame(param1:UIModuleEvent) : void
      {
         if(param1.module == "angelInvestment")
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.showFrame);
            dispatchEvent(new Event("complete"));
         }
      }
      
      public function onDataComplete(param1:AngelInvestmentDataAnalyzer) : void
      {
         this._model.data = param1.data;
      }
      
      public function get model() : AngelInvestmentModel
      {
         return this._model;
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
