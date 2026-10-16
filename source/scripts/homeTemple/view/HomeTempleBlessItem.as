package homeTemple.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class HomeTempleBlessItem extends Sprite implements Disposeable
   {
      
      private var _id:int;
      
      private var _bless:MovieClip;
      
      private var _blessBtn:BaseButton;
      
      public function HomeTempleBlessItem(param1:int)
      {
         super();
         this._id = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bless = ComponentFactory.Instance.creat("asset.home.temple.a00" + (this._id + 1).toString());
         addChild(this._bless);
         this._blessBtn = ComponentFactory.Instance.creatComponentByStylename("home.temple.circleTipBtn");
         this._blessBtn.tipData = LanguageMgr.GetTranslation("home.temple.circleTipText" + this._id);
         addChild(this._blessBtn);
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bless);
         this._bless = null;
         ObjectUtils.disposeObject(this._blessBtn);
         this._blessBtn = null;
      }
      
      public function get blessBtn() : BaseButton
      {
         return this._blessBtn;
      }
      
      public function get blessMovie() : MovieClip
      {
         return this._bless;
      }
   }
}

