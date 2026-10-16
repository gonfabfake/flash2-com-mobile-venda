package hall
{
   import AvatarCollection.AvatarCollectionManager;
   import GodSyah.SyahManager;
   import Indiana.IndianaDataManager;
   import LimitAward.LimitAwardButton;
   import accumulativeLogin.AccumulativeManager;
   import angelInvestment.AngelInvestmentManager;
   import anotherDimension.controller.AnotherDimensionManager;
   import calendar.CalendarManager;
   import chickActivation.ChickActivationManager;
   import church.view.weddingRoomList.DivorcePromptFrame;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.LoaderSavingManager;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import condiscount.CondiscountManager;
   import cryptBoss.CryptBossManager;
   import ddt.bagStore.BagStore;
   import ddt.constants.CacheConsts;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.SelfInfo;
   import ddt.loader.StartupResourceLoader;
   import ddt.manager.AcademyManager;
   import ddt.manager.BossBoxManager;
   import ddt.manager.ChatManager;
   import ddt.manager.EdictumManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.manager.TimeManager;
   import ddt.manager.VoteManager;
   import ddt.states.BaseStateView;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import ddt.view.DailyButtunBar;
   import ddt.view.MainToolBar;
   import ddt.view.NovicePlatinumCard;
   import ddt.view.bossbox.AwardsView;
   import ddt.view.bossbox.AwardsViewII;
   import ddt.view.bossbox.SmallBoxButton;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatView;
   import ddtKingWay.DDTKingWayManager;
   import defendisland.DefendislandManager;
   import flash.display.Bitmap;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flowerGiving.FlowerGivingManager;
   import foodActivity.FoodActivityManager;
   import game.view.stage.StageCurtain;
   import growthPackage.GrowthPackageManager;
   import gypsyShop.ctrl.GypsyShopManager;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.view.HallRightIconView;
   import im.IMController;
   import inviteFriends.InviteFriendsManager;
   import labyrinth.LabyrinthManager;
   import levelFund.LevelFundManager;
   import littleGame.LittleGameManager;
   import littleGame.events.LittleGameEvent;
   import lotteryTicket.LotteryManager;
   import magicHouse.MagicHouseManager;
   import magicHouse.MagicHouseModel;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import newYearRice.NewYearRiceManager;
   import noviceactivity.NoviceActivityManager;
   import petsBag.controller.PetBagController;
   import petsBag.event.UpdatePetFarmGuildeEvent;
   import prayIndiana.PrayIndianaManager;
   import quest.TaskMainFrame;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   import road7th.utils.MovieClipWrapper;
   import room.RoomManager;
   import roulette.LeftGunRouletteManager;
   import roulette.RouletteFrameEvent;
   import serverlist.view.ServerDropList;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenday.SevendayManager;
   import shop.manager.ShopSaleManager;
   import shop.view.ShopRechargeEquipAlert;
   import shop.view.ShopRechargeEquipServer;
   import socialContact.friendBirthday.FriendBirthdayManager;
   import store.StrengthDataManager;
   import superWinner.manager.SuperWinnerManager;
   import times.TimesManager;
   import trainer.controller.NewHandGuideManager;
   import trainer.controller.WeakGuildManager;
   import trainer.data.ArrowType;
   import trainer.data.Step;
   import trainer.view.NewHandContainer;
   import trainer.view.WelcomeView;
   import vip.VipController;
   import wonderfulActivity.WonderfulActivityManager;
   
   public class HallStateView extends BaseStateView
   {
      
      public static const VIP_LEFT_DAY_TO_COMFIRM:int = 3;
      
      public static const VIP_LEFT_DAY_FIRST_PROMPT:int = 7;
      
      public static var SoundLoaded:Boolean = false;
      
      private var _hallMainView:MovieClip;
      
      private var _chatView:ChatView;
      
      private var _boxButton:SmallBoxButton;
      
      private var _limitAwardButton:LimitAwardButton;
      
      private var _eventActives:Array;
      
      private var _isIMController:Boolean;
      
      private var isShow:Boolean = false;
      
      private var _renewal:BaseAlerFrame;
      
      private var _isAddFrameComplete:Boolean = false;
      
      private var list:ServerDropList;
      
      private var _littleGameNote:InteractiveObject;
      
      private var btnArray:Array = ["church_mc","shop_mc","dungeon_mc","roomList_mc","auction_mc","active_mc","civil_mc","store_mc","campaignLab_mc","tofflist_mc","hotWell_mc","consortia_mc"];
      
      private var txtArray:Array = ["txt_church_mc","txt_shop_mc","txt_dungeon_mc","txt_roomList_mc","txt_auction_mc","txt_master_mc","txt_civil_mc","txt_store_mc","txt_campaignLab_mc","txt_tofflist_mc","txt_spa_mc","txt_consortia_mc"];
      
      private var _shine:Vector.<MovieClipWrapper>;
      
      private var awards:AwardsViewII;
      
      private const VIP_LEVEL1:String = "112112";
      
      private const VIP_LEVEL2:String = "112113";
      
      private const VIP_LEVEL3:String = "112114";
      
      private const VIP_LEVEL4:String = "112115";
      
      private const VIP_LEVEL5:String = "112116";
      
      private const VIP_LEVEL6:String = "112117";
      
      private const VIP_LEVEL7:String = "112118";
      
      private const VIP_LEVEL8:String = "112119";
      
      private const VIP_LEVEL9:String = "112120";
      
      private var _vipChestsArr:Array = [this.VIP_LEVEL1,this.VIP_LEVEL2,this.VIP_LEVEL3,this.VIP_LEVEL4,this.VIP_LEVEL5,this.VIP_LEVEL6,this.VIP_LEVEL7,this.VIP_LEVEL8,this.VIP_LEVEL9];
      
      private var _trainerWelcomeView:WelcomeView;
      
      private var _battleFrame:Frame;
      
      private var _battlePanel:ScrollPanel;
      
      private var _battleImg:Bitmap;
      
      private var _battleBtn:TextButton;
      
      private var _isFirst:Boolean;
      
      private var _hallRightIconView:HallRightIconView;
      
      private var _timer:Timer;
      
      public function HallStateView()
      {
         if(PathManager.LabertynthEnable)
         {
            this.btnArray[4] = "labertynth_mc";
            this.txtArray[4] = "txt_labertynth_mc";
         }
         super();
         try
         {
            WeakGuildManager.Instance.timeStatistics(0,getDefinitionByName("DDT_Loading").time);
            if(PathManager.isStatistics)
            {
               WeakGuildManager.Instance.statistics(3,getDefinitionByName("DDT_Loading").time);
            }
         }
         catch(e:Error)
         {
         }
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         this._timer = new Timer(1000);
         this._timer.addEventListener("timer",this._checkActivityPer);
         LabyrinthManager.Instance.addEventListener(LabyrinthManager.LABYRINTH_CHAT,this.__labyrinthChat);
         PetBagController.instance().addEventListener(UpdatePetFarmGuildeEvent.FINISH,this.__updatePetFarmGuilde);
      }
      
      private function _checkActivityPer(param1:TimerEvent) : void
      {
         ShopSaleManager.Instance.checkOpenShopSale();
         IndianaDataManager.instance.tickTime();
      }
      
      private function __updatePetFarmGuilde(param1:UpdatePetFarmGuildeEvent) : void
      {
         PetBagController.instance().finishTask();
      }
      
      protected function __labyrinthChat(param1:Event) : void
      {
         LayerManager.Instance.addToLayer(ChatManager.Instance.view,LayerManager.GAME_DYNAMIC_LAYER);
      }
      
      override public function getType() : String
      {
         return StateType.MAIN;
      }
      
      override public function getBackType() : String
      {
         return StateType.MAIN;
      }
      
      override public function enter(param1:BaseStateView, param2:Object = null) : void
      {
         var _loc3_:BaseLoader = null;
         var _loc4_:NovicePlatinumCard = null;
         KeyboardShortcutsManager.Instance.cancelForbidden();
         super.enter(param1,param2);
         SoundManager.instance.playMusic("062",true,false);
         KeyboardShortcutsManager.Instance.setup();
         SocketManager.Instance.out.sendSceneLogin(1);
         SocketManager.Instance.out.sendWonderfulActivity(0,-1);
         SocketManager.Instance.out.requestWonderfulActInit(2);
         if(!this._hallMainView)
         {
            this._hallMainView = ComponentFactory.Instance.creat("asset.hall.hallMainViewAsset");
         }
         this._hallMainView.gotoAndStop(13);
         addChild(this._hallMainView);
         MainToolBar.Instance.show();
         MainToolBar.Instance.btnOpen();
         if(!this._isAddFrameComplete)
         {
            TaskManager.checkHighLight();
         }
         MainToolBar.Instance.enabled = true;
         MainToolBar.Instance.updateReturnBtn(MainToolBar.ENTER_HALL);
         DailyButtunBar.Insance.show();
         ChatManager.Instance.state = ChatManager.CHAT_HALL_STATE;
         ChatManager.Instance.view.visible = true;
         ChatManager.Instance.lock = ChatManager.HALL_CHAT_LOCK;
         ChatManager.Instance.chatDisabled = false;
         addChild(ChatManager.Instance.view);
         if(PathManager.solveWeeklyEnable())
         {
            TimesManager.Instance.showButton();
         }
         if(PlayerManager.Instance.Self.Grade >= 8 && PlayerManager.Instance.Self.Grade <= 70)
         {
            InviteFriendsManager.Instance.showButton();
         }
         CalendarManager.getInstance().showButton();
         this._hallMainView.svrname_txt.text = "";
         if(this.list == null)
         {
            this.list = ComponentFactory.Instance.creat("serverlist.hall.ServerDropList");
         }
         else
         {
            this.list.refresh();
         }
         addChild(this.list);
         this.initBuild();
         this.setLotteryIcon();
         this.setOptionalModule(this._hallMainView["spa_no_mc"],10,!PathManager.solveSPAEnable());
         StartupResourceLoader.Instance.finishLoadingProgress();
         if(NewHandGuideManager.Instance.progress < Step.POP_EXPLAIN_ONE && WeakGuildManager.Instance.switchUserGuide)
         {
            StartupResourceLoader.Instance.addNotStartupNeededResource();
         }
         else
         {
            StartupResourceLoader.Instance.addNotStartupNeededResource();
            if(!SoundLoaded)
            {
               _loc3_ = LoaderManager.Instance.creatLoader(PathManager.solveSoundSwf(),BaseLoader.MODULE_LOADER);
               _loc3_.addEventListener(LoaderEvent.COMPLETE,this.__onAudioLoadComplete);
               LoaderManager.Instance.startLoad(_loc3_);
            }
         }
         this.loadUserGuide();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_MARRY);
         this.checkShowVote();
         CacheSysManager.unlock(CacheConsts.ALERT_IN_FIGHT);
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_FIGHT);
         this.checkShowVipAlert_New();
         this.checkShowBossBox();
         this.checkShowLimiAward();
         LeftGunRouletteManager.instance.addEventListener(RouletteFrameEvent.LEFTGUN_ENABLE,this.__leftGunShow);
         this.checkShowLeftGun();
         this.checkShowStoreFromShop();
         StrengthDataManager.instance.setup();
         if(!this._isIMController && PathManager.CommunityExist())
         {
            this._isIMController = true;
            IMController.Instance.createConsortiaLoader();
         }
         if(SharedManager.Instance.divorceBoolean)
         {
            DivorcePromptFrame.Instance.show();
         }
         if(PlayerManager.Instance.Self.baiduEnterCode == "true")
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard");
            _loc4_.setup();
         }
         TaskManager.MainFrame.addEventListener(TaskMainFrame.TASK_FRAME_HIDE,this.__taskFrameHide);
         this.loadWeakGuild();
         if(!this._isAddFrameComplete)
         {
            this.addFrame();
         }
         CacheSysManager.getInstance().singleRelease(CacheConsts.ALERT_IN_HALL);
         FriendBirthdayManager.Instance.findFriendBirthday();
         EdictumManager.Instance.showEdictum();
         LittleGameManager.Instance.addEventListener(LittleGameEvent.ActivedChanged,this.__littlegameActived);
         this.__littlegameActived(null);
         LeftGunRouletteManager.instance.addEventListener(RouletteFrameEvent.LEFTGUN_ENABLE,this.__leftGunShow);
         this.checkShowLeftGun();
         if(NoviceActivityManager.instance.checkTime())
         {
            NoviceActivityManager.instance.addIcon();
         }
         HallIconManager.instance.checkDefaultIconShow();
         FoodActivityManager.Instance.checkOpen();
         this._hallRightIconView = new HallRightIconView();
         PositionUtils.setPos(this._hallRightIconView,"hallIcon.hallRightIconViewPos");
         LayerManager.Instance.addToLayer(this._hallRightIconView,LayerManager.GAME_UI_LAYER);
         HallIconManager.instance.checkCacheRightIconShow();
         HallIconManager.instance.checkCacheRightIconTask();
         WonderfulActivityManager.Instance.addWAIcon = this.initLimitActivityIcon;
         WonderfulActivityManager.Instance.deleWAIcon = this.deleteLimitActivityIcon;
         if(WonderfulActivityManager.Instance.actList.length > 0 || WonderfulActivityManager.Instance.hasActivity)
         {
            this.initLimitActivityIcon();
         }
         this._eventActives = CalendarManager.getInstance().eventActives;
         GrowthPackageManager.instance.showEnterIcon();
         ChickActivationManager.instance.checkShowIcon();
         this.addAccumulativeLoginAct();
         WorshipTheMoonManager.getInstance().worshipTheMoonIcon(WorshipTheMoonManager.getInstance()._isOpen);
         SevenDayTargetManager.Instance.isHallAct = true;
         SevenDayTargetManager.Instance.onClickSevenDayTargetIcon();
         if(SyahManager.Instance.isOpen)
         {
            if(SyahManager.Instance.login == false)
            {
               SyahManager.Instance.login = true;
               ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("ddt.GodSyah.isCome"));
            }
         }
         CloudBuyLotteryManager.Instance.initIcon(CloudBuyLotteryManager.Instance.model.isOpen);
         NewYearRiceManager.instance.showEnterIcon(NewYearRiceManager.instance.model.isOpen);
         FlowerGivingManager.instance.checkOpen();
         ShopSaleManager.Instance.checkOpenShopSale();
         SuperWinnerManager.instance.addEventListener(SuperWinnerManager.ROOM_IS_OPEN,this.__superWinnerIsOpen);
         PrayIndianaManager.Instance.showPrayIndianaIcon(PrayIndianaManager.Instance.isOpen);
         ConRechargeManager.instance.showIcon();
         LotteryManager.instance.updataEnterIcon();
         LotteryManager.instance.updataEnterIcon();
         ConRechargeManager.instance.showIcon();
         CondiscountManager.instance.showIcon();
         AngelInvestmentManager.instance.initHall(ServerConfigManager.instance.angelInvestmentIsOpen);
         GypsyShopManager.getInstance().refreshNPC();
         CryptBossManager.instance.showIcon();
         DefendislandManager.instance.showIcon();
         AnotherDimensionManager.Instance.checkShowIcon();
         if(AvatarCollectionManager.instance.isDataComplete)
         {
            if(!AvatarCollectionManager.instance.isCheckedAvatarTime)
            {
               this.__checkAvatarCollectionTime(null);
            }
         }
         else
         {
            AvatarCollectionManager.instance.addEventListener("avatar_collection_data_complete",this.__checkAvatarCollectionTime);
         }
         HallIconManager.instance.updateSwitchHandler(HallIconType.MONEYTREE,ServerConfigManager.instance.wealthTreeIsOpen);
         HallIconManager.instance.updateSwitchHandler(HallIconType.BATTLEPASS,PathManager.BattlePassEnable);
         HallIconManager.instance.updateSwitchHandler(HallIconType.FARM,PathManager.FarmEnable);
         LevelFundManager.instance.addLevelFundActivityBtn(this);
         if(FoodActivityManager.Instance._isStart)
         {
            FoodActivityManager.Instance.initBtn();
         }
         DDTKingWayManager.instance.checkIcon();
         SevendayManager.instance.checkIcon();
         IndianaDataManager.instance.checkIcon();
      }
      
      private function __checkAvatarCollectionTime(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:* = null;
         if(Boolean(param1))
         {
            AvatarCollectionManager.instance.removeEventListener("avatar_collection_data_complete",this.__checkAvatarCollectionTime);
         }
         if(!AvatarCollectionManager.instance.maleUnitList)
         {
            return;
         }
         var _loc7_:Array = AvatarCollectionManager.instance.maleUnitList;
         _loc7_ = _loc7_.concat(AvatarCollectionManager.instance.femaleUnitList);
         _loc7_ = _loc7_.concat(AvatarCollectionManager.instance.weaponUnitList);
         _loc2_ = 0;
         while(_loc2_ < _loc7_.length)
         {
            _loc3_ = _loc7_[_loc2_];
            if(!(!_loc3_.endTime || _loc3_.totalActivityItemCount < _loc3_.totalItemList.length / 2))
            {
               _loc4_ = Number(_loc3_.endTime.getTime());
               _loc5_ = TimeManager.Instance.Now().getTime();
               if(_loc4_ - _loc5_ <= 0)
               {
                  _loc6_ = new ChatData();
                  _loc6_.channel = 21;
                  _loc6_.childChannelArr = [7,14];
                  _loc6_.type = 108;
                  _loc6_.msg = LanguageMgr.GetTranslation("avatarCollection.noTime.tipTxt");
                  AvatarCollectionManager.instance.isCheckedAvatarTime = true;
                  ChatManager.Instance.chat(_loc6_);
                  AvatarCollectionManager.instance.skipId = _loc3_.id;
                  break;
               }
            }
            _loc2_++;
         }
      }
      
      private function checkShowLeftGun() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEFTGUNROULETTE,LeftGunRouletteManager.instance.IsOpen);
      }
      
      private function __leftGunShow(param1:RouletteFrameEvent) : void
      {
         this.checkShowLeftGun();
      }
      
      private function __onAudioLoadComplete(param1:LoaderEvent) : void
      {
         param1.loader.removeEventListener(LoaderEvent.COMPLETE,this.__onAudioLoadComplete);
         if(param1.loader.isSuccess)
         {
            SoundManager.instance.setupAudioResource();
            SoundLoaded = true;
         }
      }
      
      private function _getStrArr(param1:DictionaryData) : Array
      {
         return param1[this._vipChestsArr[PlayerManager.Instance.Self.VIPLevel - 1]];
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.awards.hasEventListener(FrameEvent.RESPONSE))
         {
            this.awards.removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         }
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.awards.dispose();
               this.awards = null;
         }
      }
      
      private function __sendReward(param1:Event) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyAward(3);
         this.awards.removeEventListener(AwardsView.HAVEBTNCLICK,this.__sendReward);
         this.awards.dispose();
         PlayerManager.Instance.Self.canTakeVipReward = false;
      }
      
      private function __littlegameActived(param1:Event) : void
      {
         HallIconManager.instance.updateSwitchHandler("littlegamenote",LittleGameManager.Instance.hasActive());
         if(LittleGameManager.Instance.hasActive())
         {
            if(this._littleGameNote == null)
            {
               this._littleGameNote = ComponentFactory.Instance.creat("LittleGameNote");
               addChild(this._littleGameNote);
            }
         }
         else
         {
            ObjectUtils.disposeObject(this._littleGameNote);
            this._littleGameNote = null;
         }
      }
      
      private function setOptionalModule(param1:MovieClip, param2:int, param3:Boolean) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param3)
         {
            param1.visible = true;
            this._hallMainView[this.btnArray[param2]].buttonMode = this._hallMainView[this.btnArray[param2]].mouseEnable = this._hallMainView[this.btnArray[param2]].mouseChildren = false;
            this._hallMainView[this.btnArray[param2]].removeEventListener(MouseEvent.CLICK,this.__btnClick);
            this._hallMainView[this.btnArray[param2]].removeEventListener(MouseEvent.MOUSE_OVER,this.__btnOver);
            this._hallMainView[this.btnArray[param2]].removeEventListener(MouseEvent.MOUSE_OUT,this.__btnOut);
         }
         else
         {
            param1.visible = false;
            this._hallMainView[this.btnArray[param2]].buttonMode = this._hallMainView[this.btnArray[param2]].mouseEnable = this._hallMainView[this.btnArray[param2]].mouseChildren = true;
         }
      }
      
      private function initBuild() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.Grade;
         this.setBuildState(3,true);
         this.setBuildState(6,_loc1_ >= 3 ? Boolean(true) : Boolean(false));
         this.setBuildState(5,_loc1_ >= 5 ? Boolean(true) : Boolean(false));
         this.setBuildState(11,_loc1_ >= 6 ? Boolean(true) : Boolean(false));
         this.setBuildState(2,_loc1_ >= 7 ? Boolean(true) : Boolean(false));
         this.setBuildState(7,_loc1_ >= 2 ? Boolean(true) : Boolean(false));
         this.setBuildState(1,_loc1_ >= 2 ? Boolean(true) : Boolean(false));
         this.setBuildState(0,_loc1_ >= 8 ? Boolean(true) : Boolean(false));
         this.setBuildState(9,_loc1_ >= 10 ? Boolean(true) : Boolean(false));
         this.setBuildState(10,_loc1_ >= 12 ? Boolean(true) : Boolean(false));
         this.setBuildState(4,_loc1_ >= 1 ? Boolean(true) : Boolean(false));
         this.setBuildState(8,_loc1_ >= 14 ? Boolean(true) : Boolean(false));
      }
      
      private function setBuildState(param1:int, param2:Boolean) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            param2 = true;
         }
         _loc3_ = this._hallMainView[this.txtArray[param1]];
         _loc4_ = this._hallMainView[this.btnArray[param1]];
         _loc3_.buttonMode = _loc3_.mouseChildren = _loc3_.mouseEnabled = false;
         _loc4_.buttonMode = _loc4_.mouseChildren = _loc4_.mouseEnabled = _loc3_.visible = param2;
         if(param2)
         {
            _loc4_.addEventListener(MouseEvent.CLICK,this.__btnClick);
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.__btnOver);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.__btnOut);
         }
      }
      
      private function addFrame() : void
      {
         if(this._isAddFrameComplete)
         {
            return;
         }
         if(TimeManager.Instance.TotalDaysToNow(PlayerManager.Instance.Self.LastDate as Date) >= 30 && PlayerManager.Instance.Self.isOldPlayerHasValidEquitAtLogin)
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(new ShopRechargeEquipServer().show));
         }
         else if(PlayerManager.Instance.Self.OvertimeListByBody.length > 0)
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(new ShopRechargeEquipAlert().show));
         }
         else
         {
            InventoryItemInfo.startTimer();
         }
         if(AcademyManager.Instance.isRecommend())
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(AcademyManager.Instance.recommend));
         }
         this._isAddFrameComplete = true;
      }
      
      private function loadWeakGuild() : void
      {
         if(!WeakGuildManager.Instance.switchUserGuide || PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
         {
            return;
         }
         WeakGuildManager.Instance.checkFunction();
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED) && TaskManager.isAchieved(TaskManager.getQuestByID(320)) && !TaskManager.isAchieved(TaskManager.getQuestByID(321)))
         {
            this.buildShine(Step.GAME_ROOM_CLICKED,"asset.trainer.RoomShineAsset","trainer.posBuildGameRoom");
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_SHOW_OPEN))
            {
               this.showBuildOpen(Step.GAME_ROOM_SHOW_OPEN,"asset.trainer.openGameRoom");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
            {
               this.buildShine(Step.GAME_ROOM_CLICKED,"asset.trainer.RoomShineAsset","trainer.posBuildGameRoom");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_SHOW))
            {
               this.showBuildOpen(Step.CIVIL_SHOW,"asset.trainer.openCivil");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_CLICKED))
            {
               this.buildShine(Step.CIVIL_CLICKED,"asset.trainer.shineCivil","trainer.posBuildCivil");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.MASTER_ROOM_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.MASTER_ROOM_SHOW))
            {
               this.showBuildOpen(Step.MASTER_ROOM_SHOW,"asset.trainer.openMasterRoom");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.MASTER_ROOM_CLICKED))
            {
               this.buildShine(Step.MASTER_ROOM_CLICKED,"asset.trainer.shineMasterRoom","trainer.posBuildMasterRoom");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_SHOW))
            {
               this.showBuildOpen(Step.CONSORTIA_SHOW,"asset.trainer.openConsortia");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
            {
               this.buildShine(Step.CONSORTIA_CLICKED,"asset.trainer.shineConsortia","trainer.posBuildConsortia");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_SHOW))
            {
               this.showBuildOpen(Step.DUNGEON_SHOW,"asset.trainer.openDungeon");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
            {
               this.buildShine(Step.DUNGEON_CLICKED,"asset.trainer.shineDungeon","trainer.posBuildDungeon");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_SHOW))
            {
               this.showBuildOpen(Step.CHURCH_SHOW,"asset.trainer.openChurch");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_CLICKED))
            {
               this.buildShine(Step.CHURCH_CLICKED,"asset.trainer.shineChurch","trainer.posBuildChurch");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_SHOW))
            {
               this.showBuildOpen(Step.TOFF_LIST_SHOW,"asset.trainer.openToffList");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_CLICKED))
            {
               this.buildShine(Step.TOFF_LIST_CLICKED,"asset.trainer.shineToffList","trainer.posBuildToffList");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HOT_WELL_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HOT_WELL_SHOW))
            {
               this.showBuildOpen(Step.HOT_WELL_SHOW,"asset.trainer.openHotWell");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HOT_WELL_CLICKED))
            {
               this.buildShine(Step.HOT_WELL_CLICKED,"asset.trainer.shineHotWell","trainer.posBuildHotWell");
            }
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_OPEN))
         {
            return;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_OPEN))
         {
            if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_SHOW))
            {
               this.showBuildOpen(Step.CAMPAIGN_LAB_SHOW,"asset.trainer.openCampaignLab");
            }
            else if(!PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_CLICKED))
            {
               this.buildShine(Step.CAMPAIGN_LAB_CLICKED,"asset.trainer.shineCampaignLab","trainer.posBuildCampaignLab");
            }
         }
      }
      
      private function __taskFrameHide(param1:Event) : void
      {
         this.loadWeakGuild();
      }
      
      private function checkShowVote() : void
      {
         if(VoteManager.Instance.showVote)
         {
            VoteManager.Instance.addEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
            if(VoteManager.Instance.loadOver)
            {
               VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
               VoteManager.Instance.openVote();
            }
         }
      }
      
      private function checkShowVipAlert() : void
      {
         var _loc1_:String = null;
         var _loc2_:SelfInfo = PlayerManager.Instance.Self;
         if(!_loc2_.isSameDay && !VipController.instance.isRechargePoped)
         {
            VipController.instance.isRechargePoped = true;
            if(_loc2_.IsVIP)
            {
               if(_loc2_.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM && _loc2_.VIPLeftDays >= 0 || _loc2_.VIPLeftDays == VIP_LEFT_DAY_FIRST_PROMPT)
               {
                  _loc1_ = "";
                  if(_loc2_.VIPLeftDays == 0)
                  {
                     if(_loc2_.VipLeftHours > 0)
                     {
                        _loc1_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredToday",_loc2_.VipLeftHours);
                     }
                     else if(_loc2_.VipLeftHours == 0)
                     {
                        _loc1_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredHour");
                     }
                     else
                     {
                        _loc1_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue");
                     }
                  }
                  else
                  {
                     _loc1_ = LanguageMgr.GetTranslation("ddt.vip.vipView.expired",_loc2_.VIPLeftDays);
                  }
                  this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc1_,LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._renewal.moveEnable = false;
                  this._renewal.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
               }
            }
            else if(_loc2_.VIPExp > 0)
            {
               if(_loc2_.LastDate.valueOf() < _loc2_.VIPExpireDay.valueOf() && _loc2_.VIPExpireDay.valueOf() <= _loc2_.systemDate.valueOf())
               {
                  this._renewal = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.vip.vipView.expiredTrue"),LanguageMgr.GetTranslation("ddt.vip.vipView.RenewalNow"),"",false,false,false,LayerManager.ALPHA_BLOCKGOUND);
                  this._renewal.moveEnable = false;
                  this._renewal.addEventListener(FrameEvent.RESPONSE,this.__goRenewal);
               }
            }
         }
      }
      
      private function checkShowVipAlert_New() : void
      {
         var _loc1_:SelfInfo = PlayerManager.Instance.Self;
         if(!_loc1_.isSameDay && !VipController.instance.isRechargePoped)
         {
            VipController.instance.isRechargePoped = true;
            if(_loc1_.IsVIP)
            {
               if(_loc1_.VIPLeftDays <= VIP_LEFT_DAY_TO_COMFIRM && _loc1_.VIPLeftDays >= 0 || _loc1_.VIPLeftDays == VIP_LEFT_DAY_FIRST_PROMPT)
               {
                  VipController.instance.showRechargeAlert();
               }
            }
            else if(_loc1_.VIPExp > 0)
            {
               VipController.instance.showRechargeAlert();
            }
         }
      }
      
      private function __goRenewal(param1:FrameEvent) : void
      {
         this._renewal.removeEventListener(FrameEvent.RESPONSE,this.__goRenewal);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               VipController.instance.show();
         }
         this._renewal.dispose();
         if(Boolean(this._renewal.parent))
         {
            this._renewal.parent.removeChild(this._renewal);
         }
         this._renewal = null;
      }
      
      private function __vote(param1:Event) : void
      {
         VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
         VoteManager.Instance.openVote();
      }
      
      private function checkShowBossBox() : void
      {
         if(BossBoxManager.instance.isShowBoxButton())
         {
            if(!this._boxButton)
            {
               this._boxButton = new SmallBoxButton(SmallBoxButton.HALL_POINT);
            }
            addChild(this._boxButton);
         }
      }
      
      private function checkShowLimiAward() : void
      {
         if(CalendarManager.getInstance().checkEventInfo() && PlayerManager.Instance.Self.Grade >= 8)
         {
            if(!this._limitAwardButton)
            {
               this._limitAwardButton = new LimitAwardButton(LimitAwardButton.HALL_POINT);
            }
            addChild(this._limitAwardButton);
         }
      }
      
      private function checkShowStoreFromShop() : void
      {
         if(BagStore.instance.isFromShop)
         {
            BagStore.instance.isFromShop = false;
            BagStore.instance.show();
         }
      }
      
      private function toFightLib() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.CAMPAIGN_LAB_OPEN,15))
         {
            WeakGuildManager.Instance.showBuildPreview("campaignLab_mc",LanguageMgr.GetTranslation("tank.hall.ChooseHallView.campaignLabAlert"));
            return;
         }
         if(PlayerManager.Instance.Self.Grade < 15)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",15));
            return;
         }
         if(PathManager.getFightLibEanble())
         {
            StateManager.setState(StateType.FIGHT_LIB);
            ComponentSetting.SEND_USELOG_ID(12);
            if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CAMPAIGN_LAB_CLICKED))
            {
               SocketManager.Instance.out.syncWeakStep(Step.CAMPAIGN_LAB_CLICKED);
            }
         }
         else
         {
            this.createBattle();
         }
      }
      
      private function toDungeon() : void
      {
         if(!WeakGuildManager.Instance.checkOpen(Step.DUNGEON_OPEN,8))
         {
            WeakGuildManager.Instance.showBuildPreview("dungeon_mc",LanguageMgr.GetTranslation("tank.hall.ChooseHallView.dungeon"));
            return;
         }
         if(!PlayerManager.Instance.checkEnterDungeon)
         {
            return;
         }
         StateManager.setState(StateType.DUNGEON_LIST);
         ComponentSetting.SEND_USELOG_ID(4);
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.DUNGEON_CLICKED))
         {
            SocketManager.Instance.out.syncWeakStep(Step.DUNGEON_CLICKED);
         }
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         SoundManager.instance.play("047");
         switch(param1.currentTarget.name)
         {
            case "auction_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.AUCTION_OPEN,14))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.auction"));
                  return;
               }
               StateManager.setState(StateType.AUCTION);
               ComponentSetting.SEND_USELOG_ID(7);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.AUCTION_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.AUCTION_CLICKED);
               }
               break;
            case "active_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.MASTER_ROOM_OPEN,6))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.master"));
                  return;
               }
               if(PlayerManager.Instance.Self.Grade >= AcademyManager.TARGET_PLAYER_MIN_LEVEL)
               {
                  StateManager.setState(StateType.ACADEMY_REGISTRATION);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("hall.HallStateView.academyInfo"));
               }
               ComponentSetting.SEND_USELOG_ID(11);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.MASTER_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.MASTER_ROOM_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.MASTER_ROOM_CLICKED);
               }
               break;
            case "campaignLab_mc":
               this.toFightLib();
               break;
            case "church_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.CHURCH_OPEN,10))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.church"));
                  return;
               }
               StateManager.setState(StateType.CHURCH_ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(6);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CHURCH_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CHURCH_CLICKED);
               }
               break;
            case "civil_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.CIVIL_OPEN,5))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.civil"));
                  return;
               }
               _loc2_ = false;
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CIVIL_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CIVIL_CLICKED);
                  _loc2_ = true;
               }
               StateManager.setState(StateType.CIVIL,_loc2_);
               ComponentSetting.SEND_USELOG_ID(10);
               break;
            case "consortia_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.CONSORTIA_OPEN,7))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.consortia"));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               ComponentSetting.SEND_USELOG_ID(5);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.CONSORTIA_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.CONSORTIA_CLICKED);
               }
               break;
            case "dungeon_mc":
               this.toDungeon();
               break;
            case "hotWell_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.HOT_WELL_OPEN,13))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.hotWell"));
                  return;
               }
               if(PathManager.solveSPAEnable())
               {
                  StateManager.setState(StateType.HOT_SPRING_ROOM_LIST);
               }
               else
               {
                  this.showSPAAlert();
               }
               ComponentSetting.SEND_USELOG_ID(9);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HOT_WELL_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HOT_WELL_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.HOT_WELL_CLICKED);
               }
               break;
            case "roomList_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.GAME_ROOM_OPEN,2))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.roomList"));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               ComponentSetting.SEND_USELOG_ID(3);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAME_ROOM_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.GAME_ROOM_CLICKED);
               }
               break;
            case "shop_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.SHOP_OPEN,3))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.shop"));
                  return;
               }
               StateManager.setState(StateType.SHOP);
               ComponentSetting.SEND_USELOG_ID(1);
               break;
            case "store_mc":
               if(WeakGuildManager.Instance.switchUserGuide && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.OLD_PLAYER))
               {
                  if(PlayerManager.Instance.Self.Grade < 3)
                  {
                     WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.view.store.title"));
                     return;
                  }
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               ComponentSetting.SEND_USELOG_ID(2);
               break;
            case "tofflist_mc":
               if(!WeakGuildManager.Instance.checkOpen(Step.TOFF_LIST_OPEN,12))
               {
                  WeakGuildManager.Instance.showBuildPreview(param1.currentTarget.name,LanguageMgr.GetTranslation("tank.hall.ChooseHallView.tofflist"));
                  return;
               }
               StateManager.setState(StateType.TOFFLIST);
               ComponentSetting.SEND_USELOG_ID(8);
               if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_OPEN) && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.TOFF_LIST_CLICKED))
               {
                  SocketManager.Instance.out.syncWeakStep(Step.TOFF_LIST_CLICKED);
               }
               break;
            case "lottery_mc":
               if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.magicHouseNeedMinLevel)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",ServerConfigManager.instance.magicHouseNeedMinLevel));
                  return;
               }
               MagicHouseModel.instance.viewIndex = 0;
               MagicHouseManager.instance.show();
         }
      }
      
      private function __btnOver(param1:MouseEvent) : void
      {
         switch(param1.currentTarget.name)
         {
            case "auction_mc":
               this._hallMainView.gotoAndStop(5);
               break;
            case "active_mc":
               this._hallMainView.gotoAndStop(6);
               break;
            case "campaignLab_mc":
               this._hallMainView.gotoAndStop(9);
               break;
            case "church_mc":
               this._hallMainView.gotoAndStop(1);
               break;
            case "civil_mc":
               this._hallMainView.gotoAndStop(7);
               break;
            case "consortia_mc":
               this._hallMainView.gotoAndStop(12);
               break;
            case "dungeon_mc":
               this._hallMainView.gotoAndStop(3);
               break;
            case "hotWell_mc":
               this._hallMainView.gotoAndStop(11);
               break;
            case "tofflist_mc":
               this._hallMainView.gotoAndStop(10);
               break;
            case "roomList_mc":
               this._hallMainView.gotoAndStop(4);
               break;
            case "shop_mc":
               this._hallMainView.gotoAndStop(2);
               break;
            case "store_mc":
               this._hallMainView.gotoAndStop(8);
         }
      }
      
      private function __btnOut(param1:MouseEvent) : void
      {
         if(Boolean(this._hallMainView))
         {
            this._hallMainView.gotoAndStop(13);
         }
      }
      
      private function loadUserGuide() : void
      {
         if(NewHandGuideManager.Instance.progress < Step.POP_EXPLAIN_ONE && WeakGuildManager.Instance.switchUserGuide)
         {
            if(PathManager.TRAINER_STANDALONE && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE))
            {
               SocketManager.Instance.out.syncStep(Step.POP_EXPLAIN_ONE,true);
               this.prePopWelcome();
            }
         }
         MainToolBar.Instance.tipTask();
      }
      
      private function prePopWelcome() : void
      {
         this._trainerWelcomeView = ComponentFactory.Instance.creat("trainer.welcome.mainFrame");
         this._trainerWelcomeView.addEventListener(FrameEvent.RESPONSE,this.__trainerResponse);
         this._trainerWelcomeView.show();
      }
      
      private function __trainerResponse(param1:FrameEvent) : void
      {
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__trainerResponse);
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            if(!PathManager.TRAINER_STANDALONE && !PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GAIN_ADDONE))
            {
               NewHandGuideManager.Instance.mapID = 111;
               SocketManager.Instance.out.createUserGuide();
            }
            this.finPopWelcome();
         }
      }
      
      private function exePopWelcome() : Boolean
      {
         return RoomManager.Instance.current != null;
      }
      
      private function finPopWelcome() : void
      {
         this._trainerWelcomeView.dispose();
         this._trainerWelcomeView = null;
      }
      
      private function createBattle() : void
      {
         this._battleFrame = ComponentFactory.Instance.creatComponentByStylename("hall.battleFrame");
         this._battleFrame.titleText = LanguageMgr.GetTranslation("tank.hall.ChooseHallView.campaignLabAlert");
         this._battleFrame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._battlePanel = ComponentFactory.Instance.creatComponentByStylename("hall.battleSrollPanel");
         this._battleFrame.addToContent(this._battlePanel);
         this._battleImg = ComponentFactory.Instance.creatBitmap("asset.hall.battleLABS");
         this._battlePanel.setView(this._battleImg);
         this._battleBtn = ComponentFactory.Instance.creatComponentByStylename("hall.battleBtn");
         this._battleBtn.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
         this._battleFrame.addToContent(this._battleBtn);
         this._battleBtn.addEventListener(MouseEvent.CLICK,this.__battleBtnClick);
         LayerManager.Instance.addToLayer(this._battleFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function showSPAAlert() : void
      {
         var _loc1_:Frame = ComponentFactory.Instance.creatComponentByStylename("hall.hotSpringAlertFrame");
         _loc1_.addEventListener(FrameEvent.RESPONSE,this.__onRespose);
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __onRespose(param1:FrameEvent) : void
      {
         var _loc2_:Frame = param1.currentTarget as Frame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
         _loc2_.dispose();
      }
      
      private function __battleBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.battleFrameClose();
      }
      
      private function battleFrameClose() : void
      {
         this._battleFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._battleBtn.removeEventListener(MouseEvent.CLICK,this.__battleBtnClick);
         this._battlePanel = null;
         this._battleImg = null;
         this._battleFrame.dispose();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.battleFrameClose();
         }
      }
      
      override public function leaving(param1:BaseStateView) : void
      {
         LittleGameManager.Instance.removeEventListener(LittleGameEvent.ActivedChanged,this.__littlegameActived);
         LeftGunRouletteManager.instance.removeEventListener(RouletteFrameEvent.LEFTGUN_ENABLE,this.__leftGunShow);
         LeftGunRouletteManager.instance.hideGunButton();
         VoteManager.Instance.removeEventListener(VoteManager.LOAD_COMPLETED,this.__vote);
         TaskManager.MainFrame.removeEventListener(TaskMainFrame.TASK_FRAME_HIDE,this.__taskFrameHide);
         MainToolBar.Instance.hide();
         MainToolBar.Instance.updateReturnBtn(MainToolBar.LEAVE_HALL);
         DailyButtunBar.Insance.hide();
         SuperWinnerManager.instance.removeEventListener(SuperWinnerManager.ROOM_IS_OPEN,this.__superWinnerIsOpen);
         FoodActivityManager.Instance.deleteBtn();
         if(Boolean(this._shine))
         {
            while(this._shine.length > 0)
            {
               this._shine.shift().dispose();
            }
            this._shine = null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 12)
         {
            this._hallMainView[this.btnArray[_loc2_]].removeEventListener(MouseEvent.CLICK,this.__btnClick);
            this._hallMainView[this.btnArray[_loc2_]].removeEventListener(MouseEvent.MOUSE_OVER,this.__btnOver);
            this._hallMainView[this.btnArray[_loc2_]].removeEventListener(MouseEvent.MOUSE_OUT,this.__btnOut);
            _loc2_++;
         }
         if(Boolean(this._hallMainView.parent))
         {
            removeChild(this._hallMainView);
         }
         this._hallMainView = null;
         if(Boolean(this._boxButton))
         {
            BossBoxManager.instance.deleteBoxButton();
            ObjectUtils.disposeObject(this._boxButton);
         }
         this.list.dispose();
         this.list = null;
         this._boxButton = null;
         ObjectUtils.disposeObject(this._littleGameNote);
         this._littleGameNote = null;
         if(Boolean(this._limitAwardButton))
         {
            ObjectUtils.disposeObject(this._limitAwardButton);
         }
         this._limitAwardButton = null;
         if(PathManager.solveWeeklyEnable())
         {
            TimesManager.Instance.hideButton();
         }
         if(param1.getType() != StateType.DUNGEON_LIST && param1.getType() != StateType.ROOM_LIST)
         {
            GameInSocketOut.sendExitScene();
         }
         if(Boolean(this._hallRightIconView))
         {
            ObjectUtils.disposeObject(this._hallRightIconView);
            this._hallRightIconView = null;
         }
         WonderfulActivityManager.Instance.addWAIcon = null;
         WonderfulActivityManager.Instance.deleWAIcon = null;
         super.leaving(param1);
      }
      
      override public function prepare() : void
      {
         super.prepare();
         this._isFirst = true;
      }
      
      override public function fadingComplete() : void
      {
         var _loc1_:SaveFileWidow = null;
         super.fadingComplete();
         if(this._isFirst)
         {
            this._isFirst = false;
            if(LoaderSavingManager.cacheAble == false && PlayerManager.Instance.Self.IsFirst > 1)
            {
               _loc1_ = ComponentFactory.Instance.creatComponentByStylename("hall.SaveFileWidow");
               _loc1_.show();
            }
            LeavePageManager.setFavorite(PlayerManager.Instance.Self.IsFirst <= 1);
         }
      }
      
      private function showBuildOpen(param1:int, param2:String) : void
      {
         var _loc3_:String = null;
         if(StateManager.currentStateType != StateType.MAIN)
         {
            return;
         }
         SoundManager.instance.play("159");
         var _loc4_:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(param2),true,true);
         _loc4_.movie.mouseEnabled = _loc4_.movie.mouseChildren = false;
         addChild(_loc4_.movie);
         SocketManager.Instance.out.syncWeakStep(param1);
         switch(param1)
         {
            case Step.GAME_ROOM_SHOW_OPEN:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeGameRoom);
               _loc3_ = "tank.hall.ChooseHallView.roomList";
               break;
            case Step.CIVIL_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeCivil);
               _loc3_ = "tank.hall.ChooseHallView.civil";
               break;
            case Step.MASTER_ROOM_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeMasterRoom);
               _loc3_ = "tank.hall.ChooseHallView.master";
               break;
            case Step.CONSORTIA_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeConsortia);
               _loc3_ = "tank.hall.ChooseHallView.consortia";
               break;
            case Step.DUNGEON_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeDungeon);
               _loc3_ = "tank.hall.ChooseHallView.dungeon";
               break;
            case Step.CHURCH_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeChurch);
               _loc3_ = "tank.hall.ChooseHallView.church";
               break;
            case Step.TOFF_LIST_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeToffList);
               _loc3_ = "tank.hall.ChooseHallView.tofflist";
               break;
            case Step.HOT_WELL_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeHotWell);
               _loc3_ = "tank.hall.ChooseHallView.hotWell";
               break;
            case Step.AUCTION_SHOW:
               return;
            case Step.CAMPAIGN_LAB_SHOW:
               _loc4_.addEventListener(Event.COMPLETE,this.__completeCampaignLab);
               _loc3_ = "tank.hall.ChooseHallView.campaignLabAlert";
         }
         WeakGuildManager.Instance.openBuildTip(_loc3_);
      }
      
      private function __completeGameRoom(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeGameRoom);
         this.buildShine(Step.GAME_ROOM_CLICKED,"asset.trainer.RoomShineAsset","trainer.posBuildGameRoom");
      }
      
      private function __completeCivil(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeCivil);
         this.buildShine(Step.CIVIL_CLICKED,"asset.trainer.shineCivil","trainer.posBuildCivil");
      }
      
      private function __completeMasterRoom(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeMasterRoom);
         this.buildShine(Step.MASTER_ROOM_CLICKED,"asset.trainer.shineMasterRoom","trainer.posBuildMasterRoom");
      }
      
      private function __completeConsortia(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeConsortia);
         this.buildShine(Step.CONSORTIA_CLICKED,"asset.trainer.shineConsortia","trainer.posBuildConsortia");
      }
      
      private function __completeDungeon(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeDungeon);
         this.buildShine(Step.DUNGEON_CLICKED,"asset.trainer.shineDungeon","trainer.posBuildDungeon");
      }
      
      private function __completeChurch(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeChurch);
         this.buildShine(Step.CHURCH_CLICKED,"asset.trainer.shineChurch","trainer.posBuildChurch");
      }
      
      private function __completeToffList(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeToffList);
         this.buildShine(Step.TOFF_LIST_CLICKED,"asset.trainer.shineToffList","trainer.posBuildToffList");
      }
      
      private function __completeHotWell(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeHotWell);
         this.buildShine(Step.HOT_WELL_CLICKED,"asset.trainer.shineHotWell","trainer.posBuildHotWell");
      }
      
      private function __completeAuction(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeAuction);
         this.buildShine(Step.AUCTION_CLICKED,"asset.trainer.shineAuction","trainer.posBuildAuction");
      }
      
      private function __completeCampaignLab(param1:Event) : void
      {
         MovieClipWrapper(param1.currentTarget).removeEventListener(Event.COMPLETE,this.__completeCampaignLab);
         this.buildShine(Step.CAMPAIGN_LAB_CLICKED,"asset.trainer.shineCampaignLab","trainer.posBuildCampaignLab");
      }
      
      private function __onClickServerName(param1:MouseEvent) : void
      {
      }
      
      private function buildShine(param1:int, param2:String, param3:String) : void
      {
         if(StateManager.currentStateType != StateType.MAIN)
         {
            return;
         }
         var _loc4_:Point = ComponentFactory.Instance.creatCustomObject(param3);
         var _loc5_:MovieClipWrapper = new MovieClipWrapper(ClassUtils.CreatInstance(param2),true,false);
         _loc5_.movie.mouseEnabled = _loc5_.movie.mouseChildren = false;
         _loc5_.repeat = true;
         _loc5_.movie.x = _loc4_.x;
         _loc5_.movie.y = _loc4_.y;
         addChild(_loc5_.movie);
         if(!this._shine)
         {
            this._shine = new Vector.<MovieClipWrapper>();
         }
         this._shine.push(_loc5_);
         NewHandContainer.Instance.clearArrowByID(-1);
         switch(param1)
         {
            case Step.GAME_ROOM_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,145,"trainer.gameRoomArrowPos","asset.trainer.txtClickHall","trainer.gameRoomTipPos",this);
               break;
            case Step.CIVIL_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-150,"trainer.civilArrowPos","asset.trainer.txtClickCivil","trainer.civilTipPos",this);
               break;
            case Step.MASTER_ROOM_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-150,"trainer.masterRoomArrowPos","asset.trainer.txtClickMasterRoom","trainer.masterRoomTipPos",this);
               break;
            case Step.CONSORTIA_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,45,"trainer.consortiaArrowPos","asset.trainer.txtClickConsortia","trainer.consortiaTipPos",this);
               break;
            case Step.DUNGEON_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-45,"trainer.dungeonArrowPos","asset.trainer.txtClickDungeon","trainer.dungeonTipPos",this);
               break;
            case Step.CHURCH_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,30,"trainer.churchArrowPos","asset.trainer.txtClickChurch","trainer.churchTipPos",this);
               break;
            case Step.TOFF_LIST_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,150,"trainer.toffListArrowPos","asset.trainer.txtClickToffList","trainer.toffListTipPos",this);
               break;
            case Step.HOT_WELL_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,150,"trainer.hotWellArrowPos","asset.trainer.txtClickHotWell","trainer.hotWellTipPos",this);
               break;
            case Step.AUCTION_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,-30,"trainer.auctionArrowPos","asset.trainer.txtClickAuction","trainer.auctionTipPos",this);
               break;
            case Step.CAMPAIGN_LAB_CLICKED:
               NewHandContainer.Instance.showArrow(ArrowType.HALL_BUILD,150,"trainer.campaignLabArrowPos","asset.trainer.txtClickCampaignLab","trainer.campaignLabTipPos",this);
         }
      }
      
      override public function refresh() : void
      {
         var _loc1_:StageCurtain = new StageCurtain();
         _loc1_.play(25);
         LayerManager.Instance.clearnGameDynamic();
         ShowTipManager.Instance.removeAllTip();
         ChatManager.Instance.lock = ChatManager.HALL_CHAT_LOCK;
         this.enter(null);
      }
      
      private function setLotteryIcon() : void
      {
         var _loc1_:MovieClip = this._hallMainView["lottery_mc"];
         _loc1_.visible = PathManager.solveLotteryEnable();
         _loc1_.buttonMode = _loc1_.mouseChildren = _loc1_.mouseEnabled = true;
         _loc1_.addEventListener(MouseEvent.CLICK,this.__btnClick);
      }
      
      private function initLimitActivityIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIMITACTIVITY,true);
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEAGUE,DateUtils.checkTimeCompare("19:30","21:30"));
      }
      
      private function deleteLimitActivityIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LIMITACTIVITY,false);
         HallIconManager.instance.updateSwitchHandler(HallIconType.LEAGUE,DateUtils.checkTimeCompare("19:30","21:30"));
      }
      
      private function addAccumulativeLoginAct() : void
      {
         if(PlayerManager.Instance.Self.accumulativeLoginDays >= 7 && PlayerManager.Instance.Self.accumulativeAwardDays >= 7)
         {
            AccumulativeManager.instance.removeAct();
         }
         else
         {
            AccumulativeManager.instance.addAct();
         }
      }
      
      private function __superWinnerIsOpen(param1:Event) : void
      {
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_NEWVERSIONGUIDETIP,new FunctionAction(this.superWinnerShowFrame));
         }
         else
         {
            this.superWinnerShowFrame();
         }
      }
      
      private function superWinnerShowFrame() : void
      {
         var _loc1_:BaseAlerFrame = null;
         if(SuperWinnerManager.instance.isOpen && PlayerManager.Instance.Self.Grade >= 20)
         {
            _loc1_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.superWinner.openSuperWinner"),LanguageMgr.GetTranslation("ok"),"",false,true,true,LayerManager.BLCAK_BLOCKGOUND);
            _loc1_.addEventListener(FrameEvent.RESPONSE,this._responseEnterSuperWinner);
         }
      }
      
      private function _responseEnterSuperWinner(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this._responseEnterSuperWinner);
         SoundManager.instance.playButtonSound();
         _loc2_.dispose();
      }
      
      public function setNPCBtnEnable(param1:*, param2:Boolean) : void
      {
      }
   }
}

