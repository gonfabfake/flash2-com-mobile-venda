package morn.core.ex
{
   import morn.core.components.ProgressBar;
   
   public class ProgressBarEx extends ProgressBar
   {
      
      public function ProgressBarEx(param1:String = null)
      {
         super(param1);
      }
      
      public function set barXOffset(param1:Number) : void
      {
         bar.x = param1;
         _mark.x = param1;
      }
      
      public function set barYOffset(param1:Number) : void
      {
         bar.y = param1;
         _mark.x = param1;
      }
   }
}

