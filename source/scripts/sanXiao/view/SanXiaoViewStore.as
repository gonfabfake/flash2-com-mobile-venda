package sanXiao.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.pageSelector.PageSelector;
   import ddt.view.pageSelector.PageSelectorFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import road7th.utils.DateUtils;
   import sanXiao.SanXiaoManager;
   
   public class SanXiaoViewStore extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _itemList:Vector.<SXStoreItem>;
      
      private var _pageSelecter:PageSelector;
      
      private var _timeRemainText:FilterFrameText;
      
      private var _crystalRemainText:FilterFrameText;
      
      private var _crystalIconBmp:Bitmap;
      
      public function SanXiaoViewStore()
      {
         super();
         this.init();
         this.addEvents();
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         this._bg = ComponentFactory.Instance.creatBitmap("ast.sanxiao.bg.store");
         addChild(this._bg);
         this._itemList = new Vector.<SXStoreItem>();
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            this._itemList[_loc1_] = new SXStoreItem();
            this._itemList[_loc1_].x = 216 + 256 * (_loc1_ % 2);
            this._itemList[_loc1_].y = 60 + int(_loc1_ / 2) * 94;
            addChild(this._itemList[_loc1_]);
            _loc1_++;
         }
         this._pageSelecter = PageSelectorFactory.getInstance().getPageSelector("normal");
         this._pageSelecter.itemDataArr = SanXiaoManager.getInstance().itemDataList;
         this._pageSelecter.itemList = this._itemList;
         PositionUtils.setPos(this._pageSelecter,"sanxiao.storePageNumber.pt");
         addChild(this._pageSelecter);
         this._timeRemainText = ComponentFactory.Instance.creat("sanxiao.storeText.Txt");
         PositionUtils.setPos(this._timeRemainText,"sanxiao.storeTimeRemain.pt");
         addChild(this._timeRemainText);
         this._timeRemainText.text = "00:00:00";
         this._crystalRemainText = ComponentFactory.Instance.creat("sanxiao.storeText.Txt");
         PositionUtils.setPos(this._crystalRemainText,"sanxiao.storeCrystalRemain.pt");
         addChild(this._crystalRemainText);
         this._crystalRemainText.text = "0";
         this._crystalIconBmp = ComponentFactory.Instance.creatBitmap("ast.sanxiao.crystal");
         PositionUtils.setPos(this._crystalIconBmp,"sanxiao.storeCrystalIcon.pt");
         addChild(this._crystalIconBmp);
      }
      
      private function addEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      public function update() : void
      {
         this._timeRemainText.text = DateUtils.dateFormat(SanXiaoManager.getInstance().endTime);
         this._crystalRemainText.text = SanXiaoManager.getInstance().crystalNum.toString();
         this._pageSelecter.itemDataArr = SanXiaoManager.getInstance().itemDataList;
         this._pageSelecter.itemList = this._itemList;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         if(Boolean(this._itemList))
         {
            this._itemList.length = 0;
            this._itemList = null;
         }
         if(Boolean(this._pageSelecter))
         {
            ObjectUtils.disposeObject(this._pageSelecter);
            this._pageSelecter = null;
         }
         this._timeRemainText = null;
         this._crystalRemainText = null;
         this._crystalIconBmp = null;
      }
   }
}

