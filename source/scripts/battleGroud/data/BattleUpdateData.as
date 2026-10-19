package battleGroud.data
{
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   
   public class BattleUpdateData
   {
      
      public var addDayPrestge:int;
      
      public var totalPrestige:int;
      
      public var fairBattleDayPrestige:int;
      
      public var rankings:int;
      
      public var yePrestige:int;
      
      public var weekPrestige:int = 0;
      
      private var _prestigeTimes:int;
      
      public function BattleUpdateData()
      {
         super();
      }
      
      public function get prestigeTimes() : int
      {
         return 0;
      }
      
      public function get prestigeTotalTimes() : int
      {
         var _loc1_:int = ServerConfigManager.instance.getVipPrestigeTimes(PlayerManager.Instance.Self.VIPLevel);
         return ServerConfigManager.instance.getPrestigeTimes + _loc1_;
      }
   }
}

