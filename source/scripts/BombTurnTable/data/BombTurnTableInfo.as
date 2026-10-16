package BombTurnTable.data
{
   public class BombTurnTableInfo
   {
      
      private var _level:int;
      
      private var _goodsInfo:Vector.<BombTurnTableGoodInfo>;
      
      public function BombTurnTableInfo()
      {
         super();
      }
      
      public function get goodsInfo() : Vector.<BombTurnTableGoodInfo>
      {
         if(this._goodsInfo == null)
         {
            this._goodsInfo = new Vector.<BombTurnTableGoodInfo>();
         }
         return this._goodsInfo;
      }
      
      public function set goodsInfo(param1:Vector.<BombTurnTableGoodInfo>) : void
      {
         this._goodsInfo = param1;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get quality() : int
      {
         return (this._level - 1) / 4;
      }
   }
}

