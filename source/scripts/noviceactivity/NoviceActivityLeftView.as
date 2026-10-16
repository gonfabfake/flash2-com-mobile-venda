package noviceactivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class NoviceActivityLeftView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _titleBitmap:Bitmap;
      
      private var _content:ScrollPanel;
      
      private var _vbox:VBox;
      
      private var _items:Array;
      
      private var _selectedItem:NoviceActivityLeftTitleItem;
      
      public function NoviceActivityLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.novice.leftview.bg");
         this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.novice.frame.titlebitmap");
         addChild(this._bg);
         addChild(this._titleBitmap);
         this._content = ComponentFactory.Instance.creatComponentByStylename("noviceactiviy.leftview.itemlist");
         this._vbox = new VBox();
         this._vbox.spacing = 4;
         this._content.setView(this._vbox);
         this._content.vScrollProxy = ScrollPanel.ON;
         this._content.hScrollProxy = ScrollPanel.OFF;
         this._content.vScrollbar;
         addChild(this._content);
         this.addItem();
         if(Boolean(this._items) && Boolean(this._items[0]))
         {
            this._items[0].selected = true;
            this._selectedItem = this._items[0];
         }
      }
      
      private function addItem() : void
      {
         var _loc3_:Object = null;
         var _loc1_:NoviceActivityLeftTitleItem = null;
         this._items = [];
         var _loc2_:DictionaryData = NoviceActivityManager.instance.list;
         for each(_loc3_ in _loc2_.list)
         {
            _loc1_ = new NoviceActivityLeftTitleItem();
            _loc1_.setInfo(_loc3_.activityType,_loc3_.Title);
            _loc1_.addEventListener(MouseEvent.CLICK,this.__itemHandler);
            this._items.push(_loc1_);
            this._vbox.addChild(_loc1_);
         }
         this._vbox.refreshChildPos();
         this._content.invalidateViewport();
      }
      
      private function __itemHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:NoviceActivityLeftTitleItem = param1.currentTarget as NoviceActivityLeftTitleItem;
         this.setSelectItem(_loc2_);
         NoviceActivityManager.instance.changeRightView(_loc2_.index);
      }
      
      private function setSelectItem(param1:NoviceActivityLeftTitleItem) : void
      {
         if(param1 != this._selectedItem)
         {
            if(Boolean(this._selectedItem))
            {
               this._selectedItem.selected = false;
            }
            this._selectedItem = param1;
            this._selectedItem.selected = true;
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._titleBitmap))
         {
            ObjectUtils.disposeObject(this._titleBitmap);
         }
         this._titleBitmap = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

