package newTitle.view
{
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.EffortManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import newTitle.NewTitleManager;
   import newTitle.event.NewTitleEvent;
   
   public class NewTitleListView extends Sprite implements Disposeable
   {
      
      private var _list:ListPanel;
      
      public function NewTitleListView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._list = ComponentFactory.Instance.creatComponentByStylename("newTitle.list");
         addChild(this._list);
      }
      
      private function initEvent() : void
      {
         this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
      }
      
      protected function __onListItemClick(param1:ListItemEvent) : void
      {
         NewTitleManager.instance.dispatchEvent(new NewTitleEvent(NewTitleEvent.TITLE_ITEM_CLICK,[param1.index]));
      }
      
      public function updateOwnTitleList() : void
      {
         var _loc1_:Array = EffortManager.Instance.getHonorArray();
         this._list.vectorListModel.clear();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._list.vectorListModel.append(_loc1_[_loc2_].Name,_loc2_);
            _loc2_++;
         }
         this._list.list.updateListView();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(PlayerManager.Instance.Self.honor == _loc1_[_loc3_].Name)
            {
               this._list.setViewPosition(_loc3_);
               this._list.list.currentSelectedIndex = _loc3_;
               break;
            }
            _loc3_++;
         }
      }
      
      public function updateAllTitleList() : void
      {
         this._list.vectorListModel.clear();
         var _loc1_:Array = NewTitleManager.instance.titleArray;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this._list.vectorListModel.append(_loc1_[_loc2_].Name,_loc2_);
            _loc2_++;
         }
         this._list.list.updateListView();
         this._list.list.currentSelectedIndex = 0;
      }
      
      public function dispose() : void
      {
         if(Boolean(this._list))
         {
            this._list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__onListItemClick);
            ObjectUtils.disposeObject(this._list);
            this._list = null;
         }
      }
   }
}

