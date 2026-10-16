package moneyTree.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import moneyTree.MoneyTreeController;
   import moneyTree.MoneyTreeManager;
   
   public class CountDownBoard extends Sprite implements Disposeable
   {
      
      private var _index:int;
      
      private var _bg:Bitmap;
      
      private var _title:Bitmap;
      
      private var _speedUpBtn:SimpleBitmapButton;
      
      private var _countDownTextField:FilterFrameText;
      
      public function CountDownBoard(param1:int, param2:Bitmap)
      {
         this._index = param1;
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("moneyTree.cd.bg");
         addChild(this._bg);
         this._title = param2;
         this._title.x = -1;
         this._title.y = 2;
         addChild(this._title);
         this._speedUpBtn = ComponentFactory.Instance.creat("moneyTree.speedup.Btn");
         this._speedUpBtn.addEventListener("click",this.onSpeedUpClick);
         addChild(this._speedUpBtn);
         this._countDownTextField = ComponentFactory.Instance.creat("moneyTree.cd.textField");
         addChild(this._countDownTextField);
      }
      
      protected function onSpeedUpClick(param1:MouseEvent) : void
      {
         this._speedUpBtn.enable = false;
         SoundManager.instance.play("008");
         MoneyTreeManager.getInstance().onSpeedUpClick(this._index);
         setTimeout(this.setBtnEnable,2000);
      }
      
      private function setBtnEnable() : void
      {
         if(Boolean(this._speedUpBtn))
         {
            this._speedUpBtn.enable = true;
         }
      }
      
      public function updateTime(param1:String) : void
      {
         this._countDownTextField.text = param1;
         if(param1 == LanguageMgr.GetTranslation("moneyTree.MoneyTreeModel.TreeOK"))
         {
            this._speedUpBtn.visible = false;
            MoneyTreeController.getInstance().BecomeMature();
         }
         else
         {
            this._speedUpBtn.visible = true;
         }
      }
      
      public function dispose() : void
      {
         if(this._bg != null)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._title != null)
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(this._speedUpBtn != null)
         {
            this._speedUpBtn.removeEventListener("click",this.onSpeedUpClick);
            ObjectUtils.disposeObject(this._speedUpBtn);
            this._speedUpBtn = null;
         }
         if(this._countDownTextField != null)
         {
            ObjectUtils.disposeObject(this._countDownTextField);
            this._countDownTextField = null;
         }
      }
   }
}

