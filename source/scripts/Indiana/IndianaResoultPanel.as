package Indiana
{
   import Indiana.item.IndianaResoultLose;
   import Indiana.item.IndianaResoultSuccess;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class IndianaResoultPanel extends Sprite implements Disposeable
   {
      
      private var _successView:IndianaResoultSuccess;
      
      private var _loseView:IndianaResoultLose;
      
      public function IndianaResoultPanel()
      {
         super();
         this.showResoult(1);
      }
      
      private function showResoult(param1:int) : void
      {
         switch(int(param1))
         {
            case 0:
               if(this._successView == null)
               {
                  this._successView = new IndianaResoultSuccess();
                  addChild(this._successView);
               }
               break;
            case 1:
               if(this._loseView == null)
               {
                  this._loseView = new IndianaResoultLose();
                  addChild(this._loseView);
               }
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._successView = null;
         this._loseView = null;
      }
   }
}

