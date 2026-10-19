package wonderfulActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.utils.Dictionary;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.views.ActivityLeftView;
   import wonderfulActivity.views.WonderfulRightView;
   
   public class WonderfulFrame extends Frame
   {
      
      private var _bag:ScaleBitmapImage;
      
      private var _leftView:ActivityLeftView;
      
      private var _rightView:WonderfulRightView;
      
      private var allMusic:Boolean;
      
      public function WonderfulFrame()
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
         titleText = LanguageMgr.GetTranslation("wonderfulActivityManager.tittle");
         this._bag = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.scale9cornerImageTree");
         addToContent(this._bag);
         this._leftView = new ActivityLeftView();
         this._leftView.x = 22;
         this._leftView.y = 46;
         addToContent(this._leftView);
         this._rightView = new WonderfulRightView();
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
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         for each(_loc3_ in param1)
         {
            _loc2_ = new ActivityCellVo();
            _loc2_.id = _loc3_;
            _loc2_.activityName = _loc7_[_loc3_].label;
            switch(_loc7_[_loc3_].unitIndex)
            {
               case 1:
                  _loc5_.push(_loc2_);
                  break;
               case 2:
                  _loc4_.push(_loc2_);
                  break;
               case 3:
                  _loc6_.push(_loc2_);
            }
         }
         if(_loc6_.length == 0)
         {
            this._leftView.isNewServerExist = false;
         }
         else
         {
            this._leftView.isNewServerExist = true;
         }
         this._leftView.addUnitByType(_loc4_,2);
         this._leftView.addUnitByType(_loc5_,1);
         if(this._leftView.isNewServerExist)
         {
            this._leftView.addUnitByType(_loc6_,3);
         }
         else
         {
            this._leftView.checkNewServerExist();
         }
         this._leftView.extendUnitView();
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

