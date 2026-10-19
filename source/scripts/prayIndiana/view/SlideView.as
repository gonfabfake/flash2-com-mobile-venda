package prayIndiana.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SlideView extends Sprite
   {
      
      private var _slide:MovieClip;
      
      public function SlideView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._slide = ComponentFactory.Instance.creat("prayIndiana.slide");
         addChild(this._slide);
      }
      
      public function dispose() : void
      {
         if(Boolean(this._slide))
         {
            ObjectUtils.disposeObject(this._slide);
         }
         this._slide = null;
      }
      
      public function get slide() : MovieClip
      {
         return this._slide;
      }
      
      public function set slide(param1:MovieClip) : void
      {
         this._slide = param1;
      }
   }
}

