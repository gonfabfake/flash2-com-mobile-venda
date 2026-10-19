package rank.view
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import rank.RankManager;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   
   public class RankMenu extends Sprite implements Disposeable
   {
      
      private var _selectItem:RankCell;
      
      private var _cellArr:Array = [];
      
      public function RankMenu()
      {
         super();
         this.createUI();
      }
      
      private function createUI() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc4_ in WonderfulActivityManager.Instance.rankDic)
         {
            _loc1_ = WonderfulActivityManager.Instance.rankDic[_loc4_] as GmActivityInfo;
            if(Boolean(_loc1_))
            {
               _loc2_ = new RankCell(_loc1_);
               _loc2_.y = _loc3_ * 54;
               _loc2_.addEventListener("click",this._cellClickedHandle);
               addChild(_loc2_);
               this._cellArr.push(_loc2_);
               _loc3_++;
            }
         }
      }
      
      private function _cellClickedHandle(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:RankCell = param1.currentTarget as RankCell;
         this.setSelectItem(_loc2_);
         RankManager.instance.model.currentInfo = _loc2_.info;
         RankManager.instance.setCurrentInfo();
      }
      
      public function init() : void
      {
         this._cellArr[0].dispatchEvent(new MouseEvent("click"));
      }
      
      private function setSelectItem(param1:RankCell) : void
      {
         if(param1 != this._selectItem)
         {
            if(Boolean(this._selectItem))
            {
               this._selectItem.selected = false;
            }
            this._selectItem = param1;
            this._selectItem.selected = true;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         if(Boolean(this._selectItem))
         {
            this._selectItem.dispose();
            this._selectItem = null;
         }
         _loc1_ = 0;
         while(_loc1_ < this._cellArr.length)
         {
            _loc2_ = this._cellArr[_loc1_];
            if(Boolean(_loc2_))
            {
               _loc2_.removeEventListener("click",this._cellClickedHandle);
               _loc2_.dispose();
               _loc2_ = null;
            }
            _loc1_++;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

