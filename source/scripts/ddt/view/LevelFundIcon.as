package ddt.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import levelFund.LevelFundManager;
   
   public class LevelFundIcon extends Sprite implements Disposeable
   {
      
      private var _activityIcon:MovieImage;
      
      public function LevelFundIcon()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._activityIcon = ComponentFactory.Instance.creat("hall.levelFundActivityBtn");
         this._activityIcon.buttonMode = true;
         addChild(this._activityIcon);
      }
      
      private function initEvent() : void
      {
         this._activityIcon.addEventListener("click",this.__showLevelFundActivityFrame);
      }
      
      protected function __showLevelFundActivityFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         LevelFundManager.instance.show();
      }
      
      private function removeEvent() : void
      {
         this._activityIcon.removeEventListener("click",this.__showLevelFundActivityFrame);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._activityIcon);
         this._activityIcon = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

