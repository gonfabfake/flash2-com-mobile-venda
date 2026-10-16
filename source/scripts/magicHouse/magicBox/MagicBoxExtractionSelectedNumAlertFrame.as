package magicHouse.magicBox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class MagicBoxExtractionSelectedNumAlertFrame extends BaseAlerFrame
   {
      
      protected var _alertInfo:AlertInfo;
      
      protected var _sellFunction:Function;
      
      protected var _notSellFunction:Function;
      
      protected var _maxNum:int = 0;
      
      protected var _minNum:int = 1;
      
      protected var _nowNum:int = 1;
      
      protected var _btn1:BaseButton;
      
      protected var _btn2:BaseButton;
      
      protected var _inputText:FilterFrameText;
      
      protected var _inputBg:Image;
      
      protected var _txtExplain:Bitmap;
      
      public var index:int;
      
      private var _goodsinfo:InventoryItemInfo;
      
      public function MagicBoxExtractionSelectedNumAlertFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("magichouse.magicboxView.extractionSelectedNumTitle"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"));
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._btn1 = ComponentFactory.Instance.creat("magicbox.SellLeftAlerBt1");
         this._btn2 = ComponentFactory.Instance.creat("magicbox.SellLeftAlerBt2");
         this._txtExplain = ComponentFactory.Instance.creatBitmap("magichouse.magicbox.selectedNum");
         this._inputBg = ComponentFactory.Instance.creat("magicbox.SellLeftAlerInputTextBG");
         this._inputText = ComponentFactory.Instance.creat("magicbox.SellLeftAlerInputText");
         this._inputText.restrict = "0-9";
         addToContent(this._txtExplain);
         addToContent(this._inputBg);
         addToContent(this._btn1);
         addToContent(this._btn2);
         addToContent(this._inputText);
      }
      
      private function initEvent() : void
      {
         addEventListener("addedToStage",this.__addToStageHandler);
         this._inputText.addEventListener("change",this._changeInput);
         this._inputText.addEventListener("keyDown",this.__enterHanlder);
         addEventListener("response",this.onFrameResponse);
         this._btn1.addEventListener("click",this.click_btn1);
         this._btn2.addEventListener("click",this.click_btn2);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("addedToStage",this.__addToStageHandler);
         if(Boolean(this._inputText))
         {
            this._inputText.removeEventListener("change",this._changeInput);
         }
         if(Boolean(this._inputText))
         {
            this._inputText.removeEventListener("keyDown",this.__enterHanlder);
         }
         removeEventListener("response",this.onFrameResponse);
         if(Boolean(this._btn1))
         {
            this._btn1.removeEventListener("click",this.click_btn1);
         }
         if(Boolean(this._btn2))
         {
            this._btn2.removeEventListener("click",this.click_btn2);
         }
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._inputText.appendText(this._nowNum.toString());
         this._inputText.setFocus();
         this._upbtView();
      }
      
      private function _changeInput(param1:Event) : void
      {
         if(int(this._inputText.text) == 0)
         {
            this._nowNum = 1;
         }
         else if(int(this._inputText.text) > this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else
         {
            this._nowNum = int(this._inputText.text);
         }
         this.upSee();
      }
      
      private function __enterHanlder(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == 13)
         {
            this.__confirm();
         }
         if(param1.keyCode == 27)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function click_btn1(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nowNum += 1;
         this.upSee();
      }
      
      private function click_btn2(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._nowNum -= 1;
         this.upSee();
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
            case 4:
               if(this._notSellFunction != null)
               {
                  this._notSellFunction.call(this);
               }
               this.dispose();
               break;
            case 2:
            case 3:
               this.__confirm();
         }
      }
      
      private function _upbtView() : void
      {
         this._btn1.enable = true;
         this._btn2.enable = true;
         if(this._nowNum == this._minNum)
         {
            this._btn2.enable = false;
         }
         else if(this._nowNum == this._maxNum)
         {
            this._btn1.enable = false;
         }
      }
      
      public function upSee() : void
      {
         this._inputText.text = this._nowNum.toString();
         this._upbtView();
      }
      
      private function __confirm() : void
      {
         if(int(this._inputText.text) >= this._maxNum)
         {
            this._nowNum = this._maxNum;
         }
         else if(int(this._inputText.text) == 0)
         {
            this._nowNum = 1;
         }
         if(this._sellFunction != null)
         {
            this._sellFunction.call(this,this._nowNum,this.goodsinfo,this.index);
         }
      }
      
      public function addExeFunction(param1:Function, param2:Function) : void
      {
         this._sellFunction = param1;
         this._notSellFunction = param2;
      }
      
      public function get goodsinfo() : InventoryItemInfo
      {
         return this._goodsinfo;
      }
      
      public function set goodsinfo(param1:InventoryItemInfo) : void
      {
         this._goodsinfo = param1;
      }
      
      public function show(param1:int = 5, param2:int = 1) : void
      {
         this._maxNum = param1;
         this._minNum = param2;
         this._nowNum = this._maxNum;
         LayerManager.Instance.addToLayer(this,3,true,1);
      }
      
      private function removeView() : void
      {
         if(Boolean(this._alertInfo))
         {
            this._alertInfo = null;
         }
         if(Boolean(this._txtExplain))
         {
            ObjectUtils.disposeObject(this._txtExplain);
         }
         this._txtExplain = null;
         if(Boolean(this._inputBg))
         {
            ObjectUtils.disposeObject(this._inputBg);
         }
         this._inputBg = null;
         if(Boolean(this._btn1))
         {
            ObjectUtils.disposeObject(this._btn1);
         }
         this._btn1 = null;
         if(Boolean(this._btn2))
         {
            ObjectUtils.disposeObject(this._btn2);
         }
         this._btn2 = null;
         if(Boolean(this._inputText))
         {
            ObjectUtils.disposeObject(this._inputText);
         }
         this._inputText = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this.removeView();
         if(this._sellFunction != null)
         {
            this._sellFunction = null;
         }
         if(this._notSellFunction != null)
         {
            this._notSellFunction = null;
         }
         if(Boolean(this.parent))
         {
            removeChild(this);
         }
      }
   }
}

