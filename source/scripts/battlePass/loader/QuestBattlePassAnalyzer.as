package battlePass.loader
{
   import battlePass.data.QuestBattlePassInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   
   public class QuestBattlePassAnalyzer extends DataAnalyzer
   {
      
      public var list:Dictionary = new Dictionary();
      
      public function QuestBattlePassAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:XML = null;
         var _loc4_:QuestBattlePassInfo = null;
         var _loc5_:XML = new XML(param1);
         if(_loc5_.@value == "true")
         {
            _loc2_ = _loc5_..Item;
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = new QuestBattlePassInfo();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc3_);
               this.list[_loc4_.QuestID] = _loc4_;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc5_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

