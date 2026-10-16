package panicBuying.views
{
   import bagAndInfo.cell.BagCell;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.tips.GoodTipInfo;
   
   public class PanicBuyingCell extends BagCell
   {
      
      private var _expireTime:int;
      
      private var _buyType:int;
      
      public function PanicBuyingCell(param1:int, param2:ItemTemplateInfo, param3:int, param4:int)
      {
         this._buyType = param3;
         this._expireTime = param4;
         super(param1,param2);
      }
      
      override protected function setDefaultTipData() : void
      {
         var _loc1_:* = null;
         if(EquipType.isCardBox(_info))
         {
            tipStyle = "core.CardBoxTipPanel";
            tipData = _info;
         }
         else if(_info.CategoryID != 26)
         {
            tipStyle = "panicBuying.views.PanicBuyingTips";
            _tipData = new GoodTipInfo();
            GoodTipInfo(_tipData).itemInfo = _info;
            GoodTipInfo(_tipData).buyType = this._buyType;
            GoodTipInfo(_tipData).expireTime = this._expireTime;
            _loc1_ = _info as InventoryItemInfo;
         }
      }
   }
}

