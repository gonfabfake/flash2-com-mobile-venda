package prayIndiana.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Sprite;
   import prayIndiana.PrayIndianaManager;
   
   public class PrayGoodsView extends Sprite
   {
      
      private var _goodsFrameArr:Array;
      
      private var _cell:BagCell;
      
      private var _cellArr:Array;
      
      private var _goodItemContainerAll:Array;
      
      private var _goodsItemSprite:Sprite;
      
      public function PrayGoodsView()
      {
         super();
      }
      
      private function initView() : void
      {
      }
      
      public function setInfo(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         _loc2_ = 0;
         _loc3_ = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         if(param1 == null || param1.length <= 0)
         {
            return;
         }
         var _loc8_:int = 0;
         this._cellArr = [];
         this._goodItemContainerAll = [];
         this._goodsItemSprite = new Sprite();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc8_ = param1[_loc2_].Quality < 5 ? 1 : 2;
            _loc3_ = ComponentFactory.Instance.creat("prayIndiana.GoodsF");
            _loc3_.gotoAndStop(_loc8_);
            _loc4_ = ItemManager.Instance.getTemplateById(param1[_loc2_].TemplateID) as ItemTemplateInfo;
            _loc5_ = new InventoryItemInfo();
            ObjectUtils.copyProperties(_loc5_,_loc4_);
            _loc5_.ValidDate = param1[_loc2_].ValidDate;
            _loc5_.StrengthenLevel = param1[_loc2_].StrengthLevel;
            _loc5_.AttackCompose = param1[_loc2_].AttackCompose;
            _loc5_.DefendCompose = param1[_loc2_].DefendCompose;
            _loc5_.LuckCompose = param1[_loc2_].LuckCompose;
            _loc5_.AgilityCompose = param1[_loc2_].AgilityCompose;
            _loc5_.IsBinds = param1[_loc2_].IsBind;
            _loc5_.Count = param1[_loc2_].Count;
            _loc5_.Place = param1[_loc2_].Position;
            _loc5_.exaltLevel = param1[_loc2_].Quality;
            this._cell = new BagCell(0,_loc5_,false,null);
            this._cell.width = 56;
            this._cell.height = 55;
            this._cell.x = 10;
            this._cell.y = 11;
            this._cell.setBgVisible(false);
            if(Boolean(param1[_loc2_].IsSelect))
            {
               this._cell.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._cell.alpha = 0.4;
               PrayIndianaManager.Instance.model.getGoods.push(_loc2_);
            }
            _loc6_ = 68;
            _loc7_ = 68;
            _loc6_ *= int(_loc2_ % 7);
            _loc7_ *= int(_loc2_ / 7);
            _loc3_.x = _loc6_;
            _loc3_.y = _loc7_;
            this._cell.x = _loc6_ + 10;
            this._cell.y = _loc7_ + 11;
            this._goodsItemSprite.addChild(this._cell);
            this._cellArr.push(this._cell);
            addChild(_loc3_);
            addChild(this._goodsItemSprite);
            this._goodItemContainerAll.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function removeEvnet() : void
      {
      }
      
      public function dispose() : void
      {
      }
      
      public function get goodItemContainerAll() : Array
      {
         return this._goodItemContainerAll;
      }
      
      public function set goodItemContainerAll(param1:Array) : void
      {
         this._goodItemContainerAll = param1;
      }
      
      public function get cellArr() : Array
      {
         return this._cellArr;
      }
      
      public function set cellArr(param1:Array) : void
      {
         this._cellArr = param1;
      }
      
      public function get goodsItemSprite() : Sprite
      {
         return this._goodsItemSprite;
      }
      
      public function set goodsItemSprite(param1:Sprite) : void
      {
         this._goodsItemSprite = param1;
      }
   }
}

