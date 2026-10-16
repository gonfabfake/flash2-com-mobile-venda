package battlePass.loader
{
   import battlePass.data.QuestBattlePassItemInfo;
   import battlePass.data.QuestBattlePassRewardInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import flash.utils.Dictionary;
   
   public class QuestBattlePassItemAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function QuestBattlePassItemAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:QuestBattlePassRewardInfo = null;
         var _loc6_:XMLList = null;
         var _loc7_:Vector.<QuestBattlePassItemInfo> = null;
         var _loc8_:XML = null;
         var _loc9_:QuestBattlePassItemInfo = null;
         var _loc10_:XML = new XML(param1);
         var _loc11_:Dictionary = new Dictionary();
         var _loc12_:XMLList = _loc10_..Item;
         if(_loc10_.@value == "true")
         {
            for each(_loc2_ in _loc12_)
            {
               _loc3_ = parseInt(_loc2_.@Score);
               _loc4_ = parseInt(_loc2_.@ID);
               _loc5_ = new QuestBattlePassRewardInfo();
               _loc5_.Score = _loc3_;
               _loc5_.ID = _loc4_;
               if(_loc3_ > 0)
               {
                  _loc6_ = _loc2_.Rewards.children();
                  _loc7_ = new Vector.<QuestBattlePassItemInfo>();
                  for each(_loc8_ in _loc6_)
                  {
                     _loc9_ = new QuestBattlePassItemInfo();
                     _loc9_.ScoreCount = _loc3_;
                     _loc9_.ItemID = parseInt(_loc8_.@ItemID);
                     _loc9_.ItemCount = parseInt(_loc8_.@ItemCount);
                     _loc7_.push(_loc9_);
                  }
                  _loc5_.Items = _loc7_;
               }
               this.list[_loc3_] = _loc5_;
               onAnalyzeComplete();
            }
         }
         else
         {
            message = _loc10_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

