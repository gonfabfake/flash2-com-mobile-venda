package groupPurchase.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import groupPurchase.GroupPurchaseManager;
   
   public class GroupPurchaseRankFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _cellList:Vector.<GroupPurchaseRankCell>;
      
      private var _timer2:Timer;
      
      private var _endTime:Date;
      
      public function GroupPurchaseRankFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.initRefreshData();
      }
      
      private function initView() : void
      {
         var _loc1_:GroupPurchaseRankCell = null;
         var _loc2_:int = 0;
         _loc1_ = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.groupPurchase.rankViewBg");
         addToContent(this._bg);
         this._cellList = new Vector.<GroupPurchaseRankCell>();
         _loc2_ = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = new GroupPurchaseRankCell();
            _loc1_.x = 9;
            _loc1_.y = 54 + 43 * _loc2_ + _loc2_ * 0.7;
            addToContent(_loc1_);
            this._cellList.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function initRefreshData() : void
      {
         this._timer2 = new Timer(this.getRefreshDelay());
         this._timer2.addEventListener(TimerEvent.TIMER,this.requestRefreshData,false,0,true);
         this._timer2.start();
         SocketManager.Instance.out.sendGroupPurchaseRefreshRankData();
      }
      
      private function requestRefreshData(param1:TimerEvent) : void
      {
         SocketManager.Instance.out.sendGroupPurchaseRefreshRankData();
         this._timer2.delay = this.getRefreshDelay();
      }
      
      private function getRefreshDelay() : int
      {
         this._endTime = GroupPurchaseManager.instance.endTime;
         var _loc1_:Number = (this._endTime.getTime() - TimeManager.Instance.Now().getTime()) / 1000;
         if(_loc1_ > 3600)
         {
            return 180000;
         }
         return 15000;
      }
      
      private function refreshView(param1:Event) : void
      {
         var _loc2_:Array = GroupPurchaseManager.instance.rankList;
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            this._cellList[_loc3_].refreshView(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GroupPurchaseManager.instance.addEventListener(GroupPurchaseManager.REFRESH_RANK_DATA,this.refreshView);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GroupPurchaseManager.instance.removeEventListener(GroupPurchaseManager.REFRESH_RANK_DATA,this.refreshView);
         if(Boolean(this._timer2))
         {
            this._timer2.removeEventListener(TimerEvent.TIMER,this.requestRefreshData);
            this._timer2.stop();
         }
         this._timer2 = null;
         super.dispose();
         this._bg = null;
         this._cellList = null;
         this._endTime = null;
      }
   }
}

