package magicHouse
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.BagInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.bossbox.AwardsView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class MagicHouseControl extends EventDispatcher
   {
      
      private static var _instance:MagicHouseControl;
      
      private var _magicHouseMainView:MagicHouseMainView;
      
      public function MagicHouseControl(param1:MagicHouseInstance)
      {
         super();
      }
      
      public static function get instance() : MagicHouseControl
      {
         if(_instance == null)
         {
            _instance = new MagicHouseControl(new MagicHouseInstance());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         MagicHouseManager.instance.addEventListener("showMainView",this.__showHandler);
         MagicHouseManager.instance.addEventListener("hideMainView",this.__hideHandler);
         MagicHouseManager.instance.addEventListener("freebox_return",this.__freeBoxReturnHandler);
         MagicHouseManager.instance.addEventListener("chargebox_return",this.__chargeBoxReturnHandler);
      }
      
      private function __showHandler(param1:Event) : void
      {
         if(PlayerManager.Instance.Self.Grade >= 17)
         {
            this._magicHouseMainView = ComponentFactory.Instance.creatComponentByStylename("magicHouse.mainViewFrame");
            this._magicHouseMainView.show(MagicHouseModel.instance.viewIndex);
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
         }
      }
      
      private function __hideHandler(param1:Event) : void
      {
         if(Boolean(this._magicHouseMainView))
         {
            this._magicHouseMainView.close();
         }
      }
      
      private function __freeBoxReturnHandler(param1:Event) : void
      {
         var _loc3_:AwardsView = null;
         var _loc4_:FilterFrameText = null;
         var _loc2_:* = null;
         _loc3_ = new AwardsView();
         _loc3_.goodsList = MagicHouseModel.instance.freeBoxGoodListInfos;
         _loc3_.boxType = 4;
         _loc4_ = ComponentFactory.Instance.creat("magichouse.collectionView.boxGetAwards");
         _loc4_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
         _loc4_.x = 80;
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("magichouse.ItemPreviewListFrame");
         var _loc5_:String = LanguageMgr.GetTranslation("magichouse.collectionView.freeBoxItemName");
         var _loc6_:AlertInfo = new AlertInfo(_loc5_);
         _loc6_.showCancel = false;
         _loc6_.moveEnable = false;
         _loc2_.info = _loc6_;
         _loc2_.addToContent(_loc3_);
         _loc2_.addToContent(_loc4_);
         _loc2_.addEventListener("response",this.__frameClose);
         LayerManager.Instance.addToLayer(_loc2_,3,true,1);
      }
      
      private function __chargeBoxReturnHandler(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:AwardsView = null;
         var _loc4_:FilterFrameText = null;
         _loc2_ = null;
         _loc3_ = new AwardsView();
         _loc3_.goodsList = MagicHouseModel.instance.chargeBoxGoodListInfos;
         _loc3_.boxType = 4;
         _loc4_ = ComponentFactory.Instance.creat("magichouse.collectionView.boxGetAwards");
         _loc4_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.awardsTitle");
         _loc4_.x = 80;
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("magichouse.ItemPreviewListFrame");
         var _loc5_:String = LanguageMgr.GetTranslation("magichouse.collectionView.chargeBoxItemName");
         var _loc6_:AlertInfo = new AlertInfo(_loc5_);
         _loc6_.showCancel = false;
         _loc6_.moveEnable = false;
         _loc2_.info = _loc6_;
         _loc2_.addToContent(_loc3_);
         _loc2_.addToContent(_loc4_);
         _loc2_.addEventListener("response",this.__frameClose);
         LayerManager.Instance.addToLayer(_loc2_,3,true,1);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         switch(int(param1.responseCode) - 2)
         {
            case 0:
            case 1:
               SoundManager.instance.play("008");
               _loc2_.removeEventListener("response",this.__frameClose);
               _loc2_.dispose();
               SocketManager.Instance.out.sendClearStoreBag();
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("magichouse.collectionView.getBoxAwardMessage"));
         }
      }
      
      public function initServerConfig() : void
      {
         MagicHouseModel.instance.juniorWeaponList = ServerConfigManager.instance.magicHouseJuniorWeaponList;
         MagicHouseModel.instance.midWeaponList = ServerConfigManager.instance.magicHouseMidWeaponList;
         MagicHouseModel.instance.seniorWeapinList = ServerConfigManager.instance.magicHouseSeniorWeaponList;
         MagicHouseModel.instance.boxNeedmoney = ServerConfigManager.instance.magicHouseBoxNeedMonry;
         MagicHouseModel.instance.openDepotNeedMoney = ServerConfigManager.instance.magicHouseOpenDepotNeedMoney;
         MagicHouseModel.instance.levelUpNumber = ServerConfigManager.instance.magicHouseLevelUpNumber;
         MagicHouseModel.instance.depotPromoteNeedMoney = ServerConfigManager.instance.magicHouseDepotPromoteNeedMoney;
         MagicHouseModel.instance.juniorAddAttribute = ServerConfigManager.instance.magicHouseJuniorAddAttribute;
         MagicHouseModel.instance.midAddAttribute = ServerConfigManager.instance.magicHouseMidAddAttribute;
         MagicHouseModel.instance.seniorAddAttribute = ServerConfigManager.instance.magicHouseSeniorAddAttribute;
      }
      
      public function selectEquipFromBag() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         var _loc10_:int = 0;
         var _loc11_:* = null;
         var _loc12_:int = 0;
         var _loc13_:* = null;
         var _loc14_:int = 0;
         var _loc15_:BagInfo = PlayerManager.Instance.Self.Bag;
         if(MagicHouseModel.instance.equipOpenList == null)
         {
            MagicHouseModel.instance.equipOpenList = [];
         }
         _loc1_ = 0;
         while(_loc1_ < 9)
         {
            _loc2_ = false;
            if(_loc1_ < 3)
            {
               _loc3_ = MagicHouseModel.instance.juniorWeaponList[_loc1_].split(",");
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc15_.findItemsByTempleteID(_loc3_[_loc4_]);
                  _loc6_ = 0;
                  while(_loc6_ < _loc5_.length)
                  {
                     if(_loc5_[_loc6_] != null && _loc5_[_loc6_].getRemainDate() > 0)
                     {
                        _loc2_ = true;
                        break;
                     }
                     _loc6_++;
                  }
                  if(_loc2_)
                  {
                     break;
                  }
                  _loc4_++;
               }
               MagicHouseModel.instance.equipOpenList[_loc1_] = _loc2_;
            }
            else if(_loc1_ < 6)
            {
               _loc7_ = MagicHouseModel.instance.midWeaponList[_loc1_ - 3].split(",");
               _loc8_ = 0;
               while(_loc8_ < _loc7_.length)
               {
                  _loc9_ = _loc15_.findItemsByTempleteID(_loc7_[_loc8_]);
                  _loc10_ = 0;
                  while(_loc10_ < _loc9_.length)
                  {
                     if(_loc9_[_loc10_] != null && _loc9_[_loc10_].getRemainDate() > 0)
                     {
                        _loc2_ = true;
                        break;
                     }
                     _loc10_++;
                  }
                  if(_loc2_)
                  {
                     break;
                  }
                  _loc8_++;
               }
               MagicHouseModel.instance.equipOpenList[_loc1_] = _loc2_;
            }
            else
            {
               _loc11_ = MagicHouseModel.instance.seniorWeapinList[_loc1_ - 6].split(",");
               _loc12_ = 0;
               while(_loc12_ < _loc11_.length)
               {
                  _loc13_ = _loc15_.findItemsByTempleteID(_loc11_[_loc12_]);
                  _loc14_ = 0;
                  while(_loc14_ < _loc13_.length)
                  {
                     if(_loc13_[_loc14_] != null && _loc13_[_loc14_].getRemainDate() > 0)
                     {
                        _loc2_ = true;
                        break;
                     }
                     _loc14_++;
                  }
                  if(_loc2_)
                  {
                     break;
                  }
                  _loc12_++;
               }
               MagicHouseModel.instance.equipOpenList[_loc1_] = _loc2_;
            }
            _loc1_++;
         }
      }
      
      public function checkGetFreeBoxTime() : Boolean
      {
         if(MagicHouseModel.instance.freeGetTime.getDate() != TimeManager.Instance.Now().getDate())
         {
            return true;
         }
         return false;
      }
      
      public function chechGetChargeBoxTime() : Boolean
      {
         if(MagicHouseModel.instance.chargeGetTime.getDate() != TimeManager.Instance.Now().getDate())
         {
            return true;
         }
         return false;
      }
      
      public function closeMagicHouseView() : void
      {
         if(Boolean(this._magicHouseMainView))
         {
            this._magicHouseMainView.close();
         }
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
