package hallIcon
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import hallIcon.model.HallIconModel;
   import hallIcon.view.HallIcon;
   
   public class HallIconManager extends EventDispatcher
   {
      
      private static var _instance:HallIconManager;
      
      public var model:HallIconModel;
      
      public function HallIconManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : HallIconManager
      {
         if(_instance == null)
         {
            _instance = new HallIconManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.model = new HallIconModel();
         this.initEvent();
      }
      
      public function checkDefaultIconShow() : void
      {
         this.model.wonderFulPlayIsOpen = true;
         this.model.activityIsOpen = true;
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onPlayerPropertyChange);
      }
      
      private function cacheRightIcon(param1:String, param2:HallIconInfo) : void
      {
         if(param2.isopen)
         {
            this.model.cacheRightIconDic[param1] = param2;
         }
         else if(Boolean(this.model.cacheRightIconDic[param1]))
         {
            delete this.model.cacheRightIconDic[param1];
         }
      }
      
      public function checkCacheRightIconShow() : void
      {
         this.model.dispatchEvent(new HallIconEvent(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW));
      }
      
      public function executeCacheRightIconLevelLimit(param1:String, param2:Boolean, param3:int = 0) : void
      {
         if(param2)
         {
            this.model.cacheRightIconLevelLimit[param1] = param3;
         }
         else if(Boolean(this.model.cacheRightIconLevelLimit[param1]))
         {
            delete this.model.cacheRightIconLevelLimit[param1];
         }
      }
      
      private function __onPlayerPropertyChange(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         if(Boolean(param1.changedProperties["Grade"]) && PlayerManager.Instance.Self.IsUpGrade)
         {
            for(_loc2_ in this.model.cacheRightIconLevelLimit)
            {
               _loc3_ = int(this.model.cacheRightIconLevelLimit[_loc2_]);
               if(PlayerManager.Instance.Self.Grade >= _loc3_)
               {
                  this.updateSwitchHandler(_loc2_,true);
                  delete this.model.cacheRightIconLevelLimit[_loc2_];
               }
            }
         }
      }
      
      public function updateSwitchHandler(param1:String, param2:Boolean, param3:String = null, param4:int = -1) : void
      {
         var _loc5_:HallIconInfo = this.convertIconInfo(param1,param2,param3,param4);
         this.cacheRightIcon(param1,_loc5_);
         this.model.dispatchEvent(new HallIconEvent(HallIconEvent.UPDATE_RIGHTICON_VIEW,_loc5_));
      }
      
      private function convertIconInfo(param1:String, param2:Boolean, param3:String, param4:int) : HallIconInfo
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 99;
         switch(param1)
         {
            case HallIconType.WORLDBOSSENTRANCE1:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc5_ = true;
               _loc7_ = 1;
               break;
            case HallIconType.WORLDBOSSENTRANCE4:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc5_ = true;
               _loc7_ = 2;
               break;
            case HallIconType.RINGSTATION:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 3;
               break;
            case HallIconType.LEAGUE:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 4;
               break;
            case HallIconType.BATTLE:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 5;
               break;
            case HallIconType.TRANSNATIONAL:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 6;
               break;
            case HallIconType.CONSORTIABATTLE:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 7;
               break;
            case HallIconType.CAMP:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 8;
               break;
            case HallIconType.FIGHTFOOTBALLTIME:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 9;
               break;
            case HallIconType.SEVENDOUBLE:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 10;
               break;
            case HallIconType.LITTLEGAMENOTE:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 11;
               break;
            case HallIconType.FLOWERGIVING:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 12;
               break;
            case HallIconType.FLOWERGIVING:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 70;
               break;
            case HallIconType.ESCORT:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 13;
               break;
            case HallIconType.BURIED:
               _loc6_ = HallIcon.WONDERFULPLAY;
               _loc7_ = 14;
               break;
            case HallIconType.ACCUMULATIVE_LOGIN:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 1;
               break;
            case HallIconType.SEVENDAYTARGET:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 2;
               break;
            case HallIconType.GODSROADS:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 3;
               break;
            case HallIconType.LIMITACTIVITY:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 4;
               break;
            case HallIconType.OLDPLAYERREGRESS:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 5;
               break;
            case HallIconType.GROWTHPACKAGE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 6;
               break;
            case HallIconType.LEFTGUNROULETTE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 7;
               break;
            case HallIconType.GROUPPURCHASE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 8;
               break;
            case HallIconType.NEWCHICKENBOX:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 9;
               break;
            case HallIconType.SUPERWINNER:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 10;
               break;
            case HallIconType.LUCKSTAR:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 11;
               break;
            case HallIconType.DICE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 12;
               break;
            case HallIconType.TREASUREHUNTING:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 13;
               break;
            case HallIconType.GUILDMEMBERWEEK:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 14;
               break;
            case HallIconType.PYRAMID:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 15;
               break;
            case HallIconType.SYAH:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 16;
               break;
            case HallIconType.MYSTERIOUROULETTE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 17;
               break;
            case HallIconType.CATCHBEAST:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 18;
               break;
            case HallIconType.LANTERNRIDDLES:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 19;
               break;
            case HallIconType.CHRISTMAS:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 20;
               break;
            case HallIconType.LUCKSTONE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 21;
               break;
            case HallIconType.LIGHTROAD:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 22;
               break;
            case HallIconType.ENTERTAINMENT:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 23;
               break;
            case HallIconType.SALESHOP:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 24;
               break;
            case HallIconType.KINGDIVISION:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 25;
               break;
            case HallIconType.CHICKACTIVATION:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 26;
               break;
            case HallIconType.DDPLAY:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 27;
               break;
            case HallIconType.BOGUADVENTURE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 28;
            case HallIconType.HALLOWEEN:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 32;
               break;
            case HallIconType.WITCHBLESSING:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 29;
               break;
            case HallIconType.TREASUREPUZZLE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 30;
               break;
            case HallIconType.HALLOWEEN:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 31;
               break;
            case HallIconType.WORSHIPTHEMOON:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 30;
               break;
            case HallIconType.FOODACTIVITY:
               _loc6_ = 3;
               _loc7_ = 31;
               break;
            case HallIconType.RESCUE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 32;
               break;
            case HallIconType.CATCHINSECT:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 33;
               break;
            case HallIconType.MAGPIEBRIDGE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 34;
               break;
            case HallIconType.CLOUDBUYLOTTERY:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 35;
               break;
            case HallIconType.TREASURELOST:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 32;
               break;
            case HallIconType.NEWYEARRICE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 36;
               break;
            case HallIconType.ZODIAC:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 37;
               break;
            case HallIconType.PRAY_INDIANA:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 35;
               break;
            case "happyRecharge":
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 41;
               break;
            case "lotteryTicket":
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 58;
               break;
            case "conRecharge":
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 56;
               break;
            case "condiscount":
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 64;
               break;
            case "bombTurnTable":
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 54;
               break;
            case "angelInvestment":
               _loc6_ = 2;
               _loc7_ = 53;
               break;
            case "signActivity":
               _loc6_ = 2;
               _loc7_ = 55;
               break;
            case "godOfWealth":
               _loc6_ = 2;
               _loc7_ = 48;
               break;
            case "gypsyShop":
               _loc6_ = 1;
               _loc7_ = 80;
               break;
            case "hotSpring":
               _loc6_ = 1;
               _loc7_ = 81;
               break;
            case "gypsyShop":
               _loc6_ = 1;
               _loc7_ = 83;
               break;
            case "goldmine":
               _loc6_ = 2;
               _loc7_ = 61;
               break;
            case "cryptBoss":
               _loc6_ = 1;
               _loc7_ = 99;
               break;
            case "defend_island":
               _loc6_ = 1;
               _loc7_ = 65;
               break;
            case "buried":
               _loc6_ = 1;
               _loc7_ = 14;
               break;
            case "petIsland":
               _loc6_ = 2;
               _loc7_ = 40;
               break;
            case "sanxiao":
               _loc6_ = 2;
               _loc7_ = 44;
               break;
            case HallIconType.MEMORYGAME:
               _loc6_ = 2;
               _loc7_ = 43;
               break;
            case HallIconType.HORSERACE:
               _loc6_ = HallIcon.ACTIVITY;
               _loc7_ = 33;
               break;
            case HallIconType.MONEYTREE:
               _loc6_ = 1;
               _loc7_ = 15;
               break;
            case "welfareCenter":
               _loc6_ = 2;
               _loc7_ = 51;
               break;
            case "farm":
               _loc6_ = 2;
               _loc7_ = 98;
               break;
            case HallIconType.BATTLEPASS:
               _loc6_ = 2;
               _loc7_ = 52;
               break;
            case HallIconType.LEVELFUND:
               _loc6_ = 2;
               _loc7_ = 89;
               break;
            case HallIconType.PANICBUGING:
               _loc6_ = 2;
               _loc7_ = 45;
               break;
            case HallIconType.BRAVEDOOR:
               _loc6_ = 2;
               _loc7_ = 57;
               break;
            case HallIconType.DDT_KINGWAY:
               _loc6_ = 1;
               _loc7_ = 61;
               break;
            case HallIconType.SEVENDAY:
               _loc6_ = 2;
               _loc7_ = 63;
               break;
            case HallIconType.INDIANA:
               _loc6_ = 2;
               _loc7_ = 62;
         }
         var _loc8_:HallIconInfo = new HallIconInfo();
         _loc8_.halltype = _loc6_;
         _loc8_.icontype = param1;
         _loc8_.isopen = param2;
         _loc8_.timemsg = param3;
         _loc8_.fightover = _loc5_;
         _loc8_.orderid = _loc7_;
         _loc8_.num = param4;
         return _loc8_;
      }
      
      public function showCommonFrame(param1:DisplayObject, param2:String = "", param3:Number = 530, param4:Number = 545) : Frame
      {
         var _loc5_:Frame = ComponentFactory.Instance.creatCustomObject("hallIcon.commonFrame");
         _loc5_.titleText = LanguageMgr.GetTranslation(param2);
         _loc5_.width = param3;
         _loc5_.height = param4;
         _loc5_.addToContent(param1);
         _loc5_.addEventListener(FrameEvent.RESPONSE,this.__commonFrameResponse);
         if(param2 == "wonderfulActivityManager.btnTxt14")
         {
            _loc5_.escEnable = false;
         }
         LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND,true);
         return _loc5_;
      }
      
      private function __commonFrameResponse(param1:FrameEvent) : void
      {
         var _loc2_:Frame = param1.currentTarget as Frame;
         if(Boolean(_loc2_))
         {
            _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__commonFrameResponse);
            ObjectUtils.disposeAllChildren(_loc2_);
            ObjectUtils.disposeObject(_loc2_);
            _loc2_ = null;
         }
      }
      
      public function checkHallIconExperienceTask(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.model.cacheRightIconTask = null;
         }
         else
         {
            this.model.cacheRightIconTask = {"isCompleted":param1};
         }
         dispatchEvent(new HallIconEvent(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN));
      }
      
      public function checkCacheRightIconTask() : void
      {
         if(Boolean(this.model.cacheRightIconTask))
         {
            dispatchEvent(new HallIconEvent(HallIconEvent.CHECK_HALLICONEXPERIENCEOPEN,this.model.cacheRightIconTask.isCompleted));
         }
      }
   }
}

