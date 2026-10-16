package ddt.view.tips
{
   import road7th.utils.StringHelper;
   
   public class WordWrapLineTip extends OneLineTip
   {
      
      public function WordWrapLineTip()
      {
         super();
      }
      
      override public function set tipData(param1:Object) : void
      {
         _data = param1;
         _contentTxt.htmlText = StringHelper.trim(String(_data));
         if(_contentTxt.width > 250)
         {
            _contentTxt.autoSize = "none";
            _contentTxt.width = 250;
            _contentTxt.height = _contentTxt.textHeight;
         }
         else
         {
            _contentTxt.autoSize = "left";
         }
         updateTransform();
      }
   }
}

