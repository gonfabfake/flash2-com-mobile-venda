package BombTurnTable.view
{
   import BombTurnTable.BombTurnTableControls;
   import BombTurnTable.data.BombTurnTableFactory;
   import BombTurnTable.data.BombTurnTableInfo;
   import BombTurnTable.event.TurnTableEvent;
   import BombTurnTable.view.quality.BaseTurnTable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ServerConfigManager;
   import flash.display.Sprite;
   
   public class TurnTableView extends Sprite implements Disposeable
   {
      
      private var _curTurnTable:BaseTurnTable = null;
      
      private var _curData:BombTurnTableInfo = null;
      
      private var _control:BombTurnTableControls;
      
      public function TurnTableView(param1:BombTurnTableControls)
      {
         this._control = param1;
         super();
      }
      
      public function updateView(param1:BombTurnTableInfo) : void
      {
         this._curData = param1;
         if(this._curData == null)
         {
            return;
         }
         if(Boolean(this._curTurnTable))
         {
            if(this._curTurnTable.level != this._curData.level)
            {
               if(this._curTurnTable.level > this._curData.level)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bombTurnTable.lottery.degrade.returnLotteryTicket",ServerConfigManager.instance.getNeedUseLotteryKicket(this._curData.quality)),0,true);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bombTurnTable.lottery.grade.returnLotteryTicket",ServerConfigManager.instance.getNeedUseLotteryKicket(this._curData.quality)),0,true);
               }
               ObjectUtils.disposeObject(this._curTurnTable);
               this._curTurnTable = null;
            }
            else
            {
               this._curTurnTable.clear();
            }
         }
         if(this._curTurnTable == null || this._curTurnTable.level != this._curData.level)
         {
            this._curTurnTable = BombTurnTableFactory.instance.createTurnTable(this._curData.level,this._control.curLotteryStatus);
            this._curTurnTable.addEventListener("ClickLottery",this.clickLottery_Handler);
            this._curTurnTable.addEventListener("lotteryComplate",this.lotteryComplate_Handler);
            addChild(this._curTurnTable);
         }
         this._curTurnTable.updateAwardGood(this._curData);
      }
      
      public function updateLotteryTicket(param1:int) : void
      {
         this._curTurnTable.updateLotteryTicket(param1);
      }
      
      protected function clickLottery_Handler(param1:TurnTableEvent) : void
      {
         this.dispatchEvent(new TurnTableEvent("ClickLottery",param1.data));
      }
      
      public function startLottery(param1:int) : void
      {
         if(Boolean(this._curTurnTable))
         {
            this._curTurnTable.startLottery(param1);
         }
      }
      
      public function updateTurnTableBtnStatus(param1:Boolean) : void
      {
         this._curTurnTable.lotteryBtn.updateBtnStatus(param1);
      }
      
      public function lotteryComplate_Handler(param1:TurnTableEvent) : void
      {
         this.dispatchEvent(new TurnTableEvent("lotteryComplate",null));
      }
      
      public function dispose() : void
      {
         if(Boolean(this._curTurnTable))
         {
            this._curTurnTable.removeEventListener("ClickLottery",this.clickLottery_Handler);
            this._curTurnTable.removeEventListener("lotteryComplate",this.lotteryComplate_Handler);
            ObjectUtils.disposeObject(this._curTurnTable);
         }
         this._curTurnTable = null;
         this._control = null;
         this._curData = null;
      }
   }
}

