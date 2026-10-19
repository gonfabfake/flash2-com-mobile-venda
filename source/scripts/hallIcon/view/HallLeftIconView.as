package hallIcon.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import hallIcon.HallIconManager;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   
   public class HallLeftIconView extends Sprite implements Disposeable
   {
      
      private var _iconVBox:VBox;
      
      public function HallLeftIconView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._iconVBox = new VBox();
         this._iconVBox.spacing = 5;
         addChild(this._iconVBox);
      }
      
      private function initEvent() : void
      {
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_LEFTICON_VIEW,this.__updateLeftIconView);
      }
      
      private function addChildBox(param1:DisplayObject) : void
      {
         this._iconVBox.addChild(param1);
         this._iconVBox.arrange();
      }
      
      private function __updateLeftIconView(param1:HallIconEvent) : void
      {
         var _loc2_:HallIconInfo = param1.data as HallIconInfo;
      }
      
      private function createComponentIcon(param1:String) : Component
      {
         var _loc2_:Component = null;
         _loc2_ = null;
         _loc2_ = new Component();
         _loc2_.tipStyle = "ddt.view.tips.OneLineTip";
         _loc2_.tipDirctions = "7,3,6";
         _loc2_.addChild(ComponentFactory.Instance.creat(param1));
         _loc2_.width = 70;
         _loc2_.height = 70;
         return _loc2_;
      }
      
      private function removeEvent() : void
      {
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_LEFTICON_VIEW,this.__updateLeftIconView);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._iconVBox))
         {
            ObjectUtils.disposeAllChildren(this._iconVBox);
            ObjectUtils.disposeObject(this._iconVBox);
            this._iconVBox = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

