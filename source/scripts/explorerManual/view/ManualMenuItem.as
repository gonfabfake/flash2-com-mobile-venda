package explorerManual.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   
   public class ManualMenuItem extends SelectedButton
   {
      
      private var _chapter:int;
      
      private var _isHaveNewDebris:Boolean = false;
      
      private var _icon:MovieClip;
      
      public function ManualMenuItem()
      {
         super();
         this._icon = ComponentFactory.Instance.creat("asset.explorerManual.sighIcon");
         this._icon.visible = false;
         PositionUtils.setPos(this._icon,"explorerManual.sighIconPos");
      }
      
      public function get isHaveNewDebris() : Boolean
      {
         return this._isHaveNewDebris;
      }
      
      public function set isHaveNewDebris(param1:Boolean) : void
      {
         if(this._isHaveNewDebris == param1)
         {
            return;
         }
         this._isHaveNewDebris = param1;
         this._icon.visible = this.isHaveNewDebris;
      }
      
      public function get chapter() : int
      {
         return this._chapter;
      }
      
      public function set chapter(param1:int) : void
      {
         this._chapter = param1;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._icon))
         {
            addChild(this._icon);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._icon))
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
      }
   }
}

