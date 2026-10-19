package rank.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import rank.RankManager;
   
   public class RankFrame extends Frame
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _leftBorderbg:ScaleBitmapImage;
      
      private var _leftView:RankMenu;
      
      private var _rightView:RankRewardView;
      
      private var _activityTime:FilterFrameText;
      
      private var _acitvityEndInfo:FilterFrameText;
      
      public function RankFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("rank.view.scale9ImageBg");
         addToContent(this._bg);
         this._leftBorderbg = ComponentFactory.Instance.creatComponentByStylename("rank.view.BG1");
         addToContent(this._leftBorderbg);
         this._leftView = new RankMenu();
         addToContent(this._leftView);
         PositionUtils.setPos(this._leftView,"rank.leftView.pos");
         this._rightView = new RankRewardView();
         addToContent(this._rightView);
         PositionUtils.setPos(this._rightView,"rank.rightView.pos");
         this._activityTime = ComponentFactory.Instance.creatComponentByStylename("rank.ActivityTimeText");
         addToContent(this._activityTime);
         this._activityTime.text = LanguageMgr.GetTranslation("ddt.rankFrame.activityTime",RankManager.instance.model.beginTime + "--" + RankManager.instance.model.endTime);
         this._acitvityEndInfo = ComponentFactory.Instance.creatComponentByStylename("rank.AcitvityEndInfoText");
         addToContent(this._acitvityEndInfo);
         this._acitvityEndInfo.text = LanguageMgr.GetTranslation("ddt.rankFrame.endActivity");
      }
      
      public function initNew() : void
      {
         this._leftView.init();
      }
      
      public function setRightView() : void
      {
         this._rightView.setData();
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this._responseHandle);
      }
      
      private function addEvent() : void
      {
         addEventListener("response",this._responseHandle);
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
               this.dispose();
               break;
            case 1:
               this.dispose();
               break;
            case 4:
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._leftBorderbg);
         this._leftBorderbg = null;
         ObjectUtils.disposeObject(this._rightView);
         this._rightView = null;
         ObjectUtils.disposeObject(this._leftView);
         this._leftView = null;
         ObjectUtils.disposeObject(this._activityTime);
         this._activityTime = null;
         ObjectUtils.disposeObject(this._acitvityEndInfo);
         this._acitvityEndInfo = null;
      }
   }
}

