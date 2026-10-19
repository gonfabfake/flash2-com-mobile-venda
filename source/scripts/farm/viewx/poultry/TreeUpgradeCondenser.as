package farm.viewx.poultry
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PkgEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmEvent;
   import farm.FarmModelController;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TreeUpgradeCondenser extends Sprite implements Disposeable
   {
      
      private var _title:Bitmap;
      
      private var _loadingBg:Bitmap;
      
      private var _loading:MovieClip;
      
      private var _exp:FilterFrameText;
      
      private var _checkBox:SelectedCheckButton;
      
      private var _condenserBtn:BaseButton;
      
      private var _currentExp:Number;
      
      private var _totalExp:Number;
      
      private var _frameIndex:int;
      
      private var _isUpgrade:Boolean;
      
      public function TreeUpgradeCondenser()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._title = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.condenserTitle");
         addChild(this._title);
         this._loadingBg = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.loadingBg");
         addChild(this._loadingBg);
         this._loading = ComponentFactory.Instance.creat("asset.farm.treeUpgrade.consenderLoading");
         PositionUtils.setPos(this._loading,"farm.treeUpgrade.consenderLoading");
         addChild(this._loading);
         this._loading.stop();
         this._exp = ComponentFactory.Instance.creatComponentByStylename("farm.tree.treeExpTxt");
         addChild(this._exp);
         this._checkBox = ComponentFactory.Instance.creatComponentByStylename("farm.tree.checkBox");
         PositionUtils.setPos(this._checkBox,"farm.treeUpgrade.condenserView.checkBoxPos");
         addChild(this._checkBox);
         this._checkBox.text = LanguageMgr.GetTranslation("farm.tree.upgradeCondenser.checkBoxText");
         this._checkBox.selected = true;
         this._condenserBtn = ComponentFactory.Instance.creatComponentByStylename("farm.treeUpgradeView.condenserBtn");
         this._condenserBtn.tipData = LanguageMgr.GetTranslation("farm.tree.upgradeCondenserBtn.tipsText");
         addChild(this._condenserBtn);
      }
      
      private function initEvent() : void
      {
         this._condenserBtn.addEventListener("click",this.__onCondenserBtnClick);
         SocketManager.Instance.addEventListener(PkgEvent.format(81,25),this.__onCondenser);
      }
      
      protected function __onCondenser(param1:PkgEvent) : void
      {
         if(this._checkBox.selected || this._frameIndex == 105)
         {
            this.setLoadingFrame();
         }
         else
         {
            this._loading.gotoAndStop(this._frameIndex);
            this._loading.loading.gotoAndStop(this._frameIndex);
            SocketManager.Instance.out.initFarmTree();
         }
      }
      
      public function setExp(param1:Number, param2:Number, param3:int) : void
      {
         this._currentExp = param1;
         this._totalExp = param2;
         this._exp.text = this._currentExp + "/" + this._totalExp;
         this._condenserBtn.enable = true;
         this.frameIndex = this._currentExp * 105 / this._totalExp;
         this._loading.gotoAndStop(this._frameIndex);
         this._loading.loading.gotoAndStop(this._frameIndex);
      }
      
      private function setLoadingFrame() : void
      {
         FarmModelController.instance.dispatchEvent(new FarmEvent("farmPoultry_upgrading",[true]));
         this._loading.gotoAndPlay(this._loading.currentFrame);
         this._loading.loading.gotoAndPlay(this._loading.currentFrame);
         addEventListener("enterFrame",this.__onEnterFrame);
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         if(this._frameIndex < 105 && this._loading.currentFrame >= this._frameIndex || this._loading.currentFrame == this._loading.totalFrames)
         {
            FarmModelController.instance.dispatchEvent(new FarmEvent("farmPoultry_upgrading",[false]));
            if(this._frameIndex < 105 && this._loading.currentFrame >= this._frameIndex)
            {
               this._loading.gotoAndStop(this._frameIndex);
               this._loading.loading.gotoAndStop(this._frameIndex);
            }
            removeEventListener("enterFrame",this.__onEnterFrame);
            SocketManager.Instance.out.initFarmTree();
            if(this._isUpgrade)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.farmUpgrade.condenserUpgrade"));
            }
         }
      }
      
      protected function __onCondenserBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 1;
         var _loc3_:int = (this._totalExp - this._currentExp) / 10;
         var _loc4_:int = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(11957);
         if(_loc4_ > 0)
         {
            SoundManager.instance.playButtonSound();
            this._condenserBtn.enable = false;
            if(this._checkBox.selected)
            {
               _loc2_ = Math.min(_loc4_,_loc3_);
            }
            this.frameIndex = (this._currentExp + _loc2_ * 10) * 105 / this._totalExp;
            if(this._checkBox.selected && _loc4_ >= _loc3_)
            {
               this._isUpgrade = true;
               this.frameIndex = 105;
            }
            SocketManager.Instance.out.farmCondenser(_loc2_);
         }
      }
      
      private function set frameIndex(param1:int) : void
      {
         if(param1 == 0)
         {
            this._loading.visible = false;
            this._frameIndex = 1;
         }
         else
         {
            this._loading.visible = true;
            this._frameIndex = param1;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("enterFrame",this.__onEnterFrame);
         SocketManager.Instance.removeEventListener(PkgEvent.format(81,25),this.__onCondenser);
         if(Boolean(this._condenserBtn))
         {
            this._condenserBtn.removeEventListener("click",this.__onCondenserBtnClick);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._title))
         {
            this._title.bitmapData.dispose();
            this._title = null;
         }
         if(Boolean(this._loadingBg))
         {
            this._loadingBg.bitmapData.dispose();
            this._loadingBg = null;
         }
         if(Boolean(this._exp))
         {
            this._exp.dispose();
            this._exp = null;
         }
         if(Boolean(this._checkBox))
         {
            this._checkBox.dispose();
            this._checkBox = null;
         }
         if(Boolean(this._condenserBtn))
         {
            this._condenserBtn.dispose();
            this._condenserBtn = null;
         }
         if(Boolean(this._loading))
         {
            this._loading.gotoAndStop(1);
            ObjectUtils.disposeAllChildren(this._loading);
            this._loading = null;
         }
      }
   }
}

