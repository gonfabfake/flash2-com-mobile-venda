package RechargeRank
{
   import RechargeRank.data.RechargeRankVo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import wonderfulActivity.WonderfulActivityManager;
   import wonderfulActivity.data.GmActivityInfo;
   import wonderfulActivity.data.LeftViewInfoVo;
   
   public class RechargeRankManager extends EventDispatcher
   {
      
      private static var _instance:RechargeRankManager;
      
      public static const RECHARGE_UPDATEVIEW:String = "rechargeUpdateView";
      
      public var actId:String;
      
      public var status:int;
      
      public var xmlData:GmActivityInfo;
      
      public var myConsume:int;
      
      public var rankList:Array;
      
      private var requestCount:int = 0;
      
      public function RechargeRankManager()
      {
         super();
      }
      
      public static function get instance() : RechargeRankManager
      {
         if(!_instance)
         {
            _instance = new RechargeRankManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.RECHARGE_RANK,this.__updateInfo);
      }
      
      protected function __updateInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc7_:PackageIn = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         this.actId = (_loc7_ = param1.pkg).readUTF();
         var _loc8_:Boolean = _loc7_.readBoolean();
         var _loc9_:Dictionary = WonderfulActivityManager.Instance.activityData;
         var _loc10_:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         if(_loc8_)
         {
            this.status = _loc7_.readInt();
            this.xmlData = _loc9_[this.actId];
            if(!this.xmlData)
            {
               ++this.requestCount;
               if(this.requestCount <= 5)
               {
                  SocketManager.Instance.out.requestWonderfulActInit(0);
               }
               return;
            }
            if(WonderfulActivityManager.Instance.actList.indexOf(this.actId) == -1)
            {
               _loc10_[this.actId] = new LeftViewInfoVo(61,"· " + this.xmlData.activityName,this.xmlData.icon);
               WonderfulActivityManager.Instance.addElement(this.actId);
            }
            this.rankList = [];
            _loc2_ = _loc7_.readInt();
            if(_loc2_ <= 0)
            {
               _loc3_ = 0;
               while(_loc3_ < 10)
               {
                  _loc4_ = new RechargeRankVo();
                  _loc4_.userId = 0;
                  _loc4_.name = "";
                  _loc4_.vipLvl = 0;
                  _loc4_.consume = 0;
                  this.rankList.push(_loc4_);
                  _loc3_++;
               }
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ <= _loc2_ - 1)
               {
                  _loc6_ = new RechargeRankVo();
                  _loc6_.userId = _loc7_.readInt();
                  _loc6_.name = _loc7_.readUTF();
                  _loc6_.vipLvl = _loc7_.readByte();
                  _loc6_.consume = _loc7_.readInt();
                  this.rankList.push(_loc6_);
                  _loc5_++;
               }
            }
            this.myConsume = _loc7_.readInt();
            dispatchEvent(new Event("rechargeUpdateView"));
         }
         else
         {
            WonderfulActivityManager.Instance.removeElement(this.actId);
         }
      }
   }
}

