package superWinner.data
{
   import ddt.manager.ItemManager;
   
   public class SuperWinnerAwardsMode
   {
      
      private var _type:uint = 0;
      
      private var _goodId:uint = 0;
      
      private var _goodName:String = "";
      
      private var _count:uint = 0;
      
      public function SuperWinnerAwardsMode()
      {
         super();
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function set type(param1:uint) : void
      {
         this._type = param1;
      }
      
      public function get goodId() : uint
      {
         return this._goodId;
      }
      
      public function set goodId(param1:uint) : void
      {
         this._goodId = param1;
         this.formatGood(this._goodId);
      }
      
      public function get goodName() : String
      {
         return this._goodName;
      }
      
      private function formatGood(param1:uint) : void
      {
         this._goodName = ItemManager.Instance.getTemplateById(param1).Name;
      }
      
      public function get count() : uint
      {
         return this._count;
      }
      
      public function set count(param1:uint) : void
      {
         this._count = param1;
      }
   }
}

