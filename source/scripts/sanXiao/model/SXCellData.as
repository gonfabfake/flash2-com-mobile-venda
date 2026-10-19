package sanXiao.model
{
   public class SXCellData
   {
      
      public var row:Number;
      
      public var column:Number;
      
      public var type:int;
      
      public var isLocked:Boolean = false;
      
      public function SXCellData(param1:Number, param2:Number, param3:int = 0)
      {
         super();
         this.row = param1;
         this.column = param2;
         this.type = param3;
      }
   }
}

