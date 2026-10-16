package morn.core.ex
{
   import flash.display.Shape;
   import morn.core.components.Label;
   
   public class LabelEx extends Label
   {
      
      protected var _middlelineSp:Shape;
      
      protected var _middleline:Boolean;
      
      public function LabelEx(param1:String = "", param2:String = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         addChild(this._middlelineSp = new Shape());
      }
      
      public function set middleline(param1:Boolean) : void
      {
         if(param1)
         {
            this._middlelineSp.graphics.clear();
            this._middlelineSp.graphics.lineStyle(2,_textField.textColor);
            this._middlelineSp.graphics.moveTo(_textField.x,_textField.y + _textField.height / 2);
            this._middlelineSp.graphics.lineTo(_textField.x + _textField.width,_textField.y + _textField.height / 2);
            this._middlelineSp.graphics.endFill();
         }
         else
         {
            this._middlelineSp.graphics.clear();
         }
      }
      
      public function get middleline() : Boolean
      {
         return this._middleline;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(Boolean(this._middlelineSp))
         {
            this._middlelineSp.graphics.clear();
            if(Boolean(this._middlelineSp.parent))
            {
               this._middlelineSp.parent.removeChild(this._middlelineSp);
            }
            this._middlelineSp = null;
         }
      }
   }
}

