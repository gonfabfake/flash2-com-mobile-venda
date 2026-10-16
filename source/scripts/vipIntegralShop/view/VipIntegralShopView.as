package vipIntegralShop.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import vipIntegralShop.VipIntegralShopController;
   
   public class VipIntegralShopView extends Frame
   {
      
      private static const MAXNUM:int = 4;
      
      private var _bg:Bitmap;
      
      private var _infoText:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _integralNum:FilterFrameText;
      
      private var _callText:FilterFrameText;
      
      private var _foreBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _shopCellList:Vector.<VipIntegralShopCell>;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      public function VipIntegralShopView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function initData() : void
      {
         var _loc1_:int = int(VipIntegralShopController.instance.goodsInfoList.length);
         this._totlePage = Math.ceil(_loc1_ / 4);
         this._currentPage = 1;
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.getVipIntegralShopLimit();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         titleText = LanguageMgr.GetTranslation("vipIntegralShopView.titleText");
         this._bg = ComponentFactory.Instance.creat("asset.vipIntegralShopView.viewBg");
         addToContent(this._bg);
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.infoText");
         this._infoText.text = LanguageMgr.GetTranslation("vipIntegralShopView.info.Text");
         addToContent(this._infoText);
         this._callText = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.call");
         this._callText.text = LanguageMgr.GetTranslation("vipIntegralShopView.callText");
         this._pageTxt = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.pageTxt");
         addToContent(this._pageTxt);
         this._foreBtn = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.foreBtn");
         addToContent(this._foreBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.nextBtn");
         addToContent(this._nextBtn);
         this._integralNum = ComponentFactory.Instance.creatComponentByStylename("vipIntegralShopView.integralNum");
         this._integralNum.text = PlayerManager.Instance.Self.VipIntegral.toString();
         addToContent(this._integralNum);
         this._shopCellList = new Vector.<VipIntegralShopCell>(4);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new VipIntegralShopCell();
            _loc2_.x = 16 + _loc1_ % 2 * (_loc2_.width + 3);
            _loc2_.y = 227 + int(_loc1_ / 2) * (_loc2_.height + 2);
            addToContent(_loc2_);
            this._shopCellList[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__frameEventHandler);
         this._foreBtn.addEventListener("click",this.__changePageHandler);
         this._nextBtn.addEventListener("click",this.__changePageHandler);
         PlayerManager.Instance.Self.addEventListener("propertychange",this.__onUpdatePlayerProperty);
      }
      
      protected function __onUpdatePlayerProperty(param1:PlayerPropertyEvent) : void
      {
         this._integralNum.text = PlayerManager.Instance.Self.VipIntegral.toString();
      }
      
      public function refreshView() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this._pageTxt.text = this._currentPage + "/" + this._totlePage;
         var _loc4_:int = (this._currentPage - 1) * 4;
         var _loc5_:int = int(VipIntegralShopController.instance.goodsInfoList.length);
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc3_ = _loc4_ + _loc2_;
            if(_loc3_ >= _loc5_)
            {
               this._shopCellList[_loc2_].visible = false;
            }
            else
            {
               this._shopCellList[_loc2_].visible = true;
               _loc1_ = VipIntegralShopController.instance.goodsInfoList[_loc3_];
               this._shopCellList[_loc2_].refreshShow(_loc1_);
            }
            _loc2_++;
         }
      }
      
      private function __changePageHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:SimpleBitmapButton = param1.currentTarget as SimpleBitmapButton;
         switch(_loc2_)
         {
            case this._foreBtn:
               if(this._currentPage <= 1)
               {
                  this._currentPage = this._totlePage;
               }
               else
               {
                  --this._currentPage;
               }
               break;
            case this._nextBtn:
               if(this._currentPage >= this._totlePage)
               {
                  this._currentPage = 1;
               }
               else
               {
                  ++this._currentPage;
               }
         }
         this.sendPkg();
      }
      
      protected function __onAlertResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener("response",this.__onAlertResponse);
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
               SoundManager.instance.playButtonSound();
               _loc2_.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__frameEventHandler);
         this._foreBtn.removeEventListener("click",this.__changePageHandler);
         this._nextBtn.removeEventListener("click",this.__changePageHandler);
         PlayerManager.Instance.Self.removeEventListener("propertychange",this.__onUpdatePlayerProperty);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               VipIntegralShopController.instance.hide();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(Boolean(this._bg))
         {
            this._bg.bitmapData.dispose();
            this._bg = null;
         }
         if(Boolean(this._infoText))
         {
            this._infoText.dispose();
            this._infoText = null;
         }
         if(Boolean(this._callText))
         {
            this._callText.dispose();
            this._callText = null;
         }
         if(Boolean(this._pageTxt))
         {
            this._pageTxt.dispose();
            this._pageTxt = null;
         }
         if(Boolean(this._integralNum))
         {
            this._integralNum.dispose();
            this._integralNum = null;
         }
         if(Boolean(this._nextBtn))
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(Boolean(this._foreBtn))
         {
            this._foreBtn.dispose();
            this._foreBtn = null;
         }
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
   }
}

