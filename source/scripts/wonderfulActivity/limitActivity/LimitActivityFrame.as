package wonderfulActivity.limitActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.utils.Dictionary;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.views.WonderfulRightView;
   
   public class LimitActivityFrame extends Frame
   {
      
      private var _bag:ScaleBitmapImage;
      
      private var _leftView:LimitActivityLeftView;
      
      private var _rightView:WonderfulRightView;
      
      private var allMusic:Boolean;
      
      public function LimitActivityFrame()
      {
         super();
         escEnable = true;
         this.allMusic = SharedManager.Instance.allowMusic;
         SharedManager.Instance.allowMusic = false;
         SharedManager.Instance.changed();
         this.initview();
         this.addEvents();
      }
      
      public function setState(param1:int, param2:int) : void
      {
         if(!this._rightView && !this._rightView.parent)
         {
            return;
         }
         this._rightView.setState(param1,param2);
      }
      
      private function initview() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.limitActivityFrame.tittle");
         this._bag = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.scale9cornerImageTree");
         this._bag.width = 765;
         addToContent(this._bag);
         this._leftView = new LimitActivityLeftView();
         this._leftView.x = 20;
         this._leftView.y = 47;
         addToContent(this._leftView);
         this._rightView = new WonderfulRightView();
         PositionUtils.setPos(this._rightView,"limitActivity.wonderfulRightViewPos");
         addToContent(this._rightView);
         this._leftView.setRightView(this._rightView.updateView);
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      public function addElement(param1:Array) : void
      {
         var _loc2_:ActivityCellVo = null;
         var _loc3_:String = null;
         var _loc4_:Array = [];
         var _loc5_:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         for each(_loc3_ in param1)
         {
            _loc2_ = new ActivityCellVo();
            _loc2_.id = _loc3_;
            _loc2_.activityName = _loc5_[_loc3_].label;
            _loc2_.viewType = _loc5_[_loc3_].viewType;
            _loc4_.push(_loc2_);
         }
         this._leftView.setData(_loc4_);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(!WonderfulActivityManager.Instance.isRuning)
         {
            return;
         }
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            if(WonderfulActivityManager.Instance.frameCanClose)
            {
               SoundManager.instance.play("008");
               this.clear();
            }
         }
      }
      
      private function clear() : void
      {
         this.dispose();
         WonderfulActivityManager.Instance.dispose();
      }
      
      override public function dispose() : void
      {
         if(!WonderfulActivityManager.Instance.isRuning)
         {
            return;
         }
         SharedManager.Instance.allowMusic = this.allMusic;
         SharedManager.Instance.changed();
         this.removeEvents();
         ObjectUtils.disposeObject(this._leftView);
         ObjectUtils.disposeObject(this._rightView);
         this._leftView = null;
         this._rightView = null;
         super.dispose();
      }
   }
}

