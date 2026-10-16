package luckStar.model
{
   import com.pickgliss.loader.DataAnalyzer;
   import luckStar.manager.LuckStarManager;
   
   public class LuckStarRankAnalyzer extends DataAnalyzer
   {
      
      private static const MAX_LIST:int = 5;
      
      public function LuckStarRankAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:Vector.<LuckStarPlayerInfo> = null;
         var _loc3_:XMLList = null;
         var _loc4_:Array = null;
         var _loc5_:LuckStarPlayerInfo = null;
         var _loc6_:int = 0;
         var _loc7_:LuckStarPlayerInfo = null;
         var _loc8_:XML = XML(param1);
         if(_loc8_.@value == "true")
         {
            _loc3_ = _loc8_..rankInfo;
            _loc4_ = [];
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length())
            {
               if(_loc6_ % MAX_LIST == 0 || _loc6_ == 0)
               {
                  _loc2_ = new Vector.<LuckStarPlayerInfo>();
                  _loc4_.push(_loc2_);
               }
               _loc5_ = new LuckStarPlayerInfo();
               _loc5_.name = String(_loc3_[_loc6_].@nickName);
               _loc5_.rank = int(_loc3_[_loc6_].@rank);
               _loc5_.starNum = int(_loc3_[_loc6_].@useStarNum);
               _loc5_.isVip = int(_loc3_[_loc6_].@isVip) != 0;
               _loc2_.push(_loc5_);
               _loc6_++;
            }
            _loc7_ = new LuckStarPlayerInfo();
            _loc7_.rank = int(_loc8_.myRank.@rank);
            _loc7_.starNum = int(_loc8_.myRank.@useStarNum);
            LuckStarManager.Instance.model.selfInfo = _loc7_;
            LuckStarManager.Instance.model.lastDate = String(_loc8_.@lastUpdateTime);
            LuckStarManager.Instance.model.rank = _loc4_;
            onAnalyzeComplete();
         }
         else
         {
            message = _loc8_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}

