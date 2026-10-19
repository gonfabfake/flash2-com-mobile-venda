package hallIcon.view
{
   import BombTurnTable.BombTurnTableManager;
   import BraveDoor.BraveDoorManager;
   import DDPlay.DDPlayManaer;
   import GodSyah.SyahManager;
   import HappyRecharge.HappyRechargeManager;
   import Indiana.IndianaDataManager;
   import accumulativeLogin.AccumulativeManager;
   import angelInvestment.AngelInvestmentManager;
   import battlePass.BattlePassManager;
   import catchbeast.CatchBeastManager;
   import chickActivation.ChickActivationManager;
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import conRecharge.ConRechargeManager;
   import condiscount.CondiscountManager;
   import cryptBoss.CryptBossManager;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.view.FoodActivityEnterIcon;
   import ddt.view.bossbox.SmallBoxButton;
   import ddtKingWay.DDTKingWayManager;
   import entertainmentMode.EntertainmentModeManager;
   import farm.FarmModelController;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flowerGiving.FlowerGivingManager;
   import foodActivity.FoodActivityManager;
   import godOfWealth.GodOfWealthManager;
   import godsRoads.manager.GodsRoadsManager;
   import goldmine.GoldmineManager;
   import groupPurchase.GroupPurchaseManager;
   import growthPackage.GrowthPackageManager;
   import guildMemberWeek.manager.GuildMemberWeekManager;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyNPCModel;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import hallIcon.event.HallIconEvent;
   import hallIcon.info.HallIconInfo;
   import levelFund.LevelFundManager;
   import lightRoad.manager.LightRoadManager;
   import lotteryTicket.LotteryManager;
   import luckStar.manager.LuckStarManager;
   import memoryGame.MemoryGameManager;
   import midAutumnWorshipTheMoon.WorshipTheMoonManager;
   import moneyTree.MoneyTreeManager;
   import newChickenBox.controller.NewChickenBoxManager;
   import newYearRice.NewYearRiceManager;
   import panicBuying.PanicBuyingManager;
   import prayIndiana.PrayIndianaManager;
   import pyramid.PyramidManager;
   import rank.RankManager;
   import roleRecharge.RoleRechargeMgr;
   import roulette.LeftGunRouletteManager;
   import sanXiao.SanXiaoManager;
   import sevenDayTarget.controller.NewSevenDayAndNewPlayerManager;
   import sevenDayTarget.controller.SevenDayTargetManager;
   import sevenday.SevendayManager;
   import shop.manager.ShopSaleManager;
   import signActivity.SignActivityMgr;
   import superWinner.manager.SuperWinnerManager;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   import welfareCenter.WelfareCenterManager;
   import witchBlessing.WitchBlessingManager;
   import wonderfulActivity.WonderfulActivityManager;
   import zodiac.ZodiacManager;
   
   public class HallRightIconView extends Sprite implements Disposeable
   {
      
      private var _iconBox:HBox;
      
      private var _iconTopBox:HBox;
      
      private var _boxButton:SmallBoxButton;
      
      private var _wonderFulPlay:HallIconPanel;
      
      private var _activity:HallIconPanel;
      
      private var _lastCreatTime:Number;
      
      private var _showArrowSp:Sprite;
      
      private var _loginToal:MovieClip;
      
      private var _roleRechargeIcon:HallIconPanel;
      
      private var _rankIcon:MovieClip;
      
      private var _foodButton:FoodActivityEnterIcon;
      
      public function HallRightIconView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._showArrowSp = new Sprite();
         addChild(this._showArrowSp);
         this._iconBox = new HBox();
         this._iconBox.spacing = 5;
         addChild(this._iconBox);
         this._iconTopBox = new HBox();
         this._iconTopBox.spacing = 5;
         this._iconTopBox.y = -294;
         addChild(this._iconTopBox);
         this.updateActivityIcon();
         this.updateWonderfulPlayIcon();
         this.updateRoleRechargeIcon();
         this.updateRankIcon();
         SignActivityMgr.instance.showIcon();
         CondiscountManager.instance.showIcon();
         ConRechargeManager.instance.showIcon();
      }
      
      private function initEvent() : void
      {
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.addEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
      }
      
      private function addChildBox(param1:DisplayObject) : void
      {
         this._iconBox.addChild(param1);
         this._iconBox.arrange();
         this._iconBox.x = -this._iconBox.width;
      }
      
      private function addChildTopBox(param1:DisplayObject) : void
      {
         this._iconTopBox.addChild(param1);
         this._iconTopBox.arrange();
         this._iconTopBox.x = -(this._iconTopBox.width + 117);
      }
      
      private function __updateBatchIconViewHandler(param1:HallIconEvent) : void
      {
         var _loc2_:HallIconInfo = null;
         var _loc3_:Dictionary = HallIconManager.instance.model.cacheRightIconDic;
         for each(_loc2_ in _loc3_)
         {
            this.updateIconView(_loc2_);
         }
      }
      
      private function __updateIconViewHandler(param1:HallIconEvent) : void
      {
         var _loc2_:HallIconInfo = HallIconInfo(param1.data);
         this.updateIconView(_loc2_);
      }
      
      private function updateIconView(param1:HallIconInfo) : void
      {
         if(param1.halltype == 1 && Boolean(this._wonderFulPlay))
         {
            this.commonUpdateIconPanelView(this._wonderFulPlay,param1,false);
            if(!param1.isopen)
            {
               this.removeWonderFulPlayChildHandler(param1.icontype);
            }
         }
         else if(param1.halltype == HallIcon.ACTIVITY && Boolean(this._activity))
         {
            this.commonUpdateIconPanelView(this._activity,param1);
         }
         else
         {
            switch(param1.icontype)
            {
               case HallIconType.ACTIVITY:
                  SignActivityMgr.instance.showIcon();
                  CondiscountManager.instance.showIcon();
                  ConRechargeManager.instance.showIcon();
                  this.updateActivityIcon();
                  break;
               case "wonderfulplay":
                  this.updateWonderfulPlayIcon();
                  break;
               case "roleRecharge":
                  this.updateRoleRechargeIcon();
                  break;
               case "FoodActivity":
                  this.checkFoodBox();
                  break;
               case "rank":
                  this.updateRankIcon();
            }
         }
      }
      
      private function checkFoodBox() : void
      {
         if(FoodActivityManager.Instance._isStart)
         {
            if(this._foodButton == null)
            {
               this._foodButton = FoodActivityManager.Instance.foodActivityIcon;
               this.addChildTopBox(this._foodButton);
            }
         }
         else
         {
            this.removeFoodBox();
         }
      }
      
      private function removeFoodBox() : void
      {
         if(Boolean(this._foodButton))
         {
            FoodActivityManager.Instance.stopTime();
            ObjectUtils.disposeAllChildren(this._foodButton);
            ObjectUtils.disposeObject(this._foodButton);
            this._foodButton = null;
            FoodActivityManager.Instance.deleteBtn();
         }
      }
      
      public function removeWonderFulPlayChildHandler(param1:String) : void
      {
         var _loc2_:String = param1;
         switch(0)
         {
         }
      }
      
      private function commonUpdateIconPanelView(param1:HallIconPanel, param2:HallIconInfo, param3:Boolean = false) : void
      {
         var _loc4_:HallIcon = null;
         if(param2.isopen)
         {
            _loc4_ = param1.getIconByType(param2.icontype) as HallIcon;
            if(!_loc4_)
            {
               _loc4_ = param1.addIcon(this.createHallIconPanelIcon(param2),param2.icontype,param2.orderid,param3) as HallIcon;
            }
            _loc4_.updateIcon(param2);
         }
         else
         {
            param1.removeIconByType(param2.icontype);
         }
         param1.arrange();
      }
      
      private function updateActivityIcon() : void
      {
         if(HallIconManager.instance.model.activityIsOpen)
         {
            if(this._activity == null)
            {
               this._activity = new HallIconPanel("assets.hallIcon.activityIcon",HallIconPanel.LEFT,6);
               this._activity.addEventListener(MouseEvent.CLICK,this.__activityClickHandler);
               this.addChildBox(this._activity);
            }
         }
         else
         {
            this.removeActivityIcon();
         }
      }
      
      private function __activityClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:HallIcon = null;
         var _loc3_:PlayerInfo = null;
         SevenDayTargetManager.Instance.isHallAct = false;
         if(Boolean(this._activity) && param1.target == this._activity.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._activity.count);
            return;
         }
         SevenDayTargetManager.Instance.isHallAct = false;
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(param1.target is HallIcon)
         {
            _loc2_ = param1.target as HallIcon;
            if(_loc2_.iconInfo.halltype == HallIcon.ACTIVITY)
            {
               switch(_loc2_.iconInfo.icontype)
               {
                  case HallIconType.GODSROADS:
                     GodsRoadsManager.instance.openGodsRoads(param1);
                     break;
                  case HallIconType.LIMITACTIVITY:
                     SoundManager.instance.play("008");
                     WonderfulActivityManager.Instance.clickWonderfulActView = true;
                     SocketManager.Instance.out.requestWonderfulActInit(1);
                     break;
                  case HallIconType.DDPLAY:
                     SoundManager.instance.play("008");
                     DDPlayManaer.Instance.show();
                     break;
                  case HallIconType.PYRAMID:
                     PyramidManager.instance.onClickPyramidIcon(param1);
                     break;
                  case HallIconType.HALLOWEEN:
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.halloweenInit();
                     break;
                  case HallIconType.CATCHBEAST:
                     CatchBeastManager.instance.onCatchBeastShow(param1);
                     break;
                  case HallIconType.GROWTHPACKAGE:
                     GrowthPackageManager.instance.onClickIcon(param1);
                     break;
                  case HallIconType.ACCUMULATIVE_LOGIN:
                     AccumulativeManager.instance.showFrame();
                     break;
                  case HallIconType.ZODIAC:
                     SoundManager.instance.play("008");
                     ZodiacManager.instance.showFrame();
                     break;
                  case HallIconType.BOGUADVENTURE:
                     SoundManager.instance.playButtonSound();
                     if(PlayerManager.Instance.Self.Grade < 10)
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                     }
                     else
                     {
                        StateManager.setState(StateType.BOGU_ADVENTURE);
                     }
                     break;
                  case HallIconType.LIGHTROAD:
                     LightRoadManager.instance.onClicklightRoadIcon(param1);
                     break;
                  case HallIconType.GUILDMEMBERWEEK:
                     GuildMemberWeekManager.instance.onClickguildMemberWeekIcon(param1);
                     break;
                  case HallIconType.CHICKACTIVATION:
                     SoundManager.instance.play("008");
                     ChickActivationManager.instance.showFrame();
                     break;
                  case HallIconType.GROUPPURCHASE:
                     GroupPurchaseManager.instance.showFrame();
                     break;
                  case HallIconType.SALESHOP:
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.sendGetShopBuyLimitedCount();
                     ShopSaleManager.Instance.show();
                     break;
                  case HallIconType.WORSHIPTHEMOON:
                     SoundManager.instance.playButtonSound();
                     WorshipTheMoonManager.getInstance().showFrame();
                     break;
                  case HallIconType.NEWCHICKENBOX:
                     NewChickenBoxManager.instance.enterNewBoxView(param1);
                     break;
                  case HallIconType.SEVENDAYTARGET:
                     NewSevenDayAndNewPlayerManager.Instance.onClickSevenDayTargetIcon(param1);
                     break;
                  case HallIconType.SYAH:
                     SyahManager.Instance.showFrame();
                     break;
                  case HallIconType.LUCKSTAR:
                     LuckStarManager.Instance.onClickLuckyStarIocn(param1);
                     break;
                  case HallIconType.CLOUDBUYLOTTERY:
                     SoundManager.instance.play("008");
                     CloudBuyLotteryManager.Instance.loaderCloudBuyFrame();
                     break;
                  case HallIconType.TREASUREPUZZLE:
                     SoundManager.instance.playButtonSound();
                     TreasurePuzzleManager.Instance.onClickTreasurePuzzleIcon();
                     break;
                  case HallIconType.WITCHBLESSING:
                     SoundManager.instance.playButtonSound();
                     WitchBlessingManager.Instance.onClickIcon();
                     break;
                  case HallIconType.NEWYEARRICE:
                     SoundManager.instance.play("008");
                     NewYearRiceManager.instance.onClickNewYearRiceIcon(param1);
                     break;
                  case HallIconType.FLOWERGIVING:
                     FlowerGivingManager.instance.onIconClick(param1);
                     break;
                  case HallIconType.SUPERWINNER:
                     SuperWinnerManager.instance.setup();
                     SuperWinnerManager.instance.openSuperWinner(param1);
                     break;
                  case HallIconType.PRAY_INDIANA:
                     SoundManager.instance.playButtonSound();
                     PrayIndianaManager.Instance.onClickIcon();
                     break;
                  case "happyRecharge":
                     SoundManager.instance.play("008");
                     HappyRechargeManager.instance.loadResource();
                     break;
                  case "lotteryTicket":
                     SoundManager.instance.play("008");
                     LotteryManager.instance.isClick = true;
                     LotteryManager.instance.loadResource();
                     break;
                  case "conRecharge":
                     SoundManager.instance.playButtonSound();
                     ConRechargeManager.instance.loadResource();
                     break;
                  case "condiscount":
                     SoundManager.instance.play("008");
                     CondiscountManager.instance.show();
                     break;
                  case "bombTurnTable":
                     BombTurnTableManager.instance.openView_Handler();
                     break;
                  case "angelInvestment":
                     AngelInvestmentManager.instance.onClickIcon();
                     break;
                  case "signActivity":
                     SocketManager.Instance.out.requestWonderfulActInit(2);
                     SoundManager.instance.playButtonSound();
                     SignActivityMgr.instance.loadResource();
                     break;
                  case "godOfWealth":
                     SoundManager.instance.play("008");
                     GodOfWealthManager.getInstance().show();
                     break;
                  case "goldmine":
                     SoundManager.instance.play("008");
                     GoldmineManager.Instance.show();
                     break;
                  case "petIsland":
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.petIslandInit(1);
                     break;
                  case "sanxiao":
                     SoundManager.instance.play("008");
                     SanXiaoManager.getInstance().show();
                     break;
                  case "memoryGame":
                     SoundManager.instance.play("008");
                     MemoryGameManager.instance.show();
                     break;
                  case "welfareCenter":
                     WelfareCenterManager.instance.showView();
                     break;
                  case "farm":
                     FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
                     break;
                  case HallIconType.BATTLEPASS:
                     SoundManager.instance.playButtonSound();
                     BattlePassManager.instance.show();
                     break;
                  case HallIconType.LEFTGUNROULETTE:
                     SoundManager.instance.play("008");
                     LeftGunRouletteManager.instance.showTurnplate();
                     break;
                  case HallIconType.LEVELFUND:
                     SoundManager.instance.play("008");
                     LevelFundManager.instance.show();
                     break;
                  case HallIconType.PANICBUGING:
                     SoundManager.instance.play("008");
                     PanicBuyingManager.instance.show();
                     break;
                  case HallIconType.BRAVEDOOR:
                     BraveDoorManager.instance.openView_Handler();
                     break;
                  case HallIconType.ENTERTAINMENT:
                     SoundManager.instance.play("008");
                     EntertainmentModeManager.instance.show();
                     break;
                  case HallIconType.SEVENDAY:
                     SoundManager.instance.play("008");
                     SevendayManager.instance.show();
                     break;
                  case HallIconType.INDIANA:
                     SoundManager.instance.play("008");
                     IndianaDataManager.instance.show();
               }
            }
         }
      }
      
      public function createHallIconPanelIcon(param1:HallIconInfo) : HallIcon
      {
         var _loc2_:String = null;
         switch(param1.icontype)
         {
            case HallIconType.WORLDBOSSENTRANCE1:
               _loc2_ = "assets.hallIcon.worldBossEntrance_1";
               break;
            case HallIconType.WORLDBOSSENTRANCE4:
               _loc2_ = "assets.hallIcon.worldBossEntrance_4";
               break;
            case HallIconType.CAMP:
               _loc2_ = "assets.hallIcon.campIcon";
               break;
            case HallIconType.BATTLE:
               _loc2_ = "assets.hallIcon.battleIcon";
               break;
            case HallIconType.SEVENDOUBLE:
               _loc2_ = "assets.hallIcon.sevenDoubleEntryIcon";
               break;
            case HallIconType.LEAGUE:
               _loc2_ = "assets.hallIcon.leagueIcon";
               break;
            case HallIconType.RINGSTATION:
               _loc2_ = "assets.hallIcon.ringStationIcon";
               break;
            case HallIconType.TRANSNATIONAL:
               _loc2_ = "assets.hallIcon.transnationalIcon";
               break;
            case HallIconType.FIGHTFOOTBALLTIME:
               _loc2_ = "assets.hallIcon.fightFootballTimeIcon";
               break;
            case HallIconType.CONSORTIABATTLE:
               _loc2_ = "assets.hallIcon.consortiaBattleEntryIcon";
               break;
            case HallIconType.LITTLEGAMENOTE:
               _loc2_ = "assets.hallIcon.littleGameNoteIcon";
               break;
            case HallIconType.FLOWERGIVING:
               _loc2_ = "assets.hallIcon.flowerGivingIcon";
               break;
            case HallIconType.ESCORT:
               _loc2_ = "assets.hallIcon.escortEntryIcon";
               break;
            case HallIconType.BURIED:
               _loc2_ = "assets.hallIcon.buriedIcon";
               break;
            case HallIconType.CHRISTMAS:
               _loc2_ = "assets.hallIcon.christmasIcon";
               break;
            case HallIconType.CATCHBEAST:
               _loc2_ = "asset.hallIcon.catchBeastIcon";
               break;
            case HallIconType.PYRAMID:
               _loc2_ = "assets.hallIcon.pyramidIcon";
               break;
            case HallIconType.SUPERWINNER:
               _loc2_ = "assets.hallIcon.superWinnerEntryIcon";
               break;
            case HallIconType.LUCKSTAR:
               _loc2_ = "assets.hallIcon.luckyStarIcon";
               break;
            case HallIconType.GROWTHPACKAGE:
               _loc2_ = "assets.hallIcon.growthPachageIcon";
               break;
            case HallIconType.DICE:
               _loc2_ = "assets.hallIcon.diceIcon";
               break;
            case HallIconType.ACCUMULATIVE_LOGIN:
               _loc2_ = "assets.hallIcon.accumulativeLoginIcon";
               break;
            case HallIconType.GUILDMEMBERWEEK:
               _loc2_ = "assets.hallIcon.guildmemberweekIcon";
               break;
            case HallIconType.LANTERNRIDDLES:
               _loc2_ = "assets.hallIcon.lanternriddlesIcon";
               break;
            case HallIconType.NEWCHICKENBOX:
               _loc2_ = "assets.hallIcon.newChickenBoxIcon";
               break;
            case HallIconType.LEFTGUNROULETTE:
               _loc2_ = "assets.hallIcon.rouletteGunIcon";
               break;
            case HallIconType.GROUPPURCHASE:
               _loc2_ = "assets.hallIcon.groupPurchaseIcon";
               break;
            case HallIconType.LUCKSTONE:
               _loc2_ = "assets.hallIcon.luckStoneIcon";
               break;
            case HallIconType.MYSTERIOUROULETTE:
               _loc2_ = "assets.hallIcon.mysteriousRouletteIcon";
               break;
            case HallIconType.SYAH:
               _loc2_ = "assets.hallIcon.syahIcon";
               break;
            case HallIconType.TREASUREHUNTING:
               _loc2_ = "assets.hallIcon.treasureHuntingIcon";
               break;
            case HallIconType.OLDPLAYERREGRESS:
               _loc2_ = "assets.hallIcon.oldPlayerRegressIcon";
               break;
            case HallIconType.LIMITACTIVITY:
               _loc2_ = "assets.hallIcon.limitActivityIcon";
               break;
            case HallIconType.LIGHTROAD:
               _loc2_ = "assets.hallIcon.lightRoadIcon";
               break;
            case HallIconType.SEVENDAYTARGET:
               _loc2_ = "assets.hallIcon.sevenDayTargetIcon";
               break;
            case HallIconType.GODSROADS:
               _loc2_ = "assets.hallIcon.godsRoadsIcon";
               break;
            case HallIconType.ENTERTAINMENT:
               _loc2_ = "assets.hallIcon.entertainmentIcon";
               break;
            case HallIconType.SEVENDAY:
               _loc2_ = "assets.hallIcon.sevendayIcon";
               break;
            case HallIconType.SALESHOP:
               _loc2_ = "assets.hallIcon.saleShopIcon";
               break;
            case HallIconType.KINGDIVISION:
               _loc2_ = "assets.hallIcon.kingDivisionIcon";
               break;
            case HallIconType.CHICKACTIVATION:
               _loc2_ = "assets.hallIcon.chickActivationIcon";
               break;
            case HallIconType.DDPLAY:
               _loc2_ = "assets.hallIcon.DDPlayIcon";
               break;
            case HallIconType.BOGUADVENTURE:
               _loc2_ = "assets.hallIcon.boguAdventureIcon";
               break;
            case HallIconType.WITCHBLESSING:
               _loc2_ = "assets.hallIcon.witchBlessingIcon";
               break;
            case HallIconType.TREASUREPUZZLE:
               _loc2_ = "assets.hallIcon.treasurePuzzleIcon";
               break;
            case HallIconType.HALLOWEEN:
               _loc2_ = "assets.hallIcon.halloweenIcon";
               break;
            case HallIconType.WORSHIPTHEMOON:
               _loc2_ = "assets.hallIcon.worshipTheMoon";
               break;
            case HallIconType.RESCUE:
               _loc2_ = "assets.hallIcon.rescue";
               break;
            case HallIconType.CATCHINSECT:
               _loc2_ = "assets.hallIcon.catchInsect";
               break;
            case HallIconType.MAGPIEBRIDGE:
               _loc2_ = "assets.hallIcon.magpiebridge";
               break;
            case HallIconType.CLOUDBUYLOTTERY:
               _loc2_ = "assets.hallIcon.cloudbuylotteryIcon";
               break;
            case HallIconType.TREASURELOST:
               _loc2_ = "assets.hallIcon.treasureLostIcon";
               break;
            case HallIconType.NEWYEARRICE:
               _loc2_ = "assets.hallIcon.newYearRiceIcon";
               break;
            case HallIconType.ZODIAC:
               _loc2_ = "assets.hallIcon.zodiacIcon";
               break;
            case HallIconType.PRAY_INDIANA:
               _loc2_ = "assets.hallIcon.prayIndianaIcon";
               break;
            case "happyRecharge":
               _loc2_ = "assets.hallIcon.happyRecharge";
               break;
            case "lotteryTicket":
               _loc2_ = "assets.hallIcon.lotteryTicketIcon";
               break;
            case "conRecharge":
               _loc2_ = "assets.hallIcon.conRechargeIcon";
               break;
            case "condiscount":
               _loc2_ = "assets.hallIcon.condiscountIcon";
               break;
            case "bombTurnTable":
               _loc2_ = "assets.hallIcon.bombTurnTable.icon";
               break;
            case "angelInvestment":
               _loc2_ = "assets.hallIcon.angelInvestmentIcon";
               break;
            case "signActivity":
               _loc2_ = "assets.hallIcon.signActivity";
               break;
            case "godOfWealth":
               _loc2_ = "assets.hallIcon.godOfWealthIcon";
               break;
            case "gypsyShop":
               _loc2_ = "assets.hallIcon.qatarWorldCup";
               break;
            case "hotSpring":
               _loc2_ = "assets.hallIcon.hotSpring";
               break;
            case HallIconType.LITTLEGAMENOTE:
               _loc2_ = "assets.hallIcon.littleGameNoteIcon";
               break;
            case "goldmine":
               _loc2_ = "assets.hallIcon.goldmineIcon";
               break;
            case "firstrecharge":
               _loc2_ = "asset.ddthall.firstrecharge";
               break;
            case "cryptBoss":
               _loc2_ = "asset.ddthall.cryptBoss";
               break;
            case "defend_island":
               _loc2_ = "assets.hallIcon.defendDDTIslandIcon";
               break;
            case "buried":
               _loc2_ = "assets.hallIcon.buriedIcon";
               break;
            case "petIsland":
               _loc2_ = "assets.hallIcon.petIsland";
               break;
            case "sanxiao":
               _loc2_ = "assets.hallIconl.sanxiaoBtn";
               break;
            case "memoryGame":
               _loc2_ = "assets.hallIcon.MemoryGameIcon";
               break;
            case HallIconType.HORSERACE:
               _loc2_ = "assets.hallIcon.horseRace";
               break;
            case "moneyTree":
               _loc2_ = "assets.hallIcon.moneyTree";
               break;
            case "welfareCenter":
               _loc2_ = "asset.hallIcon.welfareCenterIcon";
               break;
            case "farm":
               _loc2_ = "asset.hall.farmIcon";
               break;
            case HallIconType.BATTLEPASS:
               _loc2_ = "asset.hallIcon.welfareCenterIcon";
               break;
            case HallIconType.LEVELFUND:
               _loc2_ = "asset.ddthall.fund";
               break;
            case HallIconType.PANICBUGING:
               _loc2_ = "assets.hallIcon.panicBuyingIcon";
               break;
            case "bravedoor":
               _loc2_ = "assets.hallIcon.braveDoor.icon";
               break;
            case "FoodActivity":
               _loc2_ = "asset.hallIcon.FoodActivity";
               break;
            case HallIconType.DDT_KINGWAY:
               _loc2_ = "assets.hallIcon.ddtKingWayIcon";
               break;
            case HallIconType.INDIANA:
               _loc2_ = "assets.hallIcon.indianaIcon";
         }
         return new HallIcon(_loc2_,param1);
      }
      
      public function getIconByType(param1:int, param2:String) : DisplayObject
      {
         if(param1 == HallIcon.ACTIVITY && Boolean(this._activity))
         {
            return this._activity.getIconByType(param2);
         }
         return null;
      }
      
      private function topIndex() : void
      {
         if(Boolean(this.parent) && this.parent.numChildren > 1)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      private function checkNoneActivity(param1:int) : void
      {
         if(param1 <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.calendar.NoneActivity"));
         }
      }
      
      private function removeEvent() : void
      {
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_RIGHTICON_VIEW,this.__updateIconViewHandler);
         HallIconManager.instance.model.removeEventListener(HallIconEvent.UPDATE_BATCH_RIGHTICON_VIEW,this.__updateBatchIconViewHandler);
      }
      
      private function removeActivityIcon() : void
      {
         if(Boolean(this._activity))
         {
            this._activity.removeEventListener(MouseEvent.CLICK,this.__activityClickHandler);
            ObjectUtils.disposeObject(this._activity);
            this._activity = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeWonderfulPlayIcon();
         this.removeActivityIcon();
         if(Boolean(this._iconBox))
         {
            ObjectUtils.disposeAllChildren(this._iconBox);
            ObjectUtils.disposeObject(this._iconBox);
            this._iconBox = null;
         }
         if(Boolean(this._iconTopBox))
         {
            ObjectUtils.disposeAllChildren(this._iconTopBox);
            ObjectUtils.disposeObject(this._iconTopBox);
            this._iconTopBox = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      private function updateLoginToalIcon() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.accumulativeLoginDays > 7 ? int(7) : int(PlayerManager.Instance.Self.accumulativeLoginDays);
         var _loc2_:int = PlayerManager.Instance.Self.accumulativeAwardDays;
         if(_loc2_ < 7)
         {
            if(this._loginToal == null)
            {
               this._loginToal = ClassUtils.CreatInstance("assets.hallIcon.loginToalIconIcon");
               this._loginToal.addEventListener(MouseEvent.CLICK,this.__loginToalIconClickHandler);
               this._loginToal.buttonMode = true;
               this._loginToal.mouseChildren = false;
               this.addChildBox(this._loginToal);
            }
         }
      }
      
      private function removeLoginToalIcon() : void
      {
         if(Boolean(this._loginToal))
         {
            this._loginToal.stop();
            this._loginToal.removeEventListener(MouseEvent.CLICK,this.__loginToalIconClickHandler);
            ObjectUtils.disposeObject(this._loginToal);
            this._loginToal = null;
         }
      }
      
      private function __loginToalIconClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AccumulativeManager.instance.showFrame();
      }
      
      private function updateRoleRechargeIcon() : void
      {
         if(PlayerManager.Instance.Self.Grade >= 1 && RoleRechargeMgr.instance.isOpen)
         {
            if(this._roleRechargeIcon == null)
            {
               this._roleRechargeIcon = new HallIconPanel("asset.ddthall.roleRechargeIcon",HallIconPanel.LEFT,6);
               this._roleRechargeIcon.addEventListener("click",this.__roleRechargeClickHandler);
               this._roleRechargeIcon.buttonMode = true;
               this._roleRechargeIcon.mouseChildren = false;
               this.addChildTopBox(this._roleRechargeIcon);
            }
         }
         else
         {
            this.removeRoleRechargeIcon();
         }
      }
      
      private function __roleRechargeClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         RoleRechargeMgr.instance.show();
      }
      
      private function removeRoleRechargeIcon() : void
      {
         if(Boolean(this._roleRechargeIcon))
         {
            this._roleRechargeIcon.removeEventListener("click",this.__roleRechargeClickHandler);
            ObjectUtils.disposeObject(this._roleRechargeIcon);
            this._roleRechargeIcon = null;
         }
      }
      
      private function __wonderFulPlayClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(Boolean(this._wonderFulPlay) && param1.target == this._wonderFulPlay.mainIcon)
         {
            this.topIndex();
            this.checkNoneActivity(this._wonderFulPlay.count);
            return;
         }
         if(getTimer() - this._lastCreatTime < 1000)
         {
            return;
         }
         this._lastCreatTime = getTimer();
         if(param1.target is HallIcon)
         {
            _loc2_ = param1.target as HallIcon;
            if(_loc2_.iconInfo.halltype == 1)
            {
               switch(_loc2_.iconInfo.icontype)
               {
                  case HallIconType.LEAGUE:
                     StateManager.setState(StateType.ROOM_LIST);
                     break;
                  case "gypsyShop":
                     if(GypsyNPCModel.getInstance().isStart())
                     {
                        GypsyShopManager.getInstance().showMainFrame();
                     }
                     else
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("gypsy.upOpen"));
                     }
                     break;
                  case "hotSpring":
                     StateManager.setState(StateType.HOT_SPRING_ROOM_LIST);
                     break;
                  case HallIconType.LITTLEGAMENOTE:
                     StateManager.setState(StateType.LITTLEHALL);
                     break;
                  case "cryptBoss":
                     if(PlayerManager.Instance.Self.Grade < ServerConfigManager.instance.CryptBossNeedLevel())
                     {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",ServerConfigManager.instance.CryptBossNeedLevel()));
                        return;
                     }
                     CryptBossManager.instance.show();
                     break;
                  case "defend_island":
                     SoundManager.instance.play("008");
                     SocketManager.Instance.out.defendislandInfo(1);
                     break;
                  case "buried":
                     SoundManager.instance.play("003");
                     SocketManager.Instance.out.clickAnotherDimensionEnter();
                     break;
                  case "moneyTree":
                     SoundManager.instance.play("008");
                     MoneyTreeManager.getInstance().show();
                     break;
                  case HallIconType.DDT_KINGWAY:
                     SoundManager.instance.play("008");
                     DDTKingWayManager.instance.show();
               }
            }
         }
      }
      
      private function updateWonderfulPlayIcon() : void
      {
         if(HallIconManager.instance.model.wonderFulPlayIsOpen)
         {
            if(this._wonderFulPlay == null)
            {
               this._wonderFulPlay = new HallIconPanel("assets.hallIcon.wonderfulPlayIcon",HallIconPanel.LEFT,6);
               this._wonderFulPlay.addEventListener("click",this.__wonderFulPlayClickHandler);
               this._wonderFulPlay.x = -64;
               this._wonderFulPlay.y = 72;
               addChild(this._wonderFulPlay);
            }
         }
         else
         {
            this.removeWonderfulPlayIcon();
         }
      }
      
      private function removeWonderfulPlayIcon() : void
      {
         if(Boolean(this._wonderFulPlay))
         {
            this._wonderFulPlay.removeEventListener("click",this.__wonderFulPlayClickHandler);
            ObjectUtils.disposeObject(this._wonderFulPlay);
            this._wonderFulPlay = null;
         }
      }
      
      private function updateRankIcon() : void
      {
         if(WonderfulActivityManager.Instance.rankFlag)
         {
            if(this._rankIcon == null)
            {
               this._rankIcon = ClassUtils.CreatInstance("assets.hallIcon.rankIcon");
               this._rankIcon.addEventListener("click",this.__rankIconClickHandler);
               this._rankIcon.buttonMode = true;
               this._rankIcon.mouseChildren = false;
               this.addChildTopBox(this._rankIcon);
            }
         }
         else
         {
            this.removeRankIcon();
         }
      }
      
      private function removeRankIcon() : void
      {
         if(Boolean(this._rankIcon))
         {
            this._rankIcon.stop();
            this._rankIcon.removeEventListener("click",this.__rankIconClickHandler);
            ObjectUtils.disposeObject(this._rankIcon);
            this._rankIcon = null;
         }
      }
      
      private function __rankIconClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         RankManager.instance.show();
      }
   }
}

