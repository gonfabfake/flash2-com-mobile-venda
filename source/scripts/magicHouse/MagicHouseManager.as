package magicHouse
{
   import ddt.CoreManager;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.utils.HelperUIModuleLoad;
   import flash.events.Event;
   import magicHouse.magicBox.MagicBoxItemInfo;
   import road7th.comm.PackageIn;
   
   public class MagicHouseManager extends CoreManager
   {
      
      private static var _instance:MagicHouseManager;
      
      public static const SHOWMAINVIEW:String = "showMainView";
      
      public static const HIDEMAINVIEW:String = "hideMainView";
      
      public static const MAGICHOUSE_UPDATA:String = "magichouse_updata";
      
      public static const FREEBOX_RETURN:String = "freebox_return";
      
      public static const CHARGEBOX_RETURN:String = "chargebox_return";
      
      public static const MAGICBOX_EXTRACTION_COMPLETE:String = "magicbox_extraction_complete";
      
      public static const MAGICBOX_FUSION_COMPLETE:String = "magicbox_fusion_complete";
      
      public static const LEVEL_LIMIT:int = 17;
      
      public function MagicHouseManager(param1:MagicHouseInstance)
      {
         super();
      }
      
      public static function get instance() : MagicHouseManager
      {
         if(_instance == null)
         {
            _instance = new MagicHouseManager(new MagicHouseInstance());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener("magichouse",this.__magicHouseHandler);
      }
      
      private function __magicHouseHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         if(_loc3_ == 1)
         {
            this._loginMessage(_loc2_);
         }
         else if(_loc3_ == 2)
         {
            this._updateMessage(_loc2_);
         }
         else if(_loc3_ == 3)
         {
            this._isOpen(_loc2_);
         }
         else if(_loc3_ == 4)
         {
            this._getFreeBoxMessage(_loc2_);
         }
         else if(_loc3_ == 5)
         {
            this._getChargeBoxMessage(_loc2_);
         }
         else if(_loc3_ == 6)
         {
            this._extractionComplete(_loc2_);
         }
         else if(_loc3_ == 7)
         {
            this._fusionComplete(_loc2_);
         }
      }
      
      private function _loginMessage(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         MagicHouseModel.instance.activityWeapons = [];
         MagicHouseModel.instance.isMagicRoomShow = param1.readBoolean();
         _loc2_ = 0;
         while(_loc2_ < 9)
         {
            MagicHouseModel.instance.activityWeapons[_loc2_] = param1.readInt();
            _loc2_++;
         }
         MagicHouseModel.instance.magicJuniorLv = param1.readInt();
         MagicHouseModel.instance.magicJuniorExp = param1.readInt();
         MagicHouseModel.instance.magicMidLv = param1.readInt();
         MagicHouseModel.instance.magicMidExp = param1.readInt();
         MagicHouseModel.instance.magicSeniorLv = param1.readInt();
         MagicHouseModel.instance.magicSeniorExp = param1.readInt();
         MagicHouseModel.instance.freeGetCount = param1.readInt();
         MagicHouseModel.instance.freeGetTime = param1.readDate();
         MagicHouseModel.instance.chargeGetCount = param1.readInt();
         MagicHouseModel.instance.chargeGetTime = param1.readDate();
         MagicHouseModel.instance.depotCount = param1.readInt();
         PlayerManager.Instance.Self.essence = param1.readInt();
      }
      
      private function _updateMessage(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         if(MagicHouseModel.instance.activityWeapons == null)
         {
            MagicHouseModel.instance.activityWeapons = [];
         }
         MagicHouseModel.instance.isMagicRoomShow = param1.readBoolean();
         _loc2_ = 0;
         while(_loc2_ < 9)
         {
            MagicHouseModel.instance.activityWeapons[_loc2_] = param1.readInt();
            _loc2_++;
         }
         MagicHouseModel.instance.magicJuniorLv = param1.readInt();
         MagicHouseModel.instance.magicJuniorExp = param1.readInt();
         MagicHouseModel.instance.magicMidLv = param1.readInt();
         MagicHouseModel.instance.magicMidExp = param1.readInt();
         MagicHouseModel.instance.magicSeniorLv = param1.readInt();
         MagicHouseModel.instance.magicSeniorExp = param1.readInt();
         MagicHouseModel.instance.freeGetCount = param1.readInt();
         MagicHouseModel.instance.freeGetTime = param1.readDate();
         MagicHouseModel.instance.chargeGetCount = param1.readInt();
         MagicHouseModel.instance.chargeGetTime = param1.readDate();
         MagicHouseModel.instance.depotCount = param1.readInt();
         PlayerManager.Instance.Self.essence = param1.readInt();
         dispatchEvent(new Event("magichouse_updata"));
      }
      
      private function _isOpen(param1:PackageIn) : void
      {
         MagicHouseModel.instance.isOpen = param1.readBoolean();
         MagicHouseModel.instance.isMagicRoomShow = param1.readBoolean();
      }
      
      private function _getFreeBoxMessage(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = param1.readInt();
         MagicHouseModel.instance.freeGetTime = param1.readDate();
         var _loc5_:int = param1.readInt();
         var _loc6_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = new BoxGoodsTempInfo();
            _loc3_.TemplateId = param1.readInt();
            _loc3_.ItemCount = param1.readInt();
            _loc3_.ItemValid = param1.readInt();
            _loc3_.IsBind = param1.readBoolean();
            _loc3_.StrengthenLevel = param1.readInt();
            _loc3_.AttackCompose = param1.readInt();
            _loc3_.DefendCompose = param1.readInt();
            _loc3_.AgilityCompose = param1.readInt();
            _loc3_.LuckCompose = param1.readInt();
            _loc6_.push(_loc3_);
            _loc2_++;
         }
         MagicHouseModel.instance.freeBoxGoodListInfos = null;
         MagicHouseModel.instance.freeBoxGoodListInfos = _loc6_;
         dispatchEvent(new Event("freebox_return"));
      }
      
      private function _getChargeBoxMessage(param1:PackageIn) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = param1.readInt();
         MagicHouseModel.instance.chargeGetCount -= _loc4_;
         MagicHouseModel.instance.chargeGetTime = param1.readDate();
         var _loc5_:int = param1.readInt();
         var _loc6_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_ = new BoxGoodsTempInfo();
            _loc3_.TemplateId = param1.readInt();
            _loc3_.ItemCount = param1.readInt();
            _loc3_.ItemValid = param1.readInt();
            _loc3_.IsBind = param1.readBoolean();
            _loc3_.StrengthenLevel = param1.readInt();
            _loc3_.AttackCompose = param1.readInt();
            _loc3_.DefendCompose = param1.readInt();
            _loc3_.AgilityCompose = param1.readInt();
            _loc3_.LuckCompose = param1.readInt();
            _loc6_.push(_loc3_);
            _loc2_++;
         }
         MagicHouseModel.instance.chargeBoxGoodListInfos = null;
         MagicHouseModel.instance.chargeBoxGoodListInfos = _loc6_;
         dispatchEvent(new Event("chargebox_return"));
      }
      
      private function _extractionComplete(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         if(_loc2_)
         {
            dispatchEvent(new Event("magicbox_extraction_complete"));
         }
      }
      
      private function _fusionComplete(param1:PackageIn) : void
      {
         var _loc2_:Boolean = param1.readBoolean();
         if(_loc2_)
         {
            dispatchEvent(new Event("magicbox_fusion_complete"));
         }
      }
      
      public function setupMagicBoxData(param1:MagicBoxDataAnalyzer) : void
      {
         var _loc3_:* = undefined;
         if(!MagicHouseModel.instance.itemExtrationEnableList)
         {
            MagicHouseModel.instance.itemExtrationEnableList = [];
         }
         if(!MagicHouseModel.instance.itemFusionEnableList)
         {
            MagicHouseModel.instance.itemFusionEnableList = [];
         }
         var _loc2_:Vector.<MagicBoxItemInfo> = param1.list;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.Type == 1)
            {
               MagicHouseModel.instance.itemFusionEnableList.push(_loc3_);
            }
            else
            {
               MagicHouseModel.instance.itemExtrationEnableList.push(_loc3_);
            }
         }
      }
      
      override protected function start() : void
      {
         this._magichouseLoad();
      }
      
      private function _magichouseLoad() : void
      {
         new HelperUIModuleLoad().loadUIModule(["magicHouse","bagandinfo","ddtstore","ddtbead","consortionii"],this.onLoadedNew);
      }
      
      private function onLoadedNew() : void
      {
         dispatchEvent(new Event("showMainView"));
      }
      
      public function hide() : void
      {
         dispatchEvent(new Event("hideMainView"));
      }
   }
}

class MagicHouseInstance
{
   
   public function MagicHouseInstance()
   {
      super();
   }
}
