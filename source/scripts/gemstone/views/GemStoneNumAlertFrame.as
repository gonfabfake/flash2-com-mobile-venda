package gemstone.views
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GemStoneNumAlertFrame extends BaseAlerFrame
   {
      
      private var _alertInfo:AlertInfo;
      
      private var _cellBg:ScaleBitmapImage;
      
      private var _cell:BagCell;
      
      private var _descript:FilterFrameText;
      
      private var _inputBg:Scale9CornerImage;
      
      private var _inputTxt:FilterFrameText;
      
      private var _maxBtn:SimpleBitmapButton;
      
      private var maxLimit:int;
      
      private var submitFunc:Function;
      
      public function GemStoneNumAlertFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.gemstone.alertFrame.title"),LanguageMgr.GetTranslation("ok"),"",true,false);
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         escEnable = true;
         this._cellBg = ComponentFactory.Instance.creatComponentByStylename("ddtcore.CellBg");
         PositionUtils.setPos(this._cellBg,"gemstone.alertFrame.cellbgPos");
         addToContent(this._cellBg);
         var _loc1_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(100100);
         this._cell = new BagCell(0,_loc1_);
         PositionUtils.setPos(this._cell,"gemstone.alertFrame.cellPos");
         var _loc2_:BagInfo = PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG);
         this.maxLimit = _loc2_.getItemCountByTemplateId(100100);
         this._cell.setCount(this.maxLimit);
         addToContent(this._cell);
         this._descript = ComponentFactory.Instance.creatComponentByStylename("gemstone.alertFrame.descriptTxt");
         this._descript.text = LanguageMgr.GetTranslation("ddt.gemstone.alertFrame.descript");
         addToContent(this._descript);
         this._inputBg = ComponentFactory.Instance.creatComponentByStylename("gemstone.alertFrame.inputBg");
         addToContent(this._inputBg);
         this._inputTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.alertFrame.inputTxt");
         this._inputTxt.text = "1";
         this._inputTxt.restrict = "0-9";
         addToContent(this._inputTxt);
         this._maxBtn = ComponentFactory.Instance.creatComponentByStylename("gemstone.alertFrame.maxBtn");
         addToContent(this._maxBtn);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
         this._inputTxt.addEventListener(Event.CHANGE,this.__inputChange);
         this._maxBtn.addEventListener(MouseEvent.CLICK,this.__maxBtnClick);
      }
      
      protected function __maxBtnClick(param1:MouseEvent) : void
      {
         this._inputTxt.text = this.maxLimit.toString();
      }
      
      protected function __inputChange(param1:Event) : void
      {
         var _loc2_:int = parseInt(this._inputTxt.text);
         if(_loc2_ <= 0)
         {
            this._inputTxt.text = "1";
         }
         else if(_loc2_ > this.maxLimit)
         {
            this._inputTxt.text = this.maxLimit.toString();
         }
      }
      
      protected function _response(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
               _loc2_ = parseInt(this._inputTxt.text);
               this.submitFunc(_loc2_);
               break;
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
         }
         ObjectUtils.disposeObject(this);
      }
      
      public function callBack(param1:Function) : void
      {
         this.submitFunc = param1;
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._inputTxt.removeEventListener(Event.CHANGE,this.__inputChange);
         this._maxBtn.removeEventListener(MouseEvent.CLICK,this.__maxBtnClick);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeObject(this._cellBg);
         ObjectUtils.disposeObject(this._cell);
         ObjectUtils.disposeObject(this._descript);
         ObjectUtils.disposeObject(this._inputBg);
         ObjectUtils.disposeObject(this._inputTxt);
         ObjectUtils.disposeObject(this._maxBtn);
         super.dispose();
      }
   }
}

