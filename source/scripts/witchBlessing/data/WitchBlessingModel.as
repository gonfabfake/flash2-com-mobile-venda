package witchBlessing.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.ServerConfigManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class WitchBlessingModel extends EventDispatcher implements Disposeable
   {
      
      public var isOpen:Boolean = true;
      
      public var totalExp:int = 0;
      
      public var startDate:Date;
      
      public var endDate:Date;
      
      public var lv1GetAwardsTimes:int = 0;
      
      public var lv2GetAwardsTimes:int = 0;
      
      public var lv3GetAwardsTimes:int = 0;
      
      public var lv1CD:int = 0;
      
      public var lv2CD:int = 0;
      
      public var lv3CD:int = 0;
      
      public var isDouble:Boolean = false;
      
      private var _itemInfoList:Array = [];
      
      public var awardslist1:Array = [];
      
      public var awardslist2:Array = [];
      
      public var awardslist3:Array = [];
      
      public var ExpArr:Array = [0];
      
      public var AwardsNums:Array = [];
      
      public var DoubleMoney:Array = [];
      
      public function WitchBlessingModel(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function set itemInfoList(param1:Array) : void
      {
         var _loc2_:WitchBlessingPackageInfo = null;
         var _loc3_:String = null;
         var _loc4_:WitchBlessingInfo = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc2_ = param1[_loc6_];
            if(_loc2_.Quality == 1)
            {
               this.awardslist1.push(_loc2_);
            }
            else if(_loc2_.Quality == 2)
            {
               this.awardslist2.push(_loc2_);
            }
            else if(_loc2_.Quality == 3)
            {
               this.awardslist3.push(_loc2_);
            }
            _loc6_++;
         }
         this._itemInfoList = [this.awardslist1,this.awardslist2,this.awardslist3];
         var _loc7_:Object = ServerConfigManager.instance.serverConfigInfo["WitchBlessConfig"];
         if(Boolean(_loc7_))
         {
            _loc3_ = _loc7_.Value;
            if(Boolean(_loc3_) && _loc3_ != "")
            {
               _loc4_ = new WitchBlessingInfo();
               _loc5_ = _loc3_.split("|");
               _loc4_.ExpArr = (_loc5_[0] as String).split(",");
               _loc4_.AwardsNums = (_loc5_[1] as String).split(",");
               _loc4_.DoubleMoney = (_loc5_[2] as String).split(",");
            }
            this.infoDate = _loc4_;
         }
      }
      
      public function set infoDate(param1:WitchBlessingInfo) : void
      {
         var _loc2_:Array = param1.ExpArr;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ += int(_loc2_[_loc4_]);
            this.ExpArr.push(_loc3_);
            _loc4_++;
         }
         this.AwardsNums = param1.AwardsNums;
         this.DoubleMoney = param1.DoubleMoney;
      }
      
      public function get itemInfoList() : Array
      {
         return this._itemInfoList;
      }
      
      public function get activityTime() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = "";
         if(Boolean(this.startDate) && Boolean(this.endDate))
         {
            _loc1_ = this.startDate.minutes > 9 ? this.startDate.minutes + "" : "0" + this.startDate.minutes;
            _loc2_ = this.endDate.minutes > 9 ? this.endDate.minutes + "" : "0" + this.endDate.minutes;
            _loc3_ = this.startDate.fullYear + "." + (this.startDate.month + 1) + "." + this.startDate.date + " - " + this.endDate.fullYear + "." + (this.endDate.month + 1) + "." + this.endDate.date;
         }
         return _loc3_;
      }
      
      public function dispose() : void
      {
      }
   }
}

