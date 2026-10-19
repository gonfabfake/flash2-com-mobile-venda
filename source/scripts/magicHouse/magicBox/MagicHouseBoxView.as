package magicHouse.magicBox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButtonNew;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MagicHouseBoxView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _extractionBtn:SelectedTextButtonNew;
      
      private var _fusionBtn:SelectedTextButtonNew;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _extractionView:MagicHouseExtraction;
      
      private var _fusionView:MagicHouseFusionView;
      
      public function MagicHouseBoxView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("magichouse.magicboxview.mainview.bg");
         addChild(this._bg);
         this._extractionBtn = ComponentFactory.Instance.creatComponentByStylename("maigchouse.magicboxview.extractionBtn");
         this._extractionBtn.text = LanguageMgr.GetTranslation("magichouse.magicboxView.extractiontxt");
         addChild(this._extractionBtn);
         this._fusionBtn = ComponentFactory.Instance.creatComponentByStylename("maigchouse.magicboxview.fusionBtn");
         this._fusionBtn.text = LanguageMgr.GetTranslation("magichouse.magicboxView.fusiontxt");
         addChild(this._fusionBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._extractionBtn);
         this._btnGroup.addSelectItem(this._fusionBtn);
         this._btnGroup.selectIndex = 0;
         this._createExtractionView();
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener("change",this.__changeHandler);
      }
      
      private function removeEvent() : void
      {
         this._btnGroup.removeEventListener("change",this.__changeHandler);
      }
      
      private function __changeHandler(param1:Event) : void
      {
         switch(int(this._btnGroup.selectIndex))
         {
            case 0:
               if(!this._extractionView)
               {
                  this._extractionView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicBoxMainView.extractionview");
                  addChild(this._extractionView);
               }
               this._extractionView.visible = true;
               if(Boolean(this._fusionView))
               {
                  this._fusionView.visible = false;
               }
               break;
            case 1:
               if(!this._fusionView)
               {
                  this._fusionView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicBoxMainView.fusionview");
                  addChild(this._fusionView);
               }
               this._fusionView.visible = true;
               if(Boolean(this._extractionView))
               {
                  this._extractionView.visible = false;
               }
         }
      }
      
      private function _createExtractionView() : void
      {
         if(!this._extractionView)
         {
            this._extractionView = ComponentFactory.Instance.creatCustomObject("magicHouse.magicBoxMainView.extractionview");
            addChild(this._extractionView);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._extractionBtn))
         {
            ObjectUtils.disposeObject(this._extractionBtn);
         }
         this._extractionBtn = null;
         if(Boolean(this._fusionBtn))
         {
            ObjectUtils.disposeObject(this._fusionBtn);
         }
         this._fusionBtn = null;
         if(Boolean(this._fusionView))
         {
            ObjectUtils.disposeObject(this._fusionView);
         }
         this._fusionView = null;
         if(Boolean(this._extractionView))
         {
            ObjectUtils.disposeObject(this._extractionView);
         }
         this._extractionView = null;
      }
   }
}

