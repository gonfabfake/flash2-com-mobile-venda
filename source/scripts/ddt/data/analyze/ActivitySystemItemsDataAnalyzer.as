package ddt.data.analyze
{
   import chickActivation.data.ChickActivationInfo;
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import defendisland.data.DefendislandRewardInfo;
   import growthPackage.data.GrowthPackageInfo;
   import guildMemberWeek.data.GuildMemberWeekItemsInfo;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import lotteryTicket.data.LotteryRewardInfo;
   import newYearRice.data.NewYearRiceInfo;
   import pyramid.data.PyramidSystemItemsInfo;
   import welfareCenter.callBackFund.CallBackFundRewardInfo;
   import witchBlessing.data.WitchBlessingPackageInfo;
   
   public class ActivitySystemItemsDataAnalyzer extends DataAnalyzer
   {
      
      public var pyramidSystemDataList:Array;
      
      public var growthPackageDataList:Array;
      
      public var guildMemberWeekDataList:Array;
      
      public var chickActivationDataList:Array;
      
      public var witchBlessingDataList:Array;
      
      public var newYearRiceDataList:Array;
      
      public var lotteryDataList:Array;
      
      public var defendislandDataList:Array;
      
      public var callbackDataList:Array;
      
      public function ActivitySystemItemsDataAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:PyramidSystemItemsInfo = null;
         var _loc5_:Array = null;
         var _loc6_:GuildMemberWeekItemsInfo = null;
         var _loc7_:Array = null;
         var _loc8_:GrowthPackageInfo = null;
         var _loc9_:Vector.<GrowthPackageInfo> = null;
         var _loc10_:ChickActivationInfo = null;
         var _loc11_:Array = null;
         var _loc12_:WitchBlessingPackageInfo = null;
         var _loc13_:Array = null;
         var _loc14_:NewYearRiceInfo = null;
         var _loc15_:Array = null;
         var _loc16_:LotteryRewardInfo = null;
         var _loc17_:Array = null;
         var _loc18_:DefendislandRewardInfo = null;
         var _loc19_:Array = null;
         var _loc20_:CallBackFundRewardInfo = null;
         var _loc21_:Array = null;
         this.pyramidSystemDataList = [];
         this.guildMemberWeekDataList = [];
         this.growthPackageDataList = [];
         this.chickActivationDataList = [];
         this.witchBlessingDataList = [];
         this.newYearRiceDataList = [];
         this.lotteryDataList = [];
         this.defendislandDataList = [];
         this.callbackDataList = [];
         var _loc22_:XML = new XML(param1);
         if(_loc22_.@value == "true")
         {
            _loc2_ = _loc22_..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               if(_loc2_[_loc3_].@ActivityType == "8")
               {
                  _loc4_ = new PyramidSystemItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  _loc5_ = this.pyramidSystemDataList[_loc4_.Quality - 1];
                  if(!_loc5_)
                  {
                     _loc5_ = [];
                  }
                  _loc5_.push(_loc4_);
                  this.pyramidSystemDataList[_loc4_.Quality - 1] = _loc5_;
               }
               else if(_loc2_[_loc3_].@ActivityType == String(GuildMemberWeekManager.instance.getGiftType))
               {
                  _loc6_ = new GuildMemberWeekItemsInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc6_,_loc2_[_loc3_]);
                  _loc7_ = this.guildMemberWeekDataList[_loc6_.Quality - 1];
                  if(!_loc7_)
                  {
                     _loc7_ = [];
                  }
                  _loc7_.push(_loc6_);
                  this.guildMemberWeekDataList[_loc6_.Quality - 1] = _loc7_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "20")
               {
                  _loc8_ = new GrowthPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc8_,_loc2_[_loc3_]);
                  _loc9_ = this.growthPackageDataList[_loc8_.Quality];
                  if(!_loc9_)
                  {
                     _loc9_ = new Vector.<GrowthPackageInfo>();
                  }
                  _loc9_.push(_loc8_);
                  this.growthPackageDataList[_loc8_.Quality] = _loc9_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "40")
               {
                  _loc10_ = new ChickActivationInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc10_,_loc2_[_loc3_]);
                  if(_loc10_.Quality >= 10001 && _loc10_.Quality <= 10010)
                  {
                     _loc11_ = this.chickActivationDataList[12];
                     if(!_loc11_)
                     {
                        _loc11_ = new Array();
                     }
                     _loc11_.push(_loc10_);
                     _loc11_.sortOn("Quality",Array.NUMERIC);
                     this.chickActivationDataList[12] = _loc11_;
                  }
                  else
                  {
                     _loc11_ = this.chickActivationDataList[_loc10_.Quality];
                     if(!_loc11_)
                     {
                        _loc11_ = new Array();
                     }
                     _loc11_.push(_loc10_);
                     this.chickActivationDataList[_loc10_.Quality] = _loc11_;
                  }
               }
               else if(_loc2_[_loc3_].@ActivityType == "49")
               {
                  _loc12_ = new WitchBlessingPackageInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc12_,_loc2_[_loc3_]);
                  if(!_loc13_)
                  {
                     _loc13_ = new Array();
                  }
                  _loc13_.push(_loc12_);
                  this.witchBlessingDataList = _loc13_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "99")
               {
                  _loc14_ = new NewYearRiceInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc14_,_loc2_[_loc3_]);
                  if(!_loc15_)
                  {
                     _loc15_ = new Array();
                  }
                  _loc15_.push(_loc14_);
                  this.newYearRiceDataList = _loc15_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "114")
               {
                  _loc16_ = new LotteryRewardInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc16_,_loc2_[_loc3_]);
                  if(!_loc17_)
                  {
                     _loc17_ = new Array();
                  }
                  _loc17_.push(_loc16_);
                  this.lotteryDataList = _loc17_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "111")
               {
                  _loc20_ = new CallBackFundRewardInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc20_,_loc2_[_loc3_]);
                  if(!_loc21_)
                  {
                     _loc21_ = [];
                  }
                  _loc21_.push(_loc20_);
                  this.callbackDataList = _loc21_;
               }
               else if(_loc2_[_loc3_].@ActivityType == "155")
               {
                  _loc18_ = new DefendislandRewardInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc18_,_loc2_[_loc3_]);
                  if(!_loc19_)
                  {
                     _loc19_ = [];
                  }
                  _loc19_.push(_loc18_);
                  this.defendislandDataList = _loc19_;
               }
               _loc3_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc22_.@message;
            onAnalyzeError();
         }
      }
   }
}

