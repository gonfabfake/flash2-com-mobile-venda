package godOfWealth.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import godOfWealth.GodOfWealthManager;
   import homeTemple.view.N_BitmapDataNumber;
   import org.aswing.KeyboardManager;
   import times.utils.timerManager.TimerJuggler;
   import times.utils.timerManager.TimerManager;
   
   public class GodOfWealthMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _btnPay:Scale9CornerImage;
      
      private var _detailTxt:FilterFrameText;
      
      private var _endTimeTxt:FilterFrameText;
      
      private var _endTime:Number;
      
      private var _timer:TimerJuggler;
      
      private var _numRes:N_BitmapDataNumber;
      
      private var _numTxtBitmap:Bitmap;
      
      private var _numTitleBitmap:Bitmap;
      
      public var id:int;
      
      public function GodOfWealthMainView()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         var _loc1_:int = 0;
         this._bg = ComponentFactory.Instance.creat("ast.godofwealth.bg");
         addChild(this._bg);
         this._closeBtn = ComponentFactory.Instance.creat("godOfWealth.closeBtn");
         this._closeBtn.addEventListener("click",this.onCloseClick);
         addChild(this._closeBtn);
         KeyboardManager.getInstance().addEventListener("keyDown",this.onKeyDown);
         this._btnPay = ComponentFactory.Instance.creat("asset.godOfWealth.btn");
         this._btnPay.useHandCursor = true;
         this._btnPay.buttonMode = true;
         this._btnPay.x = 300 - this._btnPay.width * 0.5;
         this._btnPay.addEventListener("rollOut",this.onOut);
         this._btnPay.addEventListener("rollOver",this.onOver);
         this._btnPay.addEventListener("mouseDown",this.onDown);
         this._btnPay.addEventListener("click",this.onPayClick);
         addChild(this._btnPay);
         var _loc2_:Vector.<BitmapData> = new Vector.<BitmapData>();
         _loc1_ = 0;
         while(_loc1_ < 10)
         {
            _loc2_[_loc1_] = ComponentFactory.Instance.creatBitmapData("ast.godofwealth.n" + _loc1_.toString());
            _loc1_++;
         }
         this._numRes = new N_BitmapDataNumber();
         this._numRes.gap = -3;
         this._numRes.numList = _loc2_;
         this._numRes.rect = new Rectangle(0,0,134,24);
         this._numTitleBitmap = ComponentFactory.Instance.creatBitmap("ast.godofwealth.txt.buy");
         PositionUtils.setPos(this._numTitleBitmap,"godOfWealth.btnTitlePos");
         addChild(this._numTitleBitmap);
         this._numTxtBitmap = new Bitmap(this._numRes.getNumber("0"));
         this._numTxtBitmap.x = this._numTitleBitmap.x + this._numTitleBitmap.width;
         this._numTxtBitmap.y = this._numTitleBitmap.y + 1;
         addChild(this._numTxtBitmap);
         this._detailTxt = ComponentFactory.Instance.creat("godOfWealth.detailText");
         addChild(this._detailTxt);
         this._endTimeTxt = ComponentFactory.Instance.creat("godOfWealth.endTimeText");
         addChild(this._endTimeTxt);
         this._endTime = GodOfWealthManager.getInstance().endTime();
         this._timer = TimerManager.getInstance().addTimer1000ms(1000);
         this._timer.addEventListener("timer",this.onEndTimeTimer);
         this._timer.start();
         this.onEndTimeTimer(null);
      }
      
      protected function onEndTimeTimer(param1:Event) : void
      {
         var _loc2_:Number = this._endTime - TimeManager.Instance.Now().time;
         this._endTimeTxt.text = Helpers.getTimeString(_loc2_);
         if(_loc2_ <= 0)
         {
            this._btnPay.mouseEnabled = false;
            Helpers.grey(this._btnPay);
         }
         else
         {
            this._btnPay.mouseEnabled = true;
            Helpers.colorful(this._btnPay);
         }
      }
      
      protected function onDown(param1:MouseEvent) : void
      {
         this._btnPay.y = 435;
         this._btnPay.alpha = 1;
      }
      
      protected function onOver(param1:MouseEvent) : void
      {
         this._btnPay.y = 434;
         this._btnPay.alpha = 0.9;
         this._btnPay.filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         this._btnPay.y = 435;
         this._btnPay.alpha = 1;
         this._btnPay.filters = [];
      }
      
      protected function onPayClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(GodOfWealthManager.getInstance().nextPayNeeded <= 0)
         {
            _loc2_ = LanguageMgr.GetTranslation("godOfWealth.alert.godIsSmiling");
            MessageTipManager.getInstance().show(_loc2_,0,true,1);
         }
         else
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            KeyboardManager.getInstance().removeEventListener("keyDown",this.onKeyDown);
            _loc2_ = LanguageMgr.GetTranslation("godOfWealth.alert",GodOfWealthManager.getInstance().nextPayNeeded);
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
            _loc3_.addEventListener("response",this.onResponse);
         }
      }
      
      protected function onResponse(param1:FrameEvent) : void
      {
         param1.target.removeEventListener("response",this.onResponse);
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 2:
            case 3:
               CheckMoneyUtils.instance.checkMoney(false,GodOfWealthManager.getInstance().nextPayNeeded,this.onChecked,this.onCanceled);
         }
         KeyboardManager.getInstance().addEventListener("keyDown",this.onKeyDown);
      }
      
      private function onCanceled() : void
      {
      }
      
      private function onChecked() : void
      {
         GameInSocketOut.sendGodOfWealthPay();
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         switch(int(param1.keyCode) - 27)
         {
            case 0:
               ObjectUtils.disposeObject(this);
         }
      }
      
      protected function onCloseClick(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      public function update() : void
      {
         var _loc1_:int = GodOfWealthManager.getInstance().nextPayNeeded;
         if(_loc1_ <= 0)
         {
            this._numTitleBitmap.bitmapData = ComponentFactory.Instance.creatBitmapData("ast.godofwealth.txt.tks");
            this._numTxtBitmap.visible = false;
            this._detailTxt.text = LanguageMgr.GetTranslation("godOfWealth.detail.timesOut");
            this._btnPay.width = this._numTitleBitmap.width + 9;
            this._btnPay.x = 300 - this._btnPay.width * 0.5;
            this._numTitleBitmap.x = 300 - this._numTitleBitmap.width * 0.5;
         }
         else
         {
            this._numTitleBitmap.bitmapData = ComponentFactory.Instance.creatBitmapData("ast.godofwealth.txt.buy");
            this._numTxtBitmap.bitmapData = this._numRes.getNumber(_loc1_.toString());
            this._numTxtBitmap.visible = true;
            this._detailTxt.text = LanguageMgr.GetTranslation("godOfWealth.detail",GodOfWealthManager.getInstance().nextRewardMin,GodOfWealthManager.getInstance().nextRewardMax);
            this._btnPay.width = this._numTitleBitmap.width + _loc1_.toString().length * 20 + 12;
            this._btnPay.x = 300 - this._btnPay.width * 0.5;
            this._numTitleBitmap.x = this._btnPay.x + 4;
            this._numTxtBitmap.x = this._numTitleBitmap.x + this._numTitleBitmap.width;
         }
         this._endTime = GodOfWealthManager.getInstance().endTime();
         this.onEndTimeTimer(null);
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         TimerManager.getInstance().removeTimer1000ms(this._timer);
         this._timer.removeEventListener("timer",this.onEndTimeTimer);
         this._timer = null;
         this._closeBtn.removeEventListener("click",this.onCloseClick);
         KeyboardManager.getInstance().removeEventListener("keyDown",this.onKeyDown);
         this._btnPay.removeEventListener("rollOut",this.onOut);
         this._btnPay.removeEventListener("rollOver",this.onOver);
         this._btnPay.removeEventListener("mouseDown",this.onDown);
         this._btnPay.removeEventListener("click",this.onPayClick);
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._closeBtn = null;
         this._closeBtn = null;
         this._detailTxt = null;
         this._numRes = null;
         this._numTxtBitmap = null;
         this._numTitleBitmap = null;
         this._endTimeTxt = null;
      }
   }
}

