package witchBlessing.view
{
   import bagAndInfo.cell.BagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import witchBlessing.WitchBlessingManager;
   import witchBlessing.data.WitchBlessingPackageInfo;
   
   public class WitchBlessingRightView extends Sprite implements Disposeable
   {
      
      private var blessingLV:int = 1;
      
      private var _rightViewMidBg:Bitmap;
      
      private var _rightViewSmallBg:Bitmap;
      
      private var _noBlessing:Bitmap;
      
      private var _AwardsView:Sprite = new Sprite();
      
      private var _awardsTxt:FilterFrameText;
      
      private var _awardsTxt1:FilterFrameText;
      
      private var _awardsTxt2:FilterFrameText;
      
      private var _nextTimeTxt:FilterFrameText;
      
      private var propertyArr1:Array = ["defense","agility","recovery","hp"];
      
      private var propertyArr2:Array = ["attact","luck","damage","hp"];
      
      private var property1:Array;
      
      private var property2:Array;
      
      private var _getAwardsBtn:BaseButton;
      
      private var _getDoubleAwardsBtn:BaseButton;
      
      private var cdTime:int = 0;
      
      private var _timer:Timer;
      
      private var canGetAwardsFlag:Boolean = false;
      
      private var awardsNum:int;
      
      private var allNum:int;
      
      private var doubleMoney:int = 0;
      
      private var sec:int;
      
      private var min:int;
      
      private var hour:int;
      
      private var str:String;
      
      private var doubleAlert:BaseAlerFrame;
      
      public function WitchBlessingRightView(param1:int, param2:int = 0, param3:int = 0)
      {
         var _loc4_:Array = ServerConfigManager.instance.localWitchBlessAddProperty;
         this.property1 = [_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]];
         this.property2 = [_loc4_[4],_loc4_[5],_loc4_[6],_loc4_[7]];
         this.blessingLV = param1;
         this.allNum = param2;
         this.doubleMoney = param3;
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:FilterFrameText = null;
         var _loc5_:int = 0;
         addChild(this._AwardsView);
         PositionUtils.setPos(this._AwardsView,"witchBlessing.AwardsViewPos");
         this._getAwardsBtn = ComponentFactory.Instance.creat("witchBlessing.getAwardsBtn");
         this._getAwardsBtn.enable = false;
         this._getDoubleAwardsBtn = ComponentFactory.Instance.creat("witchBlessing.getDoubleAwardsBtn");
         this._getDoubleAwardsBtn.enable = false;
         this._noBlessing = ComponentFactory.Instance.creat("asset.witchBlessing.noBlessing");
         addChild(this._getAwardsBtn);
         addChild(this._getDoubleAwardsBtn);
         this._nextTimeTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.nextTimeTxt");
         this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.nextTimeTxt");
         addChild(this._nextTimeTxt);
         this._awardsTxt1 = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.awardsTxt");
         this._awardsTxt1.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt1",3,3);
         addChild(this._awardsTxt1);
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.__timer);
         if(this.blessingLV > 1)
         {
            this._rightViewMidBg = ComponentFactory.Instance.creat("asset.witchBlessing.rightViewMidBg");
            addChild(this._rightViewMidBg);
            this._awardsTxt = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.awardsTxt");
            this._awardsTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt2");
            addChild(this._awardsTxt);
            PositionUtils.setPos(this._awardsTxt,"witchBlessing.AwardsTxt2Pos");
            _loc2_ = [];
            _loc3_ = 1;
            while(_loc3_ < 5)
            {
               _loc4_ = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.propertyTxt");
               PositionUtils.setPos(_loc4_,"witchBlessing.propertyTxtPos");
               _loc2_.push(_loc4_);
               _loc4_.text = LanguageMgr.GetTranslation("tank.view.personalinfoII." + this.propertyArr1[_loc3_ - 1]) + "+" + this.property1[_loc3_ - 1];
               if(_loc3_ != 1)
               {
                  _loc4_.x += _loc1_;
               }
               _loc1_ += _loc4_.width + 20;
               addChild(_loc4_);
               _loc3_++;
            }
            if(this.blessingLV > 2)
            {
               this._rightViewSmallBg = ComponentFactory.Instance.creat("asset.witchBlessing.rightViewSmallBg");
               addChild(this._rightViewSmallBg);
               this._awardsTxt2 = ComponentFactory.Instance.creatComponentByStylename("witchBlessing.awardsTxt");
               this._awardsTxt2.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt3");
               addChild(this._awardsTxt2);
               PositionUtils.setPos(this._awardsTxt2,"witchBlessing.AwardsTxt3Pos");
               _loc1_ = 0;
               _loc5_ = 1;
               while(_loc5_ < 5)
               {
                  _loc2_[_loc5_ - 1].text = LanguageMgr.GetTranslation("tank.view.personalinfoII." + this.propertyArr2[_loc5_ - 1]) + "+" + this.property2[_loc5_ - 1];
                  PositionUtils.setPos(_loc2_[_loc5_ - 1],"witchBlessing.propertyTxtPos");
                  if(_loc3_ != 1)
                  {
                     _loc2_[_loc5_ - 1].x += _loc1_;
                  }
                  _loc1_ += _loc2_[_loc5_ - 1].width + 20;
                  _loc5_++;
               }
            }
         }
         this.initAwards();
      }
      
      private function initEvent() : void
      {
         this._getAwardsBtn.addEventListener(MouseEvent.CLICK,this.getAwardsFunc);
         this._getDoubleAwardsBtn.addEventListener(MouseEvent.CLICK,this.getDoubleAwardsFunc);
      }
      
      private function getAwardsFunc(param1:MouseEvent) : void
      {
         SocketManager.Instance.out.sendWitchGetAwards(this.blessingLV);
      }
      
      private function getDoubleAwardsFunc(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(PlayerManager.Instance.Self.Money < this.doubleMoney)
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("witchBlessing.view.haveNoMoney",this.doubleMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         }
         else
         {
            if(this.doubleAlert != null)
            {
               return;
            }
            this.doubleAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("witchBlessing.view.doubleGetAwardsMoney",this.doubleMoney),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this.doubleAlert.addEventListener(FrameEvent.RESPONSE,this.__getDoubleAwards);
         }
      }
      
      private function __getDoubleAwards(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.doubleAlert.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         this.doubleAlert.disposeChildren = true;
         this.doubleAlert.dispose();
         this.doubleAlert = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendWitchGetAwards(this.blessingLV,true);
         }
      }
      
      private function __onNoMoneyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onNoMoneyResponse);
         _loc2_.disposeChildren = true;
         _loc2_.dispose();
         _loc2_ = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         this.timeCountingFunc();
         this.cdTime -= 1000;
      }
      
      private function timeCountingFunc() : void
      {
         if(this.cdTime <= 0)
         {
            this._timer.stop();
            if(this.awardsNum > 0 && this.blessingLV <= WitchBlessingManager.Instance.frame.nowLv)
            {
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.canGetAwardsTxt");
               this.isCanGetAwards(true);
               this.cannotBlessing(true);
            }
            else
            {
               if(this.blessingLV > WitchBlessingManager.Instance.frame.nowLv)
               {
                  this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.notEnoughLv");
                  this.cannotBlessing(false);
               }
               else
               {
                  this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.noAwardsTxt");
                  this.cannotBlessing(true);
               }
               this.isCanGetAwards(false);
            }
         }
         else
         {
            if(this.awardsNum == 0)
            {
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.noAwardsTxt");
               if(this.blessingLV > WitchBlessingManager.Instance.frame.nowLv)
               {
                  this.cannotBlessing(false);
               }
               else
               {
                  this.cannotBlessing(true);
               }
            }
            else if(this.blessingLV > WitchBlessingManager.Instance.frame.nowLv)
            {
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.notEnoughLv");
               this.cannotBlessing(false);
            }
            else
            {
               this.sec = int(this.cdTime / 1000);
               this._nextTimeTxt.text = LanguageMgr.GetTranslation("witchBlessing.view.nextTimeTxt",this.transSecond(this.sec));
               this.cannotBlessing(true);
            }
            this.isCanGetAwards(false);
         }
      }
      
      public function cannotBlessing(param1:Boolean) : void
      {
         this._noBlessing.visible = !param1;
      }
      
      private function isCanGetAwards(param1:Boolean) : void
      {
         if(this.canGetAwardsFlag == param1)
         {
            return;
         }
         if(param1)
         {
            this._getAwardsBtn.enable = true;
            this._getDoubleAwardsBtn.enable = true;
         }
         else
         {
            this._getAwardsBtn.enable = false;
            this._getDoubleAwardsBtn.enable = false;
         }
         this.canGetAwardsFlag = param1;
      }
      
      private function transSecond(param1:Number) : String
      {
         var _loc2_:int = Math.floor(param1 / 3600);
         var _loc3_:int = Math.floor((param1 - _loc2_ * 3600) / 60);
         var _loc4_:int = param1 - _loc2_ * 3600 - _loc3_ * 60;
         if(_loc2_ > 0)
         {
            this.str = _loc2_ + "" + LanguageMgr.GetTranslation("hour") + _loc3_ + LanguageMgr.GetTranslation("minute");
         }
         else if(_loc3_ > 0)
         {
            this.str = _loc3_ + "" + LanguageMgr.GetTranslation("minute") + _loc4_ + "" + LanguageMgr.GetTranslation("second");
         }
         else
         {
            this.str = _loc4_ + "" + LanguageMgr.GetTranslation("second");
         }
         return this.str;
      }
      
      public function flushCDTime(param1:int) : void
      {
         this.cdTime = param1;
         if(this.cdTime > 0 && !this._timer.running)
         {
            this._timer.start();
         }
         this.timeCountingFunc();
      }
      
      public function flushGetAwardsTimes(param1:int) : void
      {
         this.awardsNum = this.allNum - param1;
         this._awardsTxt1.text = LanguageMgr.GetTranslation("witchBlessing.view.awardsTxt1",this.allNum,this.awardsNum);
      }
      
      private function initAwards() : void
      {
         var _loc1_:WitchBlessingPackageInfo = null;
         var _loc2_:ItemTemplateInfo = null;
         var _loc3_:Bitmap = null;
         var _loc4_:BagCell = null;
         var _loc5_:Array = WitchBlessingManager.Instance.model.itemInfoList;
         var _loc6_:int = 340 / (_loc5_[this.blessingLV - 1].length - 1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_[this.blessingLV - 1].length)
         {
            _loc1_ = _loc5_[this.blessingLV - 1][_loc7_] as WitchBlessingPackageInfo;
            _loc2_ = ItemManager.Instance.getTemplateById(_loc1_.TemplateID) as ItemTemplateInfo;
            _loc3_ = ComponentFactory.Instance.creatBitmap("asset.witchBlessing.sugerBox");
            _loc4_ = new BagCell(_loc7_,_loc2_,false,_loc3_,false);
            _loc4_.setContentSize(62,62);
            _loc4_.PicPos = new Point(3,3);
            _loc4_.setCount(_loc1_.Count);
            _loc4_.x = _loc7_ * _loc6_;
            this._AwardsView.addChild(_loc4_);
            _loc7_++;
         }
      }
      
      public function dispose() : void
      {
         this._timer.stop();
         this._timer = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this._rightViewMidBg))
         {
            this._rightViewMidBg = null;
         }
         if(Boolean(this._rightViewSmallBg))
         {
            this._rightViewSmallBg = null;
         }
         if(Boolean(this._noBlessing))
         {
            this._noBlessing = null;
         }
         if(Boolean(this._AwardsView))
         {
            this._AwardsView = null;
         }
         if(Boolean(this._awardsTxt))
         {
            this._awardsTxt = null;
         }
         if(Boolean(this._awardsTxt1))
         {
            this._awardsTxt1 = null;
         }
         if(Boolean(this._awardsTxt2))
         {
            this._awardsTxt2 = null;
         }
         if(Boolean(this._nextTimeTxt))
         {
            this._nextTimeTxt = null;
         }
      }
   }
}

