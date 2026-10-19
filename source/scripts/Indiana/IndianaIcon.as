package Indiana
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class IndianaIcon extends Sprite implements Disposeable
   {
      
      private var _activityIcon:MovieClip;
      
      public function IndianaIcon()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._activityIcon = ComponentFactory.Instance.creat("asst.hall.oneYuanShopingIcon");
         this.buttonMode = true;
         addChild(this._activityIcon);
      }
      
      private function initEvent() : void
      {
         this.addEventListener("click",this.__enterIndianaView);
      }
      
      private function __enterIndianaView(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         IndianaDataManager.instance.show();
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener("click",this.__enterIndianaView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._activityIcon);
         this._activityIcon = null;
      }
   }
}

