package zodiac
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   
   public class ZodiacMainView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _title:MovieClip;
      
      private var _details:FilterFrameText;
      
      private var _quest:FilterFrameText;
      
      private var _lastCount:FilterFrameText;
      
      private var _awards:Array;
      
      private var _boxBtnBitmap:Bitmap;
      
      private var _boxBtnBitmapDark:Bitmap;
      
      private var _boxMask:MovieClip;
      
      private var _boxAwardBtn:MovieClip;
      
      private var _boxComponent:Component;
      
      private var _addBtn:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _gotofinishBtn:SimpleBitmapButton;
      
      private var _getAwardBtn:SimpleBitmapButton;
      
      private var _helpframe:Frame;
      
      private var _bgHelp:Scale9CornerImage;
      
      private var _content:MovieClip;
      
      private var _btnOk:TextButton;
      
      private var _index:int;
      
      private var _last:int;
      
      private var _indexType:int;
      
      public function ZodiacMainView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("zodiac.mainview.bg");
         addChild(this._bg);
         this._title = ClassUtils.CreatInstance("zodiac.mainview.title.mc");
         PositionUtils.setPos(this._title,"zodiac.mainview.titlemc.pos");
         addChild(this._title);
         this._details = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.details.txt");
         addChild(this._details);
         this._quest = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.quest.txt");
         addChild(this._quest);
         this._boxBtnBitmapDark = ComponentFactory.Instance.creatBitmap("zodiac.mainview.boxbitmap");
         this._boxBtnBitmapDark.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         this._boxBtnBitmap = ComponentFactory.Instance.creatBitmap("zodiac.mainview.boxbitmap");
         this._boxMask = ClassUtils.CreatInstance("zodiac.mainview.boxbitmap.mask");
         this._boxBtnBitmap.mask = this._boxMask;
         this._boxAwardBtn = ClassUtils.CreatInstance("zodiac.mainview.boxshine");
         this._boxAwardBtn.visible = false;
         this._boxComponent = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.boxconent");
         this._boxComponent.addChild(this._boxBtnBitmapDark);
         this._boxComponent.addChild(this._boxBtnBitmap);
         this._boxComponent.addChild(this._boxMask);
         this._boxComponent.addChild(this._boxAwardBtn);
         this._boxComponent.buttonMode = false;
         var _loc1_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(201585);
         var _loc2_:BagCell = new BagCell(0,_loc1_,false);
         this._boxComponent.tipData = _loc2_.tipData;
         addChild(this._boxComponent);
         this._lastCount = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.lastcount.txt");
         addChild(this._lastCount);
         this._addBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.addcounts.btn");
         addChild(this._addBtn);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.help.btn");
         addChild(this._helpBtn);
         this._gotofinishBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.gotofinish.btn");
         addChild(this._gotofinishBtn);
         this._gotofinishBtn.visible = false;
         this._getAwardBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.mainview.getaward.btn");
         addChild(this._getAwardBtn);
         this._getAwardBtn.visible = false;
      }
      
      private function initEvent() : void
      {
         this._addBtn.addEventListener(MouseEvent.CLICK,this.__addCounts);
         this._boxComponent.addEventListener(MouseEvent.CLICK,this.__getAwardAll);
         this._gotofinishBtn.addEventListener(MouseEvent.CLICK,this.__gotoFinish);
         this._getAwardBtn.addEventListener(MouseEvent.CLICK,this.__getAward);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__showHelpFrame);
      }
      
      private function removeEvent() : void
      {
         this._addBtn.removeEventListener(MouseEvent.CLICK,this.__addCounts);
         this._boxComponent.removeEventListener(MouseEvent.CLICK,this.__getAwardAll);
         this._gotofinishBtn.removeEventListener(MouseEvent.CLICK,this.__gotoFinish);
         this._getAwardBtn.removeEventListener(MouseEvent.CLICK,this.__getAward);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__showHelpFrame);
      }
      
      private function __addCounts(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         if(PlayerManager.Instance.Self.Money >= ServerConfigManager.instance.zodiacAddPrice)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("zodiac.mainview.addCountstip",ServerConfigManager.instance.zodiacAddPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
         else
         {
            LeavePageManager.showFillFrame();
         }
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.zodiacAddCounts();
         }
         _loc2_.dispose();
      }
      
      private function __gotoFinish(param1:MouseEvent) : void
      {
         var _loc2_:StoreMainView = null;
         var _loc3_:StoreMainView = null;
         var _loc4_:StoreMainView = null;
         var _loc5_:StoreMainView = null;
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         switch(this._indexType)
         {
            case 34:
               if(PlayerManager.Instance.Self.Grade < 3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",3));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               break;
            case 41:
               if(PlayerManager.Instance.Self.Grade < 25)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",25));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(3);
               break;
            case 42:
               if(PlayerManager.Instance.Self.Grade < 13)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",13));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(2);
               break;
            case 37:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               break;
            case 46:
               if(PlayerManager.Instance.Self.Grade < 18)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",18));
                  return;
               }
               StateManager.setState(StateType.AUCTION);
               break;
            case 35:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               break;
            case 47:
               if(PlayerManager.Instance.Self.Grade < 28)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",28));
                  return;
               }
               break;
            case 33:
               if(PlayerManager.Instance.Self.Grade < 17)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               break;
            case 48:
               if(PlayerManager.Instance.Self.Grade < 40)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",40));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(8);
               break;
            case 49:
            case 50:
               break;
            case 51:
               if(PlayerManager.Instance.Self.Grade < 14)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",14));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(4);
               break;
            case 52:
               if(PlayerManager.Instance.Self.Grade < 31)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",31));
                  return;
               }
               break;
            case 53:
               break;
            case 45:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc2_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc2_.skipFromWantStrong(StoreMainView.EXALT);
               break;
            case 54:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,0);
               break;
            case 55:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,1);
               break;
            case 56:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,2);
               break;
            case 57:
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,3);
               break;
            case 58:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.FORGE_STORE,4);
               break;
            case 59:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc3_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc3_.skipFromWantStrong(StoreMainView.FUSION);
               break;
            case 60:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc4_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc4_.skipFromWantStrong(StoreMainView.TRANSF);
               break;
            case 61:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc5_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc5_.skipFromWantStrong(StoreMainView.COMPOSE);
               break;
            case 62:
               if(PlayerManager.Instance.Self.Grade < 20)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",20));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(5);
               break;
            case 63:
               if(PlayerManager.Instance.Self.Grade < 16)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",16));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(6);
               break;
            case 64:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
               break;
            case 65:
               break;
            case 66:
               if(PlayerManager.Instance.Self.Grade < 6)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",6));
                  return;
               }
               StateManager.setState(StateType.SHOP);
               break;
            case 67:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",10));
                  return;
               }
         }
         ZodiacManager.instance.frameDispose();
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         SocketManager.Instance.out.zodiacGetAward(ZodiacManager.instance.questArr[this._index - 1]);
      }
      
      private function __getAwardAll(param1:MouseEvent) : void
      {
         if(this._boxAwardBtn.visible == false)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         SocketManager.Instance.out.zodiacGetAwardAll();
      }
      
      private function __showHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         if(!this._helpframe)
         {
            this._helpframe = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.help.main");
            this._helpframe.titleText = LanguageMgr.GetTranslation("zodiac.mainframe.title");
            this._helpframe.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
            this._bgHelp = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.help.bgHelp");
            this._content = ComponentFactory.Instance.creatCustomObject("zodiac.frame.help.content");
            this._btnOk = ComponentFactory.Instance.creatComponentByStylename("zodiac.frame.help.btnOk");
            this._btnOk.text = LanguageMgr.GetTranslation("ok");
            this._btnOk.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpframe.addToContent(this._bgHelp);
            this._helpframe.addToContent(this._content);
            this._helpframe.addToContent(this._btnOk);
         }
         LayerManager.Instance.addToLayer(this._helpframe,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      private function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this._helpframe.parent.removeChild(this._helpframe);
         }
      }
      
      private function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpframe.parent.removeChild(this._helpframe);
      }
      
      public function setViewIndex(param1:int) : void
      {
         if(param1 == 0)
         {
            param1 = 1;
         }
         this._index = param1;
         this._title.gotoAndStop(this._index);
         this._details.text = LanguageMgr.GetTranslation("zodiac.mainview.constellation" + this._index);
         this.setQuestInfo();
         this.updateView();
      }
      
      public function updateView() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         this._last = ZodiacManager.instance.maxCounts - ZodiacManager.instance.finshedCounts;
         this._lastCount.text = this._last.toString();
         _loc1_ = 0;
         var _loc2_:int = 1;
         while(_loc2_ <= 13)
         {
            if((ZodiacManager.instance.awardRecord >> _loc2_ & 1) == 1)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         this._boxMask.y = this._boxBtnBitmap.y + this._boxBtnBitmap.height - _loc1_ * 4;
         if(_loc1_ == 12)
         {
            this._boxBtnBitmap.visible = this._boxBtnBitmapDark.visible = this._boxMask.visible = false;
            this._boxAwardBtn.visible = true;
            this._boxComponent.buttonMode = true;
         }
         if(_loc1_ == 13)
         {
            this._boxBtnBitmap.visible = true;
            this._boxBtnBitmapDark.visible = this._boxMask.visible = false;
            this._boxAwardBtn.visible = false;
            this._boxComponent.buttonMode = false;
         }
         var _loc3_:QuestInfo = TaskManager.getQuestByID(ZodiacManager.instance.questArr[this._index - 1]);
         this.refreshQuestBtn(this._index,_loc3_);
      }
      
      private function setQuestInfo() : void
      {
         var _loc7_:BagCell = null;
         var _loc1_:int = 0;
         var _loc2_:QuestInfo = null;
         var _loc3_:Point = null;
         var _loc4_:int = 0;
         var _loc5_:QuestItemReward = null;
         var _loc6_:InventoryItemInfo = null;
         _loc7_ = null;
         if(this._awards != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._awards.length)
            {
               removeChild(this._awards[0]);
               this._awards.shift();
            }
         }
         else
         {
            this._awards = [];
         }
         var _loc8_:int = int(ZodiacManager.instance.questArr[this._index - 1]);
         if(_loc8_ != 0)
         {
            _loc2_ = TaskManager.getQuestByID(_loc8_);
            if((ZodiacManager.instance.awardRecord >> this._index & 1) == 1)
            {
               this._quest.text = _loc2_.Detail + "(" + LanguageMgr.GetTranslation("zodiac.mainview.questcomplete") + ")";
            }
            else
            {
               this._quest.text = _loc2_.conditionDescription[0];
            }
            this._indexType = ZodiacManager.instance.indexTypeArr[_loc8_];
            this.refreshQuestBtn(this._index,_loc2_);
            if(Boolean(_loc2_.itemRewards))
            {
               _loc3_ = PositionUtils.creatPoint("zodiac.mainview.awardcell.pos");
               _loc4_ = 0;
               while(_loc4_ < _loc2_.itemRewards.length)
               {
                  _loc5_ = _loc2_.itemRewards[_loc4_];
                  _loc6_ = new InventoryItemInfo();
                  _loc6_.TemplateID = _loc5_.itemID;
                  _loc6_.Count = _loc5_.count;
                  _loc6_.AttackCompose = _loc5_.AttackCompose;
                  _loc6_.DefendCompose = _loc5_.DefendCompose;
                  _loc6_.LuckCompose = _loc5_.LuckCompose;
                  _loc6_.AgilityCompose = _loc5_.AgilityCompose;
                  _loc6_.StrengthenLevel = _loc5_.StrengthenLevel;
                  _loc6_.IsBinds = _loc5_.isBind;
                  _loc6_.ValidDate = _loc5_.ValidateTime;
                  ItemManager.fill(_loc6_);
                  _loc7_ = new BagCell(0,_loc6_,false,ComponentFactory.Instance.creatBitmap("zodiac.mainview.awardcell.bg"),false);
                  _loc7_.setContentSize(53,53);
                  _loc7_.setCount(_loc6_.Count);
                  _loc7_.x = _loc3_.x + 78 * (_loc4_ % 3);
                  _loc7_.y = _loc3_.y + 62 * (int(_loc4_ / 3) % 3);
                  addChild(_loc7_);
                  this._awards.push(_loc7_);
                  _loc4_++;
               }
            }
         }
         else
         {
            this._indexType = 0;
         }
      }
      
      private function refreshQuestBtn(param1:int, param2:QuestInfo) : void
      {
         if(param2 == null)
         {
            return;
         }
         if((ZodiacManager.instance.awardRecord >> param1 & 1) == 1)
         {
            this._gotofinishBtn.visible = false;
            this._getAwardBtn.visible = true;
            this._getAwardBtn.enable = false;
         }
         else if(param2.isAchieved)
         {
            this._gotofinishBtn.visible = false;
            this._getAwardBtn.visible = true;
            this._getAwardBtn.enable = false;
         }
         else if(param2.isCompleted)
         {
            this._gotofinishBtn.visible = false;
            this._getAwardBtn.visible = true;
            this._getAwardBtn.enable = true;
         }
         else
         {
            this._gotofinishBtn.visible = this._indexType == 0 || this._indexType == 49 ? Boolean(false) : Boolean(true);
            this._getAwardBtn.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

