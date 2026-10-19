package growthPackage.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import growthPackage.GrowthPackageManager;
   import growthPackage.event.GrowthPackageEvent;
   
   public class GrowthPackageFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _explainTxt:FilterFrameText;
      
      private var _itemsSprite:Sprite;
      
      private var _items:Vector.<GrowthPackageItem>;
      
      public function GrowthPackageFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:GrowthPackageItem = null;
         _loc1_ = null;
         titleText = LanguageMgr.GetTranslation("ddt.growthPackage.frameTitle");
         this._bg = ComponentFactory.Instance.creatBitmap("assets.growthPackage.FrameBg");
         addToContent(this._bg);
         this._explainTxt = ComponentFactory.Instance.creatComponentByStylename("growthPackage.explainTxt.text");
         this._explainTxt.text = LanguageMgr.GetTranslation("growthPackage.explainTxt.txt");
         addToContent(this._explainTxt);
         this._itemsSprite = new Sprite();
         addToContent(this._itemsSprite);
         this._items = new Vector.<GrowthPackageItem>();
         var _loc2_:int = 0;
         while(_loc2_ < GrowthPackageManager.indexMax)
         {
            _loc1_ = new GrowthPackageItem(_loc2_);
            _loc1_.y = _loc2_ * 54;
            this._itemsSprite.addChild(_loc1_);
            this._items.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GrowthPackageManager.instance.model.addEventListener(GrowthPackageEvent.DATA_CHANGE,this.__dataChange);
      }
      
      private function __dataChange(param1:GrowthPackageEvent) : void
      {
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this._items))
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this.updateItem(_loc1_);
               _loc1_++;
            }
         }
      }
      
      private function updateItem(param1:int) : void
      {
         var _loc2_:GrowthPackageItem = GrowthPackageItem(this._items[param1]);
         _loc2_.updateState();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         GrowthPackageManager.instance.model.removeEventListener(GrowthPackageEvent.DATA_CHANGE,this.__dataChange);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GrowthPackageItem = null;
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._explainTxt);
         this._explainTxt = null;
         if(Boolean(this._items))
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               _loc2_ = this._items[_loc1_];
               ObjectUtils.disposeObject(_loc2_);
               _loc1_++;
            }
            this._items = null;
         }
         if(Boolean(this._itemsSprite))
         {
            ObjectUtils.disposeAllChildren(this._itemsSprite);
            ObjectUtils.disposeObject(this._itemsSprite);
            this._itemsSprite = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

