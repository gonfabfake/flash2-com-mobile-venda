package defendisland.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.CheckWeaponManager;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import defendisland.DefendislandControl;
   import defendisland.DefendislandManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.GameManager;
   
   public class DefendislandFrame extends Frame
   {
      
      private var _bg:Bitmap;
      
      private var _startGameBtn:BaseButton;
      
      private var _cancelGameBtn:BaseButton;
      
      private var _helpBtn:BaseButton;
      
      private var boss1:Bitmap;
      
      private var boss2:Bitmap;
      
      private var boss3:Bitmap;
      
      private var boss4:Bitmap;
      
      private var boss5:Bitmap;
      
      private var icon1:Component;
      
      private var icon2:Component;
      
      private var icon3:Component;
      
      private var icon4:Component;
      
      private var icon5:Component;
      
      private var bossShine:Bitmap;
      
      private var _bossList:Array;
      
      private var waiting:Bitmap;
      
      private var timeTxt:FilterFrameText;
      
      public function DefendislandFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("ddt.defendisland.frame.title");
         this._bg = ComponentFactory.Instance.creatBitmap("defendisland.frame.bg");
         addToContent(this._bg);
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"coreii.helpBtn",{
            "x":730,
            "y":2
         },LanguageMgr.GetTranslation("store.view.HelpButtonText"),"defendisland.content.help",438,520);
         this._startGameBtn = ComponentFactory.Instance.creatComponentByStylename("defendisland.frame.startGameBtn");
         addToContent(this._startGameBtn);
         this._cancelGameBtn = ComponentFactory.Instance.creatComponentByStylename("defendisland.frame.cancelGameBtn");
         addToContent(this._cancelGameBtn);
         this.bossShine = ComponentFactory.Instance.creatBitmap("defendisland.frame.boss.shine");
         addToContent(this.bossShine);
         this.icon1 = new Component();
         this.icon2 = new Component();
         this.icon3 = new Component();
         this.icon4 = new Component();
         this.icon5 = new Component();
         this.boss1 = ComponentFactory.Instance.creatBitmap("defendisland.frame.boss1");
         this.boss2 = ComponentFactory.Instance.creatBitmap("defendisland.frame.boss2");
         this.boss3 = ComponentFactory.Instance.creatBitmap("defendisland.frame.boss3");
         this.boss4 = ComponentFactory.Instance.creatBitmap("defendisland.frame.boss4");
         this.boss5 = ComponentFactory.Instance.creatBitmap("defendisland.frame.boss5");
         addToContent(this.icon1);
         addToContent(this.icon2);
         addToContent(this.icon3);
         addToContent(this.icon4);
         addToContent(this.icon5);
         this.icon1.addChild(this.boss1);
         this.icon2.addChild(this.boss2);
         this.icon3.addChild(this.boss3);
         this.icon4.addChild(this.boss4);
         this.icon5.addChild(this.boss5);
         PositionUtils.setPos(this.icon1,"defendisland.frame.boss1.pos");
         PositionUtils.setPos(this.icon2,"defendisland.frame.boss2.pos");
         PositionUtils.setPos(this.icon3,"defendisland.frame.boss3.pos");
         PositionUtils.setPos(this.icon4,"defendisland.frame.boss4.pos");
         PositionUtils.setPos(this.icon5,"defendisland.frame.boss5.pos");
         this._bossList = [this.icon1,this.icon2,this.icon3,this.icon4,this.icon5];
         this._bossList[0].tipStyle = this._bossList[1].tipStyle = this._bossList[2].tipStyle = this._bossList[3].tipStyle = this._bossList[4].tipStyle = "ddt.view.tips.OneLineTip";
         this._bossList[0].tipDirctions = this._bossList[1].tipDirctions = this._bossList[2].tipDirctions = this._bossList[3].tipDirctions = this._bossList[4].tipDirctions = "7,5";
         this._bossList[0].tipGapH = this._bossList[1].tipGapH = this._bossList[2].tipGapH = this._bossList[3].tipGapH = this._bossList[4].tipGapH = 120;
         this._bossList[0].tipGapV = this._bossList[1].tipGapV = this._bossList[2].tipGapV = this._bossList[3].tipGapV = this._bossList[4].tipGapV = 72;
         this.bossShine.visible = false;
         this.waiting = ComponentFactory.Instance.creatBitmap("defendisland.frame.loading");
         addToContent(this.waiting);
         this._cancelGameBtn.visible = this.waiting.visible = false;
         this.timeTxt = ComponentFactory.Instance.creatComponentByStylename("defendisland.frame.activityTimeText");
         addToContent(this.timeTxt);
         this.timeTxt.text = LanguageMgr.GetTranslation("ddt.defendisland.frame.time",DefendislandManager.instance.model.beginTime,DefendislandManager.instance.model.endTime);
         this.setData();
      }
      
      public function setData() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         var _loc2_:Array = LanguageMgr.GetTranslation("ddt.defendisland.frame.prizeName").split("|");
         var _loc3_:Array = LanguageMgr.GetTranslation("ddt.defendisland.frame.npcName").split("|");
         _loc1_ = this._bossList.length - 1;
         while(_loc1_ >= 0)
         {
            this._bossList[_loc1_].tipData = LanguageMgr.GetTranslation("ddt.defendisland.frame.tip",_loc3_[_loc1_],DefendislandManager.instance.model.remainCountList[_loc1_],DefendislandManager.instance.model.countList[_loc1_],_loc2_[_loc1_]);
            if(DefendislandManager.instance.model.remainCountList[_loc1_] == 0)
            {
               this._bossList[_loc1_].filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
               this.bossShine.visible = true;
               this._bossList[_loc1_].filters = null;
               this.bossShine.x = this._bossList[_loc1_].x;
               this.bossShine.y = this._bossList[_loc1_].y;
            }
            _loc1_--;
         }
         this._startGameBtn.visible = true;
         this.waiting.visible = this._cancelGameBtn.visible = false;
      }
      
      private function addEvent() : void
      {
         addEventListener("response",this._responseHandle);
         this._startGameBtn.addEventListener("click",this.createRoomBtnHandler);
         this._cancelGameBtn.addEventListener("click",this.quickJoinBtnHandler);
         GameManager.Instance.addEventListener("StartLoading",this.__startLoading);
      }
      
      protected function __startLoading(param1:Event) : void
      {
         StateManager.getInGame_Step_6 = true;
         ChatManager.Instance.input.faceEnabled = false;
         LayerManager.Instance.clearnGameDynamic();
         StateManager.setState("roomLoading",GameManager.Instance.Current);
         StateManager.getInGame_Step_7 = true;
      }
      
      private function createRoomBtnHandler(param1:MouseEvent) : void
      {
         if(CheckWeaponManager.instance.isNoWeapon())
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIController.weapon"));
            return;
         }
         if(DefendislandManager.instance.model.remainCountList[DefendislandManager.instance.model.remainCountList.length - 1] == 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.defendisland.frame.remainCountNone"));
            return;
         }
         SocketManager.Instance.out.defendislandInfo(3);
         this._startGameBtn.visible = false;
         this.waiting.visible = this._cancelGameBtn.visible = true;
      }
      
      private function quickJoinBtnHandler(param1:MouseEvent) : void
      {
         GameInSocketOut.sendCancelWait();
         this._startGameBtn.visible = true;
         this.waiting.visible = this._cancelGameBtn.visible = false;
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this._responseHandle);
         this._startGameBtn.removeEventListener("click",this.createRoomBtnHandler);
         this._cancelGameBtn.removeEventListener("click",this.quickJoinBtnHandler);
         GameManager.Instance.removeEventListener("StartLoading",this.__startLoading);
      }
      
      protected function _responseHandle(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
               this.dispose();
               break;
            case 1:
               this.dispose();
               break;
            case 4:
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         GameInSocketOut.sendCancelWait();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this.boss1);
         this.boss1 = null;
         ObjectUtils.disposeObject(this.boss2);
         this.boss2 = null;
         ObjectUtils.disposeObject(this.boss3);
         this.boss3 = null;
         ObjectUtils.disposeObject(this.boss4);
         this.boss4 = null;
         ObjectUtils.disposeObject(this.boss5);
         this.boss5 = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         ObjectUtils.disposeObject(this._startGameBtn);
         this._startGameBtn = null;
         ObjectUtils.disposeObject(this._cancelGameBtn);
         this._cancelGameBtn = null;
         ObjectUtils.disposeObject(this.waiting);
         this.waiting = null;
         ObjectUtils.disposeObject(this.timeTxt);
         this.timeTxt = null;
         DefendislandControl.instance._frame = null;
      }
   }
}

