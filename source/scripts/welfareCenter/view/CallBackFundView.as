package welfareCenter.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import welfareCenter.callBackFund.CallBackFundManager;
   
   public class CallBackFundView extends Sprite implements Disposeable
   {
      
      private var _btnSp:Sprite;
      
      private var _quickBuyBtn:SimpleBitmapButton;
      
      private var _quickReceiveBtn:SimpleBitmapButton;
      
      private var _tomorrowComeBtn:SimpleBitmapButton;
      
      private var _receiveOverBtn:SimpleBitmapButton;
      
      private var _callBackFunMgr:CallBackFundManager;
      
      private var _rewardsHBox:HBox;
      
      private var _rewardsHBox1:HBox;
      
      public function CallBackFundView()
      {
         super();
         this._callBackFunMgr = CallBackFundManager.instance;
         this.initView();
         this.initEvent();
         this.update(null);
      }
      
      private function initView() : void
      {
         var _loc3_:Date = null;
         UICreatShortcut.creatAndAdd("callBackFund.bg",this);
         var _loc1_:Date = this._callBackFunMgr.startTime;
         var _loc2_:String = _loc1_.fullYear + "." + (_loc1_.month + 1) + "." + _loc1_.date;
         _loc3_ = this._callBackFunMgr.endTime;
         var _loc4_:String = _loc3_.fullYear + "." + (_loc3_.month + 1) + "." + _loc3_.date;
         UICreatShortcut.creatTextAndAdd("callbackfund.openTimeTf",_loc2_ + "-" + _loc4_,this);
         var _loc5_:String = LanguageMgr.GetTranslation("callBackFund.frame.contentText",this._callBackFunMgr.buyFundCount,6);
         UICreatShortcut.creatTextAndAdd("callbackfund.contentTf",_loc5_,this);
         this._btnSp = new Sprite();
         addChild(this._btnSp);
         this.setGoods();
      }
      
      private function setGoods() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:Array = CallBackFundManager.instance.dailyRewardInfoList;
         if(Boolean(_loc5_))
         {
            this._rewardsHBox = ComponentFactory.Instance.creatComponentByStylename("callBackFund.dailyView.rewardsHBox");
            addChild(this._rewardsHBox);
            _loc1_ = 0;
            while(_loc1_ < _loc5_.length)
            {
               _loc2_ = CallBackFundManager.instance.createCell(_loc5_[_loc1_]);
               this._rewardsHBox.addChild(_loc2_);
               _loc1_++;
            }
         }
         var _loc6_:Array = CallBackFundManager.instance.downRewardInfoList;
         if(Boolean(_loc6_))
         {
            this._rewardsHBox1 = ComponentFactory.Instance.creatComponentByStylename("callBackFund.downView.rewardsHBox");
            addChild(this._rewardsHBox1);
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               _loc4_ = CallBackFundManager.instance.createCell(_loc6_[_loc3_]);
               this._rewardsHBox1.addChild(_loc4_);
               _loc3_++;
            }
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.responseHandler);
         addEventListener("click",this.onBtnClick);
         CallBackFundManager.instance.addEventListener("event_state_change",this.update);
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.responseHandler);
         removeEventListener("click",this.onBtnClick);
         CallBackFundManager.instance.removeEventListener("event_state_change",this.update);
      }
      
      private function update(param1:Event) : void
      {
         ObjectUtils.removeChildAllChildren(this._btnSp);
         var _loc2_:int = CallBackFundManager.instance.state;
         if(_loc2_ == 0)
         {
            this._quickBuyBtn = UICreatShortcut.creatAndAdd("callBackFund.quickBuyBtn",this._btnSp);
            this._quickBuyBtn.mouseChildren = false;
         }
         else if(_loc2_ == 1)
         {
            this._quickReceiveBtn = UICreatShortcut.creatAndAdd("callBackFund.quickReceiveBtn",this._btnSp);
            this._quickReceiveBtn.mouseChildren = false;
         }
         else if(_loc2_ == 2)
         {
            this._tomorrowComeBtn = UICreatShortcut.creatAndAdd("callBackFund.tomorrowComeBtn",this._btnSp);
            UICreatShortcut.creatTextAndAdd("callbackfund.leftDayTf",LanguageMgr.GetTranslation("callBackFund.frame.leftDayText",this._callBackFunMgr.getLeftReceiveTime()),this._btnSp);
         }
         else
         {
            this._receiveOverBtn = UICreatShortcut.creatAndAdd("callBackFund.receiveOverBtn",this._btnSp);
         }
      }
      
      private function onBtnClick(param1:MouseEvent) : void
      {
         var onAlertFrameResponse:* = undefined;
         var onCheckComplete:* = undefined;
         var msg:String = null;
         var _payAlert:BaseAlerFrame = null;
         var evt:MouseEvent = param1;
         var target:* = evt.target;
         if(target == this._quickBuyBtn)
         {
            onAlertFrameResponse = function(param1:FrameEvent):void
            {
               if(param1.responseCode == 3 || param1.responseCode == 2)
               {
                  CheckMoneyUtils.instance.checkMoney(false,_callBackFunMgr.buyFundCount,onCheckComplete);
               }
               _payAlert.removeEventListener("response",onAlertFrameResponse);
               ObjectUtils.disposeObject(_payAlert);
            };
            onCheckComplete = function():void
            {
               SocketManager.Instance.out.BuyCallFund();
            };
            SoundManager.instance.playButtonSound();
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(!CallBackFundManager.instance.isOpen)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("callBackFund.frame.activityFinish"));
               return;
            }
            msg = LanguageMgr.GetTranslation("callbackfund.buyFundTip",this._callBackFunMgr.buyFundCount);
            _payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),msg,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,2,null,"SimpleAlert",50,true,0);
            _payAlert.enterEnable = false;
            _payAlert.addEventListener("response",onAlertFrameResponse);
         }
         else if(target == this._quickReceiveBtn)
         {
            SoundManager.instance.playButtonSound();
            SocketManager.Instance.out.getCallFund();
         }
         else if(target == this._tomorrowComeBtn || target == this._receiveOverBtn)
         {
            SoundManager.instance.playButtonSound();
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("callBackFund.frame.receive"));
         }
      }
      
      private function responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            this.dispose();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._btnSp = null;
         this._quickBuyBtn = null;
         this._quickReceiveBtn = null;
         this._tomorrowComeBtn = null;
         this._receiveOverBtn = null;
         this._callBackFunMgr = null;
      }
   }
}

