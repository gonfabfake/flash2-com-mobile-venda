package lotteryTicket.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CheckMoneyUtils;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import lotteryTicket.LotteryManager;
   import lotteryTicket.data.LotteryRewardInfo;
   import lotteryTicket.data.LotteryTicketInfo;
   import lotteryTicket.event.LotteryTicketEvent;
   
   public class LotteryMainView extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _prizeMoney:Sprite;
      
      private var _activityTimeTxt:FilterFrameText;
      
      private var _openTimeTxt:FilterFrameText;
      
      private var _randomBtn:BaseButton;
      
      private var _okBtn:BaseButton;
      
      private var _buyBtn:BaseButton;
      
      private var _prizeListBtn:BaseButton;
      
      private var firstTicket:MovieClip;
      
      private var secondTicket:MovieClip;
      
      private var thirdTicket:MovieClip;
      
      private var fourthTicket:MovieClip;
      
      private var isFour:Array = [0,0,0,0];
      
      private var count:int = 16;
      
      private var selectArr:Array;
      
      private var ticketArr:Array;
      
      private var _list:ListPanel;
      
      private var prizeBox:Sprite;
      
      private var closeBtn:BaseButton;
      
      private var _help:SimpleBitmapButton;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var canBuyArr:Array;
      
      private var _frame:LotteryPrizeView;
      
      public function LotteryMainView()
      {
         super();
         this.initView();
         this.initEvent();
         this.initData();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc8_:* = null;
         var _loc9_:* = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.bg");
         addChild(this._bg);
         this._activityTimeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.activityTime.txt");
         addChild(this._activityTimeTxt);
         this._activityTimeTxt.text = LanguageMgr.GetTranslation("asset.lotteryTicket.activityTime",ServerConfigManager.instance.getTwoColorBallBeginTime(),ServerConfigManager.instance.getTwoColorBallEndTime());
         this._openTimeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.lotteryTicket.openTime.txt");
         addChild(this._openTimeTxt);
         this._openTimeTxt.text = LanguageMgr.GetTranslation("asset.lotteryTicket.openTime","21:00");
         this._randomBtn = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.randomBtn");
         addChild(this._randomBtn);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.okBtn");
         addChild(this._okBtn);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.buyBtn");
         addChild(this._buyBtn);
         this._prizeListBtn = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.prizeListBtn");
         addChild(this._prizeListBtn);
         if(LotteryManager.instance.model.displayResults == "")
         {
            this._prizeListBtn.enable = false;
         }
         this.selectArr = [];
         _loc1_ = 0;
         while(_loc1_ < this.count)
         {
            _loc2_ = ClassUtils.CreatInstance("asset.lotteryTicket.select");
            _loc2_.pos = _loc1_;
            PositionUtils.setPos(_loc2_,"asset.lotteryTicket.select.pos" + String(_loc1_));
            _loc2_.gotoAndStop(1);
            addChild(_loc2_);
            _loc2_.addEventListener("click",this.selectHandler);
            this.selectArr.push(_loc2_);
            _loc1_++;
         }
         this.ticketArr = [];
         this.firstTicket = ClassUtils.CreatInstance("asset.lotteryTicket.ticket");
         this.secondTicket = ClassUtils.CreatInstance("asset.lotteryTicket.ticket");
         this.thirdTicket = ClassUtils.CreatInstance("asset.lotteryTicket.ticket");
         this.fourthTicket = ClassUtils.CreatInstance("asset.lotteryTicket.ticket");
         PositionUtils.setPos(this.firstTicket,"asset.lotteryTicket.ticket.pos1");
         PositionUtils.setPos(this.secondTicket,"asset.lotteryTicket.ticket.pos2");
         PositionUtils.setPos(this.thirdTicket,"asset.lotteryTicket.ticket.pos3");
         PositionUtils.setPos(this.fourthTicket,"asset.lotteryTicket.ticket.pos4");
         addChild(this.firstTicket);
         addChild(this.secondTicket);
         addChild(this.thirdTicket);
         addChild(this.fourthTicket);
         this.firstTicket.gotoAndStop(this.count + 1);
         this.secondTicket.gotoAndStop(this.count + 1);
         this.thirdTicket.gotoAndStop(this.count + 1);
         this.fourthTicket.gotoAndStop(this.count + 1);
         this.ticketArr = [this.firstTicket,this.secondTicket,this.thirdTicket,this.fourthTicket];
         this._list = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.cellList");
         addChild(this._list);
         this.prizeBox = new Sprite();
         addChild(this.prizeBox);
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < LotteryManager.instance.model.itemInfoList.length)
         {
            _loc6_ = LotteryManager.instance.model.itemInfoList[_loc5_] as LotteryRewardInfo;
            _loc4_ = new InventoryItemInfo();
            _loc4_.TemplateID = _loc6_.TemplateID;
            _loc4_ = ItemManager.fill(_loc4_);
            _loc4_.IsBinds = _loc6_.IsBind;
            _loc4_.ValidDate = _loc6_.ValidDate;
            _loc4_.StrengthenLevel = _loc6_.StrengthLevel;
            _loc4_.AttackCompose = _loc6_.AttackCompose;
            _loc4_.DefendCompose = _loc6_.DefendCompose;
            _loc4_.AgilityCompose = _loc6_.AgilityCompose;
            _loc4_.LuckCompose = _loc6_.LuckCompose;
            _loc4_.Count = _loc6_.Count;
            _loc7_ = new BagCell(0,_loc4_,false,ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.prize.bg"));
            _loc7_.BGVisible = true;
            _loc7_.setContentSize(40,40);
            if(_loc6_.Quality == 1)
            {
               _loc7_.x = _loc10_ * 50 + 595;
               _loc7_.y = 313;
               _loc10_++;
            }
            else if(_loc6_.Quality == 2)
            {
               _loc7_.x = _loc11_ * 50 + 595;
               _loc7_.y = 394;
               _loc11_++;
            }
            else if(_loc6_.Quality == 3)
            {
               _loc7_.x = _loc12_ * 50 + 595;
               _loc7_.y = 471;
               _loc12_++;
            }
            this.prizeBox.addChild(_loc7_);
            _loc5_++;
         }
         if(LotteryManager.instance.model.displayResults.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < LotteryManager.instance.model.displayResults.length)
            {
               _loc8_ = ClassUtils.CreatInstance("asset.lotteryTicket.ticket");
               addChild(_loc8_);
               _loc8_.x = 602 + _loc5_ * 63;
               _loc8_.y = 172;
               _loc8_.gotoAndStop(parseInt(LotteryManager.instance.model.displayResults.substr(_loc5_,1),16) + 1);
               _loc5_++;
            }
         }
         else
         {
            _loc5_ = 0;
            while(_loc5_ < 4)
            {
               _loc9_ = ComponentFactory.Instance.creatBitmap("asset.lotteryTicket.question");
               addChild(_loc9_);
               _loc9_.x = 613 + _loc5_ * 63;
               _loc9_.y = 174;
               _loc5_++;
            }
         }
         this.closeBtn = ComponentFactory.Instance.creatComponentByStylename("lotteryTicket.closeBtn");
         addChild(this.closeBtn);
         this._help = HelpFrameUtils.Instance.simpleHelpButton(this,"coreii.helpBtn",null,LanguageMgr.GetTranslation("asset.lotteryTicket.helpTitle"),"asset.lotteryTicket.help",430,484) as SimpleBitmapButton;
         PositionUtils.setPos(this._help,"asset.lotteryTicket.helpBtn.pos");
      }
      
      public function initData() : void
      {
         this._list.vectorListModel.clear();
         this._list.vectorListModel.appendAll(LotteryManager.instance.model.dataList);
         this._list.list.updateListView();
      }
      
      private function ticketHandler(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame == this.count + 1)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this.firstTicket:
               this.isFour[0] = 0;
               break;
            case this.secondTicket:
               this.isFour[1] = 0;
               break;
            case this.thirdTicket:
               this.isFour[2] = 0;
               break;
            case this.fourthTicket:
               this.isFour[3] = 0;
         }
         this.selectArr[param1.currentTarget.currentFrame - 1].gotoAndStop(1);
         param1.currentTarget.gotoAndStop(this.count + 1);
      }
      
      private function cleanAllSelect() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.selectArr.length)
         {
            this.selectArr[_loc1_].gotoAndStop(1);
            _loc1_++;
         }
      }
      
      private function selectHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = this.isFour.indexOf(0);
         if(_loc2_ == -1 || param1.currentTarget.currentFrame == 2)
         {
            return;
         }
         this.isFour[_loc2_] = param1.currentTarget.pos + 1;
         this.ticketArr[_loc2_].gotoAndStop(param1.currentTarget.pos + 1);
         param1.currentTarget.gotoAndStop(2);
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__frameEventHandler);
         this._randomBtn.addEventListener("click",this.randomBtnHander);
         this._okBtn.addEventListener("click",this.okBtnHander);
         this._buyBtn.addEventListener("click",this.buyBtnHander);
         this._prizeListBtn.addEventListener("click",this.prizeListBtnHander);
         this.firstTicket.addEventListener("click",this.ticketHandler);
         this.secondTicket.addEventListener("click",this.ticketHandler);
         this.thirdTicket.addEventListener("click",this.ticketHandler);
         this.fourthTicket.addEventListener("click",this.ticketHandler);
         this.closeBtn.addEventListener("click",this.closeHandler);
         LotteryManager.instance.addEventListener("deleteCell",this.deleteHandler);
      }
      
      private function closeHandler(param1:MouseEvent) : void
      {
         LotteryManager.instance.closeFrame();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode) - 1)
         {
            case 0:
               LotteryManager.instance.closeFrame();
               break;
            case 3:
         }
      }
      
      private function randomBtnHander(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.cleanAllSelect();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = Math.floor(16 * Math.random());
            if(this.isFour.indexOf(_loc3_ + 1) != -1)
            {
               _loc2_--;
            }
            else
            {
               this.isFour[_loc2_] = _loc3_ + 1;
               this.ticketArr[_loc2_].gotoAndStop(_loc3_ + 1);
               this.selectArr[_loc3_].gotoAndStop(2);
            }
            _loc2_++;
         }
      }
      
      private function okBtnHander(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(!LotteryManager.instance.model.isCanBuyBall)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.lotteryTicket.joinFail3"));
            return;
         }
         if(LotteryManager.instance.model.dataList.length == 8)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.lotteryTicket.joinFail2"));
            return;
         }
         var _loc3_:int = this.isFour.indexOf(0);
         if(_loc3_ != -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.lotteryTicket.joinFail1"));
            return;
         }
         var _loc4_:LotteryTicketInfo = new LotteryTicketInfo();
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc4_.ticketArr[_loc2_] = (this.isFour[_loc2_] - 1).toString(16);
            _loc2_++;
         }
         _loc4_.ifBuy = false;
         LotteryManager.instance.model.dataList.push(_loc4_);
         this.initData();
      }
      
      private function buyBtnHander(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         this.canBuyArr = [];
         _loc2_ = 0;
         while(_loc2_ < LotteryManager.instance.model.dataList.length)
         {
            _loc3_ = LotteryManager.instance.model.dataList[_loc2_];
            if(!_loc3_.ifBuy)
            {
               this.canBuyArr.push(_loc3_);
            }
            _loc2_++;
         }
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.canBuyArr.length == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("asset.lotteryTicket.joinFail4"));
            return;
         }
         var _loc4_:String = LanguageMgr.GetTranslation("asset.lotteryTicket.howmuchmoney",100 * this.canBuyArr.length,this.canBuyArr.length);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("ddt.vip.vipFrame.ConfirmTitle"),_loc4_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,1,null,"SimpleAlert",30,true,0);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener("response",this.__confirm);
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode) - 2)
         {
            case 0:
            case 1:
               CheckMoneyUtils.instance.checkMoney(this._confirmFrame.isBand,100 * this.canBuyArr.length,this.onCompleteHandler);
         }
         this._confirmFrame.removeEventListener("response",this.__confirm);
         this._confirmFrame.dispose();
         if(Boolean(this._confirmFrame.parent))
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      private function onCompleteHandler() : void
      {
         SocketManager.Instance.out.buyLotteryTicket(LotteryManager.instance.model.gameIndex,this.canBuyArr);
      }
      
      private function prizeListBtnHander(param1:MouseEvent) : void
      {
         this._frame = ComponentFactory.Instance.creatCustomObject("Lottery.lotteryPrizeView");
         this._frame.titleText = LanguageMgr.GetTranslation("asset.lotteryTicket.prizeList");
         LayerManager.Instance.addToLayer(this._frame,3,true,1);
      }
      
      private function deleteHandler(param1:LotteryTicketEvent) : void
      {
         this.initData();
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__frameEventHandler);
         this._randomBtn.removeEventListener("click",this.randomBtnHander);
         this._okBtn.removeEventListener("click",this.okBtnHander);
         this._buyBtn.removeEventListener("click",this.buyBtnHander);
         this._prizeListBtn.removeEventListener("click",this.prizeListBtnHander);
         this.firstTicket.removeEventListener("click",this.ticketHandler);
         this.secondTicket.removeEventListener("click",this.ticketHandler);
         this.thirdTicket.removeEventListener("click",this.ticketHandler);
         this.fourthTicket.removeEventListener("click",this.ticketHandler);
         this.closeBtn.removeEventListener("click",this.closeHandler);
         LotteryManager.instance.removeEventListener("deleteCell",this.deleteHandler);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         LotteryManager.instance.isClick = false;
         this.removeEvent();
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(this._prizeMoney))
         {
            ObjectUtils.disposeObject(this._prizeMoney);
         }
         this._prizeMoney = null;
         if(Boolean(this._activityTimeTxt))
         {
            ObjectUtils.disposeObject(this._activityTimeTxt);
         }
         this._activityTimeTxt = null;
         if(Boolean(this._openTimeTxt))
         {
            ObjectUtils.disposeObject(this._openTimeTxt);
         }
         this._openTimeTxt = null;
         if(Boolean(this._randomBtn))
         {
            ObjectUtils.disposeObject(this._randomBtn);
         }
         this._randomBtn = null;
         if(Boolean(this._okBtn))
         {
            ObjectUtils.disposeObject(this._okBtn);
         }
         this._okBtn = null;
         if(Boolean(this._buyBtn))
         {
            ObjectUtils.disposeObject(this._buyBtn);
         }
         this._buyBtn = null;
         if(Boolean(this._prizeListBtn))
         {
            ObjectUtils.disposeObject(this._prizeListBtn);
         }
         this._prizeListBtn = null;
         if(Boolean(this.firstTicket))
         {
            ObjectUtils.disposeObject(this.firstTicket);
         }
         this.firstTicket = null;
         if(Boolean(this.secondTicket))
         {
            ObjectUtils.disposeObject(this.secondTicket);
         }
         this.secondTicket = null;
         if(Boolean(this.thirdTicket))
         {
            ObjectUtils.disposeObject(this.thirdTicket);
         }
         this.thirdTicket = null;
         if(Boolean(this.fourthTicket))
         {
            ObjectUtils.disposeObject(this.fourthTicket);
         }
         this.fourthTicket = null;
         if(Boolean(this._list))
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(Boolean(this._help))
         {
            ObjectUtils.disposeObject(this._help);
         }
         this._help = null;
         _loc1_ = 0;
         while(_loc1_ < this.selectArr.length)
         {
            this.selectArr[_loc1_].removeEventListener("click",this.selectHandler);
            ObjectUtils.disposeObject(this.selectArr[_loc1_]);
            _loc1_++;
         }
         dispatchEvent(new KeyboardEvent("keyDown",true,false,27));
         super.dispose();
      }
   }
}

