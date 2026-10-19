package sevenday.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SevendayTaskCell extends Sprite implements Disposeable
   {
      
      private var _cell:BagCell;
      
      private var _rewardCompleteIcon:Bitmap;
      
      private var _isGet:Boolean;
      
      public function SevendayTaskCell()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._cell = new BagCell(0);
         addChild(this._cell);
         this._rewardCompleteIcon = ComponentFactory.Instance.creatBitmap("asset.sevenday.isgetgift");
         this._rewardCompleteIcon.visible = false;
         addChild(this._rewardCompleteIcon);
      }
      
      public function update(param1:ItemTemplateInfo, param2:int = 1) : void
      {
         this._cell.info = param1;
         this._cell.setCount(param2);
      }
      
      public function get isGet() : Boolean
      {
         return this._isGet;
      }
      
      public function set isGet(param1:Boolean) : void
      {
         this._isGet = param1;
         this._rewardCompleteIcon.visible = this.isGet;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._rewardCompleteIcon);
         this._rewardCompleteIcon = null;
      }
   }
}

