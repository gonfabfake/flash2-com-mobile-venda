package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.event.BraveDoorEvent;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class DuplicateSelectView extends Frame implements Disposeable
   {
      
      public static var SELECT_DUPLICATE:String = "selectDuplicate";
      
      private var _duplicateMap:Bitmap;
      
      private var _dropList:BraveDoorDropList;
      
      private var _bg:Bitmap;
      
      private var _selectDupBtn:BaseButton;
      
      private var _info:DungeonInfo;
      
      private var _control:BraveDoorControl;
      
      public function DuplicateSelectView(param1:BraveDoorControl)
      {
         this._control = param1;
         super();
      }
      
      override protected function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.braveDoor.duplicateDrop.bgIcon");
         this._selectDupBtn = ComponentFactory.Instance.creatComponentByStylename("braveDoor.selectDuplicateView.selectDupBtn");
         this._selectDupBtn.enable = false;
         this._dropList = new BraveDoorDropList();
         this._dropList.x = 15;
         this._dropList.y = 178;
         this._dropList.visible = true;
         super.init();
         titleText = LanguageMgr.GetTranslation("game.braveDoor.selectDulicate");
         this.initEvent();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._bg);
         addChild(this._dropList);
         addChild(this._selectDupBtn);
      }
      
      private function initEvent() : void
      {
         this.addEventListener("response",this.__responseHandler);
         this._selectDupBtn.addEventListener("click",this.__selectDupHandler);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener("response",this.__responseHandler);
         this._selectDupBtn.removeEventListener("click",this.__selectDupHandler);
      }
      
      private function __selectDupHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(Boolean(this._control))
         {
            this._control.dispatchEvent(new BraveDoorEvent("selectedDuplicate",this._info.ID));
         }
         this.dispose();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == 0 || param1.responseCode == 1)
         {
            SoundManager.instance.playButtonSound();
            this.dispose();
         }
      }
      
      public function set duplicateID(param1:int) : void
      {
         this._info = MapManager.getBraveDoorDuplicateInfo(param1);
         this.updateMap(param1);
         if(Boolean(this._info && param1 != 0) && Boolean(param1 != 10000) && this._info.SimpleTemplateIds != "")
         {
            this._dropList.info = this._info.SimpleTemplateIds.split(",");
         }
         this._selectDupBtn.enable = true;
      }
      
      private function updateMap(param1:int) : void
      {
         if(Boolean(this._duplicateMap))
         {
            ObjectUtils.disposeObject(this._duplicateMap);
            this._duplicateMap = null;
         }
         if(param1 != 0)
         {
            this._duplicateMap = ComponentFactory.Instance.creatBitmap("asset.braveDoor.duplicateIcon" + param1);
            this._duplicateMap.x = 20;
            this._duplicateMap.y = 44;
            addChild(this._duplicateMap);
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._dropList))
         {
            ObjectUtils.disposeObject(this._dropList);
         }
         this._dropList = null;
         if(Boolean(this._duplicateMap))
         {
            ObjectUtils.disposeObject(this._duplicateMap);
         }
         this._duplicateMap = null;
         if(Boolean(this._selectDupBtn))
         {
            ObjectUtils.disposeObject(this._selectDupBtn);
         }
         this._selectDupBtn = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this._info = null;
         this._control = null;
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

