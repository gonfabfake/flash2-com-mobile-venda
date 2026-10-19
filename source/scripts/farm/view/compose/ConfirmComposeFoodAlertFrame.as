package farm.view.compose
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.control.FarmComposeHouseController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
   public class ConfirmComposeFoodAlertFrame extends Frame
   {
      
      private var _bg3:Scale9CornerImage;
      
      private var _promptTxt:FilterFrameText;
      
      private var _showTxtBG:Image;
      
      private var _preBtn:BaseButton;
      
      private var _nextBtn:BaseButton;
      
      private var _hBox:HBox;
      
      private var _cells:Vector.<ShopItemCell>;
      
      private var _cellInfos:Array;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      private var _currentImg:Bitmap;
      
      public function ConfirmComposeFoodAlertFrame()
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
         this._bg3 = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeFoodAlertFrame.bg3");
         addToContent(this._bg3);
         this._showTxtBG = ComponentFactory.Instance.creatComponentByStylename("farm.confirmComposeFoodAlertFrame.showTxtBG");
         addToContent(this._showTxtBG);
         this._promptTxt = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.promptTxt");
         this._promptTxt.text = LanguageMgr.GetTranslation("ddt.farms.confirmComposeFoodAlertFrame.promptText");
         addToContent(this._promptTxt);
         escEnable = true;
         this._preBtn = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.btnPrePage1");
         addToContent(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.btnNextPage1");
         addToContent(this._nextBtn);
         this._cells = new Vector.<ShopItemCell>();
         this._hBox = ComponentFactory.Instance.creat("farm.confirmComposeFoodAlertFrame.cropBox");
         addToContent(this._hBox);
         _loc1_ = 0;
         while(_loc1_ < 3)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("farmHouse.btnSelectHouseCompose3");
            _loc3_ = new Sprite();
            _loc3_.graphics.beginFill(16777215,0);
            _loc3_.graphics.drawRect(0,0,50,50);
            _loc3_.graphics.endFill();
            _loc4_ = new ShopItemCell(_loc3_);
            _loc4_.cellSize = 50;
            _loc2_.addEventListener("click",this.__selectValue);
            _loc2_.mouseChildren = true;
            _loc2_.addChild(_loc4_);
            PositionUtils.setPos(_loc4_,"farm.confirmComposeFoodAlertFrame.cellPos");
            this._hBox.addChild(_loc2_);
            this._cells.push(_loc4_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener("response",this.__framePesponse);
         this._preBtn.addEventListener("click",this.__onPageBtnClick);
         this._nextBtn.addEventListener("click",this.__onPageBtnClick);
      }
      
      private function __onPageBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._preBtn:
               this._currentPage = this._currentPage - 1 < 0 ? 0 : int(Number(this._currentPage - 1));
               break;
            case this._nextBtn:
               this._currentPage = this._currentPage + 1 > this._totlePage ? this._totlePage : int(this._currentPage + 1);
         }
         this.upCells(this._currentPage);
      }
      
      private function initData() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this._cellInfos = [];
         for each(_loc3_ in FarmComposeHouseController.instance().composeHouseModel.foodComposeList)
         {
            _loc1_ = int(_loc3_[0].FoodID);
            _loc2_ = ItemManager.Instance.getTemplateById(_loc1_);
            this._cellInfos.push(_loc2_);
         }
         this._totlePage = this._cellInfos.length % 3 == 0 ? int(this._cellInfos.length / 3 - 1) : int(Number(this._cellInfos.length / 3));
         this.upCells(0);
      }
      
      private function upCells(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         this._currentPage = param1;
         var _loc3_:int = param1 * 3;
         _loc2_ = 0;
         while(_loc2_ < this._cells.length)
         {
            if(Boolean(this._cellInfos[_loc2_ + _loc3_]))
            {
               this._cells[_loc2_].info = this._cellInfos[_loc2_ + _loc3_];
            }
            _loc2_++;
         }
      }
      
      private function __selectValue(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         SoundManager.instance.play("008");
         var _loc5_:BaseButton = param1.currentTarget as BaseButton;
         _loc3_ = 0;
         while(_loc3_ < _loc5_.numChildren)
         {
            _loc4_ = _loc5_.getChildAt(_loc3_);
            if(_loc4_ is ShopItemCell)
            {
               _loc2_ = _loc4_.info;
               break;
            }
            _loc3_++;
         }
         if(Boolean(_loc2_))
         {
            dispatchEvent(new SelectComposeItemEvent("selectFood",_loc2_));
         }
      }
      
      protected function __framePesponse(param1:FrameEvent) : void
      {
         removeEventListener("response",this.__framePesponse);
         SoundManager.instance.play("008");
         switch(int(param1.responseCode))
         {
            case 0:
            case 1:
               this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener("response",this.__framePesponse);
         this._preBtn.removeEventListener("click",this.__onPageBtnClick);
         this._nextBtn.removeEventListener("click",this.__onPageBtnClick);
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = null;
         this.removeEvent();
         if(Boolean(this._hBox))
         {
            _loc1_ = 0;
            while(_loc1_ < this._hBox.numChildren)
            {
               _loc2_ = this._hBox.getChildAt(_loc1_);
               if(_loc2_ is BaseButton)
               {
                  _loc2_.removeEventListener("click",this.__onPageBtnClick);
               }
               _loc1_++;
            }
            this._hBox.disposeAllChildren();
            this._hBox.dispose();
            this._hBox = null;
         }
         if(Boolean(this._promptTxt))
         {
            ObjectUtils.disposeObject(this._promptTxt);
         }
         this._promptTxt = null;
         if(Boolean(this._bg3))
         {
            ObjectUtils.disposeObject(this._bg3);
         }
         this._bg3 = null;
         if(Boolean(this._showTxtBG))
         {
            ObjectUtils.disposeObject(this._showTxtBG);
         }
         this._showTxtBG = null;
         super.dispose();
      }
   }
}

