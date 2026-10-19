package Indiana
{
   import Indiana.item.IndianaRecodeItem;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class IndianaRecodePanel extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _scroller:ScrollPanel;
      
      private var _vbox:VBox;
      
      public function IndianaRecodePanel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         IndianaDataManager.instance.addEventListener("recodeiteminfo",this.__recodeUpdata);
      }
      
      private function __recodeUpdata(param1:Event) : void
      {
         this.setItem();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.indiana.recode.bg");
         this._scroller = ComponentFactory.Instance.creatComponentByStylename("indiana.scroll.recodepanel");
         this._vbox = new VBox();
         this._vbox.spacing = 12;
         this._scroller.setView(this._vbox);
         addChild(this._bg);
         addChild(this._scroller);
         this.setItem();
      }
      
      private function setItem() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = int(IndianaDataManager.instance.currentIndianInfo.length);
         this.clearItem();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = new IndianaRecodeItem();
            _loc1_.info = IndianaDataManager.instance.currentIndianInfo[_loc2_];
            this._vbox.addChild(_loc1_);
            _loc2_++;
         }
         _loc1_ = new IndianaRecodeItem();
         _loc1_.visible = false;
         this._vbox.addChild(_loc1_);
         this._scroller.invalidateViewport();
      }
      
      public function clearItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._vbox.clearAllChild();
         var _loc3_:int = this._vbox.numChildren;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            if(this._vbox.getChildAt(_loc1_) is IndianaRecodeItem)
            {
               _loc2_ = this._vbox.getChildAt(_loc1_) as IndianaRecodeItem;
               ObjectUtils.disposeObject(_loc2_);
               _loc2_ = null;
               _loc1_--;
            }
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         IndianaDataManager.instance.removeEventListener("recodeiteminfo",this.__recodeUpdata);
         if(Boolean(this._scroller))
         {
            ObjectUtils.disposeObject(this._scroller);
         }
         this._scroller = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this._vbox = null;
      }
   }
}

