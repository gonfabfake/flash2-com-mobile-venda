package prayIndiana
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import prayIndiana.view.PrayIndianaFrame;
   
   public class PrayIndianaController
   {
      
      private static var _instance:PrayIndianaController;
      
      private var _pray:PrayIndianaFrame;
      
      public function PrayIndianaController(param1:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : PrayIndianaController
      {
         if(PrayIndianaController._instance == null)
         {
            PrayIndianaController._instance = new PrayIndianaController(new PrivateClass());
         }
         return PrayIndianaController._instance;
      }
      
      public function setup() : void
      {
         PrayIndianaManager.Instance.addEventListener("prayindianaOpenFrame",this.__onPrayIndianaOpenFrame);
         PrayIndianaManager.Instance.addEventListener("updateLotterynumber",this.__onUpdateLotteryNumber);
         PrayIndianaManager.Instance.addEventListener("updatelottery",this.__onUpdateLottery);
         PrayIndianaManager.Instance.addEventListener("prayindianaDispose",this.__onPrayIndianaDispose);
      }
      
      private function __onPrayIndianaDispose(param1:Event) : void
      {
         if(this._pray != null && PrayIndianaManager.Instance.model.isOpen)
         {
            ObjectUtils.disposeObject(this._pray);
            this._pray = null;
         }
      }
      
      private function __onUpdateLottery(param1:Event) : void
      {
         if(this._pray != null)
         {
            this._pray.updateLotteryNumber();
            this._pray.goodsJump();
         }
      }
      
      private function __onUpdateLotteryNumber(param1:Event) : void
      {
         if(this._pray != null)
         {
            this._pray.updateLotteryNumber();
         }
      }
      
      private function __onPrayIndianaOpenFrame(param1:Event) : void
      {
         if(this._pray != null)
         {
            ObjectUtils.disposeObject(this._pray);
            this._pray = null;
         }
         this._pray = ComponentFactory.Instance.creatComponentByStylename("PrayIndianaManager.PrayIndianaFrame");
         LayerManager.Instance.addToLayer(this._pray,3,true,1);
      }
   }
}

class PrivateClass
{
   
   public function PrivateClass()
   {
      super();
   }
}
