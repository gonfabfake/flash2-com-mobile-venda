package toyMachine.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   import toyMachine.ToyMachineManager;
   import trainer.view.NewHandContainer;
   
   public class ToyMachineFrame extends Frame implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _silverItem:ToyMachineItem;
      
      private var _goldItem:ToyMachineItem;
      
      public function ToyMachineFrame()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.getToyMachineInfo();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.farm.toyMachine.titleText");
         this._bg = ComponentFactory.Instance.creat("asset.toyMachine.bg");
         addToContent(this._bg);
         this._silverItem = new ToyMachineItem(1);
         PositionUtils.setPos(this._silverItem,"toyMachine.silverPos");
         addToContent(this._silverItem);
         this._goldItem = new ToyMachineItem(2);
         PositionUtils.setPos(this._goldItem,"toyMachine.goldPos");
         addToContent(this._goldItem);
         if(!PlayerManager.Instance.Self.IsWeakGuildFinish(135))
         {
            if(PlayerManager.Instance.Self.Grade >= 25)
            {
               NewHandContainer.Instance.showArrow(146,135,new Point(285,443),"","",LayerManager.Instance.getLayerByType(0));
            }
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__onResponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOYMACHINE,this.__onUpdateView);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.TOYGRAPPLE,this.__onGetReward);
      }
      
      protected function __onGetReward(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         _loc2_.position = 20;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == 1)
         {
            this._silverItem.getReward(_loc2_);
         }
         else
         {
            this._goldItem.getReward(_loc2_);
         }
      }
      
      protected function __onUpdateView(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = null;
         _loc2_ = param1.pkg;
         var _loc3_:Date = _loc2_.readDate();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Date = _loc2_.readDate();
         this._silverItem.setItemInfo(_loc3_,_loc4_);
         this._goldItem.setItemInfo(_loc5_);
      }
      
      protected function __onResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               ToyMachineManager.instance.hide();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__onResponse);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOYMACHINE,this.__onUpdateView);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.TOYGRAPPLE,this.__onGetReward);
      }
      
      override public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(146);
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._silverItem = null;
         this._goldItem = null;
      }
   }
}

