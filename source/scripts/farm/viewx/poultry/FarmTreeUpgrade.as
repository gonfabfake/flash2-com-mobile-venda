package farm.viewx.poultry
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.HelpFrameUtils;
   import ddt.utils.PositionUtils;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   
   public class FarmTreeUpgrade extends BaseAlerFrame
   {
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _bg:Bitmap;
      
      private var _bg2:Bitmap;
      
      private var _titleImage:MutipleImage;
      
      private var _loveBg:BaseButton;
      
      private var _loveNum:FilterFrameText;
      
      private var _callBtn:BaseButton;
      
      private var _levelNum:int;
      
      private var _control:DisplayObject;
      
      private var _upgradingFlag:Boolean;
      
      public function FarmTreeUpgrade()
      {
         super();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.initFarmTree();
      }
      
      private function initView() : void
      {
         escEnable = true;
         this._helpBtn = HelpFrameUtils.Instance.simpleHelpButton(this,"farm.treeUpgradeView.helpBtn",null,LanguageMgr.GetTranslation("ddt.consortia.bossFrame.helpTitle"),"farm.treeUpgrade.helpInfo",408,488) as SimpleBitmapButton;
         this._titleImage = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.title");
         addToContent(this._titleImage);
         this._bg = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.Bg");
         addToContent(this._bg);
         this._bg2 = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.Bg2");
         addToContent(this._bg2);
         this._loveBg = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.loveNumBg");
         this._loveBg.tipData = LanguageMgr.GetTranslation("farm.farmUpgrade.loveNumTipsTxt");
         addToContent(this._loveBg);
         this._loveNum = ComponentFactory.Instance.creatComponentByStylename("farm.tree.loveNumTxt");
         addToContent(this._loveNum);
         this._callBtn = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.callBtn");
         this._callBtn.tipData = LanguageMgr.GetTranslation("farm.farmUpgrade.callBtnTxt");
         addToContent(this._callBtn);
         if(FarmModelController.instance.model.PoultryState > 0)
         {
            this._callBtn.enable = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__closeFarm);
         this._callBtn.addEventListener("click",this.__onCallBtnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FARM_UPGRADEINITTREE,this.__onInitData);
         FarmModelController.instance.addEventListener("farmPoultry_setCallBtn",this.__onSetCallBtnEnable);
         FarmModelController.instance.addEventListener("farmPoultry_upgrading",this.__onUpgrading);
      }
      
      protected function __onUpgrading(param1:FarmEvent) : void
      {
         this._upgradingFlag = param1.obj[0];
      }
      
      protected function __onSetCallBtnEnable(param1:FarmEvent) : void
      {
         this._callBtn.enable = false;
      }
      
      protected function __onInitData(param1:CrazyTankSocketEvent) : void
      {
         var _loc3_:PackageIn = null;
         var _loc2_:int = 0;
         this._levelNum = (_loc3_ = param1.pkg).readInt();
         var _loc4_:int = _loc3_.readInt();
         var _loc5_:int = _loc3_.readInt() - FarmModelController.instance.model.farmPoultryInfo[this._levelNum].Exp;
         var _loc6_:int = _loc3_.readInt();
         var _loc7_:int = int(FarmModelController.instance.model.farmPoultryInfo[this._levelNum].CostExp);
         FarmModelController.instance.model.FarmTreeLevel = this._levelNum;
         FarmModelController.instance.dispatchEvent(new FarmEvent("farmTree_updateTreeLevel"));
         this._loveNum.text = _loc4_.toString();
         if(this._levelNum > 0 && this._levelNum % 10 == 0 && _loc5_ == 0 && _loc6_ < _loc7_)
         {
            if(Boolean(this._control))
            {
               if(this._control is TreeUpgradeWater)
               {
                  TreeUpgradeWater(this._control).dispose();
                  this._control = new TreeUpgradeCondenser();
               }
            }
            else
            {
               this._control = new TreeUpgradeCondenser();
            }
            TreeUpgradeCondenser(this._control).setExp(_loc6_,_loc7_,this._levelNum);
         }
         else
         {
            if(Boolean(this._control))
            {
               if(this._control is TreeUpgradeCondenser)
               {
                  TreeUpgradeCondenser(this._control).dispose();
                  this._control = new TreeUpgradeWater();
               }
            }
            else
            {
               this._control = new TreeUpgradeWater();
            }
            _loc2_ = 0;
            if(this._levelNum >= FarmModelController.MAXLEVEL)
            {
               _loc5_ = _loc2_ = 1;
            }
            else
            {
               _loc2_ = FarmModelController.instance.model.farmPoultryInfo[this._levelNum + 1].Exp - FarmModelController.instance.model.farmPoultryInfo[this._levelNum].Exp;
            }
            TreeUpgradeWater(this._control).setLevelNum(this._levelNum);
            TreeUpgradeWater(this._control).setExp(_loc5_,_loc2_);
            TreeUpgradeWater(this._control).setLoveNum(_loc4_);
         }
         PositionUtils.setPos(this._control,"asset.farm.controlPos");
         addToContent(this._control);
      }
      
      protected function __onCallBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         var _loc2_:CallPoultryView = ComponentFactory.Instance.creatComponentByStylename("farm.poultry.callView");
         LayerManager.Instance.addToLayer(_loc2_,2,true,1);
      }
      
      protected function __onHelpBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         HelpFrameUtils.Instance.simpleHelpFrame(LanguageMgr.GetTranslation("ddt.consortia.bossFrame.helpTitle"),ComponentFactory.Instance.creatCustomObject("farm.treeUpgrade.helpInfo"),408,488);
      }
      
      private function __closeFarm(param1:FrameEvent) : void
      {
         if(!this._upgradingFlag)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__closeFarm);
         this._callBtn.removeEventListener("click",this.__onCallBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.FARM_UPGRADEINITTREE,this.__onInitData);
         FarmModelController.instance.removeEventListener("farmPoultry_setCallBtn",this.__onSetCallBtnEnable);
         FarmModelController.instance.removeEventListener("farmPoultry_upgrading",this.__onUpgrading);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._bg2))
         {
            this._bg2.bitmapData.dispose();
            this._bg2 = null;
         }
         if(Boolean(this._helpBtn))
         {
            ObjectUtils.disposeObject(this._helpBtn);
            this._helpBtn = null;
         }
         if(Boolean(this._loveBg))
         {
            this._loveBg.dispose();
            this._loveBg = null;
         }
         if(Boolean(this._titleImage))
         {
            this._titleImage.dispose();
            this._titleImage = null;
         }
         if(Boolean(this._loveNum))
         {
            this._loveNum.dispose();
            this._loveNum = null;
         }
         if(Boolean(this._callBtn))
         {
            this._callBtn.dispose();
            this._callBtn = null;
         }
         super.dispose();
      }
   }
}

