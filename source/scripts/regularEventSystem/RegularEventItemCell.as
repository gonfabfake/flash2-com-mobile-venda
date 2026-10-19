package regularEventSystem
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.goods.ItemTemplateInfo;
   
   public class RegularEventItemCell extends BagCell
   {
      
      public var count:int;
      
      public function RegularEventItemCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:String = "")
      {
         super(param1,param2,param3,ComponentFactory.Instance.creatBitmap(param4),false);
         this.count = param1;
         this.WanderItemDegerGosterme(this.count);
      }
      
      public function WanderItemDegerGosterme(param1:int) : void
      {
         if(Boolean(info) && this.count >= 1)
         {
            _tbxCount.text = String(this.count);
            _tbxCount.visible = true;
            _tbxCount.x = 10;
            addChild(_tbxCount);
         }
         else
         {
            _tbxCount.visible = false;
         }
      }
   }
}

