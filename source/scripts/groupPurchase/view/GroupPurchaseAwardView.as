package groupPurchase.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import groupPurchase.GroupPurchaseManager;
   import groupPurchase.data.GroupPurchaseAwardInfo;
   
   public class GroupPurchaseAwardView extends Sprite implements Disposeable
   {
      
      private var _awardList:Object;
      
      public function GroupPurchaseAwardView()
      {
         super();
         this._awardList = GroupPurchaseManager.instance.awardInfoList;
         var _loc1_:int = 1;
         while(_loc1_ <= 12)
         {
            this.createAwardCell(_loc1_);
            _loc1_++;
         }
      }
      
      private function createAwardCell(param1:int) : void
      {
         var _loc2_:BagCell = null;
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:GroupPurchaseAwardInfo = this._awardList[param1];
         if(Boolean(_loc4_))
         {
            _loc2_ = new BagCell(1,null,true,null,false);
            _loc2_.tipGapH = 0;
            _loc2_.tipGapV = 0;
            _loc3_ = new InventoryItemInfo();
            _loc3_.TemplateID = _loc4_.TemplateID;
            ItemManager.fill(_loc3_);
            _loc3_.StrengthenLevel = _loc4_.StrengthenLevel;
            _loc3_.AttackCompose = _loc4_.AttackCompose;
            _loc3_.DefendCompose = _loc4_.DefendCompose;
            _loc3_.LuckCompose = _loc4_.LuckCompose;
            _loc3_.AgilityCompose = _loc4_.AgilityCompose;
            _loc3_.IsBinds = _loc4_.IsBind;
            _loc3_.ValidDate = _loc4_.ValidDate;
            _loc3_.Count = _loc4_.Count;
            _loc2_.info = _loc3_;
            if(_loc3_.Count > 1)
            {
               _loc2_.setCount(_loc3_.Count);
            }
            PositionUtils.setPos(_loc2_,"groupPurchase.awardCellPos" + param1);
            addChild(_loc2_);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._awardList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

