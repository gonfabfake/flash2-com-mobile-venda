package treasure.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleUpDownImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import treasure.controller.TreasureManager;
   import treasure.events.TreasureEvents;
   import treasure.model.TreasureModel;
   
   public class TreasureView extends Sprite implements Disposeable
   {
      
      private var _model:TreasureModel;
      
      private var _bg:Bitmap;
      
      private var _loginDaysTitle:Bitmap;
      
      private var _numBg:Bitmap;
      
      private var _digTimesTitle:Bitmap;
      
      private var _helpTimesTitle:Bitmap;
      
      private var _line1:Bitmap;
      
      private var _line2:Bitmap;
      
      private var _loginDaysTf:FilterFrameText;
      
      private var infoFrameBg:ScaleUpDownImage;
      
      private var beginBtn:SimpleBitmapButton;
      
      private var endBtn:SimpleBitmapButton;
      
      private var box:Sprite;
      
      private var fieldView:TreasureField;
      
      private var _treasureReturnBar:TreasureReturnBar;
      
      private var _helpFrame:TreasureHelpFrame;
      
      public function TreasureView()
      {
         super();
         this._model = TreasureModel.instance;
         this.init();
         this.addListener();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.treasure.bg");
         this.infoFrameBg = ComponentFactory.Instance.creatComponentByStylename("asset.treasure.infoFrame.BG");
         this._loginDaysTitle = ComponentFactory.Instance.creatBitmap("asset.treasure.loginDays");
         this._numBg = ComponentFactory.Instance.creatBitmap("asset.treasure.numBg");
         this._digTimesTitle = ComponentFactory.Instance.creatBitmap("asset.treasure.digTimes");
         this._helpTimesTitle = ComponentFactory.Instance.creatBitmap("asset.treasure.helpTimes");
         this._line1 = ComponentFactory.Instance.creatBitmap("asset.treasure.line");
         this._line2 = ComponentFactory.Instance.creatBitmap("asset.treasure.line");
         this._loginDaysTf = ComponentFactory.Instance.creatComponentByStylename("asset.treasure.loginDaysTf");
         this.beginBtn = ComponentFactory.Instance.creatComponentByStylename("treasure.beginbtn");
         this.box = new Sprite();
         this._treasureReturnBar = ComponentFactory.Instance.creat("asset.treasure.returnMenu");
         this._helpFrame = ComponentFactory.Instance.creat("asset.treasure.helpFrame");
         PositionUtils.setPos(this._line1,"treasure.pos.line1");
         PositionUtils.setPos(this._line2,"treasure.pos.line2");
         addChild(this._bg);
         addChild(this.infoFrameBg);
         addChild(this._loginDaysTitle);
         addChild(this._numBg);
         addChild(this._digTimesTitle);
         addChild(this._helpTimesTitle);
         addChild(this._line1);
         addChild(this._line2);
         addChild(this._loginDaysTf);
         addChild(this.box);
         addChild(this.beginBtn);
         addChild(this._treasureReturnBar);
         this.fieldView = new TreasureField(this);
         addChild(this._helpFrame);
         if(TreasureModel.instance.isEndTreasure)
         {
            this.fieldView.setField(true);
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.treasure.over"));
         }
         else if(TreasureModel.instance.isBeginTreasure)
         {
            this.fieldView.setField(false);
         }
         else
         {
            this.fieldView.setField(true);
         }
         this.initData();
      }
      
      private function initData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(TreasureModel.instance.isEndTreasure)
         {
            this.beginBtn.visible = false;
         }
         else if(TreasureModel.instance.isBeginTreasure)
         {
            this.beginBtn.visible = false;
         }
         else
         {
            this.beginBtn.visible = true;
         }
         this._loginDaysTf.text = String(TreasureModel.instance.logoinDays);
         var _loc9_:int = TreasureModel.instance.logoinDays > 2 ? 3 : TreasureModel.instance.logoinDays;
         if(Boolean(this.box))
         {
            ObjectUtils.disposeAllChildren(this.box);
         }
         _loc1_ = 0;
         while(_loc1_ < TreasureModel.instance.friendHelpTimes)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("asset.treasure.forfex");
            this.box.addChild(_loc2_);
            _loc2_.x = 60 + _loc1_ * (_loc2_.width + 10);
            _loc1_++;
         }
         var _loc10_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _loc9_)
         {
            _loc4_ = ComponentFactory.Instance.creatBitmap("asset.treasure.star");
            this.box.addChild(_loc4_);
            _loc4_.x = 60 + _loc3_ * (_loc4_.width + 10);
            _loc4_.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            _loc10_.push(_loc4_);
            _loc3_++;
         }
         var _loc11_:int = TreasureModel.instance.friendHelpTimes >= PathManager.treasureHelpTimes ? 1 : 0;
         var _loc12_:Array = [];
         _loc5_ = 0;
         while(_loc5_ < _loc11_)
         {
            _loc6_ = ComponentFactory.Instance.creatBitmap("asset.treasure.sun");
            this.box.addChild(_loc6_);
            _loc6_.x = 60 + _loc9_ * (_loc6_.width + 10);
            _loc6_.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            _loc12_.push(_loc6_);
            _loc5_++;
         }
         _loc7_ = 0;
         while(_loc7_ < PlayerManager.Instance.Self.treasure)
         {
            if(Boolean(_loc10_[_loc7_]))
            {
               _loc10_[_loc7_].filters = null;
            }
            _loc7_++;
         }
         _loc8_ = 0;
         while(_loc8_ < PlayerManager.Instance.Self.treasureAdd)
         {
            if(Boolean(_loc12_[_loc8_]))
            {
               _loc12_[_loc8_].filters = null;
            }
            _loc8_++;
         }
      }
      
      private function addListener() : void
      {
         this.beginBtn.addEventListener("click",this.__onbeginBtnClick);
         this._treasureReturnBar.addEventListener("returnTreasure",this.__returnHandler);
         TreasureManager.instance.addEventListener("beRepairFriendFarmSend",this.__friendHelpFarmHandler);
         TreasureManager.instance.addEventListener("beginGame",this.__beginGameHandler);
         TreasureManager.instance.addEventListener("dig",this.__diHandler);
         TreasureManager.instance.addEventListener("endGame",this.__endGameHandler);
      }
      
      private function __endGameHandler(param1:TreasureEvents) : void
      {
         this.fieldView.endGameShow();
      }
      
      private function __diHandler(param1:TreasureEvents) : void
      {
         this.initData();
         this.fieldView.digField(param1.info.pos);
      }
      
      private function __beginGameHandler(param1:TreasureEvents) : void
      {
         this.beginBtn.visible = false;
         this.fieldView.playStartCartoon();
      }
      
      private function __returnHandler(param1:TreasureEvents) : void
      {
         SoundManager.instance.play("008");
         FarmModelController.instance.goFarm(PlayerManager.Instance.Self.ID,PlayerManager.Instance.Self.NickName);
      }
      
      private function __friendHelpFarmHandler(param1:TreasureEvents) : void
      {
         this.initData();
      }
      
      private function __onEndBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(TreasureModel.instance.friendHelpTimes < PathManager.treasureHelpTimes)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("ddt.treasure.giveUp"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,false,2);
            _loc2_.addEventListener("response",this.__onFeedResponse);
         }
         else
         {
            SocketManager.Instance.out.endTreasure();
         }
      }
      
      protected function __onFeedResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode) - 2)
         {
            case 0:
            case 1:
               SocketManager.Instance.out.endTreasure();
         }
         param1.currentTarget.removeEventListener("response",this.__onFeedResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      private function __onbeginBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.beginBtn.enable = false;
         SocketManager.Instance.out.startTreasure();
      }
      
      private function removeEvent() : void
      {
         this.beginBtn.removeEventListener("click",this.__onbeginBtnClick);
         this._treasureReturnBar.removeEventListener("returnTreasure",this.__returnHandler);
         TreasureManager.instance.removeEventListener("beRepairFriendFarmSend",this.__friendHelpFarmHandler);
         TreasureManager.instance.removeEventListener("beginGame",this.__beginGameHandler);
         TreasureManager.instance.removeEventListener("dig",this.__diHandler);
         TreasureManager.instance.removeEventListener("endGame",this.__endGameHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this.box))
         {
            ObjectUtils.disposeAllChildren(this.box);
         }
         if(Boolean(this.box))
         {
            ObjectUtils.disposeObject(this.box);
         }
         this.box = null;
         if(Boolean(this._loginDaysTf))
         {
            ObjectUtils.disposeObject(this._loginDaysTf);
         }
         this._loginDaysTf = null;
         if(Boolean(this._line1))
         {
            ObjectUtils.disposeObject(this._line1);
         }
         this._line1 = null;
         if(Boolean(this._line2))
         {
            ObjectUtils.disposeObject(this._line2);
         }
         this._line2 = null;
         if(Boolean(this._helpTimesTitle))
         {
            ObjectUtils.disposeObject(this._helpTimesTitle);
         }
         this._helpTimesTitle = null;
         if(Boolean(this._digTimesTitle))
         {
            ObjectUtils.disposeObject(this._digTimesTitle);
         }
         this._digTimesTitle = null;
         if(Boolean(this._numBg))
         {
            ObjectUtils.disposeObject(this._numBg);
         }
         this._numBg = null;
         if(Boolean(this._loginDaysTitle))
         {
            ObjectUtils.disposeObject(this._loginDaysTitle);
         }
         this._loginDaysTitle = null;
         if(Boolean(this.infoFrameBg))
         {
            ObjectUtils.disposeObject(this.infoFrameBg);
         }
         this.infoFrameBg = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         this.fieldView.dispose();
         this.fieldView = null;
         this._helpFrame.dispose();
         this._helpFrame = null;
         this._treasureReturnBar.dispose();
         this._treasureReturnBar = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

