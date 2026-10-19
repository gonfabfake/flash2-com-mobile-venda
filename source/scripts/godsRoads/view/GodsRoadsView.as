package godsRoads.view
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.bagStore.BagStore;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import godsRoads.data.GodsRoadsMissionInfo;
   import godsRoads.data.GodsRoadsMissionVo;
   import godsRoads.data.GodsRoadsStepVo;
   import godsRoads.data.GodsRoadsVo;
   import godsRoads.manager.GodsRoadsManager;
   import godsRoads.model.GodsRoadsModel;
   import labyrinth.LabyrinthManager;
   import store.StoreMainView;
   import store.states.BaseStoreView;
   
   public class GodsRoadsView extends Frame
   {
      
      private var _view:Sprite = new Sprite();
      
      private var _model:GodsRoadsModel;
      
      private var _listPanel:ListPanel;
      
      private var _data:GodsRoadsVo;
      
      private var _currentLv:int;
      
      private var _currentMissionID:int;
      
      private var _currentStep:GodsRoadsStepVo;
      
      private var _missionContentTxt:FilterFrameText;
      
      private var _missionProgressTxt:FilterFrameText;
      
      private var _missionStatusTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _progressTxt:FilterFrameText;
      
      private var _statusTxt:FilterFrameText;
      
      private var _stepProgressTxt:FilterFrameText;
      
      private var _stepProgressNum:FilterFrameText;
      
      private var _smallBtn:BaseButton;
      
      private var _bigBtn:BaseButton;
      
      private var _stepIsOpen:Boolean = false;
      
      private var _btnArr:Vector.<GodsRoadsFlag> = new Vector.<GodsRoadsFlag>(7);
      
      private var _missionAwardsView:Sprite = new Sprite();
      
      private var _stepAwardsView:Sprite = new Sprite();
      
      public function GodsRoadsView()
      {
         this._model = GodsRoadsManager.instance._model;
         this._currentLv = this._model.godsRoadsData.currentLevel;
         this._currentStep = this._model.godsRoadsData.steps[this._currentLv - 1];
         super();
         escEnable = true;
      }
      
      public function initView() : void
      {
         addToContent(this._view);
         var _loc1_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.GodsRoads.bg");
         this._view.addChild(_loc1_);
         this._listPanel = ComponentFactory.Instance.creatComponentByStylename("godsRoads.missionList");
         this._view.addChild(this._listPanel);
         this._listPanel.list.setListData(this._model.godsRoadsData.currentSteps.missionVos);
         this._listPanel.list.updateListView();
         this._missionContentTxt = ComponentFactory.Instance.creat("godsRoads.missionContentTxt");
         this._missionProgressTxt = ComponentFactory.Instance.creat("godsRoads.missionContentTxt");
         this._missionStatusTxt = ComponentFactory.Instance.creat("godsRoads.missionContentTxt");
         this._missionContentTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.contenttxt");
         this._missionProgressTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.progresstxt");
         this._missionStatusTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.statustxt");
         PositionUtils.setPos(this._missionContentTxt,"godsRoads.missionContentPos1");
         PositionUtils.setPos(this._missionProgressTxt,"godsRoads.missionContentPos2");
         PositionUtils.setPos(this._missionStatusTxt,"godsRoads.missionContentPos3");
         this._view.addChild(this._missionContentTxt);
         this._view.addChild(this._missionProgressTxt);
         this._view.addChild(this._missionStatusTxt);
         this._contentTxt = ComponentFactory.Instance.creat("godsRoads.contentTxt");
         this._progressTxt = ComponentFactory.Instance.creat("godsRoads.contentTxt");
         this._statusTxt = ComponentFactory.Instance.creat("godsRoads.contentTxt");
         PositionUtils.setPos(this._contentTxt,"godsRoads.contentPos1");
         PositionUtils.setPos(this._progressTxt,"godsRoads.contentPos2");
         PositionUtils.setPos(this._statusTxt,"godsRoads.contentPos3");
         this._view.addChild(this._contentTxt);
         this._view.addChild(this._progressTxt);
         this._view.addChild(this._statusTxt);
         this._stepProgressTxt = ComponentFactory.Instance.creat("godsRoads.stepProgress");
         PositionUtils.setPos(this._stepProgressTxt,"godsRoads.stepProgressPos");
         this._view.addChild(this._stepProgressTxt);
         this._stepProgressNum = ComponentFactory.Instance.creat("godsRoads.stepProgressNum");
         PositionUtils.setPos(this._stepProgressNum,"godsRoads.stepProgressPos1");
         this._view.addChild(this._stepProgressNum);
         this._smallBtn = ComponentFactory.Instance.creat("godsRoads.smallAwardsBtn");
         this._smallBtn.enable = false;
         this._bigBtn = ComponentFactory.Instance.creat("godsRoads.bigAwardsBtn");
         this._bigBtn.enable = false;
         this._view.addChild(this._smallBtn);
         this._view.addChild(this._bigBtn);
         this.initBtn();
         PositionUtils.setPos(this._missionAwardsView,"godsRoads.missionAwardsViewPos");
         this._view.addChild(this._missionAwardsView);
         PositionUtils.setPos(this._stepAwardsView,"godsRoads.stepAwardsViewPos");
         this._view.addChild(this._stepAwardsView);
         this.initEvent();
      }
      
      private function initBtn() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            this._btnArr[_loc1_] = ComponentFactory.Instance.creat("godsRoads.GodsRoadsFlag" + (_loc1_ + 1),[_loc1_ + 1]);
            this._btnArr[_loc1_].enable = false;
            this._view.addChild(this._btnArr[_loc1_]);
            _loc1_++;
         }
      }
      
      public function changeSteps(param1:int, param2:int = 0) : void
      {
         this._listPanel.vectorListModel.clear();
         this._stepIsOpen = this._btnArr[param1 - 1].isOpened;
         this._currentLv = param1;
         this._currentStep = this._model.godsRoadsData.steps[this._currentLv - 1];
         if(this._currentStep.getFinishPerNum() == 100)
         {
            if(this._currentStep.isGetAwards)
            {
               this._bigBtn.enable = false;
            }
            else
            {
               this._bigBtn.enable = true;
            }
         }
         else
         {
            this._bigBtn.enable = false;
         }
         this._listPanel.list.setListData(this._currentStep.missionVos);
         this._listPanel.list.updateListView();
         this._listPanel.list.currentSelectedIndex = param2;
         this._stepProgressTxt.text = LanguageMgr.GetTranslation("ddt.godsRoads.stepProgress");
         this._stepProgressNum.text = this._currentStep.getFinishPerString();
         GodsRoadsManager.instance.lastStep = this._currentStep.currentStep;
         this.flushStepAwards();
      }
      
      public function updateView(param1:GodsRoadsModel, param2:int = 0, param3:int = 0) : void
      {
         this._data = param1.godsRoadsData;
         var _loc4_:int = 0;
         while(_loc4_ < 7)
         {
            if(_loc4_ + 1 <= this._data.currentLevel)
            {
               this._btnArr[_loc4_].enable = true;
               if(_loc4_ + 1 <= this._data.currentLevel)
               {
                  this._btnArr[_loc4_].progressNum = this._data.steps[_loc4_].getFinishPerNum();
               }
               else
               {
                  this._btnArr[_loc4_].showProgress = false;
               }
            }
            else
            {
               this._btnArr[_loc4_].enable = false;
            }
            _loc4_++;
         }
         if(Boolean(param2))
         {
            this.changeSteps(param2,param3);
         }
         else
         {
            this.changeSteps(this._data.currentLevel);
         }
      }
      
      private function flushStepAwards() : void
      {
         var _loc4_:BagCell = null;
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:InventoryItemInfo = null;
         _loc4_ = null;
         ObjectUtils.disposeAllChildren(this._stepAwardsView);
         var _loc5_:Array = this._currentStep.awards;
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.godsRoads.stepAwardsBox");
            _loc3_ = _loc5_[_loc1_] as InventoryItemInfo;
            _loc4_ = new BagCell(_loc1_,_loc3_,false,_loc2_,false);
            _loc4_.setContentSize(48,48);
            _loc4_.setCount(_loc5_[_loc1_].Count);
            _loc4_.x = _loc1_ % 5 * 50;
            _loc4_.y = int(_loc1_ / 5) * 50;
            this._stepAwardsView.addChild(_loc4_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(FrameEvent.RESPONSE,this.__response);
         if(Boolean(this._listPanel))
         {
            this._listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
            this._listPanel.list.currentSelectedIndex = 0;
         }
         this._smallBtn.addEventListener(MouseEvent.CLICK,this.getMissionAwards);
         this._bigBtn.addEventListener(MouseEvent.CLICK,this.getStepAwards);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CANCEL_CLICK)
         {
            removeEventListener(FrameEvent.RESPONSE,this.__response);
            this.dispose();
         }
      }
      
      private function getMissionAwards(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.getGodsRoadsAwards(1,this._currentMissionID);
      }
      
      private function getStepAwards(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.getGodsRoadsAwards(2,this._currentLv);
      }
      
      private function __itemClick(param1:ListItemEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GodsRoadsMissionInfo = null;
         var _loc4_:Bitmap = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:BagCell = null;
         ObjectUtils.disposeAllChildren(this._missionAwardsView);
         var _loc7_:GodsRoadsMisstionCell = param1.cell as GodsRoadsMisstionCell;
         var _loc8_:GodsRoadsMissionVo = _loc7_.getCellValue();
         this._currentMissionID = _loc8_.ID;
         GodsRoadsManager.instance.lastMssion = param1.index;
         var _loc9_:Array = _loc8_.awards;
         _loc2_ = 0;
         while(_loc2_ < _loc9_.length)
         {
            _loc4_ = ComponentFactory.Instance.creatBitmap("asset.godsRoads.missionAwardsBox");
            _loc5_ = _loc9_[_loc2_] as InventoryItemInfo;
            _loc6_ = new BagCell(_loc2_,_loc5_,false,_loc4_,false);
            _loc6_.setContentSize(42,42);
            _loc6_.setCount(_loc9_[_loc2_].Count);
            _loc6_.x = _loc2_ % 5 * 44;
            _loc6_.y = int(_loc2_ / 5) * 44;
            this._missionAwardsView.addChild(_loc6_);
            _loc2_++;
         }
         _loc3_ = this._model.getMissionInfoById(_loc8_.ID);
         if(_loc3_.Detail.length > 26)
         {
            this._contentTxt.text = _loc3_.Detail.substring(0,26) + "...";
         }
         else if(_loc3_.Detail.length > 26)
         {
            this._contentTxt.text = _loc3_.Detail.substring(0,26) + "...";
         }
         else
         {
            this._contentTxt.text = _loc3_.Detail;
         }
         var _loc10_:int = _loc8_.condition1;
         if(_loc10_ > _loc3_.Para2)
         {
            _loc10_ = _loc3_.Para2;
         }
         this._progressTxt.text = _loc10_ + "/" + _loc3_.Para2;
         if(_loc8_.isFinished)
         {
            this._progressTxt.text = _loc3_.Para2 + "/" + _loc3_.Para2;
            this._statusTxt.textFormatStyle = "godsRoads.TextFormat5";
            this._statusTxt.filterString = "godsRoads.GF5";
            this._statusTxt.mouseEnabled = false;
            this._statusTxt.htmlText = LanguageMgr.GetTranslation("ddt.godsRoads.finishedTxt");
            this._statusTxt.removeEventListener(TextEvent.LINK,this.__linkFunc);
            if(_loc8_.isGetAwards)
            {
               this._smallBtn.enable = false;
            }
            else
            {
               this._smallBtn.enable = true;
            }
         }
         else
         {
            this._smallBtn.enable = false;
            if(this._stepIsOpen)
            {
               this._statusTxt.textFormatStyle = "godsRoads.TextFormat6";
               this._statusTxt.filterString = "godsRoads.GF6";
               this._statusTxt.mouseEnabled = true;
               this._statusTxt.htmlText = "<u><a href=\'event:" + _loc3_.IndexType + "\'>" + LanguageMgr.GetTranslation("ddt.godsRoads.gotoView") + "</a></u>";
               this._statusTxt.addEventListener(TextEvent.LINK,this.__linkFunc);
            }
            else
            {
               this._statusTxt.textFormatStyle = "godsRoads.TextFormat";
               this._statusTxt.filterString = "godsRoads.GF5";
               this._statusTxt.mouseEnabled = false;
               this._statusTxt.htmlText = LanguageMgr.GetTranslation("ddt.godsRoads.noOpenTxt");
               if(this._statusTxt.hasEventListener(TextEvent.LINK))
               {
                  this._statusTxt.removeEventListener(TextEvent.LINK,this.__linkFunc);
               }
            }
         }
      }
      
      private function __linkFunc(param1:TextEvent) : void
      {
         var _loc2_:StoreMainView = null;
         var _loc3_:StoreMainView = null;
         var _loc4_:StoreMainView = null;
         var _loc5_:int = int(param1.text);
         switch(_loc5_)
         {
            case 31:
               if(PlayerManager.Instance.Self.Grade < 8)
               {
                  TaskManager.switchVisible();
               }
               break;
            case 32:
               if(PlayerManager.Instance.Self.Grade < 12)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",12));
                  return;
               }
               StateManager.setState(StateType.ACADEMY_REGISTRATION);
               break;
            case 33:
               if(PlayerManager.Instance.Self.Grade < 17)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",17));
                  return;
               }
               StateManager.setState(StateType.CONSORTIA);
               break;
            case 34:
               if(PlayerManager.Instance.Self.Grade < 3)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",3));
                  return;
               }
               StateManager.setState(StateType.ROOM_LIST);
               break;
            case 35:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc2_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc2_.skipFromWantStrong(StoreMainView.STRENGTH);
               break;
            case 36:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc3_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc3_.skipFromWantStrong(StoreMainView.COMPOSE);
               break;
            case 37:
               if(PlayerManager.Instance.Self.Grade < 10)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",10));
                  return;
               }
               StateManager.setState(StateType.DUNGEON_LIST);
               break;
            case 38:
               break;
            case 39:
               if(PlayerManager.Instance.Self.Grade < 16)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",16));
                  return;
               }
               BagAndInfoManager.Instance.showBagAndInfo(2);
               break;
            case 40:
               if(PlayerManager.Instance.Self.Grade < 19)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",19));
                  return;
               }
               break;
            case 41:
               BagAndInfoManager.Instance.showBagAndInfo(3);
               break;
            case 42:
               BagAndInfoManager.Instance.showBagAndInfo(2);
               break;
            case 43:
               LabyrinthManager.Instance.show();
               break;
            case 44:
               if(PlayerManager.Instance.Self.Grade < 30)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",30));
                  return;
               }
               if(PlayerManager.Instance.Self.Bag.getItemAt(6) == null)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
                  return;
               }
               break;
            case 45:
               if(PlayerManager.Instance.Self.Grade < 5)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newSevenDayTarget.newSevenDayTargetFrameLevelDown",5));
                  return;
               }
               BagStore.instance.show(BagStore.BAG_STORE);
               _loc4_ = (BagStore.instance.controllerInstance.getSkipView() as BaseStoreView)._storeview;
               _loc4_.skipFromWantStrong(StoreMainView.EXALT);
         }
         this.dispose();
      }
      
      override public function dispose() : void
      {
         if(this._statusTxt.hasEventListener(TextEvent.LINK))
         {
            this._statusTxt.removeEventListener(TextEvent.LINK,this.__linkFunc);
         }
         if(Boolean(this._listPanel))
         {
            this._listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         }
         if(Boolean(this._view))
         {
            ObjectUtils.removeChildAllChildren(this._view);
         }
         this._view = null;
         super.dispose();
      }
   }
}

