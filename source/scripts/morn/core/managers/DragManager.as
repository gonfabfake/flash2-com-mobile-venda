package morn.core.managers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import morn.core.events.DragEvent;
   
   public class DragManager
   {
      
      private var _dragInitiator:DisplayObject;
      
      private var _dragImage:Sprite;
      
      private var _data:*;
      
      public function DragManager()
      {
         super();
      }
      
      public function doDrag(param1:Sprite, param2:Sprite = null, param3:* = null, param4:Point = null) : void
      {
         var _loc5_:* = null;
         this._dragInitiator = param1;
         this._dragImage = param2 ? param2 : param1;
         this._data = param3;
         if(this._dragImage != this._dragInitiator)
         {
            if(!this._dragImage.parent)
            {
               App.stage.addChild(this._dragImage);
            }
            param4 ||= new Point();
            _loc5_ = this._dragImage.globalToLocal(new Point(App.stage.mouseX,App.stage.mouseY));
            this._dragImage.x = _loc5_.x - param4.x;
            this._dragImage.y = _loc5_.y - param4.y;
            this._dragImage.visible = false;
         }
         App.stage.addEventListener("mouseMove",this.onStageMouseMove);
         App.stage.addEventListener("mouseUp",this.onStageMouseUp);
      }
      
      private function onStageMouseMove(param1:MouseEvent) : void
      {
         if(!this._dragImage.visible)
         {
            this._dragImage.visible = true;
            this._dragImage.startDrag();
            this._dragInitiator.dispatchEvent(new DragEvent("dragStart",this._dragInitiator,this._data));
         }
         if(param1.stageX <= 0 || param1.stageX >= App.stage.stageWidth || param1.stageY <= 0 || param1.stageY >= App.stage.stageHeight)
         {
            this._dragImage.stopDrag();
         }
         else
         {
            this._dragImage.startDrag();
         }
      }
      
      private function onStageMouseUp(param1:Event) : void
      {
         App.stage.removeEventListener("mouseMove",this.onStageMouseMove);
         App.stage.removeEventListener("mouseUp",this.onStageMouseUp);
         this._dragImage.stopDrag();
         var _loc2_:DisplayObject = this.getDropTarget(this._dragImage.dropTarget);
         if(Boolean(_loc2_))
         {
            _loc2_.dispatchEvent(new DragEvent("dragDrop",this._dragInitiator,this._data));
         }
         this._dragInitiator.dispatchEvent(new DragEvent("dragComplete",this._dragInitiator,this._data));
         if(this._dragInitiator != this._dragImage && Boolean(this._dragImage.parent))
         {
            this._dragImage.parent.removeChild(this._dragImage);
         }
         this._dragInitiator = null;
         this._data = null;
         this._dragImage = null;
      }
      
      private function getDropTarget(param1:DisplayObject) : DisplayObject
      {
         while(Boolean(param1))
         {
            if(param1.hasEventListener("dragDrop"))
            {
               return param1;
            }
            param1 = param1.parent;
         }
         return null;
      }
   }
}

