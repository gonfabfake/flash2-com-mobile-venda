package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.Helpers;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class DoubleSelectedItem extends Sprite implements IEventDispatcher
   {
      
      public static const BIND_TYPE:String = "bind";
      
      public static const NO_BIND_TYPE:String = "noBind";
      
      public static const EACH_TYPE:String = "each";
      
      private static const NOBIND:int = 1;
      
      private static const BIND:int = 0;
      
      private var _isBind:Boolean;
      
      private var _selectedBandBtn:SelectedCheckButton;
      
      private var _selectedBtn:SelectedCheckButton;
      
      private var _group1:SelectedButtonGroup;
      
      private var _bandMoneyTxt:FilterFrameText;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _back:MovieClip;
      
      public function DoubleSelectedItem()
      {
         super();
         this.initView();
      }
      
      public function useMoneyType(param1:String) : void
      {
         switch(param1)
         {
            case "bind":
               this._isBind = true;
               this._bandMoneyTxt.visible = true;
               this._selectedBandBtn.enable = true;
               this._selectedBandBtn.selected = true;
               this._selectedBandBtn.visible = true;
               this._moneyTxt.visible = false;
               this._selectedBtn.enable = false;
               this._selectedBtn.visible = false;
               break;
            case "noBind":
               this._isBind = false;
               this._bandMoneyTxt.visible = false;
               this._selectedBandBtn.enable = false;
               this._selectedBandBtn.visible = false;
               this._moneyTxt.visible = true;
               this._selectedBtn.enable = true;
               this._selectedBtn.selected = true;
               this._selectedBtn.visible = true;
               break;
            case "each":
               this._bandMoneyTxt.visible = true;
               this._selectedBandBtn.enable = true;
               this._selectedBandBtn.visible = true;
               this._moneyTxt.visible = true;
               this._selectedBtn.enable = true;
               this._selectedBtn.visible = true;
         }
      }
      
      public function lockMoneyType(param1:String) : void
      {
         switch(param1)
         {
            case "bind":
               this._selectedBandBtn.mouseEnabled = this._selectedBandBtn.mouseChildren = false;
               this._selectedBtn.mouseEnabled = this._selectedBtn.mouseChildren = false;
               this._selectedBtn.enable = false;
               Helpers.grey(this._selectedBtn);
               this._group1.selectIndex = 0;
               this._group1.removeEventListener("change",this.changeHander);
               break;
            case "noBind":
               this._selectedBandBtn.mouseEnabled = this._selectedBandBtn.mouseChildren = false;
               this._selectedBandBtn.enable = false;
               Helpers.grey(this._selectedBandBtn);
               this._selectedBtn.mouseEnabled = this._selectedBtn.mouseChildren = false;
               this._group1.selectIndex = 1;
               this._group1.removeEventListener("change",this.changeHander);
               break;
            case "each":
               this._selectedBandBtn.mouseEnabled = this._selectedBandBtn.mouseChildren = true;
               this._selectedBandBtn.enable = true;
               Helpers.colorful(this._selectedBandBtn);
               this._selectedBtn.mouseEnabled = this._selectedBtn.mouseChildren = true;
               this._selectedBtn.enable = true;
               Helpers.colorful(this._selectedBtn);
               this._group1.selectIndex = 0;
               this._group1.addEventListener("change",this.changeHander);
         }
      }
      
      private function initView() : void
      {
         this._back = ComponentFactory.Instance.creat("asset.core.stranDown");
         this._back.x = 0;
         this._back.y = 0;
         addChild(this._back);
         this._isBind = true;
         this._selectedBandBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBandBtn.x = 37;
         this._selectedBandBtn.y = -16;
         this._selectedBandBtn.selected = true;
         this._selectedBandBtn.mouseEnabled = false;
         addChild(this._selectedBandBtn);
         this._selectedBtn = ComponentFactory.Instance.creatComponentByStylename("vip.core.selectBtn");
         this._selectedBtn.x = -80;
         this._selectedBtn.y = -16;
         addChild(this._selectedBtn);
         this._group1 = new SelectedButtonGroup();
         this._group1.addSelectItem(this._selectedBandBtn);
         this._group1.addSelectItem(this._selectedBtn);
         this._bandMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._bandMoneyTxt.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText3");
         this._bandMoneyTxt.x = 25;
         this._bandMoneyTxt.y = -8;
         addChild(this._bandMoneyTxt);
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("vip.core.bandMoney");
         this._moneyTxt.text = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text2");
         this._moneyTxt.x = -103;
         this._moneyTxt.y = -8;
         addChild(this._moneyTxt);
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._group1.addEventListener("change",this.changeHander);
      }
      
      private function changeHander(param1:Event) : void
      {
         var _loc2_:int = this._group1.selectIndex;
         switch(int(_loc2_))
         {
            case 0:
               this._isBind = true;
               this._selectedBtn.mouseEnabled = true;
               this._selectedBandBtn.mouseEnabled = false;
               this._selectedBtn.selected = false;
               this._selectedBandBtn.selected = true;
               break;
            case 1:
               this._isBind = false;
               this._selectedBtn.mouseEnabled = false;
               this._selectedBandBtn.mouseEnabled = true;
               this._selectedBandBtn.selected = false;
               this._selectedBtn.selected = true;
         }
         dispatchEvent(new Event("change"));
      }
      
      public function get isBind() : Boolean
      {
         return this._isBind;
      }
      
      public function set isBind(param1:Boolean) : void
      {
         this._isBind = param1;
      }
      
      public function dispose() : void
      {
         this._group1.dispose();
         this._group1.removeEventListener("change",this.changeHander);
         this._isBind = false;
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

