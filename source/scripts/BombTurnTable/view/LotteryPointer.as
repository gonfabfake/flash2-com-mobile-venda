package BombTurnTable.view
{
   import BombTurnTable.event.TurnTableEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LotteryPointer extends Sprite implements Disposeable
   {
      
      private var _curType:int;
      
      private var _bg:Bitmap;
      
      private var _pointer:Bitmap;
      
      private var _pointerBorder:Bitmap;
      
      private var _lotteryBtn:BaseButton;
      
      private var _continuousBtn:BaseButton;
      
      private var _stopBtn:BaseButton;
      
      private var _curStatus:int;
      
      private var _clickNum:Number = 0;
      
      public function LotteryPointer(param1:int, param2:int)
      {
         super();
         this._curType = param1;
         this._curStatus = param2;
         this.initView();
      }
      
      private function initView() : void
      {
         switch(int(this._curType))
         {
            case 0:
               this.updatePointer(1);
               break;
            case 1:
               this.updatePointer(1);
               this.updatePointerBorder();
               break;
            case 2:
            case 3:
               this.updatePointer(2);
               this.updatePointerBorder();
         }
         this._bg = ComponentFactory.Instance.creatBitmap("asset.bombTurnTable.pointer.bg");
         if(Boolean(this._bg))
         {
            addChild(this._bg);
         }
         this.initLotteryBtn();
      }
      
      private function initLotteryBtn() : void
      {
         this._lotteryBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.bombTurnTable.lotteryIconBtn");
         this._lotteryBtn.addEventListener("click",this.clickLottery_Handler);
         addChild(this._lotteryBtn);
         this._continuousBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.bombTurnTable.lotteryIconBtn.continuous");
         this._continuousBtn.addEventListener("click",this.continuousLottery_Handler);
         addChild(this._continuousBtn);
         this._stopBtn = ComponentFactory.Instance.creatComponentByStylename("ddt.bombTurnTable.lotteryIconBtn.stop");
         this._stopBtn.addEventListener("click",this.stopLottery_Handler);
         addChild(this._stopBtn);
         this.initBtnStatus();
      }
      
      private function initBtnStatus() : void
      {
         var _loc1_:* = this._curStatus == 2;
         this._continuousBtn.visible = !_loc1_;
         this._stopBtn.visible = _loc1_;
         this._lotteryBtn.enable = !_loc1_;
      }
      
      private function clickLottery_Handler(param1:MouseEvent) : void
      {
         var _loc2_:Number = new Date().time;
         if(_loc2_ - this._clickNum < 2000)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            return;
         }
         this._clickNum = _loc2_;
         this.dispatchEvent(new TurnTableEvent("ClickLottery",1));
      }
      
      private function continuousLottery_Handler(param1:MouseEvent) : void
      {
         this.dispatchEvent(new TurnTableEvent("ClickLottery",2));
      }
      
      private function stopLottery_Handler(param1:MouseEvent) : void
      {
         this.dispatchEvent(new TurnTableEvent("ClickLottery",0));
      }
      
      public function updateBtnStatus(param1:Boolean) : void
      {
         this._continuousBtn.visible = !param1;
         this._stopBtn.visible = param1;
         this._lotteryBtn.enable = !param1;
      }
      
      private function updatePointer(param1:int) : void
      {
         this._pointer = ComponentFactory.Instance.creatBitmap("asset.bombTurnTable.pointer" + param1);
         addChild(this._pointer);
      }
      
      private function updatePointerBorder() : void
      {
         this._pointerBorder = ComponentFactory.Instance.creatBitmap("asset.bombTurnTable.pointer.border" + this._curType);
         addChild(this._pointerBorder);
      }
      
      private function removeEvents() : void
      {
         this._lotteryBtn.removeEventListener("click",this.clickLottery_Handler);
         this._continuousBtn.removeEventListener("click",this.continuousLottery_Handler);
         this._stopBtn.removeEventListener("click",this.stopLottery_Handler);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._pointerBorder))
         {
            ObjectUtils.disposeObject(this._pointerBorder);
         }
         this._pointerBorder = null;
         if(Boolean(this._pointer))
         {
            ObjectUtils.disposeObject(this._pointer);
         }
         this._pointer = null;
         if(Boolean(this._lotteryBtn))
         {
            ObjectUtils.disposeObject(this._lotteryBtn);
         }
         this._lotteryBtn = null;
         if(Boolean(this._continuousBtn))
         {
            ObjectUtils.disposeObject(this._continuousBtn);
         }
         this._continuousBtn = null;
         if(Boolean(this._stopBtn))
         {
            ObjectUtils.disposeObject(this._stopBtn);
         }
         this._stopBtn = null;
      }
   }
}

