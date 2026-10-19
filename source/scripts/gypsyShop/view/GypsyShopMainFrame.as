package gypsyShop.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import gypsyShop.ctrl.GypsyShopManager;
   import gypsyShop.model.GypsyShopModel;
   import gypsyShop.ui.GypsyItemCell;
   
   public class GypsyShopMainFrame extends Frame implements Disposeable
   {
      
      private var _model:GypsyShopModel;
      
      private var _bg:Bitmap;
      
      private var _rareTitle:Bitmap;
      
      private var _coolShiningMCList:Vector.<MovieClip>;
      
      private var _rareList:Vector.<BagCell>;
      
      private var _itemList:Vector.<GypsyItemCell>;
      
      private var _rmbTicketsIcon:Bitmap;
      
      private var _honourIcon:Bitmap;
      
      private var _ticketsBG:Bitmap;
      
      private var _honourBG:Bitmap;
      
      private var _rmbTicketsText:FilterFrameText;
      
      private var _honourText:FilterFrameText;
      
      private var _refreshTimeDetails:FilterFrameText;
      
      private var _refreshBtn:BaseButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      public function GypsyShopMainFrame()
      {
         super();
      }
      
      public function setModel(param1:GypsyShopModel) : void
      {
         this._model = param1;
      }
      
      override protected function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("gypsy.frame.bg");
         addToContent(this._bg);
         this._rareTitle = ComponentFactory.Instance.creatBitmap("gypsy.frame.rare.title");
         addToContent(this._rareTitle);
         this._ticketsBG = ComponentFactory.Instance.creatBitmap("gypsy.money.bg");
         PositionUtils.setPos(this._ticketsBG,"gypsy.pt.rmb");
         addToContent(this._ticketsBG);
         this._rmbTicketsIcon = ComponentFactory.Instance.creatBitmap("gypsy.icon.dianjuanWithBG");
         addToContent(this._rmbTicketsIcon);
         this._rmbTicketsText = ComponentFactory.Instance.creat("gypsy.textfield.rmbTicketRemain");
         addToContent(this._rmbTicketsText);
         this._rmbTicketsText.text = "0";
         this._honourBG = ComponentFactory.Instance.creatBitmap("gypsy.money.bg");
         PositionUtils.setPos(this._honourBG,"gypsy.pt.honour.bg");
         addToContent(this._honourBG);
         this._honourIcon = ComponentFactory.Instance.creatBitmap("gypsy.icon.honor");
         PositionUtils.setPos(this._honourIcon,"gypsy.pt.honour.icon");
         addToContent(this._honourIcon);
         this._honourText = ComponentFactory.Instance.creat("gypsy.textfield.honourRemain");
         addToContent(this._honourText);
         this._honourText.text = "0";
         this._refreshTimeDetails = ComponentFactory.Instance.creat("gypsy.textfield.timeRefreshDetail");
         addToContent(this._refreshTimeDetails);
         this._refreshTimeDetails.text = LanguageMgr.GetTranslation("gypsy.refresh.details","18:00");
         this._refreshBtn = ComponentFactory.Instance.creat("gypsy.refreshBtn");
         addToContent(this._refreshBtn);
         this._itemList = new Vector.<GypsyItemCell>();
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            this._itemList[_loc1_] = new GypsyItemCell();
            this._itemList[_loc1_].x = 27 + 218 * (_loc1_ % 2);
            this._itemList[_loc1_].y = 148 + 86 * int(_loc1_ / 2);
            addToContent(this._itemList[_loc1_]);
            _loc1_++;
         }
         this._helpBtn = ComponentFactory.Instance.creat("gypsy.btn.helpBtn");
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.onHelp);
         addToContent(this._helpBtn);
         this._rareList = new Vector.<BagCell>();
         this._coolShiningMCList = new Vector.<MovieClip>();
         this._refreshBtn.addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(FrameEvent.RESPONSE,this._response);
         this.updateWealth();
      }
      
      protected function onHelp(param1:MouseEvent) : void
      {
         var _loc2_:GypsyHelpFrame = ComponentFactory.Instance.creat("gypsy.helpFrame");
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.frameEvent);
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ObjectUtils.disposeObject(param1.currentTarget);
      }
      
      public function updateNewItemList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = Math.min(8,this._model.itemDataList.length);
         _loc1_ = 0;
         while(_loc1_ < this._itemList.length)
         {
            this._itemList[_loc1_].clear();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._itemList[_loc1_].updateCell(this._model.itemDataList[_loc1_]);
            _loc1_++;
         }
         this.updateWealth();
      }
      
      public function updateBuyResult() : void
      {
         var _loc1_:GypsyItemCell = null;
         var _loc2_:int = int(this._model.buyResult.id);
         for each(_loc1_ in this._itemList)
         {
            if(_loc1_.id == _loc2_)
            {
               _loc1_.updateBuyButtonState(this._model.buyResult.canBuy);
            }
         }
         this.updateWealth();
      }
      
      public function updateRareItemsList() : void
      {
         var _loc1_:int = 0;
         var _loc3_:MovieClip = null;
         _loc1_ = 0;
         var _loc2_:BagCell = null;
         _loc3_ = null;
         _loc1_ = 0;
         while(_loc1_ < this._rareList.length)
         {
            _loc2_ = this._rareList[_loc1_];
            ObjectUtils.disposeObject(_loc2_);
            _loc1_++;
         }
         this._rareList = new Vector.<BagCell>();
         var _loc4_:int = int(this._model.listRareItemTempleteIDs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            this._rareList[_loc1_] = new BagCell(0,ItemManager.Instance.getTemplateById(this._model.listRareItemTempleteIDs[_loc1_]));
            this._rareList[_loc1_].x = 76 + 56 * (3 - _loc4_ * 0.5) + 56 * _loc1_;
            this._rareList[_loc1_].y = 85;
            this._rareList[_loc1_].setContentSize(45,45);
            addToContent(this._rareList[_loc1_]);
            _loc3_ = ComponentFactory.Instance.creat("asset.core.icon.coolShining");
            _loc3_.mouseChildren = false;
            _loc3_.mouseEnabled = false;
            _loc3_.x = this._rareList[_loc1_].x - 1;
            _loc3_.y = this._rareList[_loc1_].y - 1;
            _loc3_.alpha = 0.5;
            addToContent(_loc3_);
            this._coolShiningMCList.push(_loc3_);
            _loc1_++;
         }
         this.updateWealth();
      }
      
      private function updateWealth() : void
      {
         this._rmbTicketsText.text = PlayerManager.Instance.Self.Money.toString();
         this._honourText.text = PlayerManager.Instance.Self.myHonor.toString();
      }
      
      private function _response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         SoundManager.instance.play("008");
         GypsyShopManager.getInstance().hideMainFrame();
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         if(param1.target == this._refreshBtn)
         {
            GypsyShopManager.getInstance().refreshBtnClicked();
         }
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.onHelp);
         this._refreshBtn.removeEventListener(MouseEvent.CLICK,this.onClick);
         ObjectUtils.disposeObject(this._refreshBtn);
         this._refreshBtn = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._rareTitle);
         this._rareTitle = null;
         ObjectUtils.disposeObject(this._rmbTicketsIcon);
         this._rmbTicketsIcon = null;
         ObjectUtils.disposeObject(this._rmbTicketsText);
         this._rmbTicketsText = null;
         ObjectUtils.disposeObject(this._honourBG);
         this._honourBG = null;
         ObjectUtils.disposeObject(this._honourIcon);
         this._honourIcon = null;
         ObjectUtils.disposeObject(this._honourText);
         this._honourText = null;
         ObjectUtils.disposeObject(this._refreshTimeDetails);
         this._refreshTimeDetails = null;
         ObjectUtils.disposeObject(this._helpBtn);
         this._helpBtn = null;
         this._itemList.length = 0;
         this._itemList = null;
         this._rareList.length = 0;
         this._rareList = null;
         var _loc1_:int = int(this._coolShiningMCList.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this._coolShiningMCList[_loc2_].stop();
            _loc2_++;
         }
         this._coolShiningMCList.length = 0;
         this._coolShiningMCList = null;
         this._model = null;
         super.dispose();
      }
   }
}

