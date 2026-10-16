package superWinner.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import superWinner.data.SuperWinnerAwardsMode;
   
   public class SuperWinnerAnalyze extends DataAnalyzer
   {
      
      private var _awardsArr:Vector.<Object> = new Vector.<Object>();
      
      public function SuperWinnerAnalyze(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:Vector.<SuperWinnerAwardsMode> = null;
         var _loc3_:XML = null;
         var _loc4_:uint = 0;
         var _loc5_:SuperWinnerAwardsMode = null;
         var _loc6_:XML = new XML(param1);
         var _loc7_:XMLList = _loc6_..Item;
         var _loc8_:int = 0;
         while(_loc8_ < 6)
         {
            _loc2_ = new Vector.<SuperWinnerAwardsMode>();
            this._awardsArr.push(_loc2_);
            _loc8_++;
         }
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_.length())
         {
            _loc3_ = _loc7_[_loc9_];
            _loc4_ = _loc3_.@rank - 1;
            _loc5_ = new SuperWinnerAwardsMode();
            _loc5_.type = _loc3_.@rank;
            _loc5_.goodId = _loc3_.@template;
            _loc5_.count = _loc3_.@count;
            (this._awardsArr[5 - _loc4_] as Vector.<SuperWinnerAwardsMode>).push(_loc5_);
            _loc9_++;
         }
         onAnalyzeComplete();
      }
      
      public function get awards() : Vector.<Object>
      {
         return this._awardsArr;
      }
   }
}

