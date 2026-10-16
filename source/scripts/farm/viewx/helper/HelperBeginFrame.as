package farm.viewx.helper
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   
   public class HelperBeginFrame extends BaseAlerFrame
   {
      
      private var _explainText:FilterFrameText;
      
      private var _explainText2:FilterFrameText;
      
      private var _explainText3:FilterFrameText;
      
      private var _bgTitle:DisplayObject;
      
      public var modelType:int;
      
      private var _seedID:int;
      
      private var _seedTime:int;
      
      private var _needCount:int;
      
      private var _haveCount:int;
      
      private var _getCount:int;
      
      private var _needMoney:int;
      
      private var _moneyType:int;
      
      private var _moneyTypeText:String;
      
      private var _ifNeed:Boolean;
      
      private var _isDDTMoney:Boolean = false;
      
      private var _showPayMoneyBG:Image;
      
      public function HelperBeginFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.escEnable = true;
         _loc1_.title = LanguageMgr.GetTranslation("ddt.farm.beginFrame.title");
         _loc1_.bottomGap = 37;
         _loc1_.buttonGape = 65;
         _loc1_.customPos = ComponentFactory.Instance.creat("farm.confirmHelperBeginAlertBtnPos");
         this.info = _loc1_;
         height = 250;
         this._needCount = 0;
         this._ifNeed = false;
         this.intView();
         this.intEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,3,true,1);
         if(this.modelType == -1)
         {
            if(this._needCount > 0)
            {
               this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText1",this._needCount,this._needMoney);
               this._explainText.text += this._moneyTypeText;
               this._explainText3.x = 57;
               this._explainText3.y = 75;
               this._explainText2.x = 105;
               this._explainText2.y = 50;
               PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos2");
               _submitButton.y = 133;
               _cancelButton.y = 133;
               addToContent(this._explainText2);
            }
            else
            {
               this._explainText3.x = 57;
               this._explainText3.y = 75;
               _submitButton.y = 133;
               _cancelButton.y = 133;
            }
            return;
         }
         if(this._needCount > 0)
         {
            this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText1",this._needCount,this._needMoney);
            this._explainText.text += this._moneyTypeText;
            this._explainText2.x = 57;
            this._explainText2.y = 69;
            this._explainText3.x = 13;
            this._explainText3.y = 99;
            PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos2");
            _submitButton.y = 133;
            _cancelButton.y = 133;
            addToContent(this._explainText2);
         }
         else
         {
            _submitButton.y = 133;
            _cancelButton.y = 133;
         }
      }
      
      private function intView() : void
      {
         this._bgTitle = ComponentFactory.Instance.creat("assets.farm.titleSmall");
         PositionUtils.setPos(this._bgTitle,"farm.HelperBeginTitlePos");
         addChild(this._bgTitle);
         this._explainText = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText");
         this._explainText.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText");
         PositionUtils.setPos(this._explainText,"farm.helperBeginExplainPos1");
         addToContent(this._explainText);
         this._explainText2 = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText2");
         this._explainText2.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText2");
         this._explainText3 = ComponentFactory.Instance.creatComponentByStylename("assets.farm.beginFrame.explainText3");
         this._explainText3.text = LanguageMgr.GetTranslation("ddt.farm.beginFrame.expText3");
         addToContent(this._explainText3);
      }
      
      private function intEvent() : void
      {
         addEventListener("response",this.__framePesponse);
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               removeEventListener("response",this.__framePesponse);
               this.dispose();
               break;
            case 2:
            case 3:
               this.submit();
               break;
            case 4:
               removeEventListener("response",this.__framePesponse);
               this.dispose();
         }
      }
      
      private function submit() : void
      {
         if(this._needCount > 0)
         {
            switch(int(this.modelType) - -9)
            {
               case 0:
                  if(PlayerManager.Instance.Self.BandMoney < this._needMoney)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.tip1"));
                     return;
                  }
                  break;
               case 1:
                  if(PlayerManager.Instance.Self.Money < this._needMoney)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("treasureHunting.tip1"));
                     return;
                  }
                  break;
               case 7:
                  if(PlayerManager.Instance.Self.Money < this._needMoney)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.madelLack"));
                     return;
                  }
            }
         }
         var _loc1_:Array = [];
         _loc1_.push(true);
         _loc1_.push(this._seedID);
         _loc1_.push(this._seedTime);
         _loc1_.push(this._haveCount);
         _loc1_.push(this._getCount);
         _loc1_.push(this._moneyType);
         _loc1_.push(this._needMoney);
         _loc1_.push(_isBand);
         SocketManager.Instance.out.sendBeginHelper(_loc1_);
         this.dispose();
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener("response",this.__poorManResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == 3 || param1.responseCode == 2)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function removeEvent() : void
      {
         addEventListener("response",this.__framePesponse);
      }
      
      private function removeView() : void
      {
         if(Boolean(this._explainText))
         {
            ObjectUtils.disposeObject(this._explainText);
         }
         this._explainText = null;
      }
      
      public function get seedID() : int
      {
         return this._seedID;
      }
      
      public function set seedID(param1:int) : void
      {
         this._seedID = param1;
      }
      
      public function get seedTime() : int
      {
         return this._seedTime;
      }
      
      public function set seedTime(param1:int) : void
      {
         this._seedTime = param1;
      }
      
      public function get needCount() : int
      {
         return this._needCount;
      }
      
      public function set needCount(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._needCount = param1;
         var _loc4_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(88);
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc3_ = _loc4_[_loc2_].TemplateID;
            if(this._seedID == _loc3_)
            {
               this._needMoney = this._needCount * _loc4_[_loc2_].AValue1;
               this._moneyType = _loc4_[_loc2_].APrice1;
               if(this._needCount * _loc4_[_loc2_].getItemPrice(1).moneyValue > 0)
               {
                  this._isDDTMoney = false;
                  this._moneyTypeText = LanguageMgr.GetTranslation("money");
               }
            }
            _loc2_++;
         }
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function set haveCount(param1:int) : void
      {
         this._haveCount = param1;
      }
      
      public function get getCount() : int
      {
         return this._getCount;
      }
      
      public function set getCount(param1:int) : void
      {
         this._getCount = param1;
      }
      
      override public function dispose() : void
      {
         this.removeView();
         this.removeEvent();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
   }
}

