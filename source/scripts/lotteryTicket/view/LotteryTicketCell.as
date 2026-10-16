package lotteryTicket.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import lotteryTicket.LotteryManager;
   import lotteryTicket.data.LotteryTicketInfo;
   import lotteryTicket.event.LotteryTicketEvent;
   
   public class LotteryTicketCell extends Sprite implements IListCell, Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var firstTicket:MovieClip;
      
      private var secondTicket:MovieClip;
      
      private var thirdTicket:MovieClip;
      
      private var fourthTicket:MovieClip;
      
      private var bought:Bitmap;
      
      private var deleteBtn:BaseButton;
      
      private var _data:LotteryTicketInfo;
      
      public function LotteryTicketCell()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.select.lightBg");
         addChild(this._bg);
         var _loc1_:int = 0;
         this.firstTicket = ClassUtils.CreatInstance("asset.lotteryTicket.small.ticket");
         this.firstTicket.gotoAndStop(1);
         this.firstTicket.x = 5 + 46 * _loc1_;
         addChild(this.firstTicket);
         _loc1_++;
         this.secondTicket = ClassUtils.CreatInstance("asset.lotteryTicket.small.ticket");
         this.secondTicket.gotoAndStop(1);
         this.secondTicket.x = 5 + 46 * _loc1_;
         addChild(this.secondTicket);
         _loc1_++;
         this.thirdTicket = ClassUtils.CreatInstance("asset.lotteryTicket.small.ticket");
         this.thirdTicket.gotoAndStop(1);
         this.thirdTicket.x = 5 + 46 * _loc1_;
         addChild(this.thirdTicket);
         _loc1_++;
         this.fourthTicket = ClassUtils.CreatInstance("asset.lotteryTicket.small.ticket");
         this.fourthTicket.gotoAndStop(1);
         this.fourthTicket.x = 5 + 46 * _loc1_;
         addChild(this.fourthTicket);
         this.firstTicket.y = this.secondTicket.y = this.thirdTicket.y = this.fourthTicket.y = 2;
         this.bought = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.bought");
         addChild(this.bought);
         this.bought.visible = false;
         this.deleteBtn = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.deleteBtn");
         addChild(this.deleteBtn);
         this.deleteBtn.visible = false;
      }
      
      private function initEvent() : void
      {
         this.deleteBtn.addEventListener("click",this.deleteBtnHandler);
      }
      
      private function deleteBtnHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = LotteryManager.instance.model.dataList.indexOf(this._data);
         LotteryManager.instance.model.dataList.splice(_loc2_,1);
         LotteryManager.instance.dispatchEvent(new LotteryTicketEvent("deleteCell"));
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function getCellValue() : *
      {
         return this._data;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._data = param1 as LotteryTicketInfo;
         this.updateViewData();
      }
      
      private function updateViewData() : void
      {
         this.bought.visible = this._data.ifBuy;
         this.deleteBtn.visible = !this._data.ifBuy;
         this.firstTicket.gotoAndStop(parseInt(this._data.ticketArr[0],16) + 1);
         this.secondTicket.gotoAndStop(parseInt(this._data.ticketArr[1],16) + 1);
         this.thirdTicket.gotoAndStop(parseInt(this._data.ticketArr[2],16) + 1);
         this.fourthTicket.gotoAndStop(parseInt(this._data.ticketArr[3],16) + 1);
      }
      
      private function removeEvent() : void
      {
         this.deleteBtn.removeEventListener("click",this.deleteBtnHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this.bought))
         {
            ObjectUtils.disposeObject(this.bought);
         }
         this.bought = null;
         if(Boolean(this.deleteBtn))
         {
            ObjectUtils.disposeObject(this.deleteBtn);
         }
         this.deleteBtn = null;
         if(Boolean(this.firstTicket))
         {
            ObjectUtils.disposeObject(this.firstTicket);
         }
         this.firstTicket = null;
         if(Boolean(this.secondTicket))
         {
            ObjectUtils.disposeObject(this.secondTicket);
         }
         this.secondTicket = null;
         if(Boolean(this.thirdTicket))
         {
            ObjectUtils.disposeObject(this.thirdTicket);
         }
         this.thirdTicket = null;
         if(Boolean(this.fourthTicket))
         {
            ObjectUtils.disposeObject(this.fourthTicket);
         }
         this.fourthTicket = null;
      }
   }
}

