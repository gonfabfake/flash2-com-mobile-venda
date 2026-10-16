package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.data.BraveDoorListModel;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   
   public class BraveDoorFrame extends Frame implements Disposeable
   {
      
      private var _control:BraveDoorControl;
      
      private var _data:BraveDoorListModel;
      
      private var _view:BraveDoorView;
      
      public function BraveDoorFrame(param1:BraveDoorControl, param2:BraveDoorListModel)
      {
         this._control = param1;
         this._data = param2;
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         titleText = LanguageMgr.GetTranslation("game.braveDoor.titleTxt");
         this._view = new BraveDoorView(this._control,this._data);
         if(Boolean(this._view))
         {
            addToContent(this._view);
         }
      }
      
      protected function initView() : void
      {
      }
      
      override public function dispose() : void
      {
         if(Boolean(this._control))
         {
            this._control.dispose();
         }
         this._control = null;
         this._data = null;
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
         }
         this._view = null;
      }
   }
}

