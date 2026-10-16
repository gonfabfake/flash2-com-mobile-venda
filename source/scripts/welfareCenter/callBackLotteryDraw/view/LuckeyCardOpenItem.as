package welfareCenter.callBackLotteryDraw.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawController;
   import welfareCenter.callBackLotteryDraw.CallBackLotteryDrawManager;
   
   public class LuckeyCardOpenItem extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _mc:MovieClip;
      
      private var _bagCell:BagCell;
      
      private var _orglX:int;
      
      private var _orglY:int;
      
      private var _border:MovieClip;
      
      private var _borderTweenLite:TweenLite;
      
      private var _tweenLite:TweenLite;
      
      private var _isClick:Boolean = false;
      
      private var _hasFlipOver:Boolean = false;
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _manager:CallBackLotteryDrawManager;
      
      private var _award:Object;
      
      private var _maskSp:Sprite;
      
      public function LuckeyCardOpenItem(param1:int, param2:int, param3:int)
      {
         super();
         this._index = param1;
         this._manager = CallBackLotteryDrawManager.instance;
         this._award = this._manager.luckeyLotteryDrawModel.awardArr[this._index];
         this._orglX = param2;
         this._orglY = param3;
         this._mc = ComponentFactory.Instance.creat("luckeylotterydraw.cardOpen");
         this._mc.stop();
         addChild(this._mc);
         this.mouseChildren = false;
         this._border = ComponentFactory.Instance.creat("luckeylotterydraw.cardMouseOverBorder");
         this._border.x = 4;
         this._border.y = 12;
         addChild(this._border);
         this._border.visible = false;
         this.x = this._orglX;
         this.y = this._orglY;
         this.buttonMode = true;
         this._maskSp = new Sprite();
         this.addEventListener("rollOver",this.onCardOpenMCMouseHandler);
         this.addEventListener("rollOut",this.onCardOpenMCMouseHandler);
         this.addEventListener("click",this.onCardOpenMCMouseHandler);
         CallBackLotteryDrawManager.instance.addEventListener("event_op_back_buy",this.onBuy);
      }
      
      private function onCardOpenMCMouseHandler(param1:MouseEvent) : void
      {
         var target:* = undefined;
         var onAlertFrameResponse:* = undefined;
         var onCheckComplete:* = undefined;
         var newPrice:int = 0;
         var msg:String = null;
         var _payAlert:BaseAlerFrame = null;
         var evt:MouseEvent = param1;
         var eventType:String = evt.type;
         if(this._hasFlipOver == false)
         {
            TweenLite.killTweensOf(this._border);
            TweenLite.killTweensOf(this);
            if(eventType == "click")
            {
               SoundManager.instance.playButtonSound();
               this._isClick = true;
               this._border.visible = false;
               this.y = this._orglY;
               LayerManager.Instance.addToLayer(this._maskSp,3,true,2);
               SocketManager.Instance.out.buyCallLotteryDrawGood(1,this._award["Index"],false);
            }
            else if(eventType == "rollOver")
            {
               this._border.visible = true;
               this._borderTweenLite = TweenLite.to(this._border,0.5,{"alpha":1});
               this._tweenLite = TweenLite.to(this,0.5,{"y":this._orglY - 5});
            }
            else if(eventType == "rollOut")
            {
               this._border.visible = false;
               this._borderTweenLite = TweenLite.to(this._border,0.5,{"alpha":0});
               this._tweenLite = TweenLite.to(this,0.5,{"y":this._orglY});
            }
         }
         else if(eventType == "click")
         {
            target = evt.target;
            if(target == this._buyBtn)
            {
               onAlertFrameResponse = function(param1:FrameEvent):void
               {
                  if(param1.responseCode == 3 || param1.responseCode == 2)
                  {
                     CheckMoneyUtils.instance.checkMoney(_payAlert.isBand,newPrice,onCheckComplete);
                  }
                  _payAlert.removeEventListener("response",onAlertFrameResponse);
                  ObjectUtils.disposeObject(_payAlert);
               };
               onCheckComplete = function():void
               {
                  LayerManager.Instance.addToLayer(_maskSp,3,true,2);
                  SocketManager.Instance.out.buyCallLotteryDrawGood(1,_award["Index"],CheckMoneyUtils.instance.isBind);
               };
               SoundManager.instance.playButtonSound();
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               newPrice = this._award["Cost"] * this._award["LimitCount"] / 100;
               msg = LanguageMgr.GetTranslation("callbacklotterdraw.buyGoodTip",newPrice,this._award["InventoryItemInfo"].Name);
               _payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true,1);
               _payAlert.enterEnable = false;
               _payAlert.addEventListener("response",onAlertFrameResponse);
            }
         }
      }
      
      public function playCardOpen() : void
      {
         this._hasFlipOver = true;
         this._mc.play();
         this._mc.addEventListener("enterFrame",this.onCardOpenEnterFrame);
      }
      
      private function onCardOpenEnterFrame(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(this._mc.currentFrame == 5)
         {
            this._mc.gotoAndStop(5);
            _loc2_ = CallBackLotteryDrawController.instance.getCardShowFont(this._award,"luckeylotterydraw");
            _loc2_.x = -5;
            _loc2_.y = 18;
            this._mc["c1"].addChild(_loc2_);
            this._buyBtn = UICreatShortcut.creatAndAdd("luckeylotterydraw.buyBtn",this._mc["c1"]);
            this._buyBtn.visible = this._award["IsCanGet"];
            if(!this._award["IsCanGet"])
            {
               _loc3_ = UICreatShortcut.creatAndAdd("luckeylotterydraw.pic7",this._mc);
               PositionUtils.setPos(_loc3_,"luckeylotterydraw.hasGetMask");
            }
            this._mc.play();
         }
         else if(this._mc.currentFrame == this._mc.totalFrames)
         {
            this._mc.removeEventListener("enterFrame",this.onCardOpenEnterFrame);
            this._mc.stop();
            if(this._isClick)
            {
               CallBackLotteryDrawManager.instance.dispatchEvent(new Event("click_card_open_play_over"));
            }
         }
      }
      
      public function getMCTotalFrames() : int
      {
         return this._mc.totalFrames;
      }
      
      private function onBuy(param1:CEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:Object = param1.data;
         if(_loc3_.index == this._award["Index"])
         {
            if(Boolean(_loc3_.res))
            {
               if(this._manager.luckeyLotteryDrawModel.currPhaseHasGetCount == 1)
               {
                  this.playCardOpen();
                  CallBackLotteryDrawManager.instance.dispatchEvent(new CEvent("click_card_open_item",this));
               }
               else
               {
                  this._buyBtn.visible = false;
               }
               _loc2_ = UICreatShortcut.creatAndAdd("luckeylotterydraw.pic7",this._mc);
               PositionUtils.setPos(_loc2_,"luckeylotterydraw.hasGetMask");
            }
            this._maskSp.parent.removeChild(this._maskSp);
         }
      }
      
      public function dispose() : void
      {
         this.removeEventListener("rollOver",this.onCardOpenMCMouseHandler);
         this.removeEventListener("rollOut",this.onCardOpenMCMouseHandler);
         this.removeEventListener("click",this.onCardOpenMCMouseHandler);
         CallBackLotteryDrawManager.instance.removeEventListener("event_op_back_buy",this.onBuy);
         this._mc.removeEventListener("enterFrame",this.onCardOpenEnterFrame);
         TweenLite.killTweensOf(this._border);
         TweenLite.killTweensOf(this);
         ObjectUtils.disposeAllChildren(this);
         this._mc = null;
         this._bagCell = null;
         this._border = null;
         this._borderTweenLite = null;
         this._tweenLite = null;
         this._buyBtn = null;
         this._manager = null;
         this._award = null;
         this._maskSp = null;
      }
   }
}

