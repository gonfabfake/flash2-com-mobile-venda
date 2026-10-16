package ddt.manager
{
   import ddt.data.ServerConfigInfo;
   import ddt.data.analyze.ServerConfigAnalyz;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class ServerConfigManager
   {
      
      private static var privileges:Dictionary;
      
      private static var _instance:ServerConfigManager;
      
      public static const MARRT_ROOM_CREATE_MONET:String = "MarryRoomCreateMoney";
      
      public static const MISSION_RICHES:String = "MissionRiches";
      
      public static const VIP_TAKE_CARD_DISCOUNT:String = "VIPTakeCardDisCount";
      
      public static const HOT_SPRING_EXP:String = "HotSpringExp";
      
      public static const FIRSTRECHARGE_RETURN:String = "FirstChargeReturn";
      
      public static const PLAYER_MIN_LEVEL:String = "PlayerMinLevel";
      
      public static const WARRIORFAMRAIDPRICEPERMIN:String = "WarriorFamRaidPricePerMin";
      
      public static const PYRAMIDTOPPOINT:String = "PyramidTopPoint";
      
      public static const TOTEMPROPMONEYOFFSET:String = "TotemPropMoneyOffset";
      
      public static const HALLOWEEN_MINNUM:String = "HalloweenMinNum";
      
      public static const HALLOWEEN_BEGINDATE:String = "HalloweenBeginDate";
      
      public static const HALLOWEEN_ENDDATE:String = "HalloweenEndDate";
      
      public static const PROMOTEPACKAGEPRICE:String = "PromotePackagePrice";
      
      public static const ISPROMOTEPACKAGEOPEN:String = "IsPromotePackageOpen";
      
      public static const LIGHTROAD_MINLEVEL:String = "GoodsCollectMinLevel";
      
      public static const VIP_STRENGTHEN_EX:String = "VIPStrengthenEx";
      
      public static const AUCTION_RATE:String = "Cess";
      
      public static const ISCHICKENACTIVEKEYOPEN:String = "IsChickenActiveKeyOpen";
      
      public static const CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE:String = "ChickenActiveKeyLvAwardNeedPrestige";
      
      public static const WORSHIPMOONBEGINDATE:String = "WorshipMoonBeginDate";
      
      public static const WORSHIPMOONENDDATE:String = "WorshipMoonEndDate";
      
      public static const WITCHBLESSDOUBLEGPTIME:String = "WitchBlessDoubleGpTime";
      
      public static const WITCH_BLESS_GP:String = "WitchBlessGP";
      
      public static const WITCH_BLESS_DOUBLEGP_TIME:String = "WitchBlessDoubleGpTime";
      
      public static const WITCH_BLESS_MONEY:String = "WithcBlessMoney";
      
      public static const WITCH_BLESS_ADD_PROPERTY:String = "WitchBlessAddProperty";
      
      public static const YEARFOODITEMCOUNT:String = "YearFoodItemsCount";
      
      public static const YEARFOODITEMS:String = "YearFoodItems";
      
      public static const YEARFOODITEMPRICES:String = "YearFoodItemPrices";
      
      public static const CONSORTIA_MATCH_START_TIME:String = "ConsortiaMatchStartTime";
      
      public static const CONSORTIA_MATCH_END_TIME:String = "ConsortiaMatchEndTime";
      
      public static const LOCAL_CONSORTIA_MATCH_DAYS:String = "LocalConsortiaMatchDays";
      
      public static const AREA_CONSORTIA_MATCH_DAYS:String = "AreaConsortiaMatchDays";
      
      public static const PETDISAPPEAR_PLAYCOUNT:String = "PetDisappearPlayCount";
      
      public static const PETDISAPPEAR_PLAYSONCOUNT:String = "PetDisappearPlaySonCount";
      
      public static const PETDISAPPEAR_USERBLOOD:String = "PetDisappearUserBlood";
      
      public static const PETDISAPPEAR_NPCBLOOD:String = "PetDisappearNPCBlood";
      
      public static const ENTERTAINMENT_SCORE:String = "EntertainmentScore";
      
      private var _serverConfigInfoList:DictionaryData;
      
      private var _cryptBossOpenDay:Array;
      
      private var _VIPExtraBindMoneyUpper:Array;
      
      private var _BindMoneyMax:Array;
      
      public function ServerConfigManager()
      {
         super();
      }
      
      public static function get instance() : ServerConfigManager
      {
         if(_instance == null)
         {
            _instance = new ServerConfigManager();
         }
         return _instance;
      }
      
      public function getserverConfigInfo(param1:ServerConfigAnalyz) : void
      {
         this._serverConfigInfoList = param1.serverConfigInfoList;
         this._BindMoneyMax = this._serverConfigInfoList["BindMoneyMax"].Value.split("|");
         this._cryptBossOpenDay = this._serverConfigInfoList["CryptBossOpenDay"].Value.split("|");
         this._VIPExtraBindMoneyUpper = this._serverConfigInfoList["VIPExtraBindMoneyUpper"].Value.split("|");
      }
      
      public function get serverConfigInfo() : DictionaryData
      {
         return this._serverConfigInfoList;
      }
      
      public function get weddingMoney() : Array
      {
         return this.findInfoByName(ServerConfigManager.MARRT_ROOM_CREATE_MONET).Value.split(",");
      }
      
      public function get divorcedMoney() : String
      {
         return this.findInfoByName("DivorcedMoney").Value;
      }
      
      public function get firstDivorcedMoney() : String
      {
         return this.findInfoByName("DivorcedDiscountMoney").Value;
      }
      
      public function get MissionRiches() : Array
      {
         return this.findInfoByName(ServerConfigManager.MISSION_RICHES).Value.split("|");
      }
      
      public function get VIPTakeCardDisCount() : Array
      {
         var _loc1_:Object = this.findInfoByName(VIP_TAKE_CARD_DISCOUNT);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get HotSpringExp() : Array
      {
         return this.findInfoByName(ServerConfigManager.HOT_SPRING_EXP).Value.split(",");
      }
      
      public function findInfoByName(param1:String) : ServerConfigInfo
      {
         return this._serverConfigInfoList[param1];
      }
      
      public function getFirstRechargeRebateAndValue() : Array
      {
         var _loc1_:Object = this.findInfoByName(FIRSTRECHARGE_RETURN);
         if(Boolean(_loc1_))
         {
            return this.findInfoByName(FIRSTRECHARGE_RETURN).Value.split("|");
         }
         return [1,998];
      }
      
      public function get minOpenPetSystemLevel() : int
      {
         var _loc1_:Object = this.findInfoByName(PLAYER_MIN_LEVEL);
         return int(_loc1_.Value);
      }
      
      public function get WarriorFamRaidPricePerMin() : Number
      {
         return Number(this.findInfoByName(WARRIORFAMRAIDPRICEPERMIN).Value);
      }
      
      public function get pyramidTopMinMaxPoint() : Array
      {
         var _loc1_:Array = null;
         var _loc2_:ServerConfigInfo = this.findInfoByName(PYRAMIDTOPPOINT);
         if(Boolean(_loc2_))
         {
            _loc1_ = _loc2_.Value.split("|");
            return new Array(_loc1_[0],_loc1_[_loc1_.length - 1]);
         }
         return new Array(0,0);
      }
      
      public function get totemSignDiscount() : Number
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(TOTEMPROPMONEYOFFSET);
         if(Boolean(_loc1_))
         {
            return Number(_loc1_.Value);
         }
         return 40;
      }
      
      public function get getHalloweenMinNum() : String
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_MINNUM);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value);
         }
         return "";
      }
      
      public function get getHalloweenBeginDate() : String
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_BEGINDATE);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value);
         }
         return "";
      }
      
      public function get getHalloweenEndDate() : String
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_ENDDATE);
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value);
         }
         return "";
      }
      
      public function get getHalloweenDateEnd() : Date
      {
         var _loc1_:Date = null;
         var _loc2_:ServerConfigInfo = this.findInfoByName(HALLOWEEN_ENDDATE);
         if(Boolean(_loc2_))
         {
            return DateUtils.getDateByStr(_loc2_.Value);
         }
         return null;
      }
      
      public function get growthPackagePrice() : Number
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(PROMOTEPACKAGEPRICE);
         if(Boolean(_loc1_))
         {
            return Number(_loc1_.Value);
         }
         return 0;
      }
      
      public function get growthPackageIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(ISPROMOTEPACKAGEOPEN);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function get zodiacAddPrice() : int
      {
         return this._serverConfigInfoList["ConstellationExtraSpendMoney"].Value;
      }
      
      public function get lightRoadLevel() : int
      {
         return int(this.findInfoByName(LIGHTROAD_MINLEVEL).Value);
      }
      
      public function get AuctionRate() : String
      {
         return String(Number(this.findInfoByName(AUCTION_RATE).Value) * 100);
      }
      
      public function get chickActivationIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(ISCHICKENACTIVEKEYOPEN);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() == "true";
         }
         return false;
      }
      
      public function get chickenActiveKeyLvAwardNeedPrestige() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(CHICKENACTIVEKEYLVAWARDNEEDPRESTIGE);
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.split("|");
         }
         return null;
      }
      
      public function get worshipMoonBeginDate() : String
      {
         return this.findInfoByName(WORSHIPMOONBEGINDATE).Value;
      }
      
      public function get worshipMoonEndDate() : String
      {
         return this.findInfoByName(WORSHIPMOONENDDATE).Value;
      }
      
      public function get prayActivityConfig() : Array
      {
         return this.findInfoByName("PrayGoodsActivityConfig").Value.split("|");
      }
      
      public function get getWitchBlessItemId() : String
      {
         return this.findInfoByName("WitchBlessTemplateId").Value;
      }
      
      public function get witchBlessDoubleGpTime() : int
      {
         return int(this.findInfoByName(WITCHBLESSDOUBLEGPTIME).Value);
      }
      
      public function get getWitchBlessGP() : Array
      {
         return this.findInfoByName(WITCH_BLESS_GP).Value.split("|");
      }
      
      public function get getWitchBlessDoubleGpTime() : String
      {
         return String(this.findInfoByName(WITCH_BLESS_DOUBLEGP_TIME).Value);
      }
      
      public function get getWitchBlessMoney() : int
      {
         return int(this.findInfoByName(WITCH_BLESS_MONEY).Value);
      }
      
      public function get localYearFoodItemsCount() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(YEARFOODITEMCOUNT);
         return _loc1_.Value.split("|");
      }
      
      public function get localYearFoodItems() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(YEARFOODITEMS);
         return _loc1_.Value.split(",");
      }
      
      public function get localYearFoodItemsPrices() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(YEARFOODITEMPRICES);
         return _loc1_.Value.split(",");
      }
      
      public function get localWitchBlessAddProperty() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(WITCH_BLESS_ADD_PROPERTY);
         return _loc1_.Value.split(",");
      }
      
      public function get consortiaMatchStartTime() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(CONSORTIA_MATCH_START_TIME);
         return _loc1_.Value.split(" ")[1].toString().split(":");
      }
      
      public function get consortiaMatchEndTime() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(CONSORTIA_MATCH_END_TIME);
         return _loc1_.Value.split(" ")[1].toString().split(":");
      }
      
      public function get localConsortiaMatchDays() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(LOCAL_CONSORTIA_MATCH_DAYS);
         return _loc1_.Value.split("|");
      }
      
      public function get areaConsortiaMatchDays() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName(AREA_CONSORTIA_MATCH_DAYS);
         return _loc1_.Value.split("|");
      }
      
      public function getHappyRechargeSpecialItemCount() : Array
      {
         return this._serverConfigInfoList["HappyChargeItemPercent"].Value.split("|");
      }
      
      public function getTwoColorBallBeginTime() : String
      {
         return this._serverConfigInfoList["TwoColorBallBeginTime"].Value.split(" ")[0];
      }
      
      public function getTwoColorBallEndTime() : String
      {
         return this._serverConfigInfoList["TwoColorBallEndTime"].Value.split(" ")[0];
      }
      
      public function get angelInvestmentAllPrice() : int
      {
         var _loc1_:int = 0;
         if(this._serverConfigInfoList.hasKey("MonthCardBuyAllPrice"))
         {
            _loc1_ = int(this._serverConfigInfoList["MonthCardBuyAllPrice"].Value);
         }
         return _loc1_;
      }
      
      public function get angelInvestmentDiscount() : int
      {
         var _loc1_:int = 0;
         if(this._serverConfigInfoList.hasKey("MonthCardBuyAllDiscount"))
         {
            _loc1_ = int(this._serverConfigInfoList["MonthCardBuyAllDiscount"].Value);
         }
         return _loc1_;
      }
      
      public function get angelInvestmentDay() : int
      {
         var _loc1_:int = 0;
         if(this._serverConfigInfoList.hasKey("MonthCardBuyAllDay"))
         {
            _loc1_ = int(this._serverConfigInfoList["MonthCardBuyAllDay"].Value);
         }
         return _loc1_;
      }
      
      public function get angelInvestmentIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("MonthCardBuyIsOpen");
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() == "true";
         }
         return false;
      }
      
      public function getNeedUseLotteryKicket(param1:int) : int
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(this._serverConfigInfoList.hasKey("TurnTableCostCountByLevel"))
         {
            _loc2_ = this._serverConfigInfoList["TurnTableCostCountByLevel"].Value;
            _loc3_ = _loc2_.split("|");
            if(_loc3_.length == 4 && param1 <= 3)
            {
               return _loc3_[param1];
            }
            return _loc3_[_loc3_.length - 1];
         }
         return 6;
      }
      
      public function get equipAmuletBuyDustMax() : int
      {
         var _loc1_:int = 20;
         if(this._serverConfigInfoList.hasKey("AmuletBuyDustMax"))
         {
            _loc1_ = int(this._serverConfigInfoList["AmuletBuyDustMax"].Value);
         }
         return _loc1_;
      }
      
      public function get AmuletBuyDustCountAndNeedMoney() : Array
      {
         var _loc1_:Array = [];
         if(this._serverConfigInfoList.hasKey("AmuletBuyDustCountAndNeedMoney"))
         {
            _loc1_ = this._serverConfigInfoList["AmuletBuyDustCountAndNeedMoney"].Value.split("|");
         }
         return _loc1_;
      }
      
      public function get pvePowerBuffLevelLimit() : int
      {
         var _loc1_:int = 20;
         if(this._serverConfigInfoList.hasKey("BlessBuffOpenLv"))
         {
            _loc1_ = int(this._serverConfigInfoList["BlessBuffOpenLv"].Value);
         }
         return _loc1_;
      }
      
      public function get pvePowerBuffRefreshPrice() : int
      {
         var _loc1_:int = 100;
         if(this._serverConfigInfoList.hasKey("BlessBuffRefreshPrice"))
         {
            _loc1_ = int(this._serverConfigInfoList["BlessBuffRefreshPrice"].Value);
         }
         return _loc1_;
      }
      
      public function get pvePowerBuffGetBuffPrice() : int
      {
         var _loc1_:int = 100;
         if(this._serverConfigInfoList.hasKey("BlessBuffAddBuffPrice"))
         {
            _loc1_ = int(this._serverConfigInfoList["BlessBuffAddBuffPrice"].Value);
         }
         return _loc1_;
      }
      
      public function get cryptBossOpenDay() : Array
      {
         return this._cryptBossOpenDay;
      }
      
      public function getBindBidLimit(param1:int, param2:int = 0) : int
      {
         var _loc3_:int = param1 % 10 == 0 ? int(this._BindMoneyMax[int(param1 / 10) - 1]) : int(this._BindMoneyMax[int(param1 / 10)]);
         var _loc4_:int = 0;
         if(PlayerManager.Instance.Self.IsVIP && param2 > 0)
         {
            _loc4_ = int(this._VIPExtraBindMoneyUpper[param2 - 1]);
         }
         return _loc3_ + _loc4_;
      }
      
      public function getTimeControl() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DiffDimensionTimeControl");
         return _loc1_.Value.split("|");
      }
      
      public function getSpaceControl() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DiffDimensionSpaceControl");
         return _loc1_.Value.split("|");
      }
      
      public function getLootControl() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DiffDimensionLootControl");
         return _loc1_.Value.split("|");
      }
      
      public function getLevelUpItemID() : int
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DiffDimensionLevelUpItemID");
         if(Boolean(_loc1_))
         {
            return int(_loc1_.Value);
         }
         return 0;
      }
      
      public function getSearchPrice() : int
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DiffDimensionRefreshPrice");
         if(Boolean(_loc1_))
         {
            return int(_loc1_.Value);
         }
         return 0;
      }
      
      public function get petDisappearMaxLevel() : int
      {
         return this._serverConfigInfoList["PetDisappearMaxLevel"].Value;
      }
      
      public function get petDisappearAddScore() : int
      {
         return this._serverConfigInfoList["PetDisappearAddScore"].Value;
      }
      
      public function get petDisappearMinLevel() : int
      {
         return this._serverConfigInfoList["PetDisappearMinLevel"].Value;
      }
      
      public function get petDisappearPlaycount() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("PetDisappearPlayCount");
         return _loc1_.Value.split("|");
      }
      
      public function get petDisappearPlaySoncount() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("PetDisappearPlaySonCount");
         return _loc1_.Value.split("|");
      }
      
      public function get petDisappearPlayerBlood() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("PetDisappearUserBlood");
         return _loc1_.Value.split("|");
      }
      
      public function get petDisappearNPCBlood() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("PetDisappearNPCBlood");
         return _loc1_.Value.split("|");
      }
      
      public function get petDisappearRecoverPrice() : int
      {
         return this._serverConfigInfoList["PetDisappearRecoverPrice"].Value;
      }
      
      public function get petDisappearSkillMoney() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("PetDisappearSkillMoney");
         return _loc1_.Value.split("|");
      }
      
      public function get petDisappearSkillMaxTimes() : int
      {
         return this._serverConfigInfoList["PetDisappearSkillMaxTimes"].Value;
      }
      
      public function get petDisappearSkillTwoMaxTimes() : int
      {
         return this._serverConfigInfoList["PetDisappearSkillTwoMaxTimes"].Value;
      }
      
      public function get petDisappearSkillTwoMoney() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("PetDisappearSkillTwoMoney");
         return _loc1_.Value.split("|");
      }
      
      public function SanXiaoChangeColorScore() : String
      {
         return this._serverConfigInfoList["ThreeClearColourChangePoint"].Value;
      }
      
      public function SanXiaoChangeColorPrice() : String
      {
         return this._serverConfigInfoList["ThreeClearColourChangeCost"].Value;
      }
      
      public function SanXiaoCrossBombScore() : String
      {
         return this._serverConfigInfoList["ThreeClearCrossPoint"].Value;
      }
      
      public function SanXiaoCrossBombPrice() : String
      {
         return this._serverConfigInfoList["ThreeClearCrossCost"].Value;
      }
      
      public function SanXiaoSquareBombScore() : String
      {
         return this._serverConfigInfoList["ThreeClearRectPoint"].Value;
      }
      
      public function SanXiaoSquareBombPrice() : String
      {
         return this._serverConfigInfoList["ThreeClearRectCost"].Value;
      }
      
      public function SanXiaoClearColorScore() : String
      {
         return this._serverConfigInfoList["ThreeClearColourCleanPoint"].Value;
      }
      
      public function SanXiaoClearColorPrice() : String
      {
         return this._serverConfigInfoList["ThreeClearColourCleanCost"].Value;
      }
      
      public function SanXiaoStepPrice() : String
      {
         return this._serverConfigInfoList["ThreeCleanBuyCost"].Value;
      }
      
      public function get getPrestigeTimes() : int
      {
         return this._serverConfigInfoList["PrestigeTimes"].Value;
      }
      
      public function getVipPrestigeTimes(param1:int) : int
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         if(PlayerManager.Instance.Self.IsVIP && param1 > 0)
         {
            _loc2_ = "0|0|0|0|0|5|5|5|10|10|10|15|15|15|15";
            if(this._serverConfigInfoList.hasKey("VIPAddPrestigeTimes"))
            {
               _loc2_ = String(this._serverConfigInfoList["VIPAddPrestigeTimes"].Value);
            }
            _loc3_ = _loc2_.split("|");
            return int(_loc3_[param1 - 1]);
         }
         return 0;
      }
      
      public function getVipIntegral() : Array
      {
         return this._serverConfigInfoList["ShopVipScore"].Value.split("|");
      }
      
      public function get VIPQuestFinishDirect() : Array
      {
         return this.analyzeData("VIPQuestFinishDirect");
      }
      
      public function analyzeData(param1:String) : Array
      {
         var _loc2_:Object = this.findInfoByName(param1);
         if(Boolean(_loc2_))
         {
            return String(_loc2_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPDailyPack() : Array
      {
         return this.findInfoByName("VIPDailyPackID").Value.split("|");
      }
      
      public function get VIPRewardCryptCount() : Vector.<String>
      {
         return Vector.<String>(this.findInfoByName("VIPRewardCryptCount").Value.split("|"));
      }
      
      public function get getDayMaxAddPrestige() : int
      {
         return this._serverConfigInfoList["DayMaxAddPrestige"].Value;
      }
      
      public function memoryGameCardMoney() : int
      {
         return this._serverConfigInfoList["PairUpCardCost"].Value;
      }
      
      public function memoryGameResetMoney() : int
      {
         return this._serverConfigInfoList["PairUpResetCost"].Value;
      }
      
      public function get wealthTreeIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("IsOpenWealthTree");
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function getPrivilegeMinLevel(param1:String) : int
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         if(privileges == null)
         {
            _loc2_ = this.findInfoByName("VIPPrivilege");
            _loc3_ = 1;
            _loc4_ = String(_loc2_.Value).split("|");
            privileges = new Dictionary();
            for each(_loc5_ in _loc4_)
            {
               for each(_loc6_ in _loc5_.split(","))
               {
                  privileges[_loc6_] = _loc3_;
               }
               _loc3_++;
            }
         }
         return int(privileges[param1]);
      }
      
      public function get VIPRenewalPrice() : Array
      {
         var _loc1_:Object = this.findInfoByName("VIPRenewalPrize");
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get VIPStrengthenEx() : Array
      {
         var _loc1_:Object = this.findInfoByName("VIPStrengthenEx");
         if(Boolean(_loc1_))
         {
            return this.findInfoByName("VIPStrengthenEx").Value.split("|");
         }
         return null;
      }
      
      public function get VIPExpNeededForEachLv() : Array
      {
         return this.findInfoByName("VIPExpForEachLv").Value.split("|");
      }
      
      public function getToyMachinePrice() : Array
      {
         return this._serverConfigInfoList["ToyMachinePrice"].Value.split("|");
      }
      
      public function get levelFundPrice() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DDFundPrice");
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.split(",");
         }
         return null;
      }
      
      public function entertainmentScore() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("EntertainmentScore");
         return _loc1_.Value.split(",");
      }
      
      public function entertainmentPrice() : int
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("RecreationPvpRefreshPropBindMoney");
         if(Boolean(_loc1_))
         {
            return int(_loc1_.Value);
         }
         return 0;
      }
      
      public function entertainmentLevel() : int
      {
         return int(this.findInfoByName("RecreationPvpMinLevel").Value);
      }
      
      public function CryptBossNeedLevel() : int
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("CryptBossNeedLevel");
         if(Boolean(_loc1_))
         {
            return int(_loc1_.Value);
         }
         return 0;
      }
      
      public function get sevendayProgressGift() : Array
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("SevenDayTargetReward");
         return _loc1_.Value.split("|");
      }
      
      public function get sevenDayIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("SevenDayIsOpen");
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function get cryptBossIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("CryptBossIsOpen");
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function get ddtKingWayIsOpen() : Boolean
      {
         var _loc1_:ServerConfigInfo = this.findInfoByName("DDTKingWayIsOpen");
         if(Boolean(_loc1_))
         {
            return _loc1_.Value.toLowerCase() != "false";
         }
         return false;
      }
      
      public function get magicHouseJuniorAddAttribute() : Array
      {
         return this._serverConfigInfoList["MagicRoomJuniorAddAttribute"].Value.split("|");
      }
      
      public function get magicHouseMidAddAttribute() : Array
      {
         return this._serverConfigInfoList["MagicRoomMidAddAttribute"].Value.split("|");
      }
      
      public function get magicHouseSeniorAddAttribute() : Array
      {
         return this._serverConfigInfoList["MagicRoomSeniorAddAttribute"].Value.split("|");
      }
      
      public function get magicHouseJuniorWeaponList() : Array
      {
         return this._serverConfigInfoList["MagicRoomJuniorWeaponList"].Value.split("|");
      }
      
      public function get magicHouseMidWeaponList() : Array
      {
         return this._serverConfigInfoList["MagicRoomMidWeaponList"].Value.split("|");
      }
      
      public function get magicHouseSeniorWeaponList() : Array
      {
         return this._serverConfigInfoList["MagicRoomSeniorWeaponList"].Value.split("|");
      }
      
      public function get magicHouseBoxNeedMonry() : int
      {
         return this._serverConfigInfoList["MagicRoomBoxNeedMoney"].Value;
      }
      
      public function get magicHouseOpenDepotNeedMoney() : int
      {
         return this._serverConfigInfoList["MagicRoomOpenNeedMoney"].Value.split("|")[0];
      }
      
      public function get magicHouseDepotPromoteNeedMoney() : int
      {
         return this._serverConfigInfoList["MagicRoomOpenNeedMoney"].Value.split("|")[1];
      }
      
      public function get magicHouseLevelUpNumber() : Array
      {
         return this._serverConfigInfoList["MagicRoomLevelUpCount"].Value.split("|");
      }
      
      public function get magicHouseNeedMinLevel() : int
      {
         return this._serverConfigInfoList["MaxMagicRoomLevelLimited"].Value;
      }
      
      public function get FightSpiritLevelAddDamage() : Array
      {
         var _loc1_:Object = this.findInfoByName("FightSpiritLevelAddDamage");
         if(Boolean(_loc1_))
         {
            return String(_loc1_.Value).split("|");
         }
         return null;
      }
      
      public function get goldGemstoneLevel() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < this.FightSpiritLevelAddDamage.length)
         {
            _loc2_.push(int(this.FightSpiritLevelAddDamage[_loc1_].split(",")[0]));
            _loc1_++;
         }
         return _loc2_;
      }
   }
}

