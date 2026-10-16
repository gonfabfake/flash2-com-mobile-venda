package pvePowerBuff
{
   import ddt.CoreManager;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import road7th.comm.PackageIn;
   
   public class PvePowerBuffManager extends CoreManager
   {
      
      private static var _instance:PvePowerBuffManager;
      
      public static const PVEPOWERBUFF_REFRESH:String = "pvepowerbuff_refresh";
      
      public static const PVEPOWERBUFF_GETBUFF:String = "pvepowerbuff_getbuff";
      
      public var playerInfoVc:Vector.<PlayerInfo>;
      
      public var refreshCount:int;
      
      public var refreshDate:Date;
      
      public var getBuffCount:int;
      
      public var getBuffDate:Date;
      
      public var getBuffIndex:int;
      
      public var getBuffAtk:int;
      
      public var getBuffDef:int;
      
      public var getBuffAgl:int;
      
      public var getBuffLuck:int;
      
      public var getBuffHp:int;
      
      public var getBuffMAtk:int;
      
      public var getBuffMDef:int;
      
      public var getBuffDmg:int;
      
      public var getBuffAr:int;
      
      public var isInRefresh:Boolean = false;
      
      public var isInGetBuff:Boolean = false;
      
      public function PvePowerBuffManager(param1:PvePowerBuffInstance)
      {
         super();
      }
      
      public static function get instance() : PvePowerBuffManager
      {
         if(_instance == null)
         {
            _instance = new PvePowerBuffManager(new PvePowerBuffInstance());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener("pvePowerBuff",this.__pvePowerBuffHandler);
      }
      
      private function __pvePowerBuffHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc10_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc11_:PackageIn = param1.pkg;
         var _loc12_:int = _loc11_.readInt() - 1;
         switch(_loc12_)
         {
            case 0:
               this.playerInfoVc = new Vector.<PlayerInfo>();
               this.refreshCount = _loc11_.readInt();
               this.refreshDate = _loc11_.readDate();
               this.getBuffCount = _loc11_.readInt();
               this.getBuffDate = _loc11_.readDate();
               this.getBuffIndex = _loc11_.readInt();
               _loc2_ = _loc11_.readInt();
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc4_ = new PlayerInfo();
                  _loc4_.ID = _loc11_.readInt();
                  _loc4_.Attack = _loc11_.readInt();
                  _loc4_.Defence = _loc11_.readInt();
                  _loc4_.Agility = _loc11_.readInt();
                  _loc4_.Luck = _loc11_.readInt();
                  _loc4_.Damage = _loc11_.readInt();
                  _loc4_.Guard = _loc11_.readInt();
                  _loc4_.hp = _loc11_.readInt();
                  _loc4_.Grade = _loc11_.readInt();
                  _loc4_.FightPower = _loc11_.readInt();
                  _loc4_.NickName = _loc11_.readUTF();
                  _loc4_.Sex = _loc11_.readInt();
                  _loc4_.Style = _loc11_.readUTF();
                  _loc4_.Colors = _loc11_.readUTF();
                  _loc4_.Skin = _loc11_.readUTF();
                  _loc4_.Hide = _loc11_.readInt();
                  this.playerInfoVc.push(_loc4_);
                  _loc3_++;
               }
               this.getBuffAtk = _loc11_.readInt();
               this.getBuffDef = _loc11_.readInt();
               this.getBuffAgl = _loc11_.readInt();
               this.getBuffLuck = _loc11_.readInt();
               this.getBuffDmg = _loc11_.readInt();
               this.getBuffAr = _loc11_.readInt();
               this.getBuffHp = _loc11_.readInt();
               this.getBuffMAtk = _loc11_.readInt();
               this.getBuffMDef = _loc11_.readInt();
               break;
            case 1:
               this.isInRefresh = true;
               this.playerInfoVc = new Vector.<PlayerInfo>();
               this.refreshCount = _loc11_.readInt();
               this.refreshDate = _loc11_.readDate();
               this.getBuffIndex = _loc11_.readInt();
               _loc5_ = _loc11_.readInt();
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc7_ = new PlayerInfo();
                  _loc7_.ID = _loc11_.readInt();
                  _loc7_.Attack = _loc11_.readInt();
                  _loc7_.Defence = _loc11_.readInt();
                  _loc7_.Agility = _loc11_.readInt();
                  _loc7_.Luck = _loc11_.readInt();
                  _loc7_.Damage = _loc11_.readInt();
                  _loc7_.Guard = _loc11_.readInt();
                  _loc7_.hp = _loc11_.readInt();
                  _loc7_.Grade = _loc11_.readInt();
                  _loc7_.FightPower = _loc11_.readInt();
                  _loc7_.NickName = _loc11_.readUTF();
                  _loc7_.Sex = _loc11_.readInt();
                  _loc7_.Style = _loc11_.readUTF();
                  _loc7_.Colors = _loc11_.readUTF();
                  _loc7_.Skin = _loc11_.readUTF();
                  _loc7_.Hide = _loc11_.readInt();
                  this.playerInfoVc.push(_loc7_);
                  _loc6_++;
               }
               _loc8_ = new PvePowerBuffEvent("pvepowerbuff_refresh");
               dispatchEvent(_loc8_);
               break;
            case 2:
               this.getBuffCount = _loc11_.readInt();
               this.getBuffDate = _loc11_.readDate();
               this.getBuffIndex = _loc11_.readInt();
               this.getBuffAtk = _loc11_.readInt();
               this.getBuffDef = _loc11_.readInt();
               this.getBuffAgl = _loc11_.readInt();
               this.getBuffLuck = _loc11_.readInt();
               this.getBuffDmg = _loc11_.readInt();
               this.getBuffAr = _loc11_.readInt();
               this.getBuffHp = _loc11_.readInt();
               this.getBuffMAtk = _loc11_.readInt();
               this.getBuffMDef = _loc11_.readInt();
               _loc9_ = new PvePowerBuffEvent("pvepowerbuff_getbuff");
               dispatchEvent(_loc9_);
         }
      }
      
      public function showNewBuff() : void
      {
         dispatchEvent(new PvePowerBuffEvent("pvePowerBuffOpenView"));
      }
      
      override protected function start() : void
      {
         dispatchEvent(new PvePowerBuffEvent("pvePowerBuffOpenView"));
      }
      
      public function disposeView() : void
      {
         var _loc1_:PvePowerBuffEvent = new PvePowerBuffEvent("pvePowerBuffDispose");
         dispatchEvent(_loc1_);
      }
   }
}

class PvePowerBuffInstance
{
   
   public function PvePowerBuffInstance()
   {
      super();
   }
}
