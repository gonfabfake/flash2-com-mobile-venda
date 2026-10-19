package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class GiftContentView extends Sprite implements Disposeable
   {
      
      private var listLen:int = 12;
      
      private var _content:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      public function GiftContentView()
      {
         super();
         this.initData();
         this.initView();
      }
      
      private function initData() : void
      {
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._content = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.Vbox");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("vip.GiftContentView.DetailList");
         this._scrollPanel.setView(this._content);
         _loc1_ = 0;
         while(_loc1_ <= this.listLen - 1)
         {
            _loc2_ = new VipGiftDetail();
            _loc2_.setData(_loc1_ + 1);
            this._content.addChild(_loc2_);
            _loc1_++;
         }
         this._scrollPanel.invalidateViewport();
         addChild(this._scrollPanel);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
      }
   }
}

