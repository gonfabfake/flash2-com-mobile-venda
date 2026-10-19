package cloudBuyLottery.view
{
   import cloudBuyLottery.CloudBuyLotteryManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class TheWinningLog extends Frame
   {
      
      private var SHOP_ITEM_NUM:int = 9;
      
      private var itemList:Array;
      
      private var _list:VBox;
      
      private var _panel:ScrollPanel;
      
      private var _logArr:Array;
      
      private var _bg:Bitmap;
      
      public function TheWinningLog()
      {
         super();
         this.initView();
         this.loadList();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:WinningLogListItem = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.IndividualLottery.dituBG");
         addToContent(this._bg);
         _titleText = LanguageMgr.GetTranslation("TheWinningLog.titleText");
         this._list = ComponentFactory.Instance.creatComponentByStylename("TheWinningLog.goodsListBox");
         this._list.spacing = 0;
         this._panel = ComponentFactory.Instance.creatComponentByStylename("TheWinningLog.right.scrollpanel");
         this._panel.x = 0;
         this._panel.y = -4;
         this._panel.width = 210;
         this._panel.height = 465;
         this.itemList = new Array();
         this._logArr = CloudBuyLotteryManager.Instance.logArr;
         if(this._logArr != null)
         {
            this.SHOP_ITEM_NUM = this._logArr.length;
            if(this.SHOP_ITEM_NUM <= 0)
            {
               return;
            }
            _loc1_ = 0;
            while(_loc1_ < this.SHOP_ITEM_NUM)
            {
               _loc2_ = ComponentFactory.Instance.creatCustomObject("TheWinningLog.WinningLogListItem");
               this.itemList.push(_loc2_);
               this.itemList[_loc1_].initView(this._logArr[_loc1_].nickName,_loc1_);
               this.itemList[_loc1_].y = (this.itemList[_loc1_].height + 1) * _loc1_;
               this._list.addChild(this.itemList[_loc1_]);
               _loc1_++;
            }
         }
         this._panel.setView(this._list);
         addToContent(this._panel);
         this._panel.invalidateViewport();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function loadList() : void
      {
         this.setList(CloudBuyLotteryManager.Instance.model.myGiftData);
      }
      
      private function setList(param1:Vector.<WinningLogItemInfo>) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.clearitems();
         var _loc2_:int = 0;
         while(_loc2_ < this.SHOP_ITEM_NUM)
         {
            if(!param1)
            {
               break;
            }
            if(_loc2_ < param1.length && Boolean(param1[_loc2_]))
            {
               this.itemList[_loc2_].shopItemInfo = param1[_loc2_];
               this.itemList[_loc2_].itemID = param1[_loc2_].TemplateID;
            }
            _loc2_++;
         }
      }
      
      private function clearitems() : void
      {
         var _loc1_:int = 0;
         if(this.itemList[_loc1_] == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.SHOP_ITEM_NUM)
         {
            this.itemList[_loc1_].shopItemInfo = null;
            _loc1_++;
         }
      }
      
      private function disposeItems() : void
      {
         var _loc1_:int = 0;
         if(Boolean(this.itemList))
         {
            _loc1_ = 0;
            while(_loc1_ < this.itemList.length)
            {
               ObjectUtils.disposeObject(this.itemList[_loc1_]);
               this.itemList[_loc1_] = null;
               _loc1_++;
            }
            this.itemList = null;
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.disposeItems();
         CloudBuyLotteryFrame.logFrameFlag = false;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}

