package BombTurnTable.view
{
   import BombTurnTable.BombTurnTableControls;
   import BombTurnTable.data.BombTurnTableInfo;
   import BombTurnTable.event.TurnTableEvent;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.HelpFrameUtils;
   
   public class BombTurnTableFrame extends Frame
   {
      
      private var _turnTableView:TurnTableView;
      
      private var _control:BombTurnTableControls;
      
      private var _helpBtn:BaseButton;
      
      public function BombTurnTableFrame(param1:BombTurnTableControls)
      {
         super();
         this._control = param1;
         this.initView();
         this.initEvent();
      }
      
      protected function initView() : void
      {
         this._turnTableView = new TurnTableView(this._control);
         if(Boolean(this._turnTableView))
         {
            addToContent(this._turnTableView);
         }
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this._container,"ddt.bombTurnTable.helpButton",{
            "x":416,
            "y":93
         },LanguageMgr.GetTranslation("AlertDialog.help"),"asset.bombTurnTable.helpDes",400,470);
      }
      
      public function initEvent() : void
      {
         if(this._control != null)
         {
            this._control.addEventListener("updateTurntableData",this.updateView);
         }
      }
      
      private function removeEvent() : void
      {
         if(this._control != null)
         {
            this._control.removeEventListener("updateTurntableData",this.updateView);
         }
      }
      
      public function updateView(param1:TurnTableEvent) : void
      {
         if(Boolean(this._turnTableView) && this._control != null)
         {
            this._turnTableView.updateView(param1.data as BombTurnTableInfo);
            this._turnTableView.updateLotteryTicket(this._control.getLotteryTicket());
         }
      }
      
      public function get turnTableView() : TurnTableView
      {
         return this._turnTableView;
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._turnTableView))
         {
            ObjectUtils.disposeObject(this._turnTableView);
            this._turnTableView = null;
         }
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
         }
         if(Boolean(this._control))
         {
            this._control = null;
         }
         if(Boolean(this) && Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

