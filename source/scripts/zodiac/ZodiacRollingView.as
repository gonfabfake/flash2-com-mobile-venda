package zodiac
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ZodiacRollingView extends Sprite implements Disposeable
   {
      
      private var _rollingBtn:MovieClip;
      
      private var btndarkArr:Array;
      
      private var btnShineArr:Array;
      
      private var currentBtn:Image;
      
      private var paopaoArr:Array;
      
      private var finalMovie:MovieClip;
      
      private var _last:int;
      
      private var rollrace:int;
      
      private var rollcount:int;
      
      private var indexpaopao:int;
      
      private var endpaopao:int;
      
      public function ZodiacRollingView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function rolling(param1:int) : void
      {
         ZodiacManager.instance.inRolling = true;
         this.endpaopao = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.paopaoArr.length)
         {
            addChild(this.paopaoArr[_loc2_]);
            this.paopaoArr[_loc2_].visible = false;
            _loc2_++;
         }
         this.rollrace = 70;
         this.rollcount = 1;
         this.indexpaopao = 0;
         setTimeout(this.startrolling,this.rollrace);
      }
      
      private function startrolling() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = this.paopaoArr[this.indexpaopao] as MovieClip;
         _loc2_.visible = true;
         _loc2_.gotoAndPlay(1);
         this.indexpaopao = this.indexpaopao == 11 ? int(0) : int(++this.indexpaopao);
         this.rollcount = this.indexpaopao == 0 ? int(++this.rollcount) : int(this.rollcount);
         if(this.rollcount == 2)
         {
            this.rollrace -= 4;
         }
         else if(this.rollcount >= 6)
         {
            this.rollrace += 4;
         }
         if(this.rollcount < 8)
         {
            setTimeout(this.startrolling,this.rollrace);
         }
         else if(this.indexpaopao == this.endpaopao || this.endpaopao == 12 && this.indexpaopao == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.paopaoArr.length)
            {
               removeChild(this.paopaoArr[_loc1_]);
               _loc1_++;
            }
            this.rollingComplete(this.endpaopao);
         }
         else
         {
            setTimeout(this.startrolling,this.rollrace);
         }
      }
      
      private function rolltest() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.paopaoArr.length)
         {
            addChild(this.paopaoArr[_loc1_]);
            this.paopaoArr[_loc1_].visible = false;
            _loc1_++;
         }
         this.rollrace = 70;
         this.rollcount = 1;
         this.indexpaopao = 0;
         setTimeout(this.startrolling,this.rollrace);
      }
      
      private function initView() : void
      {
         var _loc4_:Image = null;
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:Bitmap = null;
         _loc4_ = null;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 1;
         while(_loc7_ <= 12)
         {
            _loc2_ = ComponentFactory.Instance.creatBitmap("zodiac.rollingview.line");
            addChild(_loc2_);
            PositionUtils.setPos(_loc2_,"zodiac.rollingview.backline.pos" + _loc7_);
            _loc2_.rotation = (_loc7_ - 1) * 30;
            _loc3_ = ComponentFactory.Instance.creatBitmap("zodiac.rollingview.ball.bg");
            addChild(_loc3_);
            PositionUtils.setPos(_loc3_,"zodiac.rollingview.ballgb.pos" + _loc7_);
            _loc7_++;
         }
         if(this.btndarkArr == null)
         {
            this.btndarkArr = [];
         }
         _loc1_ = 1;
         while(_loc1_ <= 12)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("zodiac.rollingview.darkbtnball" + _loc1_);
            addChild(_loc4_);
            _loc4_.buttonMode = true;
            _loc4_.mouseEnabled = false;
            _loc4_.addEventListener(MouseEvent.CLICK,this.__ballClickHandler);
            PositionUtils.setPos(_loc4_,"zodiac.rollingview.darkbtnball.pos" + _loc1_);
            this.btndarkArr.push(_loc4_);
            _loc1_++;
         }
         if(this.btnShineArr == null)
         {
            this.btnShineArr = [];
         }
         var _loc8_:int = 0;
         while(_loc8_ < 12)
         {
            _loc5_ = ClassUtils.CreatInstance("zodiac.rollingview.notcomplete.shine");
            PositionUtils.setPos(_loc5_,"zodiac.rollingview.btnshine.pos" + _loc8_);
            this.btnShineArr.push(_loc5_);
            _loc8_++;
         }
         if(this.paopaoArr == null)
         {
            this.paopaoArr = [];
         }
         var _loc9_:int = 0;
         while(_loc9_ < 12)
         {
            _loc6_ = ClassUtils.CreatInstance("zodiac.rollingview.ball.shine");
            PositionUtils.setPos(_loc6_,"zodiac.rollingview.paopao.pos" + _loc9_);
            this.paopaoArr.push(_loc6_);
            _loc9_++;
         }
         this.finalMovie = ClassUtils.CreatInstance("zodiac.rollingview.finalstop");
         addChild(this.finalMovie);
         this.hideFinalMovie();
         this._rollingBtn = ClassUtils.CreatInstance("zodiac.rollingview.rolling.btn");
         this._rollingBtn.buttonMode = true;
         this._rollingBtn.mouseEnabled = true;
         PositionUtils.setPos(this._rollingBtn,"zodiac.rollingview.rollingbtn.pos");
         addChild(this._rollingBtn);
         this.update();
         this.refreshBallState();
         this.refreshShineState();
      }
      
      private function initEvent() : void
      {
         this._rollingBtn.addEventListener(MouseEvent.ROLL_OVER,this.__rolloverHandler);
         this._rollingBtn.addEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         this._rollingBtn.addEventListener(MouseEvent.CLICK,this.__rollingHandler);
      }
      
      private function removeEvent() : void
      {
         this._rollingBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__rolloverHandler);
         this._rollingBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         this._rollingBtn.removeEventListener(MouseEvent.CLICK,this.__rollingHandler);
      }
      
      private function __rolloverHandler(param1:MouseEvent) : void
      {
         this._rollingBtn.gotoAndPlay("move");
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         this._rollingBtn.gotoAndPlay(1);
      }
      
      private function __rollingHandler(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         this._rollingBtn.gotoAndPlay("down");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         if(this._last > 0)
         {
            SocketManager.Instance.out.zodiacRolling();
            this.hideFinalMovie();
            this.removeCurrentPaopao();
         }
         else
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("zodiac.mainview.addCountstip",ServerConfigManager.instance.zodiacAddPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
      }
      
      private function __onAlertResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money >= ServerConfigManager.instance.zodiacAddPrice)
            {
               SocketManager.Instance.out.zodiacAddCounts();
            }
            else
            {
               LeavePageManager.showFillFrame();
            }
         }
         _loc2_.dispose();
      }
      
      private function __ballClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         var _loc2_:Image = param1.currentTarget as Image;
         var _loc3_:int = 0;
         while(_loc3_ < this.btndarkArr.length)
         {
            if(this.btndarkArr[_loc3_] == _loc2_)
            {
               ZodiacManager.instance.setCurrentIndexView(_loc3_ + 1);
            }
            _loc3_++;
         }
         if(this.finalMovie.visible == true)
         {
            this.refreshBallState();
            this.refreshShineState();
         }
         this.hideFinalMovie();
         this.removeCurrentPaopao();
      }
      
      public function update() : void
      {
         this._last = ZodiacManager.instance.maxCounts - ZodiacManager.instance.finshedCounts;
         if(ZodiacManager.instance.questCounts == 12)
         {
            this._rollingBtn.buttonMode = false;
            this._rollingBtn.mouseEnabled = false;
            this._rollingBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._rollingBtn.buttonMode = true;
            this._rollingBtn.mouseEnabled = true;
            this._rollingBtn.filters = [];
         }
         this.refreshShineState();
      }
      
      private function refreshBallState() : void
      {
         var _loc1_:Image = null;
         var _loc2_:Array = ZodiacManager.instance.questArr;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = this.btndarkArr[_loc3_] as Image;
            if(_loc2_[_loc3_] != 0)
            {
               _loc1_.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               _loc1_.mouseEnabled = true;
            }
            else
            {
               _loc1_.filters = [];
               _loc1_.mouseEnabled = false;
            }
            _loc3_++;
         }
      }
      
      private function refreshShineState() : void
      {
         var _loc1_:QuestInfo = null;
         var _loc2_:int = 0;
         var _loc3_:Array = ZodiacManager.instance.questArr;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] != 0)
            {
               _loc1_ = TaskManager.getQuestByID(_loc3_[_loc4_]);
               if((ZodiacManager.instance.awardRecord >> _loc4_ + 1 & 1) == 1)
               {
                  if(Boolean(this.btnShineArr[_loc4_].parent))
                  {
                     this.btnShineArr[_loc4_].parent.removeChild(this.btnShineArr[_loc4_]);
                  }
               }
               else if(_loc1_.isAchieved)
               {
                  if(Boolean(this.btnShineArr[_loc4_].parent))
                  {
                     this.btnShineArr[_loc4_].parent.removeChild(this.btnShineArr[_loc4_]);
                  }
               }
               else if(!(this.endpaopao == _loc4_ + 1 && ZodiacManager.instance.inRolling == true))
               {
                  _loc2_ = 0;
                  _loc2_ = this.getChildIndex(this.finalMovie);
                  addChildAt(this.btnShineArr[_loc4_],_loc2_);
               }
            }
            else if(Boolean(this.btnShineArr[_loc4_].parent))
            {
               this.btnShineArr[_loc4_].parent.removeChild(this.btnShineArr[_loc4_]);
            }
            _loc4_++;
         }
      }
      
      private function hideFinalMovie() : void
      {
         this.finalMovie.visible = false;
      }
      
      private function showFinalMovie(param1:int) : void
      {
         PositionUtils.setPos(this.finalMovie,"zodiac.rollingview.finalmc.pos" + param1);
         this.finalMovie.rotation = 300 - 30 * param1;
         this.finalMovie.visible = true;
         this.finalMovie.gotoAndPlay(1);
      }
      
      private function addCurrentPaopao(param1:int) : void
      {
         this.currentBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.rollingview.lightbtnball" + param1);
         var _loc2_:int = this.getChildIndex(this.finalMovie);
         addChildAt(this.currentBtn,_loc2_);
         PositionUtils.setPos(this.currentBtn,"zodiac.rollingview.darkbtnball.pos" + param1);
      }
      
      private function removeCurrentPaopao() : void
      {
         if(this.currentBtn != null)
         {
            removeChild(this.currentBtn);
            this.currentBtn = null;
         }
      }
      
      private function rollingComplete(param1:int) : void
      {
         this.removeCurrentPaopao();
         this.addCurrentPaopao(param1);
         this.showFinalMovie(param1);
         this.refreshBallState();
         this.refreshShineState();
         ZodiacManager.instance.inRolling = false;
         ZodiacManager.instance.setCurrentIndexView(param1);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.rollingcompletemsg"));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

