package BombTurnTable.data
{
   public class BombTurnTableGoodInfo
   {
      
      private var _place:int;
      
      private var _templateId:int;
      
      private var _goodCount:int;
      
      private var _validDate:int;
      
      private var _sex:int;
      
      private var _isReceive:int;
      
      public function BombTurnTableGoodInfo()
      {
         super();
      }
      
      public function get isReceive() : int
      {
         return this._isReceive;
      }
      
      public function set isReceive(param1:int) : void
      {
         this._isReceive = param1;
      }
      
      public function get sex() : int
      {
         return this._sex;
      }
      
      public function set sex(param1:int) : void
      {
         this._sex = param1;
      }
      
      public function get validDate() : int
      {
         return this._validDate;
      }
      
      public function set validDate(param1:int) : void
      {
         this._validDate = param1;
      }
      
      public function get goodCount() : int
      {
         return this._goodCount;
      }
      
      public function set goodCount(param1:int) : void
      {
         this._goodCount = param1;
      }
      
      public function get templateId() : int
      {
         return this._templateId;
      }
      
      public function set templateId(param1:int) : void
      {
         this._templateId = param1;
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function set place(param1:int) : void
      {
         this._place = param1;
      }
   }
}

