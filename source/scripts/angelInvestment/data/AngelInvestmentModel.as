package angelInvestment.data
{
   import road7th.data.DictionaryData;
   
   public class AngelInvestmentModel
   {
      
      private var _isOpen:Boolean = false;
      
      private var _data:DictionaryData;
      
      public function AngelInvestmentModel()
      {
         super();
      }
      
      public function get data() : DictionaryData
      {
         return this._data;
      }
      
      public function set data(param1:DictionaryData) : void
      {
         this._data = param1;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function set isOpen(param1:Boolean) : void
      {
         this._isOpen = param1;
      }
   }
}

