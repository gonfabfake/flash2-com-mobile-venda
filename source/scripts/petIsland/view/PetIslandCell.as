package petIsland.view
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petIsland.PetIslandManager;
   import petIsland.event.PetIslandEvent;
   
   public class PetIslandCell extends Sprite
   {
      
      private var cell:MovieClip;
      
      private var _type:int;
      
      public var _row:int;
      
      public var _col:int;
      
      private var _isShine:Boolean;
      
      public function PetIslandCell(param1:int, param2:int, param3:int)
      {
         super();
         this._type = param1;
         this._row = param2;
         this._col = param3;
         this.init();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get isShine() : Boolean
      {
         return this._isShine;
      }
      
      public function set isShine(param1:Boolean) : void
      {
         this._isShine = param1;
         this.cell["shine"].visible = this._isShine;
      }
      
      private function init() : void
      {
         this.cell = ComponentFactory.Instance.creat("asset.petIsland.cell" + this._type);
         this.cell["shine"].visible = false;
         addChild(this.cell);
         this.cell.addEventListener("click",this.cellClickHandler);
      }
      
      public function destroy() : void
      {
         TweenLite.to(this.cell["cellMc"],0.4,{
            "alpha":0,
            "onComplete":this.tweenComplete
         });
         this.cell["breakMc"].gotoAndPlay(2);
      }
      
      private function tweenComplete() : void
      {
         PetIslandManager.instance.dispatchEvent(new PetIslandEvent("destroy",this));
      }
      
      private function cellClickHandler(param1:MouseEvent) : void
      {
         PetIslandManager.instance.dispatchEvent(new PetIslandEvent("pet_click",this));
      }
      
      public function clearShine() : void
      {
         this.cell["shine"].visible = false;
      }
   }
}

