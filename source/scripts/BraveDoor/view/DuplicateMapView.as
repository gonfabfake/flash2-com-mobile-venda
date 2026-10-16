package BraveDoor.view
{
   import BraveDoor.BraveDoorControl;
   import BraveDoor.BraveDoorManager;
   import BraveDoor.data.BraveDoorDuplicateInfo;
   import BraveDoor.data.DuplicateInfo;
   import BraveDoor.event.BraveDoorEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import road7th.data.DictionaryData;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class DuplicateMapView extends Sprite implements Disposeable
   {
      
      private var _title:Bitmap = null;
      
      private var _duplicateList:DictionaryData = new DictionaryData();
      
      private var _duplicats:BraveDoorDuplicateInfo;
      
      private var _mapSpri:Sprite = new Sprite();
      
      private var _control:BraveDoorControl;
      
      private var _curSelectDupID:int = -1;
      
      private var _mapBg:Bitmap = null;
      
      private var _baseBtn:duplicateIconButton;
      
      public function DuplicateMapView()
      {
         super();
      }
      
      public function initView(param1:BraveDoorControl, param2:BraveDoorDuplicateInfo) : void
      {
         this._control = param1;
         this._duplicats = param2;
         this._mapSpri.removeChildren();
         addChild(this._mapSpri);
         this.createMap();
         this._title = ComponentFactory.Instance.creatBitmap("asset.braveDoor.titleIcon");
         addChild(this._title);
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(Boolean(this._control))
         {
            this._control.addEventListener("selectedDuplicate",this.selectedDulicateHandler);
         }
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._control))
         {
            this._control.removeEventListener("selectedDuplicate",this.selectedDulicateHandler);
         }
      }
      
      private function selectedDulicateHandler(param1:BraveDoorEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:int = int(param1.data);
         for each(_loc4_ in this._duplicateList)
         {
            _loc4_.enable = true;
            this.updateDuplicateFilter(_loc4_,false);
         }
         this.curSelectDupID = _loc3_;
         if(this._duplicateList.hasKey(_loc3_))
         {
            _loc2_ = this._duplicateList[_loc3_];
            _loc2_.enable = false;
            this.updateDuplicateFilter(_loc2_,true);
         }
      }
      
      public function set isEnableClick(param1:Boolean) : void
      {
         this._mapSpri.mouseChildren = param1;
         this._mapSpri.mouseEnabled = param1;
      }
      
      protected function createMap() : void
      {
         var _loc1_:int = BraveDoorManager.instance.currentPage;
         this._mapBg = null;
         if(this._duplicats != null)
         {
            this._mapBg = ComponentFactory.Instance.creatBitmap(this._duplicats.mapUrl);
            this._mapBg.height = this._duplicats.mapHeight;
            this._mapBg.width = this._duplicats.mapWidth;
            this._mapBg.x = this._duplicats.mapX;
            this._mapBg.y = this._duplicats.mapY;
            this._mapSpri.addChild(this._mapBg);
         }
         this.createDuplicates(this._duplicats);
      }
      
      protected function createDuplicates(param1:BraveDoorDuplicateInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<DuplicateInfo> = null;
         _loc2_ = 0;
         _loc3_ = param1.duplicateInfo;
         var _loc4_:int = int(_loc3_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this._baseBtn = new duplicateIconButton(_loc3_[_loc2_]);
            this._baseBtn.beginChanges();
            this._baseBtn.x = _loc3_[_loc2_].x;
            this._baseBtn.y = _loc3_[_loc2_].y;
            this._baseBtn.backStyle = _loc3_[_loc2_].backStyle;
            this._baseBtn.addEventListener("click",this.__duplicateClickHandler);
            this._baseBtn.addEventListener("mouseMove",this.__btnOver);
            this._baseBtn.addEventListener("mouseOut",this.__btnOut);
            this._baseBtn.filterString = _loc3_[_loc2_].filterString;
            this._baseBtn.commitChanges();
            this._duplicateList[_loc3_[_loc2_].id] = this._baseBtn;
            this._mapSpri.addChild(this._baseBtn);
            _loc2_++;
         }
      }
      
      private function __btnOver(param1:MouseEvent) : void
      {
         var _loc2_:duplicateIconButton = param1.target as duplicateIconButton;
         if(this.isCanFilter(_loc2_.info.id))
         {
            this.updateDuplicateFilter(_loc2_,true);
         }
      }
      
      private function __btnOut(param1:MouseEvent) : void
      {
         var _loc2_:duplicateIconButton = param1.target as duplicateIconButton;
         if(Boolean(_loc2_) && Boolean(_loc2_.info) && this.isCanFilter(_loc2_.info.id))
         {
            this.updateDuplicateFilter(_loc2_,false);
         }
      }
      
      private function isCanFilter(param1:int) : Boolean
      {
         return this.curSelectDupID != param1;
      }
      
      private function updateDuplicateFilter(param1:duplicateIconButton, param2:Boolean) : void
      {
         if(param2)
         {
            param1.filters = [new GlowFilter(16776960,1,8,8,2,2)];
         }
         else
         {
            param1.filters = null;
         }
      }
      
      private function __duplicateClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:RoomInfo = null;
         SoundManager.instance.playButtonSound();
         _loc2_ = RoomManager.Instance.current;
         if(Boolean((_loc2_) && _loc2_.selfRoomPlayer) && Boolean(!_loc2_.selfRoomPlayer.isHost) && this._control.currentRoomType != 1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("game.braveDoor.noRoot.selectMap"));
            return;
         }
         var _loc3_:int = duplicateIconButton(param1.target).info.id;
         if(this.levCheck(_loc3_))
         {
            return;
         }
         var _loc4_:DuplicateSelectView = ComponentFactory.Instance.creat("ddt.braveDoor.duplicateSelectFrame",[this._control]);
         if(Boolean(_loc4_))
         {
            LayerManager.Instance.addToLayer(_loc4_,3,true,1);
            _loc4_.duplicateID = _loc3_;
         }
      }
      
      private function levCheck(param1:int) : Boolean
      {
         var _loc2_:DungeonInfo = MapManager.getBraveDoorDuplicateInfo(param1);
         if(PlayerManager.Instance.Self.Grade < _loc2_.LevelLimits)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.clew",_loc2_.LevelLimits));
            return true;
         }
         return false;
      }
      
      public function get curSelectDupID() : int
      {
         return this._curSelectDupID;
      }
      
      public function set curSelectDupID(param1:int) : void
      {
         this._curSelectDupID = param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = null;
         if(Boolean(this._title))
         {
            ObjectUtils.disposeObject(this._title);
         }
         this.removeEvent();
         if(Boolean(this._duplicateList))
         {
            while(this._duplicateList.list.length > 0)
            {
               _loc1_ = this._duplicateList.list.shift();
               _loc1_.removeEventListener("click",this.__duplicateClickHandler);
               _loc1_.removeEventListener("mouseMove",this.__btnOver);
               _loc1_.removeEventListener("mouseOut",this.__btnOut);
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         if(Boolean(this._mapSpri))
         {
            ObjectUtils.disposeAllChildren(this._mapSpri);
         }
         if(Boolean(this._mapBg))
         {
            ObjectUtils.disposeObject(this._mapBg);
         }
         this._mapSpri = null;
         this._duplicateList = null;
         this._duplicats = null;
         this._title = null;
         this._baseBtn = null;
         this._mapBg = null;
         this._control = null;
      }
   }
}

