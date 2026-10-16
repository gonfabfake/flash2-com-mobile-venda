package battlePass.view
{
   import battlePass.BattlePassManager;
   import battlePass.data.QuestBattlePassInfo;
   import battlePass.data.QuestBattlePassItemInfo;
   import battlePass.data.QuestBattlePassRewardInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.PlayerPortraitView;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import regularEventSystem.RegularEventItemCell;
   
   public class BattlePassView extends Frame
   {
      
      private var _frontHolder:Bitmap;
      
      private var _bg:Bitmap;
      
      private var _scoreIconBg:Bitmap;
      
      private var _tracks:Bitmap;
      
      private var _profileCardBg:Bitmap;
      
      private var _payOkeyImg:Bitmap;
      
      private var _pointBg:Bitmap;
      
      private var _pageBg:Bitmap;
      
      private var _progress:Bitmap;
      
      private var _slotContainerBg:Bitmap;
      
      private var _slotOkContainerBg:Bitmap;
      
      private var _seasonNum:int = 1;
      
      private var blendTimer:Timer = new Timer(100);
      
      private var _selfPortrait:PlayerPortraitView;
      
      private var _pointTxt:FilterFrameText;
      
      private var _reqpointTxt:FilterFrameText;
      
      private var _charNameTxt:FilterFrameText;
      
      private var _itemCntTxt:FilterFrameText;
      
      private var _nextPageBtn:BaseButton;
      
      private var _prevPageBtn:BaseButton;
      
      private var _quNextPageBtn:SimpleBitmapButton;
      
      private var _quPrevPageBtn:SimpleBitmapButton;
      
      private var _payBtn:SimpleBitmapButton;
      
      private var _shopBtn:SimpleBitmapButton;
      
      private var _tabQuestBtn:SimpleBitmapButton;
      
      public var _point:int = 0;
      
      private var _slotStartPosX:int = 33;
      
      private var _slotItemCellStartPosY:int = 180;
      
      private var _slotquCellStartPosY:int = 75;
      
      public var battlePassMoney:int = 10000;
      
      public var battleRemainTime:int = 0;
      
      public var isPayBattlePass:Boolean = false;
      
      public var RequiredPoints:String = "100|200|300|400|500|600|700";
      
      private var RequiredPointsArr:Array;
      
      private var GroupItemsCntArr:Array;
      
      private var SingleItemsArr:Array;
      
      private var SingleItemsCntArr:Array;
      
      private var ItemNum:int = 0;
      
      private var quItemNum:int = 0;
      
      private var pageBtnNum:int = 1;
      
      private var slotItemCell:RegularEventItemCell = null;
      
      private var slotDataArr:Array = [];
      
      private var slotQuestDataArr:Array = [];
      
      private var questsTypeIconArr:Array = [];
      
      private var questsDescArr:Array = [];
      
      private var cached_questsDescArr:Array = [];
      
      private var questsTitleArr:Array = [];
      
      private var totalRequiredPoint:int = 0;
      
      private var _qupageNumTxt:FilterFrameText;
      
      private var quPageNum:int = 0;
      
      private var _qufiltCheckBoxBtn1:SelectedCheckButton;
      
      private var _qufiltCheckBoxBtn2:SelectedCheckButton;
      
      private var _qufiltCheckBoxBtn3:SelectedCheckButton;
      
      private var _qufiltCheckBoxBtn4:SelectedCheckButton;
      
      private var selectedquType:int = 0;
      
      private var _questHolder:Bitmap;
      
      private var QuestsArr:Array;
      
      private var _questsArr:Array;
      
      private var singleQuestsArr:QuestBattlePassInfo;
      
      private var _quTitleTxt:FilterFrameText;
      
      private var _quDescTxt:FilterFrameText;
      
      private var _quObjectTxt:FilterFrameText;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _quPointTxt:FilterFrameText;
      
      private var _remainResetTime:FilterFrameText;
      
      private var _quTypeIcon:ScaleFrameImage;
      
      private var quTitleArr:Array;
      
      private var quDescArr:Array;
      
      private var _cache_questDescTxt:String;
      
      private var months:Array = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"];
      
      private var _questMaxPage:int = 0;
      
      public function BattlePassView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._frontHolder = ComponentFactory.Instance.creatBitmap("bombia_battlepass_frontend");
         this._bg = ComponentFactory.Instance.creatBitmap("battlepass.BG");
         this._scoreIconBg = ComponentFactory.Instance.creatBitmap("battlepass.highTicket");
         this._profileCardBg = ComponentFactory.Instance.creatBitmap("bombia_battlepass_profilecard");
         this._payOkeyImg = ComponentFactory.Instance.creatBitmap("pay_okey_img");
         this._progress = ComponentFactory.Instance.creatBitmap("bombia_battlepass_progress");
         this._selfPortrait = ComponentFactory.Instance.creatCustomObject("chatFrame.selfPortrait",["right"]);
         this._pointTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
         this._charNameTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.rightBtn");
         this._prevPageBtn = ComponentFactory.Instance.creatComponentByStylename("GodSyah.syahView.leftBtn");
         this._payBtn = ComponentFactory.Instance.creatComponentByStylename("battlePass.payBtn");
         this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("battlePass.shopBtn");
         this._tabQuestBtn = ComponentFactory.Instance.creatComponentByStylename("battlePass.tabQuestBtn");
         this._selfPortrait.info = PlayerManager.Instance.Self;
         this._pageBg = ComponentFactory.Instance.creatBitmap("battlepass.pageBg");
         this._quNextPageBtn = ComponentFactory.Instance.creatComponentByStylename("battlePass.questPage.nextBtn");
         this._quPrevPageBtn = ComponentFactory.Instance.creatComponentByStylename("battlePass.questPage.preBtn");
         this._qupageNumTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
         this._qufiltCheckBoxBtn1 = ComponentFactory.Instance.creatComponentByStylename("battlePass.filterquCheckButton");
         this._qufiltCheckBoxBtn1.text = LanguageMgr.GetTranslation("battlepass.view.quest.simple");
         this._qufiltCheckBoxBtn2 = ComponentFactory.Instance.creatComponentByStylename("battlePass.filterquCheckButton");
         this._qufiltCheckBoxBtn2.text = LanguageMgr.GetTranslation("battlepass.view.quest.normal");
         this._qufiltCheckBoxBtn3 = ComponentFactory.Instance.creatComponentByStylename("battlePass.filterquCheckButton");
         this._qufiltCheckBoxBtn3.text = LanguageMgr.GetTranslation("battlepass.view.quest.hard");
         this._qufiltCheckBoxBtn4 = ComponentFactory.Instance.creatComponentByStylename("battlePass.filterquCheckButton");
         this._qufiltCheckBoxBtn4.text = LanguageMgr.GetTranslation("battlepass.view.quest.god");
         this._pageBg.width = 61;
         this._pageBg.x = 675;
         this._pageBg.y = -46;
         this._quNextPageBtn.x = 736;
         this._quNextPageBtn.y = -48;
         this._quPrevPageBtn.y = -48;
         this._quPrevPageBtn.x = 652;
         this._quPrevPageBtn.enable = false;
         this._qufiltCheckBoxBtn1.x = -76;
         this._qufiltCheckBoxBtn2.x = -76;
         this._qufiltCheckBoxBtn3.x = 24;
         this._qufiltCheckBoxBtn4.x = 24;
         this._qufiltCheckBoxBtn1.y = 366;
         this._qufiltCheckBoxBtn2.y = 392;
         this._qufiltCheckBoxBtn3.y = 366;
         this._qufiltCheckBoxBtn4.y = 392;
         this._prevPageBtn.x = -110;
         this._prevPageBtn.y = 164;
         this._nextPageBtn.x = 470;
         this._nextPageBtn.y = 164;
         this._selfPortrait.x = -83;
         this._selfPortrait.y = -23;
         this._selfPortrait.width = 73;
         this._selfPortrait.height = 68;
         this._progress.x = -85;
         this._progress.y = 344;
         this._pointTxt.x = 10;
         this._pointTxt.y = 24;
         this._charNameTxt.x = this._profileCardBg.x + 81;
         this._charNameTxt.y = this._profileCardBg.y + 56 - 45;
         this._payBtn.x = 386;
         this._payBtn.y = 13;
         this._shopBtn.x = 314;
         this._shopBtn.y = 366;
         this._tabQuestBtn.x = 500;
         this._tabQuestBtn.y = -50;
         this._payOkeyImg.x = 455;
         this._payOkeyImg.y = 60;
         this._payOkeyImg.visible = false;
         this._scoreIconBg.x = -17;
         this._scoreIconBg.y = 21;
         this._scoreIconBg.width = 25;
         this._scoreIconBg.height = 25;
         this._remainResetTime = new FilterFrameText();
         this._remainResetTime.htmlText = "<font SIZE=\'12\' COLOR=\'#54301c\'>" + LanguageMgr.GetTranslation("battlepass.view.desc.reset",this.battleRemainTime) + "</font>";
         this._remainResetTime.width = 350;
         this._remainResetTime.height = 150;
         this._remainResetTime.x = 310;
         this._remainResetTime.y = -36;
         addToContent(this._bg);
         addToContent(this._frontHolder);
         addToContent(this._profileCardBg);
         addToContent(this._progress);
         addToContent(this._selfPortrait);
         addToContent(this._pointTxt);
         addToContent(this._charNameTxt);
         addToContent(this._nextPageBtn);
         addToContent(this._prevPageBtn);
         addToContent(this._payBtn);
         addToContent(this._shopBtn);
         addToContent(this._scoreIconBg);
         addToContent(this._tabQuestBtn);
         addToContent(this._payOkeyImg);
         addToContent(this._pageBg);
         addToContent(this._quNextPageBtn);
         addToContent(this._quPrevPageBtn);
         addToContent(this._qupageNumTxt);
         addToContent(this._qufiltCheckBoxBtn1);
         addToContent(this._qufiltCheckBoxBtn2);
         addToContent(this._qufiltCheckBoxBtn3);
         addToContent(this._qufiltCheckBoxBtn4);
         addToContent(this._remainResetTime);
         this.RequiredPointsArr = this.RequiredPoints.split("|");
         var _loc1_:int = 0;
         while(_loc1_ < this.RequiredPointsArr.length)
         {
            if(int(this.RequiredPointsArr[_loc1_]) > this.totalRequiredPoint)
            {
               this.totalRequiredPoint = int(this.RequiredPointsArr[_loc1_]);
            }
            _loc1_++;
         }
         if(this._progress.width < 527)
         {
            this._progress.width = Math.floor(int(745 / this.totalRequiredPoint * this._point) / 1.3);
         }
         this._pointTxt.htmlText = String(this._point);
         if(PlayerManager.Instance.Self.IsVIP)
         {
            this._charNameTxt.htmlText = PlayerManager.Instance.Self.NickName;
         }
         else
         {
            this._charNameTxt.htmlText = PlayerManager.Instance.Self.NickName;
         }
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BATTLE_PASS_GET_INFO,BattlePassManager.instance.__battlePassHandler);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         addEventListener(MouseEvent.MOUSE_WHEEL,this._wheelUpdatePage);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__nextPageBtnClick);
         this._prevPageBtn.addEventListener(MouseEvent.CLICK,this.__prevPageBtnClick);
         this._payBtn.addEventListener(MouseEvent.CLICK,this.__payButtonClick);
         this._shopBtn.addEventListener(MouseEvent.CLICK,this._shopButtonClick);
         this._quNextPageBtn.addEventListener(MouseEvent.CLICK,this.__nextQuestPageBtnClick);
         this._quPrevPageBtn.addEventListener(MouseEvent.CLICK,this.__prevQuestPageBtnClick);
         this._qufiltCheckBoxBtn1.addEventListener(MouseEvent.CLICK,this.__changequType1);
         this._qufiltCheckBoxBtn2.addEventListener(MouseEvent.CLICK,this.__changequType2);
         this._qufiltCheckBoxBtn3.addEventListener(MouseEvent.CLICK,this.__changequType3);
         this._qufiltCheckBoxBtn4.addEventListener(MouseEvent.CLICK,this.__changequType4);
      }
      
      public function SetSeasonNum(param1:int) : void
      {
         var _loc2_:Date = new Date();
         this._seasonNum = param1;
         titleText = LanguageMgr.GetTranslation("battlepass.view.title",this.months[_loc2_.getMonth()],param1.toString());
      }
      
      public function UpdateRemainTime(param1:int) : void
      {
         this._remainResetTime.htmlText = "<font SIZE=\'12\' COLOR=\'#ed9b4a\'>" + LanguageMgr.GetTranslation("battlepass.view.desc.reset",param1) + "</font>";
      }
      
      private function __changequType1(param1:int) : void
      {
         this._qufiltCheckBoxBtn3.selected = false;
         this._qufiltCheckBoxBtn2.selected = false;
         this._qufiltCheckBoxBtn4.selected = false;
         this.selectedquType = 1;
         if(this._qufiltCheckBoxBtn1.selected == false)
         {
            this.selectedquType = 0;
         }
         this._buildQuests(this.selectedquType,0);
      }
      
      private function __changequType2(param1:int) : void
      {
         this._qufiltCheckBoxBtn1.selected = false;
         this._qufiltCheckBoxBtn3.selected = false;
         this._qufiltCheckBoxBtn4.selected = false;
         this.selectedquType = 2;
         if(this._qufiltCheckBoxBtn2.selected == false)
         {
            this.selectedquType = 0;
         }
         this._buildQuests(this.selectedquType,0);
      }
      
      private function __changequType3(param1:int) : void
      {
         this._qufiltCheckBoxBtn1.selected = false;
         this._qufiltCheckBoxBtn2.selected = false;
         this._qufiltCheckBoxBtn4.selected = false;
         this.selectedquType = 3;
         if(this._qufiltCheckBoxBtn3.selected == false)
         {
            this.selectedquType = 0;
         }
         this._buildQuests(this.selectedquType,0);
      }
      
      private function __changequType4(param1:int) : void
      {
         this._qufiltCheckBoxBtn1.selected = false;
         this._qufiltCheckBoxBtn2.selected = false;
         this._qufiltCheckBoxBtn3.selected = false;
         this.selectedquType = 4;
         if(this._qufiltCheckBoxBtn4.selected == false)
         {
            this.selectedquType = 0;
         }
         this._buildQuests(this.selectedquType,0);
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function _colorBlending() : void
      {
         while(true)
         {
            this._progress.transform.colorTransform = new ColorTransform(255,255,144,1);
            this._progress.transform.colorTransform = new ColorTransform(230,255,255,1);
            this._progress.transform.colorTransform = new ColorTransform(255,230,124,1);
            this._progress.transform.colorTransform = new ColorTransform(155,255,255,1);
         }
      }
      
      public function _buildSlots(param1:int) : void
      {
         var pageCount:int = 0;
         var loadedRewardInfoCount:int = 0;
         var showItems:Dictionary = null;
         var PageNum:int = param1;
         var item:* = undefined;
         var battleRewardDataInfo:QuestBattlePassRewardInfo = null;
         var itemsToShow:Array = null;
         var battleRewardDataToRayInfo:QuestBattlePassRewardInfo = null;
         var loadedIndex:int = 0;
         var battleRewardInfo:QuestBattlePassRewardInfo = null;
         var items:Vector.<QuestBattlePassItemInfo> = null;
         var rewardItem:QuestBattlePassItemInfo = null;
         var itemIndex:int = 0;
         var slotItemData:ItemTemplateInfo = null;
         this._payBtn.visible = !this.isPayBattlePass;
         this._shopBtn.visible = true;
         this._payOkeyImg.visible = this.isPayBattlePass;
         this._slotStartPosX = -80;
         this._slotItemCellStartPosY = 120;
         this.RequiredPointsArr = this.RequiredPoints.split("|");
         if(this._progress.width < 575)
         {
            this._progress.width = Math.floor(int(745 / this.totalRequiredPoint * this._point) / 1.3);
         }
         pageCount = 0;
         for each(item in BattlePassManager.instance.battlePassQuestItems)
         {
            pageCount++;
         }
         if(PageNum > Math.floor(pageCount / 3.5))
         {
            --this.pageBtnNum;
            return;
         }
         if(PageNum > 1)
         {
            PageNum--;
            this.ItemNum = 5 * PageNum;
         }
         else
         {
            this.ItemNum = 0;
         }
         this.clearSlotData();
         loadedRewardInfoCount = 0;
         showItems = new Dictionary();
         for each(battleRewardDataInfo in BattlePassManager.instance.battlePassQuestItems)
         {
            if(this.ItemNum != 0)
            {
               if(battleRewardDataInfo.ID < this.ItemNum)
               {
                  continue;
               }
            }
            if(battleRewardDataInfo.ID <= this.ItemNum + 5)
            {
               showItems[battleRewardDataInfo.Score] = battleRewardDataInfo;
               loadedRewardInfoCount++;
            }
         }
         itemsToShow = [];
         for each(battleRewardDataToRayInfo in showItems)
         {
            itemsToShow.push(battleRewardDataToRayInfo);
         }
         itemsToShow.sort(function(param1:QuestBattlePassRewardInfo, param2:QuestBattlePassRewardInfo):Number
         {
            if(param1.ID < param2.ID)
            {
               return -1;
            }
            if(param1.ID > param2.ID)
            {
               return 1;
            }
            return 0;
         });
         loadedIndex = 0;
         while(loadedIndex < itemsToShow.length)
         {
            if(loadedIndex >= 5)
            {
               break;
            }
            battleRewardInfo = itemsToShow[loadedIndex];
            if(battleRewardInfo != null)
            {
               items = battleRewardInfo.Items;
               this._slotContainerBg = ComponentFactory.Instance.creatBitmap("bombia_battlepass_prizebar");
               addToContent(this._slotContainerBg);
               this.slotDataArr.push(this._slotContainerBg);
               this._slotContainerBg.x = this._slotStartPosX;
               this._slotItemCellStartPosY = 120;
               if(items == null)
               {
                  this._slotContainerBg.visible = false;
                  break;
               }
               this._reqpointTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
               addToContent(this._reqpointTxt);
               this._reqpointTxt.htmlText = "<font SIZE=\'18\' COLOR=\'#ffae00\'><b>" + battleRewardInfo.Score + "</b></font>";
               this.slotDataArr.push(this._reqpointTxt);
               for each(rewardItem in items)
               {
                  slotItemData = ItemManager.Instance.getTemplateById(rewardItem.ItemID);
                  if(slotItemData != null)
                  {
                     this._itemCntTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
                     this._itemCntTxt.htmlText = String(rewardItem.ItemCount);
                     this.slotItemCell = new RegularEventItemCell(0,slotItemData,true,"asset.core.regularEventItemCellBgAsset");
                     addToContent(this.slotItemCell);
                     this.slotDataArr.push(this.slotItemCell);
                     if(loadedIndex <= 0)
                     {
                        this.slotItemCell.x = this._slotStartPosX + 16;
                     }
                     else
                     {
                        this.slotItemCell.x = this._slotStartPosX + 16;
                     }
                     this.slotItemCell.y = this._slotItemCellStartPosY;
                     if(rewardItem.ItemCount > 1)
                     {
                        addToContent(this._itemCntTxt);
                        if(int(rewardItem.ItemCount) > 9 && int(rewardItem.ItemCount) < 100)
                        {
                           this._itemCntTxt.x = this.slotItemCell.x + 29;
                        }
                        else if(int(rewardItem.ItemCount) > 99 && int(rewardItem.ItemCount) < 1000)
                        {
                           this._itemCntTxt.x = this.slotItemCell.x + 14;
                        }
                        else
                        {
                           this._itemCntTxt.x = this.slotItemCell.x + 30;
                        }
                        this._itemCntTxt.y = this.slotItemCell.y + 30;
                        this.slotDataArr.push(this._itemCntTxt);
                     }
                     this._slotItemCellStartPosY += 55;
                  }
               }
               this._reqpointTxt.x = this._slotContainerBg.x + 25;
               this._slotStartPosX += 115;
               this._slotContainerBg.y = 84;
               if(this._point >= this.RequiredPointsArr[this.ItemNum + loadedIndex])
               {
                  this._slotOkContainerBg = ComponentFactory.Instance.creatBitmap("bombia_battlepass_prizebardone");
                  addToContent(this._slotOkContainerBg);
                  this._slotOkContainerBg.x = this._slotContainerBg.x;
                  this._slotOkContainerBg.y = this._slotContainerBg.y;
                  this.slotDataArr.push(this._slotOkContainerBg);
               }
               this._reqpointTxt.y = this._slotContainerBg.y + 4;
            }
            loadedIndex++;
         }
         this._buildQuests(this.selectedquType,this.quPageNum);
      }
      
      private function clearSlotData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.slotDataArr.length)
         {
            removeFromContent(this.slotDataArr[_loc1_]);
            _loc1_++;
         }
         this.slotDataArr.length = 0;
      }
      
      private function clearQuestSlotData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.slotQuestDataArr.length)
         {
            removeFromContent(this.slotQuestDataArr[_loc1_]);
            _loc1_++;
         }
         this.slotQuestDataArr.length = 0;
      }
      
      private function clearQuestDescData() : void
      {
         this.questsTypeIconArr.length = 0;
         this.questsDescArr.length = 0;
      }
      
      private function createFilterFrameText(param1:String) : FilterFrameText
      {
         var _loc2_:FilterFrameText = new FilterFrameText();
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
         _loc2_.htmlText = "<font SIZE=\'10\' COLOR=\'#f79c5c\'> " + param1 + "</font>";
         _loc2_.width = 450;
         return _loc2_;
      }
      
      public function _buildQuests(param1:int, param2:int) : void
      {
         var cached_questsDescArr:* = undefined;
         var target_questDescTxt_0:FilterFrameText = null;
         var target_questDescTxt_1:FilterFrameText = null;
         var target_questDescTxt_2:FilterFrameText = null;
         var target_questDescTxt_3:FilterFrameText = null;
         var target_questDescTxt_4:FilterFrameText = null;
         var quType:int = param1;
         var pageNum:int = param2;
         var maxPageNum:int = 0;
         var questNum:int = 0;
         var infoText:FilterFrameText = null;
         var infoText3:FilterFrameText = null;
         var infoText2:FilterFrameText = null;
         cached_questsDescArr = undefined;
         target_questDescTxt_0 = null;
         target_questDescTxt_1 = null;
         target_questDescTxt_2 = null;
         target_questDescTxt_3 = null;
         target_questDescTxt_4 = null;
         var item:QuestBattlePassInfo = null;
         var i:int = 0;
         var _questHolder:Bitmap = null;
         var _questTitleTxt:FilterFrameText = null;
         var questCurrentValue:* = undefined;
         var questMaxValue:* = undefined;
         var questTitle:* = undefined;
         var _questDescTxt:FilterFrameText = null;
         var _questTypeIcon:ScaleFrameImage = null;
         var target_questTypeIcon:ScaleFrameImage = null;
         var target_questTitleTxt:FilterFrameText = null;
         var dictionaryLength:int = 0;
         var dictionaryQuestShow:Dictionary = new Dictionary();
         for each(item in BattlePassManager.instance.battlePassQuestList)
         {
            if(!(item.Type != quType && quType != 0))
            {
               dictionaryQuestShow[dictionaryLength] = item;
               dictionaryLength++;
            }
         }
         maxPageNum = Math.ceil(dictionaryLength / 5);
         this._questMaxPage = maxPageNum;
         questNum = 0;
         if(pageNum >= maxPageNum)
         {
            --this.quPageNum;
            return;
         }
         this._slotquCellStartPosY = -5;
         this.clearQuestSlotData();
         this.clearQuestDescData();
         this._qupageNumTxt.htmlText = "<font SIZE=\'12\' COLOR=\'#FEC045\'>" + (pageNum + 1) + "/" + maxPageNum + "</font>";
         this._qupageNumTxt.x = 693;
         this._qupageNumTxt.y = -42;
         infoText = this.createFilterFrameText(LanguageMgr.GetTranslation("battlepass.view.desc1"));
         infoText.x = 120;
         infoText.y = 30;
         infoText3 = this.createFilterFrameText(LanguageMgr.GetTranslation("battlepass.view.desc2"));
         infoText3.x = 120;
         infoText3.y = 9;
         infoText2 = this.createFilterFrameText(LanguageMgr.GetTranslation("battlepass.view.desc3"));
         infoText2.x = 510;
         infoText2.y = 392;
         infoText2.height = 32;
         addToContent(infoText);
         addToContent(infoText2);
         addToContent(infoText3);
         this.slotQuestDataArr.push(infoText);
         this.slotQuestDataArr.push(infoText2);
         this.slotQuestDataArr.push(infoText3);
         i = 0;
         while(i < 5)
         {
            if(pageNum > 0)
            {
               this.quItemNum = 5 * pageNum;
            }
            else
            {
               this.quItemNum = 0;
            }
            if(dictionaryQuestShow[this.quItemNum + i] == null)
            {
               return;
            }
            this.singleQuestsArr = dictionaryQuestShow[this.quItemNum + i];
            _questHolder = new Bitmap();
            _questHolder = ComponentFactory.Instance.creatBitmap("bombia_battlepass_questbarbg");
            _questHolder.name = "_questHolder" + i;
            _questHolder.y = this._slotquCellStartPosY;
            _questHolder.x = 504;
            _questHolder.width = 256;
            this.slotQuestDataArr.push(_questHolder);
            this._slotquCellStartPosY += 80;
            addToContent(_questHolder);
            _questTitleTxt = new FilterFrameText();
            _questTitleTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
            _questTitleTxt.width = _questHolder.width;
            questCurrentValue = 0;
            questMaxValue = this.singleQuestsArr.Objective;
            questTitle = "<font SIZE=\'14\' COLOR=\'#ffde8f\'><b>" + this.singleQuestsArr.Name + "</b></font> ";
            _questTitleTxt.htmlText = questTitle;
            _questTitleTxt.y = _questHolder.y + 12;
            _questTitleTxt.x = 521;
            _questTitleTxt.name = "_questTitleTxt_" + i;
            this.slotQuestDataArr.push(_questTitleTxt);
            this.questsTitleArr.push(_questTitleTxt);
            addToContent(_questTitleTxt);
            _questDescTxt = new FilterFrameText();
            _questDescTxt = ComponentFactory.Instance.creatComponentByStylename("academy.AcademyMemberItem.nameTxt");
            _questDescTxt.width = _questHolder.width - 75;
            _questDescTxt.height = Math.floor(_questHolder.height / 1.25);
            _questDescTxt.wordWrap = true;
            _questDescTxt.multiline = true;
            _questDescTxt.htmlText = "<font SIZE=\'12\'>" + this.singleQuestsArr.Description + "</font>";
            _questDescTxt.y = _questHolder.y + 28;
            _questDescTxt.x = 521;
            _questDescTxt.name = "_questDescTxt_" + i;
            this.slotQuestDataArr.push(_questDescTxt);
            this.questsDescArr.push(_questDescTxt);
            if(this._cache_questDescTxt != "" && i == 0)
            {
               this._cache_questDescTxt = "";
            }
            if(this._cache_questDescTxt != "")
            {
               this._cache_questDescTxt = this._cache_questDescTxt + "|" + this.singleQuestsArr.Description + "|" + this.singleQuestsArr.Objective + "|" + this.singleQuestsArr.Reward;
            }
            else
            {
               this._cache_questDescTxt = this.singleQuestsArr.Description + "|" + this.singleQuestsArr.Objective + "|" + this.singleQuestsArr.Reward;
            }
            addToContent(_questDescTxt);
            _questTypeIcon = new ScaleFrameImage();
            _questTypeIcon = ComponentFactory.Instance.creatComponentByStylename("battlePass.questTypeIcon");
            _questTypeIcon.width = 40;
            _questTypeIcon.height = 40;
            _questTypeIcon.x = _questHolder.x + _questHolder.width - 44;
            _questTypeIcon.y = _questHolder.y + 2;
            _questTypeIcon.setFrame(this.singleQuestsArr.Type);
            _questTypeIcon.name = "_questTypeIcon_" + i;
            this.slotQuestDataArr.push(_questTypeIcon);
            this.questsTypeIconArr.push(_questTypeIcon);
            addToContent(_questTypeIcon);
            target_questTypeIcon = new ScaleFrameImage();
            target_questTypeIcon = this.questsTypeIconArr[i];
            target_questTitleTxt = this.questsTitleArr[i] as FilterFrameText;
            cached_questsDescArr = this._cache_questDescTxt.split("|");
            if(i == 0)
            {
               target_questDescTxt_0 = this.questsDescArr[i] as FilterFrameText;
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
               {
                  target_questDescTxt_0.htmlText = "Objetivo: <b>(0/" + cached_questsDescArr[1] + ")</b>\nRecompensa: <b>" + cached_questsDescArr[2] + "</b>";
               });
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
               {
                  target_questDescTxt_0.htmlText = cached_questsDescArr[0];
               });
            }
            else if(i == 1)
            {
               target_questDescTxt_1 = this.questsDescArr[i] as FilterFrameText;
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
               {
                  target_questDescTxt_1.htmlText = "Objetivo: <b>(0/" + cached_questsDescArr[4] + ")</b>\nRecompensa: <b>" + cached_questsDescArr[5] + "</b>";
               });
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
               {
                  target_questDescTxt_1.htmlText = cached_questsDescArr[3];
               });
            }
            else if(i == 2)
            {
               target_questDescTxt_2 = this.questsDescArr[i] as FilterFrameText;
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
               {
                  target_questDescTxt_2.htmlText = "Objetivo: <b>(0/" + cached_questsDescArr[7] + ")</b>\nRecompensa: <b>" + cached_questsDescArr[8] + "</b>";
               });
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
               {
                  target_questDescTxt_2.htmlText = cached_questsDescArr[6];
               });
            }
            else if(i == 3)
            {
               target_questDescTxt_3 = this.questsDescArr[i] as FilterFrameText;
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
               {
                  target_questDescTxt_3.htmlText = "Objetivo: <b>(0/" + cached_questsDescArr[10] + ")</b>\nRecompensa: <b>" + cached_questsDescArr[11] + "</b>";
               });
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
               {
                  target_questDescTxt_3.htmlText = cached_questsDescArr[9];
               });
            }
            else if(i == 4)
            {
               target_questDescTxt_4 = this.questsDescArr[i] as FilterFrameText;
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
               {
                  target_questDescTxt_4.htmlText = "Objetivo: <b>(0/" + cached_questsDescArr[13] + ")</b>\nRecompensa: <b>" + cached_questsDescArr[14] + "</b>";
               });
               target_questTypeIcon.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
               {
                  target_questDescTxt_4.htmlText = cached_questsDescArr[12];
               });
            }
            i++;
         }
      }
      
      private function __nextQuestPageBtnClick(param1:MouseEvent) : void
      {
         this._quPrevPageBtn.enable = true;
         SoundManager.instance.play("008");
         ++this.quPageNum;
         if(this.quPageNum >= this._questMaxPage - 1)
         {
            this._quNextPageBtn.enable = false;
         }
         this._buildQuests(this.selectedquType,this.quPageNum);
      }
      
      private function __prevQuestPageBtnClick(param1:MouseEvent) : void
      {
         this._quNextPageBtn.enable = true;
         SoundManager.instance.play("008");
         if(this.quPageNum <= 0)
         {
            return;
         }
         --this.quPageNum;
         if(this.quPageNum <= 0)
         {
            this._quPrevPageBtn.enable = false;
         }
         this._buildQuests(this.selectedquType,this.quPageNum);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               BattlePassManager.instance.hide();
         }
      }
      
      private function _wheelUpdatePage(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.delta > 0)
         {
            SoundManager.instance.play("008");
            ++this.pageBtnNum;
            this._buildSlots(this.pageBtnNum);
         }
         else
         {
            if(this.pageBtnNum <= 1)
            {
               return;
            }
            SoundManager.instance.play("008");
            --this.pageBtnNum;
            this._buildSlots(this.pageBtnNum);
         }
      }
      
      private function _wheelUpdatequPage(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.delta > 0)
         {
            if(this.quPageNum < 1)
            {
               return;
            }
            SoundManager.instance.play("008");
            --this.quPageNum;
            this._buildQuests(0,this.quPageNum);
         }
         else
         {
            SoundManager.instance.play("008");
            ++this.quPageNum;
            this._buildQuests(0,this.quPageNum);
         }
      }
      
      private function __payButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:String = LanguageMgr.GetTranslation("ddt.battlpass.confirm",10000);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND,null,"SimpleAlert",30,true);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function _shopButtonClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         MessageTipManager.getInstance().show("Loja em construção, aguarde a próxima atualização.");
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.Money < 10000)
               {
                  MessageTipManager.getInstance().show("Cupons insuficientes, recarregue e tente novamente.");
                  return;
               }
               SocketManager.Instance.out.sendPayBattlePass();
         }
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         this._confirmFrame.dispose();
         if(Boolean(this._confirmFrame.parent))
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      private function __nextPageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ++this.pageBtnNum;
         this._buildSlots(this.pageBtnNum);
      }
      
      private function __prevPageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this.pageBtnNum <= 1)
         {
            return;
         }
         --this.pageBtnNum;
         this._buildSlots(this.pageBtnNum);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this._wheelUpdatePage);
         removeEventListener(CrazyTankSocketEvent.BATTLE_PASS_GET_INFO,BattlePassManager.instance.__battlePassHandler);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__nextPageBtnClick);
         this._prevPageBtn.removeEventListener(MouseEvent.CLICK,this.__prevPageBtnClick);
         this._payBtn.removeEventListener(MouseEvent.CLICK,this.__payButtonClick);
         this._shopBtn.removeEventListener(MouseEvent.CLICK,this._shopButtonClick);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._frontHolder))
         {
            this._frontHolder = null;
         }
         if(Boolean(this._profileCardBg))
         {
            this._profileCardBg = null;
         }
         if(Boolean(this._pointBg))
         {
            this._pointBg = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

