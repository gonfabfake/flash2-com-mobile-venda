package BombTurnTable
{
   import BombTurnTable.data.BombTurnTableGoodInfo;
   import BombTurnTable.data.BombTurnTableInfo;
   import BombTurnTable.event.TurnTableEvent;
   import BombTurnTable.view.BombTurnTableFrame;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.events.CEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class BombTurnTableControls extends EventDispatcher
   {
      
      private static var _instance:BombTurnTableControls;
      
      private var _manager:BombTurnTableManager;
      
      private var _frame:BombTurnTableFrame;
      
      private var _curTurnTableInfo:BombTurnTableInfo;
      
      private var _isStart:Boolean = false;
      
      private var _isSingleLottery:Boolean = true;
      
      private var _curLotteryStatus:int = 1;
      
      public function BombTurnTableControls()
      {
         super();
      }
      
      public static function get instance() : BombTurnTableControls
      {
         if(!_instance)
         {
            _instance = new BombTurnTableControls();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._curTurnTableInfo = new BombTurnTableInfo();
         BombTurnTableManager.instance.addEventListener("TurnTableOpenView",this.onShowView);
      }
      
      private function onShowView(param1:CEvent) : void
      {
         var _loc2_:Boolean = BombTurnTableManager.instance.isValid;
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityTime.exceed"));
            return;
         }
         this._isStart = false;
         this.isSingleLottery = true;
         if(Boolean(this._frame))
         {
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
         }
         this._frame = ComponentFactory.Instance.creat("bombTurnTable.bombTurnTableFrame",[this]);
         if(Boolean(this._frame))
         {
            LayerManager.Instance.addToLayer(this._frame,3,true,1);
            this.addEvents();
            BombTurnTableManager.instance.requestViewData();
         }
      }
      
      protected function viewData_Handler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:PackageIn = param1.pkg;
         this._curTurnTableInfo = new BombTurnTableInfo();
         this._curTurnTableInfo.level = _loc4_.readInt();
         var _loc5_:int = _loc4_.readInt();
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = new BombTurnTableGoodInfo();
            _loc2_.place = _loc4_.readInt();
            _loc2_.templateId = _loc4_.readInt();
            _loc2_.goodCount = _loc4_.readInt();
            _loc2_.validDate = _loc4_.readInt();
            _loc2_.sex = _loc4_.readInt();
            _loc2_.isReceive = _loc4_.readInt();
            this._curTurnTableInfo.goodsInfo.push(_loc2_);
            _loc3_++;
         }
         if(_loc5_ == 8)
         {
            dispatchEvent(new TurnTableEvent("updateTurntableData",this._curTurnTableInfo));
            if(!this._isSingleLottery)
            {
               this.myDelayedFunction();
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bombTurnTable.dataErrorMsg"));
         }
      }
      
      public function myDelayedFunction() : void
      {
         if(!this._isSingleLottery && !this._isStart && this.checkLotteryCondition())
         {
            this.sendStartLottery();
         }
      }
      
      protected function winningInfo_Handler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(Boolean(this._frame) && Boolean(this._frame.turnTableView))
         {
            this.updateBtnState(false);
            this._isStart = true;
            this._frame.turnTableView.startLottery(_loc3_);
         }
      }
      
      private function lottery_Handler(param1:TurnTableEvent) : void
      {
         switch(int(param1.data))
         {
            case 0:
               this.isSingleLottery = true;
               if(Boolean(this._frame))
               {
                  this._frame.turnTableView.updateTurnTableBtnStatus(false);
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bombTurnTable.lottery.stopContinuonsLottery"),0,true);
               break;
            case 1:
               if(this._isStart)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bombTurnTable.lotteryProcessingMsg"));
               }
               else if(this.checkLotteryCondition())
               {
                  this.isSingleLottery = true;
                  this.sendStartLottery();
               }
               break;
            case 2:
               if(this.checkLotteryCondition())
               {
                  this.isSingleLottery = false;
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bombTurnTable.lottery.openContinuonsLottery"),0,true);
                  if(Boolean(this._frame))
                  {
                     this._frame.turnTableView.updateTurnTableBtnStatus(true);
                  }
                  if(!this._isStart)
                  {
                     this.sendStartLottery();
                  }
               }
         }
      }
      
      private function checkLotteryCondition() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = null;
         if(Boolean(this._curTurnTableInfo))
         {
            _loc1_ = this.getLotteryTicket();
            _loc2_ = ServerConfigManager.instance.getNeedUseLotteryKicket(this._curTurnTableInfo.quality);
            if(BombTurnTableManager.instance.isValid || _loc1_ < _loc2_)
            {
               if(BombTurnTableManager.instance.isValid)
               {
                  _loc3_ = "ddt.activityTime.exceed";
               }
               else
               {
                  _loc3_ = "ddt.bombTurnTable.ticketLackingMsg";
               }
               this._isStart = false;
               this.isSingleLottery = true;
               if(Boolean(this._frame))
               {
                  this._frame.turnTableView.updateTurnTableBtnStatus(false);
               }
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation(_loc3_),0,true);
               return false;
            }
            return true;
         }
         return false;
      }
      
      private function sendStartLottery() : void
      {
         BombTurnTableManager.instance.sendStartLottery();
      }
      
      private function updateBtnState(param1:Boolean = false) : void
      {
         if(Boolean(this._frame))
         {
            this._frame.closeButton.enable = param1;
         }
      }
      
      private function addEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOMBTURNTABLE_INIT,this.viewData_Handler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BOMBTURNTABLE_WINNING,this.winningInfo_Handler);
         BombTurnTableManager.instance.addEventListener("TurnTableEnd",this._turntableEnd_Handler);
         if(Boolean(this._frame))
         {
            this._frame.turnTableView.addEventListener("ClickLottery",this.lottery_Handler);
         }
         if(Boolean(this._frame))
         {
            this._frame.addEventListener("response",this.__responseHandler);
         }
         if(Boolean(this._frame))
         {
            this._frame.turnTableView.addEventListener("lotteryComplate",this._lotteryComplate_Handler);
         }
      }
      
      private function removeEvents() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOMBTURNTABLE_INIT,this.viewData_Handler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BOMBTURNTABLE_WINNING,this.winningInfo_Handler);
         BombTurnTableManager.instance.removeEventListener("TurnTableEnd",this._turntableEnd_Handler);
         if(Boolean(this._frame))
         {
            this._frame.turnTableView.removeEventListener("ClickLottery",this.lottery_Handler);
         }
         if(Boolean(this._frame))
         {
            this._frame.removeEventListener("response",this.__responseHandler);
         }
         if(Boolean(this._frame))
         {
            this._frame.turnTableView.removeEventListener("lotteryComplate",this._lotteryComplate_Handler);
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(!this._isStart && (param1.responseCode == 0 || param1.responseCode == 1))
         {
            SoundManager.instance.playButtonSound();
            if(Boolean(this._frame))
            {
               this.removeEvents();
               ObjectUtils.disposeObject(this._frame);
               this._frame = null;
            }
         }
      }
      
      private function _turntableEnd_Handler(param1:TurnTableEvent) : void
      {
         if(this.curLotteryStatus == 2)
         {
            this.isSingleLottery = true;
            this._isStart = false;
            this.updateBtnState(true);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.activityTime.exceed"));
            if(Boolean(this._frame))
            {
               this._frame.turnTableView.updateTurnTableBtnStatus(false);
            }
         }
      }
      
      public function getLotteryTicket(param1:int = 12554) : int
      {
         var _loc2_:BagInfo = PlayerManager.Instance.Self.getBag(1);
         return _loc2_.getItemCountByTemplateId(param1);
      }
      
      private function _lotteryComplate_Handler(param1:TurnTableEvent) : void
      {
         this.updateBtnState(true);
         this._isStart = false;
         BombTurnTableManager.instance.requestViewData();
      }
      
      private function get isSingleLottery() : Boolean
      {
         return this._isSingleLottery;
      }
      
      private function set isSingleLottery(param1:Boolean) : void
      {
         this._isSingleLottery = param1;
         this._curLotteryStatus = param1 ? 1 : 2;
      }
      
      public function get curLotteryStatus() : int
      {
         return this._curLotteryStatus;
      }
   }
}

