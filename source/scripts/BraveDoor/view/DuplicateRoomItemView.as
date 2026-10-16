package BraveDoor.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import room.model.RoomInfo;
   
   public class DuplicateRoomItemView extends Sprite implements Disposeable
   {
      
      private var _info:RoomInfo;
      
      private var _itemBg:Bitmap;
      
      private var _desc:FilterFrameText;
      
      private var _placeCountText:FilterFrameText;
      
      public function DuplicateRoomItemView(param1:RoomInfo = null)
      {
         this._info = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.buttonMode = true;
         this._desc = UICreatShortcut.creatTextAndAdd("asset.braveDoor.duplicateRoom.decText","OOXX",this);
         this._placeCountText = UICreatShortcut.creatTextAndAdd("asset.braveDoor.duplicateRoom.placeCountText","OOXX",this);
         this.update();
      }
      
      private function update() : void
      {
         if(this._info != null)
         {
            this._desc.text = LanguageMgr.GetTranslation("DuplicateRoomItemView.Number");
            this._placeCountText.text = String(this._info.totalPlayer) + "/" + String(this._info.placeCount);
            this.updateBgItem(this._info.mapId);
         }
      }
      
      private function updateBgItem(param1:int) : void
      {
         if(Boolean(this._itemBg))
         {
            ObjectUtils.disposeObject(this._itemBg);
            this._itemBg = null;
         }
         this._itemBg = ComponentFactory.Instance.creat("asset.braveDoor.room.duplicateIcon" + param1);
         addChildAt(this._itemBg,0);
      }
      
      public function get info() : RoomInfo
      {
         return this._info;
      }
      
      public function set info(param1:RoomInfo) : void
      {
         this._info = param1;
         this.update();
      }
      
      public function dispose() : void
      {
         if(Boolean(this._itemBg))
         {
            ObjectUtils.disposeObject(this._itemBg);
         }
         this._itemBg = null;
         if(Boolean(this._desc))
         {
            ObjectUtils.disposeObject(this._desc);
         }
         this._desc = null;
         if(Boolean(this._placeCountText))
         {
            ObjectUtils.disposeObject(this._placeCountText);
         }
         this._placeCountText = null;
         this._info = null;
      }
   }
}

