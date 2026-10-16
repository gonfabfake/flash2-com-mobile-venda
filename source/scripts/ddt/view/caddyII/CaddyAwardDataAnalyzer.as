package ddt.view.caddyII
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   
   public class CaddyAwardDataAnalyzer extends DataAnalyzer
   {
      
      public var _awards:Vector.<CaddyAwardInfo>;
      
      public var _silverAwards:Vector.<CaddyAwardInfo>;
      
      public var _goldAwards:Vector.<CaddyAwardInfo>;
      
      public var _treasureAwards:Vector.<CaddyAwardInfo>;
      
      public var _silverToyAwards:Vector.<CaddyAwardInfo>;
      
      public var _goldToyAwards:Vector.<CaddyAwardInfo>;
      
      public function CaddyAwardDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this._awards = new Vector.<CaddyAwardInfo>();
         this._silverAwards = new Vector.<CaddyAwardInfo>();
         this._goldAwards = new Vector.<CaddyAwardInfo>();
         this._treasureAwards = new Vector.<CaddyAwardInfo>();
         this._silverToyAwards = new Vector.<CaddyAwardInfo>();
         this._goldToyAwards = new Vector.<CaddyAwardInfo>();
         var _loc4_:XML = new XML(param1);
         var _loc5_:int = _loc4_.item.length();
         var _loc6_:XMLList = _loc4_.item;
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = new CaddyAwardInfo();
            ObjectUtils.copyPorpertiesByXML(_loc3_,_loc6_[_loc2_]);
            if(_loc6_[_loc2_].@BoxType == 1)
            {
               this._awards.push(_loc3_);
            }
            else if(_loc6_[_loc2_].@BoxType == 2)
            {
               this._silverAwards.push(_loc3_);
            }
            else if(_loc6_[_loc2_].@BoxType == 3)
            {
               this._goldAwards.push(_loc3_);
            }
            else if(_loc6_[_loc2_].@BoxType == 4)
            {
               this._treasureAwards.push(_loc3_);
            }
            else if(_loc6_[_loc2_].@BoxType == 5)
            {
               this._silverToyAwards.push(_loc3_);
            }
            else if(_loc6_[_loc2_].@BoxType == 6)
            {
               this._goldToyAwards.push(_loc3_);
            }
            _loc2_++;
         }
         onAnalyzeComplete();
      }
   }
}

