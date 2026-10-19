package flowerGiving.events
{
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class FlowerGivingEvent extends Event
   {
      
      public static const GIVE_FLOWER:String = "giveFlower";
      
      public static const FLOWER_FALL:String = "flowerFall";
      
      public static const GET_RECORD:String = "getReward";
      
      public static const GET_FLOWER_RANK:String = "getFlowerRank";
      
      public static const GET_REWARD:String = "getReward";
      
      public static const REWARD_INFO:String = "rewardInfo";
      
      public static const FLOWER_GIVING_OPEN:String = "flowerGivingOpen";
      
      private var _pkg:PackageIn;
      
      public function FlowerGivingEvent(param1:String, param2:PackageIn = null)
      {
         super(param1,bubbles,cancelable);
         this._pkg = param2;
      }
      
      public function get pkg() : PackageIn
      {
         return this._pkg;
      }
   }
}

