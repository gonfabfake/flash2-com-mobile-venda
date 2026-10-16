package entertainmentMode.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.PropInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.events.MouseEvent;
   
   public class EntertainmentInfoFrame extends BaseAlerFrame
   {
      
      public static const SUM_NUMBER:int = 20;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<PropItemView>;
      
      private var _page:int = 1;
      
      private var propList:Array = [];
      
      public function EntertainmentInfoFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc6_:ScrollPanel = null;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         this.propList = ItemManager.Instance.getPropByTypeAndPro();
         var _loc5_:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("entertainment.frameBottom");
         this._list = ComponentFactory.Instance.creatCustomObject("entertainment.TrophyList",[5]);
         this.titleText = LanguageMgr.GetTranslation("entertainment.view.title");
         this._items = new Vector.<PropItemView>();
         this._list.beginChanges();
         _loc1_ = 0;
         while(_loc1_ < this.propList.length)
         {
            _loc2_ = new PropInfo(this.propList[_loc1_]);
            _loc3_ = new PropItemView(_loc2_,true,false);
            _loc3_.propPos = 5;
            _loc4_ = ComponentFactory.Instance.creat("asset.Entertainment.mode.propBox");
            _loc4_.width = 48;
            _loc4_.height = 48;
            _loc3_.width = 50;
            _loc3_.height = 50;
            _loc3_.addChildAt(_loc4_,0);
            this._items.push(_loc3_);
            this._list.addChild(_loc3_);
            _loc1_++;
         }
         this._list.commitChanges();
         _loc6_ = ComponentFactory.Instance.creatComponentByStylename("entertainment.view.scrollPanel");
         _loc6_.setView(this._list);
         addToContent(_loc5_);
         addToContent(_loc6_);
         escEnable = true;
      }
      
      private function initEvents() : void
      {
         addEventListener("response",this._response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener("response",this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            this.hide();
         }
      }
      
      public function hide() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function _nextClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this._page;
         if(this._page > this.pageSum())
         {
            this._page = 1;
         }
      }
      
      private function _prevClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         --this._page;
         if(this._page < 1)
         {
            this._page = this.pageSum();
         }
      }
      
      public function pageSum() : int
      {
         return 1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvents();
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._items != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               ObjectUtils.disposeObject(this._items[_loc1_]);
               _loc1_++;
            }
            this._items = null;
         }
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

