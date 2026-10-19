package welfareCenter.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class OldPlayerGradeGiftBox extends BaseButton
   {
      
      private var _gainBg:Bitmap;
      
      private var _isGain:Boolean;
      
      private var _shine:MovieClip;
      
      private var _isShine:Boolean;
      
      public function OldPlayerGradeGiftBox()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(Boolean(this._gainBg))
         {
            addChild(this._gainBg);
         }
         if(Boolean(this._shine))
         {
            addChild(this._shine);
         }
      }
      
      public function set isGain(param1:Boolean) : void
      {
         if(this._isGain == param1)
         {
            return;
         }
         this._isGain = param1;
         if(this._isGain)
         {
            if(this._gainBg == null)
            {
               this._gainBg = ComponentFactory.Instance.creatBitmap("asset.welfareCeneter.gift.isGain");
            }
            this._gainBg.x = (width - this._gainBg.width) / 2;
            this._gainBg.y = (height - this._gainBg.height) / 2;
            this._gainBg.visible = true;
            if(Boolean(_back))
            {
               _back.filters = ComponentFactory.Instance.creatFilters("welfareCenter.boxFilter");
            }
            this.addChildren();
         }
         else
         {
            if(Boolean(this._gainBg))
            {
               this._gainBg.visible = false;
            }
            if(Boolean(_back))
            {
               _back.filters = [];
            }
         }
      }
      
      public function set isShine(param1:Boolean) : void
      {
         if(this._isShine == param1)
         {
            return;
         }
         this._isShine = param1;
         if(this._isShine)
         {
            if(this._shine == null)
            {
               this._shine = ComponentFactory.Instance.creat("asset.welfareCeneter.iconItemShine");
               PositionUtils.setPos(this._shine,"welfareCenter.gradeGiftView.boxShinePos");
            }
            this._shine.visible = true;
            this.addChildren();
         }
         else if(Boolean(this._shine))
         {
            this._shine.visible = false;
         }
      }
      
      public function get isShine() : Boolean
      {
         return this._isShine;
      }
      
      public function get isGain() : Boolean
      {
         return this._isGain;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._shine);
         ObjectUtils.disposeObject(this._gainBg);
         super.dispose();
         this._gainBg = null;
         this._shine = null;
      }
   }
}

