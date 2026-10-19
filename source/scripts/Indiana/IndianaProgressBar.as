package Indiana
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class IndianaProgressBar extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _fg:Bitmap;
      
      private var _mask:Shape;
      
      private var _bar:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _progressTxt:FilterFrameText;
      
      private var _barWidth:int;
      
      public function IndianaProgressBar()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.indiana.progress.bg");
         this._fg = ComponentFactory.Instance.creatBitmap("asset.indiana.progress.bar");
         this._bar = ComponentFactory.Instance.creatBitmap("asset.indiana.progress.light");
         this._mask = new Shape();
         this._mask.graphics.beginFill(16777215);
         this._mask.graphics.drawRect(0,0,this._fg.width,this._fg.height);
         this._mask.graphics.endFill();
         this._barWidth = this._bg.width;
         this._fg.mask = this._mask;
         this._txt = ComponentFactory.Instance.creatComponentByStylename("indiana.progress.Txt");
         this._txt.text = LanguageMgr.GetTranslation("tank.view.effort.EffortPullDodnMenu.ACQUIRE");
         this._progressTxt = ComponentFactory.Instance.creatComponentByStylename("indiana.progress.value.Txt");
         addChild(this._bg);
         addChild(this._fg);
         addChild(this._bar);
         addChild(this._txt);
         addChild(this._progressTxt);
         addChild(this._mask);
         this.setProgress(0);
      }
      
      public function setProgress(param1:Number) : void
      {
         if(param1 <= 1)
         {
            this._mask.width = param1 * this._barWidth;
            this._bar.x = this._mask.width - this._bar.width / 2;
            this._progressTxt.text = (param1 * 100).toFixed(2) + "%";
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
         ObjectUtils.disposeAllChildren(this);
         this._fg = null;
         this._bg = null;
         this._mask = null;
         this._bar = null;
         this._progressTxt = null;
      }
   }
}

