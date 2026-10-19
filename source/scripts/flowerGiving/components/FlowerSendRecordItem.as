package flowerGiving.components
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flowerGiving.FlowerGivingManager;
   import flowerGiving.data.FlowerSendRecordInfo;
   import flowerGiving.events.FlowerSendRecordEvent;
   
   public class FlowerSendRecordItem extends Sprite implements Disposeable
   {
      
      private var _timeTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _huikuiBtn:SimpleBitmapButton;
      
      private var _sender:String;
      
      private var _num:int;
      
      private var _receiver:String;
      
      public function FlowerSendRecordItem(param1:int)
      {
         super();
         this.initView();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,490,param1 % 2 == 0 ? Number(34) : Number(32));
         this.graphics.endFill();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.Txt");
         addChild(this._timeTxt);
         PositionUtils.setPos(this._timeTxt,"flowerGiving.flowerSendRecordFrame.timePos");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.Txt");
         addChild(this._contentTxt);
         PositionUtils.setPos(this._contentTxt,"flowerGiving.flowerSendFrame.contentPos");
         this._huikuiBtn = ComponentFactory.Instance.creatComponentByStylename("flowerGiving.flowerSendRecordFrame.huiKuiBtn");
         addChild(this._huikuiBtn);
      }
      
      public function setData(param1:FlowerSendRecordInfo) : void
      {
         this._num = param1.num;
         if(param1.flag)
         {
            this._sender = "Você";
            this._receiver = param1.nickName;
            this._huikuiBtn.visible = false;
         }
         else
         {
            this._sender = param1.nickName;
            this._receiver = "Você";
            this._huikuiBtn.visible = true;
         }
         this._contentTxt.htmlText = LanguageMgr.GetTranslation("flowerGiving.flowerSendRecordFrame.contentTxt",this._sender,this._num,this._receiver);
         this._timeTxt.text = param1.date;
      }
      
      private function addEvent() : void
      {
         this._huikuiBtn.addEventListener(MouseEvent.CLICK,this.__huikuiClick);
      }
      
      protected function __huikuiClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         FlowerGivingManager.instance.dispatchEvent(new FlowerSendRecordEvent(FlowerSendRecordEvent.HUIKUI_FLOWER,this._sender));
      }
      
      private function removeEvent() : void
      {
         this._huikuiBtn.removeEventListener(MouseEvent.CLICK,this.__huikuiClick);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.graphics.clear();
         ObjectUtils.disposeAllChildren(this);
         this._timeTxt = null;
         this._contentTxt = null;
         this._huikuiBtn = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

