package morn.core.ex
{
   import flash.events.MouseEvent;
   import morn.core.components.AutoBitmap;
   import morn.core.components.Button;
   
   public class SelectButtonEx extends Button
   {
      
      protected var _bottomBg:AutoBitmap;
      
      protected var _rollOverBg:AutoBitmap;
      
      public function SelectButtonEx(param1:String = null, param2:String = "")
      {
         super(param1,param2);
      }
      
      override protected function onMouse(param1:MouseEvent) : void
      {
         super.onMouse(param1);
         if(param1.type == "rollOver")
         {
            if(Boolean(this._rollOverBg))
            {
               this._rollOverBg.visible = true;
            }
         }
         else if(param1.type == "rollOut")
         {
            if(Boolean(this._rollOverBg))
            {
               this._rollOverBg.visible = false;
            }
         }
      }
      
      public function set bottomBgSkin(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = null;
         _loc3_ = null;
         if(param1 != "" || param1 != null)
         {
            if(this._bottomBg == null)
            {
               addChildAt(this._bottomBg = new AutoBitmap(),0);
            }
            _loc2_ = param1.split("|");
            this._bottomBg.bitmapData = App.asset.getBitmapData(_loc2_[0]);
            if(_loc2_.length > 1)
            {
               _loc3_ = _loc2_[1].split(",");
               this._bottomBg.x = _loc3_[0];
               this._bottomBg.y = _loc3_[1];
            }
         }
         else
         {
            this.removeBottomBg();
         }
      }
      
      public function set rollOverBgSkin(param1:String) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = null;
         _loc3_ = null;
         if(param1 != "" || param1 != null)
         {
            if(this._rollOverBg == null)
            {
               addChild(this._rollOverBg = new AutoBitmap());
            }
            this._rollOverBg.visible = false;
            _loc2_ = param1.split("|");
            this._rollOverBg.bitmapData = App.asset.getBitmapData(_loc2_[0]);
            if(_loc2_.length > 1)
            {
               _loc3_ = _loc2_[1].split(",");
               this._rollOverBg.x = _loc3_[0];
               this._rollOverBg.y = _loc3_[1];
            }
            if(_loc2_.length > 2)
            {
               addChildAt(this._rollOverBg,_loc2_[2]);
            }
         }
         else
         {
            this.removeRollOverBg();
         }
      }
      
      private function removeBottomBg() : void
      {
         if(Boolean(this._bottomBg))
         {
            if(Boolean(this._bottomBg.parent))
            {
               this._bottomBg.parent.removeChild(this._bottomBg);
            }
            this._bottomBg.dispose();
            this._bottomBg = null;
         }
      }
      
      private function removeRollOverBg() : void
      {
         if(Boolean(this._rollOverBg))
         {
            if(Boolean(this._rollOverBg.parent))
            {
               this._rollOverBg.parent.removeChild(this._rollOverBg);
            }
            this._rollOverBg.dispose();
            this._rollOverBg = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeBottomBg();
         this.removeRollOverBg();
      }
   }
}

