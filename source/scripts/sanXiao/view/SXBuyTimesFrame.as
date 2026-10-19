package sanXiao.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class SXBuyTimesFrame extends BaseAlerFrame
   {
      
      public var buyFunction:Function;
      
      public var clickFunction:Function;
      
      private var _timesSelector:NumberSelecter;
      
      private var _txt:FilterFrameText;
      
      private var _target:Sprite;
      
      public var autoClose:Boolean = true;
      
      private var _timesLabel:FilterFrameText;
      
      public function SXBuyTimesFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      public function set target(param1:Sprite) : void
      {
         this._target = param1;
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText"),LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText"));
         info = _loc1_;
         this._timesSelector = ComponentFactory.Instance.creatCustomObject("ddtcore.numberSelecter");
         this._timesSelector.needFocus = false;
         this._timesSelector.setNumberTxt(false);
         this._timesSelector.x = 157;
         this._timesSelector.y = 84;
         this._timesSelector.number = 10;
         this._timesSelector.minimum = 10;
         this._timesSelector.maximum = 90;
         this._timesSelector.times = 10;
         addToContent(this._timesSelector);
         this._timesLabel = ComponentFactory.Instance.creat("sanxiao.TimesLabelbt");
         addToContent(this._timesLabel);
         this._txt = ComponentFactory.Instance.creatComponentByStylename("core.alert.txt");
         addToContent(this._txt);
         this.onMoneyChange(null);
      }
      
      private function initEvents() : void
      {
         addEventListener("response",this.responseHander);
         this._timesSelector.addEventListener("change",this.onMoneyChange);
      }
      
      protected function onMoneyChange(param1:Event) : void
      {
         var _loc2_:int = int(ServerConfigManager.instance.SanXiaoStepPrice());
         var _loc3_:Number = this._timesSelector.number * _loc2_;
         var _loc4_:String = LanguageMgr.GetTranslation("money");
         this._timesLabel.text = LanguageMgr.GetTranslation("sanxiao.buyTimesLabel",_loc3_,_loc4_,this._timesSelector.number.toString());
      }
      
      private function removeEvnets() : void
      {
         removeEventListener("response",this.responseHander);
         this._timesSelector.removeEventListener("change",this.onMoneyChange);
      }
      
      private function responseHander(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            if(this.buyFunction != null)
            {
               this.buyFunction(this._timesSelector.number,false);
            }
            if(this.autoClose)
            {
               this.dispose();
            }
         }
         else if(param1.responseCode == 0 || param1.responseCode == 1 || param1.responseCode == 4)
         {
            this.dispose();
         }
      }
      
      public function setTxt(param1:String) : void
      {
         this._txt.text = param1;
      }
      
      override public function dispose() : void
      {
         this.buyFunction = null;
         this.clickFunction = null;
         this.removeEvnets();
         while(Boolean(_container.numChildren))
         {
            ObjectUtils.disposeObject(_container.getChildAt(0));
         }
         super.dispose();
         this._timesSelector = null;
         this._timesLabel = null;
      }
   }
}

