package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.BraveDoorManager;
   import BraveDoor.data.BraveDoorDuplicateInfo;
   import BraveDoor.data.BraveDoorListModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class BraveDoorView extends Sprite implements Disposeable
   {
      
      private var _dmapView:DuplicateMapView = null;
      
      private var _dlistView:DuplicateListView = null;
      
      private var _bg:Bitmap = null;
      
      private var _control:BraveDoorControl;
      
      private var _data:BraveDoorListModel;
      
      public function BraveDoorView(param1:BraveDoorControl, param2:BraveDoorListModel)
      {
         this._control = param1;
         this._data = param2;
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         if(this._dmapView != null)
         {
            ObjectUtils.disposeObject(this._dmapView);
            this._dmapView = null;
         }
         if(this._dlistView != null)
         {
            ObjectUtils.disposeObject(this._dlistView);
            this._dlistView = null;
         }
         this._bg = ComponentFactory.Instance.creatBitmap("asset.braveDoor.bgIcon");
         addChild(this._bg);
         var _loc1_:Vector.<BraveDoorDuplicateInfo> = BraveDoorManager.instance.getDuplicateTemInfo();
         var _loc2_:int = BraveDoorManager.instance.currentPage;
         this._dmapView = ComponentFactory.Instance.creatCustomObject("ddt.braveDoor.duplicateMapView");
         this._dmapView.initView(this._control,_loc1_[_loc2_]);
         this._dlistView = ComponentFactory.Instance.creatCustomObject("ddt.braveDoor.DuplicateListView");
         this._dlistView.initView(this._control,this._data);
         addChild(this._dmapView);
         addChild(this._dlistView);
      }
      
      public function dispose() : void
      {
         this._control = null;
         this._data = null;
         if(Boolean(this._dmapView))
         {
            ObjectUtils.disposeObject(this._dmapView);
         }
         this._dmapView = null;
         if(Boolean(this._dlistView))
         {
            ObjectUtils.disposeObject(this._dlistView);
         }
         this._dlistView = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
      }
   }
}

