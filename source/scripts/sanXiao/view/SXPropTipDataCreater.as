package sanXiao.view
{
   import ddt.manager.LanguageMgr;
   import sanXiao.SanXiaoManager;
   
   public class SXPropTipDataCreater
   {
      
      private var _detailStringList:Array = ["","sanxiao.propCrossBomb.detail","sanxiao.propSquareBomb.detail","sanxiao.propClearColor.detail","sanxiao.propChangeColor.detail"];
      
      public function SXPropTipDataCreater()
      {
         super();
      }
      
      public function getTipData(param1:int) : Object
      {
         var _loc2_:String = LanguageMgr.GetTranslation(this._detailStringList[param1],SanXiaoManager.getInstance().getPropScore(param1));
         var _loc3_:String = SanXiaoManager.getInstance().getPropPrice(param1).toString();
         var _loc4_:Boolean = SanXiaoManager.getInstance().isDiscounts;
         var _loc5_:String = SanXiaoManager.getInstance().getPropCurPrice(param1);
         return {
            "detail":_loc2_,
            "price":_loc3_,
            "isDiscount":_loc4_,
            "curPrice":_loc5_
         };
      }
   }
}

